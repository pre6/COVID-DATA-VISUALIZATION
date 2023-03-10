-- Percent of deaths out of the total number of people infected in Canada
-- Likelihood of dying if you contract covid 

SELECT Location,
date,
total_cases,
new_cases,
total_deaths,
(total_deaths*1.0/total_cases)*100 as PercentDeathsofInfected
FROM Deaths
WHERE location = 'Canada'
ORDER by 1,2

-- Percent of the population infected

SELECT Location,
Population,
MAX(total_cases) as Highest_infected, 
MAX(total_cases*1.0/Population)*100 as Percentpopulationinfected
FROM Deaths
WHERE continent != ''
GROUP BY Location
ORDER by Percentpopulationinfected DESC

-- Highest percent of deaths per population for each country

SELECT Location, MAX(CAST(total_deaths as INT)) as Total_death_count
FROM Deaths
WHERE continent != ''
GROUP BY Location
ORDER BY Total_death_count DESC

-- Total Deaths for each continent

SELECT location , MAX(CAST(total_deaths as INT)) as Total_death_count
FROM Deaths
WHERE continent = '' and location in ('Africa', 'North America', 'South America', 'Ocenia', 'Asia','Europe','World')
GROUP BY location
ORDER BY Total_death_count DESC

-- Deaths by Date

SELECT date, SUM(new_cases), SUM(CAST(new_deaths as int)),
(SUM(CAST(new_deaths as int))*1.0)/SUM(new_cases)*100
FROM Deaths
WHERE continent != ''
-- GROUP BY date
Order by 1

-- Percent of deaths per day

SELECT SUM(new_cases), SUM(CAST(new_deaths as int)),
(SUM(CAST(new_deaths as int))*1.0)/SUM(new_cases)*100
FROM Deaths
WHERE continent != ''
Order by 1


-- Vaccination Percentage of the population

SELECT Deaths.continent, Deaths.location, Deaths.date, Deaths.population,
Vaccinations.new_vaccinations,
SUM(CAST(Vaccinations.new_vaccinations as INT)) OVER (Partition by Deaths.location ORDER BY Deaths.location,
Deaths.date ) as RollingPeopleVaccinated
FROM Deaths
JOIN Vaccinations
ON Deaths.location = Vaccinations.location AND Deaths.date = Vaccinations.date
WHERE Deaths.continent != '' -- and Deaths.location = 'Canada'
ORDER BY 2,3

-- Using CTE, Percentage of people Vaccinated at the date as a percentage of total population

WITH POPvsVAC (continent,location, date, population, new_vacciantions,rollingpeoplevaccinated)
as 

(SELECT Deaths.continent, Deaths.location, Deaths.date, Deaths.population,
Vaccinations.new_vaccinations,
SUM(CAST(Vaccinations.new_vaccinations as INT)) OVER (Partition by Deaths.location ORDER BY Deaths.location,
Deaths.date ) as RollingPeopleVaccinated

FROM Deaths
JOIN Vaccinations
ON Deaths.location = Vaccinations.location AND Deaths.date = Vaccinations.date
WHERE Deaths.continent != '') -- and Deaths.location = 'Canada')

SELECT *, (rollingpeoplevaccinated*1.0/population)*100
FROM POPvsVAC

-- Created the previous query as a temporary table and inserted data

Create Table PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert into PercentPopulationVaccinated
SELECT Deaths.continent, Deaths.location, Deaths.date, Deaths.population,
Vaccinations.new_vaccinations,
SUM(CAST(Vaccinations.new_vaccinations as INT)) OVER (Partition by Deaths.location ORDER BY Deaths.location,
Deaths.date ) as RollingPeopleVaccinated
FROM Deaths
JOIN Vaccinations
ON Deaths.location = Vaccinations.location AND Deaths.date = Vaccinations.date
WHERE Deaths.continent != '' -- and Deaths.location = 'Canada'




