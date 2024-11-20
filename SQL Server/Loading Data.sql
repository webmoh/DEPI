



-- loading data into the sales_teams table - file: sales_teams.csv 
BULK INSERT [dbo].[sales_teams]
FROM 'C:\Users\CYBER-TECH\Downloads\CRM_Sales_Opportunities_project-main\modified_files\sales_teams.csv'
WITH (
	FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '\n', 
    FIRSTROW = 2
);

SELECT TOP (5) * FROM [dbo].[sales_teams];

-- loading data into the products table - file: products.csv
BULK INSERT[dbo].[products]
FROM 'C:\Users\CYBER-TECH\Downloads\CRM_Sales_Opportunities_project-main\modified_files\products.csv'
WITH (
	FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '\n', 
    FIRSTROW = 2
);

SELECT TOP(5) * FROM [dbo].[products];

-- loading data into the accounts table - file: accounts.csv
BULK INSERT [dbo].[accounts]
FROM 'C:\Users\CYBER-TECH\Downloads\CRM_Sales_Opportunities_project-main\modified_files\accounts.csv'
WITH (
	FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '\n', 
    FIRSTROW = 2
);

SELECT TOP(5) * FROM [dbo].[accounts];

-- loading data into the sales_pipeline table - file: sales_pipeline.csv
BULK INSERT [dbo].[sales]
FROM 'C:\Users\CYBER-TECH\Downloads\CRM_Sales_Opportunities_project-main\modified_files\sales_pipeline.csv'
WITH (
	FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '\n', 
    FIRSTROW = 2
);

SELECT TOP(5) * FROM [dbo].[sales];