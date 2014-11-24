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

class User
  @_passport

  constructor: () ->
    @_passport = require ("passport")
    LocalStrategy = require("passport-local").Strategy

    @_passport.serializeUser (user, done) ->
      done null, user
      return

    @_passport.deserializeUser (obj, done) ->
      done null, obj
      return

    @_passport.use new LocalStrategy({usernameField: 'username', passwordField: 'password'},(username, password, done) ->
      # We retrieve the user from database
      needle.get("http://localhost:8098/buckets/users/keys/"+username, (error, response) ->
        if (!error && response.statusCode == 200)
          console.log "El usuario encontrado es "+response
          # We check password
          if (response.password == password)
            # we call passport's done function with the username of the user found
            done null, response.key
          else
            done null, false, {message: "Incorrect password"}
        else
          done null, false, {message: "Incorrect username"}
      )
    )

  ########################################
  # Register a new user into the system
  # ======================================
  register: (username, passw, callback) ->
    console.log "Registrando a :"+username+" con password :"+passw
    db.save("users",username,{"password": passw})
    return callback()

  signIn: (username, passw, callback) ->
    passport.authenticate("local", (req,res) ->
      # If this function gets called, authentication was successful.
        res.redirect("/Dashboard/")#+req.user.username)
    )

    return

module.exports = User


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
# Register a new user into the system
# POST /signup
# ====================================
app.post "/signup", (req, res) ->
  console.log "El body vale: "+util.inspect(req.body)
  if(req.body != null && req.body != undefined )
    user = new User()
    user.register(req.body.username, req.body.password, ->
      console.log "Creado user con username: "+req.body.username
      res.status(201).send("Created",req.body.username)
    )
  else
    res.status(401).send("Not acceptable")
    return
  return

######################################
# Logs a user into the system
# POST /login
# ====================================
app.post "/login", (req, res) ->
  if(req.body != null && req.body != undefined)
    console.log "Alguien trata de loguearse con username "+req.body.username+" y pass: "+req.body.password
    login = new User()
    return
  else
    console.log "El cuerpo llega vacio"
    return res.status(501).send("Internal Error")
  return

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