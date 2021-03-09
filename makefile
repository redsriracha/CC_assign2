MASTER=10.56.0.92
SLAVE=10.56.3.30

ASSIGN=CC_assign2

PYTHON=python3

default: hadoop

# Test locally using python3
test: NYPD_Complaint_Data_Current_YTD.csv hw2-mapper.py hw2-reducer.py
	cat NYPD_Complaint_Data_Current_YTD.csv | $(PYTHON) hw2-mapper.py | sort | $(PYTHON) hw2-reducer.py > test_part-00000

# Run on Hadoop cluster using python3
hadoop: hw2-mapper.py hw2-reducer.py
	$(HADOOP_PREFIX)/bin/hadoop jar $(HADOOP_PREFIX)/contrib/streaming/hadoop-streaming-*.jar \
		-input /hw2-input \
		-output /hw2-output \
		-file hw2-mapper.py \
		-mapper hw2-mapper.py \
		-file hw2-reducer.py \
		-reducer hw2-reducer.py \
		-cmdenv LC_CTYPE=en_GB.UTF-8
	rm -rf part-00*
	$(HADOOP_PREFIX)/bin/hadoop fs -get /hw2-output/part-00000 .

hadoop_combiner: hw2-mapper.py hw2-combiner.py hw2-reducer.py
	$(HADOOP_PREFIX)/bin/hadoop jar $(HADOOP_PREFIX)/contrib/streaming/hadoop-streaming-*.jar \
		-input /hw2-input \
		-output /hw2-output \
		-file hw2-mapper.py \
		-mapper hw2-mapper.py \
		-file hw2-reducer.py \
		-reducer hw2-reducer.py \
		-file hw2-combiner.py \
		-combiner hw2-combiner.py \
		-cmdenv LC_CTYPE=en_GB.UTF-8
	rm -rf part-00*
	$(HADOOP_PREFIX)/bin/hadoop fs -get /hw2-output/part-00000 .

diff: test hadoop
	diff -w part-00000 test_part-00000

diff_combiner: test hadoop_combiner
	diff -w part-00000 test_part-00000

update_code:
	cp -v $(ASSIGN)/*.py .

update_hadoop:
	scp $(HADOOP_PREFIX)/conf/*-site.xml $(SLAVE):$(HADOOP_PREFIX)/conf
	scp $(HADOOP_PREFIX)/conf/hadoop-env.sh $(SLAVE):$(HADOOP_PREFIX)/conf

jps:
	jps
	ssh $(SLAVE) jps

rmr_input:
	$(HADOOP_PREFIX)/bin/hadoop fs -rmr /hw2-input

rmr_output:
	$(HADOOP_PREFIX)/bin/hadoop fs -rmr /hw2-output

start_all:
	$(HADOOP_PREFIX)/bin/start-all.sh

stop_all:
	$(HADOOP_PREFIX)/bin/stop-all.sh

format:
	$(HADOOP_PREFIX)/bin/hadoop namenode -format

inputs:
	wget -nc http://cs.utsa.edu/~plama/CS4843/NYPD_Complaint_Data_Current_YTD.csv
	$(HADOOP_PREFIX)/bin/hadoop fs -put NYPD_Complaint_Data_Current_YTD.csv /hw2-input
	$(HADOOP_PREFIX)/bin/hadoop fs -ls /hw2-input
