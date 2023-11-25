const { Sequelize, DataTypes } = require("sequelize");
const sequelize = new Sequelize("sqlite::memory:");
module.exports = (db, type) => {
  return db.define(
    "bookchalet",
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
      usernamr: {
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
      name: {
        type: DataTypes.STRING,
        references: {
          model: "chales",
          key: "name",
        },
        allowNull: false,
        foreignKey: true,
        validate: {
          is: ["^[a-z]+$", "i"],
          notNull: true,
          notEmpty: true,
        },
      },
      date: {
        type: DataTypes.DATE,
        allowNull: false,
        validate: {
          notNull: true,
          notEmpty: true,
        },
      },
      done: {
        type: DataTypes.BOOLEAN,
        allowNull: false,
        validate: {
          notNull: true,
          notEmpty: true,
        },
      },
      end: {
        type: DataTypes.DATE,
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
