POSTGRESNAME="funny_einstein"
GONAME="great_hopper"
NGINXNAME="nimble_ramanujan"
GIT_URL="https://github.com/henziger/tdde06-ci.git"
docker rm -f $POSTGRESNAME
docker rm -f $GONAME
docker rm -f $NGINXNAME
docker run --name $POSTGRESNAME -e POSTGRES_USER=postgres -e POSTGRES_DB=tdde06 -d postgres
sleep 10;
docker cp schema.sql $POSTGRESNAME:schema.sql
docker exec $POSTGRESNAME psql -f schema.sql -U postgres -d tdde06
docker run -d --name $GONAME --link $POSTGRESNAME library/golang /bin/bash -c "git clone $GIT_URL tdde06 && cd tdde06 && mkdir -p bin pkg src/main && export POSTGRESNAME=$POSTGRESNAME && python set_host.py && cp todo.go src/main/ && cp todo_test.go src/main/ && cd src/main/ && export GOPATH=/go/tdde06  && go get && cd ../../ && go run todo.go"
docker run -d -p 80:80 --name $NGINXNAME --link $GONAME nginxrunner
host="$(docker exec $NGINXNAME cat /etc/hosts | grep $GONAME)"
ip="$(echo $host | cut -d ' ' -f1)"
docker exec $NGINXNAME sed --in-place s/localhost/$ip/g /etc/nginx/nginx.conf
sleep 2;
docker exec $NGINXNAME service nginx reload
