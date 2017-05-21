host=52.44.186.120
port=8084
len=100


json={"\"number\"":200000}
echo $json
curl -X POST -H "Content-Type: application/json" http://$host:$port/fibo/fibonacci -d $json
echo ""
exit

for (( i=20000 ; i > 19900; i-- ))
do
  json={"\"number\"":$i}
  echo $json
  curl -X POST -H "Content-Type: application/json" http://$host:$port/fibo/webresources/fibonacci -d $json
echo ""
done


