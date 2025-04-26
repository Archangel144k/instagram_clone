# BahamaGram Seed File
require 'open-uri'

puts "🌴 Seeding BahamaGram database..."

# Clear existing data (uncomment if needed)
if Rails.env.development?
  puts "🧹 Cleaning database..."
  # Keep this commented unless you specifically want to clear your database
  # [Like, Save, Comment, Follow, Post, User].each(&:delete_all)
end

# ==============================
# Create Users with Real Avatars
# ==============================

def create_user(attributes)
  user = User.find_or_create_by!(email: attributes[:email]) do |u|
    u.username = attributes[:username]
    u.password = attributes[:password] || 'password123'
    u.password_confirmation = attributes[:password] || 'password123'
    u.bio = attributes[:bio]
    u.website = attributes[:website]
  end
  
  # Attach avatar if URL provided
  if attributes[:avatar_url] && !user.avatar.attached?
    begin
      file = URI.open(attributes[:avatar_url])
      user.avatar.attach(io: file, filename: "#{user.username}_avatar.jpg", content_type: 'image/jpeg')
      puts "✅ Avatar attached for #{user.username}"
    rescue => e
      puts "❌ Failed to attach avatar for #{user.username}: #{e.message}"
    end
  end
  
  user
end

# Create Bahamian-themed users
users = [
  {
    username: 'island_explorer',
    email: 'explorer@example.com',
    bio: 'Exploring the beautiful islands of the Bahamas 🏝️',
    website: 'https://bahamas.com',
    avatar_url: 'https://randomuser.me/api/portraits/men/32.jpg'
  },
  {
    username: 'beach_lover',
    email: 'beach@example.com',
    bio: 'Beach life is the best life 🌊 | Professional sunbather',
    website: 'https://beachlife.com',
    avatar_url: 'https://randomuser.me/api/portraits/women/44.jpg'
  },
  {
    username: 'ocean_diver',
    email: 'diver@example.com',
    bio: 'Diving instructor 🤿 | Showing you the underwater treasures',
    website: 'https://divebahamas.com',
    avatar_url: 'https://randomuser.me/api/portraits/men/22.jpg'
  },
  {
    username: 'sunset_chaser',
    email: 'sunset@example.com',
    bio: 'Chasing sunsets and good vibes ✨ | Photographer',
    website: 'https://sunsetphotos.com',
    avatar_url: 'https://randomuser.me/api/portraits/women/67.jpg'
  },
  {
    username: 'island_chef',
    email: 'chef@example.com',
    bio: 'Creating Bahamian cuisine masterpieces 🍹 | Food blogger',
    website: 'https://bahamiancuisine.com',
    avatar_url: 'https://randomuser.me/api/portraits/men/55.jpg'
  },
  {
    username: 'alice_codes',
    email: 'alice@example.com',
    bio: 'Lover of Rails and dark themes. Coding from paradise! 💻',
    website: 'https://rubyonrails.org',
    avatar_url: 'https://randomuser.me/api/portraits/women/3.jpg'
  },
  {
    username: 'bob_builds',
    email: 'bob@example.com',
    bio: 'Building cool things with Tailwind. Island edition. 🏝️',
    website: 'https://tailwindcss.com',
    avatar_url: 'https://randomuser.me/api/portraits/men/4.jpg'
  }
]

created_users = users.map do |user_attrs|
  user = create_user(user_attrs)
  puts "👤 Created User: #{user.username} (#{user.email})"
  user
end

# ==============================
# Create Follows
# ==============================

def create_follows(users)
  # Check if follows table exists
  if !ActiveRecord::Base.connection.table_exists?('follows')
    puts "⚠️ The follows table doesn't exist. Creating it now..."
    
    # Execute the migration directly from seeds if needed
    ActiveRecord::Migration.say_with_time("Creating follows table") do
      ActiveRecord::Base.connection.create_table :follows do |t|
        t.integer :follower_id, null: false
        t.integer :followed_id, null: false
        t.timestamps
      end
      
      ActiveRecord::Base.connection.add_index :follows, :follower_id
      ActiveRecord::Base.connection.add_index :follows, :followed_id
      ActiveRecord::Base.connection.add_index :follows, [:follower_id, :followed_id], unique: true
    end
  end

  # Clear existing follows for clean seeding (optional)
  if Follow.count > 0
    puts "🧹 Clearing existing follows..."
    Follow.delete_all
  end

  puts "👥 Creating follows..."
  
  # Create a realistic social graph
  # - Some users are very popular (followed by many)
  # - Some users follow many others
  # - Some have balanced follow/follower counts
  
  # Make island_explorer and sunset_chaser popular accounts
  popular_users = users.select { |user| ['island_explorer', 'sunset_chaser'].include?(user.username) }
  
  # Create follow relationships
  total_follows = 0
  
  users.each do |follower|
    # Determine how many users this account will follow (2-5 for normal users)
    max_to_follow = case follower.username
                    when 'beach_lover', 'alice_codes'
                      # These users follow more people
                      rand(4..6)
                    else
                      rand(2..5)
                    end
    
    # Select users to follow (excluding self)
    potential_followed = users - [follower]
    
    # Popular users are more likely to be followed
    potential_followed = (potential_followed + popular_users).uniq
    
    # Select random subset to follow
    to_follow = potential_followed.sample(max_to_follow)
    
    to_follow.each do |followed|
      next if follower == followed # Extra check to never follow self
      next if Follow.exists?(follower_id: follower.id, followed_id: followed.id)
      
      follow = Follow.new(follower_id: follower.id, followed_id: followed.id)
      
      if follow.save
        total_follows += 1
        puts "👤 #{follower.username} is now following #{followed.username}"
      else
        puts "❌ Failed to create follow: #{follow.errors.full_messages.join(', ')}"
      end
    end
  end
  
  # Create specific follows for testing
  if users.length >= 2
    test_follower = users.first
    test_followed = users.second
    
    unless Follow.exists?(follower_id: test_follower.id, followed_id: test_followed.id)
      Follow.create(follower_id: test_follower.id, followed_id: test_followed.id)
      puts "🔍 Created test follow: #{test_follower.username} → #{test_followed.username}"
    end
  end
  
  puts "✅ Created #{total_follows} follows"
end

create_follows(created_users)

# ==============================
# Create Posts with Real Images
# ==============================

bahamas_image_urls = [
  'https://images.unsplash.com/photo-1548574505-5e239809ee19?q=80&w=1200',
  'https://images.unsplash.com/photo-1591445141169-f76f5d4e1dec?q=80&w=1200',
  'https://images.unsplash.com/photo-1544141310-035a532f2981?q=80&w=1200',
  'https://images.unsplash.com/photo-1590504960434-507ef17de704?q=80&w=1200',
  'https://images.unsplash.com/photo-1560260240-c6ef90a163a4?q=80&w=1200',
  'https://images.unsplash.com/photo-1599861758261-0a8b0097751b?q=80&w=1200',
  'https://images.unsplash.com/photo-1586861256632-51a43daeb131?q=80&w=1200',
  'https://images.unsplash.com/photo-1617170788899-09b27165926c?q=80&w=1200',
  'https://images.unsplash.com/photo-1600210491369-e753d80a41f3?q=80&w=1200',
  'https://images.unsplash.com/photo-1550074735-cb27a85939fc?q=80&w=1200',
  'https://images.unsplash.com/photo-1589604872090-5c5242ca3c9a?q=80&w=1200',
  'https://images.unsplash.com/photo-1597466599360-3b9775841aec?q=80&w=1200'
]

captions = [
  "Paradise found 🏝️ #BahamaLife",
  "Crystal clear waters as far as the eye can see 💙 #OceanViews",
  "Soaking up the sun at the most beautiful beach ☀️ #BeachDay",
  "Island hopping adventures continue! 🚤 #IslandLife",
  "The colors of the Bahamas never disappoint 🌈 #ColorfulParadise",
  "Sunset magic hour in Nassau 🌅 #SunsetLovers",
  "Fresh coconut water is the best refreshment 🥥 #TropicalTreats",
  "Sandy toes, sun-kissed nose 👣 #BeachVibes",
  "Swimming with the pigs at Exuma! Bucket list checked ✓ #SwimmingPigs",
  "The definition of turquoise found in the Bahamas 💎 #TurquoiseWaters",
  "Palm trees and ocean breeze 🌴 #IslandBreeze",
  "Found my happy place 😌 #BahamaBliss",
  "Local cuisine is simply amazing 🍽️ #BahamianFood",
  "Snorkeling in this underwater paradise 🐠 #MarineLife",
  "Pink sand beaches are real and they're spectacular 💕 #PinkSandBeach"
]

def create_posts(users, image_urls, captions)
  users.each do |user|
    # Create 1-3 posts per user
    rand(1..3).times do
      # Select a random image and caption
      image_url = image_urls.sample
      caption = captions.sample
      
      # Create the post
      post = user.posts.build(caption: caption)
      
      begin
        file = URI.open(image_url)
        post.image.attach(io: file, filename: "post_#{SecureRandom.hex(5)}.jpg", content_type: 'image/jpeg')
        
        if post.save
          puts "📸 Created post for #{user.username}: #{caption[0..30]}..."
        else
          puts "❌ Failed to create post for #{user.username}: #{post.errors.full_messages.join(', ')}"
        end
      rescue => e
        puts "❌ Failed to attach image for post: #{e.message}"
      end
    end
  end
end

create_posts(created_users, bahamas_image_urls, captions)

# ==============================
# Create Comments
# ==============================

comments = [
  "This is absolutely stunning! 😍",
  "Paradise vibes! ✨",
  "I need to visit this place! 🏝️",
  "Wow, what a gorgeous view! 👏",
  "Living the dream! 💙",
  "This makes me want to book a flight right now! ✈️",
  "The colors are incredible! 🌈",
  "Best place on earth! 🌎",
  "That water looks so inviting! 🌊",
  "Island life suits you! 🏝️",
  "Perfect shot! 📸",
  "This is what dreams are made of! ✨",
  "Take me there! 🙏",
  "Serious vacation envy right now! 😎",
  "Pure bliss! 💯"
]

def create_comments(users, posts, comment_texts)
  posts = Post.all.to_a
  return if posts.empty?
  
  # Each user leaves 2-5 comments on random posts
  users.each do |user|
    num_comments = rand(2..5)
    posts_to_comment = posts.sample(num_comments)
    
    posts_to_comment.each do |post|
      comment_text = comment_texts.sample
      comment = post.comments.build(user: user, body: comment_text)
      
      if comment.save
        puts "💬 #{user.username} commented on #{post.user.username}'s post: #{comment_text[0..20]}..."
      else
        puts "❌ Failed to create comment: #{comment.errors.full_messages.join(', ')}"
      end
    end
  end
end

create_comments(created_users, Post.all, comments)

# ==============================
# Create Likes
# ==============================

def create_likes(users, posts)
  posts = Post.all.to_a
  return if posts.empty?
  
  # Each user likes 3-7 random posts
  users.each do |user|
    num_likes = rand(3..7)
    posts_to_like = posts.sample(num_likes)
    
    posts_to_like.each do |post|
      next if post.likes.where(user: user).exists?
      
      like = post.likes.build(user: user)
      if like.save
        puts "❤️ #{user.username} liked #{post.user.username}'s post"
      else
        puts "❌ Failed to create like: #{like.errors.full_messages.join(', ')}"
      end
    end
  end
end

create_likes(created_users, Post.all)

# ==============================
# Create Saved Posts
# ==============================

def create_saved_posts(users, posts)
  posts = Post.all.to_a
  return if posts.empty?
  
  # Each user saves 1-4 random posts
  users.each do |user|
    num_saves = rand(1..4)
    posts_to_save = posts.sample(num_saves)
    
    posts_to_save.each do |post|
      # Check if defined(saves) exists and that the user hasn't already saved this post
      next unless defined?(Save) && !Save.exists?(user: user, saveable: post)
      
      save = Save.new(user: user, saveable: post)
      if save.save
        puts "🔖 #{user.username} saved #{post.user.username}'s post"
      else
        puts "❌ Failed to save post: #{save.errors.full_messages.join(', ')}"
      end
    end
  end
end

# Save posts only if the Save model exists
if defined?(Save)
  create_saved_posts(created_users, Post.all)
end

# ==============================
# Create Reels
# ==============================

# Create reels if the Reel model exists
if defined?(Reel)
  puts "🎬 Creating Reels..."
  
  # This is just a placeholder. In a real application, you'd need video files.
  # You could use remote video URLs, but for simplicity, we'll just indicate that reels would be created here.
  puts "⚠️ Skipping Reel creation - please add videos manually or update seed file with video URLs"
end

# ==============================
# Create Stories
# ==============================

story_image_urls = [
  'https://images.unsplash.com/photo-1566761011389-b226bd9122dc?q=80&w=1200', # Beach view
  'https://images.unsplash.com/photo-1540202404-d0c7fe46a087?q=80&w=1200',    # Sunset
  'https://images.unsplash.com/photo-1583509160110-b8ddb984eba9?q=80&w=1200', # Palm trees
  'https://images.unsplash.com/photo-1560750588-73207b1ef5b8?q=80&w=1200',    # Beach drinks
  'https://images.unsplash.com/photo-1626446614196-a1ca3a2975f5?q=80&w=1200', # Swimming pigs
  'https://images.unsplash.com/photo-1518756740824-59cc0e2b1de7?q=80&w=1200', # Boat on water
  'https://images.unsplash.com/photo-1600210491369-e753d80a41f3?q=80&w=1200', # Bahamas aerial view
  'https://images.unsplash.com/photo-1567519136491-e52abba28c88?q=80&w=1200'  # Resort view
]

# Only use videos with appropriate licenses (Creative Commons or public domain)
story_video_urls = [
  'https://assets.mixkit.co/videos/preview/mixkit-waves-in-the-water-1164-large.mp4',
  'https://assets.mixkit.co/videos/preview/mixkit-young-woman-taking-a-picture-of-the-sunset-5028-large.mp4',
  'https://assets.mixkit.co/videos/preview/mixkit-aerial-of-a-paradisiacal-beach-4112-large.mp4',
  'https://assets.mixkit.co/videos/preview/mixkit-dog-jumps-into-a-pool-1958-large.mp4'
]

story_captions = [
  "Just another day in paradise 🏝️",
  "Sunset chasing 🌅",
  "Ocean therapy 🌊",
  "Beach vibes only ✨",
  "Island hopping today! 🚤",
  "Soaking up the sun ☀️",
  "This view though... 😍",
  "Morning swim 🏊‍♀️",
  "Found a hidden gem today",
  "No filter needed here",
  "Making memories 💭",
  "Can't get enough of this place 💙"
]

def create_stories(users, image_urls, video_urls, captions)
  # Check if Story model exists
  return unless defined?(Story)
  
  puts "📱 Creating stories..."
  
  users.each do |user|
    # Create 1-3 stories per user with varying expiration times
    rand(1..3).times do
      # Decide between image or video (70% chance of image)
      is_image = rand < 0.7
      media_url = is_image ? image_urls.sample : video_urls.sample
      caption = captions.sample
      
      # Set expiration - some active, some expired
      expires_at = [24.hours.from_now, 12.hours.from_now, 2.hours.ago, 1.day.ago].sample
      
      story = user.stories.new(
        caption: caption,
        expires_at: expires_at
      )
      
      begin
        file = URI.open(media_url)
        content_type = is_image ? 'image/jpeg' : 'video/mp4'
        story.media.attach(
          io: file,
          filename: "story_#{SecureRandom.hex(5)}.#{is_image ? 'jpg' : 'mp4'}",
          content_type: content_type
        )
        
        if story.save
          status = expires_at > Time.current ? "🟢 Active" : "🔴 Expired"
          puts "#{status} story created for #{user.username}: #{caption[0..20]}... (#{is_image ? 'Image' : 'Video'})"
          
          # Create some views for each story
          create_story_views(story, users - [user])
        else
          puts "❌ Failed to create story: #{story.errors.full_messages.join(', ')}"
        end
      rescue => e
        puts "❌ Failed to attach media for story: #{e.message}"
      end
    end
  end
end

def create_story_views(story, users)
  return unless defined?(StoryView)
  
  # Random viewers (30-70% of users)
  num_viewers = (users.length * (0.3 + rand * 0.4)).to_i
  viewers = users.sample(num_viewers)
  
  viewers.each do |viewer|
    view = StoryView.new(user: viewer, story: story)
    if view.save
      # Don't output this to avoid cluttering the console
    else
      puts "⚠️ Failed to create story view: #{view.errors.full_messages.join(', ')}"
    end
  end
  
  if viewers.any?
    puts "  👁️ Viewed by #{viewers.count} users"
  end
end

create_stories(created_users, story_image_urls, story_video_urls, story_captions)

puts "✅ Seeding complete! Created:"
puts "• #{User.count} users"
puts "• #{Post.count} posts"
puts "• #{Comment.count} comments"
puts "• #{Like.count} likes"
puts "• #{Follow.count} follows"
puts "• #{defined?(Save) ? Save.count : 0} saved posts"
puts "• #{defined?(Reel) ? Reel.count : 0} reels"
puts "• #{defined?(Story) ? Story.count : 0} stories"
puts "• #{defined?(StoryView) ? StoryView.count : 0} story views"
