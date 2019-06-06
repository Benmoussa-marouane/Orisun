with result as
(
SELECT

numeric_value, count(*) as classe_frequency


FROM  bs.numerics

where 

topic = 619

group by numeric_value
order by count(*) desc
)

select 

numeric_value as most_frequent

From result 

limit 1;


;

