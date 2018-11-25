#!/bin/bash
java_path=$1
benchmark_path=$2
output_file=$3
benchmarks="$($java_path -jar $benchmark_path -l)"
blist=(`echo ${benchmarks}`)
for i in ${blist[@]};
do 
	echo $i >> $output_file;
	for j in `seq 0 10`;
	do
		time=$({ time $($java_path -jar $benchmark_path $i &> /dev/null) ; } 2>&1);
		echo 'time: ' $time;
		echo $time >> $output_file;
	done
done
