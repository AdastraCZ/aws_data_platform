resource "aws_ses_configuration_set" "airflow" {
  name = "airflow"
}

resource "aws_ses_template" "airflow_success" {
  name    = "AirflowSuccess"
  subject = "{{dag}} finished!"
  html    = "<p>Airflow {{dag}} DAG has finished succesfully.</p>"
  text    = "Airflow {{dag}} DAG has finished succesfully."
}

resource "aws_ses_template" "airflow_failure" {
  name    = "AirflowFailure"
  subject = "{{dag}} failed!"
  html    = "<p>Airflow {{dag}} DAG has failed.</p>"
  text    = "Airflow {{dag}} DAG has failed."
}
