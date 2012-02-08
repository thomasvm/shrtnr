mongoose = require "mongoose"
helpers  = require "./helpers"
Schema   = mongoose.Schema

HitName = 'Hit'
Hit = new Schema
  url_id: Schema.ObjectId,
  created: Date
Hit.pre 'save', helpers.setCreated

module.exports = mongoose.model HitName, Hit
