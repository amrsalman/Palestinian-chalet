const { Sequelize, DataTypes } = require("sequelize");
const sequelize = new Sequelize("sqlite::memory:");
module.exports = (db, type) => {
  return db.define(
    "verify",
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
      usarname: {
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
      crypto: {
        type: DataTypes.STRING,
        allowNull: false,
      },
    },
    { freezeTableName: true, timestamps: false }
  );
};
