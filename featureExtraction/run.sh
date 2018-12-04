#-----------
# sample use: ./run.sh 
#-----------

echo "AOT for only $1 method"

#first make sure there is no cache for this test
java -Xshareclasses:name=Hello,destroy

#run once to make sure the example class gets in there, in case this limits whether the method could be in in
java -Xshareclasses:name=Hello Example

#then setup cache with only the AOT code for the single method in it
java -Xshareclasses:name=Hello,verbose -Xaot:count=1,log=compile.log,traceFull Example

#have tried to isolate/specify the method we want to AOT compile with the following:
#java -Xshareclasses:name=Hello,verbose -Xaot:limitFile=(methodfile.txt, 0, 1) Example
#java -Xshareclasses:name=Hello,verbose -Xaot:limitFile={*exampleMethod*} Example
#java -Xshareclasses:name=Hello,verbose -Xaot:limitFile={*exampleMethod*},count=0 Example

#where methodFile.txt only includes one line: exampleMethod
#one caveat that I have read is that the class must be in the cache before it can be AOT compiled? so thats why there is the no AOT set line in this

#-Xtrace:iprint=mt,methods=exampleMethod Example #this is an attempt to generate trace for just this method. since cannot compile this method, this is not currently useful

#verify contents of this cache
java -Xshareclasses:name=Hello,printStats=aot
