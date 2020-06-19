


Create table users(
username varchar(20),
password varchar(20),
first_name varchar(20), 
last_name varchar(20),
email varchar(50),
PRIMARY KEY(username))

go
create table User_mobile_numbers(
username varchar(20),
mobile_number varchar(20),
PRIMARY KEY(username,mobile_number),
FOREIGN KEY(username) REFERENCES users on delete cascade on update cascade 
)

go
create table User_Addresses(
address  varchar(100) ,
username varchar(20),
PRIMARY KEY(address,username),
FOREIGN KEY(username) REFERENCES users on delete cascade on update cascade )



go
create table  Customer(
username varchar(20), 
points decimal(10,2) default 0,
PRIMARY KEY(username),
FOREIGN KEY(username) REFERENCES users on delete cascade on update cascade )

go
create table Admins(
username varchar(20),
PRIMARY KEY(username),
FOREIGN KEY(username) REFERENCES users on delete cascade on update cascade )



go
create table Vendor(
username varchar(20), 
activated bit default 0,
company_name varchar(20), 
bank_acc_no  varchar(20) , 
admin_username varchar(20),
PRIMARY KEY(username),
FOREIGN KEY(username) REFERENCES users  ,
FOREIGN KEY(admin_username) REFERENCES admins )



go
Create table Delivery_person(
username varchar(20) , 
is_activated Bit default 0,
primary key (username) , 
foreign key (username) references users on delete cascade on update cascade );


go
Create table Credit_card(
number varchar(20),
expiration_date date,
cvv_code varchar(4),
primary key(number));


go
Create table Delivery(
id int identity,
type varchar(20),
time_duration int,
fees decimal(5,3),
username varchar(20),
primary key (id),
foreign key(username) references Admins );

go
 create table GiftCard(
 code varchar(10) primary key, 
 expiry_date datetime , 
 amount int,
username VARCHAR(20) FOREIGN KEY REFERENCES Admins 

);

go
Create table Orders(
order_no int identity ,
order_date date,
total_amount decimal(10,2), 
cash_amount decimal(10,2), 
credit_amount decimal(10,2),
payment_type varchar(20), 
order_status varchar(20),
remaining_days int,
time_limit datetime,
Gift_Card_code_used varchar(10),
customer_name varchar(20),
delivery_id int, 
creditCard_number varchar(20),
primary key(order_no),
foreign key(Gift_Card_code_used) references GiftCard on update cascade,
foreign key(customer_name) references Customer on update cascade ,
foreign key (delivery_id) references Delivery on delete set null on update cascade ,
foreign key (creditCard_number) references Credit_Card );


go
create table Product(
serial_no int identity ,
product_name varchar(20),
category varchar(20),
product_description text,
price decimal(10,2),
final_price decimal(10,2), 
color varchar(20),
available bit,
rate int ,
vendor_username varchar(20),
customer_username varchar(20),
customer_order_id int ,
primary key(serial_no),
foreign key(vendor_username) references Vendor  ,
foreign key (customer_username) references Customer,
foreign key (customer_order_id) references Orders on delete set null on update cascade  );


go
Create table CustomerAddstoCartProduct(
serial_no int,
customer_name varchar(20),
primary key(serial_no,customer_name),
foreign key(serial_no) references Product on delete cascade on update cascade ,
foreign key(customer_name) references Customer );


go
Create table Todays_Deals (
deal_id INT identity,
deal_amount INT, 
expiry_date DATETime, 
admin_username VARCHAR(20), 
PRIMARY KEY(deal_id), 
FOREIGN KEY(admin_username) REFERENCES Admins 

);


go
Create table Todays_Deals_Product (
deal_id INT, 
serial_no INT, 
PRIMARY KEY(deal_id,serial_no), 
FOREIGN KEY(deal_id) REFERENCES Todays_Deals on delete cascade on update cascade , 
FOREIGN KEY(serial_no) REFERENCES Product on delete cascade on update cascade
);

go
Create table offer(
offer_id INT identity, 
offer_amount INT, 
expiry_date DATEtime,
PRIMARY KEY(offer_id) 
)


go
Create table offersOnProduct(
offer_id  INT,
serial_no INT,
PRIMARY KEY(offer_id,serial_no), 
FOREIGN KEY(offer_id) REFERENCES offer on delete cascade on update cascade , 
FOREIGN KEY(serial_no) REFERENCES Product  on delete cascade on update cascade
);

go
Create table Customer_Question_Product(
serial_no INT,
customer_name VARCHAR(20),
question TEXT, 
answer TEXT, 
PRIMARY KEY (serial_no,customer_name),
FOREIGN KEY(serial_no) REFERENCES Product on delete cascade on update cascade ,
FOREIGN KEY(customer_name) REFERENCES Customer 
);

go
create table Wishlist(
username varchar(20) FOREIGN key REFERENCES Customer on delete cascade on update cascade,
name VARCHAR(20),
PRIMARY KEY(username,name)
 );



go
CREATE table Wishlist_Product(
username VARCHAR(20),
 wish_name VARCHAR(20),
 serial_no int FOREIGN key REFERENCES Product on delete cascade on update cascade  , 
PRIMARY KEY(username,wish_name,serial_no) ,
FOREIGN KEY(username,wish_name) REFERENCES Wishlist  ,
);


go
create table Admin_Customer_Giftcard ( 
code varchar(10) FOREIGN KEY  REFERENCES GiftCard on delete cascade on update cascade ,
customer_name VARCHAR(20) FOREIGN key REFERENCES Customer on delete cascade on update cascade , 
admin_username VARCHAR(20) FOREIGN key REFERENCES Admins  ,
remaining_points decimal(10,2),
PRIMARY KEY(code,customer_name,admin_username)
);


go
create table Admin_Delivery_Order(

delivery_username VARCHAR(20) FOREIGN key REFERENCES Delivery_person ,
order_no int FOREIGN key  REFERENCES Orders ,
admin_username VARCHAR(20) FOREIGN KEY REFERENCES  Admins ,
delivery_window varchar(50) ,
PRIMARY KEY(delivery_username,order_no),
);

go
create TABLE Customer_CreditCard(
    customer_name VARCHAR(20),
    cc_number varchar(20) ,
    FOREIGN KEY (customer_name) REFERENCES Customer on delete cascade on update cascade ,
    FOREIGN key (cc_number) REFERENCES Credit_Card on delete cascade on update cascade ,
    PRIMARY KEY(customer_name,cc_number)
);



--------------USERS 
go
Create proc customerRegister 
@username varchar(20),
@first_name varchar(20),
@last_name varchar(20),
@password varchar(20),
@email varchar(50) 
As
Insert into users(username,first_name,Last_name,password,email) 
VALUES (@username , @first_name ,@last_name,@password,@email ) 
Insert into Customer(username) Values (@username)



GO
Create proc vendorRegister 
@username varchar(20),
@first_name varchar(20), 
@last_name varchar(20),
@password varchar(20),
@email varchar(50), 
@company_name varchar(20),
@bank_acc_no varchar(20)
AS
Insert into users(username,first_name,last_name, password,email) VALUES (@username , @first_name ,@last_name,@password,@email ) 
insert into vendor(username,company_name,bank_acc_no) values (@username,@company_name ,@bank_acc_no);


GO
create PROC userLogin  
@username varchar(20), 
@password varchar(20) ,
@success bit OUTPUT,
@type int OUTPUT
AS
if EXISTS(SELECT * from Users where username=@username and password=@password)
begin
SET
@success='1'

if EXISTS (SELECT * from Customer where username=@username ) 
begin
SET @type=0
end
ELSE
begin
if EXISTS (SELECT * from Vendor where username=@username )
begin
SET @type=1
end
ELSE
begin
if EXISTS (SELECT * from Admin where username=@username )
begin
SET @type=2
end
ELSE
begin
if EXISTS (SELECT * from Delivery where username=@username )
begin
set @type=3
end
end
end
end
end

ELSE
begin
SET @success='0'
set @type=-1
end


 

GO

Create proc addMobile 
@username varchar(20),
@mobile_number varchar(20)
As
Insert into User_mobile_numbers (username,mobile_number) VALUES (@username , @mobile_number ) ;

  
GO
Create proc addAddress 
@username varchar(20),
@address varchar(100)
As
Insert into User_Addresses (username ,address) VALUES 
(@username ,@address)



--------------Customers
go
 create proc showProducts
 as

 select p.product_name,p.product_description,p.price,p.final_price,p.color
 from product p
 where p.available='1'


 


 go
 create proc  ShowProductsbyPrice
 as 
 select p.product_name,p.product_description ,p.price,p.color from product p
 where p.available='1'
 order by p.price




go
 create proc  searchbyname 
 @text varchar(20)
 as
 select p.product_name,p.product_description,p.price,p.final_price,p.color 
 from product p where p.product_name LIKE '%' + @text + '%' and p.available='1'
 
 
GO
 create proc  AddQuestion  
 @serial int,
 @customer varchar(20), 
 @Question varchar(50)
 as 
 insert into Customer_Question_Product (serial_no ,customer_name ,question)  
 values (@serial, @customer, @Question)
  
  

GO
 create proc addToCart 
 @customername varchar(20), @serial int 
 as
 declare @av bit 
 select @av=available from Product where serial_no=@serial
 if (@av='1')

 begin

 insert into CustomerAddstoCartProduct (serial_no,customer_name)
 values(@serial,@customername)
 end

go
 create proc removefromCart
  @customername varchar(20), @serial int 
  as
 delete from   CustomerAddstoCartProduct where serial_no = @serial and @customername=customer_name

 
GO
 create proc createWishlist 
@customername varchar(20),
@WishList_name varchar(20)
as
insert into Wishlist (username , name) values (@customername , @WishList_name) ;


go
create proc AddtoWishlist
@customername varchar(20), 
@wishlistname varchar(20),
@serial int
as
insert into Wishlist_Product(username,wish_name,serial_no) values(@customername,@wishlistname,@serial);



GO
create proc removefromWishlist
@customername varchar(20),
@wishlistname varchar(20),
@serial int
as
delete from WishList_Product
where WishList_Product.username = @customername And WishList_Product.wish_name = @wishlistname And WishList_Product.serial_no = @serial ;


GO
create proc showWishlistProduct
@customername varchar(20),
@Wish_name varchar(20)
as
Select p.product_name,p.product_description,p.price,p.final_price,p.color
from Product p 
inner join WishList_Product w on w.serial_no = p.serial_no 
where w.username=@customername and w.wish_name=@Wish_name ;


go
create proc viewMyCart
@customer varchar(20)
as
select P.product_name,P.product_description,P.price,P.final_price,P.color from Product P 
Inner join CustomerAddstoCartProduct C ON P.serial_no=C.serial_no
where C.customer_name=@customer ;


go
create proc calculatepriceOrder
@customername varchar(20),
 @sum decimal(10,2) output

as
SELECT @sum=sum(p.final_price) from  Product p
inner join CustomerAddstoCartProduct c on p.serial_no=c.serial_no
WHERE c.customer_name=@customername
print(@sum)
--go 
--declare @sum decimal(10,2)
--execute calculatepriceOrder 'ahmed.ashraf' , @sum output
--print (@sum)

go
create proc productsinorder
@customername varchar(20),
@orderID int 
as
update Product 
set Product.available='0'
where Product.serial_no in( select serial_no from CustomerAddstoCartProduct where customer_name=@customername) 

GO
create proc emptyCart
@customername varchar(20)
as
delete from CustomerAddstoCartProduct 
where customer_name=@customername;


GO



create proc makeOrder
@customername VARCHAR(20)
AS
DECLARE @sum DECIMAL(10,2)

EXECUTE calculatepriceOrder @customername, @sum OUTPUT


INSERT into Orders (total_amount,customer_name,order_date,order_status) VALUES (@sum, @customername,CURRENT_TIMESTAMP,'not processed')


delete from CustomerAddstoCartProduct 
where CustomerAddstoCartProduct.serial_no in
( select p.serial_no from Product p where p.customer_username=@customername  
and CustomerAddstoCartProduct.customer_name <> P.customer_username);

declare @serial_max int

select @serial_max=max(order_no) from Orders

update Product 
set Product.customer_username=@customername , Product.customer_order_id = @serial_max 
where Product.serial_no in (select c2.serial_no from CustomerAddstoCartProduct c2 where c2.customer_name=@customername)




execute productsinorder @customername , @serial_max

execute emptyCart @customername



go

create proc cancelorder
@orderid int 
as
declare @status varchar(20)

select @status=order_status from Orders where order_no=@orderid

if (@status='not processed' or @status='process')

begin
update Product 
set 
available='1',
customer_username =null,
rate=null,
customer_order_id=null
where customer_order_id = @orderid

declare @cash decimal(10,2)
declare @total decimal(10,2)
declare @credit decimal(10,2)
declare @type varchar(20) 

select @cash=cash_amount, @total=total_amount,@credit=credit_amount , @type= payment_type from Orders where order_no=@orderid 
declare @temp decimal(10,2)
if(@type = 'credit')
begin
	set @cash = 0 
end
else
begin
set @credit = 0 


set @temp=@total-@cash-@credit
end
if(@temp !=0)
begin
declare @gift_card_code varchar(10)
declare @customer_name varchar(20)


select @gift_card_code=o.Gift_Card_Code_Used , @customer_name=o.customer_name   from Orders o where o.order_no=@orderid 
declare @expiry_date date 
select @expiry_date=gc.expiry_date from GiftCard gc where @gift_card_code=gc.code

if(DATEDIFF(day, CURRENT_TIMESTAMP,@expiry_date)>=0)
begin
update Customer 
set
points=points+@temp
where Customer.username=@customer_name

DECLARE @admin_username VARCHAR(20)
SELECT @admin_username=g.username from Giftcard  g WHERE @gift_card_code=g.code



update Admin_Customer_Giftcard
set
remaining_points=remaining_points+@temp
where code=@gift_card_code and @customer_name=customer_name and admin_username=@admin_username
  
end
end
end
delete from Orders where @orderid=order_no




go

create proc returnProduct 
@serialno int , @orderid int 
 as
declare @status varchar(20)
declare @price decimal (10,2)


select @status=o.order_status    from Orders o where o.order_no=@orderid
  if (@status='delivered')
  begin
  select @price= p.final_price
 from Product p where serial_no=@serialno and customer_order_id=@orderid

  update Product
  set
  rate=null,
  customer_username=null,
  customer_order_id=null,
  available='1'
  where
  serial_no=@serialno

declare @cash decimal(10,2)
declare @total decimal(10,2)
declare @credit decimal(10,2)
declare @type varchar(20)

select @cash=cash_amount, @total=total_amount,@credit=credit_amount , @type= payment_type 
from Orders where order_no=@orderid 
declare @temp decimal(10,2)
if(@type = 'credit')
begin
	set @cash = 0 
END
else
BEGIN
set @credit = 0 
END

set @temp=@total-@cash-@credit

if(@temp !=0)
begin
declare @gift_card_code varchar(10)
declare @customer_name varchar(20)


select @gift_card_code=o.Gift_Card_Code_Used , @customer_name=o.customer_name   
from Orders o where o.order_no=@orderid 
declare @expiry_date date 
select @expiry_date=gc.expiry_date from GiftCard gc where @gift_card_code=gc.code



if(DATEDIFF(day,CURRENT_TIMESTAMP ,@expiry_date)>=0)
BEGIN
update Customer 
set
points=points+@temp
where Customer.username=@customer_name
DECLARE @admin_username VARCHAR(20)
SELECT @admin_username=g.username from Giftcard  g WHERE @gift_card_code=g.code

update Admin_Customer_Giftcard

set
remaining_points=remaining_points+@temp
where code=@gift_card_code and @customer_name=customer_name 
END
END
update Orders
SET 
Orders.total_amount=total_amount-@price
end

go
Create proc ShowproductsIbought 
@customername varchar(20)
AS
select p.serial_no,p.product_name,p.category,p.product_description,p.price,p.final_price,p.color
from Product p 
where p.customer_username = @customername ; 





go
Create proc rate 
@serialno int, 
@rate int ,
@customername varchar(20)
As
update Product
set rate = @rate
where serial_no=@serialno And customer_username=@customername ; 



go
Create proc SpecifyAmount 
@customername varchar(20),
@orderID int, 
@cash decimal(10,2), 
@credit decimal(10,2)
AS
-- to know the payment method
DECLARE @payment_method VARCHAR(20)
-- to store the amount remaining to see how many points need to be deducted
declare @amount_remaining DECIMAL(10,2)
-- to store the total valueof the order
DECLARE @total DECIMAL(10,2)
SELECT @total=o.total_amount from Orders o WHERE o.order_no=@orderId
if(@cash is null or @cash=0)
BEGIN
SET @payment_method='credit' 
 set @amount_remaining=@total-@credit  
END
ELSE
BEGIn
SET @payment_method='cash' 
 set @amount_remaining=@total-@cash  
END
-- keda dah ma3nah hanedfa3 cash or credit only 
if(@amount_remaining=0)
BEGIN
IF (@payment_method='cash')
begin
UPDATE Orders
SET
cash_amount=@cash,
credit_amount=null,
payment_type=@payment_method
WHERE order_no=@orderID
END
ELSE 
BEGIN
UPDATE Orders
SET
cash_amount=null,
credit_amount=@credit,
payment_type=@payment_method
WHERE order_no=@orderID
END
END
-- keda ma3nah hanedfa3 partially with cash or credit 
ELSE

BEGIN
DECLARE @gift_card_code VARCHAR(10)
SELECT @gift_card_code=code from Admin_Customer_Giftcard WHERE customer_name=@customername
UPDATE Admin_Customer_Giftcard
SET
remaining_points=remaining_points-@amount_remaining
WHERE

customer_name=@customername AND code=@gift_card_code

UPDATE Customer 
SET
points=points-@amount_remaining
WHERE 
username=@customername

UPDATE Orders
set
cash_amount=@cash,
credit_amount=@credit,
payment_type=@payment_method,
Gift_Card_Code_Used=@gift_card_code
WHERE
order_no=@orderID
end



GO
create proc AddCreditCard
@creditcardnumber VARCHAR(20), @expirydate DATE, @cvv VARCHAR(4), @customername VARCHAR(20)
AS
INSERT INTO Credit_card VALUES(@creditcardnumber,@expirydate,@cvv)
INSERT INTO Customer_CreditCard VALUES(@customername,@creditcardnumber)

GO

create proc ChooseCreditCard  @creditcard VARCHAR(20) , @orderid INT
As
update  Orders 
SET
  creditCard_number= @creditcard
 WHERE order_no=@orderid

GO

 CREATE proc vewDeliveryTypes 
 As
 SELECT d.type ,d.time_duration, d.fees from Delivery d
  go
  

GO
 CREATE PROC specifydeliverytype @orderID int , @deliveryID int
 As
 
 DECLARE @delivery_duration INT
 DECLARE @date_of_order DATE
 DECLARE @day INT
 DECLARe @remaining INT
 SELECT @date_of_order=order_date from Orders WHERE order_no=@orderID 
 SELECT @delivery_duration= time_duration from Delivery WHERE id=@deliveryID
 
 SET @day= DATEDIFF(day,@date_of_order,CURRENT_TIMESTAMP) 
 print(@day)
SET @remaining=@delivery_duration-@day
update Orders 
SET
delivery_id =@deliveryID,
remaining_days=@remaining

WHERE order_no=@orderID



GO

create proc trackRemainingDays @orderid int , @customername VARCHAR(20) , @days int OUTPUT
As
DECLARE @delivery_id INT
SELECT @delivery_id=delivery_id from Orders WHERE order_no=@orderid


EXECUTE  specifydeliverytype @orderid ,@delivery_id



SELECT @days=remaining_days FROM Orders WHERE @orderid=order_no 





GO
create proc recommend
@customer_name varchar(20)
AS
declare @category_abl_magib_el_top table ( category varchar(20),coun int)
insert into @category_abl_magib_el_top  select p1.category,count(p1.category) from Product p1  inner join CustomerAddstoCartProduct c on c.serial_no=p1.serial_no 
					where @customer_name = c.customer_name
					group by category
					order by count(category) desc 


declare @top_3_table_category table (category varchar(20),coun int)
insert into @top_3_table_category select top 3 * from @category_abl_magib_el_top


declare @abl_el_akhira table (category varchar(20))
insert into @abl_el_akhira select category from @top_3_table_category

declare @blabla table (seraial_no int , cou int)
insert into @blabla select p.serial_no , count(p.serial_no) from Product p inner join Wishlist_Product w on p.serial_no=w.serial_no where p.category in (select * from @abl_el_akhira) group by p.serial_no order by count(p.serial_no) desc

declare @blabla2 table(serial_no int , cou int)
insert into @blabla2 select top 3 * from @blabla
					
declare @blabla3 table (serial_no int , product_name varchar(20) , category varchar(20)  , price decimal (10,2), final_price decimal(10,2),color varchar(20))
insert into @blabla3 select serial_no , product_name , category   , price , final_price ,color from Product where serial_no in (select serial_no from @blabla2)

declare @bom1 table (customer_name varchar(20) )
insert into @bom1 select c2.customer_name from CustomerAddstoCartProduct c1 inner join CustomerAddstoCartProduct c2 on c1.serial_no=c2.serial_no where c2.customer_name<>@customer_name
group by c2.customer_name order by count(c2.customer_name) desc

declare @bom2 table(customer_name varchar(20))
insert into @bom2 select top 3 * from @bom1


declare @bom3 table(customer_name varchar(20))
insert into @bom3 select customer_name from @bom2


declare @bom4 table(serial_no int )
insert into @bom4 select p.serial_no from CustomerAddstoCartProduct ca inner join Product p on ca.serial_no=p.serial_no where ca.customer_name in (select customer_name from @bom3) group by p.serial_no order by count(p.serial_no) desc


declare @bom5 table(serial_no int)
insert into @bom5 select top 3 * from @bom4


declare @bom6 table (serial_no int , product_name varchar(20) , category varchar(20)  , price decimal (10,2), final_price decimal(10,2),color varchar(20))
insert into @bom6 select  serial_no , product_name , category  , price , final_price ,color from Product where serial_no in(select * from @bom5)

declare @final table(serial_no int , product_name varchar(20) , category varchar(20)  , price decimal (10,2), final_price decimal(10,2),color varchar(20))
insert into @final select * from @blabla3 union select * from @bom6 


select p.serial_no , p.product_name , p.category  , p.price , p.final_price , p.color,p.product_description from @final f inner join Product p on p.serial_no=f.serial_no
 



















		



------------vendors
GO

create proc  postProduct 
@vendorUsername varchar(20), 
 @product_name varchar(20) ,
 @category varchar(20), 
 @product_description text , 
 @price decimal(10,2), 
 @color varchar(20) 
 AS  
 DECLARE @activate BIT
 Select @activate=activated from Vendor where Vendor.username = @vendorUsername
 if(@activate='1')
 begin
 insert into product (product_name,category,product_description,price,final_price ,color,vendor_username) VALUES 
 ( @product_name, @category,@product_description, @price, @price,@color, @vendorUsername)  
 update product
 set Product.available='1'
 END

 
 
  
GO
  create proc vendorviewProducts 
@vendorname varchar(20)
AS
select * 
from product where @vendorname = vendor_username


 GO
 create proc  EditProduct  
@vendorname varchar(20),
@serialnumber int,
@product_name varchar(20),
@category varchar(20), 
@product_description text , 
@price decimal(10,2), 
@color varchar(20) 
as

if(@product_name is null)
begin
select @product_name=product_name from Product where product.serial_no=@serialnumber
end 
if(@category is null)
begin
select @category=category from Product where product.serial_no=@serialnumber
end 
if(@product_description is null)
begin
select @product_description=product_description from Product where product.serial_no=@serialnumber
end 
if(@price is null)
begin
select @price=price from Product where product.serial_no=@serialnumber
end 
if(@color is null)
begin
select @color=color from Product where product.serial_no=@serialnumber
end 
update  product 
set 
product_name=@product_name ,
category=@category,
product_description=@product_description ,
price=@price,
color=@color

where product.serial_no=@serialnumber and product.vendor_username=@vendorname




GO
create proc deleteProduct
@vendorname varchar(20), 
@serialnumber int 
 AS
delete product where serial_no =@serialnumber   AND vendor_username=@vendorname 


GO
 create proc viewQuestions 
 @vendorname varchar(20)
 as 
 select q.serial_no,q.customer_name,q.question,q.answer from Customer_Question_Product q
 inner join  Product p on q.serial_no=p.serial_no
 where  p.vendor_username=@vendorname

 go
 select * from Customer_Question_Product
 select * from Customer
 execute AddQuestion 11,'ahmed.ashraf','cdhgfv??'
 execute viewQuestions 'hadeel.adel'

 GO
 create proc answerQuestions
 @vendorname varchar(20),
 @serialno int , 
 @customername varchar(20),
 @answer text
 as

update Customer_Question_Product
set Customer_Question_Product.answer=@answer
where Customer_Question_Product.serial_no=@serialno and Customer_Question_Product.customer_name=@customername

--execute answerQuestions 'hadeel.adel',11,'ahmed.ashraf','fvvhdk'

 GO
 create proc  addOffer 
 @oﬀeramount int,
 @expiry_date datetime 
 as
 insert  into offer (offer_amount,expiry_date) values (@offeramount,@expiry_date)
 



GO
 create proc  checkOfferonProduct
@serial int,
@activeoffer bit output

as
set @activeoffer='0' 
DECLARE @offer_id INT 
select @offer_id=op.offer_id from offersOnProduct op WHERE op.serial_no=@serial
DECLARE @date DATETIME
SELECT @date=o.expiry_date from offer o WHERE @offer_id=o.offer_id

if(datediff(day,@date  ,CURRENT_TIMESTAMP) >=0)
begin

SET @activeoffer='1' 
END




GO


 create proc checkandremoveExpiredoffer
 @offerid int
 as 
 declare @date_of_expiry datetime
 select @date_of_expiry=expiry_date from offer where @offerid=offer_id

if(datediff(day,@date_of_expiry  ,CURRENT_TIMESTAMP) <=0)
begin


declare @offer_amount int

select @offer_amount=offer_amount from offer where offer_id=@offerid
-- keda keda lao 3amlna delete from offer will delete from offeronproduct
-- because ana 3amel on delete cascade in table offerson product


declare @s_n int
select @s_n= op.serial_no from offersOnProduct op where op.offer_id=@offerid
delete from offer where offer_id=@offerid
update Product 
	set final_price=final_price+@offer_amount
	where Product.serial_no=@s_n
end
 
 

GO


create proc applyoffer 
 @vendorname varchar(20), 
 @oﬀerid int, 
 @serial int
as 

declare @check_bit bit
execute CheckandremoveExpiredoffer @offerid 
execute checkOfferonProduct @serial , @check_bit output

if @check_bit='0'
begin

insert into offersOnProduct values (@offerid,@serial)
declare @amount decimal(10,2)
select @amount=offer_amount from offer 
where @offerid=offer_id

update Product
set
final_price=price-@amount
where
@serial=serial_no and @vendorname=vendor_username


end




 -------------------------Admin
 GO
create proc activateVendors
@admin_username varchar(20),
@vendor_username varchar(20)
as
update Vendor 
set Vendor.activated='1',Vendor.admin_username=@admin_username
where Vendor.username=@vendor_username;


 GO
create proc inviteDeliveryPerson
@delivery_username varchar(20),
@delivery_email varchar(50)
as
update Users 
set Users.email=@delivery_email
where Users.username=@delivery_username 

insert into Delivery_Person (username , is_activated) Values (@delivery_username , '0')


GO
create proc reviewOrders
as
Select * from Orders



GO
create proc updateOrderStatusInProcess
@order_no int
as
update Orders 
set Orders.order_status='in Process'
where orders.order_no=@order_no;

GO
create proc addDelivery
@delivery_type varchar(20),
@time_duration int,
@fees decimal(5,3),
@admin_username varchar(20)
as
insert into Delivery (type,time_duration,fees,username) values (@delivery_type,@time_duration,@fees,@admin_username);


GO
create proc assignOrdertoDelivery
@delivery_username varchar(20),
@order_no int,
@admin_username varchar(20)
as
insert into Admin_Delivery_Order(delivery_username,order_no,admin_username) values (@delivery_username,@order_no,@admin_username);

GO
create proc createTodaysDeal
@deal_amount int,
@admin_username varchar(20),
@expiry_date datetime
as
insert into Todays_Deals(deal_amount,admin_username,expiry_date) values (@deal_amount,@admin_username,@expiry_date);

GO
create proc checkTodaysDealOnProduct
@serial_no INT ,
@activeDeal bit output
as
set @activeDeal='0' 
DECLARE @deal_id INT 
select @deal_id=t.deal_id from Todays_Deals_Product t WHERE t.serial_no=@serial_no
DECLARE @date DATETIME
SELECT @date=d.expiry_date from Todays_Deals d WHERE @deal_id=d.deal_id

if(datediff(day,@date,CURRENT_TIMESTAMP)<=0)
begin

SET @activeDeal='1' 
END

go
declare @active_Deal Bit
execute checkTodaysDealOnProduct 2 , @active_Deal output
print (@active_Deal)


go
create proc removeExpiredDeal @deal_iD int
as
 declare @date_of_expiry datetime
 select @date_of_expiry=expiry_date from Todays_Deals where @deal_iD=deal_id

if(datediff(day,@date_of_expiry  ,CURRENT_TIMESTAMP) >=0)
begin


declare @offer_amount int

select @offer_amount=deal_amount from Todays_Deals where deal_id=@deal_iD
-- keda keda lao 3amlna delete from offer will delete from offeronproduct
-- because ana 3amel on delete cascade in table offerson product


declare @s_n int
select @s_n= op.serial_no from Todays_Deals_Product op where op.deal_id=@deal_iD
delete from Todays_Deals_Product where deal_id=@deal_iD
declare @price decimal(10,2)
select @price=price from Product where @s_n=serial_no
update Product 
	set final_price=final_price + @price*@offer_amount
	where Product.serial_no=@s_n
end



go
create proc addTodaysDealOnProduct @deal_id int , @serial_no int

as


declare @check_bit bit

execute checkTodaysDealOnProduct @serial_no , @check_bit output

if @check_bit='0'
begin
insert into Todays_Deals_Product values (@deal_id,@serial_no)

declare @amount decimal(10,2)
select @amount=deal_amount from Todays_Deals 
where @deal_id=deal_id
declare @price decimal(10,2)

select @price=price from Product where @serial_no=serial_no
update Product
set
final_price=final_price - final_price*@amount*0.01 
where
@serial_no=serial_no 

end

execute removeExpiredDeal @deal_id 

go


GO
create proc createGiftCard
@code varchar(10),
@expiry_date datetime,
@amount int,
@admin_username varchar(20)
as
insert into Giftcard(code , expiry_date, amount, username) values (@code,@expiry_date,@amount,@admin_username);

 

GO
create proc removeExpiredGiftCard
@code varchar(10)
as
Declare @exp_date datetime 

select  @exp_date = g.expiry_date 
from GiftCard g
where g.code = @code 
if ( datediff(day,@exp_date  ,CURRENT_TIMESTAMP) >=0 )
begin
	declare @pnts decimal(10,2)
	Declare @Customer varchar(20)

	select  @pnts=ACG.remaining_points ,  @Customer= ACG.customer_name 
	from Admin_Customer_Giftcard  ACG
	where ACG.code = @code 


	declare @TOTALpnts decimal(10,2) 

	Select @TOTALpnts = c.points
	from Customer c
	where c.username =  @Customer

	SET @TOTALpnts = @TOTALpnts -  @pnts 


	Update Customer 
	Set points = @TOTALpnts 
	where username=@Customer

	Delete from Gift_Cards
	where  Gift_Cards.code = @code 

	Delete from Admin_Customer_Giftcard
	where Admin_Customer_Giftcard.code=@code
end




GO
create proc checkGiftCardOnCustomer
@code varchar(10),
@activeGiftCard BIT OUTPUT
AS
Declare @expire datetime
select @expire=g1.expiry_date from Giftcard g1 where g1.code=@code
if(datediff(day,@expire,CURRENT_TIMESTAMP)>=0)
begin
set @activeGiftCard = '0'
end
else
begin
set @activeGiftCard='1'
end







GO


create proc giveGiftCardtoCustomer
@code varchar(10),
@customer_name varchar(20),
@admin_username varchar(20)
as
declare @pnts decimal(10,2) 
Select @pnts = g. amount
from Giftcard g
where g.code = @code 



--declare @TOTALpnts decimal(10,2) 
--Select @TOTALpnts = SUM(ACG.remaining_points)
---from Admin_Customer_Giftcard ACG
---where ACG.customer_name=@customer_name
declare @bitt bit 
execute checkGiftCardOnCustomer @code, @bitt output 
if (@bitt ='0')
begin
Update Customer 
Set points = points+@pnts
where Customer.username=@customer_name 
insert into Admin_Customer_Giftcard VALUES (@code , @customer_name ,@admin_username , @pnts)
end 
execute removeExpiredGiftCard @code




---------------------------------------------- Delivery personnels

GO

 create proc acceptAdminInvitation
@delivery_username VARCHAR(20)
AS
UPDATE Delivery_Person 
SET Delivery_Person.is_activated='1'
where Delivery_Person.username=@delivery_username





GO 
create proc deliveryPersonUpdateInfo
@username varchar(20),
@first_name varchar(20),
@last_name varchar(20),
@password varchar(20),
@email varchar(50)
AS
UPDATE Users 
set
password=@password,
first_name=@first_name,
last_name=@last_name,
email=@email
WHERE username=@username





GO
create proc viewmyorders
@deliveryperson varchar(20)
AS
declare @orderno int

Select @orderno=ADO.order_no
from Admin_Delivery_Order ADO
where ADO.delivery_username=@deliveryperson

Select * 
from Orders o
where o.order_no = @orderno





GO
create proc specifyDeliveryWindow
@delivery_username varchar(20),
@order_no int,
@delivery_window varchar(50)
AS
update Admin_Delivery_Order
set delivery_window=@delivery_window
where Admin_Delivery_Order.delivery_username = @delivery_username and Admin_Delivery_Order.order_no=@order_no




GO
create proc updateOrderStatusOutforDelivery
@order_no int
AS
update Orders
set order_status='Out for delivery'
where Orders.order_no=@order_no







GO
create proc updateOrderStatusDelivered
@order_no int 
AS
update Orders
set order_status='Delivered'
where Orders.order_no=@order_no 





















