const dotenv = require("dotenv");
dotenv.config();

module.exports = {
  username: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  dialect: process.env.DIALECT,
  database: process.env.DB_DATABASE,
  host: process.env.DB_HOST,
};
