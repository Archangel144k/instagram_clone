document.addEventListener('turbo:load', () => {
  document.querySelectorAll('.like-button').forEach(button => {
    button.addEventListener('ajax:success', event => {
      const [data, status, xhr] = event.detail;
      button.innerHTML = xhr.responseText; // Update the button content dynamically
    });
  });
});