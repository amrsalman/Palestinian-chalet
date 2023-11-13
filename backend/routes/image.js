const express = require("express");
const router = express.Router();
const { image } = require("../models");
router
  .route("/image/:name")
  .get((req, res) => {
    image
      .findAll({
        where: { name: req.params.name },
      })
      .then((image) => res.json(image));
  })
  .post((req, res) => {
    let body = req.body;
    image
      .create(body)
      .then((image) => res.json(image))
      .catch((e) => res.json(e.message));
  });

module.exports = router;
