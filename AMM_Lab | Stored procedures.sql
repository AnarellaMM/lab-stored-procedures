use sakila;

-- In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented Action movies. 
-- Convert the query into a simple stored procedure. Use the following query:

  select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = "Action"
  group by first_name, last_name, email;
  
  DELIMITER //

CREATE PROCEDURE GetCustomersWhoRentedActionMovies()
BEGIN
    SELECT 
        c.first_name,
        c.last_name,
        c.email
    FROM customer c
    JOIN rental r ON c.customer_id = r.customer_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category cat ON fc.category_id = cat.category_id
    WHERE cat.name = 'Action'
    GROUP BY c.first_name, c.last_name, c.email;
END //

DELIMITER ;

CALL GetCustomersWhoRentedActionMovies();

-- Now keep working on the previous stored procedure to make it more dynamic. 
-- Update the stored procedure in a such manner that it can take a string argument for the category name and 
-- return the results for all customers that rented movie of that category/genre.
--  For eg., it could be action, animation, children, classics, etc.

DELIMITER //

CREATE PROCEDURE GetCustomersWhoRentedCategoryMovies(IN categoryName VARCHAR(255))
BEGIN
    SET @categoryName = categoryName;
    
    SELECT 
        c.first_name,
        c.last_name,
        c.email
    FROM customer c
    JOIN rental r ON c.customer_id = r.customer_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category cat ON fc.category_id = cat.category_id
    WHERE cat.name = @categoryName
    GROUP BY c.first_name, c.last_name, c.email;
END //

DELIMITER ;

CALL GetCustomersWhoRentedCategoryMovies('Action');
CALL GetCustomersWhoRentedCategoryMovies('Animation');
CALL GetCustomersWhoRentedCategoryMovies('Children');
CALL GetCustomersWhoRentedCategoryMovies('Classics');

-- Write a query to check the number of movies released in each movie category. 
-- Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number.
--  Pass that number as an argument in the stored procedure.

SELECT c.name AS category_name, COUNT(f.film_id) AS num_movies
FROM category c
LEFT JOIN film_category fc ON c.category_id = fc.category_id
LEFT JOIN film f ON fc.film_id = f.film_id
GROUP BY category_name;

DELIMITER //

CREATE PROCEDURE GetCategoriesWithMoreMovies(IN minMovies INT)
BEGIN
    SELECT c.name AS category_name, COUNT(f.film_id) AS num_movies
    FROM category c
    LEFT JOIN film_category fc ON c.category_id = fc.category_id
    LEFT JOIN film f ON fc.film_id = f.film_id
    GROUP BY category_name
    HAVING num_movies > minMovies;
END //

DELIMITER ;

CALL GetCategoriesWithMoreMovies(60);