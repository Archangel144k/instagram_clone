# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@rails/ujs", to: "rails-ujs.js", preload: true # Make sure this line exists if you use Rails UJS
pin "@rails/activestorage", to: "activestorage.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers" # Correctly pin Stimulus controllers
pin_all_from "app/javascript/channels", under: "channels" # Pin Action Cable channels if you use them
# Pin any other custom JS files or libraries needed
pin "likeHandler"
pin "saveHandler"
pin "commentHandler"
pin "@rails/actioncable", to: "actioncable.esm.js"
pin_all_from "app/javascript/channels", under: "channels"
