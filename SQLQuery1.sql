-- declare: It creates new variable.
--general using : declare @variablevaluename nvarchar(10):
--set @varialevaluename =  'Hasbi'

declare @WholeName nvarchar(30) = 'Hasbi'; 
print @WholeName

declare @SumFileCount int  
select @SumFileCount = COUNT(*) from DimProduct
print @SumFileCount

--This is how we can create a variable table (it does not exist after we execute it)
declare @Personel table 
(ID int,
Name nvarchar(50) not null,
Surname nvarchar(50) not null
)
insert into @Personel(ID,Name,Surname)values(1,'Mehmet Hasbi','Kaynak')

--select * from @Personel

update @Personel set Name='Olaf' where ID=1

--select * from @Personel

delete @Personel where ID= 1
select * from @Personel

-- Using IF statement , it starts with begin and ends with end
declare @UserName nvarchar(20), @Password nvarchar(20)
set @UserName = 'Hasbi' 
set @Password = '123456'
if @UserName = 'Hasbi' and @Password = '123456'
begin
print 'You`ve been logged in successfully'
end
else
begin 
print'Error occurred, please try again'
end

declare @SumofRegistry int
select @SumofRegistry = count(*) from Production.Product

if @SumofRegistry <= 100
begin
print'Sum of Registry count is less or equels to 100'
end
else if @SumofRegistry >=100 and @SumofRegistry <=200
begin
print 'Sum of Registry count is beetwen 100 and 200'
end 
else 
begin
print 'Sum of Registry count is greater than 200'
end

--this is how we can use the case statement

select Name,Color from Production.Product  
select distinct color from Production.Product
 


select name,
(case color
when 'Black' then 'Siyah'
when 'Blue' then 'Mavi'
when 'Grey' then 'Gri'
when 'Multi' then 'MultiColor'
when 'Red' then 'Kirmizi'
when 'Silver' then 'Gumus'
when 'Silver/Black' then 'Gumus/Siyah'
when 'White' then 'Beyaz'
when 'Yellow' then 'Sari'
when 'NULL' then 'Renksiz'
else 'Renk tanimi yapimamis'
end ) as Renkler
from Production.Product

--while loop

declare @name nvarchar(50) = 'Mehmet Hasbi KAYNAK'
declare @recorder int = 0

while @recorder <= len(@name)
begin
print substring(@name,1,@recorder)
set @recorder = @recorder + 1
end 
print 'While loop has been done'

--using temp table

create table #Personel 
(id int primary key,
name nvarchar(50) not null,
surname nvarchar(50) not null
)

insert into #Personel (ID,Name,Surname) values(1,'Mehmet Hasbi','Kaynak')
insert into #Personel (ID,Name,Surname) values(2,'Olaf','Viking')

select * from #Personel

update #Personel
set
name = 'Hasbi' 	
where 
id=1

delete #Personel
where 
id=1

--tsql using try catch 

begin try
insert into #Personel (id) values ('poop')
end try
begin catch
print'something went wrong'
end catch

--using functions that we create

create function ProductIDGetName(@ID int)
returns nvarchar(200) 
as
begin

declare @FoundName nvarchar(200)

if(exists(select * from Production.Product where ProductID = @ID))
begin
select @FoundName = Name from Production.Product where ProductID = @ID
end

else
begin
set @FoundName = 'There is no such value'
end

return @FoundName	
end 

select dbo.ProductIDGetName(2)


-- this returns a request function
create function IDProduct(@ID int)
returns table
as 
return (select * from Production.Product where ProductID = @ID)

select * from dbo.IDProduct(1)

--this returns a variale table function
create function Person()
returns @PersonelTable table
(ID int,
Name nvarchar(50),
Surname nvarchar(50)
)
as
begin
insert into @PersonelTable(ID,Name,Surname) values (1,'Hasbi','Kaynak')
return
end

select * from dbo.person()

--what is trigger?

create database myworksheet

create table Personel
(id int,
name nvarchar(50),
surname nvarchar(50)
)

select * from Personel

insert into Personel(id,name,surname)values(1,'Hasbi','Kaynak')

insert into Personel(id,name,surname)values(2,'Olaf','Viking')

create trigger triggerafterinsertnewpersonel
on Personel
after insert
as
begin
select 'New personel has been added'
end

--trigger 2

create trigger triggerdeletepersonel
on Personel
after delete
as
begin
select'Personel has been deleted'
end

create trigger triggerafterupdatepersonel
on personel
after update
as 
begin
select'Personel has been updated'
end

alter trigger triggerdeletepersonel
on Personel
after delete
as
begin
select'Personel has been deleted.'
end

drop trigger triggerdeletepersonel


update Personel 
set 
name='Mehmet'
where id=1

delete Personel where id =2

create table Costumer
(id int,
name nvarchar(20),
surname nvarchar(20),
email nvarchar(200),
age int
)
select * from Costumer

create trigger CostumerAgeControl
on Costumer
for insert
as
begin
if exists(select * from inserted where age <20 )
begin
raiserror('Costumers at least must have  20 age',1,1)
rollback transaction
return	
end
end

insert into Costumer(id,name,surname,email,age)values(1,'Hasbi','Kaynak','hasbi.kaynak@gmail.com',24)
