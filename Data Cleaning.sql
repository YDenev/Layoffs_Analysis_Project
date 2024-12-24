-- Data Pre-Processing and Cleaning
-- Before I do anything with the data I created a copy of the table to work with, without changing the raw data.

-- Creating the copy and inserting the data
CREATE TABLE layoffs_cleaning
LIKE layoffs;

INSERT layoffs_cleaning
SELECT * 
FROM layoffs;

SELECT * 
FROM layoffs_cleaning;


-- 1. Remove Duplicates

-- First I am using a window function within a CTE to get a column with row numbers and find the duplicates
WITH duplicate_cte AS
(SELECT *, 
ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_cleaning)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1;

-- To be able to delete the duplicates I am creating another table that will store the data from the CTE
CREATE TABLE `layoffs_cleaning_stage2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Inserting the data
INSERT INTO layoffs_cleaning_stage2
SELECT *, 
ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, 
`date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_cleaning;

-- Selecting the duplicated records
SELECT * 
FROM layoffs_cleaning_stage2
WHERE row_num > 1;

-- Deleting the duplicated records

DELETE
FROM layoffs_cleaning_stage2
WHERE row_num > 1;

SELECT * 
FROM layoffs_cleaning_stage2;

-- 2. Standardize the Data

-- 2.1 Company column
-- Removing the white spaces before and after the string
UPDATE layoffs_cleaning_stage2
SET company = TRIM(company);

-- Make sure it worked
SELECT company, TRIM(company)
FROM layoffs_cleaning_stage2;

-- 2.2 Industry column
UPDATE layoffs_cleaning_stage2
SET industry = TRIM(industry);

SELECT DISTINCT industry
FROM layoffs_cleaning_stage2
ORDER BY 1;

-- From here I can see that I have 3 distinct industries related to Crypto that are suitable for standardizing

SELECT * 
FROM layoffs_cleaning_stage2
WHERE industry LIKE '%Crypto%';

-- Updating all related records to 'Crypto'
UPDATE layoffs_cleaning_stage2
SET industry = 'Crypto'
WHERE industry LIKE '%Crypto%';

-- 2.3 Location column

SELECT DISTINCT location
FROM layoffs_cleaning_stage2
ORDER BY 1;

-- The Location column looks fine so I move on

-- 2.4 Country column

SELECT DISTINCT country
FROM layoffs_cleaning_stage2
ORDER BY 1;
-- From this result I see that some records have trailing '.' 

-- Updating the records to trim the trailing '.'
UPDATE layoffs_cleaning_stage2
SET country = TRIM(TRAILING '.' FROM country);

-- 2.5 Date column
-- The data type of that column is text so I have to change it to Date

-- Using str_to_date to update the date
SELECT `date`, str_to_date(`date`, '%m/%d/%Y')
FROM layoffs_cleaning_stage2;

UPDATE layoffs_cleaning_stage2
SET `date` = str_to_date(`date`, '%m/%d/%Y');

SELECT `date` 
FROM layoffs_cleaning_stage2;

-- Modifying the date column

ALTER TABLE layoffs_cleaning_stage2
MODIFY COLUMN `date` DATE;

-- 3. Null or Blank Values

-- Checking industry column
SELECT * 
FROM layoffs_cleaning_stage2
WHERE industry IS NULL 
OR industry = '';

-- Checking the first blank value to find another record with the same company
SELECT * 
FROM layoffs_cleaning_stage2
WHERE company = 'Airbnb';

-- Using Self JOIN to find the companies with bot populated and not populated undustires
SELECT t1.industry, t2.industry
FROM layoffs_cleaning_stage2 t1
JOIN layoffs_cleaning_stage2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

-- Setting blank values to Null values
UPDATE layoffs_cleaning_stage2
SET industry = NULL
WHERE industry = '';

-- Updating the missing or null values
UPDATE layoffs_cleaning_stage2 t1
JOIN layoffs_cleaning_stage2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

-- Last I delete all records where bot tota_laid_off and the percentage are null as they will be irrelevenat in the analysis
DELETE
FROM layoffs_cleaning_stage2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- 4. Remove any irrelevant columns for the analysis

-- Droping row_num column as I don't need it anymore
ALTER TABLE layoffs_cleaning_stage2
DROP COLUMN row_num;

SELECT * 
FROM layoffs_cleaning_stage2;


















