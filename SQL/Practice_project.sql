-- Data Cleaning

select *
from layoffs;

-- Copying data
drop table if exists layoffs_staging;
create table layoffs_staging like layoffs;
insert layoffs_staging 
select * from layoffs;
select count(*) from layoffs_staging;

-- Checking duplications 
with duplicate_cte as
(
select *, row_number() 
over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging 
)
select *
from duplicate_cte
where row_num > 1
order by percentage_laid_off desc;

truncate table layoffs_staging;
insert into layoffs_staging
select distinct * from layoffs;

-- Standardizing data
update layoffs_staging
set company = trim(company);

select distinct industry
from layoffs_staging
order by industry;
select * 
from layoffs_staging
where industry like "%Crypto%";
update layoffs_staging
set industry = "Crypto" where industry like "%Crypto%";

select distinct country
from layoffs_staging
order by 1;
update layoffs_staging
set country = trim(trailing '.' from country);

update layoffs_staging
set `date` = str_to_date(`date`, '%m/%d/%Y');
select distinct `date` from layoffs_staging order by 1;
alter table layoffs_staging
modify column `date` date;

-- Handling null or blank values
select t1.company, t1.location, t1.industry, t2.industry
from layoffs_staging as t1
join layoffs_staging as t2
	on t1.company = t2.company
where (t1.industry is null or t1.industry = "") and (t2.industry is not null and t2.industry != "");

update layoffs_staging as t1
join layoffs_staging as t2
	on t1.company = t2.company
set t1.industry = t2.industry
where (t1.industry is null or t1.industry = "") and (t2.industry is not null and t2.industry != "");

-- Deleting noninformativ rows
delete
from layoffs_staging
where total_laid_off is null and percentage_laid_off is null;

select * 
from layoffs_staging
order by company;

-- EDA
select max(percentage_laid_off)
from layoffs_staging;

select * 
from layoffs_staging
where percentage_laid_off = 1
order by funds_raised_millions desc, total_laid_off desc;

select company, sum(total_laid_off) as sum_laif_off
from layoffs_staging
group by company
order by sum_laif_off desc;

select industry, sum(total_laid_off) as sum_laif_off
from layoffs_staging
group by industry
order by sum_laif_off desc;

select year(`date`), sum(total_laid_off) as sum_laif_off
from layoffs_staging
group by year(`date`)
order by 1 desc;