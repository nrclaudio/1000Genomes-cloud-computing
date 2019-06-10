from pyspark.sql import SparkSession
from operator import add

# New API
spark_session = SparkSession\
    .builder\
    .master("spark://192.168.1.131:7077") \
    .appName("Project_1320")\
    .config("spark.executor.cores", 1)\
    .getOrCreate()

# Old API (RDD)
spark_context = spark_session.sparkContext
nucleotides = ('A', 'C', 'T', 'G', 'N')
kmer_length = 3
pair_1 = spark_context.textFile("hdfs://192.168.1.153:9000//team13/ERR181393_*.fastq.gz")
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
lsttpl = pair_3.collect()

with open('result.txt', 'w') as f:
    for tpl in lsttpl:
          f.write(' '.join(str(s) for s in tpl) + '\n')

import matplotlib.pyplot as plt

kmers = []
counts = []
for tpl in lsttpl:
    kmers.append(tpl[0])
    counts.append(int(tpl[1]))

plt.bar(kmers, counts, align = 'center')
end = time.perf_counter()
plt.xticks(kmers)
plt.grid()
plt.gca().margins(x=0)
plt.gcf().canvas.draw()
tl = plt.gca().get_xticklabels()
maxsize = max([t.get_window_extent().width for t in tl])
m = 0.2 # inch margin
s = maxsize/plt.gcf().dpi*N+2*m
margin = m/plt.gcf().get_size_inches()[0]
plt.gcf().subplots_adjust(left=margin, right=1.-margin)
plt.gcf().set_size_inches(s, plt.gcf().get_size_inches()[1])
plt.ylabel('Kmer count')
plt.xlabel('Kmers')
plt.title('Kmer count in the human genome. Elapsed time: %.1f [min]' % ((end-start)/60))
plt.savefig('kmercount_wholedataset.png')
spark_context.stop()
