SELECT
count(*) as NumberOfClasses
FROM

(SELECT
numeric_value
FROM  bs.numerics
where 
topic = 619
group by numeric_value
) as sub

;
