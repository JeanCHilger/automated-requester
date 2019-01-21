./requester.sh new ma
cd ma
echo ""
./manage.sh url http://localhost:8080/employees -m delete
./manage.sh verbose 1 -m delete
./manage.sh header Content-type:application/json -m delete

./manage.sh param ../param_samples/id.txt -m delete

echo ""
./manage.sh showconfig delete
echo ""
./manage.sh run delete
cd ..
rm -rf ma
echo -e "\n'ma' excluded."
