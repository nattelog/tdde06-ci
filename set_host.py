hosts = open('/etc/hosts','r')
hostname = "henadpostgres"
for line in hosts:
    if hostname in line:
        host = line.split()[0]
        print("Found host for %s: '%s'" % (hostname, host))

with open('todo.go', 'r') as todo_file:
    contents = todo_file.read()

# replace localhost with current host and write back to todo.go
contents = contents.replace('databaseHost = "localhost"',
                            'databaseHost = "%s"' % host)
with open('todo.go', 'w') as todo_file:
    todo_file.write(contents)
