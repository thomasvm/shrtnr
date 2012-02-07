mongoose = require "mongoose"
hasher = require "./hasher"
Schema = mongoose.Schema

getUtcNow = ->
  now = new Date()
  now_utc = new Date now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate(),  now.getUTCHours(), now.getUTCMinutes(), now.getUTCSeconds()

setCreated = (next) ->
  created = @emit 'get', 'created'
  if not created
    now = getUtcNow()
    console.log "Forcing created: #{now} #{@}"
    @created = now
  next()

# URL ShortURL
ShortURLName = 'ShortURL'
ShortURL = new Schema
  hash:    String,
  url:     String,
  created: Date
ShortURL.pre 'save', setCreated

ShortURL.methods.generateHash = (callback) ->
  result = hasher()

  @model(ShortURLName).findOne { hash: result }, (err, doc) =>
    if err or doc
      return @generateHash callback

    @hash = result
    callback()

# URL Hit
HitName = 'Hit'
Hit = new Schema
  url_id: Schema.ObjectId,
  created: Date
Hit.pre 'save', setCreated

# Export items
exports.ShortURL = mongoose.model ShortURLName, ShortURL
exports.Hit = mongoose.model HitName, Hit

mongoose.connect "mongodb://localhost/getshorty"
