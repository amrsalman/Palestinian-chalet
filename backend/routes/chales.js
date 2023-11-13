const express = require("express");
const router = express.Router();
const { chales } = require("../models");
const multer = require("multer");
const path = require("path");
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "assets/images");
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + path.extname(file.originalname));
  },
});
const upload = multer({ storage: storage }).single("main_image");

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
module.exports = router;
