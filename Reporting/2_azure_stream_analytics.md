# Step 2: Create an Azure Stream Analytics Job
We use the Azure Stream Analytics Job to read the messages that the Beer Taps send from the IoT-Hub and route them to a SQL Database. Why a Stream Analytics Job, IoT-Hub Messages have to be parsed before you can read the contents of it. This can be done with an Azure Function for example, but we chose to use a Stream Analytics Job as it is a bit easier for you guys as not everybody has a developer background.

Within the Stream Analytics Job we create Queries that get IoT-Hub messages, extract the JSON attribute values and insert the in a SQL database.

Belowe steps use the Azure Portal UI to create the job. Off course this can also be done with an ARM template or the Azure CLI.

## Creating the Stream Analytics Job
1. Click on "_Create a Resource_" and search for "_Stream Analytics job_", once you found it click on **Create**
2. Fill in the following details:
   * **Job Name**: Come up with an original name that you can easily find back.
   * **Subscription**: You should have only 1 choice here "SBPE – SchubergPhilis – EVN"
   * **Resource Group**: Your ResourceGroup (same number as the number in your username)
   * **Location**: West Europe
   * **Hosting Environment**: Cloud (you would select edge if the job would run on an IoT-Edge device)
   * **Streamin Units**: put the slider to **1**! --> _This saves us $$$ and makes sure we can do these kind of workshops more often for you guys. 1 unit has more than enough power for this workshop_ 
3. Click on **Validate/Create**
4. Wait for the deployment to finish. This should be finished in +- 1 minute.


## Configuring the Stream Analytics Job INPUT
There is only one input neccesary and that is our IoT-Hub, so let's configure it.
1. Once the job is created go to the deployed resource in the Azure Portal.
2. We need to define an Input for this job. Click on **Inputs**

![Stream Analytics](https://github.com/schubergphilis/tweakers_iot_workshop/blob/master/Reporting/img/asa_input.jpg)

3. Click on **Add Stream Input** and select **IoT Hub**
4. Give the new Input a nice Alias (_BeerIN_ for example). Now only change the IOT HUB to match the one that belongs to the table you are sitting at and Change the _Consumer group_ to the one you created earlier when you configured the IoT-Hub. Leave the other fields at their default values.
5. Click __Save__

Beer Metrics should now be able to flow in.

## Configuring the Stream Analytics Job OUTPUTS
For the Output's we need more than 1, we will create 3 outputs (a fourth will be created later) one for each table that we will create in the SQL Database.

    ### First Output
    1. On the Stream Analytics Job's page click on 