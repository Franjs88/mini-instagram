#
# This is the Main Endpoint for Mini-Instagram application
#


# Required middleware for express 4.
express = require ("express")
app = express()
bodyParser = require ("body-parser")
expressValidator = require ("express-validator")

# configure the app to use bodyparser()
app.use bodyParser.urlencoded(extended: true)
app.use bodyParser.json()
port = process.env.PORT or 8080

# Routes for the API
router = express.Router() #get an instance of the express Router

router.get "/", (req, res) ->
  res.json message: "Welcome to our MiniInstagram!"
  return

# More Routes

#Register the routes
#All of our routes will be prefixed with /api
app.use "/api", router

# SERVER STARTS
#==============================================
app.listen port

console.log "Magic happens on port " + port

