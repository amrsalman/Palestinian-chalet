function fetchAndDisplayBookings(token) {
  fetch("http://localhost:8080/api/v1/bookchalet", {
    headers: {
      Authorization: ` ${token}`,
    },
  })
    .then((response) => response.json())
    .then((data) => {
      const tableBody = document.getElementById("tableBody");
      tableBody.innerHTML = "";

      data.forEach((booking, index) => {
        const row = document.createElement("tr");
        row.innerHTML = `
            <td>${index + 1}</td>
            <td>${booking.usernamr}</td>
            <td>${booking.name}</td>
            <td>${booking.date}</td>
            <td>${booking.end}</td>
            <td>${booking.total_prise}</td>
          `;
        tableBody.appendChild(row);
      });
    })
    .catch((error) => console.error("Error:", error));
}

// Load booking data when the page loads (assuming you have the token stored in localStorage)
document.addEventListener("DOMContentLoaded", function () {
  const token = localStorage.getItem("token"); // استرجاع التوكن من localStorage
  fetchAndDisplayBookings(token);
});

function logout() {
  localStorage.removeItem("token");
  window.location.href = "login.html";
}
