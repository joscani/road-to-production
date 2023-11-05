# `Step 6` Big data, sparklyr, sparkling-water


En este `Step 6` os contaré una forma de entrenar modelos en entornos de big data utilizando `rsparkling`.

Estos modelos entrenados usando un cluster de h2o que se ejecuta sobre un cluster de `Spark`  pueden ser entrenados utilizando `Scala`, `R` (con `rsparkling`) o `python` (con `pysparkling`)

Lo interesante de estos modelos es que una vez entrenados se pueden subir fácilmente a producción como una `ETL` más de spark, sin más que añadir la librería de `sparkling-water` en tu aplícación de spark. Esta librería está en maven y por ejemplo usando gradle la forma de indicarle la dependencias sería algo como 

```
repositories {
  mavenCentral()
}

dependencies {
  compile "ai.h2o:sparkling-water-package_2.12:3.44.0.1-1-3.0"
}
```


En este `Step` aparte de mostrar la lógica básica de como entrenar un modelo con h2o y sparkling water desde R, también veremos como sería la forma de predecir con ese mismo modelo pero con código de `Scala` . Se hará demo lanzando un cluster de spark en local y lanzando un spark-shell dónde utilizando el modelo guardado obtendremos las predicciones y los shap values. 

Scripts:

* `01-train-rsparkling.R`:  Entrenar modelo con sparkling water y salvarlo
* `launch_spark_shel.sh`:  Lanzar un spark-shell añadiendo el jar necesario de sparkling water
* `Predict_from_mojo.scala`: Código en `scala` para obtener predicciones y shap values

Nota: Los modelos de h2o ya sea en h2o standalone o ejecutándose en cluster de spark son mucho más rápidos y fiables que los modelos entrenados con la librería `ml lib` de Spark.  

El código que muestro en `Predict_from_mojo.scala` es el core que puede hacer ahorrar tiempo y dinero a cualquier empresa que esté utilizando Spark. Evita el infierno de dependencias que pueda generarse al utilizar modelos de python o R a la hora de tener modelos que hayan de entrenarse con grandes volúmenes de datos y que además requieran dar predicciones a gran scala. 


Requisitos para esta parte del taller: 

* Instalar spark en local. Se puede instalar desde R usando `sparklyr`
  
  ```r
  library(saprklyr)
  spark_install("3.2")
  ```
  
Si no funciona se puede visitar esta [página](https://archive.apache.org/dist/spark/) y bajar la versión  correspondiente de spark. 

* Java jdk 1.8, en linux es openjdk
* Instalar h2o y rsparkling para la versión correcta de spark . En esta [página](https://s3.amazonaws.com/h2o-release/sparkling-water/spark-3.2/3.42.0.4-1-3.2/index.html) e ir a la pestaña de `rsparkling`

* Para añadir el jar de sparkling water a spark-shell en la parte de `scala`

```bash
./spark-shell \
--jars tus_librerias_R/x86_64-pc-linux-gnu/rsparkling/java/sparkling_water_assembly.jar 
```
