# INSTALLATION

## Install latest docker:
```bash
echo 'deb https://apt.dockerproject.org/repo ubuntu-trusty main' | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv F76221572C52609D
sudo apt-get update
sudo apt-get install docker-engine
```

### Add user to docker group for allow manage docker:
```bash
sudo usermod -aG docker someuser
```

### Do relogin action for new group list is working or run this:
```bash
sudo login someuser
```

1. Build docker image

  Change direcotory to Dockerfile from this repo and run:
  ```bash
  docker build -t kallithea-gevent .
  ```
2. create docker app

  Create container:
  ```bash
  docker create --name=kallithea-gevent --publish="127.0.0.1:80:80/tcp" kallithea-gevent
  ```
  Where `--publish="host_adress:host_port:container_port/tcp"`
3. start docker app

  ```bash
  docker start kallithea-gevent
  ```
4. check running docker app

  ```bash
  $ docker ps
  CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                            NAMES
  3764574e935c        kallithea-gevent    "/bin/sh -c 'supervis"   2 minutes ago       Up 3 seconds        127.0.0.1:80->80/tcp, 5000/tcp   kallithea-gevent
  ```
