// Function to refresh table data
function refreshTableData() {
  fetch("http://localhost:8080/api/v1/user")
    .then((response) => response.json())
    .then((data) => {
      const tableBody = document.getElementById("tableBody");
      tableBody.innerHTML = ""; // Clear the current table data
      data.forEach((user, index) => {
        const row = document.createElement("tr");
        row.innerHTML = `
              <td>${index + 1}</td>
              <td>${user.username}</td>
              <td>${user.email}</td>
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

// Initial data fetch when the page loads
refreshTableData();

function logout() {
  localStorage.removeItem("token");
  window.location.href = "login.html";
}
