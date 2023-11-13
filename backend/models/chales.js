const { Sequelize, DataTypes } = require("sequelize");
const sequelize = new Sequelize("sqlite::memory:");
module.exports = (db, type) => {
  return db.define(
    "chales",
    {
      name: {
        type: DataTypes.STRING,
        allowNull: false,
        primaryKey: true,
        validate: {
          is: ["^[a-z]+$", "i"],
          notNull: true,
          notEmpty: true,
        },
      },
      location: {
        type: DataTypes.STRING,
        allowNull: false,
        validate: {
          notNull: true,
          notEmpty: true,
        },
      },
      nomber_of_rome: {
        type: DataTypes.INTEGER,
        allowNull: false,
        validate: {
          isInt: true,
          notNull: true,
          notEmpty: true,
        },
      },
      prise: {
        type: DataTypes.INTEGER,
        allowNull: false,
        validate: {
          isInt: true,
          notNull: true,
          notEmpty: true,
        },
      },
      swimmingPool: {
        type: DataTypes.BOOLEAN,
        allowNull: false,
        validate: {
          notNull: true,
          notEmpty: true,
        },
      },
      gps: {
        type: DataTypes.GEOMETRY,
        allowNull: false,
        validate: {
          notNull: true,
          notEmpty: true,
        },
      },
      description: {
        type: DataTypes.TEXT("tiny"),
        allowNull: false,
        validate: {
          notNull: true,
          notEmpty: true,
        },
      },
      done: {
        type: DataTypes.BOOLEAN,
        allowNull: false,
        defaultValue: false,
        validate: {
          notNull: true,
          notEmpty: true,
        },
      },
      main_image: {
        type: DataTypes.STRING,
        allowNull: false,
        validate: {
          notNull: true,
          notEmpty: true,
        },
      },
      nameuser: {
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
    },
    { freezeTableName: true, timestamps: false }
  );
};
