#!/bin/bash
java_path=$1
benchmark_path=$2
output_file=$3
aot=""
is_aot=false
if [ "$4" = "aot" ]; then
  aot="-Xshareclasses:nonpersistent"
  is_aot=true
fi
benchmarks="$($java_path -jar $benchmark_path -l)"
blist=(`echo ${benchmarks}`)
for i in ${blist[@]};
do 
	echo $i >> $output_file;
	if $is_aot; then
		$($java_path -Xshareclasses:destroyAll);
	fi;
	for j in `seq 0 20`;
	do
		time=$({ time $($java_path $aot -jar $benchmark_path $i &> /dev/null) ; } 2>&1);
		echo 'time: ' $time;
		echo $time >> $output_file;
	done
done
