# PortfolioProjects

## View Data
Select *<br />
FROM `covidproject-345319.CovidVaccines.CovidDeaths`<br />
ORDER BY 3,4<br />

## Select Relevant Data 
SELECT location, date, total_cases, new_cases, total_deaths, population <br />
FROM `covidproject-345319.CovidVaccines.CovidDeaths` <br />
ORDER BY 1,2


## Looking at the total cases vs total deaths
## Shows falality rate of covid contraction
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as fatality_rate<br />
FROM `covidproject-345319.CovidVaccines.CovidDeaths`<br />
~~WHERE location = "United States"~~ <br />
ORDER BY 1,2<br />


## Total Cases Vs Population
## Shows what percentage of populaton contracted covid
SELECT location, date, total_cases, population, (total_cases/population)*100 as contraction_percentage<br />
FROM `covidproject-345319.CovidVaccines.CovidDeaths`<br />
~~WHERE location = 'United States'~~<br />
ORDER BY 1,2<br />


## Countries with highest infection rate compared to Population
SELECT location, MAX(total_cases) as highest_infection_count, population, MAX((total_cases/population))*100 as infection_rate <br />
FROM `covidproject-345319.CovidVaccines.CovidDeaths`<br />
GROUP BY location, population<br />
ORDER BY infection_rate DESC<br />
 
 
## Countries with highest death count per population
SELECT location, MAX(total_deaths) as total_death_count<br />
FROM `covidproject-345319.CovidVaccines.CovidDeaths`<br />
WHERE continent is not null <br />
GROUP BY location<br />
ORDER BY total_death_count desc<br />


## Showing the continents with the highest death count
SELECT continent, MAX(total_deaths) as total_death_count<br />
FROM `covidproject-345319.CovidVaccines.CovidDeaths`<br />
WHERE continent is not null <br />
GROUP BY continent<br />
ORDER BY total_death_count desc<br />


## GLOBAL VIEW
SELECT SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as fatality_rate<br />
FROM `covidproject-345319.CovidVaccines.CovidDeaths`<br />
WHERE continent is not null <br />
~~GROUP BY date~~<br />
ORDER BY 1,2<br />


## Looking at Total vs Vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as rolling_people_vaccinated<br />
FROM `covidproject-345319.CovidVaccines.CovidDeaths` dea<br />
JOIN `covidproject-345319.CovidVaccines.CovidVaccines` vac<br />
    ON dea.location = vac.location<br />
    and dea.date = vac.date<br />
WHERE dea.continent is not null <br />
ORDER BY 2,3<br />


## CTE
WITH popvsvac AS<br />
(<br />
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations <br />
, SUM(Cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as rolling_people_vaccinated<br />
FROM `covidproject-345319.CovidVaccines.CovidDeaths` dea<br />
JOIN `covidproject-345319.CovidVaccines.CovidVaccines` vac<br />
    ON dea.location = vac.location<br />
    and dea.date = vac.date<br />
WHERE dea.continent is not null <br />
)<br />
SELECT *, (rolling_people_vaccinated/Population) * 100<br />
FROM popvsvac<br />

# Visualizing the Data

## Global Numbers

### SQL Query

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage<br />
FROM `covidproject-345319.CovidVaccines.CovidDeaths`<br />
WHERE continent is not null <br />
ORDER by 1,2<br />

### Visualization

<img align="center" alt="linkedin.com" style="max-width:100%;margin-bottom:25px;" width="960px" src="Global Numbers Vis.PNG" />  <br />


## Total Deaths Per Continent

### SQL Query

SELECT location, SUM(cast(new_deaths as int)) as TotalDeathCount<br />
FROM `covidproject-345319.CovidVaccines.CovidDeaths` <br />
WHERE continent is null <br />
and location not in ('World', 'European Union', 'International') <br />
GROUP BY location <br />
ORDER BY TotalDeathCount desc <br />
<br />
### Visualization

 <img align="center" alt="linkedin.com" style="max-width:100%; margin-bottom:25px" width="860px" src="Total Deaths Per Continent Vis.PNG" />  <br />



## Percentage of Population Infected Per Country

### SQL Query

SELECT Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected <br />
FROM `covidproject-345319.CovidVaccines.CovidDeaths`<br />
GROUP by Location, Population<br />
ORDER by PercentPopulationInfected desc  <br />

<br />
  
### Visualization

<img align="center" alt="linkedin.com" style="max-width:100%; margin-bottom:25px" width="1080px" src="Percentage of Popuation Infected Per Country.PNG" /> <br />


    
  
## Percentage of Population Infected
  
### SQL Query

SELECT Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected<br />
FROM `covidproject-345319.CovidVaccines.CovidDeaths`<br />
GROUP by Location, Population, date<br />
ORDER by PercentPopulationInfected desc<br />
 
<br />

### Visualization
  
<img align="center" alt="linkedin.com" style="max-width:100%; margin-bottom:25px" width="1080px" src="Percentage of Population Infected.PNG" />  <br />



## Creating the Final Dashboard


<img align="center" alt="linkedin.com" width="1240px" src="Dashboard.PNG" /> <br />


