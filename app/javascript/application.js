// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import './likes';
import './saves';
import './comments';

// Add this to your application.js
document.addEventListener('turbo:click', function(event) {
  if (event.target.matches('.pagination')) {
    event.target.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i> Loading...';
    event.target.disabled = true;
  }
});

// Add for Turbo Drive compatibility
document.addEventListener("turbo:load", function() {
  // Initialize any JavaScript that needs to run on page load
});

// Or disable Turbo for specific forms
document.addEventListener("turbo:load", function() {
  const forms = document.querySelectorAll('form[data-turbo="false"]');
  forms.forEach(form => {
    form.setAttribute("data-turbo", "false");
  });
});
