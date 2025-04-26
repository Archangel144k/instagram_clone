import consumer from "channels/consumer"

// Helper to get post ID from a meta tag or a data attribute
const postId = document.querySelector("meta[name='post-id']")?.content || document.body.dataset.postId;

if (postId) {
  consumer.subscriptions.create({ channel: "CommentsChannel", post_id: postId }, {
    received(data) {
      // Insert the new comment HTML at the top of the comments list
      const commentsList = document.getElementById("comments-section") || document.querySelector(".comments-list");
      if (commentsList && data.comment) {
        const tempDiv = document.createElement("div");
        tempDiv.innerHTML = data.comment;
        const newComment = tempDiv.firstElementChild;
        if (newComment) {
          commentsList.prepend(newComment);
        }
      }
    }
  });
}
