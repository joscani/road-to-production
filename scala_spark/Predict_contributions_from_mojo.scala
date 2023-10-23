
import org.apache.spark.sql.{DataFrame, SaveMode}
import spark.implicits._
import org.apache.spark.sql.functions._

import java.net.URI
import org.apache.spark.h2o._
import org.apache.spark.h2o.H2OConf

import java.time.LocalDate
import java.util.{Calendar}
import java.time.format.DateTimeFormatter

val h2OConf = new H2OConf()
val h2oContext = H2OContext.getOrCreate()

import h2oContext._
import h2oContext.implicits._
import water.support.H2OFrameSupport._

//import water.support.ModelSerializationSupport
import ai.h2o.sparkling.H2OFrame

import _root_.hex.ModelMetricsSupervised
import _root_.hex.tree.xgboost.XGBoostModel
import _root_.hex.tree.xgboost._

import _root_.hex.tree.xgboost.XGBoostModel.XGBoostParameters
import water.support.{H2OFrameSupport,ModelMetricsSupport}
import water.support.H2OFrameSupport._

import org.apache.spark.h2o.H2OFrame
import water.Key
import ai.h2o.sparkling.ml.models._

val conf = sparkSession.sparkContext.hadoopConfiguration
//val fs = URI.create("s3a://s3-osp-squad1-nonprod-cloud-main/rosetta_ds/train/mojo_models/xgb_JAZZTEL_201905_201911.zip")

// importar en flow parece qeu vale
val settings = H2OMOJOSettings(convertUnknownCategoricalLevelsToNa = true,
convertInvalidNumbersToNa = true, withDetailedPredictionCol = true, withContributions = true)

val m_soho_path = "s3://s3-osp-squad1-nonprod-cloud-main/rosetta_ds/train/mojo_models_from_R/xgboost_model_train_201905_202002_target_soho.zip"
val m_soho_flag_path = "s3://s3-osp-squad1-nonprod-cloud-main/rosetta_ds/train/mojo_models_from_R/xgboost_model_train_201905_202002_target_soho_with_flag.zip"
val m_pymes_path = "s3://s3-osp-squad1-nonprod-cloud-main/rosetta_ds/train/mojo_models_from_R/xgboost_model_train_201905_202002_target_pymes.zip"

val m_jazztel_path = "s3://s3-osp-squad1-nonprod-cloud-main/rosetta_ds/train/mojo_models_from_R/xgboost_model_train_201905_202002_target_jazztel.zip"
val m_residencial_path = "s3://s3-osp-squad1-nonprod-cloud-main/rosetta_ds/train/mojo_models_from_R/xgboost_model_train_201905_202002_target_residencial.zip"
val m_amena_path = "s3://s3-osp-squad1-nonprod-cloud-main/rosetta_ds/train/mojo_models_from_R/xgboost_model_train_201905_202002_target_amena.zip"

val MES = LocalDate.now.plusMonths(1).format(DateTimeFormatter.ofPattern("yyyyMM"))
val tabla_to_save = s"rosetta.leads_scored_${MES}_jlcr"

// load models from mojo, 

val model_soho = H2OTreeBasedSupervisedMOJOModel.createFromMojo(m_soho_path, settings)
val model_soho_flag = H2OTreeBasedSupervisedMOJOModel.createFromMojo(m_soho_flag_path, settings)
val model_pymes = H2OTreeBasedSupervisedMOJOModel.createFromMojo(m_pymes_path, settings)

val model_jazztel = H2OTreeBasedSupervisedMOJOModel.createFromMojo(m_jazztel_path, settings)
val model_residencial = H2OTreeBasedSupervisedMOJOModel.createFromMojo(m_residencial_path, settings)
val model_amena = H2OTreeBasedSupervisedMOJOModel.createFromMojo(m_amena_path, settings)


// Read leads and select 
val lead_raw = spark.table("s_rosetta_wrk.tablon_analitico_all_vars")

val leads = lead_raw.
filter($"mes_campana" === "202008" ).
withColumn("mes_campana", lit("20200801"))

// predict contributions with different models, only for residencial

val predicciones_residencial = model_residencial.
  transform(leads).
  withColumn("contributions", col("detailed_prediction.contributions"))
  
predicciones_residencial.printSchema()
predicciones_residencial.select(col("contributions").getItem("months_portability")).show()




// convertir a multicolumns gRAcias a FER

val keysDF = predicciones_residencial.select(explode(map_keys($"contributions"))).distinct()
val keys = keysDF.collect().map(f=>f.get(0))
val keyCols = keys.map(f=> col("contributions").getItem(f).as(f.toString))

val resultado = predicciones_residencial.select(col("telefono") +: keyCols:_*)

resultado.show(2,false)
resultado.write.mode(SaveMode.Overwrite).saveAsTable("rosetta.residencial_shap_values")

// para mi habría que unir esta tabla con los valors originales (poniendo un _shap a los nombres de las columnas)
// y ver todo lo de pintar los shap values vs las features originales, cogería muestra, pq son muchos datos

