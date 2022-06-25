# 1.Import the csv file to a table in the database.
Create database test;
use test;
select * from `icc test batting figures`;

# 2.Remove the column 'Player Profile' from the table.
ALTER TABLE `icc test batting figures` DROP COLUMN `Player Profile`;

#3.	Extract the country name and player names from the given data 
#and store it in seperate columns for further usage.
alter table `icc test batting figures` 
add  country varchar(20) as 
(trim(")" from (SUBSTRING_INDEX(`Player`, "(",-1))));

# 4.From the column 'Span' extract the start_year 
# and end_year and store them in seperate columns for further usage.
alter table `icc test batting figures` 
add  start_year varchar(20) as 
(SUBSTRING_INDEX(`span`, "-",1));

alter table `icc test batting figures` 
add  end_year varchar(20) as 
(SUBSTRING_INDEX(`span`, "-",-1));


/* 5.The column 'HS' has the highest score scored by the player so far 
in any given match. The column also has details if the player had 
completed the match in a NOT OUT status. Extract the data and 
store the highest runs and the NOT OUT status in different columns.*/
select case when (substr(HS, -1,1) = "*") then HS else null end as `NO` from
`icc test batting figures` ;

select case when (substr(HS, -1,1) != "*") then HS else Null end as `Out` from
`icc test batting figures` ;

alter table `icc test batting figures` 
add  `NO_HS` varchar(20) as 
(case when (substr(HS, -1,1) = "*") then HS else null end);

alter table `icc test batting figures` 
add  `OUT_HS` varchar(20) as 
(case when (substr(HS, -1,1) != "*") then HS else Null end);


# 6.Using the data given, considering the players who were active in the year of 2019, 
-- create a set of batting order of best 6 players using the selection criteria of those who have a 
-- good average score across all matches for India.

select * from
(select *,
rank() over (order by avg desc) as rnk
from `icc test batting figures`
where end_year > 2018
and Country = 'INDIA') as t1
where rnk < 7
;


# 7. Using the data given, considering the players who were active in the year of 2019, 
-- create a set of batting order of best 6 players using the selection criteria of those who have highest number of 100s 
-- across all matches for India.

select * from
(select *,
rank() over (order by `100` desc) as rnk
from `icc test batting figures`
where end_year > 2018
and Country = 'INDIA') as t1
where rnk < 7
;


# 8.Using the data given, considering the players who were active in the year of 2019, 
-- create a set of batting order of best 6 players using 2 selection criterias of your own for India.

select * from
(select *,
rank() over (order by Runs desc) as rnk
from `icc test batting figures`
where end_year > 2018
and Country = 'INDIA'
order by Avg desc) as t1
where rnk <7
;


#9.	Create a View named ‘Batting_Order_GoodAvgScorers_SA’ using the data given, 
-- considering the players who were active in the year of 2019, create a set of batting order of best 6 players 
-- using the selection criteria of those who have a good average score across all matches for South Africa.

create view `Batting_Order_GoodAvgScorers_SA` as (
 select * from
(select *,
rank() over (order by avg desc) as rnk
from `icc test batting figures`
where end_year > 2018
and Country = 'sa') as t1
where rnk <7 );

select * from `Batting_Order_GoodAvgScorers_SA` ;

#10.	Create a View named ‘Batting_Order_HighestCenturyScorers_SA’ Using the data given,
--  considering the players who were active in the year of 2019, create a set of batting order of best 6 players
--  using the selection criteria of those who have highest number of 100s across all matches for South Africa.

create view `Batting_Order_HighestCenturyScorers_SA` as (
 select * from
(select *,
rank() over (order by `100` desc) as rnk
from `icc test batting figures`
where end_year > 2018
and Country = 'sa') as t1
where rnk <7 );


select * from `Batting_Order_HighestCenturyScorers_SA`;