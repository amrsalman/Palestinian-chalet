const express = require("express");
const router = express.Router();
const { bookchalet } = require("../models");
router
  .route("/bookchalet")
  .get((req, res) => {
    bookchalet.findAll().then((bookchalet) => res.json(bookchalet));
  })
  .post((req, res) => {
    let body = req.body;
    user
      .create(body)
      .then((user) => res.json(user))
      .catch((e) => res.json(e.message));
  });
router.route("/bookchalet/:username/chales/:name").get((req, res) => {
  user
    .findAll({
      where: { username: req.params.username, name: req.params.name },
    })
    .then((res) => res.json(res));
});
module.exports = router;
