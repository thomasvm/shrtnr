mongoose = require "mongoose"
Hit = require "./hit"
Schema   = mongoose.Schema

HitStat = new Schema
  url_id: Schema.ObjectId
  value:
    count: Number,
    dates: [
      created: Date,
      count: Number
    ]

module.exports = mongoose.model 'HitStat', HitStat

