/*

Cleaning Data in SQL Queries

*/

Select *
From PortfolioProject.dbo.NashvilleHousing


-- Standardize Data Format

Select SaleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing

Update PortfolioProject.dbo.NashvilleHousing
SET SaleDate= CONVERT(Date,SaleDate)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add SaleDateConverted Date;

Update PortfolioProject.dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


-- Populate Property Address data

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
     on a.ParcelID=b.ParcelID
	 AND a.[UniqueID ]<>b.[UniqueID ]


Update a
SET PropertyAddress= ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
     on a.ParcelID=b.ParcelID
	 AND a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is null


--Breaking out Address into single Columns(Address,City,State)

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))as Address
From PortfolioProject.dbo.NashvilleHousing



ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add PropertySplitAddress nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) 

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add PropertySplitCity nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

Select PropertySplitAddress, PropertySplitCity
From PortfolioProject.dbo.NashvilleHousing



Select ownerAddress
From PortfolioProject.dbo.NashvilleHousing



Select
PARSENAME(REPLACE(ownerAddress,',','.'),3)
,PARSENAME(REPLACE(ownerAddress,',','.'),2)
,PARSENAME(REPLACE(ownerAddress,',','.'),1)
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add ownerSplitAddress nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET ownerSplitAddress =PARSENAME(REPLACE(ownerAddress,',','.'),3) 

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add ownerSplitCity nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET ownerSplitCity = PARSENAME(REPLACE(ownerAddress,',','.'),2)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add ownerSplitState nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET ownerSplitState = PARSENAME(REPLACE(ownerAddress,',','.'),1) 

Select ownerSplitAddress,ownerSplitCity,ownerSplitState
From PortfolioProject.dbo.NashvilleHousing

-- Change Y and N to Yes and No in "Sold as Vacant" feild

Select Distinct(SoldAsVacant), Count(soldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by soldAsVacant
order by 2

Select SoldasVacant
,CASE When SoldAsVacant = 'Y' THEN 'Yes'
	 When SoldAsVacant = 'N' Then 'NO'
	 ELSE SoldAsVacant
	 END
	 From PortfolioProject.dbo.NashvilleHousing

Update PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant=CASE When SoldAsVacant = 'Y' THEN 'Yes'
	 When SoldAsVacant = 'N' Then 'NO'
	 ELSE SoldAsVacant
	 END

Select SoldAsVacant
From PortfolioProject.dbo.NashvilleHousing


--Delete Unused Columns


Select *
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress
	 
ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN saleDate
