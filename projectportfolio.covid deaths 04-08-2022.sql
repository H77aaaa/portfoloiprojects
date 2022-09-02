
--select* from portfolioproject..covidvacsination;
select location, date,population, new_cases, total_cases
from projectportfolio..covidDeaths$
where continent is not null
order by 1,2;

--loking at total_cases vs total_deaths
select location, population, total_deaths,total_cases,
(total_cases*total_deaths)/100 as persantpopulationInfected
from projectportfolio..covidDeaths$
where continent is not null
order by 1,2;

--loking at total_cases vs population
select location,date, population, total_deaths,total_cases,
(population*total_cases)/100 as persantpopulationInfected
from projectportfolio..covidDeaths$
where continent is not null
order by 1,2;

--loking at countries whith highest infection rate compared to population
select location, population,
MAX(total_cases) as HighstInfectionCount ,
MAx((population*total_cases)/100) as PersantPopulationInfected
from projectportfolio..covidDeaths$
where continent is not null
group by location, population 
order by PersantPopulationInfected desc;

--loking at countries whith Highest death count per population (location)
select location,
MAX(cast(total_deaths as int)) as HighestDeathscount
from projectportfolio..covidDeaths$
where continent is not null
group by location
order by HighestDeathscount desc;

--loking at countries whith Highest death count per population (contenent)
select location,
MAX(cast(total_deaths as int)) as HighestDeathscount
from projectportfolio..covidDeaths$
where continent is null
group by location
order by HighestDeathscount desc;

--globel numbers
select date, sum(new_cases) as total_cases,
sum(cast(new_deaths as bigint)) as total_deaths,
sum(cast(new_deaths as bigint))/sum(new_cases) *100 as total_deathes
from projectportfolio..covidDeaths$
where continent is not null
group by date;

select sum(new_cases) as total_cases,
sum(cast(new_deaths as bigint)) as total_deaths,
sum(cast(new_deaths as bigint))/sum(new_cases) *100 as total_deathes
from projectportfolio..covidDeaths$
where continent is not null;

--loking at total population vs vaccinations
--CTE
with popvsvac (continent,location,date,population,new_vaccinations,number_of_vaccinations)
as
(
select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,
sum(convert(bigint,vac.new_vaccinations))
over (partition by dea.location order by dea.location, dea.date) as number_of_vaccinations
from projectportfolio..covidDeaths$ dea
join covidvacsins$  vac
on dea.date = vac.date
and dea.location = vac.location
where dea.continent is not null
)
select*,(number_of_vaccinations/population)*100 as vaccinationpersantig
from popvsvac;

--Creating View for later visualization  

create view popvsvac as

 with popvsvac as
(
select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,
sum(convert(bigint,vac.new_vaccinations))
over (partition by dea.location order by dea.location, dea.date) as number_of_vaccinations
from projectportfolio..covidDeaths$ dea
join covidvacsins$  vac
on dea.date = vac.date
and dea.location = vac.location
where dea.continent is not null
)

create view deathcountperlocation as
(
select location,
MAX(cast(total_deaths as int)) as HighestDeathscount
from projectportfolio..covidDeaths$
where continent is not null
group by location)
--order by HighestDeathscount desc);

create view dethcountpercontinent as
(
select location,
MAX(cast(total_deaths as int)) as HighestDeathscount
from projectportfolio..covidDeaths$
where continent is null
group by location
--order by HighestDeathscount desc;
);

create view globelnumbers as 

(select sum(new_cases) as total_cases,
sum(cast(new_deaths as bigint)) as total_deaths,
sum(cast(new_deaths as bigint))/sum(new_cases) *100 as total_deathes
from projectportfolio..covidDeaths$
where continent is not null
);
