
needle = require ("needle")

class User
  @_passport

  constructor: () ->
    console.log "Construc"
    @_passport = require ("passport")
    LocalStrategy = require("passport-local").Strategy

    console.log "s1"
    @_passport.serializeUser (user, done) ->
      console.log "serial"
      done null, user
      return

    console.log "ds1"
    @_passport.deserializeUser (obj, done) ->
      console.log "deserial"
      done null, obj
      return

    console.log "strat"
    @_passport.use new LocalStrategy({usernameField: 'username', passwordField: 'password'},(username, password, done) ->
      # We retrieve the user from database
      console.log "Entra en Local con"
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

        return
      )
      return
    )

  ########################################
  # Register a new user into the system
  # ======================================
  register: (username, passw, callback) ->
    console.log "Registrando a :"+username+" con password :"+passw
    db.save("users",username,{"password": passw})
    callback()
    return

  get: ->
    @_passport

module.exports = User