CREATE DATABASE UNIV

USE UNIV

CREATE TABLE Groups
(
	Id INT PRIMARY KEY IDENTITY,
	No NVARCHAR(6),
	IsDeleted BIT DEFAULT 0
)

CREATE TABLE Students
(
	Id INT PRIMARY KEY IDENTITY,
	Fullname NVARCHAR(50),
	GroupId INT FOREIGN KEY REFERENCES Groups(Id)
)

CREATE TABLE DeletedStudents
(
	Id INT PRIMARY KEY,
	Fullname NVARCHAR(50),
	GroupId INT FOREIGN KEY REFERENCES Groups(Id),
	DeletedAt DATETIME2
)

INSERT INTO Groups (No) VALUES ('PB302')
INSERT INTO Groups (No) VALUES ('PF3202')
INSERT INTO Groups (No) VALUES ('DX193')
INSERT INTO Groups (No) VALUES ('CC108')

INSERT INTO Students (Fullname, GroupId) VALUES ('John Doe', 1)
INSERT INTO Students (Fullname, GroupId) VALUES ('Jane Smith', 2)
INSERT INTO Students (Fullname, GroupId) VALUES ('Mike Johnson', 1)
INSERT INTO Students (Fullname, GroupId) VALUES ('Sara Williams', 3)
INSERT INTO Students (Fullname, GroupId) VALUES ('Alex Brown', 2)
INSERT INTO Students (Fullname, GroupId) VALUES ('Emily Davis', 4)
INSERT INTO Students (Fullname, GroupId) VALUES ('Daniel Lee', 3)
INSERT INTO Students (Fullname, GroupId) VALUES ('Sophie Miller', 4)



--Student datası silindikdə DeletedStudents table-na əlavə olsun avtomatik (trigger yazın)

CREATE TRIGGER TR_DeleteStudent ON dbo.Students
FOR DELETE
AS
INSERT INTO DeletedStudents (Id, Fullname, GroupId, DeletedAt)
SELECT D.Id, D.Fullname, D.GroupId, GETDATE() FROM deleted AS D 
JOIN Groups AS G ON G.Id = D.GroupId

-- Testing
SELECT * FROM Students

DELETE FROM Students WHERE Id = 2

SELECT * FROM DeletedStudents

--Group datalarının IsDeleted column-u olsun və defauk false olsun. Bir group datası silinmək 
--istədikdə onun db-dan silinməsinin yerinə o datanın IsDeleted dəyəri dəyişib true olsun 
--(trigger yazın instead of ilə)

CREATE TRIGGER TR_DeleteGroup ON dbo.Groups
INSTEAD OF DELETE
AS
UPDATE G SET IsDeleted = 1 FROM deleted AS D
INNER JOIN Groups AS G ON G.Id = D.Id

-- Testing
DELETE FROM GROUPS WHERE Id = 3

SELECT * FROM Groups
