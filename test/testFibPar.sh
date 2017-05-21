#!/bin/bash
totalruns=$1
threads=$2

callservice() {
  totalruns=$1
  threadid=$2
  host=10.0.0.124
  port=8080
  onesecond=1000
  echo "totalruns=$1 threadid=$2"
  echo "run_id,thread_id,json,elapsed_time,sleep_time_ms"
  for (( i=1 ; i <= $totalruns; i++ ))
  do
    json={"\"number\"":50000}
    time1=( $(($(date +%s%N)/1000000)) )
    curl -X POST -H "Content-Type: application/json" http://$host:$port/fibo/fibonacci -d $json >/dev/null 2>/dev/null
    time2=( $(($(date +%s%N)/1000000)) )
    elapsedtime=`expr $time2 - $time1`
    sleeptime=`echo $onesecond - $elapsedtime | bc -l`
    sleeptimems=`echo $sleeptime/$onesecond | bc -l`
    echo "Run-$i,$threadid,$json,$elapsedtime,$sleeptimems"
    if (( $sleeptime > 0 ))
    then
      sleep $sleeptimems
    fi
  done
}
export -f callservice

runsperthread=`echo $totalruns/$threads | bc -l`
runsperthread=${runsperthread%.*}
echo "Setting up test: runsperthread=$runsperthread threads=$threads totalruns=$totalruns"
for (( i=1 ; i <= $threads ; i ++))
do
  arpt+=($runsperthread)
  threadid+=($i)
done
t=`seq 1 $threads`
echo ${t[@]}
echo ${arpt[@]}
parallel -j $threads -X -n 2 callservice {1} {2} ::: "${arpt[@]}" ::: "${t[@]}"

