#
# This is the Main Endpoint for Mini-Instagram application
# Info:
# http://liamkaufman.com/blog/2012/03/01/why-riak-and-nodejs-make-a-great-pair/
#


# Required middleware for express 4.
express = require ("express")
app = express()
bodyParser = require ("body-parser")
expressValidator = require ("express-validator")

# Required middleware for riak database
db = require("riak-js").getClient(
  host: "riak.myhost"
  port: "8098"
)

# configure the app to use bodyparser()
app.use bodyParser.urlencoded(extended: true)
app.use bodyParser.json()
port = process.env.PORT or 8080

# Routes for the API
# ===================================================
#get an instance of the express Router
service = express.Router()

service.get "/", (req, res) ->
  res.json message: "Welcome to our MiniInstagram!"
  return

# More Routes

# Fetch all photos from the database
service.get "/photos", (req, res) ->
  console.log "Fetching photos from database..."
  console.log "Content-type recibido es: "+req.get("Content-Type")
  #Fetch all photos
  if req.is('image')
    db.get("photos", (err, data) ->
      throw err if (err)
      console.log ("Success => Found photos: " + data)
      res.status.send(200)
      return
    )
  else
    console.log ("Error: The payload is not an image")
    res.status(401).send("Not acceptable")
    return
  return

# Saves a photo in the database
service.post "/photos", (req, res) ->
  console.log "Guardando en la BD"
  console.log "Content-type recibido es: "+req.get("Content-Type")
  # Save the photo
  if req.is('image/png')
    db.save("photos","Primera", image, (err, data) ->
      throw err if (err)
      console.log("Saved photo: " +data)
      res.status(201).send
      return
    )
  else
    console.log("Error: The payload is not an image")
    res.status(401).send("Not acceptable")
    return
  return

#Register the routes
#All of our routes will be prefixed with /api
app.use "/api", service

# SERVER STARTS
#==============================================
app.listen port

console.log "Magic happens on port " + port

