select * from SampleProject.dbo.NashvilleHousing

select SaleDate from SampleProject.dbo.NashvilleHousing

--Data Cleaning

select SaleDate, convert(Date,SaleDate)
from SampleProject.dbo.NashvilleHousing --converting saledate into date format

 Update SampleProject.dbo.NashvilleHousing --update table 
 SET SaleDate =convert(Date,SaleDate)

 alter table SampleProject.dbo.NashvilleHousing 
 Add SaleDateConverted Date

  Update SampleProject.dbo.NashvilleHousing    
 SET SaleDateConverted =convert(Date,SaleDate)

 select SaleDateConverted, convert(Date,SaleDate)
from SampleProject.dbo.NashvilleHousing


--Property Address Data

select PropertyAddress
from SampleProject.dbo.NashvilleHousing 
where PropertyAddress IS not NULL


select * from SampleProject.dbo.NashvilleHousing 
where PropertyAddress IS NULL order by ParcelID


-- when property address is null then take b.property adsress and put it on a.property address
select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from SampleProject.dbo.NashvilleHousing a
join SampleProject.dbo.NashvilleHousing b
 on a.ParcelID=b.ParcelID
 and a.[UniqueID ]<>b.[UniqueID ]
 where a.PropertyAddress is null

--Update the column 
Update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from SampleProject.dbo.NashvilleHousing a
join SampleProject.dbo.NashvilleHousing b
 on a.ParcelID=b.ParcelID
 and a.[UniqueID ]<>b.[UniqueID ]
 where a.PropertyAddress is null


 --Breaking address into individual columns

 select PropertyAddress
 from SampleProject.dbo.NashvilleHousing
 
 --seperating property address when ',' is found)
 
 select 
 substring(PropertyAddress, 1,CHARINDEX(',',PropertyAddress))
 as address,
 SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
 from SampleProject.dbo.NashvilleHousing


 ALTER TABLE SampleProject.dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update SampleProject.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE SampleProject.dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update SampleProject.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

Select *
From  SampleProject.dbo.NashvilleHousing

--Splitting owner address into individual columns
Select OwnerAddress
From SampleProject.dbo.NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)  --checking , from last third and replacing , with .
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)  --checking , from last second
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1) --checking , from last
From SampleProject.dbo.NashvilleHousing

--update columns with appropriate names
ALTER TABLE SampleProject.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update SampleProject.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE SampleProject.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update SampleProject.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE SampleProject.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update SampleProject.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


Select *
From SampleProject.dbo.NashvilleHousing


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From SampleProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2   --checking distinct count of yes,no,y and n.


select SoldAsVacant,
case when SoldAsVacant='Y' THEN 'YES'
     when SoldAsVacant='N' THEN 'NO'
	 else SoldAsVacant
	 END
from SampleProject.dbo.NashvilleHousing

Alter table SampleProject.dbo.NashvilleHousing
add SoldVacant Nvarchar(255)

Update SampleProject.dbo.NashvilleHousing
set SoldVacant= case when SoldAsVacant='Y' THEN 'YES'
     when SoldAsVacant='N' THEN 'NO'
	 else SoldAsVacant
	 END

select * from SampleProject.dbo.NashvilleHousing


Select Distinct(SoldVacant), Count(SoldVacant)
From SampleProject.dbo.NashvilleHousing
Group by SoldVacant
order by 2  

-- Remove Duplicates
with RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From SampleProject.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


-- Delete Unused Columns



Select *
From SampleProject.dbo.NashvilleHousing


ALTER TABLE SampleProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


