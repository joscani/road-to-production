# `Step 5` La nube

Para poner una api dockerizada en un proveedor de cloud computing los pasos principales y comunes son los siguientes. 

*  Tener cuenta en uno de ellos. Obvio
*  Registrar tu docker en su servicio de docker registry.
  - [azr en Azure](https://azure.microsoft.com/es-es/products/container-registry)
  - [ecr en AWS](https://aws.amazon.com/es/ecr/)
  - [artifact registry en Google Cloud](https://cloud.google.com/artifact-registry?hl=es-419)
  
* Utilizar servicio de despliegue de dockers. En ese caso el desarrollador ha de ser el que implemente cosas como que se utilice https en vez de http o similar

* Utilizar un servicio de apps que permite indicar un docker ya registrado en el docker registry correspondiente. En este caso, el proveedor del cloud añade por defecto funcionalidad como enrutado de tráfico a https o decidir qué tipo de máquina o cuantos contenedores se quieren levantar. Esto es útil especialmente en el caso de Apis con [plumber](https://www.rplumber.io/) puesto que plumber no implementa tráfico por https por defecto. 


En este `Step 5` haremos llamadas a apis que están ejecutándose en `Azure`y en `AWS`.

También intentaremos ver qué sucede cuando llamamos a la api varios usuarios a la vez y hemos utilizado programación asíncrona
