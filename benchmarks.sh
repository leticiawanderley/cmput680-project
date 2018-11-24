#!/bin/bash
java_path=$1
benchmark_path=$2
benchmarks="$($java_path -jar $benchmark_path -l)"
blist=(`echo ${benchmarks}`)
for i in ${blist[@]};
do 
	echo $i;
	`time $($java_path -jar $benchmark_path $i &> /dev/null)`;
done
