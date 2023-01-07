USE iths;

DROP TABLE IF EXISTS UNF;

CREATE TABLE `UNF` (
    `Id` DECIMAL(38, 0) NOT NULL,
    `Name` VARCHAR(26) NOT NULL,
    `Grade` VARCHAR(11) NOT NULL,
    `Hobbies` VARCHAR(25),
    `City` VARCHAR(10) NOT NULL,
    `School` VARCHAR(30) NOT NULL,
    `HomePhone` VARCHAR(15),
    `JobPhone` VARCHAR(15),
    `MobilePhone1` VARCHAR(15),
    `MobilePhone2` VARCHAR(15)
)  ENGINE=INNODB;

LOAD DATA INFILE '/var/lib/mysql-files/denormalized-data.csv'
	INTO TABLE UNF
	CHARACTER SET latin1
	FIELDS TERMINATED BY ','
	ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;

/* Normalisera Student */

DROP TABLE IF EXISTS Student;

CREATE TALBE Student (
	StudentId INT NOT NULL,
	FirstName VARCHAR(255) NOT NULL,
	LastName VARCHAR(255) NOT NULL,
	CONSTRAINT PRIMARY KEY(StudentId)
)  ENGINE=INNODB;

INSERT INTO Student (StudentId, FirstName, LastName)
SELECT DISTINCT Id, SUBSTRING_INDEX(Name, ' ', 1), SUBSTRING_INDEX(Name, ' ', -1)
FROM UNF;

/* Normalisera Phone */

DROP TABLE IF EXISTS Phone;

CREATE TABLE Phone(
	PhoneId INT NOT NULL AUTO_INCREMENT,
	StudentId INT NOT NULL,
	PhoneType VARCHAR(32),
	PhoneNumber VARCHAR(255),
	CONSTRAINT PRIMARY KEY(PhoneId)
) ENGINE=INNODB;

INSERT INTO Phone(StudentId, PhoneType, PhoneNumber)
	SELECT Id AS StudentId, "Home" AS PhoneType, HomePhone AS PhoneNumber FROM UNF
	WHERE HomePhone IS NOT NULL AND HomePhone != ''
	UNION SELECT Id AS StudentId, "Job" AS PhoneType, JobPhone AS PhoneNumber FROM UNF
        WHERE JobPhone IS NOT NULL AND JobPhone != ''
	UNION SELECT Id AS StudentId, "Mobile" AS PhoneType, MobilePhone1 AS PhoneNumber FROM UNF
        WHERE MobilePhone1 IS NOT NULL AND MobilePhone1 != ''
	UNION SELECT Id AS StudentId, "Mobile" AS PhoneType, MobilePhone2 AS PhoneNumber FROM UNF
        WHERE MobilePhone2 IS NOT NULL AND MobilePhone2 != '';

DROP VIEW IF EXISTS PhoneList;

CREATE VIEW PhoneList AS SELECT StudentId, group_concat(PhoneNumber) AS PhoneNumber FROM Phone GROUP BY StudentId;

/* Normalisera School */

DROP TABLE IF EXISTS School;

CREATE TABLE School (
	SchoolId INT NOT NULL AUTO_INCREMENT,
	SchoolName VARCHAR(255) NOT NULL,
	City VARCHAR(255) NOT NULL,
	CONSTRAINT PRIMARY KEY (SchoolId)
)  ENGINE=INNODB;

INSERT INTO School(SchoolName, City) SELECT DISTINCT School, City From UNF;

DROP TABLE IF EXISTS StudentSchool;

CREATE TABLE StudentSchool AS SELECT Id AS StudentId, SchoolId FROM UNF JOIN School ON UNF.School = School.SchoolName;

/* Normalisera Hobby */

DROP TABLE IF EXISTS Hobby;
CREATE TABLE Hobby(
	HobbyId INT NOT NULL AUTO_INCREMENT,
	HobbyName VARCHAR(32),
	CONSTRAINT PRIMARY KEY (HobbyId)
) ENGINE=INNODB;

INSERT INTO Hobby(HobbyName)
	SELECT trim(SUBSTRING_INDEXT(Hobbies, ',', 1) AS HobbyName FROM UNF
	WHERE Hobbies IS NOT NULL AND Hobbies != ''






