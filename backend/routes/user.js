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
//

router.route("/user/reset-password").post(async (req, res) => {
  const { email } = req.body;

  // Check if the user with the provided email exists
  const existingUser = await user.findOne({
    where: { email: email },
  });

  if (!existingUser) {
    return res
      .status(404)
      .json({ error: "User not found with the provided email." });
  }

  // Generate a unique token for password reset
  const resetToken = crypto.randomBytes(32).toString("hex");

  // Save the token and user information in the database
  await verify.create({
    usarname: existingUser.username,
    crypto: resetToken,
  });

  // Construct the password reset link
  const resetLink = `http://localhost:8080/api/v1/user/reset-password/${existingUser.username}/${resetToken}`;

  // Create an HTML template for the email
  const htmlTemplate = `
    <div>
      <p>Click on the link below to reset your password</p>
      <a href="${resetLink}">Reset Password</a>
    </div>
  `;

  // Send the password reset email
  try {
    await sendEmail(existingUser.email, "Reset Your Password", htmlTemplate);
    res.json("We sent you an email with instructions to reset your password.");
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

router
  .route("/user/reset-password/:username/:resetToken")
  .get(async (req, res) => {
    const { username, resetToken } = req.params;

    // Check if the provided username and reset token match a record in the database
    const verificationRecord = await verify.findOne({
      where: { usarname: username, crypto: resetToken },
    });

    if (verificationRecord) {
      // If the verification record is found, render a password reset form
      res.render("PasswordReset", { username, resetToken });
    } else {
      res
        .status(404)
        .json({ error: "Invalid or expired password reset link." });
    }
  })
  .post(async (req, res) => {
    const { username, resetToken } = req.params;
    const { newPassword } = req.body;
    // Find the user by username
    const existingUser = await user.findOne({
      where: { username: username },
    });

    if (!existingUser) {
      return res.status(404).json({ error: "User not found." });
    }

    // Update the user's password
    existingUser.password = newPassword;
    await existingUser.save();

    // Remove the verification record from the database
    await verify.destroy({
      where: {
        usarname: username,
        crypto: resetToken,
      },
    });

    res.json(
      "Password reset successful. You can now log in with your new password."
    );
  });
module.exports = router;
