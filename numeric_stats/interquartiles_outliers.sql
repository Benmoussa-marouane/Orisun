
--outliers percentage 
With otl as 
(
SELECT  

S.topic, S.ts , count(N.numeric_value) as outliers


FROM

stats.GenStats(450524,current_timestamp - interval '1 week', current_timestamp )  S 

left join bs.numerics N on N.topic = S.topic  

and N.ts >= S.ts AND  N.ts <  S.ts + interval '1 hour' 

and N.ts  > date_trunc('hour', current_timestamp) - interval '1 week'

and (N.numeric_value <   (Q1 - 1.5* (Q3-Q1)) OR N.numeric_value  >(Q3 + 1.5* (Q3-Q1)))

WHERE 
s.topic = 450524

group by S.topic, S.ts
order by S.topic, S.ts 

)

SELECT

(sum(count(tt.outliers)) * 1.0 ) as percentage 

from otl tt
;

