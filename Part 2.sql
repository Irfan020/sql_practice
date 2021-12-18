
drop table order_detail;
drop table product;
drop table prod_category;
drop table delivery;
drop table orders;
drop table customer;

/*
drop table order_detail;
drop table delivery;
drop table orders;
drop table customer;
drop table product;
drop table prod_category;
*/

create table prod_category
( cat_id INTEGER not null primary key,
cat_name varchar2(50));

create table product
( prod_id  integer not null PRIMARY KEY,
prod_name VARCHAR(30) not null,
prod_price number not null,
prod_quantity integer not null,
expire_date date,
cat_id integer not null,
foreign key (cat_id) references prod_category(cat_id));

create table customer
( cust_id integer not null primary key,
cust_name varchar2(50) not null,
cust_city varchar2(35),
cust_province varchar2(35));

create table orders
( order_id integer not null primary key,
order_date date not null,
cust_id integer not null,
foreign key (cust_id) references customer(cust_id));

create table order_detail
(prod_id          INTEGER NOT NULL,
order_id integer not null,
quantity number not null,
foreign key (prod_id) REFERENCES product(prod_id),
foreign key (order_id) references orders(order_id),
primary key (prod_id, order_id));


create table delivery 
( delivery_id integer not null primary key,
order_id integer not null,
delivery_date date not null,
foreign key (order_id) REFERENCES orders(order_id));


/* ==============================================================*/
insert into prod_category values ( 1 , 'Electronics');
insert into prod_category values ( 2 , 'Food');

insert into product(prod_id, prod_name, prod_price, prod_quantity, cat_id) values ( 1 , 'Iphone 12' , 9000 , 25,  1);
insert into product(prod_id, prod_name, prod_price, prod_quantity, cat_id) values ( 2 , 'Samsung tv', 17000, 14,  1);
insert into product(prod_id, prod_name, prod_price, prod_quantity, expire_date, cat_id) values ( 3 , 'Banana'    , 9    , 50, TO_DATE('20-03-2022','dd-mm-yyyy'), 2);
insert into product(prod_id, prod_name, prod_price, prod_quantity, expire_date, cat_id) values ( 4 , 'Pasta'     , 15   , 17, TO_DATE('20-03-2020','dd-mm-yyyy'), 2);
insert into product(prod_id, prod_name, prod_price, prod_quantity, expire_date, cat_id) values ( 5 , 'Chocolate' , 35   , 05, TO_DATE('20-03-2022','dd-mm-yyyy'), 2);
insert into product(prod_id, prod_name, prod_price, prod_quantity, expire_date, cat_id) values ( 6 , 'Vanila'    , 10   , 11, TO_DATE('11-03-2022','dd-mm-yyyy'), 2);
insert into product(prod_id, prod_name, prod_price, prod_quantity, expire_date, cat_id) values ( 7 , 'Sugar'     , 100  , 7 , '25-Dec-2021', 2);

/*  select * from prod_category;   */


insert into customer values ( 1 , 'Jason Smith'  , 'Nanjing' , 'Jiangsu' );
insert into customer values ( 2 , 'Alex Joe'     , 'Wuxi' , 'Jiangsu' );
insert into customer values ( 3 , 'Bernard Andy' , 'Wuxi' , 'Jiangsu' );
insert into customer values ( 4 , 'Samuel Ali'   , 'Nanjing' , 'Jiangsu' );


insert into orders(order_id, cust_id ,order_date) values ( 1 , 1 , TO_DATE('15-11-2021','dd-mm-yyyy'));
insert into orders(order_id, cust_id ,order_date) values ( 2 , 3 , TO_DATE('13-11-2021','dd-mm-yyyy'));  /* Delivered  */
insert into orders(order_id, cust_id ,order_date) values ( 3 , 2 , TO_DATE('20-11-2021','dd-mm-yyyy'));  /* Delivered  */
insert into orders(order_id, cust_id ,order_date) values ( 4 , 1 , TO_DATE('21-11-2021','dd-mm-yyyy'));

insert into Order_detail(order_id, prod_id, quantity) values ( 1 , 1 , 5 );
insert into Order_detail(order_id, prod_id, quantity) values ( 1 , 5 , 2 );
insert into Order_detail(order_id, prod_id, quantity) values ( 2 , 2 , 1 );
insert into Order_detail(order_id, prod_id, quantity) values ( 2 , 3 , 2 );
insert into Order_detail(order_id, prod_id, quantity) values ( 2 , 1 , 2 );
insert into Order_detail(order_id, prod_id, quantity) values ( 3 , 1 , 6 );
insert into Order_detail(order_id, prod_id, quantity) values ( 4 , 4 , 1 );
insert into Order_detail(order_id, prod_id, quantity) values ( 4 , 3 , 2 );

insert into delivery(delivery_id,  order_id, delivery_date) values  (1  , 2  , TO_DATE('21-12-2021','dd-mm-yyyy'));
insert into delivery(delivery_id, order_id, delivery_date) values  (2  , 3  , TO_DATE('11-12-2021','dd-mm-yyyy'));


/*  1. display the ID, name, price, and quantity of all products.   */

select prod_id, prod_name, prod_price, prod_quantity from product;

/*2. display the products whose quantity is less than 100  */

select * from product where prod_quantity < 100;

/* 3. display products that have never been ordered.  */

select * 
from product
where prod_id not in (select prod_id from order_detail);


select * 
from product
where prod_id not in (select Distinct(prod_id) from order_detail);

/* select DISTINCT(prod_id) from order_detail;  */


/*  4. display the detail of order 101.    */

select * from order_detail where order_id = 101;


/* 5. display products from the category ‘Electronics’.   */

select *
from product
where cat_id = (select cat_id from prod_category where cat_name = 'Electronics');

select p.prod_id, p.prod_name, p.prod_price, p.prod_quantity, p.expire_date
from product p, prod_category c
where p.cat_id = c.cat_id
and c.cat_name = 'Electronics';

select p.prod_id, p.prod_name, p.prod_price, p.prod_quantity, p.expire_date
from product p
inner join prod_category c
on p.cat_id = c.cat_id
where c.cat_name = 'Electronics';

/*  6. display orders not yet delivered.  */ 

select * from orders
where order_id not in ( select order_id from delivery);

/*  7. display the id and name of products that will expire by December 31, 2021.  */

select prod_id, prod_name
from product
where expire_date <= '31-Dec-2021';

/*  8. display all the product names, the price, and the order quantity of the customer “Jason Smith”.   */

select p.prod_name, p.prod_price, od.quantity
from product p, orders o, order_detail od, customer c
where p.prod_id = od.prod_id
and o.cust_id = c. cust_id
and o.order_id = od.order_id
and c.cust_name = 'Jason Smith';

/* 9. display the name of each product and the sum of the orders for that product  */

select p.prod_name, sum(p.prod_price * od.quantity) as total
from product p, order_detail od
where p.prod_id = od.prod_id
group by p.prod_name;


/*  10. display the most expensive product.  */

select * from product
where prod_price = (select max(prod_price) from product);


