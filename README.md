# NashvilleHousing-DataCleaning-Using-SQL

Data Cleaning Portfolio project using SQl.



Converted the SALEDATE column which is in date and timestamp format to DateOnly format.
Separated the Property address which has complete address(including city,address) into individual columns.
Split the Owner address into individual columns.
Updated the columns with inappropriate names.
Altered Y and N to understable manner in SoldasVacant column using case.


Removed duplicates  Using CTE (Common table Expression)  using row_number() function and partition by clause.

