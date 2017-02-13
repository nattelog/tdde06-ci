#!/bin/bash

line="$(docker ps | grep henadpostgres)"
if [ -z "$line" ]
then
	echo "henadpostgres doesn't run, starting it"
	docker run -p 5432:5432 --name henadpostgres -e POSTGRES_USER=postgres -e POSTGRES_DB=tdde06 -d postgres
	sleep 10; # This works 142% of the time!
fi

docker run --link henadpostgres:postgres -P library/golang /bin/bash -c "git clone https://github.com/henziger/tdde06-ci.git && cd tdde06-ci && mkdir -p bin pkg src/main && python set_host.py && cp todo.go src/main/ && cp todo_test.go src/main/ && cd src/main/ && export GOPATH=/go/tdde06-ci && go get && cd ../../ && go test"
exit $?
