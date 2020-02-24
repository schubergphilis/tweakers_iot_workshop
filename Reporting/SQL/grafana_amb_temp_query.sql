-- Please do not copy this comment!
-- You should replace the device_name, to match the device you want to so data of.
-- beta-bl8 = alchololic beer
-- gamma-bl8 =  non-alcoholic beer

-- This query returns the abient Temperature in Celcius.

SELECT [amb_temperature] as [Ambient Temperature in Celcius]
  FROM [dbo].[BeerTemperature]
  where [device_name] = 'beta-bl8'
  AND [time] = (SELECT MAX([time]) FROM [dbo].[BeerTemperature] WHERE [device_name] = 'beta-bl8')
