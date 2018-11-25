#!/bin/bash
java_path=$1
benchmark_path=$2
output_file=$3
aot=""
if [ "$4" = "aot" ]; then
  aot="-Xshareclasses:nonpersistent"
fi
benchmarks="$($java_path -jar $benchmark_path -l)"
blist=(`echo ${benchmarks}`)
for i in ${blist[@]};
do 
	echo $i >> $output_file;
	$($java_path -Xshareclasses:destroyAll);
	for j in `seq 0 10`;
	do
		time=$({ time $($java_path $aot -jar $benchmark_path $i &> /dev/null) ; } 2>&1);
		echo 'time: ' $time;
		echo $time >> $output_file;
	done
done
