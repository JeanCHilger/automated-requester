./requester.sh new ma
cd  ma
echo ""
./manage.sh url http://localhost:8080/employees -m post
./manage.sh verbose 1 -m post
./manage.sh header Content-type:application/json -m post

./manage.sh param ../param_samples/firstName.txt -m post
./manage.sh param ../param_samples/lastName.txt -m post
./manage.sh param ../param_samples/age.txt -m post
./manage.sh param ../param_samples/role.txt -m post
echo ""
./manage.sh showconfig post
echo ""
./manage.sh run post
cd ..
rm -rf ma
echo -e "\n'ma excluded.'"
