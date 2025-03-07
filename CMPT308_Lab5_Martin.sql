/*
Colin Martin 
Lab 5: SQL Queries - The Joins Three-quel
Due: During Week 5/6

Note that all of my queries seem to correctly match what it should be based on the CAP screenshot. I am mentioning
that here so that I don't have to keep writing it underneath each question.

Also note that at the end of the shown AI outputs I am providing a grade for how well it performed.
It is out of 10.

Lastly, I apologize that this is being submitted a bit later than usual, I have genuinely been slammed with so many 
things. And trust me, this is not me whining or being lazy, I like to put as much focus into these labs as I can, 
so it was difficult to find times to stay true to that since this lab has been assigned.
*/

/*
1. Show all the People data (and only people data) for people who are customers.	
Use joins this time; no subqueries.
*/
Select p.* -- Gives us just the data from the People table
From People p inner join Customers c on p.pid = c.pid;

/*
AI Output: SELECT p.*
		   FROM People p
		   JOIN Customers c ON p.pid = c.pid;

Just the formatting is a bit different, and it just used JOIN instead of inner join, which is 
still valid. Same output as mine too. 10/10
*/

/*
2. Show	all	the	People	data (and only the people data) for people	who	are	agents.	
Use	joins this time; no	subqueries.
*/
Select p.*
From People p inner join Agents a on p.pid = a.pid;

/*
AI Output: SELECT p.*
		   FROM People p
		   JOIN Agents a ON p.pid = a.pid;

Same exact deal as above question. 10/10
*/

/*
3. Show	all	People and Agent data for people who are both customers and agents.	
Use	joins this time; no	subqueries.
*/
Select p.*, a.*
From People p inner join Agents a on p.pid = a.pid
			  inner join Customers c on a.pid = c.pid;

/*
AI Output: SELECT p.*, a.*
		   FROM People p
		   JOIN Customers c ON p.pid = c.pid
		   JOIN Agents a ON p.pid = a.pid;

Still the same exact deal, another 10/10. So far, so good.
*/
  	 
/*
4. Show	the	first name of customers	who	have never placed an order.	Use	subqueries
*/
Select firstName
From People
Where pid in (
	Select pid
	From Customers 
	Where pid not in (
		Select custId
		From Orders
	)
);

/*
AI Output: SELECT firstName
		   FROM People
		   WHERE pid IN (
   			 SELECT c.pid 
    		 FROM Customers c
   			 WHERE c.pid NOT IN (SELECT custId FROM Orders)
			);
			
Still similar deal, this time we have a slight difference. The AI did a good job with
providing Customer c in its subquery, which I actually didn't do. However, the select statement 
for custId from orders is on the same line at the end, which I am sure is fine, but it doesn't feel right.
Still going to give a 10/10 though, because the output is correct.
*/

/*
5. Show	the	first name of customers	who	have never placed an order.	Use	one	inner and	
one	outer join.
*/
Select p.firstName
From People p inner join Customers c on p.pid = c.pid
			  full outer join Orders o on c.pid = o.custId
Where o.custId is NULL; -- We want NULL b/c this gives us the one customer that did not buy anything,
					    -- as there isn't any data there (Note: use * to see this)
/*
AI Output:
SELECT DISTINCT p.firstName
FROM People p
JOIN Customers c ON p.pid = c.pid
LEFT JOIN Orders o ON c.pid = o.custId
WHERE o.orderNum IS NULL;

I did not use distinct first name, which was not stated in the question but now I feel like I should have
done that; the output is still the same though. I really do not like how unspecific the AI is becoming when 
it writes the joins, though. It is again not writing inner join, and now it is not specifying the outer join.
Yes, just writing left join will work, but I really feel like it should instead be saying "left outer join"
For these reasons I will give it a 9/10.
*/

/*
6. Show	the	id and commission percent of Agents who booked	an	order for the	
Customer whose id is 007, sorted by commission percent from high to low. Use joins; no subqueries.
*/
Select a.pid, a.commissionPct
From Agents a inner join Orders o on a.pid = o.agentId
Where o.custId = 007
Order by a.commissionPct DESC;
/*
The above query outputs exactly what is being asked, but includes the duplicates. The question
does not explicitly say to use distinct id and commissionPct, but I am going to  
do that below just incase (for the sake of duplicates).
*/
Select distinct a.pid, a.commissionPct
From Agents a inner join Orders o on a.pid = o.agentId
Where o.custId = 007
Order by a.commissionPct DESC;

/*
AI Output:
SELECT DISTINCT a.pid, a.commissionPct
FROM Agents a
JOIN Orders o ON a.pid = o.agentId
WHERE o.custId = 007
ORDER BY a.commissionPct DESC;

Nothing much to say here, same deal as the first few questions. 10/10
*/

/*
7. Show	the	last name, home	city, and commission percent of Agents	who	booked an	
order for the customer	whose id is	001, sorted	by commission percent from	high to	
low. Use joins.
*/
Select p.lastName, p.homeCity, a.commissionPct
From People p inner join Agents a on p.pid = a.pid
			  inner join Orders o on o.agentId = a.pid
Where o.custId = 001
Order by a.commissionPct DESC;
/*
(Again) The above query outputs exactly what is being asked, but includes the duplicates. The question
does not explicitly say to use distinct lastName, homeCity, and commissionPct, but I am going to 
do that below just incase (for the sake of duplicates).
*/
Select distinct p.lastName, p.homeCity, a.commissionPct
From People p inner join Agents a on p.pid = a.pid
			  inner join Orders o on o.agentId = a.pid
Where o.custId = 001
Order by a.commissionPct DESC;

/*
SELECT DISTINCT p.lastName, p.homeCity, a.commissionPct
FROM People p
JOIN Agents a ON p.pid = a.pid
JOIN Orders o ON a.pid = o.agentId
WHERE o.custId = 001
ORDER BY a.commissionPct DESC;

Again, nothing much to say and this is very similar w/ the above question. 10/10
*/

/*
8. Show	the	last name and home city	of agents who live in a	city that makes	the	fewest	
different kinds	of products. (Hint:	Use	count, group by, and having	on the Products	
table in a subquery.)
*/
Select p.lastName, p.homeCity
From People p inner join Agents a on p.pid = a.pid
Where p.homeCity in (
	Select pr.city
	From Products pr inner join People p on p.homeCity = pr.city
	Group by city
	Having count(*) <= 1
);

/*
AI Output:
SELECT DISTINCT p.lastName, p.homeCity
FROM People p
JOIN Agents a ON p.pid = a.pid
WHERE p.homeCity IN (
    SELECT city 
    FROM Products 
    GROUP BY city 
    HAVING COUNT(DISTINCT prodId) = (
        SELECT MIN(product_count) 
        FROM (SELECT city, COUNT(DISTINCT prodId) AS product_count 
              FROM Products 
              GROUP BY city) AS product_counts
    )
);

This is the first instance where I like the AI output more than mine. I admittedly did not think of doing 
it this way, I struggled to find out out to use MIN() correctly, so I just used count(*) <= 1, which was correct,
but the AI was more specific than me (unfortunately). I will give this a 10/10, and I wish I had done it this way.
*/

/*
9. Show	the	name and id	of all Products	ordered	through	any	Agent who booked at	least	
one	order for a	Customer in	Oyster Bay,	sorted by product name from A to Z. You can	
use	joins or subqueries. Better	yet, impress me	by doing it	both ways.
*/
Select pr.name, pr.prodid
From Products pr inner join Orders o on pr.prodid = o.prodId
Where o.agentId in (
	Select o.agentId
	From Orders o inner join People p on o.custId = p.pid
	Where p.homeCity = 'Oyster Bay'
)
Order by pr.name ASC;

/*
AI Output:
SELECT DISTINCT pr.name, pr.prodId
FROM Products pr
JOIN Orders o ON pr.prodId = o.prodId
WHERE o.agentId IN (
    SELECT DISTINCT a.pid
    FROM Agents a
    JOIN Orders o ON a.pid = o.agentId
    JOIN Customers c ON o.custId = c.pid
    JOIN People p ON c.pid = p.pid
    WHERE p.homeCity = 'Oyster Bay'
)
ORDER BY pr.name ASC;

The AI looks to have made this more complicated than needed. It did a lot of joins within the subquery trying to 
connect the agent and customer ids with orders and people. Instead, I just used agentId from orders to connect it
with custId and then go back to people, and my output was still correct. 
Also, and this could be me overthinking this, the question wants all products, which is why I did not use distinct.
So just for that small reason, I will give a 9.5/10. I could be wrong and the use of distinct should be innate, but 
for that reason alone is why I did not use it.
*/

/*
10. Show the first and last	name of	customers and agents living	in the same	city, along	
with the name of their shared city. (Living in	a city with	yourself does not count, so	
exclude	those from your	results.)
*/
Select c.firstName, c.lastName, a.firstName, a.lastName, c.homeCity
From People c inner join Customers cu on c.pid = cu.pid
			  inner join People a on c.homeCity = a.homeCity
			  inner join Agents ag on a.pid = ag.pid
Where cu.pid <> ag.pid;

/*
AI Output:
SELECT DISTINCT c.firstName AS CustomerFirst, c.lastName AS CustomerLast, 
                a.firstName AS AgentFirst, a.lastName AS AgentLast, 
                c.homeCity
FROM People c
JOIN Customers cu ON c.pid = cu.pid
JOIN People a ON c.homeCity = a.homeCity
JOIN Agents ag ON a.pid = ag.pid
WHERE c.pid <> a.pid;

This question took a bit for the reason that the multiple calls of People made things jumpled, which is 
why I ended up specifying people by c or a to make sure I knew which people I was talking about. I am glad that 
the AI did this too, and it took it a step further by re-naming the first and last names, another thing
that I wish I did, but the output still works fine. 10/10
*/

/*
I feel like the AI did a better job in this lab than the last, oddly enough. I still wish I did number 8 
the same way that the AI went about it, but this is all good practice at the end of the day. These labs
feel like a fun puzzle, and I have been enjoying SQL a lot since starting this class.
*/





