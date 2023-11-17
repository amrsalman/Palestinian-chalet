const jwt = require("jsonwebtoken");

function verifyToken(req, res, next) {
  // Get the token from the request headers
  const token = req.headers.authorization;

  if (!token) {
    return res.status(401).json({ message: "Unauthorized: Missing token" });
  }

  // Verify the token
  jwt.verify(token, process.env.JWT_SECRET_KEY, (err, decoded) => {
    if (err) {
      return res.status(401).json({ message: "Unauthorized: Invalid token" });
    }

    // Attach the decoded payload to the request object for further use
    req.user = decoded;

    // Call the next middleware or route handler
    next();
  });
}

module.exports = verifyToken;
