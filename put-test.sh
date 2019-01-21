./requester.sh new ma
cd  ma
echo ""
./manage.sh url http://localhost:8080/employees -m put
./manage.sh verbose 1 -m put
./manage.sh header Content-type:application/json -m put

./manage.sh param ../param_samples/firstName.txt -m put
./manage.sh param ../param_samples/lastName.txt -m put
./manage.sh param ../param_samples/age.txt -m put
./manage.sh param ../param_samples/role.txt -m put
./manage.sh param ../param_samples/id.txt -m put
echo ""
./manage.sh showconfig put
echo ""
./manage.sh run put
cd ..
rm -rf ma
echo -e "\n'ma excluded.'"
