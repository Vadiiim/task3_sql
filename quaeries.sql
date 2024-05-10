--Вывести количество фильмов в каждой категории, отсортировать по убыванию.
SELECT c.name,COUNT(f_c.film_id) AS amount_of_films_in_each_category
FROM public.film_category f_c  JOIN public.category c ON f_c.category_id=c.category_id
GROUP BY  c.category_id,c.name
ORDER BY amount_of_films_in_each_category DESC;

--Вывести 10 актеров, чьи фильмы большего всего арендовали, отсортировать по убыванию.
SELECT a.first_name,a.last_name,COUNT(r.rental_id) AS amount_of_rent
FROM public.rental r JOIN public.inventory i ON r.inventory_id=i.inventory_id
JOIN public.film_actor f_a ON i.film_id=f_a.film_id
JOIN public.actor a ON f_a.actor_id=a.actor_id
GROUP BY a.actor_id,a.first_name,a.last_name
ORDER BY amount_of_rent DESC
LIMIT 10;

--Вывести категорию фильмов, на которую потратили больше всего денег
SELECT c.name, SUM(p.amount) AS film_expensens 
FROM public.payment p JOIN public.rental r ON p.rental_id=r.rental_id
JOIN public.inventory i ON r.inventory_id=i.inventory_id
JOIN public.film_category f_c ON i.film_id=f_c.film_id
JOIN public.category c ON f_c.category_id=c.category_id
GROUP BY c.category_id,c.name
ORDER BY film_expensens DESC
LIMIT 1;

--Вывести названия фильмов, которых нет в inventory. Написать запрос без использования оператора IN
SELECT f.title
FROM public.film f LEFT JOIN public.inventory i ON f.film_id=i.film_id
WHERE i.inventory_id IS NULL


--Вывести топ 3 актеров, которые больше всего появлялись в фильмах в категории “Children”. Если у нескольких актеров одинаковое кол-во фильмов, вывести всех.
WITH CTE AS 
	(
	SELECT a.first_name,a.last_name,DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS ranking
FROM category c JOIN film_category f_c ON c.category_id=f_c.category_id
JOIN film_actor f_a ON f_c.film_id=f_a.film_id
JOIN actor a ON f_a.actor_id=a.actor_id
WHERE c.name='Children'
GROUP BY a.actor_id,a.first_name,a.last_name
)
SELECT first_name,last_name FROM CTE 
WHERE ranking IN (1,2,3)



--Вывести города с количеством активных и неактивных клиентов (активный — customer.active = 1). Отсортировать по количеству неактивных клиентов по убыванию.
SELECT city.city_id,city.city,COUNT(CASE WHEN c.active=1 THEN 1 ELSE NULL END )  AS amount_of_active_customer,COUNT(CASE WHEN c.active=0 THEN 1 ELSE NULL END )  AS amount_of_inactive_customer
	FROM customer c JOIN address a ON c.address_id=a.address_id 
JOIN city ON a.city_id=city.city_id
GROUP BY city.city_id,city.city
ORDER BY  amount_of_inactive_customer DESC 


--Вывести категорию фильмов, у которой самое большое кол-во часов суммарной аренды в городах (customer.address_id в этом city), и которые начинаются на букву “a”. То же самое сделать для городов в которых есть символ “-”. Написать все в одном запросе.
SELECT c.category_id,c.name,SUM(r.return_date-r.rental_date) AS sum_of_rental
	FROM rental r JOIN inventory i ON r.inventory_id=i.inventory_id 
JOIN film_category f_c ON i.film_id=f_c.film_id
JOIN category c ON f_c.category_id=c.category_id
JOIN customer cus ON r.customer_id=cus.customer_id
JOIN address a ON cus.address_id=a.address_id
JOIN city ON a.city_id=city.city_id
WHERE city.city LIKE 'A%' or city.city LIKE 'a%' or city.city LIKE '%-%'
GROUP BY c.category_id,c.name
ORDER BY sum_of_rental DESC
LIMIT 1













