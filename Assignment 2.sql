USE db;

CREATE TABLE Crime ( CrimeID INT PRIMARY KEY, IncidentType VARCHAR(255), IncidentDate DATE, Location VARCHAR(255), Description TEXT, Status VARCHAR(20) ); 
INSERT INTO Crime (CrimeID, IncidentType, IncidentDate, Location, Description, Status) 
VALUES 
 (1, 'Robbery', '2023-09-15', '123 Main St, Cityville', 'Armed robbery at a convenience store', 'Open'), 
 (2, 'Homicide', '2023-09-20', '456 Elm St, Townsville', 'Investigation into a murder case', 'Under  Investigation'), 
 (3, 'Theft', '2023-09-10', '789 Oak St, Villagetown', 'Shoplifting incident at a mall', 'Closed'); 

CREATE TABLE Victim ( VictimID INT PRIMARY KEY, CrimeID INT, Name VARCHAR(255), ContactInfo VARCHAR(255), Injuries VARCHAR(255), FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID) ); 
INSERT INTO Victim (VictimID, CrimeID, Name, ContactInfo, Injuries) 
values
 (1, 1, 'John Doe', 'johndoe@example.com', 'Minor injuries'), 
 (2, 2, 'Jane Smith', 'janesmith@example.com', 'Deceased'),
 (3, 3, 'Alice Johnson', 'alicejohnson@example.com', 'None'); 

CREATE TABLE Suspect (SuspectID INT PRIMARY KEY, CrimeID INT, Name VARCHAR(255), Description TEXT, CriminalHistory TEXT, FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID) ); 
INSERT INTO Suspect (SuspectID, CrimeID, Name, Description, CriminalHistory) 
VALUES 
 (1, 1, 'Robber 1', 'Armed and masked robber', 'Previous robbery convictions'), 
 (2, 2, 'Unknown', 'Investigation ongoing', NULL), 
 (3, 3, 'Suspect 1', 'Shoplifting suspect', 'Prior shoplifting arrests'); 

----------------------------------------------------
SELECT * FROM Crime WHERE Status = 'Open';

----------------------------------------------------
SELECT COUNT(*) AS TotalIncidents FROM Crime;

----------------------------------------------------
SELECT DISTINCT IncidentType FROM Crime;

----------------------------------------------------
SELECT * FROM Crime WHERE IncidentDate BETWEEN '2023-09-01' AND '2023-09-10';

----------------------------------------------------
ALTER TABLE Victim
ADD COLUMN Age INT;
UPDATE Victim SET Age = 30 WHERE VictimID = 1;
UPDATE Victim SET Age = 45 WHERE VictimID = 2;
UPDATE Victim SET Age = 28 WHERE VictimID = 3;

ALTER TABLE Suspect
ADD Age INT;
UPDATE Suspect SET Age = 30 WHERE SuspectID = 1;
UPDATE Suspect SET Age = 25 WHERE SuspectID = 2;
UPDATE Suspect SET Age = 35 WHERE SuspectID = 3;

SELECT VictimID, CrimeID, Name, ContactInfo, Injuries, Age, NULL AS Description, NULL AS CriminalHistory FROM Victim
UNION ALL
SELECT SuspectID, CrimeID, Name, NULL AS ContactInfo, NULL AS Injuries, Age, Description, CriminalHistory FROM Suspect
ORDER BY Age DESC;

----------------------------------------------------
SELECT AVG(Age) AS AverageAge
FROM (SELECT Age FROM Victim UNION ALL SELECT Age FROM Suspect) AS CombinedAges;

----------------------------------------------------
SELECT IncidentType, COUNT(*) AS Incident_Count FROM Crime WHERE Status = 'Open' GROUP BY IncidentType;

----------------------------------------------------
SELECT Name FROM Victim WHERE Name LIKE '%Doe%';

----------------------------------------------------
SELECT Name FROM Victim WHERE CrimeID IN (SELECT CrimeID FROM Crime WHERE Status = 'Open')
UNION
SELECT Name FROM Suspect WHERE CrimeID IN (SELECT CrimeID FROM Crime WHERE Status = 'Open');

SELECT Name FROM Victim WHERE CrimeID IN (SELECT CrimeID FROM Crime WHERE Status = 'Closed')
UNION
SELECT Name FROM Suspect WHERE CrimeID IN (SELECT CrimeID FROM Crime WHERE Status = 'Closed');

----------------------------------------------------
SELECT DISTINCT C.IncidentType FROM Crime C
JOIN (SELECT CrimeID FROM Victim WHERE Age = 30 UNION SELECT CrimeID FROM Suspect WHERE Age = 30 UNION 
SELECT CrimeID FROM Victim WHERE Age = 35 UNION SELECT CrimeID FROM Suspect WHERE Age = 35) AS Incidents30_35 ON C.CrimeID = Incidents30_35.CrimeID;

----------------------------------------------------
SELECT Name, 'Victim' AS Role
FROM Victim JOIN Crime ON Victim.CrimeID = Crime.CrimeID WHERE IncidentType = 'Robbery'
UNION
SELECT Name, 'Suspect' AS Role
FROM Suspect JOIN Crime ON Suspect.CrimeID = Crime.CrimeID WHERE IncidentType = 'Robbery';

----------------------------------------------------
SELECT IncidentType FROM Crime WHERE Status = 'Open' GROUP BY IncidentType HAVING COUNT(*) > 1;

----------------------------------------------------
SELECT DISTINCT C.*, S.Name AS SuspectName FROM Crime C
JOIN Suspect S ON C.CrimeID = S.CrimeID
JOIN Victim V ON C.CrimeID = V.CrimeID AND S.Name = V.Name;

----------------------------------------------------
SELECT C.*, V.Name AS VictimName, V.ContactInfo, V.Injuries, S.Name AS SuspectName, S.Description AS SuspectDescription, S.CriminalHistory
FROM Crime C
LEFT JOIN Victim V ON C.CrimeID = V.CrimeID
LEFT JOIN Suspect S ON C.CrimeID = S.CrimeID;

----------------------------------------------------
SELECT C.IncidentType FROM Crime C
JOIN (SELECT CrimeID FROM Suspect WHERE Age > ANY (SELECT Age FROM Victim WHERE Victim.CrimeID = Suspect.CrimeID)) 
AS IncidentsWithOlderSuspects ON C.CrimeID = IncidentsWithOlderSuspects.CrimeID;

----------------------------------------------------
SELECT Name, COUNT(*) AS Incident_Count FROM Suspect
INNER JOIN Crime ON Suspect.CrimeID = Crime.CrimeID GROUP BY Name HAVING COUNT(*) > 1;

----------------------------------------------------
SELECT * FROM Crime
LEFT JOIN Suspect ON Crime.CrimeID = Suspect.CrimeID WHERE Suspect.SuspectID IS NULL;

----------------------------------------------------
SELECT c.CrimeID, c.IncidentType, c.IncidentDate, c.Location, c.Description, c.Status
FROM Crime c WHERE IncidentType = 'Homicide'
OR (IncidentType = 'Robbery' AND NOT EXISTS (SELECT 1 FROM Crime c2 WHERE c2.CrimeID = c.CrimeID AND c2.IncidentType != 'Robbery'));
  
---------------------------------------------

SELECT c.CrimeID, c.IncidentType, c.IncidentDate, c.Location, c.Description, c.Status,
COALESCE(s.Name, 'No Suspect') AS SuspectName
FROM Crime c LEFT JOIN Suspect s ON c.CrimeID = s.CrimeID;  

----------------------------------------------
SELECT DISTINCT s.SuspectID, s.Name
FROM Suspect s JOIN Crime c ON s.CrimeID = c.CrimeID WHERE c.IncidentType IN ('Robbery', 'Assault');
