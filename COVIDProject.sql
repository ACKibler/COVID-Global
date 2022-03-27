Select *
FROM `covidproject-345319.CovidVaccines.CovidDeaths`
WHERE continent is not null 
ORDER BY 3,4

SELECT *
FROM `covidproject-345319.CovidVaccines.CovidVaccines`
ORDER BY 3,4 "

--Select Data that we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM `covidproject-345319.CovidVaccines.CovidDeaths`
ORDER BY 1,2

-- Looking at the total cases vs total deaths
-- Shows falality rate of covid contraction
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as fatality_rate
FROM `covidproject-345319.CovidVaccines.CovidDeaths`
--WHERE location = "United States"
ORDER BY 1,2

-- Total Cases Vs Population
-- Shows waht percentage of populaton contracted covid

SELECT location, date, total_cases, population, (total_cases/population)*100 as contraction_percentage
FROM `covidproject-345319.CovidVaccines.CovidDeaths`
--WHERE location = 'United States'
ORDER BY 1,2

-- Countries with highest infection rate compared to Population

SELECT location, MAX(total_cases) as highest_infection_count, population, MAX((total_cases/population))*100 as infection_rate 
FROM `covidproject-345319.CovidVaccines.CovidDeaths`
GROUP BY location, population
ORDER BY infection_rate DESC
 
-- Countries with highest death count per population

SELECT location, MAX(total_deaths) as total_death_count
FROM `covidproject-345319.CovidVaccines.CovidDeaths`
WHERE continent is not null 
GROUP BY location
ORDER BY total_death_count desc


-- Showing the continents with the highest death count

SELECT continent, MAX(total_deaths) as total_death_count
FROM `covidproject-345319.CovidVaccines.CovidDeaths`
WHERE continent is not null 
GROUP BY continent
ORDER BY total_death_count desc

-- GLOBAL VIEW

SELECT SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as fatality_rate
FROM `covidproject-345319.CovidVaccines.CovidDeaths`
WHERE continent is not null 
--GROUP BY date
ORDER BY 1,2

--Looking at Total vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(Cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as rolling_people_vaccinated,
FROM `covidproject-345319.CovidVaccines.CovidDeaths` dea
JOIN `covidproject-345319.CovidVaccines.CovidVaccines` vac
    ON dea.location = vac.location
    and dea.date = vac.date
WHERE dea.continent is not null 
ORDER BY 2,3

-- USE CTE

WITH popvsvac AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(Cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as rolling_people_vaccinated,
FROM `covidproject-345319.CovidVaccines.CovidDeaths` dea
JOIN `covidproject-345319.CovidVaccines.CovidVaccines` vac
    ON dea.location = vac.location
    and dea.date = vac.date
WHERE dea.continent is not null 
)
SELECT *, (rolling_people_vaccinated/Population) * 100
FROM popvsvac


--TEMP TABLE 

CREATE TEMP TABLE PercentPopulationVaccinated
(
    continent STRING,
    location STRING,
    date STRING,
    population FLOAT,
    new_vaccinations FLOAT,
    rolling_people_vaccinated FLOAT,

)
AS

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(Cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as rolling_people_vaccinated,
FROM `covidproject-345319.CovidVaccines.CovidDeaths` dea
JOIN `covidproject-345319.CovidVaccines.CovidVaccines` vac
    ON dea.location = vac.location
    and dea.date = vac.date
WHERE dea.continent is not null 

SELECT *, (rolling_people_vaccinated/Population) * 100
FROM PercentPopulationVaccinated


-- Creating View to store data for later visualizations

SELECT *
FROM `covidproject-345319.CovidVaccines.PopVsVac`