# External library requires
config = require './config.json'
fs = require 'fs'
http  = require 'http'
express = require 'express'
bodyParser = require 'body-parser'
sassMiddleware = require 'node-sass-middleware'
session = require 'express-session'
app = express()

# Own code requires
Helpers = require ('./helpers')
AppRoutes = require ('./routes')

# We like Jade for views
app.set 'view engine', 'jade'

# ...and SASS for stylesheets
app.use sassMiddleware
  src: __dirname + '/styles'
  dest: __dirname + '/public'
  debug: false
  outputStyle: 'compressed'

# Setup session middleware
app.use session
  saveUninitialized: false
  resave: false
  secret: config.sessionSecret

# Parse POST data
app.use bodyParser.urlencoded(
  extended: true
)

# Serve static files from the public directory
app.use express.static('public')

# Setup app routes
AppRoutes(app)

# Create and start the HTTP server
httpServer = http.createServer app
httpServer.listen(config.port)

console.log "Running on port #{config.port}"
