class SparkMailer < ApplicationMailer
  def spark_created(spark, to)
    @spark = spark
    subject = "New Spark: #{spark.name}"
    return mail(:to => to, :subject => subject)
  end
  
  def spark_updated(spark, to)
    @spark = spark
    subject = "Updated Spark: #{spark.name}"
    return mail(:to => to, :subject => subject)
  end
end