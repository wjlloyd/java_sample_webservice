#!/bin/bash
host=10.0.0.124
port=8080
runs=$1
onesecond=1000

echo "run_id,json,elapsed_time,sleep_time_ms"
for (( i=1 ; i <= $runs; i++ ))
do
  json={"\"number\"":50000}
  time1=( $(($(date +%s%N)/1000000)) )
  curl -X POST -H "Content-Type: application/json" http://$host:$port/fibo/fibonacci -d $json >/dev/null 2>/dev/null
  time2=( $(($(date +%s%N)/1000000)) )
  elapsedtime=`expr $time2 - $time1`
  sleeptime=`echo $onesecond - $elapsedtime | bc -l`
  sleeptimems=`echo $sleeptime/$onesecond | bc -l`
  echo "Run-$i,$json,$elapsedtime,$sleeptimems"
  if (( $sleeptime > 0 ))
  then
    sleep $sleeptimems
  fi
done

