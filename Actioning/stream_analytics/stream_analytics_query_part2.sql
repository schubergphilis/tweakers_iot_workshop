-----------------------------------------------------------
--Add this part to the bottom of the queries from part 1---
-----------------------------------------------------------
SELECT
	data.[state] as state,
    data.[status] as status,
    data.[duration] as duration,
    EventEnqueuedUtcTime as time,
    device_name
INTO BeerPouringArchive
FROM BeerIN
WHERE event_type='pouring'

SELECT
	data.[state] as state,
    data.[status] as status,
    data.[duration] as duration,
    EventEnqueuedUtcTime as time,
    device_name
INTO BeerPouringLive
FROM BeerIN
WHERE event_type='pouring'
