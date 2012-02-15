mongoose = require "mongoose"

if process.env.GETSHORTY_MONGODB_URL?
  mongoose.connect process.env.GETSHORTY_MONGODB_URL
else
  mongoose.connect "mongodb://localhost/getshorty"

exports.ShortURL = require "./shorturl"
exports.Hit      = require "./hit"
exports.HitStat  = require "./hitstat"
exports.Helpers  = require "./helpers"

