

use AdventureWorksDW2019;

CREATE TABLE FactPromotionSales (
	SalesOrderNumber NVARCHAR(25),
	SalesOrderRowNumber SmallInt,
    ProductKey INT,
    CustomerKey INT,
    TerritoryKey INT,
    PromotionKey INT,
    UnitPrice MONEY,
    OrderQuantity INT,
    DiscountedPrice MONEY,
    OnlineOrderFlag BIT,
    SalesAmount MONEY,
    Freight MONEY,
    DiscountPct FLOAT,
	TotalDue Money,
    OrderDateKey INT,
    DueDateKey INT,
    ShipDateKey INT,
    OrderDate DATE,
	TaxAmt MONEY,
    DueDate DATE,
    ShipDate DATE,
    PRIMARY KEY (SalesOrderNumber,SalesOrderRowNumber) -- Assuming SaleOrderID is the primary key
);

--Foreign Keys Dimensiones

ALTER TABLE FactPromotionSales
ADD CONSTRAINT FK_DimCustomer FOREIGN KEY (CustomerKey) REFERENCES DimCustomer(CustomerKey);

ALTER TABLE FactPromotionSales
ADD CONSTRAINT FK_DimSalesTerritory FOREIGN KEY (TerritoryKey) REFERENCES DimSalesTerritory(SalesTerritoryKey);

ALTER TABLE FactPromotionSales
ADD CONSTRAINT FK_DimPromotion FOREIGN KEY (PromotionKey) REFERENCES DimPromotion(PromotionKey);

ALTER TABLE FactPromotionSales
ADD CONSTRAINT FK_DimProduct FOREIGN KEY (PromotionKey) REFERENCES DimProduct(ProductKey);

--Foreign key Dimensiones fecha

ALTER TABLE FactPromotionSales
ADD CONSTRAINT FK_Due_DimDate FOREIGN KEY (DueDateKey) REFERENCES DimDate(DateKey);

ALTER TABLE FactPromotionSales
ADD CONSTRAINT FK_Ship_DimDate FOREIGN KEY (ShipDateKey) REFERENCES DimDate(DateKey);

ALTER TABLE FactPromotionSales
ADD CONSTRAINT FK_Order_DimDate FOREIGN KEY (OrderDateKey) REFERENCES DimDate(DateKey);

--Select Insert


INSERT INTO [dbo].[FactPromotionSales]
           ([SalesOrderNumber]
           ,[SalesOrderRowNumber]
           ,[ProductKey]
           ,[CustomerKey]
           ,[TerritoryKey]
           ,[PromotionKey]
           ,[UnitPrice]
           ,[OrderQuantity]
           ,[DiscountPct]
           ,[DiscountedPrice]
           ,[TaxAmt]
           ,[Freight]
           ,[SalesAmount]
           ,[TotalDue]
			,[OnlineOrderFlag]
		   ,[OrderDate]
           ,[DueDate]
           ,[ShipDate]
           ,[OrderDateKey]
           ,[DueDateKey]
           ,[ShipDateKey]
)
SELECT
		SH.SalesOrderNumber								AS SalesOrderNumber
		,ROW_NUMBER() OVER 
			(	PARTITION BY SH.SalesOrderID 
					ORDER BY SD.SalesOrderDetailID
			)											AS SalesOrderRowNumber
		,SD.ProductID									AS ProductKey
		,SH.CustomerId									AS CustomerKey
		,SH.TerritoryID									AS TerritoryKey
		,SO.SpecialOfferID								AS PromotionKey
		,SD.UnitPrice									AS UnitPrice
		,SUM(SD.OrderQty)								AS OrderQuantity
		,SO.DiscountPct									AS DiscountPct
		,(SD.UnitPrice*(1-SO.DiscountPct))				AS DiscountedPrice
		,NULL   										AS TaxAmt
		,SH.Freight										AS Freight
		,SD.UnitPrice * SUM(SD.OrderQty)				AS SalesAmount
		,SH.TotalDue									AS TotalDue
		,SH.OnlineOrderFlag								AS OnlineOrderFlag
		,SH.OrderDate									AS OrderDate
		,SH.DueDate										AS DueDate
		,SH.ShipDate									AS ShipDate
		,YEAR(SH.OrderDate)	*10000
		+ MONTH(SH.OrderDate)	*100
			+ DAY(SH.OrderDate)							AS OrderDateKey

		,YEAR(SH.DueDate)		*10000
		+ MONTH(SH.DueDate)		*100
			+ DAY(SH.DueDate)							AS DueDateKey

		,YEAR(SH.ShipDate)	*10000
		+ MONTH(SH.ShipDate)	*100
			+ DAY(SH.ShipDate)							AS ShipDateKey

  FROM		[AdventureWorks2019].[Sales].[SalesOrderHeader]				AS SH
		JOIN	
			[AdventureWorks2019].[Sales].[SalesOrderDetail]				AS SD	ON SH.SalesOrderID		= SD.SalesOrderID
		JOIN	
 			[AdventureWorks2019].[Sales].[SalesOrderHeaderSalesReason]	AS SHSR	ON SH.SalesOrderID		= SHSR.SalesOrderID
		JOIN
			[AdventureWorks2019].[Sales].[SpecialOffer]					AS SO	ON SD.SpecialOfferID	= SO.SpecialOfferID
 
  WHERE 
			(OrderDate	> '2004-12-31'	AND OrderDate	< '2015-01-01')
		AND
			(DueDate	> '2004-12-31'	AND DueDate		< '2015-01-01')
		AND	
			(ShipDate	> '2004-12-31'	AND ShipDate	< '2015-01-01')
		AND	
			SHSR.SalesReasonID = 2 
  GROUP BY
		 SD.ProductID
		,SD.SalesOrderDetailID
		,SD.UnitPrice
		,SH.SalesOrderID
		,SH.CustomerId
		,SH.SalesOrderNumber
		,SH.OnlineOrderFlag
		,SH.TotalDue
		,SH.TaxAmt
		,SH.Freight
		,SH.OrderDate
		,SH.DueDate
		,SH.ShipDate
		,SH.TerritoryID
		,SO.SpecialOfferID
		,SO.DiscountPct
	Order by SD.ProductID


Select Top(100) * From [AdventureWorksDW2019].[dbo].[FactPromotionSales];



/* SQL Query 2 without promotion dimention*/