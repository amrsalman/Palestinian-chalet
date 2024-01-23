const express = require("express");
const router = express.Router();
const { notifications } = require("../models");

router.route("/notifications/:username").get(async (req, res) => {
  try {
    const notificationsList = await notifications.findAll({
      where: {
        user: req.params.username,
      },
      order: [
        ["id", "DESC"], // Order by id field in ascending order
      ],
    });

    res.status(200).json(notificationsList);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

router.route("/notifications/delete/:id").delete(async (req, res) => {
  try {
    const notificationId = req.params.id;

    // Find the notification by ID
    const notification = await notifications.findByPk(notificationId);

    if (!notification) {
      return res.status(404).json({ error: "Notification not found" });
    }

    // Delete the notification
    await notification.destroy();

    res.status(200).json({ message: "Notification deleted successfully" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

module.exports = router;
