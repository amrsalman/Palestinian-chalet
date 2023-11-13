const db = require("../config/database");
const Sequelize = require("sequelize");
const userModel = require("./user");
const imageModel = require("./image");
const chalesModel = require("./chales");
const bookchaletModel = require("./bookchalet");
const verifyModel = require("./verify");
const user = userModel(db, Sequelize);
const image = imageModel(db, Sequelize);
const chales = chalesModel(db, Sequelize);
const bookchalet = bookchaletModel(db, Sequelize);
const verify = verifyModel(db, Sequelize);
db.sync({ force: false }).then(() => {
  console.log("Tables Created");
});
module.exports = {
  user,
  image,
  chales,
  bookchalet,
  verify,
};
