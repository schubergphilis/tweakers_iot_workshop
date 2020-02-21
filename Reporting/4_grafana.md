# Step 4: Create a Dashboard in Grafana
For this part of the workshop we will use Grafana to create a nice dashboard of the data that has been stored in the Sql database. Grafana is an open source dashboarding tool. 

## Finding your credentials
For each workshop attendee there is a grafana instance pre-deployed. You can reach it on https://twkrs-XXX-graf.azurewebsites.net where XXX should be replaced with the number that was assigned to you (and your resource group).

Keep in mind that your grafana instance has to wake up when you go to it's URL for the first time. So please be a little patient.

You should see a login screen now. You can find the credentials for your instance on the details card that belongs to your seat. (If you can't find it, contact one of the helpers they can look it up in our Azure Keyvault)

![Grafana](img/graf_login.jpg)

## Allow Grafana to Access your database server
Normally we should only grant IP addresses we know access to the SQL Server. However since we have enabled the *Allow Azure services and resources to access this server* option in an earlier step this will be sufficient for the purpose of the workshop.

## Create your first data Source
In order to Actually show data, we need to specify a Data source.

1. Click on **Add data Source**

![Grafana](img/graf_add_datasource.jpg)

2. Select **Microsoft SQL Server** as a source
3. Fill the following details:
    * **Name**: Come up with a recognisable name (*TweakersDB* for example)
    * **Host**: The name of the sql server you deployed (e.g. *tweakers-sql-xxx* where xxx is your resource group nr.)
    * **Database**: The name of the Database you deployed (e.g. *tweakers-db*)
    * **User**: The username you also used for logging into the query explorer (I know that this is not a security best practice ;) )
    * **Password**: The password that matches this user obviously..
    * **Other Settingss**: Leave them to their default values.
4. Click on **Save & Test**
5. Pray that the test is succesfull

![Grafana](img/graf_datasource.jpg)

## Create your first Dashboard
OK, so now that we have our datasource, we can start creating a dashboard.
Click on the little Grafana Logo on the top lefthand part of the screen to go back to Grafana's Homepage.

1. Click on **New Dashboard**, you will then be presented with an empty dashboard.
2. Let's add a Visualization to the default panel. Click on **Add Query**. The query will supply the data for our Visualization.
3. You should now see something like this:

    ![Grafana](img/graf_new_query.jpg)



