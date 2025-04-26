# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@rails/ujs", to: "rails-ujs.js", preload: true
pin "@rails/activestorage", to: "activestorage.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin_all_from "app/javascript/channels", under: "channels"
pin "likeHandler"
pin "saveHandler"
pin "commentHandler"
pin "@rails/actioncable", to: "actioncable.esm.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
