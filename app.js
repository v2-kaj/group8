const express = require("express");
const importedSalesData = require('./data/monthlySales');
const importedRevData = require('./data/monthlyRevenue')
const {year, yearProfits} = require('./data/yearlyProfits')
const {departments, numberOfEmployees} = require('./data/departments')
const {metrices, metricesData} = require('./data/businessMetrices')

const app = express();
app.set("view engine", "ejs");
app.use(express.static("public"));
app.use(express.urlencoded({ extended: true }))


app.get("/", (req, res) => {

  const title = "Dashboard"
  const active = "Dashboard"
  const salesMonths = importedSalesData.months
  const salesData = importedSalesData.sales
  const revMonths = importedRevData.months
  const revData = importedRevData.rev
  

  const data = { 
    revMonths, 
    revData, 
    salesMonths, 
    salesData, 
    active, 
    title,
    year, 
    yearProfits,
    departments,
    numberOfEmployees,
    metrices,
    metricesData,
  }
  res.render("index", data);
});

app.get("/team", (req, res) => {
  const data = {
    title: "Team",
    active: "Team",
  };
  res.render("team", data);
});

app.get("/projects", (req, res) => {
  const data = {
    title: "Projects",
    active: "Projects",
  };
  res.render("projects", data);
});

app.get("/documents", (req, res) => {
  const data = {
    title: "Documents",
    active: "Documents",
  };
  res.render("documents", data);
});

app.get("/calendar", (req, res) => {
  const data = {
    title: "Calendar",
    active: "Calendar",
  };
  res.render("calendar", data);
});

app.get("/reports", (req, res) => {
  const data = {
    title: "Reports",
    active: "Reports",
  };
  res.render("reports", data);
});
const port = 3000
app.listen(port, () => {
  console.log(`server started at port ${port}`);
});
