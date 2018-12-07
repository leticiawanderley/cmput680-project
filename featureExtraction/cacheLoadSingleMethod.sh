#-----------
# sample use: ./cacheLoadSingleMethod.sh methodprefixtohaveAOT'd application
#-----------

#first make sure there is no cache for this test
java -Xshareclasses:name=Hello,destroy

#then setup cache with only the AOT code for the single method in it
java -Xshareclasses:name=Hello,verboseAOT -Xaot:loadLimit=$1,count=1 $2

#verify contents of this cache
java -Xshareclasses:name=Hello,printStats
