run 'pgrep spring | xargs kill -9'

# GEMFILE
########################################
run 'rm Gemfile'
file 'Gemfile', <<-RUBY
source 'https://rubygems.org'
ruby '#{RUBY_VERSION}'

gem 'rails', '#{Rails.version}'
gem 'pg', '~> 0.21'
gem 'puma'
gem 'redis'
gem 'uglifier'
gem 'webpacker'
gem 'jbuilder', '~> 2.5'
gem 'sass-rails'
#{"gem 'bootsnap', require: false" if Rails.version >= "5.2"}

gem 'bootstrap'
gem 'devise'
gem 'font-awesome-sass'
gem 'simple_form'
gem 'autoprefixer-rails'
gem 'jquery-rails'
gem 'carrierwave'
gem 'mini_magick'
gem 'fog-aws'

group :development do
  gem 'web-console', '>= 3.3.0'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'listen', '~> 3.0.5'
  gem 'dotenv-rails'
end
RUBY

# Ruby version
########################################
file '.ruby-version', RUBY_VERSION

# Procfile
########################################
file 'Procfile', <<-YAML
web: bundle exec puma -C config/puma.rb
YAML

# Assets
########################################
run 'rm -rf app/assets/stylesheets'
run 'rm -rf vendor'

run 'curl -L https://github.com/rayancastro/stylesheets/archive/master.zip > stylesheets.zip'
run 'unzip stylesheets.zip -d app/assets && rm stylesheets.zip && mv app/assets/stylesheets-master app/assets/stylesheets'

run 'curl -L https://github.com/rayancastro/fonts/archive/master.zip > fonts.zip'
run 'unzip fonts.zip -d app/assets && rm fonts.zip && mv app/assets/fonts-master app/assets/fonts'

run 'rm app/assets/javascripts/application.js'
file 'app/assets/javascripts/application.js', <<-JS
//= require jquery
//= require rails-ujs
//= require_tree .
JS

# Dev environment
########################################
gsub_file('config/environments/development.rb', /config\.assets\.debug.*/, 'config.assets.debug = false')

# Layout
########################################
run 'rm app/views/layouts/application.html.erb'
file 'app/views/layouts/application.html.erb', <<-HTML
<!DOCTYPE html>
<html>
  <head>
    <title>Hortatech Template</title>
    <link rel="icon" href="<%= image_path 'favicon.png' %>">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta charset="UTF-8">
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>
    <%= action_cable_meta_tag %>
    <%= stylesheet_link_tag 'application', media: 'all' %>
    <%#= stylesheet_pack_tag 'application', media: 'all' %> <!-- Uncomment if you import CSS in app/javascript/packs/application.js -->
  </head>
  <body>
    <%= render 'shared/navbar' %>
    <%= render 'shared/flashes' %>
    <%= yield %>
    <%= render 'shared/footer' %>
    <%= javascript_include_tag 'application' %>
    <%= javascript_pack_tag 'application' %>
    <%= yield(:after_js) %>
  </body>
</html>
HTML

file 'app/views/shared/_flashes.html.erb', <<-HTML
<% if notice %>
  <div class="alert alert-info alert-dismissible" role="alert">
    <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
    <%= notice %>
  </div>
<% end %>
<% if alert %>
  <div class="alert alert-warning alert-dismissible" role="alert">
    <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
    <%= alert %>
  </div>
<% end %>
HTML

run 'curl -L https://raw.githubusercontent.com/rayancastro/hortatech-templates/master/app/views/shared/_navbar_hortatech.html.erb > app/views/shared/_navbar.html.erb'
run 'curl -L https://raw.githubusercontent.com/rayancastro/hortatech-templates/master/app/views/shared/_footer_hortatech.html.erb > app/views/shared/_footer.html.erb'
run 'curl -L https://raw.githubusercontent.com/rayancastro/hortatech-templates/master/app/assets/images/logo.png > app/assets/images/logo.png'
run 'curl -L https://raw.githubusercontent.com/rayancastro/hortatech-templates/master/app/assets/images/favicon.png > app/assets/images/favicon.png'


# README
########################################
markdown_file_content = <<-MARKDOWN
Rails app generated with Hortatech Template, created by rayancastro.
MARKDOWN
file 'README.md', markdown_file_content, force: true

# Generators
########################################
generators = <<-RUBY
  config.generators do |generate|
    generate.test_framework :rspec,
      view_specs: false,
      helper_specs: false,
      routing_specs: false,
      request_specs: false
    generate.assets false
    generate.helper false
  end
RUBY

environment generators

########################################
# AFTER BUNDLE
########################################
after_bundle do
  # Generators: db + simple form + pages controller
  ########################################
  rails_command 'db:drop db:create db:migrate'
  generate('simple_form:install', '--bootstrap')
  generate(:controller, 'pages', 'home', '--skip-routes', '--no-test-framework')
  # RSPEC Install
  ########################################
  generate('rspec:install')
  # Routes
  ########################################
  route "root to: 'pages#home'"

  # Git ignore
  ########################################
  run 'rm .gitignore'
  file '.gitignore', <<-TXT
.bundle
log/*.log
tmp/**/*
tmp/*
!log/.keep
!tmp/.keep
*.swp
.DS_Store
public/assets
public/packs
public/packs-test
node_modules
yarn-error.log
.byebug_history
.env*
TXT



  # Devise install + user
  ########################################
  generate('devise:install')
  generate('devise', 'User')

  run 'rm app/models/user.rb'
  run 'curl -L https://raw.githubusercontent.com/rayancastro/hortatech-templates/master/app/models/user.rb > app/models/user.rb'

  # App controller
  ########################################
  run 'rm app/controllers/application_controller.rb'
  run 'curl -L https://raw.githubusercontent.com/rayancastro/hortatech-templates/master/app/controllers/application_controller.rb > app/controllers/application_controller.rb'


  # migrate + devise views
  ########################################
  rails_command 'db:migrate'
  generate('devise:views')

  run 'rm app/views/devise/registrations/edit.html.erb'
  run 'curl -L https://raw.githubusercontent.com/rayancastro/hortatech-templates/master/app/views/devise/registrations/edit.html.erb > app/views/devise/registrations/edit.html.erb'
  run 'rm app/views/devise/registrations/new.html.erb'
  run 'curl -L https://raw.githubusercontent.com/rayancastro/hortatech-templates/master/app/views/devise/registrations/new.html.erb > app/views/devise/registrations/new.html.erb'
  run 'rm app/views/devise/sessions/new.html.erb'
  run 'curl -L https://raw.githubusercontent.com/rayancastro/hortatech-templates/master/app/views/devise/sessions/new.html.erb > app/views/devise/sessions/new.html.erb'

  # Pages Controller
  ########################################
  run 'rm app/controllers/pages_controller.rb'
  run 'curl -L https://raw.githubusercontent.com/rayancastro/hortatech-templates/master/app/controllers/pages_controller.rb > app/controllers/pages_controller.rb'


  # Environments
  ########################################
  environment 'config.action_mailer.default_url_options = { host: "http://localhost:3000" }', env: 'development'
  environment 'config.action_mailer.default_url_options = { host: "http://TODO_PUT_YOUR_DOMAIN_HERE" }', env: 'production'

  # Webpacker / Yarn
  ########################################
  run 'rm app/javascript/packs/application.js'
  run 'yarn add bootstrap jquery popper.js typed.js'
  file 'app/javascript/packs/application.js', <<-JS
import "bootstrap";
JS

  inject_into_file 'config/webpack/environment.js', before: 'module.exports' do
<<-JS
// Bootstrap 3 has a dependency over jQuery:
const webpack = require('webpack')
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery'
  })
)

JS
  end

  # Dotenv
  ########################################
  run 'touch .env'

  # Rubocop
  ########################################
  run 'curl -L https://raw.githubusercontent.com/rayancastro/hortatech-templates/master/.rubocop.yml > .rubocop.yml'

  # Git
  ########################################
  git :init
  git add: '.'
  git commit: "-m 'Initial commit with devise, webpack, jquery, bootstrap 4'"
end
