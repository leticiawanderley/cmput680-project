#!/bin/bash
java_path=$1
benchmark_path=$2
output_file=$3
aot=""
is_aot=false

if [ "$4" = "aot" ]; then
  is_aot=true
fi
benchmarks="$($java_path -jar $benchmark_path -l)"
blist=(`echo ${benchmarks}`)
failing_benchmarks="batik tomcat tradebeans tradesoap"

declare -a benchmarks_list=()
for b in ${blist[@]};
	do
		is_not_failing=true;
		for failing_bechmark in ${failing_benchmarks[@]};
		do
			if [ "${b}" == "${failing_bechmark}" ]; then
				is_not_failing=false;
			fi;
	done
	if $is_not_failing; then
		benchmarks_list+=("${b}");
	fi;
done
	
for j in `seq 0 10`;
do	
	for i in ${benchmarks_list[@]};
	do 
		echo $i >> $output_file;
		if $is_aot; then
			aot=$($java_path -Xshareclasses:name=${i},verbose);
			echo $aot;
		fi;
		time=$({ time $($java_path $aot -jar $benchmark_path $i &> /dev/null) ; } 2>&1);
		echo 'time: ' $time;
		echo $time >> $output_file;
		sleep 1m;
	done
	sleep 12m;
done
