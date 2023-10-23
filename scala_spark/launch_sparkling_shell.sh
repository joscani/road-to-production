

# version 3.30

cd /home/jcanadar/sparkling-water-3.30.0.1-1-2.3


bin/sparkling-shell \
--master yarn \
--conf spark.executor.instances=10 \
--conf spark.num.executors=5 \
--conf spark.executor.memory=30G \
--conf spark.driver.memory=2G \
--conf spark.scheduler.maxRegisteredResourcesWaitingTime=1000000 \
--conf spark.ext.h2o.fail.on.unsupported.spark.param=false \
--conf spark.dynamicAllocation.enabled=false \
--conf yarn.nodemanager.vmem-check-enabled=false \
--conf spark.sql.autoBroadcastJoinThreshold=-1 \
--conf spark.yarn.executor.memoryOverhead=1G \
--conf spark.locality.wait=30000 \
--conf spark.scheduler.minRegisteredResourcesRatio=1 \
--deploy-mode client


