const express = require("express");
const importedSalesData = require('./data/monthlySales');
const importedRevData = require('./data/monthlyRevenue')
const importedProfitsData = require('./data/yearlyProfits')
const importedEmployeesData = require('./data/departments')
const businessMetrices = require('./data/businessMetrices')

const app = express();
app.set("view engine", "ejs");
app.use(express.static("public"));
app.use(express.urlencoded({ extended: true }))


app.get("/", (req, res) => {

  const title = "Dashboard"
  const active = "Dashboard"

  // to create 2 arrays 
  const salesDataLists = {
    salesMonths: [],
    salesData: []
  };
  
  importedSalesData.forEach(item => {
    salesDataLists.salesMonths.push(item.month);
    salesDataLists.salesData.push(item.sales);
  });

  // Object distructuring
  const {salesMonths, salesData } = salesDataLists

  // to create 2 arrays 
  const profitsDataLists = {
    year: [],
    yearProfits: []
  };
  
  importedProfitsData.forEach(item => {
    profitsDataLists.year.push(item.year);
    profitsDataLists.yearProfits.push(item.yearProfits);
  });

  // Object distructuring
  const {year, yearProfits } = profitsDataLists

  // to create 2 arrays 
  const dataFromMetrices = {
    metrices: [],
    metricesData: []
  };
  
  businessMetrices.forEach(item => {
    dataFromMetrices.metrices.push(item.metric);
    dataFromMetrices.metricesData.push(item.metricData);
  });

  // Object distructuring
  const { metrices, metricesData } = dataFromMetrices

  // to create 2 arrays 
  const revenueData = {
    revMonths: [],
    revData: []
  };
  
  importedRevData.forEach(item => {
    revenueData.revMonths.push(item.month);
    revenueData.revData.push(item.rev);
  });

  // Object distructuring
  const {revMonths, revData } = revenueData

  // to create 2 arrays 
  const departmentsData = {
    departments: [],
    numberOfEmployees: []
  };
  
  importedEmployeesData.forEach(item => {
    departmentsData.departments.push(item.department);
    departmentsData.numberOfEmployees.push(item.numberOfEmployees);
  });

  // Object distructuring
  const { departments, numberOfEmployees } = departmentsData



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
