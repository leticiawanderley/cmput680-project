#-----------  
# sample use: ./testOneAOTCompile.sh application
#
# ex: ./testOneAOTCompile.sh Example
#
#
# only compiles methods that execute one time (at least once) - having too much difficulty specifying which using limitFile -Xaot option....
##-----------
 
#first make sure there is no cache for this test
java -Xshareclasses:name=Hello,destroy

#then setup cache with only the AOT code for the single method in it
java -Xshareclasses:name=Hello,verbose -Xaot:count=1,log=compile.log,traceFull $1


#wanted to specify which method with pattern match for method: -Xaot:limitFile={*exampleMethod*}

#verify contents of this cache
java -Xshareclasses:name=Hello,printStats=aot
