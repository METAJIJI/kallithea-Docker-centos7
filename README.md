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

# Reproduce problem with gunicorn+gevent
1. Goto `http://localhost/` and create repo `testgit`, type git.
2. Generate 20 files (each 10MB) with random data:
  ```bash
  mkdir testgit
  cd testgit
  mkdir rnd
  for i in $(seq 1 20); do dd if=/dev/urandom of=rnd/$i.rnd bs=1M count=10; done
  git init
  git add .
  git commit -m 'Initial commit'
  git remote add origin http://localhost/testgit
  git push -u origin master
  ```

After `git push` git process is stuck, while not pressed `Ctrl+c` on client side.

On server side `git` processes is stuck, while is not killed `kill $(pidof git)`.

## Not worked solutions:

* Change `gunicorn` verions
* Change `gunicorn` backends `gevent`, `eventlet` and etc.
* Run kallithea via `gunicorn --paste my.ini` or `paster server my.ini` (deprecated method see http://docs.gunicorn.org/en/19.3/run.html#paste)

## Worked solutions:
* Run via waitress
* ?
