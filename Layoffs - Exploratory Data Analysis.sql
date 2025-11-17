-- EXPLORATORY DATA ANALYSIS

SELECT *
FROM layoffs_staging;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging;

SELECT *
FROM layoffs_staging
ORDER BY total_laid_off DESC;

SELECT company, SUM(total_laid_off) AS sum_laid_off
FROM layoffs_staging
GROUP BY company
ORDER BY sum_laid_off DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging;

SELECT industry, SUM(total_laid_off) AS sum_laid_off
FROM layoffs_staging
GROUP BY industry
ORDER BY sum_laid_off DESC;

SELECT country, SUM(total_laid_off) AS sum_laid_off
FROM layoffs_staging
GROUP BY country
ORDER BY sum_laid_off DESC;

SELECT YEAR(`date`), SUM(total_laid_off) AS sum_laid_off
FROM layoffs_staging
GROUP BY YEAR(`date`)
ORDER BY 2 DESC;

SELECT stage, SUM(total_laid_off) AS sum_laid_off
FROM layoffs_staging
GROUP BY stage
ORDER BY 2 DESC;

-- Rolling Total of Layoffs based on Month 

SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) 
FROM layoffs_staging
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off, SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;


SELECT company, SUM(total_laid_off) AS sum_laid_off
FROM layoffs_staging
GROUP BY company
ORDER BY sum_laid_off DESC;

SELECT company, YEAR(`date`), SUM(total_laid_off) AS sum_laid_off
FROM layoffs_staging
GROUP BY company, YEAR(`date`)
ORDER BY sum_laid_off DESC;

WITH Company_Year (Company, Years, Total_Laid_Off) AS 
(
SELECT company, YEAR(`date`), SUM(total_laid_off) AS sum_laid_off
FROM layoffs_staging
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(
SELECT *, DENSE_RANK() OVER (PARTITION BY Years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE Years IS NOT NULL
)
SELECT * 
FROM Company_Year_Rank
WHERE Ranking <= 5
ORDER BY Years ASC;
