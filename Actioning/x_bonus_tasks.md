# Step X: Bonus Tasks
If you are finished with all the previous tasks/assignments and have time left, then feel free to try out these tasks as well.

## 1. ALERT We are allmost out of beer!
In this a task we will modify the Logic app to also alert on slack when we are almost running out of beer. Off cours we cannot allow it to happen that we run out of beer! So we need to know.

### Modify the stream analytics Job
First you will need to modify the stream analytics job, as it now only sends pouring events to the service bus queue that triggers the logic app. The current volume of the Keg can be found in the "Temperature" messages. Besides that we do not want to trigger our logic app unneccesarily, so the decision wether the volume is too low should be made in the Stream Analytics  job.



### Modify the Logic App
