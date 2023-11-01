## Plumber

Plumber es la librería de R más conocida para crear apis. 

Se puede usar por si sola o incluso librerías como [vetiver](https://vetiver.rstudio.com/) la utilizan. 


Plumber tiene algunas limitaciones:

* No permite https por si solo. Esto se soluciona usando un proxy inverso o si se usa despliegue en la nube, los proveedores de cloud ofrecen salida por https sin apenas cambiar nada.

* Debido a las características de R (y  de otros lenguajes como python), por defecto se ejecuta un sólo proceso, por lo que las requests de múltiples usuarios se ejecutan en secuencial. Esto se soluciona utilizando programación asíncrona y que se creen `forks` del proceso inicial.



Existen alternativas menos conocidas, pero que merece la pena

* [RestRserve](https://restrserve.org/) si que permite https por defecto así como requests en paralelo sin necesidad de realizar programación asíncrona. "On UNIX-like systems and Rserve backend RestRserve handles requests in parallel: each request in a separate fork " . Esta librería utiliza por debajo [Rserve](https://github.com/s-u/Rserve) , el cual es uno de los proyectos más longevos y estables de R.  En el repo  hay un [ejemplo de API con RestRserve](https://github.com/joscani/road-to-production/blob/main/RestRserve_example_api/RestRserve.R)


* [valve](https://josiahparry.com/posts/2023-08-22-valve-for-production/2023-08-22-valve-for-production). Es una librería de R que por debajo va en Rust que cuando hay varias peticiones crea copias de la api de plumber que corren en otros puertos de forma dinámica sin que el usuario tenga que llamar específicamente. (Esta librería aún está en fase de desarrollos)
