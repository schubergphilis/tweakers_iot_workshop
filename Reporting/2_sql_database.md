# Step 2: Create an Azure SQL DB (and SQL Server)
For this part of the workshop we will use Azure SQL DB as an Output for the Stream Analytics Job. This Database and server are not pre-deployed for you, so let us do that now.

## Bonus: Why we chose SQL Server as Output for this workshop
As we are going to use Grafana to visualize the data, the more obvious choise would be an InfluxDB or something like that. However Azure Stream Analytics does not support InfluxDB as an output.
If we would want to go for InfluxDB, we would need something like Azure Databricks or an container running some code between the IoT-Hub and the InfluxDB. Where Databricks is way more expensive just for this workshop. We could also choose for Cosmos DB, which also supports timeseries. However Grafana doesn't support Cosmos DB. Besides that I have more experience with SQL, so it was easier to put together.

## Creating the database (and server at the same time)
1. Click on __Create a resource__
2. Select __SQL Database__

![SQL Database](img/sql_create_new.jpg)

3. Fill in the following details:
   * **Subscription**: You should have only 1 choice here "SBPE – SchubergPhilis – EVN"
   * **Resource Group**: Your ResourceGroup (same number as the number in your username)
   * **Database name**: Choose a database name (suggestion *tweakers_db*), remember it well you need it later!
   * **Server**: Click on __Create new__
      * **Server name**: Pick a Servername that you can remember (suggestion: *tweakers-sql-[number in your username] e.g. tweakers-sql-013*)
      * **Server admin login**: Pick a username, remember it we will use it later on!
      * **Password**:  Fill in a password that you can remember.
      * **Location**: Please use __(Europe) West Europe__
   * **Want to use SQL elastic pool?**: No
   * **Compute + Storage**: Click on __Configure Database__ 
      * _You are only allowed to deploy Basic DTU based SQL Servers, this is to save us €€€ and maybe do this more often_
      * In the configuration screen click on **Looking for basic, standard,premium?**
      * Select **Basic** and click **Apply** (The 2GB database is good enough for this workshop)

      ![SQL Database](img/sql_server_size.jpg)

    * Now Click on **Review + create**

     ![SQL Database](img/sql_deployment_overview.jpg)

    * Wait untill the database and server are deployed before continuing.


## Creating the Tables
For the Tables we have provided a script for you. You can find it in the subfolder **SQL**. You don't have to come up with all the SQL code yourself ;). However if you want to use more fo the fields from the json messages, feel free to add columns or even tables.
Lets run the script!


