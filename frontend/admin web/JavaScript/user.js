// Global variables to keep track of pagination
let allUsersData = []; // Declare and initialize the array with your user data
let currentPage = 1;
const usersPerPage = 10;
let totalUsers = 0;
// Function to refresh table data
function refreshTableData() {
  const startIndex = (currentPage - 1) * usersPerPage;
  const endIndex = startIndex + usersPerPage;

  fetch("http://localhost:8080/api/v1/all")
    .then((response) => response.json())
    .then((data) => {
      allUsersData = data;
      const tableBody = document.getElementById("tableBody");
      tableBody.innerHTML = ""; // Clear the current table data
      totalUsers = data.length; // Update the total number of users
      const paginatedData = data.slice(startIndex, endIndex);
      paginatedData.forEach((user, index) => {
        const row = document.createElement("tr");
        const isVerified = user.verification !== 0;
        row.innerHTML = `
              <td>${startIndex + index + 1}</td>
              <td>${user.username}</td>
              <td>${user.email}</td>
              <td>${isVerified}</td>
              <td>${user.phone}</td>
              <td>${user.fname}</td>
              <td>${user.lname}</td>
              <td>${user.living}</td>
              <td>${user.IBNA}</td>
              <td>${user.date_of_birth}</td>
              <td>
                <button class="btn btn-danger" onclick="deleteUser('${
                  user.username
                }')">Delete</button>
              </td>
            `;
        tableBody.appendChild(row);
      });
      // Generate pagination links dynamically
      generatePaginationLinks();
    })
    .catch((error) => console.error("Error:", error));
}

// Function to handle user deletion
function deleteUser(username) {
  fetch(`http://localhost:8080/api/v1/user/${username}`, { method: "DELETE" })
    .then((response) => response.json())
    .then((message) => {
      alert("User deleted successfully");
      refreshTableData(); // Refresh the table after successful deletion
    })
    .catch((error) => console.error("Error:", error));
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
  refreshTableData();
}

// Function to handle user search
function searchByUsername() {
  const searchInput = document
    .getElementById("searchInput")
    .value.toLowerCase();
  const filteredData = allUsersData.filter((user) =>
    user.username.toLowerCase().includes(searchInput)
  );

  const tableBody = document.getElementById("tableBody");
  tableBody.innerHTML = ""; // Clear the current table data

  // If there are search results, update the table with the filtered data
  if (filteredData.length > 0) {
    filteredData.forEach((user, index) => {
      const row = document.createElement("tr");
      const isVerified = user.verification !== 0;
      row.innerHTML = `
        <td>${index + 1}</td>
        <td>${user.username}</td>
        <td>${user.email}</td>
        <td>${isVerified}</td>
        <td>${user.phone}</td>
        <td>${user.fname}</td>
        <td>${user.lname}</td>
        <td>${user.living}</td>
        <td>${user.IBNA}</td>
        <td>${user.date_of_birth}</td>
        <td>
          <button class="btn btn-danger" onclick="deleteUser('${
            user.username
          }')">Delete</button>
        </td>
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

// Initial data fetch when the page loads
refreshTableData();

function logout() {
  localStorage.removeItem("token");
  window.location.href = "login.html";
}
