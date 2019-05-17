-- most frequent 
 --SELECT 		
-- 	mode() WITHIN GROUP (ORDER BY numeric_value) as Most_Frequent 
--FROM		
--		bs.numerics

-- where topic = 450524

 --  and ts > current_timestamp - interval '1 week' ;


--median percentiles

 	--SELECT 		
	--	percentile_disc(0.5) within group ( order by numeric_value ) as Median
	--FROM		
	--	bs.numerics

 --where topic = 450524

  -- and ts > current_timestamp - interval '1 week' ;


--standard deviationn, variance over 1 week

--select stddev(numeric_value) as stddev,

      -- variance(numeric_value) as var,
       
	--percentile_cont(0.5) within group ( order by numeric_value ) as Median,

	--   count(*) as count

  --from bs.numerics

 --where topic = 450524

   --and ts > current_timestamp - interval '1 week' ;


--over 1 hour in 1 week 
CREATE OR REPLACE  VIEW  BS.v_stats as 

SELECT
topic,
 date_trunc('hour', ts) as ts,
    max(numeric_value) as Max,
    min(numeric_value) as Min,
    stddev(numeric_value) as stddev,
	variance(numeric_value) as var,
	avg(numeric_value) as Mean,
	(AVG(numeric_value) - STDDEV_SAMP(numeric_value) * 2) as lower_bound,
     (AVG(numeric_value) + STDDEV_SAMP(numeric_value) * 2) as upper_bound,
    --count(*) - count(numeric_value)as Missing,
   --COUNT(IIF(numeric_value = '0', 'truish', NULL)),
    count(*) as count,
    --count(CASE WHEN  numeric_value = 1 THEN 1  END) as Missing,

	percentile_disc(0.5) within group ( order by numeric_value ) as Q2_Median,
    percentile_disc(0.75) within group (order by numeric_value) as Q3,
 	percentile_disc(0.25) within group (order by numeric_value) as Q1,
  	percentile_disc(0.1) within group (order by numeric_value) as P10,
    percentile_disc(0.9) within group (order by numeric_value) as P90

FROM  bs.numerics
 
 where --topic = 450524
 
  ts > date_trunc ('hour',current_timestamp ) - interval '1 week'  

  and ts < date_trunc('hour',current_timestamp)
 
 group by topic,date_trunc('hour', ts)
 order by topic,date_trunc('hour', ts);



-- display of the view 

select * from bs.v_stats where topic = 450524; 


--outliers percentage 

SELECT  

S.topic, S.ts , count(N.numeric_value) 

FROM

BS.v_stats S 

left join bs.numerics N on N.topic = S.topic  

and N.ts BETWEEN S.ts  and S.ts + interval '1 hour' 

and N.ts  > date_trunc('hour', current_timestamp) - interval '1 week'

and (N.numeric_value <   (Q1 - 1.5* (Q3-Q1)) OR N.numeric_value  >(Q3 + 1.5* (Q3-Q1)))

WHERE 
s.topic = 450524

group by S.topic, S.ts
order by S.topic, S.ts ;


