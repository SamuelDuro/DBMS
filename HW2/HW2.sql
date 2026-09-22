create database coffee_shop_db;
use coffee_shop_db;

set foreign_key_checks = 0;

-- Relational Table for Baristas
create table baristas(
baristerID integer(6) not null,
name varchar(40),
experience_level varchar(20),
primary key(baristerID)
);

-- Adjusted column baristaID in the baristas table
alter table baristas rename column baristerID to baristaID;

-- Relational Table for Shops
create table shops(
shopID integer(6) not null,
name varchar(40),
city varchar(20),
primary key(shopID)
);


-- Relational table for pastries
create table pastries(
pastryID integer(6) not null,
name varchar(40),
category varchar(40),
price decimal(10,2),
primary key(pastryID)
);

-- Relationship Set Employs that connects the Baristas Table to Shops
create table employs(
baristaID integer(6) not null,
shopID integer(6) not null,
primary key(baristaID, shopID),
foreign key(baristaID) references baristas(baristaID),
foreign key(shopID) references shops(shopID)
);

-- Relationship Set Offers that connects the Shops table to Pastries
create table offers(
shopID integer(6) not null,
pastryID integer(6) not null,
date_added date,
primary key(shopID, pastryID),
foreign key(shopID) references shops(shopID),
foreign key(pastryID) references pastries(pastryID)
);


-- Problem 1: Average price of pastries for each category
select category, avg(price) as average_price
from pastries
group by category;

-- Problem 2: Total number of baristas at each experience level
select experience_level, count(*) as total_baristas
from baristas
group by experience_level;

-- Problem 3: Total number of shops located in each city
select city, count(*) as total_shops
from shops
group by city;

-- Problem 4: Maximum price among pastries for each category
select category, max(price) as max_price
from pastries
group by category;

-- Problem 5: Count how many pastries have been added to the shop
select shopID, count(pastryID) as total_pastries_offered
from offers
group by shopID;

-- Problem 6: Name, category, and price of pastries whose price matches the maximum price within their category
select name, category, price
from pastries p
where price = (
		select max(price)
        from pastries 
        where category = p.category);

-- Problem 7: Unique shop IDs from offers that have offered at least one pastry priced strictly greater than the overall average price
select distinct shopID
from offers
where pastryID in (
		select pastryID
        from pastries
        where price > (
			select avg(price)
            from pastries
		  )
	    );
        
-- Problem 8: Shop ID and pastry ID for records in offers with the earliest date_added
select shopID, pastryID
from offers
where date_added = (
           select min(date_added)
           from offers);
           
-- Problem 9: Shop ID(s) offering the highest number of pastries
select shopID
from offers
group by shopID
having count(*) >= all (
        select count(*)
        from offers
        group by shopID);
        
-- Problem 10: Names of baristas who work at shops located in 'Seattle' using nested subqueries
select name
from baristas
where baristaID in (
         select baristaID
         from employs
         where shopID in (
               select shopID
               from shops
               where city = 'Seattle'
                           )
		                      );





