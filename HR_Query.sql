
----Investigating the data
select *
from HR..Absenteeism_at_work

select *
from HR..compensation

select *
from HR..Reasons

----Looking at the different reasons staff were absent
select distinct Reason_for_absence
from HR..Absenteeism_at_work

----Looking at the main reason staff were absent
select Reason_for_absence,
sum(cast(Absenteeism_time_in_hours as int)) Total_hours
from HR..Absenteeism_at_work
group by Reason_for_absence
order by sum(cast(Absenteeism_time_in_hours as int)) desc


----Looking at max transportation expense and absenteeism
select max(Transportation_expense) max_transport,
min(Transportation_expense) min_transport,
max(Distance_from_Residence_to_Work) max_distance,
min(Distance_from_Residence_to_Work) min_distance
from HR..Absenteeism_at_work


----Looking at age bracket and absenteeism
select case when Age >= 20 and Age <30 then 'Youth'
when Age >= 30 and Age <40 then 'Middle age'
when Age >=40 and Age < 50 then 'Mature'
when Age >=50 then 'Old'
else 'Child'
end as Age_Bracket,
sum(cast(Absenteeism_time_in_hours as int)) Total_hours
from HR..Absenteeism_at_work
group by case when Age >= 20 and Age <30 then 'Youth'
when Age >= 30 and Age <40 then 'Middle age'
when Age >=40 and Age < 50 then 'Mature'
when Age >=50 then 'Old'
else 'Child'
end
order by Total_hours desc

----Looking at BMI, Average Transportation costs and absenteeism average hours
select case when Body_mass_index < 18.5 then 'Underweight'
when Body_mass_index >= 18.5 and Body_mass_index < 25 then 'Normal Weight'
when Body_mass_index >=25 and Body_mass_index <30 then 'Overweight'
when Body_mass_index >=30 and Body_mass_index <35 then 'Obese Class 1'
when Body_mass_index >=35 and Body_mass_index <40 then 'Obese Class 2'
when Body_mass_index >=40 then 'Morbidly Obese'
end as Weight_Class,
avg(Transportation_expense) Average_Transport,
avg(cast(Absenteeism_time_in_hours as int)) Average_hours
from HR..Absenteeism_at_work
group by case when Body_mass_index < 18.5 then 'Underweight'
when Body_mass_index >= 18.5 and Body_mass_index < 25 then 'Normal Weight'
when Body_mass_index >=25 and Body_mass_index <30 then 'Overweight'
when Body_mass_index >=30 and Body_mass_index <35 then 'Obese Class 1'
when Body_mass_index >=35 and Body_mass_index <40 then 'Obese Class 2'
when Body_mass_index >=40 then 'Morbidly Obese'
end 
order by Average_hours desc


----CREATE A JOIN TABLE
select *
from HR..Absenteeism_at_work ab
left join HR..compensation cm
on ab.ID=cm.ID
left join HR..Reasons rn
on ab.Reason_for_absence=rn.Number


----Question; Provide a list of the 100 healthiest individuals to give a bonus
select *
from HR..Absenteeism_at_work ab
where ab.Social_drinker = 0 and ab.Social_smoker = 0
and ab.Body_mass_index < 25
and Absenteeism_time_in_hours < 
(select avg(cast(Absenteeism_time_in_hours as int)) from HR..Absenteeism_at_work)


----Question; Compenation rate increase for non-smokers, budget = 983221, 0.68 increase per hour, $1414.4 per year per employee

select count(*) as Non_Smokers
from HR..Absenteeism_at_work ab
where ab.Social_smoker = 0

-----to optimize the query
select 
ab.ID Employee_ID,
rn.Reason Reason,
ab.Month_of_absence Month_of_absence,
ab.Body_mass_index BMI,
case when ab.Body_mass_index < 18.5 then 'Underweight'
		when ab.Body_mass_index >= 18.5 and ab.Body_mass_index < 25 then 'Normal Weight'
		when ab.Body_mass_index >=25 and ab.Body_mass_index <30 then 'Overweight'
		when ab.Body_mass_index >=30 and ab.Body_mass_index <35 then 'Obese Class 1'
		when ab.Body_mass_index >=35 and ab.Body_mass_index <40 then 'Obese Class 2'
		when ab.Body_mass_index >=40 then 'Morbidly Obese'
		end as Weight_Class,

case when ab.Month_of_absence in (12,1,2) then 'Winter'
	when ab.Month_of_absence in (3,4,5) then 'Spring'
	when ab.Month_of_absence in (6,7,8) then 'Summer'
	when ab.Month_of_absence in (9,10,11) then 'Autumn'
	else 'Unknown' end as Season,

ab.Absenteeism_time_in_hours,
ab.Day_of_the_week,
ab.Distance_from_Residence_to_Work,
ab.Education,
ab.Son,
ab.Transportation_expense,
ab.Social_drinker,
ab.Social_smoker,
ab.Work_load_Average_day,
ab.Age,
ab.Disciplinary_failure

from HR..Absenteeism_at_work ab
left join HR..compensation cm
on ab.ID=cm.ID
left join HR..Reasons rn
on ab.Reason_for_absence=rn.Number





