mongoose = require "mongoose"
helpers  = require "./helpers"
Schema   = mongoose.Schema

# URL ShortURL
ShortURL = new Schema
  hash:    { type: String, unique: true },
  url:     String,
  created: Date
ShortURL.pre 'save', helpers.setCreated

ShortURL.methods.generateHash = (callback) ->
  result = helpers.generateHash()

  @collection.findOne { hash: result }, (err, doc) =>
    if err or doc
      return @generateHash callback

    @hash = result
    callback()

# Export items
module.exports = mongoose.model 'ShortURL', ShortURL

