for (( i=1 ; i <= 10; i++ ))
do
 echo $i
 if [ $i -eq 1 ]
 then
   echo "no header"
 fi
done
