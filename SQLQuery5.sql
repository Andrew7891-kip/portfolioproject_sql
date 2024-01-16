select *
from portfolioproject..nationalhousing	

select SaleDateConverted, convert(date,SaleDate)
from portfolioproject..nationalhousing

update nationalhousing
set SaleDate = convert(date,SaleDate)

alter table nationalhousing
add SaleDateConverted date;

update nationalhousing
set SaleDateConverted = convert(date,SaleDate)

--select *
--from portfolioproject..nationalhousing	
--order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
from portfolioproject..nationalhousing	a
join portfolioproject..nationalhousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a 
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from portfolioproject..nationalhousing	a
join portfolioproject..nationalhousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

select PropertyAddress
from portfolioproject..nationalhousing	

select
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) as address
,SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1,len(PropertyAddress)) as address
from portfolioproject..nationalhousing	

--alter table nationalhousing
--drop column propertysplitaddr

alter table nationalhousing
add propertysplitaddr nvarchar(255);

update nationalhousing
set propertysplitaddr = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1)

alter table nationalhousing
add propertysplitcity nvarchar(255);

update nationalhousing
set propertysplitcity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1,len(PropertyAddress))

--select OwnerAddress
--from portfolioproject..nationalhousing	

select 
PARSENAME(replace(OwnerAddress,',','.'),3) ownersaddr,
PARSENAME(replace(OwnerAddress,',','.'),2) ownerscity,
PARSENAME(replace(OwnerAddress,',','.'),1) ownersstate
from portfolioproject..nationalhousing

alter table nationalhousing
add ownersaddr nvarchar(255);

update nationalhousing
set ownersaddr = PARSENAME(replace(OwnerAddress,',','.'),3)

alter table nationalhousing
add ownerscity nvarchar(255);

update nationalhousing
set ownerscity = PARSENAME(replace(OwnerAddress,',','.'),2) 

alter table nationalhousing
add ownersstate nvarchar(255);

update nationalhousing
set ownersstate = PARSENAME(replace(OwnerAddress,',','.'),1)

--select *
--from portfolioproject..nationalhousing	

select distinct(SoldAsVacant),COUNT(SoldAsVacant)
from portfolioproject..nationalhousing	
group by SoldAsVacant
order by 2

select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'Y' then 'Yes'
	else SoldAsVacant
	end
from portfolioproject..nationalhousing	

update nationalhousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'Y' then 'Yes'
	else SoldAsVacant
	end

with rownum as (
select *,
	ROW_NUMBER() over(
		partition by ParcelID,
					PropertyAddress,
					SaleDate,
					SalePrice,
					LegalReference
					order by UniqueID
					) row_num
from portfolioproject..nationalhousing
)

select *
from rownum
where row_num > 1
order by PropertyAddress

--select *
--from portfolioproject..nationalhousing	

alter table portfolioproject..nationalhousing	
drop column PropertyAddress,SaleDate,OwnerAddress,TaxDistrict