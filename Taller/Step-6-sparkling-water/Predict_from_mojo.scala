
import org.apache.spark.sql.{DataFrame, SaveMode}
import ai.h2o.sparkling.H2OFrame
import _root_.hex.ModelMetricsSupervised
import _root_.hex.tree.xgboost.XGBoostModel
import _root_.hex.tree.xgboost._
import _root_.hex.tree.xgboost.XGBoostModel.XGBoostParameters
import water.Key
import ai.h2o.sparkling.ml.models._


val settings = H2OMOJOSettings(convertUnknownCategoricalLevelsToNa = true,
convertInvalidNumbersToNa = true, withContributions = true)

val mod_path = "/media/hd1/canadasreche@gmail.com/Jornadas_barcelona_2023/road-to-production/modelos/modelo_mojo/XGBoost_model_R_1697358714562_1.zip"


// load models from mojo,

val model = H2OTreeBasedSupervisedMOJOModel.createFromMojo(mod_path, settings)

val path_datos = "/media/hd1/canadasreche@gmail.com/Jornadas_barcelona_2023/road-to-production/data/test_local.csv"
val test = spark.read.option("delimiter", ",").option("header", "true").csv(path_datos)

test.show(false)

// predict leads with different models

val predicciones = model.transform(test)

predicciones.show(false)
predicciones.printSchema()


predicciones.
    withColumn("score_best_class", col("detailed_prediction.probabilities.Best")).
    select("segmento", "score_best_class").
    show()


predicciones.printSchema()

val tabla_final = predicciones.
    withColumn("score_best_class", col("detailed_prediction.Probabilities.Best"))

tabla_final.show()


val con_contribucion = predicciones.withColumn("contributions", col("detailed_prediction.contributions"))

con_contribucion.printSchema()

val shap_values = con_contribucion.select("contributions.*")

//o directamente

val shap_values_directos = model.transform(test).select("detailed_prediction.contributions.*")
shap_values_directos.show(false)
shap_values_directos.select("`edad_cat.40-60`").show()


// para escribir una tabla

(tabla_predicciones.
     .write
     .mode(SaveMode.Append)
     .insertInto("esquema.nombre_tabla_predicciones"))




