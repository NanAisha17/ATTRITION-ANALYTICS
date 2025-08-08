SELECT 
	* 
FROM 
	HR_Analytics;


--- DATA CLEANING ---

--REMOVE DUPLICATES

WITH DUPLICATE_CTE AS (
    SELECT *, 
           ROW_NUMBER() OVER (PARTITION BY EmpID, EmployeeNumber ORDER BY EmpID) AS Row_Num
    FROM HR_Analytics
)

DELETE FROM 
    DUPLICATE_CTE
WHERE 
    Row_Num > 1;


--DROP UNNECESSARY COLUMNS

ALTER TABLE
    HR_Analytics
DROP COLUMN
    EmployeeCount,
    Over18,
    StandardHours,
    YearsWithCurrManager;


--CORRECT INCONSISTENT ENTRIES

UPDATE 
    HR_Analytics
SET 
    BusinessTravel = 'Travel_Rarely'
WHERE 
    BusinessTravel IN ('TravelRarely');


--CHANGE DATA TYPE AND SET PRIMARY KEY

ALTER TABLE 
    HR_Analytics
ADD CONSTRAINT 
    Pk_HR_Analytics PRIMARY KEY (EmpID);

ALTER TABLE 
    HR_Analytics
DROP CONSTRAINT 
    Pk_HR_Analytics;

ALTER TABLE 
    HR_Analytics
ALTER COLUMN 
    EmpID INT NOT NULL;

ALTER TABLE 
    HR_Analytics
ADD CONSTRAINT 
    Pk_HR_Analytics PRIMARY KEY (EmpID);

ALTER TABLE 
    HR_Analytics
ALTER COLUMN 
    Attrition TINYINT NOT NULL;

ALTER TABLE 
    HR_Analytics
ALTER COLUMN 
    OverTime TINYINT NOT NULL;


--- BUSINESS QUESTIONS ---

-- HOW MANY EMPLOYEES HAVE LEFT THE COMPANY (ATTRITION = YES)?

SELECT
    COUNT (*) AS Num_Of_Employees_Who_Left
FROM
    HR_Analytics
WHERE
        Attrition = 1;

-- WHAT IS THE AVERAGE AGE OF EMPLOYEES WHO LEFT VS THOSE WHO STAYED?

SELECT
    Attrition,
    AVG(Age) AS Average_Age
FROM
    HR_Analytics
GROUP BY
    Attrition;

-- HOW MANY EMPLOYEES IN EACH AGE GROUP HAVE EXPERIENCED ATTRITION?

SELECT
    AgeGroup,
    COUNT(AgeGroup) AS Num_Of_Attrition
FROM
    HR_Analytics
WHERE
    Attrition = 1
GROUP BY
    AgeGroup;

-- WHICH DEPARTMENT HAS THE HIGHEST ATTRITION RATE?

SELECT
    Department,
    ROUND(
        SUM(Attrition) * 100.0 / COUNT(*), 2) 
            AS Attrition_Rate
FROM
    HR_Analytics
GROUP BY
    Department
ORDER BY
    Attrition_Rate DESC;

-- WHAT IS THE AVERAGE MONTHLY INCOME PER DEPARTMENT?

SELECT
    Department,
    AVG(MonthlyIncome) AS Avg_Monthly_Income
FROM
    HR_Analytics
GROUP BY
    Department
ORDER BY
    Avg_Monthly_Income DESC;

-- GENDER VS ATTRITION

SELECT 
    Gender,
    COUNT(*) AS Total_Employees,
    ROUND(
        SUM(Attrition) * 100.0 / COUNT(*), 2
    ) AS Attrition_Rate_Percent
FROM 
    HR_Analytics
GROUP BY 
    Gender;


-- LIST THE TOP 5 JOB ROLES WITH THE HIGHEST NUMBER OF EMPLOYEES

SELECT TOP 5
    JobRole,
    COUNT(JobRole) AS Num_Of_Employees
FROM
    HR_Analytics
GROUP BY
    JobRole
ORDER BY
    Num_Of_Employees DESC;

-- HOW MANY EMPLOYEES ARE AT JOB LEVEL 5 IN EACH DEPARTMENT?

SELECT
    Department,
    COUNT(JobLevel) AS Num_Of_Employees_Level_5
FROM
    HR_Analytics
WHERE
    JobLevel = 5
GROUP BY
    Department;

-- WHAT IS THE AVERAGE YEARS AT COMPANY FOR EMPLOYEES WHO TRAVEL FREQUENTLY?

SELECT
    AVG(YearsAtCompany) AS Avg_Years_At_Company
FROM
    HR_Analytics
WHERE
    BusinessTravel = 'Travel_Frequently';

-- FIND THE AVERAGE WORK/LIFE BALANCE SCORE ACROSS DEPARTMENTS

SELECT
    Department,
    AVG(WorkLifeBalance) AS Avg_Work_Life_Balance_Score
FROM
    HR_Analytics
GROUP BY
    Department;

-- WHICH JOB ROLE HAS THE HIGHEST AVERAGE OVER-TIME RATE?

SELECT
    JobRole,
    COUNT(OverTime) AS Over_Time_Rate
FROM
    HR_Analytics
GROUP BY
    JobRole
ORDER BY
    Over_Time_Rate DESC;

-- COMPARE THE AVERAGE MONTHLY INCOME BY EDUCATION FIELD

SELECT
    EducationField,
    AVG(MonthlyIncome) AS Avg_Monthly_Income
FROM
    HR_Analytics
GROUP BY
    EducationField;

-- WHAT IS THE DISTRIBUTION OF EDUCATION LEVELS ACROSS GENDER?

SELECT
    Education,
    Gender,
    COUNT(*) AS Num_Of_Employees
FROM
    HR_Analytics
GROUP BY
    Education,
    Gender
ORDER BY
    Education,
    Gender;

-- WHICH EDUCATION FIELD HAS THE HIGHEST ATTRITION RATE?

SELECT
    EducationField,
     ROUND(
        SUM(Attrition) * 100.0 / COUNT(*), 2) 
            AS Attrition_Rate 
FROM
    HR_Analytics
GROUP BY
    EducationField
ORDER BY
    Attrition_Rate DESC;

-- HOW MANY EMPLOYEES RECEIVED A PERCENT-SALARY HIKE GRFEATER THAN 15% AND HAVE NOT BEEN PROMOTED IN THE LAST 3 YEARS?

SELECT
    COUNT(*) AS Num_Of_Employees
FROM
    HR_Analytics
WHERE
    PercentSalaryHike > 15
    AND YearsSinceLastPromotion >= 3;

-- EMPLOYEES WITH HIGH PERFORMANCE RATING (4 OR 5), BUT LOW JOB SATISFACTION (1 OR 2)

SELECT
    EmpID,
    Age,
    Gender,
    Department,
    PerformanceRating,
    JobSatisfaction,
    Attrition
FROM
    HR_Analytics
WHERE
    PerformanceRating > 3
    AND JobSatisfaction < 3;

-- AVERAGE LENGTH OF STAY BEFORE LEAVING

SELECT 
    AVG(YearsAtCompany) AS Avg_Length_Of_Stay_Before_Leaving
FROM 
    HR_Analytics
WHERE 
    Attrition = 1;