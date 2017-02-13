docker rm -f henadpostgres
docker rm -f henadgo
docker rm -f henadnginx
docker run --name henadpostgres -p 5432:5432 -e POSTGRES_USER=postgres -e POSTGRES_DB=tdde06 -d postgres
sleep 10;
docker cp schema.sql henadpostgres:schema.sql
docker exec henadpostgres psql -f schema.sql -U postgres -d tdde06
docker run -d -p 8080:8080 --name henadgo --link henadpostgres library/golang /bin/bash -c "git clone https://github.com/henziger/tdde06-ci.git && cd tdde06-ci && mkdir -p bin pkg src/main && python set_host.py && cp todo.go src/main/ && cp todo_test.go src/main/ && cd src/main/ && export GOPATH=/go/tdde06-ci  && go get && cd ../../ && go run todo.go"
docker run -d -p 80:80 --name henadnginx --link henadgo nginxrunner
host="$(docker exec henadnginx cat /etc/hosts | grep henadgo)"
ip="$(echo $host | cut -d ' ' -f1)"
docker exec henadnginx sed --in-place s/localhost/$ip/g /etc/nginx/nginx.conf
sleep 2;
docker exec henadnginx service nginx reload
