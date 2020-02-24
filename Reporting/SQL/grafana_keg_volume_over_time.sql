-- Please do not copy this comment!
-- You should replace the device_name, to match the device you want to so data of.
-- beta-bl8 = alchololic beer
-- gamma-bl8 =  non-alcoholic beer

-- This query returns a time series that shows the remaining volume in the keg over a certain time period.

SELECT
  $__timeEpoch([time]),
  [keg_volume] as value
FROM
  [dbo].[BeerTemperature]
WHERE
  $__timeFilter([time])
AND
  [device_name] = 'beta-bl8'
ORDER BY
  [time] ASC
