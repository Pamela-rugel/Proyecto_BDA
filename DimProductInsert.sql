
SET IDENTITY_INSERT [AdventureWorksDW2019].[dbo].[DimProduct] ON;

Insert Into [AdventureWorksDW2019].[dbo].[DimProduct](
	   [ProductKey]
      ,[ProductAlternateKey]
      ,[ProductSubcategoryKey]
      ,[WeightUnitMeasureCode]
      ,[SizeUnitMeasureCode]
      ,[EnglishProductName]
      ,[SpanishProductName]
      ,[FrenchProductName]
      ,[StandardCost]
      ,[FinishedGoodsFlag]
      ,[Color]
      ,[SafetyStockLevel]
      ,[ReorderPoint]
      ,[ListPrice]
      ,[Size]
      ,[SizeRange]
      ,[Weight]
      ,[DaysToManufacture]
      ,[ProductLine]
      ,[DealerPrice]
      ,[Class]
      ,[Style]
      ,[ModelName]
      ,[LargePhoto]
      ,[EnglishDescription]
      ,[FrenchDescription]
      ,[ChineseDescription]
      ,[ArabicDescription]
      ,[HebrewDescription]
      ,[ThaiDescription]
      ,[GermanDescription]
      ,[JapaneseDescription]
      ,[TurkishDescription]
      ,[StartDate]
      ,[EndDate]
      ,[Status]
	  )
Select
	  P.[ProductID]							AS ProductKey
      ,P.[ProductNumber]					AS ProductAlternateKey
      ,PSB.[ProductSubcategoryID]			AS ProductSubcategoryKey
      ,P.[WeightUnitMeasureCode]			AS WeightUnitMeasureCode
      ,P.[SizeUnitMeasureCode]				AS SizeUnitMeasureCode
      ,P.Name								AS EnglishProductName
	  ,''									AS SpanishProductName
	  ,''									AS FrenchProductName
      ,P.[StandardCost]						AS StandardCost
      ,P.[FinishedGoodsFlag]				AS FinishedGoodsFlag
      ,ISNULL(P.Color, 'NA')				AS Color
      ,P.[SafetyStockLevel]					AS SafetyStockLevel
      ,P.[ReorderPoint]						AS ReorderPoint
      ,P.[ListPrice]						AS ListPrice
      ,P.[Size]								AS Size
	  ,Null									As SizeRange
      ,P.[Weight]							AS Weight
      ,P.[DaysToManufacture]				AS DaysToManufacture
      ,P.[ProductLine]						AS ProductLine
	  ,Null									AS DealerPrice
      ,P.[Class]							AS Class
      ,P.[Style]							AS Style
      ,PM.Name								AS ModelName
	  ,null									AS LargePhoto
	  ,''									AS EnglishDescription
      ,''	 								AS FrenchDescription
      ,''	 								AS ChineseDescription
      ,'' 									AS ArabicDescription
      ,''									AS HebrewDescription
      ,''									AS ThaiDescription
      ,''	 								AS GermanDescription
      ,''	 								AS JapaneseDescription
      ,''	 								AS TurkishDescription
	  ,null 								AS StartDate
      ,null 								AS EndDate
      ,null as Status
  FROM		
			[AdventureWorks2019].[Production].[Product]					AS P
		Left Join
			[AdventureWorks2019].[Production].[ProductSubcategory]		AS PSB	ON P.ProductID	= PSB.ProductSubcategoryID
		Left JOIN
			[AdventureWorks2019].[Production].[ProductModel]			AS PM	ON P.ProductID	= PM.ProductModelID
		Full JOIN
			[AdventureWorks2019].[Sales].[SalesOrderDetail]				AS SD	ON P.ProductID = SD.ProductID
		left JOIN	
			[AdventureWorks2019].[Sales].[SalesOrderHeader]				AS SH	ON SH.SalesOrderID		= SD.SalesOrderID						
		left JOIN														
 			[AdventureWorks2019].[Sales].[SalesOrderHeaderSalesReason]	AS SHSR	ON SH.SalesOrderID		= SHSR.SalesOrderID
		left JOIN
			[AdventureWorks2019].[Sales].[SpecialOffer]					AS SO	ON SD.SpecialOfferID	= SO.SpecialOfferID
 
  WHERE 
			SHSR.SalesReasonID = 2 
	Group By

		P.[ProductID]
      ,P.[ProductNumber]
      ,PSB.[ProductSubcategoryID]
      ,P.[WeightUnitMeasureCode]
      ,P.[SizeUnitMeasureCode]
      ,P.Name
      ,P.[StandardCost]
      ,P.[FinishedGoodsFlag]
      ,P.[Color]
      ,P.[SafetyStockLevel]
      ,P.[ReorderPoint]
      ,P.[ListPrice]
      ,P.[Size]
      ,P.[Weight]
      ,P.[DaysToManufacture]
      ,P.[ProductLine]
      ,P.[Class]
      ,P.[Style]
      ,PM.Name

	  Order by P.ProductID

  