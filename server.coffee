#
# This is the Main Endpoint for Mini-Instagram application
# More Info:
# http://liamkaufman.com/blog/2012/03/01/why-riak-and-nodejs-make-a-great-pair/
#

express = require("express")
app = express()
bodyParser = require("body-parser")
multer = require ("multer")

#all environment
app.use bodyParser.urlencoded(extended: true)
app.use bodyParser.json()
app.use multer(dest: './uploads/')

# Required middleware for riak database
# get client instance (defaults to localhost:8098)
db = require ("riak-js").getClient(
  host: "localhost",
  port: "8098"
)

# Port Configuration
port = process.env.PORT or 8080

######################################
# HTML Formulary for the index webpage
# ====================================
form = "<!DOCTYPE HTML><html><body>" +
    "<form method='post' action='/upload' enctype='multipart/form-data'>" +
    "<input type='file' name='image'/>" +
    "<input type='submit' /></form>" +
    "</body></html>"

######################################
# Serves the HTML Formulary for the index webpage
# ====================================
app.get "/", (req, res) ->
  res.writeHead 200,
    "Content-Type": "text/html"
  res.end form
  return

#############################################
# Auxiliary functions
#############################################

########################################
# Saves a photo in database given a filepath
# ======================================
savePicture: (image) ->
  ###name = image.originalname
  fs.readfile image.path, 'binary', (err,picture) ->
    return
  ###
  return


########################################################
# API Routes Start
########################################################

########################################
# Retrieves all photos from the database
# GET /photos
# ======================================
app.get "/photos", (req, res) ->
  console.log "Fetching photos from database..."
  #Fetch all photos
  return


######################################
# Saves a photo in the database
# POST /photos
# ====================================
app.post "/upload", (req, res) ->
  console.log req.files
  console.log "Guardando en la BD"
  # Save the photo
  if req.is('multipart/form-data')
    # Call saveImage function
    return
  else
    console.log("Error: The payload is not an image")
    res.status(401).send("Not acceptable")
    return
  return

app.listen port
console.log "Magic happens on port " + port