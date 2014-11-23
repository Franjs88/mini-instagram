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
needle = require ("needle")


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
    console.log "Guardando en la BD la imagen: " + util.inspect(image)
    # We read the file
    fs.readFile(image.path, (err, data) ->
      if (err)
        console.log err
        throw err
      else
        key = image.originalname
        # We save the picture in the database
        db.save("pruebas",key,data,{encodeUri: true, contentType: "image/png"})
        console.log "Guardado: "+key+" en photos con data: "
        return callback(key)
    )

module.exports = Picture


########################################################
# API Routes Start
########################################################

######################################
# Login action
# ====================================
app.post "/signin", (req, res) ->
  return

########################################
# Retrieves all photos from the database
# GET /photos
# ======================================


########################################
# Retrieves a specified photo from the database
# GET /photos/:idPicture
# ======================================
app.get "/photos/:idPicture", (req, res) ->
  console.log "Fetching photos from database..."
  #Fetch all photos
  param = req.params.idPicture
  needle.get("http://localhost:8098/buckets/photos/keys/"+param, (error, response) ->
    if (!error && response.statusCode == 200)
      return res.status(200).send("Ok",res.body)
    else
      return res.status(404).send("Not Found")
  )
  return


######################################
# Publish a new picture in Mini-Instagram
# POST /photos
# ====================================
app.post "/photos", (req, res) ->
  console.log req.files
  if req.is('multipart/form-data')
    picture = new Picture()
    picture.save(req.files.image, (key)->
      # We send the key that we've just created
      res.status(201).send("Created", key)
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