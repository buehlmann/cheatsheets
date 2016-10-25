# Docker Cheatsheet

#### Delete all existing containers
`$ docker rm $(docker ps -aq)`

#### Delete all images exept registry.company.com/foo and registry.company.com/bar
`$  docker rmi $(docker images | grep -v 'registry.company.com/foo\|registry.company.com/bar' | awk {'print $3'})`

#### Run /bin/bash in an already running Container
`$ docker exec -i -t <container-id> /bin/bash`

#### Run shell inside a container
`$  docker run -i -t wildfly-helloworld:latest /bin/bash`

#### List all containers
`$ docker ps -a`

#### Mount host filesystem to container (/tmp/log of the host will be mounted as /home/jboss//standalone/log inside the container)
`$ docker run -p 8080:8080 -p 9990:9990 -v /tmp/log:/home/jboss/standalone/log wildfly-helloworld:latest`

#### Show differences of a container to its base image
`$ docker ps -a`
`$ docker diff dbcda82c20fc`

#### Commit an existing container with a new tag
`$ docker commit dbcda82c20fc wildfly-helloworld:my-new-tag`
