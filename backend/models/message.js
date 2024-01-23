const { Sequelize, DataTypes } = require("sequelize");
const sequelize = new Sequelize("sqlite::memory:");
module.exports = (db, type) => {
  return db.define(
    "message",
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
      sender: {
        type: DataTypes.STRING,
        references: {
          model: "user",
          key: "username",
        },
        allowNull: false,
        validate: {
          is: ["^[a-z]+$", "i"],
          notNull: true,
          notEmpty: true,
        },
      },
      receiver: {
        type: DataTypes.STRING,
        references: {
          model: "user",
          key: "username",
        },
        allowNull: false,
        validate: {
          is: ["^[a-z]+$", "i"],
          notNull: true,
          notEmpty: true,
        },
      },
      content: {
        type: DataTypes.TEXT("tiny"),
        allowNull: false,
        validate: {
          notNull: true,
          notEmpty: true,
        },
      },
      sentAt: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
      },
    },
    { freezeTableName: true, timestamps: false }
  );
};
