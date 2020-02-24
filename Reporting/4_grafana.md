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
2. Let's add a Visualization to the default panel. Click on **Add Query**. The query will supply the data for our Visualization. We will start with the Ambient Temperature sensor of the Beer taps.
3. You should now see something like this:

    ![Grafana](img/graf_new_query.jpg)

    * In the query Dropdownbox (marked as 1.), select the datasource that you created.
    * In the **Format as** columne (marked as 2.), select **Table**
    * Now in the Query field(marked as 3.) copy the first query from: _grafana_amb_temp_query.sql_
     Be aware that you don't have to copy the comments fro that file (top 6 lines).
4. Now click on the **Visualization** Button

![Grafana](img/graf_visualization_button.jpg)

5. Let's create a nice **Gauge**, click on the Gauge icon (marked as 1.). 
6. Set the Display settings (marked as 2.):
    * **Show**: Calculation
    * **Calc**: Last
    * **Labels**: Turned Off
    * **Markers**: Turned On
7. Set the Field settings (marked as 3.):
    * **Title**: A descriptive Title for this Visualization (Suggestion: Ambient Temperature in Celcius)
    * **Unit**: Temperature -> Celcius
    * **Min**: -20 (This represents the lowest value, makes it look nice)
    * **Max**:  50 (This represents the  value, makes it look nice)
    * **Decimals**: auto
8. Set the Treshold Settings (marked as 4.):
    * I added a treshold of 40, this can be whatever you like. I thought an ambient temp of 40 degrees would be considered hot (e.g. I want it to be red and not green) feel free to add whatever tresholds you like.

9. Now click on the **Save icon**, also set the refresh interval to 5 seconds to make your dashboard refresh in near realtime.

![Grafana](img/graf_save_refresh.jpg)

10. You should now see data on the gauge. If you don't see any values, double check if your Stream Analytics job is running without errors.

![Grafana](img/graf_first_gauge.jpg)


## Adding the other visualizations
If you want to create more gauges, it is easiest to just clone the first gauge we created earlier, modify the query and maybe some other properties.

To clone a gauge perform the following actions:
1. click on the gauge, a small bar with an arrow should appear.
2. Click the arrow, go to **more** and click on **Duplicate**
3. A new clone of your first gauge should now pop up next to the original gauge. 
4. To modify the new gauge click on the same small arrow as in step 1/2 and select **Edit**

![Grafana](img/graf_duplicate_visualization.jpg)

5. Modify the query and if needed settings to your liking. Queries can be found in the SQL directory and are prefixed with "*grafana_*".

## Adding a Graph for Keg volume over time

Let's do something else than a Gauge, let's see how the Beer volume in the keg is behaving over tie.
1. Click on **Add Panel**
2. Click on **Add Query**

![Grafana](img/graf_add_panel.jpg)

3. From the dropdownbox select the correct DataSource (*TweakersDB* if you followed the earlier suggestion).
4. Copy the query from *grafana_keg_volume_over_time.sql* and paste it in the query field.
5. For the Format select **Time Series**.

![Grafana](img/graf_beer_over_time.jpg)

6. Click on the Graph icon 

![Grafana](img/graf_visualization_button.jpg)

7. Now change the following options in the top options box (leave the others default):
    * **FIll**: 1

8. Now change the following options in the Axes options box (leave the others default):
    * **Left Y - Unit**: Volume -> Millilitre (mL)
    * **Label**: Remaining Beer
    * **Right Y - Show**: disabled
9. Now change the following options in the Legend options box (leave the others default):
    * **Values - Min**: Enabled
    * **Values - Max**: Enabled
    * **Values - Current**: Enabled

![Grafana](img/graf_beer_over_time_settings.jpg)

10. If your Stream Analytics job is still running you should now see data coming into your graph (assuming it is still refreshing every 5 secs)
11. You could also change the name of the Panel in the General Settings menu.

![Grafana](img/graf_general_settings.jpg)


## Example dashboard
If you inherited the same names that we suggested during the whole course you can also use our sample dashboard.

The JSON source of the dashboard can be found in the folder Grafana in the file *sample_dashboard.json*.

To Load it create either a new dashboard or modify the one you already created.
To insert the JSON user the following steps:
1. Click on the little gear icon to go to **Dashboard Settings**

![Grafana](img/graf_dashboard_settings.jpg)

2. Click on **JSON Model**.
3. Paste the content of the *sample_dashboard.json* over the existing JSON code.
4. Click on **Save changes**


Congratulations you should now have setup a near realtime dashboard in Grafana. :)


*reminder this is not neccesarily setup according to best practices. Please feel free to give your feedback or ideas on how we can improve this workshop.