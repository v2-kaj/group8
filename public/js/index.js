document.addEventListener('DOMContentLoaded', () => {
    // JavaScript to toggle the mobile navigation menu
    const hamburgerMenu = document.getElementById("hamburger-menu");
    const navLinks = document.getElementById("nav-links");

    hamburgerMenu.addEventListener("click", () => {
      navLinks.classList.toggle("show");
    });

    
  })