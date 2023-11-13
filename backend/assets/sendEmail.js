const nodemailer = require("nodemailer");
module.exports = async (userEmail, subject, htmlTemplate) => {
  var transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: process.env.EMAIL,
      pass: process.env.PASS_EMAIL,
    },
  });

  var mailOptions = {
    from: "amrsalman758@gmail.com",
    to: userEmail,
    subject: subject,
    html: htmlTemplate,
  };

  transporter.sendMail(mailOptions, function (error, info) {
    if (error) {
      console.log(error);
    } else {
      console.log("Email sent: " + info.response);
    }
  });
};
