with deltas as (

SELECT
topic, ts, 

ts - lag(ts,1) over w as DelatT
 
FROM 

bb.messages

WHERE

ts >= current_timestamp - interval '1 day' and ts < current_timestamp

window w as ( partition by topic order by ts)

)

select 
topic,
avg(DelatT) as Average_periodicity

From deltas 

WHERE

deltas.DelatT is not null

group by topic

limit 10;
