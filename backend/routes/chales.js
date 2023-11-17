const express = require("express");
const router = express.Router();
const { chales } = require("../models");
const multer = require("multer");
const path = require("path");
const verifyToken = require("../assets/jwtMiddleware");
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "assets/images");
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + path.extname(file.originalname));
  },
});
const upload = multer({ storage: storage }).single("main_image");
router.use(verifyToken);
router
  .route("/chales")
  .get((req, res) => {
    chales
      .findAll({ where: { done: true } })
      .then((chales) => res.json(chales));
  })
  .post(upload, async (req, res) => {
    try {
      const newChale = await chales.create({
        name: req.body.name,
        location: req.body.location,
        nomber_of_rome: req.body.nomber_of_rome,
        prise: req.body.prise,
        swimmingPool: req.body.swimmingPool,
        nameuser: req.body.nameuser,
        description: req.body.description,
        gps: {
          type: "Point",
          coordinates: [req.body.longitude, req.body.latitude], // Modify this according to your payload
        },
        main_image: req.file.path,
      });
      res.status(201).json(newChale);
    } catch (error) {
      res.status(400).json({ error: error.message });
    }
  });

router.route("/chales/:name").get((req, res) => {
  chales
    .findAll({
      where: { name: req.params.name },
    })
    .then((chales) => res.json(chales));
});
router.route("/chales/location/:location").get((req, res) => {
  chales
    .findAll({
      where: { location: req.params.location },
    })
    .then((chales) => res.json(chales));
});
router.route("/chales/user/:username").get((req, res) => {
  chales
    .findAll({
      where: { nameuser: req.params.username },
    })
    .then((chales) => res.json(chales));
});
router.route("/chales/admen/todo").get((req, res) => {
  chales.findAll({ where: { done: false } }).then((chales) => res.json(chales));
});
// New route to agree to add chales
router.route("/chales/agree/:name").patch(async (req, res) => {
  try {
    const chaleId = req.params.name;

    // Find the chale by ID
    const chale = await chales.findByPk(chaleId);

    if (!chale) {
      return res.status(404).json({ error: "Chale not found" });
    }

    // Update the 'done' field to true (assuming 'done' is a boolean field)
    chale.done = true;

    // Save the updated chale
    await chale.save();

    res.json({ message: "Chale agreed to be added successfully" });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});
// New route to delete a chale by ID
router.route("/chales/delete/:id/nameuser/:user").delete(async (req, res) => {
  try {
    const chaleId = req.params.id;
    const user = req.params.user;

    // Find the chale by ID
    const chale = await chales.findByPk(chaleId);

    if (!chale) {
      return res.status(404).json({ error: "Chale not found" });
    }

    // Check if the authenticated user is the owner of the chale
    if (chale.nameuser !== user) {
      return res
        .status(403)
        .json({ error: "You do not have permission to delete this chale" });
    }

    // Delete the chale
    await chale.destroy();

    res.json({ message: "Chale deleted successfully" });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});
// New route to edit a chale by ID
router
  .route("/chales/edit/:id/nameuser/:user")
  .patch(upload, async (req, res) => {
    try {
      const chaleId = req.params.id;
      const user = req.params.user;
      // Find the chale by ID
      const chale = await chales.findByPk(chaleId);

      if (!chale) {
        return res.status(404).json({ error: "Chale not found" });
      }

      // Check if the authenticated user is the owner of the chale
      if (chale.nameuser !== user) {
        return res
          .status(403)
          .json({ error: "You do not have permission to edit this chale" });
      }

      // Update chale information
      chale.name = req.body.name || chale.name;
      chale.location = req.body.location || chale.location;
      chale.nomber_of_rome = req.body.nomber_of_rome || chale.nomber_of_rome;
      chale.prise = req.body.prise || chale.prise;
      chale.swimmingPool = req.body.swimmingPool || chale.swimmingPool;
      chale.nameuser = req.body.nameuser || chale.nameuser;
      chale.description = req.body.description || chale.description;

      // Update GPS coordinates if provided
      if (req.body.longitude && req.body.latitude) {
        chale.gps = {
          type: "Point",
          coordinates: [req.body.longitude, req.body.latitude],
        };
      }

      // Update main image if provided
      if (req.file) {
        chale.main_image = req.file.path;
      }

      // Save the updated chale
      await chale.save();

      res.json({ message: "Chale edited successfully", chale });
    } catch (error) {
      res.status(400).json({ error: error.message });
    }
  });
// New route to delete a chale by ID (admin only)
router.route("/chales/admin/delete/:id").delete(async (req, res) => {
  try {
    const chaleId = req.params.id;

    // Find the chale by ID
    const chale = await chales.findByPk(chaleId);

    if (!chale) {
      return res.status(404).json({ error: "Chale not found" });
    }

    // Delete the chale
    await chale.destroy();

    res.json({ message: "Chale deleted successfully" });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

module.exports = router;
