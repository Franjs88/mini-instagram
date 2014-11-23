#
# This is the Main Server for Mini-Instagram application
# More Info:
# http://liamkaufman.com/blog/2012/03/01/why-riak-and-nodejs-make-a-great-pair/
#

express = require("express")
app = express()
expressValidator = require ("express-validator")
bodyParser = require("body-parser")
multer = require ("multer")
fs = require ("fs")
util = require ("util")


# Required middleware for riak database
# get client instance (defaults to localhost:8098)
db = require("riak-js").getClient(
  host: "localhost"
  port: "8098"
)

#all environment
app.use bodyParser.urlencoded(extended: true)
app.use bodyParser.json()
app.use multer(dest: './uploads/')

# Port Configuration
port = process.env.PORT or 8080


app.use("/", #the URL through which access to static content
  express.static(__dirname) #Serves all content from current directory
)

class Picture

  ########################################
  # Saves a photo in database given a filepath
  # ======================================
  save: (image, callback) ->
    console.log "Guardando en la BD la imagen: " + image.path
    key = image.originalname
    db.save("photos",key,image)
    console.log "Guardado: "+key+" en photos"
    return callback()

module.exports = Picture

######################################
# Login action
# ====================================
app.post "/signin", (req, res) ->
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
app.post "/photos", (req, res) ->
  console.log req.files
  picture = new Picture()
  if req.is('multipart/form-data')
    picture.save(req.files, ->
      res.status(201).send("Created")
      return
    )
    return
  else
    console.log("Error: The payload is not an image")
    res.status(401).send("Not acceptable")
    return
  return

app.listen port
console.log "Magic happens on port " + port