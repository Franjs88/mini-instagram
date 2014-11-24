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

# Passport middleware required for session management
#session = require ("express-session")
cookieParser = require("cookie-parser")
pass = require ("./aux/User")
user= new pass
passport = user.get()

# Required middleware for riak database
# get client instance (defaults to localhost:8098)
db = require("riak-js").getClient(
  host: "localhost"
  port: "8098"
)

app.use("/", #the URL through which access to static content
  express.static(__dirname) #Serves all content from current directory
)

#all environment
app.use cookieParser()
app.use bodyParser.urlencoded(extended: true)
app.use bodyParser.json()
app.use multer(dest: './uploads/')
###app.use session({
  secret: 'keyboard cat',
  resave: false,
  saveUninitialized: true
})###
app.use passport.initialize()
app.use passport.session()

# Port Configuration
port = process.env.PORT or 8080

########################################################
# API Routes Start
########################################################

######################################
# Register a new user into the system
# POST /signup
# ====================================
app.post "/signup", (req, res) ->
  console.log "El body vale: "+util.inspect(req.body)
  if(req.body != null && req.body != undefined )
    username = req.body.username
    passw = req.body.password
    user.register(username, passw, ->
      console.log "Creado user con username: "+username
      res.status(201).send("Created",username)
      return
    )
  else
    res.status(401).send("Not acceptable")
  return



######################################
# Logs a user into the system
# POST /login
# ====================================
app.post "/login", passport.authenticate("local"), (req,res) ->
  console.log "autenticado exito"
  res.redirect("/Dashboard.html/")

########################################
# Retrieves all photos from the database
# GET /photos
# ======================================
app.get "/photos", (req,res) ->
  return


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
      res.status(200).send("Ok",res.body)
    else
      res.status(404).send("Not Found")
    return
  )


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
  else
    console.log("Error: The payload is not an image")
    res.status(401).send("Not acceptable")
  return

app.listen port
console.log "Magic happens on port " + port


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