// Global variables to keep track of pagination
let allUsersData = []; // Declare and initialize the array with your user data
let currentPage = 1;
const usersPerPage = 10;
let totalUsers = 0;
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
  const startIndex = (currentPage - 1) * usersPerPage;
  const endIndex = startIndex + usersPerPage;
  fetch("http://localhost:8080/api/v1/chales", {
    headers: {
      Authorization: token,
    },
  })
    .then((response) => response.json())
    .then((data) => {
      allUsersData = data;
      const tableBody = document.getElementById("tableBody");
      tableBody.innerHTML = ""; // Clear the table body
      totalUsers = data.length; // Update the total number of users
      const paginatedData = data.slice(startIndex, endIndex);
      paginatedData.forEach((chale, index) => {
        const row = document.createElement("tr");
        row.innerHTML = `
            <td>${startIndex + index + 1}</td>
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
      // Generate pagination links dynamically
      generatePaginationLinks();
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

// Function to generate pagination links dynamically
function generatePaginationLinks() {
  const totalPages = Math.ceil(totalUsers / usersPerPage);
  const paginationElement = document.querySelector(".pagination ul");
  paginationElement.innerHTML = ""; // Clear existing pagination links

  for (let i = 1; i <= totalPages; i++) {
    const li = document.createElement("li");
    li.classList.add("page-item");

    const a = document.createElement("a");
    a.href = "#";
    a.textContent = i;
    a.classList.add("page-link");
    a.onclick = function () {
      changePage(i);
    };

    li.appendChild(a);
    paginationElement.appendChild(li);
  }
}

// Function to handle page change
function changePage(page) {
  currentPage = page;
  fetchAndDisplayChalets();
}

// Function to handle user search
function searchByUsername() {
  const searchInput = document
    .getElementById("searchInput")
    .value.toLowerCase();
  const filteredData = allUsersData.filter((chale) =>
    chale.name.toLowerCase().includes(searchInput)
  );

  const tableBody = document.getElementById("tableBody");
  tableBody.innerHTML = ""; // Clear the current table data

  // If there are search results, update the table with the filtered data
  if (filteredData.length > 0) {
    filteredData.forEach((chale, index) => {
      const row = document.createElement("tr");
      row.innerHTML = `
      <td>${index + 1}</td>
      <td>${chale.name}</td>
      <td>${chale.location}</td>
      <td>${chale.nomber_of_rome}</td>
      <td>${chale.prise}</td>
      <td>${chale.swimmingPool}</td>
      <td><a href="https://www.google.com/maps?q=${chale.gps.coordinates[0]},${
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
  } else {
    // If no search results, display a message or handle it as needed
    const noResultsRow = document.createElement("tr");
    noResultsRow.innerHTML = "<td colspan='11'>No results found</td>";
    tableBody.appendChild(noResultsRow);
  }
}
