select *
from portfolioproject..covidvaccinations$ as vac

select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location ,dea.date)vaccination_per_location
--(vaccination_per_location/population) * 100
from portfolioproject..coviddeaths$ as dea
join portfolioproject..covidvaccinations$ as vac 
	on dea.date = vac.date
	and dea.location = vac.location
where dea.continent is not null
order by 2,3

with popvsvac(continent,location,date,population,new_vaccination,vaccination_per_location)
as
(
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location ,dea.date)vaccination_per_location
--(vaccination_per_location/population) * 100
from portfolioproject..coviddeaths$ as dea
join portfolioproject..covidvaccinations$ as vac 
	on dea.date = vac.date
	and dea.location = vac.location
where dea.continent is not null
--order by 2,3
)
select *,(vaccination_per_location/population)*100
from popvsvac

drop table if exists #percentage_population_vaccinated
create table #percentage_population_vaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccination numeric,
vaccination_per_location numeric
) 

insert into #percentage_population_vaccinated
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location ,dea.date)vaccination_per_location
--(vaccination_per_location/population) * 100
from portfolioproject..coviddeaths$ as dea
join portfolioproject..covidvaccinations$ as vac 
	on dea.date = vac.date
	and dea.location = vac.location
--where dea.continent is not null
--order by 2,3

select *,(vaccination_per_location/population)*100 vacc_per_population
from #percentage_population_vaccinated

use portfolioproject
go
create view percentage_population_vaccinated as
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location ,dea.date)vaccination_per_location
--(vaccination_per_location/population) * 100
from portfolioproject..coviddeaths$ as dea
join portfolioproject..covidvaccinations$ as vac 
	on dea.date = vac.date
	and dea.location = vac.location
where dea.continent is not null
--order by 2,3

