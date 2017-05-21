host=52.44.186.120
port=8084

json={"\"number\"":10}
echo $json
curl -X POST -H "Content-Type: application/json" http://$host:$port/fibo/fibonacci -d $json
echo ""


