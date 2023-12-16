// Function to get token from localStorage
function getToken() {
  return localStorage.getItem("token");
}

// Function to fetch chalet data and display in the table
function fetchAndDisplayChalets() {
  const token = getToken();
  if (!token) {
    console.error("Token not found");
    return;
  }

  fetch("http://localhost:8080/api/v1/chales", {
    headers: {
      Authorization: token,
    },
  })
    .then((response) => response.json())
    .then((data) => {
      const tableBody = document.getElementById("tableBody");
      tableBody.innerHTML = ""; // Clear the table body

      data.forEach((chale, index) => {
        const row = document.createElement("tr");
        row.innerHTML = `
            <td>${index + 1}</td>
            <td>${chale.name}</td>
            <td>${chale.location}</td>
            <td>${chale.nomber_of_rome}</td>
            <td>${chale.prise}</td>
            <td>${chale.swimmingPool}</td>
            <td><a href="https://www.google.com/maps?q=${
              chale.gps.coordinates[0]
            },${
          chale.gps.coordinates[1]
        }" target="_blank" class="map-link">View on Map</a></td>
            <td>${chale.description}</td>
            <td>${chale.nameuser}</td>
            <td><img src="${
              chale.main_image
            }" alt="Chale Image" width="40" height="40"></td>
            <td><button class="btn btn-danger" onclick="deleteChale('${
              chale.name
            }')">Delete</button></td>
          `;
        tableBody.appendChild(row);
      });
    })
    .catch((error) => console.error("Error:", error));
}

// Function to delete a chalet
function deleteChale(name) {
  const token = getToken();
  if (!token) {
    console.error("Token not found");
    return;
  }

  fetch(`http://localhost:8080/api/v1/chales/admin/delete/${name}`, {
    method: "DELETE",
    headers: {
      Authorization: token,
    },
  })
    .then((response) => response.json())
    .then((message) => {
      alert(message.message); // Show the delete success message
      fetchAndDisplayChalets(); // Refresh the table after deletion
    })
    .catch((error) => console.error("Error:", error));
}

// Load chalet data when the page loads
document.addEventListener("DOMContentLoaded", function () {
  fetchAndDisplayChalets();
});

function logout() {
  localStorage.removeItem("token");
  window.location.href = "login.html";
}
