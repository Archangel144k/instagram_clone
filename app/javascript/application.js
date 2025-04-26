// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import Rails from "@rails/ujs"
import * as ActiveStorage from "@rails/activestorage";
import "controllers"
import "channels";
import "likeHandler"
import "commentHandler"
import "saveHandler"

Rails.start();
ActiveStorage.start();

const DEBUG = true; // Set to false in production
if (DEBUG) {
  console.log("JavaScript is working!");
}

// Add this to your application.js
const LOADING_SPINNER_HTML = '<i class="fas fa-spinner fa-spin mr-2"></i> Loading...';

document.addEventListener('turbo:click', function(event) {
  if (event.target.matches('.pagination')) {
    event.target.innerHTML = LOADING_SPINNER_HTML;
    event.target.disabled = true;
  }
  if (window.DEBUG_MODE) {
    console.log("Turbo:load event fired!");
  }

  // Disable Turbo for specific forms
  const turboForms = document.querySelectorAll('form[data-turbo="false"]');
  const fragment = document.createDocumentFragment();

  turboForms.forEach(form => {
    const clonedForm = form.cloneNode(true);
    clonedForm.setAttribute("data-turbo", "false");
    fragment.appendChild(clonedForm);
    form.replaceWith(clonedForm);
  });
  const forms = document.querySelectorAll('form[data-turbo="false"]');

  forms.forEach(form => {
    const clonedForm = form.cloneNode(true);
    clonedForm.setAttribute("data-turbo", "false");
    fragment.appendChild(clonedForm);
    form.replaceWith(clonedForm);
  });
// Disable Turbo for specific forms to prevent issues with custom JavaScript handling or non-standard form submissions
});

document.querySelectorAll('.like-button').forEach(btn => {
  btn.addEventListener('click', function(e) {
    e.preventDefault();
    // Your AJAX logic here
  });
});

document.addEventListener("DOMContentLoaded", function() {
  document.querySelectorAll('.flip-card').forEach(function(card) {
    card.querySelectorAll('.flip-btn').forEach(function(btn) {
      btn.addEventListener('click', function() {
        const inner = card.querySelector('.flip-card-inner');
        inner.dataset.flip = inner.dataset.flip === "true" ? "false" : "true";
      });
    });
  });

  // Save button click handler with animations
  document.querySelectorAll('.save-button').forEach(btn => {
    btn.addEventListener('click', function(e) {
      e.preventDefault();
      e.stopPropagation();
      
      const form = btn.closest('form');
      const icon = btn.querySelector('i');
      const container = btn.closest('.post-actions, .reel-actions');
      const loadingOverlay = document.createElement('div');
      
      // Add loading state
      btn.classList.add('saving');
      loadingOverlay.className = 'absolute inset-0 bg-black/30 rounded-full flex items-center justify-center';
      loadingOverlay.innerHTML = '<div class="w-4 h-4 border-2 border-teal-400 border-t-transparent rounded-full animate-spin"></div>';
      btn.appendChild(loadingOverlay);
      
      fetch(form.action, {
        method: form.querySelector('input[name="_method"]') ? 'DELETE' : 'POST',
        headers: {
          'Accept': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
          'Content-Type': 'application/json'
        },
        credentials: 'same-origin'
      })
      .then(response => response.json())
      .then(data => {
        // Remove loading state
        btn.classList.remove('saving');
        btn.removeChild(loadingOverlay);
        
        if (data.success) {
          // Update UI based on saved state
          if (data.saved) {
            // Successfully saved
            icon.className = 'fas fa-bookmark text-teal-400';
            
            // Add method input for DELETE on next click
            if (!form.querySelector('input[name="_method"]')) {
              const methodInput = document.createElement('input');
              methodInput.type = 'hidden';
              methodInput.name = '_method';
              methodInput.value = 'delete';
              form.appendChild(methodInput);
            }
            
            // Show success animation
            const savedAnimation = document.createElement('div');
            savedAnimation.className = 'saved-animation fixed bottom-10 left-1/2 transform -translate-x-1/2 bg-teal-500 text-white py-2 px-4 rounded-full shadow-lg z-50';
            savedAnimation.textContent = data.message;
            document.body.appendChild(savedAnimation);
            
            setTimeout(() => {
              savedAnimation.classList.add('fade-out');
              setTimeout(() => document.body.removeChild(savedAnimation), 500);
            }, 2000);
          } else {
            // Successfully unsaved
            icon.className = 'far fa-bookmark text-gray-300';
            
            // Remove method input for next click
            const methodInput = form.querySelector('input[name="_method"]');
            if (methodInput) form.removeChild(methodInput);
          }
        } else {
          // Show error
          const errorToast = document.createElement('div');
          errorToast.className = 'error-toast fixed bottom-10 left-1/2 transform -translate-x-1/2 bg-red-500 text-white py-2 px-4 rounded-full shadow-lg z-50';
          errorToast.textContent = data.error || 'Something went wrong';
          document.body.appendChild(errorToast);
          
          setTimeout(() => {
            errorToast.classList.add('fade-out');
            setTimeout(() => document.body.removeChild(errorToast), 500);
          }, 3000);
        }
      })
      .catch(error => {
        console.error('Error:', error);
        btn.classList.remove('saving');
        btn.removeChild(loadingOverlay);
      });
    });
  });

  const postContainer = document.querySelector('.max-w-4xl');
  if (!postContainer) return;
  
  // ============ LIKE FUNCTIONALITY ============
  // Use event delegation for like forms
  document.body.addEventListener('submit', function(e) {
    if (e.target.matches('form.like-form')) {
      e.preventDefault();
      const form = e.target;
      const button = form.querySelector('button');
      const icon = button.querySelector('i');
      const countSpan = form.closest('.actions-bar, .flex-col, .post-actions')?.querySelector('span.text-xs') || button.parentElement.querySelector('span.text-xs');
      const isLiked = icon.classList.contains('fas');

      button.classList.add('animate-pulse');

      fetch(form.action, {
        method: isLiked ? 'DELETE' : 'POST',
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
          'Accept': 'application/json'
        },
        credentials: 'same-origin'
      })
      .then(response => response.json())
      .then(data => {
        button.classList.remove('animate-pulse');
        if (data.success) {
          // Update icon and count
          if (data.liked) {
            icon.className = 'fas fa-heart text-xl';
            button.className = 'text-red-500 hover:scale-110 transition-all bg-black/20 p-2.5 rounded-full';
            // Add method input for DELETE
            if (!form.querySelector('input[name="_method"]')) {
              const methodInput = document.createElement('input');
              methodInput.type = 'hidden';
              methodInput.name = '_method';
              methodInput.value = 'delete';
              form.appendChild(methodInput);
            }
          } else {
            icon.className = 'far fa-heart text-xl';
            button.className = 'text-gray-300 hover:text-red-500 hover:scale-110 transition-all bg-black/20 p-2.5 rounded-full';
            // Remove method input for next click
            const methodInput = form.querySelector('input[name="_method"]');
            if (methodInput) form.removeChild(methodInput);
          }
          // Update count from API response
          if (countSpan && typeof data.count !== 'undefined') {
            countSpan.textContent = `${data.count} ${data.count === 1 ? 'like' : 'likes'}`;
          }
        }
      })
      .catch(error => {
        console.error('Error:', error);
        button.classList.remove('animate-pulse');
      });
    }
  });

  // ============ SAVE FUNCTIONALITY ============
  const setupSaveButton = () => {
    const saveForm = document.querySelector('form[action*="save_post"]');
    if (!saveForm) return;
    
    saveForm.addEventListener('submit', function(e) {
      e.preventDefault();
      
      // Visual feedback
      const button = this.querySelector('button') || this;
      const icon = button.querySelector('i');
      const isSaved = icon.classList.contains('fas');
      const method = isSaved ? 'DELETE' : 'POST';
      
      // Animation
      button.classList.add('animate-pulse');
      
      fetch(this.action, {
        method: method,
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
          'Accept': 'application/json'
        },
        credentials: 'same-origin'
      })
      .then(response => response.json())
      .then(data => {
        button.classList.remove('animate-pulse');
        
        if (data.success) {
          // Show toast notification
          const toast = document.createElement('div');
          toast.className = 'fixed bottom-10 left-1/2 transform -translate-x-1/2 px-6 py-3 rounded-lg text-white z-50 animate-fade-in-up';
          toast.style.backgroundColor = data.saved ? '#14b8a6' : '#374151';
          toast.innerHTML = data.message || (data.saved ? 'Post saved to collection' : 'Removed from saved items');
          document.body.appendChild(toast);
          
          setTimeout(() => {
            toast.classList.add('animate-fade-out-down');
            setTimeout(() => toast.remove(), 500);
          }, 2000);
          
          // Update icon
          if (data.saved) {
            icon.className = 'fas fa-bookmark text-xl';
            button.className = 'text-teal-400 hover:scale-110 transition-transform bg-black/40 p-3 rounded-full border border-gray-700/50';
            
            // Update form method for next click
            const methodInput = document.createElement('input');
            methodInput.type = 'hidden';
            methodInput.name = '_method';
            methodInput.value = 'delete';
            saveForm.appendChild(methodInput);
          } else {
            icon.className = 'far fa-bookmark text-xl';
            button.className = 'save-button text-gray-400 hover:text-teal-400 hover:scale-110 transition-transform bg-black/40 p-3 rounded-full border border-gray-700/50';
            
            // Update form method for next click
            const methodInput = saveForm.querySelector('input[name="_method"]');
            if (methodInput) saveForm.removeChild(methodInput);
          }
        }
      })
      .catch(error => {
        console.error('Error:', error);
        button.classList.remove('animate-pulse');
      });
    });
  };
  
  // ============ COMMENT FUNCTIONALITY ============
  // Use event delegation for comment forms
  document.body.addEventListener('submit', function(e) {
    if (e.target.matches('form[action*="comments"]')) {
      e.preventDefault();
      const form = e.target;
      const submitBtn = form.querySelector('input[type="submit"]');
      const originalText = submitBtn.value;
      submitBtn.value = 'Posting...';
      submitBtn.disabled = true;
      const formData = new FormData(form);

      // <<< START DEBUGGING >>>
      console.log("Submitting comment form:", form);
      console.log("Form Action:", form.action);
      console.log("--- FormData Entries ---");
      for (let [key, value] of formData.entries()) {
        console.log(`  ${key}: ${value}`);
      }
      console.log("--- End FormData ---");
      // <<< END DEBUGGING >>>

      fetch(form.action, {
        method: 'POST',
        body: formData,
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
          'Accept': 'application/json'
        },
        credentials: 'same-origin'
      })
      .then(response => response.json())
      .then(data => {
        submitBtn.value = originalText;
        submitBtn.disabled = false;
        form.reset();
        if (data.success) {
          // Add new comment to the top of the comments list
          const commentsList = document.getElementById('comments-section') || document.querySelector('.mt-10');
          if (commentsList) {
            const newComment = document.createElement('div');
            newComment.className = 'mb-4 flex items-start space-x-3 animate-fade-in';
            newComment.innerHTML = `
              <img src="${data.avatar_url}" class="h-8 w-8 rounded-full object-cover border border-gray-700">
              <div>
                <div class="bg-gray-800 rounded-xl px-4 py-2 text-gray-100">
                  <span class="font-semibold text-teal-400">${data.username}</span>
                  <span class="ml-2">${data.body}</span>
                </div>
                <span class="text-xs text-gray-500 ml-2">just now</span>
              </div>
            `;
            const firstComment = commentsList.querySelector('.mb-4');
            if (firstComment) {
              commentsList.insertBefore(newComment, firstComment);
            } else {
              commentsList.appendChild(newComment);
            }
          }
          // Optionally update comment count if you display it
        }
      })
      .catch(error => {
        console.error('Error:', error);
        submitBtn.value = originalText;
        submitBtn.disabled = false;
      });
    }
  });

  // ============ FOLLOW/UNFOLLOW FUNCTIONALITY ============
  document.addEventListener('click', function(e) {
    const followForm = e.target.closest('.follow-form');
    if (!followForm) return;
    
    e.preventDefault();
    const button = followForm.querySelector('button') || followForm;
    const isFollowing = button.classList.contains('unfollow-button');
    
    // Visual feedback
    button.innerHTML = '<div class="loading-spinner h-4 w-4 mx-auto"></div>';
    button.disabled = true;
    
    fetch(followForm.action, {
      method: isFollowing ? 'DELETE' : 'POST',
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      credentials: 'same-origin'
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        // Update button appearance
        if (data.following) {
          // Now following
          button.className = "unfollow-button text-gray-200 border border-gray-500 bg-gray-800 hover:bg-gray-700 px-4 py-1.5 rounded-full text-sm font-medium";
          button.innerHTML = '<i class="fas fa-user-minus mr-1"></i> Following';
          
          // Update form method for next click
          followForm.action = followForm.action.replace('follow', 'unfollow');
          
          // Add method input for DELETE
          if (!followForm.querySelector('input[name="_method"]')) {
            const methodInput = document.createElement('input');
            methodInput.type = 'hidden';
            methodInput.name = '_method';
            methodInput.value = 'delete';
            followForm.appendChild(methodInput);
          }
        } else {
          // Unfollowed
          button.className = "follow-button bg-gradient-to-r from-teal-500 to-blue-500 hover:from-teal-600 hover:to-blue-600 text-white px-4 py-1.5 rounded-full text-sm font-medium";
          button.innerHTML = '<i class="fas fa-user-plus mr-1"></i> Follow';
          
          // Update form method for next click
          followForm.action = followForm.action.replace('unfollow', 'follow');
          
          // Remove method input
          const methodInput = followForm.querySelector('input[name="_method"]');
          if (methodInput) followForm.removeChild(methodInput);
        }
        
        // Update follower count if it exists on page
        const followerCountEl = document.querySelector('.follower-count');
        if (followerCountEl) {
          followerCountEl.textContent = data.follower_count;
        }
        
        // Show toast notification
        const toast = document.createElement('div');
        toast.className = 'fixed bottom-10 left-1/2 transform -translate-x-1/2 px-6 py-3 rounded-lg text-white z-50 animate-fade-in-up';
        toast.style.backgroundColor = data.following ? '#14b8a6' : '#374151';
        toast.innerHTML = data.message;
        document.body.appendChild(toast);
        
        setTimeout(() => {
          toast.classList.add('animate-fade-out-down');
          setTimeout(() => toast.remove(), 500);
        }, 2000);
      }
    })
    .catch(error => {
      console.error('Error:', error);
      button.disabled = false;
      button.innerHTML = isFollowing ? 
        '<i class="fas fa-user-minus mr-1"></i> Following' : 
        '<i class="fas fa-user-plus mr-1"></i> Follow';
    });
  });

  // Use event delegation for unsave buttons
  document.body.addEventListener('submit', function(e) {
    if (e.target.classList.contains('unsave-form')) {
      e.preventDefault();
      const form = e.target;
      const cardElement = form.closest('.saved-post-card') || form.closest('.saved-post-item');
      
      fetch(form.action, {
        method: 'DELETE',
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
          'Accept': 'application/json'
        },
        credentials: 'same-origin'
      })
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          // Animated removal
          cardElement.style.transition = 'opacity 0.3s, transform 0.3s';
          cardElement.style.opacity = '0';
          cardElement.style.transform = 'scale(0.9)';
          
          setTimeout(() => {
            cardElement.remove();
            
            // Update the saved posts count
            const countBadge = document.querySelector('h1 .rounded-full');
            if (countBadge) {
              const currentCount = parseInt(countBadge.textContent);
              if (currentCount > 1) {
                countBadge.textContent = `${currentCount - 1} posts`;
              } else {
                countBadge.textContent = '0 posts';
                if (document.querySelectorAll('.saved-post-card, .saved-post-item').length === 0) {
                  location.reload();
                }
              }
            }
            
            // Show feedback toast
            const toast = document.createElement('div');
            toast.className = 'fixed bottom-10 left-1/2 transform -translate-x-1/2 px-6 py-3 rounded-lg text-white z-50 animate-fade-in-up';
            toast.style.backgroundColor = '#374151';
            toast.innerHTML = '<i class="fas fa-check-circle mr-2"></i> Post removed from saved items';
            document.body.appendChild(toast);
            
            setTimeout(() => {
              toast.classList.add('animate-fade-out-down');
              setTimeout(() => toast.remove(), 500);
            }, 2000);
          }, 300);
        }
      })
      .catch(error => console.error('Error:', error));
    }
  });

  // Initialize all dynamic features
  setupSaveButton();
});
import "channels"
