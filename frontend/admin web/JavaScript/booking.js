// Global variables to keep track of pagination
let allUsersData = []; // Declare and initialize the array with your user data
let currentPage = 1;
const usersPerPage = 10;
let totalUsers = 0;
let token; // Declare the token variable globally

function fetchAndDisplayBookings(token) {
  const startIndex = (currentPage - 1) * usersPerPage;
  const endIndex = startIndex + usersPerPage;
  fetch("http://localhost:8080/api/v1/bookchalet", {
    headers: {
      Authorization: ` ${token}`,
    },
  })
    .then((response) => response.json())
    .then((data) => {
      allUsersData = data;
      const tableBody = document.getElementById("tableBody");
      tableBody.innerHTML = "";
      totalUsers = data.length; // Update the total number of users
      const paginatedData = data.slice(startIndex, endIndex);
      paginatedData.forEach((booking, index) => {
        const row = document.createElement("tr");
        row.innerHTML = `
            <td>${startIndex + index + 1}</td>
            <td>${booking.usernamr}</td>
            <td>${booking.name}</td>
            <td>${booking.date}</td>
            <td>${booking.end}</td>
            <td>${booking.total_prise}</td>
          `;
        tableBody.appendChild(row);
      });
      // Generate pagination links dynamically
      generatePaginationLinks();
    })
    .catch((error) => console.error("Error:", error));
}

// Load booking data when the page loads (assuming you have the token stored in localStorage)
document.addEventListener("DOMContentLoaded", function () {
  token = localStorage.getItem("token"); // استرجاع التوكن من localStorage
  fetchAndDisplayBookings(token);
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

// Function to handle user search
function searchByUsername() {
  const searchInput = document
    .getElementById("searchInput")
    .value.toLowerCase();
  const filteredData = allUsersData.filter((booking) =>
    booking.usernamr.toLowerCase().includes(searchInput)
  );

  const tableBody = document.getElementById("tableBody");
  tableBody.innerHTML = ""; // Clear the current table data

  // If there are search results, update the table with the filtered data
  if (filteredData.length > 0) {
    filteredData.forEach((booking, index) => {
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
  } else {
    // If no search results, display a message or handle it as needed
    const noResultsRow = document.createElement("tr");
    noResultsRow.innerHTML = "<td colspan='11'>No results found</td>";
    tableBody.appendChild(noResultsRow);
  }
}

// Function to handle page change
function changePage(page) {
  currentPage = page;
  fetchAndDisplayBookings(token);
}
