./manage.sh url http://localhost:8080/employees -m get
./manage.sh verbose 1 -m get
./manage.sh header Content-type:application/json -m get

./manage.sh param ../param_samples/id.txt -m get

echo ""
./manage.sh showconfig get
echo ""
./manage.sh run get
