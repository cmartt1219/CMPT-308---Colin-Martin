/*
This is the SQL Script for my final relational database project: Music DNA

Even though it took me a long time, I had a blast doing it. This has genuintely been one of my favorite
courses at Marist (University), and this project helped me consolidate everything we did this year into 
one, cohesive, normalized relational database. I love music, and I am very glad that I chose to do this topic,
as I got to work with a large interest of mine, but in a unique fashion with the DNA concept.

I know you said to have this all on GitHub this morning, but I really tried to make this perfect, so
I took a bit of extra time today (I'm sorry!)

I hope you enjoy and I hope that I did enough to impress you. Sit back, relax, and enjoy the Music DNA / Lineage
relational database design!
*/

-- Table Creations --

-- Drop Statements -- 
DROP TABLE IF EXISTS People;
DROP TABLE IF EXISTS RecordLabels;
DROP TABLE IF EXISTS Artists;
DROP TABLE IF EXISTS Producers;
DROP TABLE IF EXISTS Albums;
DROP TABLE IF EXISTS Songs;
DROP TABLE IF EXISTS Samples;
DROP TABLE IF EXISTS Techniques;
DROP TABLE IF EXISTS SampleTechniques;
DROP TABLE IF EXISTS LegalDisputes;
DROP TABLE IF EXISTS ChartPositions;
DROP TABLE IF EXISTS Covers;
DROP TABLE IF EXISTS Collaborations;

-- People --
CREATE TABLE People (
	pid				int not null,
	firstName		text not null,
	lastName		text, -- some artists are a singular name
	DOB				date not null,
	countryFrom		text not null,
	homeCity		text not null,
 primary key(pid)
); -- end People

-- RecordLabel --
CREATE TABLE RecordLabels (
	labelID				  	int not null,
	labelName			  	text not null,
	cityLocated			  	text not null,
	yearsActive			  	int,
	platinumRecordAmount	int check(platinumRecordAmount >= 0),
 primary key(labelID)
); -- end RecordLabel

-- Artists --
CREATE TABLE Artists (
	artistID			int not null references People(pid),
	genreAssociation	text,
	numberOfAlbums		int,
	yearsActive			int,
	discogRating		int check(discogRating between 1 and 10),
	labelID				int references RecordLabels(labelID),
	nickname			text,
 primary key(artistID)
); -- end Artists

-- Producers --
CREATE TABLE Producers (
	prodID					int not null references People(pid),
	genreAssociation		text,
	numberOfProducedSongs	int not null,
	yearsActive				int,
	labelID					int references RecordLabels(labelID),
 primary key(prodID)
); -- end Producers

-- Albums --
CREATE TABLE Albums(
	albumID			int not null,
	artistID		int not null references Artists(artistID),
	title			text not null,
	genre			text not null,
	rating			int check(rating between 1 and 10),
	yearReleased	int not null,
	runtime			interval not null,
 primary key(albumID)
); -- end Albums

-- Songs --
CREATE TABLE Songs (
	songID			int not null,
	artistID		int not null references Artists(artistID),
	title			text not null,
	genre			text not null,
	key				text not null,
	BPM				int not null check(BPM > 0),
	yearReleased	int not null,
	albumID			int references Albums(albumID),
 primary key(songID)
); -- end Songs

-- Samples --
CREATE TABLE Samples (
	sampleID		int not null,
	originalSongID	int not null references Songs(songID),
	sampledSongID	int not null references Songs(songID),
	type			text not null check (type in ('Sample', 'Interpolation', 'Remix', 'Mashup', 'Sound-Alike')),
	sampleDesc		text,
	licensed		boolean not null,
 primary key(sampleID),
 check (originalSongID != sampledSongID)
); -- end Samples

-- Techniques --
CREATE TABLE Techniques (
	techniqueID		int not null,
	method			text not null,
	description		text,
 primary key(techniqueID)
); -- end Techniques

-- SampleTechniques
CREATE TABLE SampleTechniques (
	sampleID		int not null references Samples(sampleID),
	techniqueID		int not null references Techniques(techniqueID),
	whereInSong		text,
 primary key(sampleID, techniqueID)
); -- end SampleTechniques

-- LegalDisputes -- 
CREATE TABLE LegalDisputes (
	disputeID			int not null,
	songID				int not null references Songs(songID),
	plaintiffArtistID	int not null references Artists(artistID),
	defendantArtistID	int not null references Artists(artistID),
	description			text,
	outcome				text check(outcome in ('settled', 'won', 'lost', 'dismissed', 'ongoing', 'undisclosed')),
	dateOfDispute		date not null,
 primary key(disputeID)
); -- end LegalDisputes

-- ChartPositions -- 
CREATE TABLE ChartPositions (
	songID			int not null references Songs(songID),
	chartName		text not null,
	peakPosition	int not null, -- note that a position of 1 means the best
	chartDate		date not null,
 primary key(songID, chartName, chartDate)
); -- end ChartPositions

-- Covers --
CREATE TABLE Covers (
	coverID				int not null,
	coveredSongID		int not null references Songs(songID),
	sourceSongID		int not null references Songs(songID),
	reason				text,
 primary key(coverID),
 check(coveredSongID != sourceSongID)
); -- end Covers

-- Collaborations -- 
CREATE TABLE Collaborations (
	songID			int not null references Songs(songID),
	collaboratorID	int not null references People(pid),
	role			text check(role in ('feature', 'producer', 'co-writer')),
 primary key(songID, collaboratorID, role)
); -- end Collaborations


-- Inserting Data --

INSERT INTO People (pid, firstName,  lastName, 	DOB,     		countryFrom, 		homeCity) 
VALUES			   (1,   'Yung',     'Gravy',   	'1996-03-19', 	'United States',	'Rochester'),
				   (2,   'Kanye',    'West',    	'1977-06-08', 	'United States',	'Atlanta'),
				   (3,   'Lucky',    'Chops',   	'2006-12-19', 	'United States',	'New York City'),
				   (4,   'Robin',    'Thicke',  	'1977-03-10', 	'United States',	'Los Angeles'),
				   (5,   'Marvin',   'Gaye',    	'1939-04-02', 	'United States',	'Washington D.C.'),
				   (6,   'Player',   '',        	'1977-05-06', 	'United States',	'Los Angeles'),
				   (7,   'The',      'Temptations', '1961-03-21', 	'United States',	'Detroit'),
				   (8,   'Stevie',   'Wonder',  	'1950-05-13', 	'United States',	'Saginaw'),
				   (9,   'Coolio',   '',   			'1963-08-01', 	'United States',	'Monessen'),
				   (10,  'Vanilla',  'Ice',   		'1967-10-31', 	'United States',	'Dallas'),
				   (11,  'Queen',    '',   			'1970-06-27', 	'England',			'London'),
				   (12,  'David',    'Bowie',   	'1947-01-08', 	'England',			'Brixton'),
				   (13,  'Lenny',    'Kravitz',   	'1964-05-26', 	'United States',	'New York City'),
				   (14,  'Childish', 'Gambino',    '1983-09-25', 	'United States',	'Edwards Air Force Base'),
				   (15,  'Steely',   'Dan',   		'1971-02-06', 	'United States',	'Annandale-on-Hudson'),
				   (16,  'Kendrick', 'Lamar',   	'1987-06-17', 	'United States',	'Compton'),
				   (17,  'Jay',    	 'Rock',   		'1985-03-31', 	'United States',	'Watts'),
				   (18,  'Pharell',  'Williams',   '1973-04-05', 	'United States',	'Virginia Beach'),
				   (19,  'Beach',    'House',   	'2004-06-24', 	'United States',	'Baltimore'),
				   (20,  'Journey',  '',   			'1973-12-31', 	'United States',	'San Francisco'),
				   (21,  'Time',     'Check',   	'1994-12-02', 	'United States',	'Poughkeepsie'),
				   (22,  'Alan',     'Labouseur',   '1968-01-23', 	'United States',	'Albany');

INSERT INTO RecordLabels (labelID,  labelName,  		  		cityLocated,  		yearsActive,  platinumRecordAmount)
VALUES					  (100, 	 'Republic Records',		'New York City',	30,		  	  600),
						  (101, 	 'GOOD Music',	      		'Chicago',	    	21,			  21),
						  (102, 	 'Interscope Records', 		'Santa Monica',		36,			  1000),
						  (103, 	 'Motown',	  		  		'Detroit',			67,		  	  53),
						  (104, 	 'RSO Records',	  			'London',			10,		  	  22),
						  (105, 	 '$BK Records',	  	    	'New York City',	9,		  	  10),
						  (106, 	 'Parlophone',	  			'London',			129,		  45),
						  (107, 	 'Virgin Records',	  		'Los Angeles',		53,		  	  77),
						  (108, 	 'RCA Records',	  			'New York City',	124,		  400),
						  (109, 	 'pgLang',	  				'Los Angeles',		5,		  	  3),
						  (110, 	 'Top Dog Entertainment',	'Carson',			21,		      51),
						  (111, 	 'SubPop Records',	  		'Seattle',			39,		      5),
						  (112, 	 'Columbia Records',	    'Washington D.C.',	38,		  	  331),
						  (113,		 'Warner Records',			'Los Angeles',		66,			  389);

INSERT INTO Artists (artistID, genreAssociation,  numberOfAlbums, 	yearsActive,     discogRating,  labelID, nickname) 
VALUES			   	(1,   		'Hip-Hop',     	   7,   			9, 				 7,				100,	  'Mr. Buttersworth'),
				   	(2,   		'Hip-Hop',    	   15,    	        29, 			 9,				101,	  'Yeezy'),
				   	(3,   		'Brass Pop',       7,   			19, 			 9,				NULL, 	  'The Chops'),
				   	(4,   		'R&B',    		   8,  				24, 			 6,				102,      'Thicke'),
				   	(5,   		'Soul',   		   25,    			27, 			 9,				103, 	  'The Prince of Soul'),
				   	(6,   		'Rock',   		   5,        	    35, 	         8,				104,      'The Guys that Made Baby Come Back'),
				   	(7,   		'Soul',      	   43,				65, 			 8, 			103,	  'The Emperors of Soul'),
				   	(8,   		'R&B',   		   23,  			64, 			 10,			103,      ''),
				   	(9,   		'Hip-Hop',   	   8,   			35, 	         7,	            112,      ''),
				   	(10,  		'Hip-Hop',    	   6,   			39, 			 5,				105,	  ''),
				   	(11,  		'Rock',      	   15,   			54, 			 9,			    106,      'The Kings of Arena Rock'),
				   	(12,  		'Rock',     	   26,   	 		54, 			 8,				106,	  'Ziggy Stardust'),
				   	(13,  		'Funk',    		   11,   			35, 			 8,				107,	  ''),
				   	(14,  		'Hip-Hop', 		   4,    			16, 			 10,			108,	  'Bino'),
				   	(15,  		'Rock',   		   9,   		    37, 			 9,				113,	  'Dan'),
				   	(16,  		'Hip-Hop', 		   7,   			20, 			 10,			109,      'K-Dot'),
				   	(17,  		'Hip-Hop',    	   3,   			8, 				 8,				110,      ''),
				   	(18,  		'Hip-Hop',  	   2,   			32, 	         7,				107,	  'Skateboard P'),
				   	(19,  		'Indie',    	   8,   			20, 			 8,				111,	  ''),
				   	(20,  		'Rock',  		   15,   			51, 			 9,				112,	  ''),
				   	(21,  		'A Cappella',      3,   	        30, 	         10,	        NULL,     'Marists BEST A Cappella Group');

INSERT INTO Producers (prodID,	genreAssociation,	numberOfProducedSongs,	yearsActive, labelID)
VALUES				   (2, 		'Hip-Hop',			600,					29, 		 101),
					   (4, 		'R&B',				125,					31, 		 102),
					   (5, 		'Soul',			    50,						27, 		 103),
					   (8, 		'R&B',				200,					64, 		 103),
					   (13, 	'Funk',				193,					36, 		 107),
					   (14, 	'Hip-Hop',			50,						17, 		 108),
					   (16, 	'Hip-Hop',			30,						21, 		 109),
					   (18, 	'Hip-Hop',			661,					33, 		 107),
					   (22, 	'Alpaca-Rock',		19,						20, 		 102);
				   	
INSERT INTO Albums (albumID,	artistID,	title,								genre,			rating,	yearReleased,	runtime)
VALUES				(200,		1,			'Cheryl (Single)',					'Hip-Hop',		9,		2017,			INTERVAL '2 minutes 49 seconds'),
					(201,		2,			'Graduation',						'Hip-Hop',		9,		2007,			INTERVAL '54 minutes 29 seconds'),
					(202,		3,			'NYC',								'Brass Pop',	8,		2015,			INTERVAL '35 minutes 37 seconds'),
					(203,		4,			'Blurred Lines',					'R&B',			7,		2013,			INTERVAL '1 hour 2 minutes'),
					(204,		5,			'Live at the London Palladium',	'Soul',			8,		1977,			INTERVAL '1 hour 18 minutes'),
					(205,		6,			'Player (Self Titled)',				'Soft Rock',	8,		1977,			INTERVAL '39 minutes 56 seconds'),
					(206,		7,			'The Temptations Sing Smokey',		'Soul',			8,		1964,			INTERVAL '33 minutes 49 seconds'),
					(207,		8,			'Songs in the Key of Life',			'R&B',			10,		1976,			INTERVAL '1 hour 45 minutes'),
					(208,		9,			'Gangstas Paradise',				'Hip-Hop',		8,		1964,			INTERVAL '1 hour 4 minutes'),
					(209,		10,			'To The Extreme',					'Hip-Hop',		6,		1990,			INTERVAL '57 minutes 53 seconds'),
					(210,		11,			'Hot Space',						'Rock',			9,		1982,			INTERVAL '48 minutes 18 seconds'),
					(211,		13,			'5',								'Funk Rock',	8,		1998,			INTERVAL '1 hour 15 minutes'),
					(212,		14,			'Kauai',							'R&B',			8,		2014,			INTERVAL '28 minutes 7 seconds'),
					(213,		15,			'The Royal Scam',					'Jazz Fusion',	9,		1976,			INTERVAL '41 minutes 17 seconds'),
					(214,		16,			'good kid, m.A.A.d city',			'Hip-Hop',		10,		2012,			INTERVAL '1 hour 32 minutes'),
					(215,		19,			'Teen Dream',						'Indie Rock',	9,		2010,			INTERVAL '48 minutes 46 seconds'),
					(216,		20,			'Frontiers',						'Rock',			9,		1983,			INTERVAL '43 minutes 47 seconds'),
					(217,		21,			'Offce Hours',						'A Cappella',	10,		2024,			INTERVAL '10 minutes 19 seconds');

INSERT INTO Songs (songID,	artistID,	title,								genre,			key,				BPM,	yearReleased,	albumID)
VALUES			  (300,		1,			'Cheryl',							'Hip-Hop',		'C Minor',			76,		2017,			200),
				  (301,		2,			'Champion',							'Hip-Hop',		'F Sharp Major',	102,	2007,			201),
				  (302,		3,			'My Girl',							'Brass Funk',	'C Major',			105,	2015,			202),
				  (303,		4,			'Blurred Lines',					'R&B',			'G Major',			120,	2013,			203),
				  (304,		5,			'Got to Give it Up',				'Soul',			'D Major',			123,	1977,			204),
				  (305,		6,			'Baby Come Back',					'Soft Rock',	'F Minor',			156,	1977,			205),
				  (306,		7,			'My Girl',							'Soul',			'C Major',			105,	1964,			206),
				  (307,		8,			'Pastime Paradise',					'Soul',			'C Minor',			79,		1976,			207),
				  (308,		9,			'Gangstas Paradise',				'Hip-Hop',		'A Flat Major',		80,		1995,			208),
				  (309,		10,			'Ice Ice Baby',						'Hip-Hop',		'D Minor',			116,	1990,			209),
				  (310,		11,			'Under Pressure',					'Rock',			'D Major',			114,	1981,			210),
				  (311,		13,			'Thinking of You',					'Funk Rock',	'A Major',			167,	1998,			211),
				  (312,		14,			'Sober',							'R&B',			'C Major',			98,		2014,			212),
				  (313,		15,			'Kid Charlemagne',					'Jazz Fusion',	'C Major',			97,		1976,			213),
				  (314,		16,			'Money Trees',						'Hip-Hop',		'G Major',			72,		2012,			214),
				  (315,		19,			'Silver Soul',						'Indie Rock',	'D Major',			135,	2010,			215),
				  (316,		20,			'Seperate Ways (Worlds Apart)',	'Rock',			'C Major',			131,	1983,			216),
				  (317,		21,			'Seperate Ways (Worlds Apart)',	'A Cappella',	'B flat Major',		131,	2024,			217);

INSERT INTO Samples (sampleID,	originalSongID,	sampledSongID,	type,				sampleDesc,											licensed)
VALUES				(400,		305,			300,			'Sample',			'Melodic sample from chorus',						TRUE),
					(401,		313,			301,			'Interpolation',	'Interpolates instrumental groove',				TRUE),
					(402,		307,			308,			'Sample',			'Sample of main instrumental and chorus',			TRUE),
					(403,		310,			309,			'Sample',			'Sample of bassline and piano',					FALSE),
					(404,		311,			312,			'Sample',			'Sample of guitar riff and chord progression',		TRUE),
					(405,		315,			314,			'Sample',			'Vocal and instrumental flipped into beat',		TRUE),
					(406, 		304, 			303, 			'Sound-Alike', 		'Song sounds a little to similar to another one', 	FALSE);

INSERT INTO Techniques (techniqueID,	method, 			description)
VALUES					(500, 			'Chopping', 		'Slicing and rearranging segments of the original audio'),
    					(501, 			'Looping', 			'Repeating a section of audio as a rhythmic or melodic loop'),
    					(502, 			'Pitch Shifting', 	'Changing the pitch of the original audio sample'),
    					(503, 			'Time Stretching', 	'Altering the speed of the sample without affecting pitch'),
    					(504, 			'EQ Filtering', 	'Isolating or enhancing frequencies in the original sample'),
    					(505, 			'Interpolation', 	'Replaying or recreating a sample rather than directly sampling it');

INSERT INTO SampleTechniques (sampleID, techniqueID, 	whereInSong)
VALUES						  (400,		 500, 			'Used in the hook'),
    						  (400, 	 501, 			'Looped during the intro and chorus'),
							  (401, 	 505, 			'Replayed groove in main beat'),
    						  (402,      501, 			'Looped as the songs base melody'),
   			 				  (402, 	 504, 			'EQ filtered to emphasize synth line'),
    						  (403, 	 501, 			'Looped bassline in entire instrumental'),
    						  (403, 	 502, 			'Pitch shifted slightly for tempo match'),
    						  (404, 	 500, 			'Chopped guitar riff in bridge'),
    						  (404,		 504, 			'Filtered mid frequencies of original'),
    						  (405, 	 503, 			'Time-stretched intro vocals'),
    						  (405, 	 500, 			'Chopped instrumental to create hook');

INSERT INTO LegalDisputes (disputeID,	songID,	plaintiffArtistID,	defendantArtistID,	description,																	outcome,	dateOfDispute)
VALUES					   (600, 		303, 	5, 					4, 					'Feel and sound of Blurred Lines was deemed too similar to Marvins song', 		'settled', '2015-03-10'),
						   (601, 		309, 	11,		 			10, 				'Ice Ice Baby copied bassline from Under Pressure by Queen and David Bowie', 	'settled', '1991-01-01');

INSERT INTO ChartPositions (songID, chartName, 					peakPosition, 	chartDate)
VALUES						(300, 	'Billboard Hot 100', 			78, 			'2017-06-01'),    
    						(301, 	'Billboard Hot 100', 			18, 			'2007-09-10'),    
    						(302, 	'Jazz Digital Songs', 			13, 			'2015-03-18'),   
    						(303, 	'Billboard Hot 100', 			1, 				'2013-07-15'),     
    						(304, 	'Billboard R&B', 				1, 				'1977-06-10'),         
    						(305, 	'Billboard Hot 100', 			1, 				'1978-01-02'),     
    						(306, 	'Billboard Hot 100', 			1, 				'1965-01-08'),     
    						(307, 	'Billboard Soul', 				13, 			'1976-12-01'),       
    						(308, 	'Billboard Hot 100', 			1, 				'1995-10-15'),     
    						(309, 	'Billboard Hot 100', 			1, 				'1990-11-03'),     
    						(310, 	'UK Singles Chart', 			29,	 			'1981-12-15'),     
    						(311, 	'Adult Alternative Songs', 		31, 			'1998-07-05'),  
    						(312, 	'R&B/Hip-Hop Digital Songs', 	41, 			'2014-11-12'), 
    						(313, 	'Billboard 200', 				66, 			'1976-09-20'),        
    						(314, 	'Billboard Hot 100', 			30, 			'2012-11-05'),    
    						(315, 	'Billboard Rock Songs', 		22, 			'2010-04-02'), 
    						(316, 	'Billboard Hot 100', 			8, 				'1983-04-10'),     
    						(317, 	'A Cappella Weekly', 			1, 				'2024-03-01');     

INSERT INTO Covers (coverID,	coveredSongID,	sourceSongID,	reason)
VALUES			    (700,		302,			306,			'Live brass reinterpretation'),
					(701,		317,			316,			'The arrangement was too damn good');

INSERT INTO Collaborations (songID,	collaboratorID,		role)
VALUES						(303, 		18, 				'producer'), 
							(310, 		12, 				'feature'),   
							(313, 		22, 				'producer'),  
    						(314, 		17, 				'feature');   

-- Views --

/*
Display a view that shows the full music lineage between sampled songs and covers
*/
DROP VIEW IF EXISTS SongLineage;
CREATE VIEW SongLineage AS
	SELECT s.songID, s.title AS songTitle, 'Sample' AS relationType, src.title AS relatedSongTitle 
	FROM Samples samp INNER JOIN Songs s ON samp.sampledSongID = s.songID
					  INNER JOIN Songs src ON samp.originalSongID = src.songID
	UNION
	SELECT c.coveredSongID, s.title AS songTitle, 'Cover' AS relationType, src.title AS relatedSongTitle   
	FROM Covers c INNER JOIN Songs s ON c.coveredSongID = s.songID
				  INNER JOIN Songs src ON c.sourceSongID = src.songID;

SELECT *
FROM SongLineage;

/*
Display all albums that are considered to be "top rated" with a rating of 9 or higher
*/
DROP IF EXISTS VIEW TopRatedAlbums;
CREATE VIEW TopRatedAlbums AS
	SELECT a.title AS albumTitle, p.firstName, p.lastName, ar.nickname, a.rating, a.runtime    
	FROM Albums a INNER JOIN Artists ar ON a.artistID = ar.artistID
				  INNER JOIN People p ON p.pid = ar.artistID
	WHERE a.rating >= 9;

SELECT *
FROM TopRatedAlbums;

/*
Display all songs that hit number 1 on a particular chart
*/
DROP VIEW IF EXISTS NumberOneHits;
CREATE VIEW NumberOneHits AS
	SELECT s.title AS songTitle, p.firstName, p.lastName, c.chartName, c.chartDate
	FROM ChartPositions c INNER JOIN Songs s ON c.songID = s.songID
						  INNER JOIN Artists a ON s.artistID = a.artistID
						  INNER JOIN People p on a.artistID = p.pid
	WHERE c.peakPosition = 1;

SELECT *
FROM NumberOneHits;

-- Queries -- 

/*
Get all sampled songs that are in a different key than the song it samples
*/
SELECT s.sampleID, samp.title AS sampledSongTitle, samp.key AS sampledKey, 
	   orig.title AS originalSongTitle, orig.key AS originalKey
FROM Samples s INNER JOIN Songs samp on s.sampledSongID = samp.songID
			   INNER JOIN Songs orig on s.originalSongID = orig.songID
WHERE samp.key != orig.key;

/*
Get all titles, artists, genres, and the year released of songs produced by Alan Labouseur
*/
SELECT s.title AS songTitle, p.firstName, p.lastName, s.genre, s.yearReleased
FROM Collaborations c INNER JOIN Songs s on c.songID = s.songID
					  INNER JOIN Artists a on s.artistID = a.artistID
					  INNER JOIN People p on a.artistID = p.pid
WHERE c.collaboratorID = 22 AND c.role = 'producer';

/*
Get all top charting songs with the artists nickname, in order by discography rating (highest to lowest)
*/
SELECT s.title as song, a.nickname, a.discogRating, c.chartName, c.peakPosition
FROM Songs s INNER JOIN Artists a on s.artistID = a.artistID
			 INNER JOIN chartPositions c on s.songID = c.songID
WHERE c.peakPosition = 1
ORDER BY a.discogRating DESC;

/*
Get the most common sampling techniques, from lowest count to highest
*/
SELECT t.method, COUNT(st.sampleID) as techniqueCount
FROM SampleTechniques st INNER JOIN Techniques t on st.techniqueID = t.techniqueID
GROUP BY t.method
ORDER BY techniqueCount ASC;


-- Stored Procedures --

-- Get the amount of songs a producer produced on --
CREATE OR REPLACE FUNCTION getProducerSongCount(pid INT)
RETURNS INT AS 
$$
DECLARE
    count INT;
BEGIN
    SELECT COUNT(*) INTO count
    FROM Collaborations
    WHERE collaboratorID = pid AND role = 'producer';
    RETURN count;
END;
$$ 
LANGUAGE plpgsql;

SELECT getProducerSongCount(18);

-- Get all songs that sampled a song by a specified artist --
CREATE OR REPLACE FUNCTION getSampledByArtist(artistPID INT)
RETURNS TABLE (
    sampledSongTitle TEXT,
    originalSongTitle TEXT,
    samplingArtist TEXT
) 
AS 
$$
BEGIN
    RETURN QUERY
    SELECT 
        s2.title AS sampledSongTitle,
        s1.title AS originalSongTitle,
        p2.firstName || ' ' || COALESCE(p2.lastName, '') AS samplingArtist
    FROM Songs s1 INNER JOIN Samples sp ON s1.songID = sp.originalSongID
    			  INNER JOIN Songs s2 ON s2.songID = sp.sampledSongID
    			  INNER JOIN Artists a2 ON a2.artistID = s2.artistID
    			  INNER JOIN People p2 ON p2.pid = a2.artistID
    WHERE s1.artistID = artistPID;
END;
$$ 
LANGUAGE plpgsql;

SELECT * 
FROM getSampledByArtist(13);

-- Get all collaborators and their roles for a song --
CREATE OR REPLACE FUNCTION getSongCollaborations(song_id INT)
RETURNS TABLE (
    collaborator TEXT,
    role TEXT
) 
AS 
$$
BEGIN
    RETURN QUERY
    SELECT 
        p.firstName || ' ' || COALESCE(p.lastName, '') AS collaborator,
        c.role
    FROM Collaborations c
    JOIN People p ON p.pid = c.collaboratorID
    WHERE c.songID = song_id;
END;
$$ 
LANGUAGE plpgsql;

SELECT * 
FROM getSongCollaborations(314);

-- Triggers --

/*
Raise a notice when sampled songs are happening to often
*/
CREATE OR REPLACE FUNCTION tooManyTimesSampled() 
RETURNS TRIGGER AS 
$$
DECLARE
    sampleCount INT;
BEGIN
    SELECT COUNT(*) INTO sampleCount
    FROM Samples
    WHERE originalSongID = NEW.originalSongID;

    IF sampleCount >= 3 THEN
        RAISE NOTICE 'Song ID % has now been sampled % times.', NEW.originalSongID, sampleCount + 1;
    END IF;

    RETURN NEW;
END;
$$ 
LANGUAGE plpgsql;

CREATE TRIGGER trg_tooManyTimesSampled
BEFORE INSERT ON Samples
FOR EACH ROW
EXECUTE FUNCTION tooManyTimesSampled();

-- Example of tooManyTimesSampled() --
INSERT INTO Samples (sampleID, originalSongID, sampledSongID, type, sampleDesc, licensed)
VALUES 				(319, 305, 600, 'Sample', 'Use in verse melody', TRUE),
 					(320, 305, 601, 'Sample', 'Instrumental bridge', TRUE),
 					(321, 305, 602, 'Sample', 'Bassline sample', TRUE),
					(322, 305, 603, 'Sample', 'Subtle drum loop reuse', TRUE);

/*
Raise a notice when a song made by a bad artist gets added
*/
CREATE OR REPLACE FUNCTION warnLowRatingArtist() 
RETURNS TRIGGER AS 
$$
DECLARE
    rating INT;
BEGIN
    SELECT discogRating INTO rating
    FROM Artists
    WHERE artistID = NEW.artistID;

    IF rating < 5 THEN
        RAISE NOTICE 'Artist ID % has a discography rating below 5. Track: "%"', NEW.artistID, NEW.title;
    END IF;

    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER trg_warnLowRatingArtist
BEFORE INSERT ON Songs
FOR EACH ROW
EXECUTE FUNCTION warnLowRatingArtist();

-- Example of warnLowRatingArtist() -- 
INSERT INTO Artists (artistID, genreAssociation, numberOfAlbums, yearsActive, discogRating, labelID, nickname)
VALUES				(22,		'Alpaca-Rock',	  7,			  12,			4,			  100, 	   '')

INSERT INTO Songs (songID,	artistID,	title,			   genre,		  key,		  BPM,	yearReleased,	albumID)
VALUES 			   (999,  	22,   		'Noise Symphony', 'Avant-Garde', 'F# Minor', 60, 	2025, 			NULL);



-- Security/Roles --

CREATE ROLE Agent;
GRANT SELECT
ON Artists, Songs, ChartPositions, Albums
TO Agent

CREATE ROLE Admin;
GRANT ALL
ON ALL TABLES IN SCHEMA PUBLIC
TO Admin;

CREATE ROLE MusicReviewer;
GRANT INSERT, UPDATE
ON Albums, Artists
TO MusicReviewer















