-- Create departments table
DROP TABLE IF EXISTS DEPARTMENTS CASCADE;

CREATE TABLE DEPARTMENTS (
	DEPT_NO VARCHAR(50) NOT NULL,
	DEPT_NAME VARCHAR(50) NOT NULL,
	PRIMARY KEY (DEPT_NO)
);

-- Confirming import
SELECT
	*
FROM
	DEPARTMENTS;

-- Create titles table
DROP TABLE IF EXISTS TITLES CASCADE;

CREATE TABLE TITLES (
	TITLE_ID VARCHAR(50) NOT NULL,
	TITLE VARCHAR(50) NOT NULL,
	PRIMARY KEY (TITLE_ID)
);

-- Confirming import
SELECT
	*
FROM
	TITLES;

-- Create salaries table
DROP TABLE IF EXISTS SALARIES CASCADE;

CREATE TABLE SALARIES (
	EMP_NO INT NOT NULL,
	SALARY MONEY,
	PRIMARY KEY (EMP_NO)
);

-- Confirming import
SELECT
	*
FROM
	SALARIES;

--Create employees table
DROP TABLE IF EXISTS EMPLOYEES CASCADE;

CREATE TABLE EMPLOYEES (
	EMP_NO INT NOT NULL,
	EMP_TITLE_ID VARCHAR(50) NOT NULL,
	BIRTH_DATE DATE,
	FIRST_NAME VARCHAR(50) NOT NULL,
	LAST_NAME VARCHAR(50) NOT NULL,
	SEX VARCHAR(10) NOT NULL,
	HIRE_DATE DATE,
	PRIMARY KEY (EMP_NO),
	FOREIGN KEY (EMP_TITLE_ID) REFERENCES TITLES (TITLE_ID)
);

-- Confirming import
SELECT
	*
FROM
	EMPLOYEES;

-- Create dept_emp table
DROP TABLE IF EXISTS DEPT_EMP CASCADE;

CREATE TABLE DEPT_EMP (
	ID SERIAL,
	EMP_NO INT NOT NULL,
	DEPT_NO VARCHAR(50) NOT NULL,
	-- PRIMARY KEY (ID),
	UNIQUE (id),
	FOREIGN KEY (EMP_NO) REFERENCES EMPLOYEES (EMP_NO),
	FOREIGN KEY (DEPT_NO) REFERENCES DEPARTMENTS (DEPT_NO)
);

-- Confirming import
SELECT
	*
FROM
	DEPT_EMP;

-- Create dept_manager table
DROP TABLE IF EXISTS DEPT_MANAGER CASCADE;

CREATE TABLE DEPT_MANAGER (
	DEPT_NO VARCHAR(50) NOT NULL,
	EMP_NO INT NOT NULL,
	PRIMARY KEY (EMP_NO),
	FOREIGN KEY (DEPT_NO) REFERENCES DEPARTMENTS (DEPT_NO),
	FOREIGN KEY (EMP_NO) REFERENCES EMPLOYEES (EMP_NO)
);

-- Confirming import
SELECT
	*
FROM
	DEPT_MANAGER;

-- List the employee number, last name, first name, sex, and salary of each employee.
SELECT
	E.EMP_NO,
	E.LAST_NAME,
	E.FIRST_NAME,
	E.SEX,
	S.SALARY
FROM
	EMPLOYEES E
	JOIN SALARIES S ON E.EMP_NO = S.EMP_NO;

-- List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT
	E.FIRST_NAME,
	E.LAST_NAME,
	E.HIRE_DATE
FROM
	EMPLOYEES E
WHERE
	EXTRACT(
		YEAR
		FROM
			E.HIRE_DATE
	) = 1986;

-- List the manager of each department along with their department number, department name, employee number, last name, and first name.
SELECT
	D.DEPT_NO,
	D.DEPT_NAME,
	E.EMP_NO,
	E.LAST_NAME,
	E.FIRST_NAME
FROM
	DEPARTMENTS D
	JOIN DEPT_MANAGER DM ON D.DEPT_NO = DM.DEPT_NO
	JOIN EMPLOYEES E ON DM.EMP_NO = E.EMP_NO;

-- List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
SELECT
	D.DEPT_NO,
	DE.EMP_NO,
	E.LAST_NAME,
	E.FIRST_NAME,
	D.DEPT_NAME
FROM
	DEPARTMENTS D
	JOIN DEPT_EMP DE ON D.DEPT_NO = DE.DEPT_NO
	JOIN EMPLOYEES E ON DE.EMP_NO = E.EMP_NO;

-- List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
SELECT
	E.FIRST_NAME,
	E.LAST_NAME,
	E.SEX
FROM
	EMPLOYEES E
WHERE
	E.FIRST_NAME = 'Hercules'
	AND E.LAST_NAME LIKE 'B%';

-- List each employee in the Sales department, including their employee number, last name, and first name.
SELECT
	D.DEPT_NAME,
	DE.EMP_NO,
	E.LAST_NAME,
	E.FIRST_NAME
FROM
	DEPARTMENTS D
	JOIN DEPT_EMP DE ON D.DEPT_NO = DE.DEPT_NO
	JOIN EMPLOYEES E ON DE.EMP_NO = E.EMP_NO
WHERE
	D.DEPT_NAME = 'Sales';

-- List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT
	D.DEPT_NAME,
	DE.EMP_NO,
	E.LAST_NAME,
	E.FIRST_NAME
FROM
	DEPARTMENTS D
	JOIN DEPT_EMP DE ON D.DEPT_NO = DE.DEPT_NO
	JOIN EMPLOYEES E ON DE.EMP_NO = E.EMP_NO
WHERE
	D.DEPT_NAME = 'Sales'
	OR D.DEPT_NAME = 'Development';

-- List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
SELECT
	LAST_NAME,
	COUNT(*) AS FREQUENCY
FROM
	EMPLOYEES
GROUP BY
	LAST_NAME
ORDER BY
	FREQUENCY DESC;