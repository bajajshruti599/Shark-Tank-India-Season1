
--Display entire records

select * from SharkTank..Dataset1

--Display Total Episodes including multiple records

select EpNo from SharkTank..Dataset1

--Total Episodes exclude duplicate records

select distinct(EpNo) from SharkTank..Dataset1

--Display Total number of episodes

select count(distinct(EpNo)) from SharkTank..Dataset1
select max(EpNo) from SharkTank..Dataset1

--Number of brands pitches on the show

select count(distinct(Brand)) from SharkTank..Dataset1

--Display 2 columns where first one show How many startups got funding from Sharks and How many startups actually piched on the show 

select sum(a.converted_not_converted) Funding_received, count(*) total_pitches from (
select AmountInvestedLakhs, case when AmountInvestedLakhs>0 then 1 else 0 end as converted_not_converted from SharkTank..Dataset1)a

--Calculate what is the success percentage of Startups received funding with Total startups pitched on the show

select cast(sum(a.converted_not_converted)as float)/ cast(count(*)as float)*100 Success_Percentage from (
select AmountInvestedLakhs, case when AmountInvestedLakhs>0 then 1 else 0 end as converted_not_converted from SharkTank..Dataset1)a

--Total Male

Select sum(male) from SharkTank..Dataset1

--Total Female

Select sum(Female) from SharkTank..Dataset1

--Gender Ratio of Male:Female

Select (sum(Female)/sum(male)) from SharkTank..Dataset1

--Total Amount Invested by Sharks in Startups

select sum(AmountInvestedlakhs) from SharkTank..Dataset1
 
--Average Equity taken by Sharks from Startups

--select Avg(EquityTaken) from SharkTank..Dataset1

select avg(a.EquityTaken) from (
select * from SharkTank..Dataset1 where EquityTaken > 0) a

select avg(EquityTaken) from SharkTank..Dataset1

--Highest deal taken
select max(AmountInvestedLakhs) from SharkTank..Dataset1

--highest Equity taken
select max(EquityTaken) from SharkTank..Dataset1

--Startups having atleast 1 woman

select sum(a.female_count) from (
select Female, case when Female>0 then 1 else 0 end as female_count from SharkTank..Dataset1)a

-- Display Number of No Deals

select count(*) from SharkTank..Dataset1
where Deal = 'No Deal' 

--Pitches converted into Deal

select a.*, case when female>0 then 1 else 0 end as Female_count from(	
select * from SharkTank..Dataset1 where Deal!='No Deal')a

--Pitches converted into Deal having 'atleast 1 women'

select sum(b.Female_count) from (
select case when female>0 then 1 else 0 end as Female_count,a.* from(	
select * from SharkTank..Dataset1 where Deal!='No Deal')a)b

--Average Team members

select avg(teammembers) from SharkTank..Dataset1

--Amount invested per deal
select avg(a.AmountInvestedLakhs) AmountInvestedPerDeal from(
select * from SharkTank..Dataset1
where Deal!='No Deal')a

--Average age group of contestants
select * from SharkTank..Dataset1;
select Avgage, count(Avgage) Count_of_Avgage from SharkTank..Dataset1 group by Avgage

--Display count of number of contestants came from different locations

select Location, count(Location) ContestantsCount_from_Location from SharkTank..Dataset1 
group by Location
order by ContestantsCount_from_Location desc

--Display the count of number of sectors startups came in show
select Sector, count(Sector) Sector_count from SharkTank..Dataset1
group by Sector
order by Sector_count desc

--Partners Deals

select Partners, count(Partners) Partners_count from SharkTank..Dataset1
where Partners!='-'
group by Partners
order by Partners_count desc

--Making a Matrix

--Null in columns show in the dataset, which represent Total Deals when Ashneer was present
--Here Not null constraint is used for to allow the field(column) donot store null values
select 'Ashneer'as Keyy,count(AshneerAmountInvested) from SharkTank..Dataset1 where AshneerAmountInvested is not null

--Here Not null constraint is used for to allow the field(column) donot store null values and donot store zeroes that means will give you Total deals done by Ashneer,because 
--it will remove zeroes and Null values
select 'Ashneer'as Keyy,count(AshneerAmountInvested) from SharkTank..Dataset1 where AshneerAmountInvested is not null and AshneerAmountInvested > 0;

--Will display Total Amount Invested by Ashneer and Avg Equity Taken by Ashneer
select 'Ashneer'as Keyy,sum(AshneerAmountInvested),avg(e.AshneerEquityTaken)
from (Select * from SharkTank..Dataset1 where AshneerEquityTaken>0 and AshneerEquityTaken is not null)e


select m.keyy,m.Total_Deals_Present,m.Ashneer_Total_Deals,n.Amt_Invested,n.AvgEquityTaken from

(select a.Keyy, a.Total_Deals_Present,b.Ashneer_Total_Deals from(

select 'Ashneer'as Keyy,count(AshneerAmountInvested) Total_Deals_Present from SharkTank..Dataset1 where AshneerAmountInvested is not null)a

inner join(
select 'Ashneer'as Keyy,count(AshneerAmountInvested) Ashneer_Total_Deals from SharkTank..Dataset1 
where AshneerAmountInvested is not null and AshneerAmountInvested > 0)b
on a.keyy = b.Keyy)m

inner join
(
select 'Ashneer'as Keyy,sum(AshneerAmountInvested) Amt_Invested,avg(e.AshneerEquityTaken) AvgEquityTaken
from (Select * from SharkTank..Dataset1 where AshneerEquityTaken>0 and AshneerEquityTaken is not null)e)n
on m.keyy = n.Keyy;


--which is the startup in which the highest amount has been invested in each domain/sector 
--Ranking all the startups on the basis of amount invested which are present into different domain 

select c.* from
(select brand,sector,amountinvestedlakhs, rank() over (partition by sector order by amountinvestedlakhs desc) rnk from SharkTank..Dataset1)c
where c.rnk = 1