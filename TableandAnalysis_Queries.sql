CREATE TABLE "titles" (
    "title_id" VARCHAR(5)   NOT NULL,
    "title" VARCHAR(30)   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     ),
    CONSTRAINT "uc_titles_title" UNIQUE (
        "title"
    )
);

CREATE TABLE "departments" (
    "dept_no" VARCHAR(4)   NOT NULL,
    "dept_name" VARCHAR(30)   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     ),
    CONSTRAINT "uc_departments_dept_name" UNIQUE (
        "dept_name"
    )
);


CREATE TABLE "employees" (
    "emp_no" INT  NOT NULL, -- Cannot use SERIAL as there is a break between 299999 and 400000
    "emp_title_id" VARCHAR(5)   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" VARCHAR(30)   NOT NULL,
    "last_name" VARCHAR(30)   NOT NULL,
    "sex" VARCHAR(1)   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" INT   NOT NULL,
    "salary" money   NOT NULL,
    CONSTRAINT "pk_salaries" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" INT   NOT NULL,
    "dept_no" VARCHAR(4)   NOT NULL,
    CONSTRAINT "pk_dept_emp" PRIMARY KEY (
        "emp_no","dept_no"
     )
);


-- Adding Constraints to the tables 
ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("title_id");

ALTER TABLE "employees" ADD CONSTRAINT "CHK_sex_validation" CHECK ("sex" IN ("F", "M"))
;

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");


--Begin Analysis Queries--

SELECT
		e.emp_no
		,e.last_name
		,e.first_name
		,e.sex
		,(SELECT s.salary FROM salaries AS s 
		  WHERE e.emp_no = s.emp_no) AS salary
					
FROM employees AS e
;


SELECT
		e.last_name
		,e.first_name
		,e.hire_date
		
FROM employees AS e

WHERE DATE_PART('year', e.hire_date) = 1986
;


SELECT
		d.dept_no
		,d.dept_name
		,e.emp_title_id
		,e.last_name
		,e.first_name

FROM 	dept_emp as de
		LEFT JOIN employees as e
					ON e.emp_no = de.emp_no
		LEFT JOIN departments as d
					ON d.dept_no = de.dept_no

WHERE e.emp_title_id LIKE 'm%'
;


CREATE VIEW all_dept_emp AS -- Create view for the joined table

			(SELECT e.emp_no
			 		,e.emp_title_id
			 		,e.birth_date
			 		,e.last_name
			 		,e.first_name
			 		,e.sex
			 		,e.hire_date
			 		,d.dept_name
			 		,d.dept_no

			FROM 	dept_emp as de
					LEFT JOIN employees as e
								ON e.emp_no = de.emp_no
					LEFT JOIN departments as d
								ON d.dept_no = de.dept_no)
;


SELECT
		emp_no
		,last_name
		,first_name
		,dept_name

FROM 	all_dept_emp
;


SELECT
		e.first_name
		,e.last_name
		,e.sex

FROM	employees AS e

WHERE	e.first_name = 'Hercules'
		AND e.last_name LIKE 'B%'
;


CREATE VIEW Q6_7 AS  -- Create another view as similar information is required in the 2 questions

			(SELECT
					emp_no
					,last_name
					,first_name
					,dept_name

			FROM	all_dept_emp)
;


SELECT * FROM Q6_7

WHERE	dept_name = 'Sales'
;


SELECT * FROM Q6_7

WHERE	dept_name IN ('Sales', 'Development')
;


SELECT
		e.last_name
		,COUNT(e.last_name) AS frequency
		
FROM	employees AS e

GROUP BY	e.last_name

ORDER BY	frequency DESC
;