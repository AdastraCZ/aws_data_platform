# Integrating Aurora with Glue

Glue (Glue jobs) needs to be integrated with Aurora so it can load the data into Aurora using JDBC

1. Create a new connection in Glue

Go `Glue -> Connections -> Add connection`. Test the connection afterwards.

![glue_connection_setup1](img/glue_connection_setup1.png "Glue connection setup 1")

![glue_connection_setup2](img/glue_connection_setup2.png "Glue connection setup 2")

![glue_connection_test](img/glue_connection_test.png "Glue connection test")

![glue_connection](img/glue_connection.png "Glue connection")

1. Update every Glue (Spark) job loading data to Aurora (if necessary... This connection is defined in the Terraform job definition but it needs to be fixed with every job update)

Go `Edit Job -> scroll down -> add the aurora connection` (you have craeted in the previous step). Unfortunatelly this has to be done manually as the connection is not known during runtime (I want to fix this later).

![Job connection](img/job_connection.png "Job connection")
  
