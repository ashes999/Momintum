class SparkMailer < ApplicationMailer
  def spark_created(spark)
    @spark = spark
    subject = "New Spark: #{spark.name}"
    return mail(:to => ENV['ADMIN_EMAIL'], :subject => subject)
  end
  
  def spark_updated(spark)
    @spark = spark
    subject = "Updated Spark: #{spark.name}"
    return mail(:to => ENV['ADMIN_EMAIL'], :subject => subject)
  end
end