CREATE TABLE Artists ( 
ArtistID INT PRIMARY KEY, 
Name VARCHAR(255) NOT NULL, 
Biography TEXT, 
Nationality VARCHAR(100)); -- Create the Categories table 
CREATE TABLE Categories ( 
CategoryID INT PRIMARY KEY, 
Name VARCHAR(100) NOT NULL); -- Create the Artworks table 
CREATE TABLE Artworks ( 
ArtworkID INT PRIMARY KEY, 
Title VARCHAR(255) NOT NULL, 
ArtistID INT, 
CategoryID INT, 
Year INT, 
Description TEXT, 
ImageURL VARCHAR(255), 
FOREIGN KEY (ArtistID) REFERENCES Artists (ArtistID), 
FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID)); -- Create the Exhibitions table 
CREATE TABLE Exhibitions ( 
ExhibitionID INT PRIMARY KEY, 
Title VARCHAR(255) NOT NULL, 
StartDate DATE, 
EndDate DATE, 
Description TEXT); -- Create a table to associate artworks with exhibitions 
CREATE TABLE ExhibitionArtworks ( 
ExhibitionID INT, 
ArtworkID INT, 
PRIMARY KEY (ExhibitionID, ArtworkID), 
FOREIGN KEY (ExhibitionID) REFERENCES Exhibitions (ExhibitionID), 
FOREIGN KEY (ArtworkID) REFERENCES Artworks (ArtworkID));
 INSERT INTO Artists (ArtistID, Name, Biography, Nationality) VALUES 
(1, 'Pablo Picasso', 'Renowned Spanish painter and sculptor.', 'Spanish'), 
(2, 'Vincent van Gogh', 'Dutch post-impressionist painter.', 'Dutch'), 
(3, 'Leonardo da Vinci', 'Italian polymath of the Renaissance.', 'Italian'); 
INSERT INTO Categories (CategoryID, Name) VALUES 
(1, 'Painting'), 
(2, 'Sculpture'), 
(3, 'Photography');
INSERT INTO Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description, ImageURL) VALUES 
(1, 'Starry Night', 2, 1, 1889, 'A famous painting by Vincent van Gogh.', 'starry_night.jpg'), 
(2, 'Mona Lisa', 3, 1, 1503, 'The iconic portrait by Leonardo da Vinci.', 'mona_lisa.jpg'), 
(3, 'Guernica', 1, 1, 1937, 'Pablo Picasso\'s powerful anti-war mural.', 'guernica.jpg');
INSERT INTO Exhibitions (ExhibitionID, Title, StartDate, EndDate, Description) VALUES 
(1, 'Modern Art Masterpieces', '2023-01-01', '2023-03-01', 'A collection of modern art masterpieces.'), 
(2, 'Renaissance Art', '2023-04-01', '2023-06-01', 'A showcase of Renaissance art treasures.');
INSERT INTO ExhibitionArtworks (ExhibitionID, ArtworkID) VALUES 
(1, 1), 
(1, 2), 
(1, 3), 
(2, 2); 
--------------------------------
SELECT Artists.Name, 
COUNT(Artworks.ArtworkID) 
AS ArtworkCount
FROM Artists
LEFT JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY Artists.ArtistID, Artists.Name
ORDER BY ArtworkCount DESC;
---------------------------------
Select Artworks.title
From Artworks
Join Artists on Artists.ArtistID = Artworks.ArtistID
where Artists.Nationality = 'Spanish' or Artists.Nationality = 'Dutch'
order by Artworks.Year;
-----------------------------------
SELECT Artists.Name, COUNT(Artworks.ArtworkID) AS ArtworkCount
FROM Artists
JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
JOIN Categories ON Artworks.CategoryID = Categories.CategoryID
WHERE Categories.Name = 'Painting'
GROUP BY Artists.Name;
------------------------------------
SELECT Artworks.Title, Artists.Name AS Artist, Categories.Name AS Category
FROM Artworks
JOIN ExhibitionArtworks ON Artworks.ArtworkID = ExhibitionArtworks.ArtworkID
JOIN Exhibitions ON ExhibitionArtworks.ExhibitionID = Exhibitions.ExhibitionID
JOIN Artists ON Artworks.ArtistID = Artists.ArtistID
JOIN Categories ON Artworks.CategoryID = Categories.CategoryID
WHERE Exhibitions.Title = 'Modern Art Masterpieces';
------------------------------------------------
SELECT Artists.Name, COUNT(Artworks.ArtworkID) AS ArtworkCount
FROM Artists
JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY Artists.ArtistID, Artists.Name
HAVING COUNT(Artworks.ArtworkID) > 2;
------------------------------------------------
SELECT Artworks.Title
FROM Artworks
JOIN ExhibitionArtworks AS EA1 ON Artworks.ArtworkID = EA1.ArtworkID
JOIN Exhibitions AS E1 ON EA1.ExhibitionID = E1.ExhibitionID
JOIN ExhibitionArtworks AS EA2 ON Artworks.ArtworkID = EA2.ArtworkID
JOIN Exhibitions AS E2 ON EA2.ExhibitionID = E2.ExhibitionID
WHERE E1.Title = 'Modern Art Masterpieces'
AND E2.Title = 'Renaissance Art';
--------------------------------
SELECT Categories.Name AS Category, COUNT(Artworks.ArtworkID) AS ArtworkCount
FROM Categories
JOIN Artworks ON Categories.CategoryID = Artworks.CategoryID
GROUP BY Categories.CategoryID, Categories.Name;
-------------------------------
SELECT Artists.Name
FROM Artists
JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY Artists.ArtistID, Artists.Name
HAVING COUNT(Artworks.ArtworkID) > 3;
-------------------------------
SELECT Artworks.Title, Artists.Name AS Artist
FROM Artworks
JOIN Artists ON Artworks.ArtistID = Artists.ArtistID
WHERE Artists.Nationality = 'Spanish';
--------------------------------
SELECT DISTINCT E1.Title AS Exhibition
FROM Exhibitions AS E1
JOIN ExhibitionArtworks AS EA1 ON E1.ExhibitionID = EA1.ExhibitionID
JOIN Artworks AS A1 ON EA1.ArtworkID = A1.ArtworkID
JOIN Artists AS AR1 ON A1.ArtistID = AR1.ArtistID
JOIN ExhibitionArtworks AS EA2 ON EA1.ExhibitionID = EA2.ExhibitionID
JOIN Artworks AS A2 ON EA2.ArtworkID = A2.ArtworkID
JOIN Artists AS AR2 ON A2.ArtistID = AR2.ArtistID
WHERE AR1.Name = 'Vincent van Gogh'
AND AR2.Name = 'Leonardo da Vinci';
--------------------------------------
SELECT Artworks.Title
FROM Artworks
LEFT JOIN ExhibitionArtworks ON Artworks.ArtworkID = ExhibitionArtworks.ArtworkID
WHERE ExhibitionArtworks.ArtworkID IS NULL;
-----------------------------------------
SELECT Artists.Name
FROM Artists
JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY Artists.ArtistID, Artists.Name
HAVING COUNT(DISTINCT Artworks.CategoryID) = (SELECT COUNT(DISTINCT CategoryID) FROM Categories);
-------------------------------------
SELECT Categories.Name AS Category, COUNT(Artworks.ArtworkID) AS ArtworkCount
FROM Categories
LEFT JOIN Artworks ON Categories.CategoryID = Artworks.CategoryID
GROUP BY Categories.CategoryID, Categories.Name;
--------------------------------------
SELECT Artists.Name
FROM Artists
JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY Artists.ArtistID, Artists.Name
HAVING COUNT(Artworks.ArtworkID) > 2;
------------------------------------------
SELECT Categories.Name AS Category, AVG(Artworks.Year) AS AverageYear
FROM Categories
JOIN Artworks ON Categories.CategoryID = Artworks.CategoryID
GROUP BY Categories.CategoryID, Categories.Name
HAVING COUNT(Artworks.ArtworkID) > 1;
-------------------------------------------
SELECT Artworks.Title
FROM Artworks
JOIN ExhibitionArtworks ON Artworks.ArtworkID = ExhibitionArtworks.ArtworkID
JOIN Exhibitions ON ExhibitionArtworks.ExhibitionID = Exhibitions.ExhibitionID
WHERE Exhibitions.Title = 'Modern Art Masterpieces';
----------------------------------------------
SELECT Categories.Name AS Category, AVG(Artworks.Year) AS CategoryAverageYear
FROM Categories
JOIN Artworks ON Categories.CategoryID = Artworks.CategoryID
GROUP BY Categories.CategoryID, Categories.Name
HAVING AVG(Artworks.Year) > (SELECT AVG(Year) FROM Artworks);
-----------------------------------------------
SELECT Artworks.Title
FROM Artworks
LEFT JOIN ExhibitionArtworks ON Artworks.ArtworkID = ExhibitionArtworks.ArtworkID
WHERE ExhibitionArtworks.ArtworkID IS NULL;
--------------------------------------------------
SELECT Artists.Name
FROM Artists
JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
JOIN Categories ON Artworks.CategoryID = Categories.CategoryID
WHERE Categories.Name = (
    SELECT Categories.Name
    FROM Artworks
    JOIN Categories ON Artworks.CategoryID = Categories.CategoryID
    WHERE Artworks.Title = 'Mona Lisa'
);
--------------------------------------------
SELECT Artists.Name, COUNT(Artworks.ArtworkID) AS ArtworkCount
FROM Artists
JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY Artists.ArtistID, Artists.Name;
-------------------------------------------