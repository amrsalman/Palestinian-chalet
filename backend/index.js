const express = require("express");
const bodyParser = require("body-parser");
const db = require("./config/database");
const userRoute = require("./routes/user");
const imageRoute = require("./routes/image");
const chalesRoute = require("./routes/chales");
const bookchaletRoute = require("./routes/bookchalet");
const favoriteRoute = require("./routes/favorite");
const http = require("http");
const { Server } = require("socket.io");
const app = express();
const server = http.createServer(app);
const io = new Server(server);
const path = require("path");
const port = process.env.PORT;

const cors = require("cors");
const { addUserSocket, notifyUser, removeUserSocket } = require("./socket");
app.use(cors());
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
app.use("/api/v1/", favoriteRoute);
io.on("connection", (socket) => {
  console.log("A user connected");
  socket.on("login", (data) => {
    addUserSocket(data, socket);
    notifyUser(data, "test notify");
  });
  socket.on("disconnect", () => {
    console.log("User disconnected");
    removeUserSocket(socket);
  });
});
server.listen(port, "0.0.0.0", () =>
  console.log(" Server ready at: http://localhost " + port)
);

async function c() {
  try {
    await db.authenticate();
    console.log("Connection has been established successfully.");
  } catch (error) {
    console.error("Unable to connect to the database:", error);
  }
}

c();
