const { notifications, message } = require("./models");
const http = require("http");
const serveHandler = require("serve-handler");
const WebSocket = require("ws");
const WebSocketServer = WebSocket.Server;
const notifier = require("node-notifier");
const db = require("./config/database");
const { Op } = require("sequelize");
// Serve static folder
const server = http.createServer((req, res) => {
  return serveHandler(req, res, { public: "public" });
});

const io = new WebSocketServer({ server });
const clients = new Map();
const xu = new Map();

/*io.on("connection", (client) => {
  console.log("Client connected !");
  client.on("message", (msg) => {
    console.log(`Message:${msg}`);
    broadcast(msg);
  });
});*/

io.on("connection", (socket, req) => {
  // Extracting username from URL query parameters
  const user = new URL(req.url, "http://fakehost").searchParams.get("user");
  const sender = new URL(req.url, "http://fakehost").searchParams.get("sender");
  const receiver = new URL(req.url, "http://fakehost").searchParams.get(
    "receiver"
  );
  console.log("sender: ", sender);
  console.log("resever: ", receiver);
  if (sender && receiver) {
    // Fetch existing messages from the database for the given sender and receiver
    // Use your Sequelize model (Message) to query the database
    message
      .findAll({
        where: {
          [Op.or]: [
            {
              sender: sender,
              receiver: receiver,
            },
            {
              sender: receiver,
              receiver: sender,
            },
          ],
        },
        order: [["sentAt", "ASC"]], // Adjust the order as needed
      })
      .then((existingMessages) => {
        // Send existing messages to the connected client
        socket.send(JSON.stringify(existingMessages));
      })
      .catch((error) => {
        console.error("Error fetching existing messages:", error);
      });

    clients.set(sender, socket);
    socket.on("message", (msg) => {
      console.log(`Message from ${sender} to ${receiver}: ${msg}`);
      sendMessage(sender, receiver, msg);
    });
  }
  if (user) {
    xu.set(user, socket);
    console.log("You have logged in to your account");
    socket.send("You have logged in to your account");
  }
});

function broadcast(msg) {
  for (const client of io.clients) {
    if (client.readyState === WebSocket.OPEN) {
      client.send(msg);
    }
  }
}

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
  const user = receiver;
  sendNotificationrealtaim(user, message);
}

async function sendNotificationrealtaim(user, message) {
  const senderSocket = xu.get(user);
  if (senderSocket && senderSocket.readyState === WebSocket.OPEN) {
    senderSocket.send(`${message}`);
  }
}

async function sendMessage(sender, receiver, msg) {
  const recipientSocket = clients.get(receiver);
  // Save the message to the database
  try {
    const newMessage = await message.create({
      sender: sender,
      receiver: receiver,
      content: msg,
    });
    const hestory = await message.findAll({
      where: {
        [Op.or]: [
          {
            sender: sender,
            receiver: receiver,
          },
          {
            sender: receiver,
            receiver: sender,
          },
        ],
      },
      order: [["sentAt", "ASC"]], // Adjust the order as needed
    });
    if (recipientSocket && recipientSocket.readyState === WebSocket.OPEN) {
      recipientSocket.send(JSON.stringify(hestory));
    } else {
      console.log(`Recipient ${receiver} is not connected or not available.`);
      sendNotification(`Message from ${sender}: ${msg}`, receiver);
    }
  } catch (error) {
    console.error("Error saving message to the database:", error);
  }
}

server.listen(8081, () => {
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

module.exports.sendNotificationrealtaim = sendNotificationrealtaim;
