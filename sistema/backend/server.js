const express = require('express');
const sql = require('mssql/msnodesqlv8');

const app = express();
const port = 3000; // Puerto en el que escuchará el servidor


// Middleware para habilitar CORS
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*'); // Esto permite solicitudes desde cualquier origen
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');
  res.header('Access-Control-Allow-Headers', 'Content-Type');
  next();
});


// Configurar la conexión a la base de datos SQL Server
const dbConfig = {
  server: 'PAMELARD\\SQLEXPRESS',
  database: 'AdventureWorksDW2019',
  driver: 'msnodesqlv8',
  options: {
    trustedConnection: true
  }

};

// Conectar a la base de datos
sql.connect(dbConfig).then(pool => {
  console.log('Conectado a la base de datos SQL Server');
}).catch(err => {
  console.error('Error en la conexión:', err);
});


// ENDPOINTS
app.get('/products', async (req, res) => {
  try {
    const pool = await sql.connect(dbConfig);
    const result = await pool.request().query(
    `SELECT TOP (5)
    p.EnglishProductName AS ProductName,
    COUNT(*) AS TotalSales
    FROM FactPromotionSales AS PS
    JOIN DimProduct AS P ON PS.ProductKey = P.ProductKey
    GROUP BY P.EnglishProductName
    ORDER BY TotalSales DESC`
      );
    res.json(result.recordset);
  } catch (err) {
    console.error('Error en la consulta:', err);
    res.status(500).send('Error en la consulta');
  }
});



app.get('/year_sales', async (req, res) => {
  try {
    const pool = await sql.connect(dbConfig);
    const result = await pool.request().query(
      `SELECT YEAR(D.FullDateAlternateKey) AS Date,
        SUM(PS.SalesAmount) AS AccumulatedSales
      FROM FactPromotionSales  AS PS
      JOIN DimDate D ON OrderDateKey = DateKey
      GROUP BY YEAR(D.FullDateAlternateKey)
      ORDER BY Date`
      );
    res.json(result.recordset);
  } catch (err) {
    console.error('Error en la consulta:', err);
    res.status(500).send('Error en la consulta');
  }
});


app.get('/discount_pct', async (req, res) => {
  try {
    const pool = await sql.connect(dbConfig);
    const result = await pool.request().query(
      `SELECT
            CASE
                WHEN PS.DiscountPct = 0.02 THEN '2%'
                WHEN PS.DiscountPct = 0.15 THEN '15%'
                WHEN PS.DiscountPct = 0.2 THEN '20%'
            ELSE 'No Discount'
            END AS DiscountPct,
            SUM(PS.SalesAmount) AS TotalSales
        FROM
            FactPromotionSales AS PS
        GROUP BY
            DiscountPct`
      );
    res.json(result.recordset);
  } catch (err) {
    console.error('Error en la consulta:', err);
    res.status(500).send('Error en la consulta');
  }
});


app.get('/territory', async (req, res) => {
  try {
    const pool = await sql.connect(dbConfig);
    const result = await pool.request().query(
      `SELECT
          T.SalesTerritoryCountry AS TerritoryCountry,
          SUM(PS.SalesAmount) AS TotalSales
      FROM
          FactPromotionSales AS PS
      JOIN
          DimSalesTerritory AS T ON PS.TerritoryKey = T.SalesTerritoryKey
      GROUP BY
          T.SalesTerritoryCountry
      ORDER BY
          TotalSales DESC`
      );
    res.json(result.recordset);
  } catch (err) {
    console.error('Error en la consulta:', err);
    res.status(500).send('Error en la consulta');
  }
});



app.get('/customer', async (req, res) => {
  try {
    const pool = await sql.connect(dbConfig);
    const result = await pool.request().query(
      `
      SELECT top(7)
          C.CustomerKey,
          CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName,
          COUNT(*) AS TotalPromotionPurchases
      FROM
          FactPromotionSales AS PS
      JOIN
          DimCustomer AS C ON PS.CustomerKey = C.CustomerKey
      WHERE
          PS.PromotionKey IS NOT NULL
      GROUP BY
          C.CustomerKey, CONCAT(C.FirstName, ' ', C.LastName)
      ORDER BY
          TotalPromotionPurchases DESC;
      `
      );
    res.json(result.recordset);
  } catch (err) {
    console.error('Error en la consulta:', err);
    res.status(500).send('Error en la consulta');
  }
});



// Iniciar el servidor
app.listen(port, () => {
  console.log(`Servidor Express escuchando en el puerto ${port}`);
});
