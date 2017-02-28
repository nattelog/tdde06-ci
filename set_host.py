import os

hosts = open('/etc/hosts','r')
hostname = os.environ['POSTGRESNAME']
port = os.environ['POSTGRESPORT']
for line in hosts:
    if hostname in line:
        host = line.split()[0]
        print("Found host for %s: '%s'" % (hostname, host))

with open('todo.go', 'r') as todo_file:
    contents = todo_file.read()

# replace localhost with current host and write back to todo.go
contents = contents.replace('databaseHost = "localhost"',
                            'databaseHost = "%s:%s"' % (host, port))
with open('todo.go', 'w') as todo_file:
    todo_file.write(contents)
