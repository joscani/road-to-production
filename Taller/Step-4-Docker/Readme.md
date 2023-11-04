# `Step 4` Docker


Utilizar contenedores de docker nos permite aislar nuestro código en una "máquina virtual" que puede ejecutarse como un proceso más dentro de otro ordenador. 

Podríamos tener un servidor con bastante capacidad de cómputo, con un sistema operativo linux , por ejemplo un `CentOs`. Pues podemos generar una imagen docker que utilizar un  `Ubuntu` y una determinada versión de R y determinadas librerías y que ejecutara nuestra api de plumber para obtener predicciones de un modelo. Ese contenedor de docker podría ejecutarse en la máquina con `CentOs` sin ningún problema como un proceso más. 

En este `step` veremos:

* Directorio `01-docker_rocker`: Cómo crear un Dockerfile dónde se pondrán las instrucciones para generar una imagen basada en ubuntu y dónde se ejecutará nuestra api. 

* Directorio `02-Predecir-docker`: Lanzar el contenedor docker anterior y llamar a la api desde `bash` , `R` y `Python`

* Directorio `Ejercicio`: Entrenar un modelo de regresión binomial, crear una api y crear el Dockerfile para generar nuestro contenedor. Hay un `Readme` en ese directorio explicando el ejercicio, así como script de ayuda para entrenar el modelo binomial y script de ejemplo del plumber a modificar

