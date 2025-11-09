------- Data cleaning-------------
-- STEP 1--
SET SQL_SAFE_UPDATES = 0;

UPDATE human_resources
SET birthdate = CASE
    WHEN birthdate LIKE "%/%" THEN DATE_FORMAT(STR_TO_DATE(birthdate, "%m/%d/%Y"), "%Y-%m-%d")
    WHEN birthdate LIKE "%-%" THEN DATE_FORMAT(STR_TO_DATE(birthdate, "%m-%d-%Y"), "%Y-%m-%d")
    ELSE NULL
END;

SET SQL_SAFE_UPDATES = 1;  -- (opcional, para volver a activarlo)

-- STEP 2--
UPDATE human_resources
SET hire_date = CASE
	WHEN hire_date like "%/%" THEN date_format(str_to_date(hire_date,"%m/%d/%Y"), "%Y-%m-%d")
    WHEN hire_date like "%-%" THEN date_format(str_to_date(hire_date,"%m-%d-%Y"), "%Y-%m-%d")
    ELSE null
END;
ALTER TABLE human_resources
MODIFY COLUMN hire_date DATE;

-- STEP 3--
UPDATE human_resources
SET term_date = CASE
	WHEN term_date != "" THEN date(str_to_date(term_date,"%Y-%m-%d %H:%i:%s UTC"))
    ELSE "0000-00-00"
END;
SET sql_mode ="ALLOW_INVALID_DATES";
ALTER TABLE human_resources
MODIFY COLUMN term_date DATE;

-- STEP 4--
ALTER TABLE human_resources
ADD COLUMN age INT;
UPDATE human_resources
SET age = timestampdiff(YEAR, birthdate, CURDATE());

SELECT count(age) FROM human_resources
WHERE age <= 18;

