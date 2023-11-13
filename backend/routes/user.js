const express = require("express");
const jwt = require("jsonwebtoken");
const router = express.Router();
const { user, verify } = require("../models");
const crypto = require("crypto");
const sendEmail = require("../assets/sendEmail");
router
  .route("/user")
  .get((req, res) => {
    async function x() {
      return await user.findAll({
        where: { level: 0 },
      });
    }
    (async () => {
      res.json(await x());
    })();
  })
  .post(async (req, res) => {
    let body = {
      username: req.body.username,
      email: req.body.email,
      phone: req.body.phone,
      fname: req.body.fname,
      lname: req.body.lname,
      living: req.body.living,
      password: req.body.password,
      IBNA: req.body.IBNA,
      date_of_birth: req.body.date_of_birth,
    };
    let Verify = crypto.randomBytes(32).toString("hex");
    let link = `http://localhost:8080/api/v1/user/Verify/${body.username}/client/${Verify}`;
    const htmlTemplate = `
    <div>
    <p> Click on the link below to verify email</p>
    <a href="${link}">Verify</a>
    </div>`;
    await user.create(body);
    let x = {
      usarname: body.username,
      crypto: Verify,
    };
    await verify.create(x);
    await sendEmail(body.email, "Verify Your Email", htmlTemplate)
      .then((user) =>
        res.json("We sent to you an email, please verify your email addres")
      )
      .catch((e) => res.send(e));
  });
router
  .route("/user/:username")
  .get((req, res) => {
    user
      .findOne({
        where: { username: req.params.username },
      })
      .then((user) => res.json(user));
  })
  .delete((req, res) => {
    user
      .destroy({
        where: {
          username: req.params.username,
        },
      })
      .then((user) => res.json("delete Succefully"))
      .catch((e) => res.send(e));
  })
  .patch((req, res) => {
    let body = req.body;
    user
      .update(body, {
        where: {
          username: req.params.username,
        },
      })
      .then((user) => res.send("update Succefully"))
      .catch((e) => res.send(e.errors[0].message));
  });
router.route("/user/login/client").post((req, res) => {
  let { username, password } = req.body;
  user
    .findOne({
      where: {
        username: username,
        password: password,
        level: 0,
        verification: true,
      },
    })
    .then((user) => {
      if (!user) {
        res.status(404).send("User not found or invalid credentials.");
      } else {
        const token = jwt.sign({ user: username }, process.env.JWT_SECRET_KEY, {
          expiresIn: "1h",
        });
        res.send({ user, token });
      }
    });
});

router.route("/user/login/admin").post((req, res) => {
  let { username, password } = req.body;
  user
    .findOne({
      where: {
        username: username,
        password: password,
        level: 1,
        verification: true,
      },
    })
    .then((user) => {
      if (!user) {
        res.status(404).send("Admin not found or invalid credentials.");
      } else {
        const token = jwt.sign({ user: username }, process.env.JWT_SECRET_KEY, {
          expiresIn: "1h",
        });
        res.send({ user, token });
      }
    });
});

router.route("/user/get/admin").get((req, res) => {
  user
    .findAll({
      where: {
        level: 1,
      },
    })
    .then((user) => res.send(user));
});
router.route("/user/signup/admin").post(async (req, res) => {
  let body = {
    username: req.body.username,
    email: req.body.email,
    phone: req.body.phone,
    fname: req.body.fname,
    lname: req.body.lname,
    living: req.body.living,
    password: req.body.password,
    IBNA: req.body.IBNA,
    date_of_birth: req.body.date_of_birth,
    level: 1,
  };
  let Verify = crypto.randomBytes(32).toString("hex");
  let link = `http://localhost:8080/api/v1/user/Verify/${body.username}/client/${Verify}`;
  const htmlTemplate = `
    <div>
    <p> Click on the link below to verify email</p>
    <a href="${link}">Verify</a>
    </div>`;
  await user.create(body);
  let x = {
    usarname: body.username,
    crypto: Verify,
  };
  await verify.create(x);
  await sendEmail(body.email, "Verify Your Email", htmlTemplate)
    .then((user) =>
      res.json("We sent to you an email, please verify your email addres")
    )
    .catch((e) => res.send(e));
});
router.route("/user/Verify/:username/client/:Verify").get((req, res) => {
  verify
    .findOne({
      where: { usarname: req.params.username, crypto: req.params.Verify },
    })
    .then((verificationRecord) => {
      if (verificationRecord) {
        user
          .update(
            { verification: true },
            { where: { username: req.params.username } }
          )
          .then(() => {
            res.send("User verified successfully.");
            verify.destroy({
              where: {
                usarname: req.params.username,
              },
            });
          })
          .catch((error) => {
            res.status(500).send("Internal Server Error");
          });
      } else {
        res.status(404).send("Verification record not found.");
      }
    })
    .catch((error) => {
      res.status(500).send("Internal Server Error");
    });
});

module.exports = router;
