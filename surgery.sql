DROP DATABASE IF EXISTS surgery;
CREATE DATABASE surgery;
USE surgery;

DROP TABLE IF EXISTS Surgery_Day22;
CREATE TABLE Surgery_Day22(
	ID INT,
	FName VARCHAR(15),
	LName VARCHAR(15),
	HouseNo INT,
	Birthday DATE,
	Street VARCHAR(30),
	City VARCHAR(15),
	Budget INT,
	SurgeryID INT
);

INSERT INTO Surgery_Day22 (ID, FName, LName, HouseNo, Birthday, Street, City, Budget, SurgeryID) VALUES (1,'Ben','Miflin',12, '1982-05-06', 'Greek Street','Tamworth',10000,231);
INSERT INTO Surgery_Day22 (ID, FName, LName, Street, City, Budget, SurgeryID) VALUES (2,'Hans','Krebbs','Rothamsted Manor','Lichfield',24200,231);
INSERT INTO Surgery_Day22 (ID, FName, LName, HouseNo, Street, City, Budget, SurgeryID) VALUES (3,'Mary','Jones',12,'Rotten Row','Tamworth',1100,243);
INSERT INTO Surgery_Day22 (ID, FName, LName, Street, City, Budget, SurgeryID) VALUES (4,'Jane','Hughes','Rothamsted Manor','Lichfield',12100,231);
INSERT INTO Surgery_Day22 (ID, FName, LName, HouseNo, Street, City, Budget, SurgeryID) VALUES (5,'Bill','Pirie',23,'Final Way','Lichfield',16500,243);

SELECT * FROM Surgery_Day22;

-- place your answers below here

 Display the Names of those patients who do not live in lichfield.
 SELECT 
    surgery_day22.FName, surgery_day22.Lname
FROM
    surgery_day22
WHERE
    City <> 'Lichfield';
	
Display the total number of surgeries.
Select count(surgery_day22.FName)
from surgery_day22;

Return the total budget for Lichfield.
SELECT 
    SUM(surgery_day22.Budget)
FROM
    surgery_day22
WHERE
    City = 'Lichfield';

Display the average budget allocation for patients attending surgery 231.
SELECT 
    AVG(surgery_day22.Budget) as Surgery231AverageBudget
FROM
    surgery_day22
WHERE
    SurgeryID = '231';
	
Produce a query to show by how much the budget of patients with an above average
budget differs from the average.
SELECT 
    surgery_day22.FName,
    surgery_day22.LName,
    surgery_day22.Budget - (SELECT 
            AVG(surgery_day22.Budget)
        FROM
            surgery_day22) as DifferenceFromAverage
FROM
    surgery_day22
WHERE
    surgery_day22.Budget > (SELECT 
            AVG(surgery_day22.Budget)
        FROM
            surgery_day22);

Select the total cost of the budget for surgeries 231 and 243 only.
SELECT 
    SUM(surgery_day22.Budget)
FROM
    surgery_day22
WHERE
    surgery_day22.SurgeryID = '243'
        AND '231';
		
Return the names of any patients with a budget greater than the average for surgery
243
SELECT 
    surgery_day22.Fname,
    surgery_day22.LName,
    surgery_day22.Budget
FROM
    surgery_day22
WHERE
    surgery_day22.Budget > (SELECT 
            AVG(surgery_day22.Budget)
        FROM
            surgery_day22
        WHERE
            surgery_day22.SurgeryID = '243');
			
Return the names of any patients with a budget allocation greater than any of the
patients attending surgery 231.
SELECT 
    surgery_day22.FName,
    surgery_day22.LName,
    surgery_day22.Budget
FROM
    surgery_day22
WHERE
    surgery_day22.Budget > (SELECT 
            MAX(surgery_day22.Budget)
        FROM
            surgery_day22
        WHERE
            surgery_day22.SurgeryID = '231');

Return the patients with an above average budget allocation. Patients should be in
alphabetical order.
SELECT 
    surgery_day22.FName,
    surgery_day22.LName,
    surgery_day22.Budget
FROM
    surgery_day22
WHERE
    surgery_day22.Budget > (SELECT 
            avg(surgery_day22.Budget)
        FROM
            surgery_day22)
	order by surgery_day22.FName asc;
	
• Return the names of patients without a House No in alphabetical order
Select surgery_day22.FName, surgery_day22.LName
from surgery_day22
where HouseNo is null
order by surgery_day22.FName asc;

3 Advanved Tasks
a
Just add "Birthday Date" into the column declaration
ID INT,
	FName VARCHAR(15),
	LName VARCHAR(15),
	HouseNo INT,
	Birthday DATE,
	Street VARCHAR(30),
	City VARCHAR(15),
	Budget INT,
	SurgeryID INT
 and when creating a new patient add a birthday e.g)
 
INSERT INTO Surgery_Day22 (ID, FName, LName, HouseNo, Birthday, Street, City, Budget, SurgeryID) VALUES (1,'Ben','Miflin',12, '1982-05-06', 'Greek Street','Tamworth',10000,231);
Nothing much needs to be changed here, its just addding another column to the current table, you could always create
a patient table and link them via patientID, and display the patients full details on that table and just have first name, lastname and ID in this TABLE

b 
SELECT 
	AVG(surgery_day22.Budget)
        FROM
            
    surgery_day22
WHERE 
surgery_day22.Birthday > 1/1/1980;

c I have a vague Idea of how to make extra tables and connect them but I need a refresh in a lab session.