CREATE OR REPLACE  FUNCTION   stats.GenStats  (

topic integer, Tstart TimestampTZ, Tend TimestampTZ


) returns  TABLE (topic integer, ts TimestampTZ, Max double precision, Min double precision,

                  stddev  double precision, var double precision, Mean double precision, 

                  lower_bound double precision, upper_bound double precision, count bigint,

                  Q2_Median double precision, Q3 double precision,Q1 double precision,

                  P10 double precision,P90 double precision)

Language sql strict stable as 


$$
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
    count(*) as count,

	percentile_disc(0.5) within group ( order by numeric_value ) as Q2_Median,
  percentile_disc(0.75) within group (order by numeric_value) as Q3,
 	percentile_disc(0.25) within group (order by numeric_value) as Q1,
  percentile_disc(0.1) within group (order by numeric_value) as P10,
  percentile_disc(0.9) within group (order by numeric_value) as P90


FROM  bs.numerics
 
 where 
 topic = $1
 
  AND  ts > date_trunc ('hour',$2 ) 

  and ts < date_trunc('hour',$3)
 
 group by topic,date_trunc('hour', ts)
 order by topic,date_trunc('hour', ts) 

 $$;


