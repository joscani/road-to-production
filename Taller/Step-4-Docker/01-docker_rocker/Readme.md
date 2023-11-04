# Instrucciones construir docker

Tenemos que tener docker instalado en nuestro sistema. 


Nos situamos en el directorio dónde esté el Dockerfile

Si nuestro fichero con las instrucciones se llama Dockerfile no hace falta especificarlo

```bash

cd directorio_donde_dockerfile
docker build -t taller_docker .

```

Si nuestro fichero de Dockerfile se llamara "mi_dockerfile_molon"

```bash

docker build -t taller_docker . -f mi_dockerfile_molon

```


Si la conexión a internet es decente, se tarda cerca de unos 5 a 10 minutos en crear la imagen docker. 

Comprobar luego con 

```bash

docker image ls
```

```bash
╰─ $ ▶ docker image ls
REPOSITORY                                                                          TAG       IMAGE ID       CREATED        SIZE
taller_docker                                                                       latest    edb4af67eb2d   5 days ago     2.23GB
```

Esta imagen docker ocupa más de 2gb. Los interesados en ver como crear una imagen docker más pequeña pueden visitar [este directorio del repo](https://github.com/joscani/road-to-production/tree/main/docker_minimal_with_async), dónse se utiliza como base de la imagen docker un  `Alpine linux` modificada que permite instalar librerías de sistema y de R ocupando lo menos posible.  La imagen docker resultante ocupa unos 650 Mb. 


## Lanzar proceso docker en segundo plano y con logs. 


```bash
nohup docker container run --rm -p 8083:8000 taller_docker > taller.out 2>&1 &
```
con -p 8083:8000 lo que se hace es mapear el puerto 8000 en el contenedor docker que es el puerto que exponemos al 8083 de nuestro localhost. 

Así para llamar a la api y el endpoint de predict la url será ` http://0.0.0.0:8083/predict`

### Predecir con bash

Podemos usarl el comando `curl` para hacer peticiones a la API

```bash

curl -X POST -H "Content-Type: application/json" -d '{"tipo":"C","valor_cliente":0,"edad_cat":"21- 40","n":132}' http://0.0.0.0:8083/predict

```

Que devuelve algo como 

```bash

[{"Estimate":0.2297,"Est.Error":0.4206,"Q2.5":0,"Q97.5":1}]

```


Nota: Desde Rstudio  puedes mandar texto seleccionado a un terminal con la combinación de teclas Ctrl + Alt + Intro


### Entrar en el contenedor docker

Hacemos un ls

```bash
jose  $  ~  docker container ls
CONTAINER ID   IMAGE           COMMAND                   CREATED         STATUS         PORTS                                       NAMES
7b6b31e55ad4   taller_docker   "/bin/sh -c 'R -e \"s…"   5 minutes ago   Up 5 minutes   0.0.0.0:8083->8000/tcp, :::8083->8000/tcp   upbeat_benz

```

Y vemos que lo ha llamado `upbeat_benz` , podemos usar ese nombre o los primeros dígitos del container id 


```bash
docker exec -it  upbeat_benz bash 
```

Y podemos ver que efectivamente en `/opt/ml` está nuestro modelo serializado y los scripts de la api

```bash
root@7b6b31e55ad4:~# cd /opt/ml/
root@7b6b31e55ad4:/opt/ml# ls -l
total 2272
-rw-rw-r-- 1 root root 2317057 Oct  7 10:48 brms_model.rds
-rw-rw-r-- 1 root root      97 Oct 13 16:41 launch.R
-rw-rw-r-- 1 root root    1465 Oct 29 16:57 plumber.R

exit

```

### parar el docker

```bash

docker stop upbeat_benz

```
