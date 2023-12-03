const express = require("express");
const router = express.Router();
const { favorite } = require("../models");
const verifyToken = require("../assets/jwtMiddleware");

router.use(verifyToken);

router
  .route("/favorites")
  .post(async (req, res) => {
    try {
      const { username, chales } = req.body;

      // Check if the favorite already exists
      const existingFavorite = await favorite.findOne({
        where: { username, chales },
      });

      if (existingFavorite) {
        return res.status(400).json({ error: "Favorite already exists" });
      }

      // Create a new favorite
      const newFavorite = await favorite.create({ username, chales });

      return res.status(201).json(newFavorite);
    } catch (error) {
      console.error(error);
      return res.status(500).json({ error: "Internal Server Error" });
    }
  })
  .delete(async (req, res) => {
    try {
      const { username, chales } = req.body;

      // Find and delete the favorite
      const deletedFavorite = await favorite.destroy({
        where: { username, chales },
      });

      if (!deletedFavorite) {
        return res.status(404).json({ error: "Favorite not found" });
      }

      return res.status(200).json({ message: "Favorite deleted successfully" });
    } catch (error) {
      console.error(error);
      return res.status(500).json({ error: "Internal Server Error" });
    }
  })
  .get(async (req, res) => {
    try {
      const { username } = req.body;

      // Find all favorites for the specified user
      const favorites = await favorite.findAll({
        where: { username },
      });

      return res.status(200).json(favorites);
    } catch (error) {
      console.error(error);
      return res.status(500).json({ error: "Internal Server Error" });
    }
  });

module.exports = router;
