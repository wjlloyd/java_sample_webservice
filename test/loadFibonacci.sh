#! /bin/bash
host=184.72.101.134
port=8080

for (( i=1 ; i < 10; i++ ))
do

json={"\"number\"":$RANDOM}
echo $json
IFS=$'\n'
time=$( time ( curl -q -X POST -H "Content-Type: application/json" http://$host:$port/fibo/fibonacci -d $json >/dev/null 2>/dev/null ) 2>&1 )
echo "**************the time=$time" 
thetime=${time[0]}
realtime=(`echo $thetime | cut -d' ' -f 1`)
echo "realtime=${realtime[0]}"
newtime1=${realtime[0]}
newtime2=${realtime[0]}
echo "newtime1=${newtime1[0]}"
echo "newtime2=${newtime2[0]}"
echo "time text=${thetime[0]}"
unset IFS
echo ""

done


