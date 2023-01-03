CREATE DATABASE PORT;

USE PORT;

SELECT * FROM NASHVILLEHOUSING;


-------------------------------------------------------------------------------------------

-- Changing Sales Date Format

Select SaleDate
From NashvilleHousing;

Select SaleDate, CONVERT(DATE,SaleDate)
From NashvilleHousing;

-- WE CANT GET THE DESIRED OUTPUT AFTER UPDATING 

UPDATE NASHVILLEHOUSING
SET SALEDATE = CONVERT(DATE,SaleDate);

-- THATS WHY WE ARE FIRST ALTERING AND ADDING NEW COLUMN AND THEN UPDATING THE TABLE

ALTER TABLE NASHVILLEHOUSING
ADD SALEDATECONVERTED DATE;

-- AND AFTER ALTERING AGAI UPDATING IT 

UPDATE NASHVILLEHOUSING
SET SALEDATECONVERTED = CONVERT(DATE,SaleDate);


Select SaleDateCONVERTED, CONVERT(DATE,SaleDate)
From NashvilleHousing;


----------------------------------------------------------------------------------

-- HANDLING NULL VALUES ON PROPERTYADDRESS

Select PROPERTYADDRESS From NashvilleHousing
WHERE PROPERTYADDRESS IS NULL;

Select * From NashvilleHousing
ORDER BY PARCELID;


-- PARCEL ID IS ACCOMPANIED WITH PROPERTYADDRESS
-- WHERE EVER THERES NULL VAL IN PROP ADD WE WILL POPULATE IT WITH THAT PARCEL IDS ADDRESS

-- FOR THIS WE HAVE TO PERFORM SELF JOIN

SELECT A.PROPERTYADDRESS, A.PARCELID, B.PROPERTYADDRESS, B.PARCELID, ISNULL(A.PROPERTYADDRESS, B.PROPERTYADDRESS) AS PROP_ADD
FROM NASHVILLEHOUSING A
JOIN NASHVILLEHOUSING B
ON A.PARCELID = B.PARCELID AND A.UNIQUEID <> B.UNIQUEID
WHERE A.PROPERTYADDRESS IS NULL;

-- NOW UPDATING THE COLUMN
-- ISNULL SEARCH THE 1ST VAL AND IF DIDNT FIND IT THEN FILLS IT WITH 2ND VAL

UPDATE A
SET PROPERTYADDRESS = ISNULL(A.PROPERTYADDRESS, B.PROPERTYADDRESS)
FROM NASHVILLEHOUSING A
JOIN NASHVILLEHOUSING B
ON A.PARCELID = B.PARCELID AND A.UNIQUEID <> B.UNIQUEID
WHERE A.PROPERTYADDRESS IS NULL;

---------------------------------------------------------------------------------------------

-- SPLITTING PROP ADD WITH NEEW COLUMN FOR CITY

SELECT PropertyAddress FROM NASHVILLEHOUSING;


-- ONE MORE METHOD
SELECT 
SUBSTRING(PROPERTYADDRESS, 1, CHARINDEX(',', PROPERTYADDRESS) -1) AS 'ADDRESS',
SUBSTRING(PROPERTYADDRESS, CHARINDEX(',', PROPERTYADDRESS) +2, CHARINDEX(',', PROPERTYADDRESS))AS 'STATE'
FROM NASHVILLEHOUSING;

-- AUTHENTIC METHOD
SELECT 
SUBSTRING(PROPERTYADDRESS, 1, CHARINDEX(',', PROPERTYADDRESS) -1) AS 'ADDRESS',
SUBSTRING(PROPERTYADDRESS, CHARINDEX(',', PROPERTYADDRESS) +2, LEN(PROPERTYADDRESS))AS 'STATE'
FROM NASHVILLEHOUSING;


-- ALTERING THE TABLE TO ADD COLUMN
-- ADDIN TWO NEW COLUMNS

ALTER TABLE NASHVILLEHOUSING
ADD P_ADDRESS NVARCHAR(255);

ALTER TABLE NASHVILLEHOUSING
ADD P_CITY NVARCHAR(255);

-- UPDATING THE TABLE

UPDATE NASHVILLEHOUSING
SET P_ADDRESS = SUBSTRING(PROPERTYADDRESS, 1, CHARINDEX(',', PROPERTYADDRESS) -1)


UPDATE NASHVILLEHOUSING
SET P_CITY = SUBSTRING(PROPERTYADDRESS, CHARINDEX(',', PROPERTYADDRESS) +2, LEN(PROPERTYADDRESS))


SELECT * FROM NashvilleHousing;


---------------------------------------------------------------------------------------------------------------------------------------

-- HANDLING THE DATA IN OWNER NAME AND ADDRESS
-- FOR THIS WE PARSENAME METHOD
-- IT TAKE PERIOD IE '.' AS SPLITTER AND GIVES THE OUTPUT ACCORDINGLY 
-- SO WE HAVE CONVERTED THE COMMAS INTO DOT AND GOT THE OUTPUT


SELECT 
PARSENAME(REPLACE(OWNERADDRESS, ',', '.'), 1) AS 'STATE',
PARSENAME(REPLACE(OWNERADDRESS, ',', '.'), 2) AS 'CITY',
PARSENAME(REPLACE(OWNERADDRESS, ',', '.'), 3) AS 'ADDRESS'
FROM NashvilleHousing;


-- ADDING COLUMNS TO THA TABLES THROUGH ALTER COMMAND

ALTER TABLE NASHVILLEHOUSING
ADD OWNER_ADDRESS NVARCHAR(255);

ALTER TABLE NASHVILLEHOUSING
ADD OWNER_CITY NVARCHAR(255);

ALTER TABLE NASHVILLEHOUSING
ADD OWNER_STATE NVARCHAR(255);


-- UPATING THE COLUMNS 

UPDATE NASHVILLEHOUSING
SET OWNER_ADDRESS = PARSENAME(REPLACE(OWNERADDRESS, ',', '.'), 3)

UPDATE NASHVILLEHOUSING
SET OWNER_CITY = PARSENAME(REPLACE(OWNERADDRESS, ',', '.'), 2)

UPDATE NASHVILLEHOUSING
SET OWNER_STATE = PARSENAME(REPLACE(OWNERADDRESS, ',', '.'), 1)


SELECT * FROM NashvilleHousing;

---------------------------------------------------------------------------------------------------------------

-- HANDLING THE Y , YES , NO , N OF THE COLUMN -SOLDASVACANT

SELECT DISTINCT(SOLDASVACANT)
FROM NashvilleHousing;


SELECT SOLDASVACANT,
CASE WHEN SOLDASVACANT = 'Y' THEN 'YES'
	 WHEN SOLDASVACANT = 'N' THEN 'NO'
	 ELSE SOLDASVACANT
	 END
FROM NashvilleHousing;

UPDATE NashvilleHousing
SET SOLDASVACANT = CASE WHEN SOLDASVACANT = 'Y' THEN 'YES'
						WHEN SOLDASVACANT = 'N' THEN 'NO'
						ELSE SOLDASVACANT
						END;




SELECT DISTINCT(SOLDASVACANT), COUNT(SOLDASVACANT) 
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2;


------------------------------------------------------------------------------------------------------------------------

--REMOVING DUPLICATES 


-- AFTER DELETING THIS CTE WILL BE NULL THEN WE CAM CONFIRM THAT DUPLICATES ARE REMOVED

WITH ROW_NUM_CTE AS (
SELECT * , 
	ROW_NUMBER() OVER (
	PARTITION BY PARCELID,
				 PROPERTYADDRESS,
				 SALEPRICE,
				 SALEDATE,
				 LEGALREFERENCE
				 ORDER BY
					UNIQUEID
				 ) ROW_NUM
FROM NashvilleHousing
--ORDER BY ParcelID
)




SELECT * FROM ROW_NUM_CTE
WHERE ROW_NUM > 1;


WITH ROW_NUM_CTE AS (
SELECT * , 
	ROW_NUMBER() OVER (
	PARTITION BY PARCELID,
				 PROPERTYADDRESS,
				 SALEPRICE,
				 SALEDATE,
				 LEGALREFERENCE
				 ORDER BY
					UNIQUEID
				 ) ROW_NUM
FROM NashvilleHousing
--ORDER BY ParcelID
)

DELETE FROM ROW_NUM_CTE
WHERE ROW_NUM > 1;

----------------------------------------------------------------------------------------------------------------------------------------------


-- DELETING UNUSED COLUMNS

SELECT * FROM NashvilleHousing;


ALTER TABLE NASHVILLEHOUSING
DROP COLUMN OWNERADDRESS, TAXDISTRICT, PROPERTYADDRESS;

ALTER TABLE NASHVILLEHOUSING
DROP COLUMN SALEDATE;

