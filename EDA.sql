-- Exploratory Data Analysis

SELECT *
FROM layoffs_cleaning_stage2;

-- Checking the MAX number of people laid off and percentage
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_cleaning_stage2;

-- Checking the companies that laid off 100% of their employees
SELECT company, industry
FROM layoffs_cleaning_stage2
WHERE percentage_laid_off = 1;

-- Finding the top 10 companies by amount of people laid off
SELECT company, SUM(total_laid_off) AS people_laid_off
FROM layoffs_cleaning_stage2
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;

-- Finding the top 10 industries by amount of people laid off
SELECT industry, SUM(total_laid_off) AS people_laid_off
FROM layoffs_cleaning_stage2
GROUP BY industry
ORDER BY 2 DESC
LIMIT 10;

-- Finding the top 10 countries by amount of people laid off
SELECT country, SUM(total_laid_off) AS people_laid_off
FROM layoffs_cleaning_stage2
GROUP BY country
ORDER BY 2 DESC
LIMIT 10;

-- Checking the date range of the dataset
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_cleaning_stage2;

-- Checking how many people were laid off by year
SELECT YEAR(`date`), SUM(total_laid_off) AS people_laid_off
FROM layoffs_cleaning_stage2
GROUP BY YEAR(`date`)
ORDER BY 2 DESC;

-- Creating rolling total of people laid of by month, using CTE and window statement

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS laid_off_total
FROM layoffs_cleaning_stage2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1
)
SELECT `MONTH`,laid_off_total, 
SUM(laid_off_total) OVER (ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

-- Above I looked at Companies with the most Layoffs. Now I am looking at that per year.

WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_cleaning_stage2
  GROUP BY company, YEAR(date)
)
, Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 5
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;











