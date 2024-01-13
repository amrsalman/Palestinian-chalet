const express = require("express");
const router = express.Router();
const { bookchalet, chales } = require("../models");
const verifyToken = require("../assets/jwtMiddleware");
const { Sequelize } = require("sequelize");
const dayjs = require("dayjs");
router.use(verifyToken);

router
  .route("/bookchalet")
  .get((req, res) => {
    bookchalet.findAll().then((bookchalet) => res.json(bookchalet));
  })
  .post(async (req, res) => {
    try {
      const { username, name, date, end } = req.body;

      // Check if the chalet is already booked in the specified period
      const existingBooking = await bookchalet.findOne({
        where: {
          name: name,
          [Sequelize.Op.or]: [
            {
              date: {
                [Sequelize.Op.between]: [date, end],
              },
            },
            {
              end: {
                [Sequelize.Op.between]: [date, end],
              },
            },
          ],
        },
      });

      if (existingBooking) {
        return res
          .status(400)
          .json({ error: "Chalet is already booked for the specified period" });
      }
      const startDate = dayjs(date);
      const endDate = dayjs(end);
      const numberOfDays = endDate.diff(startDate, "day") + 1;
      const chalet = await chales.findOne({
        where: {
          name: name,
        },
      });

      if (!chalet) {
        return res.status(404).json({ error: "Chalet not found" });
      }

      const chaletPrice = chalet.prise;
      const total_prise = numberOfDays * parseFloat(chaletPrice);
      // Create a new booking
      const booking = await bookchalet.create({
        usernamr: username,
        name: name,
        date: date,
        end: end,
        done: false,
        total_prise: total_prise,
      });

      res.status(201).json(booking);
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: "Internal Server Error" });
    }
  });

router.route("/SearchByDate").post(async (req, res) => {
  try {
    const { startDate, endDate } = req.body;

    // Validate the date format
    if (!isValidDate(startDate) || !isValidDate(endDate)) {
      return res
        .status(400)
        .json({ error: "Invalid date format. Use ISO format (YYYY-MM-DD)." });
    }

    const bookedChalets = await bookchalet.findAll({
      where: {
        [Sequelize.Op.not]: {
          [Sequelize.Op.or]: [
            { date: { [Sequelize.Op.between]: [startDate, endDate] } },
            { end: { [Sequelize.Op.between]: [startDate, endDate] } },
          ],
        },
      },
    });
    x = bookedChalets.map((booking) => booking.dataValues.name);
    const chal = await chales.findAll({
      where: {
        name: x,
      },
    });
    res.status(200).json(chal);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
});
//user
router.route("/BookingChales/:username").get(async (req, res) => {
  try {
    const mybookedChalets = await bookchalet.findAll({
      where: {
        usernamr: req.params.username,
      },
    });
    if (mybookedChalets.length === 0) {
      // Handle the case where no booked chalets are found for the given username
      return res
        .status(404)
        .json({ error: "No booked chalets found for the given username." });
    }

    // جمع جميع أسماء الشاليهات المحجوزة
    const bookedChaletNames = mybookedChalets.map((booking) => booking.name);

    // استعلام للحصول على معلومات الشاليهات المحجوزة
    const chaletsInfo = await chales.findAll({
      where: {
        name: bookedChaletNames,
      },
      attributes: [
        "name",
        "location",
        "prise",
        "main_image",
        "gps",
        "nameuser",
      ],
    });

    // تنسيق النتائج
    const formattedResults = mybookedChalets.map((booking) => {
      const chaletInfo = chaletsInfo.find(
        (chalet) => chalet.name === booking.name
      );

      return {
        date: booking.date,
        total_prise: booking.total_prise,
        chalet: {
          name: chaletInfo.name,
          location: chaletInfo.location,
          prise: chaletInfo.prise,
          main_image: chaletInfo.main_image,
          gps: chaletInfo.gps,
          owner: chaletInfo.nameuser,
        },
      };
    });

    res.status(200).json(formattedResults);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

// Helper function to validate date format
function isValidDate(dateString) {
  const regex = /^\d{4}-\d{2}-\d{2}$/;
  return regex.test(dateString);
}
// Owner of the chalet
router.route("/expectAcceptance/:username").get(async (req, res) => {
  try {
    const myunstableChalets = await chales.findAll({
      where: {
        nameuser: req.params.username,
      },
    });
    x = myunstableChalets.map((booking) => booking.dataValues.name);
    const unstableChalets = await bookchalet.findAll({
      where: {
        done: false,
        name: x,
      },
    });
    res.status(200).json(unstableChalets);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
});
router.route("/Reservations/:username").get(async (req, res) => {
  try {
    const myunstableChalets = await chales.findAll({
      where: {
        nameuser: req.params.username,
      },
    });
    x = myunstableChalets.map((booking) => booking.dataValues.name);
    const unstableChalets = await bookchalet.findAll({
      where: {
        done: true,
        name: x,
      },
    });
    res.status(200).json(unstableChalets);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
});
router
  .route("/book/agreeBooking/:id")
  .patch(async (req, res) => {
    try {
      const id = req.params.id;
      const brook = await bookchalet.findByPk(id);

      if (!brook) {
        return res.status(404).json({ error: "Booking not found" });
      }

      // Assuming 'done' is a boolean field in your model
      brook.done = true;

      // Save the updated booking
      await brook.save();

      res.status(200).json({ message: "Your reservation has been approved" });
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: "Internal Server Error" });
    }
  })
  .delete(async (req, res) => {
    try {
      const id = req.params.id;
      const brook = await bookchalet.findByPk(id);

      if (!brook) {
        return res.status(404).json({ error: "Booking not found" });
      }

      // Assuming 'done' is a boolean field in your model
      // Optionally, you may want to check if the booking is already approved before deleting
      if (brook.done) {
        return res
          .status(400)
          .json({ error: "Cannot delete an approved booking" });
      }

      // Delete the booking
      await brook.destroy();

      res.status(200).json({ message: "Your reservation has been canceled" });
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: "Internal Server Error" });
    }
  });

module.exports = router;
