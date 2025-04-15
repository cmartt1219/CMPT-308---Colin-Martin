/*
Lab 8: Normalization Two (Questions 2-4)
Name: Colin Martin
The following SQL has the creation of all my tables (along with some inserted data, as I wanted to give it some meat,
aswell as something to work with for question 4). It also includes all of the functional dependencies, and the query
to get the directors how worked with actor Roger Moore. I hope that this is sufficient and follows the directions as
much as possible. I feel that it does, and I had a great time creating my first database in SQL!
*/

-- Question 2
drop table if exists Address;
drop table if exists People;
drop table if exists Actors;
drop table if exists Directors;
drop table if exists Features;
drop table if exists Spouse;
drop table if exists Movie;
drop table if exists ActorMovie;
drop table if exists DirectorMovie;

-- Address -- 
create table Address(
	addressID		int,
	houseNumber		text not null, -- text b/c it can contain letters and nums
	streetName		text not null,
	city			text not null,
	country			text not null,
 primary key(addressID)
); -- end Address

-- People --
create table People(
	Pid				int not null,
	firstName			text not null,
	lastName			text not null,
	DOB				date not null,
	addressID			int references Address(addressID),
	favoriteColor			text,
 primary key(Pid)
); -- end People

-- Actors --
create table Actors(
	Pid				 int not null references People(Pid),
	sagAnniversary	 		 date,
 primary key(Pid)
); -- end Actors

-- Directors --
create table Directors(
	Pid			int not null references People(Pid),
	filmSchoolAttended	text,
	dgaAnniversary		date,
	favoriteLensMaker	text,
 primary key(Pid)
); -- end Directors

-- Features --
create table Features(
	Pid			int not null references People(Pid),
	hairColor		text,
	eyeColor	    	text not null,
	heightInInches		int not null,
	weight			int not null,
 primary key(Pid)
); -- end Features

-- Spouse --
create table Spouse(
	Pid		 int not null references People(Pid),
	spouseFirstName	 text not null,
	spouseLastName	 text not null,
 primary key(Pid)
); -- end Spouse

-- Movie --
create table Movie(
	Mid			int not null,
	movieName	  	text not null,
	yearReleased  		int not null, 
	mpaaNumber		text, 
	domesticSales		decimal(19,4),
	foreignSales		decimal(19,4),
	dvdBlueraySales		decimal(19,4),
 primary key(Mid)
); -- end Movies

-- ActorMovie --
create table ActorMovie(
	actorID	 int not null references Actors(Pid),
	movieID	 int not null references Movie(Mid),
 primary key(actorID, movieID)
); -- end ActorMovie

-- DirectorMovie --
create table DirectorMovie(
	directorID	int not null references Directors(Pid),
	movieID		int not null references Movie(Mid),
 primary key(directorID, movieID)	
); -- end DirectorMovie


-- It is not asked, but I used AI to generate some real (and random) data to give it some substance --

-- Address --
INSERT INTO Address (addressID, houseNumber, streetName, 			city, 			country) 
VALUES		    (1, 	'742', 	     'Evergreen Terrace',  		'Springfield', 		'USA'),
		    (2, 	'10', 	     'Downing Street', 	   		'London', 		'UK'),
		    (3, 	'221B',      'Baker Street', 			'London', 		'UK'),
		    (4, 	'5', 	     'Bond Street', 			'London', 		'UK'),
		    (5, 	'300', 	     'Sunset Blvd', 			'Los Angeles', 		'USA'),
		    (6, 	'99', 	     'Ocean Avenue', 			'Miami', 		'USA'),
		    (7, 	'77', 	     'Director Lane', 			'London', 		'UK'),
		    (8, 	'88', 	     'Cinema Blvd', 			'Wellington', 		'New Zealand');

-- People --
INSERT INTO People (Pid, firstName, lastName, 	DOB, 			addressID, favoriteColor) 
VALUES		   (1,  'Sean',     'Connery',  '1930-08-25', 		2, 	   'Green'),
		   (2, 'George',    'Lazenby', 	'1939-09-05', 		3, 	   'Blue'),
		   (3, 'Roger',     'Moore', 	'1927-10-14', 		4,         'Red'),
		   (4, 'Timothy',   'Dalton', 	'1946-03-21', 		5, 	   'Gray'),
		   (5, 'Pierce',    'Brosnan', 	'1953-05-16', 		6, 	   'Navy'),
		   (6, 'Daniel',    'Craig', 	'1968-03-02', 		1, 	   'Black'),
		   (7, 'Sam', 	    'Mendes', 	'1965-08-01', 		7, 	   'Teal'),  -- director
		   (8, 'Martin',    'Campbell', '1943-10-24', 		8, 	   'Olive'); -- director

-- Actors --
INSERT INTO Actors (Pid, sagAnniversary) 
VALUES		   (1,   '1961-03-01'),
		   (2, 	 '1968-01-15'),
		   (3,   '1971-04-22'),
		   (4,   '1986-11-10'),
		   (5,	 '1994-06-30'),
		   (6,	 '2005-02-18');

-- Directors --
INSERT INTO Directors (Pid, filmSchoolAttended, 	   dgaAnniversary,  favoriteLensMaker) 
VALUES		      (7,   'Cambridge Film School',       '2000-09-01',   'Zeiss'),
		      (8,   'New Zealand Film School',     '1980-06-01',   'Panavision');

-- Features -- 
INSERT INTO Features (Pid, hairColor, 	 eyeColor,  heightInInches, weight) 
VALUES		     (1,   'Black',   	 'Brown',   74, 	    185),
		     (2,   'Brown',   	 'Green',   72, 	    175),
		     (3,    NULL,	 'Blue',    73, 	    180), -- bald
		     (4,   'Brown',   	 'Hazel',   74, 	    190),
		     (5,   'Dark Brown', 'Blue',    71, 	    170),
		     (6,   'Blond', 	 'Blue',    70, 	    165);

-- Spouse --
INSERT INTO Spouse (Pid, spouseFirstName, spouseLastName) 
VALUES             (1,   'Micheline',     'Roquebrune'),
		   (5, 	  'Keely', 	  'Shaye'),
		   (6, 	  'Rachel',       'Weisz');

-- Movie -- 
INSERT INTO Movie (Mid,  movieName,    				yearReleased, mpaaNumber, domesticSales, foreignSales,  dvdBlueraySales) 
VALUES		  (101,  'Goldfinger', 				1964, 	      '12345', 	   51000000, 	  60000000, 	 1000000),
		  (102, 'On Her Majesty’s Secret Service', 	1969, 	      '23456', 	   22000000, 	  30000000, 	 800000),
		  (103, 'The Spy Who Loved Me', 		1977, 	      '34567', 	   46000000, 	  50000000, 	 900000),
		  (104, 'GoldenEye', 				1995, 	      '45678', 	   52000000, 	  78000000, 	 1100000),
		  (105, 'Skyfall', 				2012, 	      '56789', 	   304000000, 	  804000000, 	 2500000),
		  (106, 'Casino Royale', 			2006, 	      '67890', 	   150000000, 	  426000000,	 2000000);

-- ActorMovie -- 
INSERT INTO ActorMovie (actorID, movieID) 
VALUES		       (1,       101),
		       (2, 	 102),
		       (3, 	 103),
		       (5, 	 104),
		       (6,       105),
		       (6, 	 106); -- Daniel Craig in two films

-- DirectorMovie --
INSERT INTO DirectorMovie (directorID, movieID) 
VALUES			  (8, 	       106),    
			  (7, 	       103);  -- Let's say Sam Mendes directed The Spy Who Loved Me, for the sake of this lab

/*
3) Functional Dependencies:
Address Table: addressID --> [houseNumber, streetName, city, country]
People Table: Pid --> [firstName, lastName, DOB, addressID, favoriteColor]
Actors Table: Pid --> [sagAnniversary]
Directors Table: Pid --> [filmSchoolAttended, dgaAnniversary, favoriteLensMaker]
Features Table: Pid --> [hairColor, eyeColor, heightInInches, weight]
Spouse Table: Pid --> [spouseFirstName, spouseLastName]
Movie Table: Mid --> [movieName, yearReleased, mpaaNumber, domesticSales, foreignSales, dvdBlueraySales]
ActorMovie Table: (actorID, movieID) --> [Empty Set] (So, it is only functionally dependent on the key except itself)
DirectorMovieTable: (directorID, movieID) --> [Empty Set] (Same deal as above)
*/

-- 4) Query for Roger Moore --
Select d.firstName, d.lastName
From People p 	inner join ActorMovie am on p.Pid = am.actorID
			 	inner join DirectorMovie dm on dm.movieID = am.movieID
				inner join People d on dm.directorID = d.Pid
Where p.firstName = 'Roger' and p.lastName = 'Moore';







