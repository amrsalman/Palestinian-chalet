// password.js

document.addEventListener("DOMContentLoaded", function () {
  const passwordForm = document.getElementById("passwordForm");

  passwordForm.addEventListener("submit", function (event) {
    event.preventDefault(); // Prevent the default form submission

    // Fetch the email input value
    const email = document.getElementById("email").value;

    // Make a POST request to your server endpoint
    fetch("http://localhost:8080/api/v1/user/reset-password", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        email: email,
      }),
    })
      .then((response) => response.json())
      .then((data) => {
        // Handle the response from the server
        console.log(data); // You can customize this based on your requirements

        // Optionally, you can display a success message to the user
        alert("Password reset link sent successfully!");
      })
      .catch((error) => {
        console.error("Error:", error);
        // Handle the error, e.g., display an error message to the user
        alert("Error sending password reset link. Please try again later.");
      });
  });
});
