-- Please do not copy this comment!
-- You should replace the device_name, to match the device you want to so data of.
-- beta-bl8 = alchololic beer
-- gamma-bl8 =  non-alcoholic beer

-- This query returns the Keg Temperature in Celcius

SELECT [keg_temperature]
  FROM [dbo].[BeerTemperature]
  where [time] = (SELECT MAX([time]) FROM [dbo].[BeerTemperature] WHERE [device_name] = 'beta-bl8')
  AND [device_name] = 'beta-bl8'
