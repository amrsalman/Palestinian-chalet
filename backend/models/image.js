const { Sequelize, DataTypes } = require("sequelize");
const sequelize = new Sequelize("sqlite::memory:");
module.exports = (db, type) => {
  return db.define(
    "image",
    {
      id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        validate: {
          notNull: true,
          notEmpty: true,
        },
      },
      name: {
        type: DataTypes.STRING,
        references: {
          model: "chales",
          key: "name",
        },
        allowNull: false,
        validate: {
          is: ["^[a-z]+$", "i"],
          notNull: true,
          notEmpty: true,
        },
      },
      image_url: {
        type: DataTypes.STRING,
        allowNull: false,
        validate: {
          notNull: true,
          notEmpty: true,
        },
      },
    },
    { freezeTableName: true, timestamps: false }
  );
};
