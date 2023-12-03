const { Sequelize, DataTypes } = require("sequelize");
const sequelize = new Sequelize("sqlite::memory:");
module.exports = (db, type) => {
  return db.define(
    "favorite",
    {
      idfavorite: {
        type: DataTypes.INTEGER,
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        validate: {
          notNull: true,
          notEmpty: true,
        },
      },
      username: {
        type: DataTypes.STRING,
        references: {
          model: "user",
          key: "nameuser",
        },
        allowNull: false,
        foreignKey: true,
        validate: {
          is: ["^[a-z]+$", "i"],
          notNull: true,
          notEmpty: true,
        },
      },
      chales: {
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
    },
    { freezeTableName: true, timestamps: false }
  );
};
