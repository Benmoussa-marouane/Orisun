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

select stddev(numeric_value) as stddev,

       variance(numeric_value) as var,
       
	percentile_cont(0.5) within group ( order by numeric_value ) as Median,

	   count(*) as count

  from bs.numerics

 where topic = 450524

   and ts > current_timestamp - interval '1 week' ;


--over 1 hour in 1 week 

SELECT date_trunc('hour', ts) as ts,
    max(numeric_value) as Max,
    min(numeric_value) as Min,
    stddev(numeric_value) as stddev,
	variance(numeric_value) as var,
	avg(numeric_value) as Mean,
    --count(*) - count(numeric_value)as Missing,
    sum(case when numeric_value = '0'  then 1 else 0 end) as Missing,
    count(*) as count

	percentile_disc(0.5) within group ( order by numeric_value ) as Q2_Median,
    percentile_disc(0.75) within group (order by numeric_value) as Q3,
 	percentile_disc(0.25) within group (order by numeric_value) as Q1,
  	percentile_disc(0.1) within group (order by numeric_value) as P10,
    percentile_disc(0.9) within group (order by numeric_value) as P90
   

FROM  bs.numerics
 
 where topic = 450524
 
   and ts > current_timestamp - interval '1 week'
 
 group by date_trunc('hour', ts)
 order by date_trunc('hour', ts);


