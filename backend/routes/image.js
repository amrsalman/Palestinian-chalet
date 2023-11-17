const express = require("express");
const router = express.Router();
const { image } = require("../models");
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
const upload = multer({ storage: storage }).single("image_url");
router.use(verifyToken);
router
  .route("/image/:name")
  .get((req, res) => {
    image
      .findAll({
        where: { name: req.params.name },
      })
      .then((image) => res.json(image));
  })
  .delete(async (req, res) => {
    try {
      const imageName = req.params.name;

      // Find the image by name
      const foundImage = await image.findAll({
        where: { name: imageName },
      });

      if (!foundImage) {
        return res.status(404).json({ error: "Image not found" });
      }

      // Delete the image file from the storage
      // const imagePath = foundImage.image_url;
      // fs.unlinkSync(imagePath);

      // Delete the image from the database
      for (const img of foundImage) {
        await img.destroy();
      }

      res.json({ message: "Image deleted successfully" });
    } catch (error) {
      res.status(400).json({ error: error.message });
    }
  })
  .post(upload, async (req, res) => {
    try {
      // Check if a file is provided
      if (!req.file) {
        return res.status(400).json({ error: "No image file provided" });
      }

      // Additional logic to save the image information in your database
      const newImage = await image.create({
        name: req.params.name,
        image_url: req.file.path,
        // Add other relevant fields to your database model as needed
      });

      res.json({ message: "Image added successfully" });
    } catch (error) {
      res.status(400).json({ error: error.message });
    }
  });

module.exports = router;
