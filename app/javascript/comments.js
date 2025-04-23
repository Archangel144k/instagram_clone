document.addEventListener('turbo:load', () => {
  const commentForm = document.querySelector('#new_comment');
  if (commentForm) {
    commentForm.addEventListener('ajax:success', event => {
      const [data, status, xhr] = event.detail;
      const commentsContainer = document.querySelector('#comments');
      commentsContainer.insertAdjacentHTML('beforeend', xhr.responseText); // Append the new comment
      commentForm.reset(); // Clear the form
    });
  }
});