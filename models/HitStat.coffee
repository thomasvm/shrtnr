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

HitStat.methods.formatDateString = (date) ->
  return "#{date.getFullYear()}-#{date.getMonth()}-#{date.getDate()}"

module.exports = mongoose.model 'HitStat', HitStat

