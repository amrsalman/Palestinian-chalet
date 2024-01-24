const { notifications } = require("./models");
const http = require("http");
const serveHandler = require("serve-handler");
const WebSocket = require("ws");
const WebSocketServer = WebSocket.Server;
const notifier = require("node-notifier");
const db = require("./config/database");
// Serve static folder
const server = http.createServer((req, res) => {
  return serveHandler(req, res, { public: "public" });
});

const io = new WebSocketServer({ server });
const clients = new Map();

io.on("connection", (client, req) => {
  const user = new URL(req.url, "http://fakehost").searchParams.get("user");
  console.log("Client connected !");
  console.log("user: ", user);

  client.on("notification", (not) => {
    console.log(`notification:${not}`);
    sendNotification(not, user);
  });
});

async function sendNotification(message, receiver) {
  notifier.notify({
    title: "Message Notification",
    message: message,
    user: receiver,
  });

  try {
    // Save the notification to the database
    const newNotification = await notifications.create({
      title: "Notification Message",
      message: message,
      user: receiver,
    });
  } catch (error) {
    console.error("Error saving notification:", error);
  }
}

server.listen(8082, () => {
  console.log(`server listening...`);
});
async function c() {
  try {
    await db.authenticate();
    console.log("Connection has been established successfully.");
  } catch (error) {
    console.error("Unable to connect to the database:", error);
  }
}

c();
