const express = require("express");
// object destructuring import
const {
  monthlySalesData,
  monthlyRevenueData,
  businessMetricesData,
  yearProfitsData,
  departmentsData
} = require('./data/data');

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

  monthlySalesData.forEach(item => {
    salesDataLists.salesMonths.push(item.month);
    salesDataLists.salesData.push(item.sales);
  });

  // Object destructuring
  const { salesMonths, salesData } = salesDataLists

  // to create 2 arrays 
  const profitsDataLists = {
    year: [],
    yearProfits: []
  };

  yearProfitsData.forEach(item => {
    profitsDataLists.year.push(item.year);
    profitsDataLists.yearProfits.push(item.yearProfits);
  });

  // Object destructuring
  const { year, yearProfits } = profitsDataLists

  // to create 2 arrays 
  const dataFromMetrices = {
    metrices: [],
    metricesData: []
  };

  businessMetricesData.forEach(item => {
    dataFromMetrices.metrices.push(item.metric);
    dataFromMetrices.metricesData.push(item.metricData);
  });

  // Object destructuring
  const { metrices, metricesData } = dataFromMetrices

  // to create 2 arrays 
  const revenueData = {
    revMonths: [],
    revData: []
  };

  monthlyRevenueData.forEach(item => {
    revenueData.revMonths.push(item.month);
    revenueData.revData.push(item.revenue);
  });

  // Object destructuring
  const { revMonths, revData } = revenueData

  // to create 2 arrays 
  const departmentsDataLists = {
    departments: [],
    numberOfEmployees: []
  };

  departmentsData.forEach(item => {
    departmentsDataLists.departments.push(item.department);
    departmentsDataLists.numberOfEmployees.push(item.numberOfEmployees);
  });

  // Object destructuring
  const { departments, numberOfEmployees } = departmentsDataLists

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
