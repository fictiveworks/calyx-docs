document.addEventListener("DOMContentLoaded", () => {
  const navbar = document.querySelector(".navbar");
  const toggleButton = document.querySelector(".nav-toggle");

  toggleButton.addEventListener("click", () => {
    navbar.classList.toggle("is-open");
  });
});
