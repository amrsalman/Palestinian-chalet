const express = require("express");
const bodyParser = require("body-parser");
const db = require("./config/database");
const userRoute = require("./routes/user");
const imageRoute = require("./routes/image");
const chalesRoute = require("./routes/chales");
const bookchaletRoute = require("./routes/bookchalet");
const app = express();
const path = require("path");
const port = process.env.PORT;

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "views"));
app.get("/", (req, res) => {
  res.send("hello");
});
app.use("/api/v1/", userRoute);
app.use("/api/v1/", imageRoute);
app.use("/api/v1/", chalesRoute);
app.use("/api/v1/", bookchaletRoute);

app.listen(port, () => console.log(`server running in port ${port}`));

async function c() {
  try {
    await db.authenticate();
    console.log("Connection has been established successfully.");
  } catch (error) {
    console.error("Unable to connect to the database:", error);
  }
}

c();
