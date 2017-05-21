#!/bin/bash
totalruns=$1
threads=$2
fibo=$3

callservice() {
  totalruns=$1
  threadid=$3
  fibonum=$2
  host=10.0.0.124
  port=8080
  onesecond=1000
  #echo "args 1=$1 2=$2 3=$3"
  if [ $threadid -eq 1 ]
  then
    echo "run_id,thread_id,json,elapsed_time,sleep_time_ms,fibonum"
  fi
  if [ $fibonum == "\"\"" ] || [ $fibonum == "\"0\"" ]
  then
    fibonum=`echo "${RANDOM}0"`
    #echo "Random fibo $fibonum"
  fi
  for (( i=1 ; i <= $totalruns; i++ ))
  do
    json={"\"number\"":$fibonum}
    time1=( $(($(date +%s%N)/1000000)) )
    curl -X POST -H "Content-Type: application/json" http://$host:$port/fibo/fibonacci -d $json >/dev/null 2>/dev/null
    time2=( $(($(date +%s%N)/1000000)) )
    elapsedtime=`expr $time2 - $time1`
    sleeptime=`echo $onesecond - $elapsedtime | bc -l`
    sleeptimems=`echo $sleeptime/$onesecond | bc -l`
    echo "$i,$threadid,$json,$elapsedtime,$sleeptimems,$fibonum"
    if (( $sleeptime > 0 ))
    then
      sleep $sleeptimems
    fi
  done
}
export -f callservice

runsperthread=`echo $totalruns/$threads | bc -l`
runsperthread=${runsperthread%.*}
echo "Setting up test: runsperthread=$runsperthread threads=$threads totalruns=$totalruns fibonum=$fibo"
for (( i=1 ; i <= $threads ; i ++))
do
  arpt+=($runsperthread)
done
afibo="\"$fibo\""
parallel --no-notice -j $threads -k callservice {1} {2} {"#"} ::: "${arpt[@]}" ::: "${afibo[@]}"
