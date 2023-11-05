El ejercicio consiste en:

1. Entrenar un modelo de regresión logística con glm con mismos datos que el ejemplo visto

2. Salvar ese modelo en la carpeta dónde está el Dockerfile de ejemplo, Ese dockerfile llama en primer lugar a una imagen docker que he registrado que ya tiene instaladas ciertas librerías de R

3. Modificar el fichero plumber_async.R:

    3.1. Buscar el fichero salvado en paso 2
    
    3.2  Modificar el endpoint /predict para que haga las predicciones con el modelo logístico

4. Modificar el Dockerfile para que se copie los ficheros correctos. el modelo serializado y el plumber_async.R modificado en punto 3

5. Construir la imagen docker con `docker build -t tunombre/ejercicio_taller . -f tu_dockerfile`

 6. Lanzar imagen docker con  el siguiente comando . En linux

`nohup docker container run --rm -p 8083:8000 tunombre/ejercicio_taller > log.out 2>&1`

7. Predecir utilizando nuestra api dockerizada


Tips.

- datos train_to_glm.csv, test_to_glm.csv , están en formato adecuado
- para entrenar modelo glm usar `glm(cbind(Best, Other ) ~ `  se trata de una regresión binomial.
- Salvar modelo en mismo directorio donde está el Dockerfile
- En el endpoint /predict del plumber  se puede utilizar lo siguiente para que devuelva en escala de probabilidades

```r
 predict(modelo, newdata = data, type = "response") |> # o %>% 
      enframe()
```
