const token = localStorage.getItem("token");

// Function to fetch data using token
function fetchData(url, options) {
  return fetch(url, {
    ...options,
    headers: {
      ...options.headers,
      Authorization: `${token}`,
    },
  }).then((response) => response.json());
}

document.addEventListener("DOMContentLoaded", function () {
  refreshTableData(); // Initial table data fetch when the DOM is loaded
});

// Function to handle the 'Accept' button click
function acceptChale(name) {
  console.log("ac");
  fetchData(`http://localhost:8080/api/v1/chales/agree/${name}`, {
    method: "PATCH",
  })
    .then((message) => {
      alert("accept chale");
      refreshTableData();
    })
    .catch((error) => console.error("Error:", error));
}

// Function to handle the 'Delete' button click
function deleteChale(name) {
  console.log("de");
  fetchData(`http://localhost:8080/api/v1/chales/admin/delete/${name}`, {
    method: "DELETE",
  })
    .then((message) => {
      alert("delete chale");
      refreshTableData();
    })
    .catch((error) => console.error("Error:", error));
}

function refreshTableData() {
  const tableBody = document.querySelector("tbody");
  tableBody.innerHTML = ""; // Clear the table body before fetching updated data

  fetchData("http://localhost:8080/api/v1/chales/admen/todo", {})
    .then((data) => {
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
                <td><img src="C:\\project\\Palestinian-chalet\\backend\\${
                  chale.main_image
                }" alt="Chale Image" width="40" height="40"></td>
                <td>
                  <button class="btn btn-success ml-1" onclick="acceptChale('${
                    chale.name
                  }')">Accept</button>
                  <button class="btn btn-danger m-1" onclick="deleteChale('${
                    chale.name
                  }')">Delete</button>
                </td>
              `;
        tableBody.appendChild(row);
      });
    })
    .catch((error) => console.error("Error:", error));
}

function logout() {
  localStorage.removeItem("token");
  window.location.href = "login.html";
}
