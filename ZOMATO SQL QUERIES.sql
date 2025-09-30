# Zomato Project
use zomato;
#1. List all users who have placed an order.
select  distinct users.user_id,
users.name
from users
join orders on users.user_id =orders.user_id;

#2.Which customer spent the maximum amount overall?
select users.user_id, users.name,
sum(orders.amount) as total_spent
from users join orders on 
users.user_id =orders.user_id
group by users.user_id, users.name
order by total_spent desc ;

#3.Find the highest rated restaurant (based on avg rating).
select restaurants.r_name,
round (avg(orders.restaurant_rating )) as avg_rating
from restaurants join orders 
on restaurants.r_id = orders.r_id
group by restaurants.r_name
order by avg_rating desc;

#4. What is the monthly revenue of Zomato?

select year(date) as year ,
month(date) as month,
sum(amount)  as monthly_revenue
from orders group by year(date),
month(date) order by year(date),month(date);

#5. Find the top 5 customers with the highest number of orders.
select 
count(users.user_id) as total_orders,
users.name
from users
join orders on users.user_id =orders.user_id
join order_details on order_details.order_id = orders.order_id
group by users.name
order by total_orders desc;

#6  Find the restaurants that generated the highest total revenue.
select 
restaurants.r_name,
sum(orders.amount) as total_revenue
from restaurants
join orders 
on restaurants.r_id = orders.r_id
group by restaurants.r_name
order by total_revenue desc
limit 1;

#7.Which delivery partner has the best average delivery rating?

select delivery_partner.partner_name,
round(avg(orders.delivery_rating)) as avg_rating
from delivery_partner join orders on
delivery_partner.partner_id = orders.partner_id
group by delivery_partner.partner_name 
order by avg_rating desc;

#8.  Use  view  and  list all orders with order_id, user name, restaurant id, food items, and delivery partner name.
create view full_details as 
select  users.name as user_name,
restaurants.r_id ,food.f_name as food_items,
delivery_partner.partner_name as partner_name,
count(*) as total_orders
from users join orders
on users.user_id =orders.user_id
join order_details on order_details.order_id = orders.order_id
join restaurants on restaurants.r_id =orders.r_id
join food on food.f_id =order_details.f_id
join delivery_partner on delivery_partner.partner_id =orders.partner_id
group by user_name,
food_items ,partner_name;

select order_id,user_name,food_items,r_id ,partner_name from full_details;

#9 Find min and max order value for all the customers.
select * from users;
select * from orders;
select users.user_id,users.name ,
min(orders.amount),
max(orders.amount)
from users join orders on
users.user_id = orders.user_id
group by users.user_id,users.name;

#10. Find restaurant with most number of menu items.

SELECT restaurants.r_name,
count(menu.f_id) AS total_menu_items
from restaurants
join menu 
on restaurants.r_id = menu.r_id
group by  restaurants.r_name
order by total_menu_items desc;

#11 Find the food that is being sold at most number of restaurants.
select food.f_name,count(*) as item_sold
from food join  order_details on 
food.f_id = order_details.f_id
join orders on orders.order_id = order_details.order_id
join restaurants on restaurants.r_id = orders.r_id
group by food.f_name order by item_sold desc;

#12 Find the average delivery time for each delivery partner.
SELECT 
delivery_partner.partner_id,
delivery_partner.partner_name,
AVG(orders.delivery_time) AS avg_delivery_time
FROM orders JOIN 
delivery_partner 
ON orders.partner_id = delivery_partner.partner_id
WHERE 
orders.delivery_time IS NOT NULL
GROUP BY 
delivery_partner.partner_id, delivery_partner.partner_name
ORDER BY 
avg_delivery_time;

#13 Find revenue per month for a restaurant
 select restaurants.r_name,
 sum(orders.amount) as revenue ,
 month(orders.date) as month,
 year(orders.date ) as year 
 from restaurants join orders on 
 restaurants.r_id =orders.r_id
 group by restaurants.r_name , month,
 year order by year , month;

#14 Find most costly restaurants.
select restaurants.r_name as restaurant_name,
round(avg(menu.price)) as avg_menu_price,
max(menu.price) as max_menu_price 
from menu join restaurants on 
restaurants.r_id = menu.r_id
group by restaurant_name;

#15. Find delivery partner compenstion using the formula(#deliveries*100+1000*avg_rating)
select delivery_partner.partner_name,
count(orders.order_id) as total_deliveries,
round(avg(orders.delivery_rating)) as avg_rating,
(count(orders.order_id) * 100 + 1000 * round(avg(orders.delivery_rating))) as compensation
from delivery_partner
join orders 
on delivery_partner.partner_id = orders.partner_id
group by delivery_partner.partner_name
order by compensation desc;
