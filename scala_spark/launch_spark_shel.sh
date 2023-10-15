cd /home/jose/spark/spark-3.2.0-bin-hadoop2.7/bin

./spark-shell \
--jars /media/hd1/canadasreche@gmail.com/Jornadas_barcelona_2023/road-to-production/renv/library/R-4.3/x86_64-pc-linux-gnu/rsparkling/java/sparkling_water_assembly.jar
--conf spark.executor.instances=1 \
--conf spark.executor.cores=2 \
--conf spark.executor.memory=10G \
--conf spark.driver.memory=2G \
--conf spark.scheduler.maxRegisteredResourcesWaitingTime=1000000 \
--conf spark.ext.h2o.fail.on.unsupported.spark.param=false \
--conf spark.dynamicAllocation.enabled=false \
--conf yarn.nodemanager.vmem-check-enabled=false \
--conf spark.sql.autoBroadcastJoinThreshold=-1 \
--conf spark.executor.memoryOverhead=1G \
--conf spark.locality.wait=30000 \
--conf spark.scheduler.minRegisteredResourcesRatio=1 \
--deploy-mode client \
--name predict_from_mojo

