-- Missing values

CREATE OR REPLACE  FUNCTION   stats.Missing   (

topic in integer, Tstart in  TimestampTZ, Tend in  TimestampTZ, 

missing_count out bigint, Percentage_Missing out double precision

) 

Language sql strict stable as 


$$ 

With Data as 
(
  SELECT
  date_trunc('hour', ts) as ts,
  count(*) as n

FROM bs.numerics

where 
 topic = $1
 
  AND  ts >= date_trunc ('hour',$2 ) 

  and ts < date_trunc('hour',$3)

 group by date_trunc('hour', ts)

)
select 

count(t) - count(d.n) as missing_count,

( (count(t) - count(d.n)) / cast (count(t) as double precision) ) * 100 as Percentage_Missing 

From  generate_series(date_trunc ('hour',$2 ) , date_trunc ('hour',$3 ) - interval '1 hour' ,'1 hour') as t 

left join Data  d on d.ts = t 



 $$;



