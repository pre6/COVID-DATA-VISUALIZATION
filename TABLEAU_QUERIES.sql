

-- Queries I used for Visualizations

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM Deaths
WHERE continent != ''
ORDER by 1,2



SELECT Location, MAX(CAST(total_deaths as INT)) as Total_death_count
FROM Deaths
WHERE continent != ''
GROUP BY Location, population
ORDER BY Total_death_count DESC

SELECT Location,
Population,
MAX(total_cases) as Highest_infected, 
MAX(total_cases*1.0/Population)*100 as Percentpopulationinfected
FROM Deaths
WHERE continent != ''
GROUP BY Location
ORDER by Percentpopulationinfected DESC

SELECT Location,
Population,
Date,
MAX(total_cases) as Highest_infected, 
MAX(total_cases*1.0/Population)*100 as Percentpopulationinfected
FROM Deaths
WHERE continent != ''
GROUP BY Location, population, Date
ORDER by Percentpopulationinfected DESC




