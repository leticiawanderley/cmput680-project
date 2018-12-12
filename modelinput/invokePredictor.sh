#-----------
#
# use: ./invokePredictor.sh configFile
#
# leaves a (background)waiting predictor process, multiple jvms can talk to
#------------

./predict $1 &>/dev/null &
