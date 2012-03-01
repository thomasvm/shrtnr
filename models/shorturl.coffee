mongoose = require "mongoose"
helpers  = require "./helpers"
Schema   = mongoose.Schema

# URL ShortURL
ShortURL = new Schema
  hash:    { type: String, unique: true },
  url:     String,
  title:   String,
  created: Date
ShortURL.pre 'save', helpers.setCreated
ShortURL.pre 'save', helpers.setCreated

ShortURL.methods.generateHash = (callback) ->
  result = helpers.generateHash()

  @collection.findOne { hash: result }, (err, doc) =>
    if err or doc
      return @generateHash callback

    @hash = result
    callback()

ShortURL.methods.fetchTitle = (next) ->
  client = require "scoped-http-client"
  findTitle = (err, resp, body) =>
    match = /<title>(.+)<\/title>/g.exec body
    return if not match
      
    @title = match[1]
    @save()

  req = client.create @url
  req.get() findTitle

# Export items
module.exports = mongoose.model 'ShortURL', ShortURL

