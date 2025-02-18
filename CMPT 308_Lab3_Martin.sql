/*
Colin Martin 
Lab 3 - Getting Started With SQL Queries
Due: During Week 3

Note that all of my queries correctly match what it should be based on the CAP screenshot. I am mentioning
that here so that I don't have to keep writing it underneath each question.

Also note that at the end of the shown AI outputs I am providing a grade for how well it performed.
It is out of 10.
*/

-- 1. List	the	order	number	and	total	dollars	of	all	orders
Select orderNum, totalUSD
From Orders;
/*
AI Output: SELECT orderNum, totalUSD
		   FROM Orders;
		   
This is exactly what I wrote, only noticible difference is the capital letter usage; 10/10.
*/

-- 2. List	the	last	name	and	home	city	of	people	whose	preix	is	“Ms.”.
Select lastName, homeCity
From People
Where prefix = 'Ms.';
/*
AI Output: SELECT lastName, homeCity
		   FROM People
		   WHERE prefix = 'Ms.';

Same notes as mentioned in question 1; 10/10.
*/

-- 3. List	the	id,	name,	and	quantity	on	hand	of	products	with	quantity	more	than	1007.
Select prodid, name, qtyOnHand
From Products
Where qtyOnHand > 1007;
/*
AI Output: SELECT prodId, name, qtyOnHand
		   FROM Products
		   WHERE qtyOnHand > 1007;

Same notes as in above questions; 10/10.
*/

-- 4. List	the	first	name	and	home	city	of	people	born	in	the	1940s.
Select firstName, homeCity
From People
Where DOB >= '1940-01-01' 
  And DOB <= '1949-12-31'; -- I am including every single day of the 1940s with this method.
/*
AI Output: SELECT firstName, homeCity
		   FROM People
		   WHERE DOB >= '1940-01-01' AND DOB <= '1949-12-31';

Still same notes from the above questions, another 10/10. So far, the AI is doing a great job.
*/

-- 5. List	the	preix	and	last	name	of	people	who	are	not	“Mr.”.
Select prefix, lastName
From People
Where prefix != 'Mr.';
/*
AI Output: SELECT prefix, lastName
		   FROM People
		   WHERE prefix <> 'Mr.';
		   
Notable difference is that it used <> for "not equal" which is certainly a correct approach, 
I just used != instead. 10/10
*/

-- 6. List	all	fields	for	products	in	neither	Dallas	nor	Duluth	that	cost	US$17	or	less.
Select *
From Products
Where city not in ('Dallas', 'Duluth') -- Using "not in" since dealing with a specified list of values
  And priceUSD <= 17.00;
/*
AI Output: SELECT *
		   FROM Products
		   WHERE city NOT IN ('Dallas', 'Duluth')
		     AND priceUSD <= 17;

This is exactly what I have, I just used 17.00 instead of 17 since this column deals w/ decimals and I wanted 
to be as specific as possible. Another 10/10.
*/

-- 7. List	all	fields	for	orders	in	January	of	any	year.
Select *
From Orders
Where date_part('month', dateOrdered) = '01'; -- Takes just the month from this data data type
/*
AI Output: SELECT *
		   FROM Orders
		   WHERE EXTRACT(MONTH FROM dateOrdered) = 1;

For this one I used stack overflow to find out about date_part so that I can get specfically instances w/ January. 
The AI used a different method instead, as shown, and upon testing, it gave the same output that I got. I don't know
if I am just being picky, but I used 01 and put it in quotes to be specific, but the AI still did it correctly.
10/10
*/

-- 8. List	all	fields	for	orders	in	February	of	any	year	of	US$23,000	or	more.
Select *
From Orders
Where date_part('month', dateOrdered) = '02' 
  And totalUSD >= 23000.00;
/*
AI Output: SELECT *
		   FROM Orders
		   WHERE EXTRACT(MONTH FROM dateOrdered) = 2
  			AND totalUSD >= 23000;

Same deal as in the above question. I used date_part and the AI used Extract. Both outputs are exactly the same. 10/10.
*/
-- 9. List	all	orders	from	the	customer	whose	id	is	010.
Select *
From Orders
Where custId = 010;
/*
AI Output: SELECT *
		   FROM Orders
		   WHERE custId = 010;

Very simple query, and there is no actual output since there is no customer ID 10. The AI wrote down exactly
what I have and also provided no output. 10/10

Side note: I find it interesting that SQL still reads 010 as 10, even though that is not the format used in this
specific orders table.
*/

-- 10. List	all	orders	from	the	customer	whose	id	is	005.
Select *
From Orders
Where custId = 005;
/*
AI Output: SELECT *
		   FROM Orders
		   WHERE custId = 005;

Another simple one, and the AI again gave me exactly what I wrote, with the same output. 10/10.
*/ 

/*
Overall, the AI did a perfect job. That is definitely somewhat surprising, but given the circumstance that this is 
a relatively simple SQL lab, this is the expectation that I had going into it.
*/




