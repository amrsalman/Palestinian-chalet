const userSocketMap = {};

const addUserSocket = (userId, socket) => {
  userSocketMap[userId] = socket;
};

const removeUserSocket = (socket) => {
  const userId = Object.keys(userSocketMap).find(
    (key) => userSocketMap[key] === socket
  );
  if (userId) {
    delete userSocketMap[userId];
  }
};
const doesUserExist = (userId) => {
  return userSocketMap.hasOwnProperty(userId);
};
const getUserSocket = (userId) => userSocketMap[userId];
const notifyUser = (userId, data) => {
  if (doesUserExist(userId)) {
    userSocketMap[userId].emit("Notification", data);
  }
};

module.exports = {
  addUserSocket,
  removeUserSocket,
  getUserSocket,
  doesUserExist,
  notifyUser,
};
