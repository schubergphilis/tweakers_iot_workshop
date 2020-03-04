# Step X: Bonus Tasks
If you are finished with all the previous tasks/assignments and have time left, then feel free to try out these tasks as well. Keep in mind that these bonus tasks are described with less detail than the rest to keep it a bit more challenging. Otherwise you wouldn't have reached these bonus taks anyway ;)

## 1. ALERT We are almost out of beer!
In this a task we will create another Logic app to also alert on slack when we are almost running out of beer. Off-course we cannot allow it to happen that we run out of beer! So we need to know.

The easiest way to do this is to just add another service bus queue, add another output to the Stream Analytics Job, Deploy another Logic App or Function App/Azure Function.

### Add another queue to the existing service bus namespace
You can add another queue to the existing service bus namespace. 

### Modify the stream analytics Job
First you will need to modify the stream analytics job, as it now only sends pouring events to the service bus queue that triggers the logic app. The current volume of the Keg can be found in the "Temperature" messages. Besides that we do not want to trigger our logic app unneccesarily, so the decision wether the volume is too low should be made in the Stream Analytics  job.

Add another Output for the new service bus queue.
Add another query wher you need to add a "WHERE" clause to only send the message to the output when value of the volume < XXXml.

### Deploy a new Logic App
Just deploy another logic app into your resource group. Would be a waste if you would mess up your existing work.

## 2. Add more visualizations to Grafana.
There are more messages and data send to the SQL database than we have used so far in the course. Feel free to explore these and add visualizations for them in Grafana.
We have provided a list with interesting sensors/data that you can play with:
| Source(Table) | Value | Description |
| ------------- | ----- | ----------- |
| IoStat        | Cooling Comp| this says ON or OFF and tells you if the blade determined that it needs to cool |
| Rall          | fan_pwm | This is how hard the cooling fan is blowing |
| Rall          | tapping_cycle | This is how much beers have been tapped | 
| Rall          | current_keg_volume | Remaining beer in the keg, you can find this one in the Temperature table as wel |
| Rall          | calculated_total_volume | Remaining beer in total (also what is in the cooling system) |
| Rall          | state_locking      | Tells you if the Keg is locked in place | 


## 3. Replace Logic App with a Function App
If you have more of a developer background, you could ofcourse create an Azure Function to replace the Logic App. We only chose to use a logic app because we could have attendees that have no programming experience at all, or not everybody has the same programming language preference as we do. So that would be a lot of work for us.

However you are free to create a Function App to do reach the same goal.
