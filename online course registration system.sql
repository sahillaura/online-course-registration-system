CREATE DATABASE SAM;
USE SAM;
CREATE TABLE Student (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Department VARCHAR(50) NOT NULL,
    Year INT NOT NULL
);
INSERT INTO Student VALUES 
(1, 'Alice', 'alice@example.com', 'CSE', 2),
(2, 'Bob', 'bob@example.com', 'ECE', 3),
(3, 'Charlie', 'charlie@example.com', 'CSE', 1),
(4, 'David', 'david@example.com', 'EEE', 4),
(5, 'Eva', 'eva@example.com', 'MECH', 2),
(6, 'Fay', 'fay@example.com', 'CSE', 3);

CREATE TABLE Instructor (
    InstructorID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Department VARCHAR(50) NOT NULL
);
INSERT INTO Instructor VALUES 
(101, 'Dr. Rao', 'rao@example.com', 'CSE'),
(102, 'Dr. Mehta', 'mehta@example.com', 'ECE'),
(103, 'Dr. Khan', 'khan@example.com', 'EEE'),
(104, 'Dr. Patel', 'patel@example.com', 'MECH'),
(105, 'Dr. Roy', 'roy@example.com', 'CSE'),
(106, 'Dr. Singh', 'singh@example.com', 'CIVIL');

CREATE TABLE Course (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100) NOT NULL,
    Credits INT NOT NULL,
    Department VARCHAR(50) NOT NULL
);
INSERT INTO Course VALUES 
(201, 'Data Structures', 4, 'CSE'),
(202, 'Digital Circuits', 3, 'ECE'),
(203, 'Thermodynamics', 4, 'MECH'),
(204, 'Control Systems', 3, 'EEE'),
(205, 'Database Systems', 4, 'CSE'),
(206, 'Fluid Mechanics', 3, 'CIVIL');

CREATE TABLE CourseOffering (
    OfferingID INT PRIMARY KEY,
    CourseID INT NOT NULL,
    InstructorID INT NOT NULL,
    Semester VARCHAR(20) NOT NULL,
    Slot VARCHAR(20) NOT NULL,
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID),
    FOREIGN KEY (InstructorID) REFERENCES Instructor(InstructorID)
);
INSERT INTO CourseOffering VALUES 
(301, 201, 101, 'Spring 2025', 'A1'),
(302, 202, 102, 'Spring 2025', 'B1'),
(303, 203, 104, 'Spring 2025', 'C1'),
(304, 204, 103, 'Spring 2025', 'D1'),
(305, 205, 105, 'Spring 2025', 'A2'),
(306, 206, 106, 'Spring 2025', 'B2');

CREATE TABLE Registration (
    RegistrationID INT PRIMARY KEY,
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    Semester VARCHAR(20) NOT NULL,
    Grade VARCHAR(2),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);
INSERT INTO Registration VALUES 
(401, 1, 201, 'Spring 2025', 'A'),
(402, 2, 202, 'Spring 2025', 'B'),
(403, 3, 205, 'Spring 2025', 'A+'),
(404, 4, 204, 'Spring 2025', 'C'),
(405, 5, 203, 'Spring 2025', 'B+'),
(406, 6, 205, 'Spring 2025', 'A');
SELECT * FROM Student;
SELECT S.Name 
FROM Student S
JOIN Registration R ON S.StudentID = R.StudentID
JOIN Course C ON R.CourseID = C.CourseID
WHERE C.CourseName = 'database systems';
UPDATE Registration
SET Grade = 'A+'
WHERE RegistrationID = 401;
DELETE FROM Registration WHERE RegistrationID = 401;
SELECT CourseID, AVG(CASE Grade 
    WHEN 'A' THEN 4 
    WHEN 'B' THEN 3 
    WHEN 'C' THEN 2 
    ELSE 0 END) AS GPA
FROM Registration
GROUP BY CourseID;
SELECT CourseName, Semester, Slot
FROM CourseOffering
JOIN Course ON CourseOffering.CourseID = Course.CourseID
WHERE Semester = 'Spring 2025';
SELECT S.Name AS StudentName, C.CourseName, R.Grade
FROM Registration R
JOIN Student S ON R.StudentID = S.StudentID
JOIN Course C ON R.CourseID = C.CourseID;
SELECT C.CourseName, COUNT(R.StudentID) AS Total_Registered
FROM Course C
JOIN Registration R ON C.CourseID = R.CourseID
GROUP BY C.CourseName;
SELECT CourseID, COUNT(*) AS Num_Students
FROM Registration
GROUP BY CourseID
HAVING COUNT(*) > 1;
SELECT Name FROM Student
WHERE StudentID IN (
    SELECT StudentID FROM Registration
    WHERE CourseID = (
        SELECT CourseID FROM Course WHERE CourseName = 'Database Systems'
    )
);