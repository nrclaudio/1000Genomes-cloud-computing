from pyspark.sql import SparkSession
from operator import add

# New API
spark_session = SparkSession\
    .builder\
    .master("spark://192.168.1.131:7077") \
    .appName("edvins_taskA")\
    .config("spark.executor.cores", 1)\
    .getOrCreate()

# Old API (RDD)
spark_context = spark_session.sparkContext

nucleotides = ('A', 'C', 'T', 'G', 'N')
kmer_length = 3

pair_1 = spark_context.textFile("hdfs://192.168.1.153:9000//team13/ERR181393_1.fastq.gz")

pair_2 = pair_1.zipWithIndex().filter(lambda x: x[1] > 0).map(lambda x: x[0])\
    .filter(lambda x: all(nt in nucleotides for nt in list(x)))


def kmer(line):
    counts = {}
    num_kmers = 100 - kmer_length + 1
    for i in range(num_kmers):
        kmer = line[i:i + kmer_length]
        if kmer not in counts:
            counts[kmer] = 0
        counts[kmer] += 1
    return counts.items()


from operator import add
pair_3 = pair_2.flatMap(kmer)\
    .reduceByKey(add)

import time

start = time.perf_counter()
pair_3.take(5)
end = time.perf_counter()
print("Elapsed time: %.1f [min]" % ((end - start) / 60))

spark_context.stop()
