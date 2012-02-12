mongoose = require "mongoose"

if process.env.GETSHORTY_MONGODB_URL?
  mongoose.connect process.env.GETSHORTY_MONGODB_URL
else
  mongoose.connect "mongodb://localhost/getshorty"

exports.ShortURL = require "./ShortURL"
exports.Hit      = require "./Hit"
exports.HitStat  = require "./HitStat"
exports.Helpers  = require "./helpers"

