/*
Colin Martin 
Lab	6: Interesting and Painful Queries
Due: During Week 6/7

Note that all of my queries seem to correctly match what it should be based on the CAP screenshot. I am mentioning
that here so that I don't have to keep writing it underneath each question.

Also note that at the end of the shown AI outputs I am providing a grade for how well it performed.
It is out of 10.

Lastly, again, I apologize that this is being submitted a bit later than usual. Midterm week genuinely kicked 
my ass. Also again, this is not me whining or being lazy, I like to put as much focus into these labs as I can, 
so it was difficult to find times to stay true to that since this lab has been assigned. I was also finding it 
difficult to actually get some sleep... but that's besides the point.
*/

/*
1. Display the cities that makes the most different kinds of products.	Experiment with	
the	rank() function
*/
drop view mostProducts;
Create View mostProducts
as
Select city, count(Distinct prodId) as cityCount
From Products
Group by city;

drop view cityRank;
Create View cityRank
as
Select city, cityCount,
	Rank() over (Order by cityCount DESC) as rk
From mostProducts;

Select city, cityCount
From cityRank
Where rk = 1;
/*
AI Output:
SELECT city, COUNT(DISTINCT prodId) AS product_count,
       RANK() OVER (ORDER BY COUNT(DISTINCT prodId) DESC) AS rank
FROM Products
GROUP BY city;

Rough start right off the bat. The AI created the rank, but didn't actually use it. We needed to 
find the city that made the most different kind of products, but this instead outputted every single
city, with its count, and its rank. It is missing a full step of the way so this is getting a 2/10. 
*/


/*
2. Display the names of	products whose priceUSD	is less	than 1%	of the average	
priceUSD, in alphabetical order from A	to Z.
*/
Select name
From Products
Where priceUSD < (
	Select avg(priceUSD)*.01
	From Products
)
Order by name ASC;
/*
AI Output:
SELECT name
FROM Products
WHERE priceUSD < (SELECT AVG(priceUSD) * 0.01 FROM Products)
ORDER BY name ASC;

This is correct and outputs exactly what I got. The only problem I have is the formatting of the 
subquery. I have not been liking the way that the AI typically does this. However, the output and 
structure is still correct so this is a 10/10.
*/

/*
3. Display the customer	last name, product id ordered, and the	totalUSD for all orders	
made in	March of any year, sorted by totalUSD from	low	to high.
*/
Select p.lastName, o.prodId, o.totalUSD
From People p inner join Orders o on p.pid = o.custId
Where date_part('Month', dateOrdered) = '03'
Order by totalUSD ASC;
/*
AI Output:
SELECT p.lastName, o.prodId, o.totalUSD
FROM Orders o
JOIN Customers c ON o.custId = c.pid
JOIN People p ON c.pid = p.pid
WHERE EXTRACT(MONTH FROM o.dateOrdered) = 3
ORDER BY o.totalUSD ASC;

This is definitely a correct method. Different than mine, in that the AI started with orders and then
connected with customers, then to people, whereas I just connected people right to orders through customer ID.
The AI also used EXTRACT to get the month and I used date_part. Overall, this is still a perfectly good
answer that provides the correct output. 10/10.
*/

/*
4. Display the last	name of	all	customers (in reverse alphabetical order) and their total	
ordered	by customer, and nothing more. Use coalesce to	avoid showing NULL totals
*/
Select p.lastName, coalesce(sum(o.quantityOrdered), 0) as totalQuant
From People p inner join Customers c ON p.pid = c.pid
			  left outer join Orders o ON c.pid = o.custId
Group by p.lastName
Order by p.lastName DESC;
/*
AI Output:
SELECT p.lastName, COALESCE(SUM(o.totalUSD), 0) AS total_spent
FROM Customers c
LEFT JOIN Orders o ON c.pid = o.custId
JOIN People p ON c.pid = p.pid
GROUP BY p.lastName
ORDER BY p.lastName DESC;

Now the AI did this all correct, but I am now realizing I may have confused totalUSD with 
total quantity ordered when I did this question considering the fact that this is what the
AI did instead. I am going to keep my answer this way to stay true to myself, because I still
think that this is what is being asked. Still will give a 10/10 to the AI, it did everything 
else correctly.
*/

/*
5. Display the names of	all	customers who bought products from	agents based in	Regina	
along with the names of	the	products they ordered, and the names of the agents	who	
sold it	to them.
*/
Select c.firstName as cust_firstName, c.lastName as cust_lastName,
	   a.firstName as agent_firstName, a.lastName as agent_lastName,
	   pr.name as productName
From Orders o inner join People c on o.custId = c.pid
			  inner join People a on o.agentId = a.pid
			  inner join Products pr on pr.prodid = o.prodId
Where a.homeCity = 'Regina';
/*
AI Output:
SELECT DISTINCT cust.firstName || ' ' || cust.lastName AS customer_name,
       prod.name AS product_name,
       agent.firstName || ' ' || agent.lastName AS agent_name
FROM Orders o
JOIN Customers c ON o.custId = c.pid
JOIN People cust ON c.pid = cust.pid
JOIN Agents a ON o.agentId = a.pid
JOIN People agent ON a.pid = agent.pid
JOIN Products prod ON o.prodId = prod.prodId
WHERE agent.homeCity = 'Regina';

The AI went through the customers and agents seperately, which is okay, but I do not like what
it did by combining the first and last names, as it violates the first normal form rule. Even though
it did the rest of the query correctly, I will have to give this a 4/10 because of that violation.
*/
 
/*
6. Write a query to	check the accuracy of the totalUSD column in the Orders table.	This	
means calculating Orders.totalUSD from	data in	other tables and comparing those values to	
the	values in Orders.totalUSD. Display all rows in	Orders where Orders.totalUSD is incorrect,	if	any.	
If there are any incorrect values, explain why they are wrong. Round to exactly two decimal places.
*/
Select o.*
From Orders o inner join Products pr on o.prodId = pr.prodid
			  inner join Customers c on c.pid = o.custId
Where Round(pr.priceUSD * o.quantityOrdered * (1-(c.discountPct/100)), 2) != o.totalUSD;
/*
The three incorrect values come from order numbers 1017, 1024, and 1026. I calculated each value seperately for
these three values are indeed the only incorrect ones, every other value correctly matched the totalUSD
in the Orders table. For #1017, the value is supposed to be 25643.89, thus meaning that the input had the 
decimal values swapped, as the CAP database shows 25643.98. For #1024, the actual correct value is 56617.55,
with another swap being the cause of error here, as it should be 17 instead of 71 before the decimal point. 
For #1026, the value is just completely incorrect. It is not a slight error as the correct value is supposed
to be 51485.44 and not 47277.29.
*/
/*
AI Output:
SELECT o.*
FROM Orders o
JOIN Products p ON o.prodId = p.prodId
WHERE ROUND(o.quantityOrdered * p.priceUSD, 2) <> o.totalUSD;

Nope. Very wrong. The AI forgot completely to join in Customers and use the discount percentage in the
calculation for the WHERE clause. Thus the output is entirely wrong because, according to its calculation,
every value will not equal the totalUSD. 0/10.
*/


/*
7. Display the first and last name	of all customers who are also agents
*/
Select p.firstName, p.lastName
From People p inner join Customers c on p.pid = c.pid
			  inner join Agents a on a.pid = c.pid;
/*
AI Output:
SELECT p.firstName, p.lastName
FROM Customers c
JOIN Agents a ON c.pid = a.pid
JOIN People p ON c.pid = p.pid;

Nothing much to say here. Simple query and it did it right, I just started the join with People instead. 10/10
*/

/*
8. Create a	VIEW of	all	Customer and People	data called	PeopleCustomers. Then another	
VIEW of	all	Agent and People data called PeopleAgents. Then select	* from each	of	
them to	test them.
*/
-- View PeopleCustomers;
drop view PeopleCustomers;
Create View PeopleCustomers
as
Select p.pid, p.prefix, p.firstName, p.lastName, p.suffix, p.homeCity, p.DOB, 
	   c.paymentTerms, c.discountPct
From People p inner join Customers c on p.pid = c.pid;

-- View PeopleAgents
drop view PeopleAgents;
Create View PeopleAgents
as
Select p.pid, p.prefix, p.firstName, p.lastName, p.suffix, p.homeCity, p.DOB, 
	   a.paymentTerms, a.commissionPct
From People p inner join Agents a on p.pid = a.pid;

-- Test PeopleCustomers
Select *
From PeopleCustomers;

-- Test PeopleAgents
Select *
From PeopleAgents;
/*
AI Output:
CREATE VIEW PeopleCustomers AS
SELECT p.*, c.paymentTerms, c.discountPct
FROM People p
JOIN Customers c ON p.pid = c.pid;

CREATE VIEW PeopleAgents AS
SELECT p.*, a.paymentTerms, a.commissionPct
FROM People p
JOIN Agents a ON p.pid = a.pid;

SELECT * FROM PeopleCustomers;
SELECT * FROM PeopleAgents;

The AI did this exactly right. I instead selected each individual column, which is fine, but 
I actually prefer the AI's method. I definitely should have done it that way, but my way still 
worked so I can't complain. 10/10
*/

/*
9. Display the first and last name	of all customers who are also agents, this	time using	
the	views you created.
*/
Select pc.firstName, pc.lastName
From PeopleCustomers pc inner join PeopleAgents pa on pc.pid = pa.pid;
/*
AI Output:
SELECT pc.firstName, pc.lastName
FROM PeopleCustomers pc
JOIN PeopleAgents pa ON pc.pid = pa.pid;

Strong finish, this is exactly right. 10/10.
*/

/*
10. Compare	your SQL in	#7 (no views) and #9 (using	views). The	output is the same.	
How	does that work?	What is	the	database server	doing internally when it processes	
the	#9 query?

The reason these output the same thing is because the SQL server is following the same logic in both
instances by extracting the people from both the agents and customers tables. The first example does 
require an extra step though, since you need to reference each table of People, Customers, and agents 
seperately. In #9, I only needed to join the two created views directly on pid instead of referencing the base
tables. 
When processing the #9 query, the database server is using logical data independence by following the logic of the 
newly added views to then simply combine them on the similar pids being referenced; without altering the meaning of the 
data. Overall, the views allow for a more simple query reference.
*/

/*
11. [Bonus]	What’s the difference between a LEFT OUTER JOIN and a RIGHT OUTER	
JOIN? Give example queries in SQL to demonstrate. (Feel free to use the CAP database	
to make	your points	here.)

A LEFT OUTER JOIN returns all of the data from the left table where there are matches. So calling this
will output every value that is being joined together, but will only take into account the LEFT matches.
So, the instances on the right side of the join will just output NULL's, but all of the left values will 
still be shown. A RIGHT OUTER JOIN will do the exact opposite of this, where it will instead focus on the
RIGHT matches from the join and output NULL's on the left where there are no matches (with the right values
still being shown.
*/
-- Example
Select pc.firstName, pa.lastName
From PeopleCustomers pc left outer join PeopleAgents pa on pc.pid = pa.pid;

Select pc.firstName, pa.lastName
From PeopleCustomers pc right outer join PeopleAgents pa on pc.pid = pa.pid;
/*
In this example, I chose to select the different first and last names from the two created views from above.
As you can see, the left outer join showed every single first name from the PeopleCustomers view, joined with 
the last names from the PeopleAgents table. "Wonder" is the only outputted last name because that is the only
match with PeopleCustomers, since Stevie Wonder is the only customer that is also an agent. The rest of the 
agent last names are null as they do not match with anymore customer first names. The right outer join, again,
does the complete opposite. All of the last names are outputted and all of the first names aside from "Stevie"
are null; since they do not match.
*/




