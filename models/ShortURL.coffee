mongoose = require "mongoose"
helpers  = require "./helpers"
Schema   = mongoose.Schema

# URL ShortURL
ShortURLName = 'ShortURL'
ShortURL = new Schema
  hash:    String,
  url:     String,
  created: Date
ShortURL.pre 'save', helpers.setCreated

ShortURL.methods.generateHash = (callback) ->
  result = helpers.generateHash()

  @model(ShortURLName).findOne { hash: result }, (err, doc) =>
    if err or doc
      return @generateHash callback

    @hash = result
    callback()

# URL Hit
# Export items
module.exports = mongoose.model ShortURLName, ShortURL

