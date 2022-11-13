-- Creating tables for PH-EmployeeDB
--create departments table
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);
--create employee table
CREATE TABLE employees (
	 emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
	);
	
	--department head table
	CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

--department employees
CREATE TABLE dept_employees2 (
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);


-- salaries table
CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

-- titles table
CREATE TABLE titles (
  emp_no INT NOT NULL,
  title VARCHAR(60) NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no, title, from_date)
);

--Queries
Select e.emp_no, e.first_name, e.last_name, t.title, t.from_date, t.to_date
INTO retirement_titles
FROM employees AS e, titles AS t
WHERE (e.emp_no = t.emp_no)
AND (e.birth_date BETWEEN ('1951-01-01') AND ('1955-12-31'))
order by e.emp_no; 

--employee retirement using distinct on from retirement titles
SELECT DISTINCT ON (rt.emp_no) rt.emp_no,
rt.first_name,
rt.last_name,
rt.title
INTO unique_titles
FROM retirement_titles AS rt
ORDER BY rt.emp_no, rt.to_date DESC;

--
SELECT COUNT(ut.title), ut.title
INTO Retiring_titles
FROM unique_titles AS ut
GROUP BY ut.title
ORDER BY COUNT(ut.title) DESC
;

--montorship elegibility
SELECT DISTINCT ON (e.emp_no) e.emp_no,
e.first_name,
e.last_name,
e.birth_date,
de.from_date,
de.to_date,
ti.title
INTO membership_elegibility
FROM employees AS e
	INNER JOIN dept_employees2 AS de 
	ON (e.emp_no = de.emp_no)
	INNER JOIN titles AS ti
	ON (e.emp_no = ti.emp_no)
	WHERE (de.to_date = '9999-01-01')
	AND e.birth_date BETWEEN '1965-01-01' AND '1965-12-31'
	ORDER BY e.emp_no;
	