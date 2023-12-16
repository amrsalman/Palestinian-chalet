document
  .getElementById("loginForm")
  .addEventListener("submit", function (event) {
    event.preventDefault();
    const username = document.getElementById("username").value;
    const password = document.getElementById("password").value;

    // Create an object with the form data
    const formData = {
      username: username,
      password: password,
    };

    // Send a POST request to the backend route
    fetch("http://localhost:8080/api/v1/user/login/admin", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(formData),
    })
      .then((response) => {
        if (!response.ok) {
          throw new Error("Admin not found or invalid credentials.");
        }
        return response.json();
      })
      .then((data) => {
        // Handle the response data or perform actions upon successful login
        const token = data.token; // Assuming the token is returned in the response
        // You can save the token to local storage or handle it accordingly
        localStorage.setItem("token", token); // Store token in local storage
        // Redirect to another page or perform actions for logged-in admin
        window.location.href = "main.html";
      })
      .catch((error) => {
        // Handle errors or display error messages
        document.getElementById("loginMessage").innerText = error.message;
        console.error("Error:", error);
      });
  });
