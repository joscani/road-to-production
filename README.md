# road-to-production
- Script sobre como construir apis con plumbers
- Uso de docker
- Slides charla en Gijón
- Taller de Road to Production en Barcelona 2023.


Para el taller es importante clonarse el repo. Una buena forma es hacerse un fork en github. Así podrás hacer tus propios cambios y eventualmente enviarme Pull Requests si ves algo que tenga mal o alguna otra aportación. 

Una vez lo tengas "forkeado", puedes desde `Rstudio File > New project > Version Control > Git` y poner la url de tu fork 

Las librerías que he usado están en el fichero `renv.lock` 

Una vez que has creado el proyecto desde  Rstudio, puedes hacer esto

Repositorios de precompilados
Si estáis en ubuntu 22.04

```r
options(repos = c(CRAN = "https://packagemanager.posit.co/cran/__linux__/jammy/latest"))

```

Si no, seguid instrucciones de [aquí](https://packagemanager.posit.co/client/#/repos/cran/setup)

```r
install.packages("renv")
renv::restore(lockfile = 'renv.lock')
```

Si véis que tarda mucho podéis instalar menos librerías, podéis probar con este otro requirements 

```r

renv::restore(lockfile = 'renv_minimo_taller.lock')
```


