-----------------------------------------------------------
--Add this part to the bottom of the queries from part 1---
-----------------------------------------------------------
SELECT
	data.[state].value as state,
    data.[status].value as status,
    data.[duration].value as duration,
    time,
    device_name
INTO BeerPouringArchive
FROM BierIN
WHERE event_type='pouring'

SELECT
	data.[state].value as state,
    data.[status].value as status,
    data.[duration].value as duration,
    time,
    device_name
INTO BeerPouringRealTime
FROM BierIN
WHERE event_type='pouring'