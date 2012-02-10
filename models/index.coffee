mongoose = require "mongoose"
mongoose.connect "mongodb://localhost/getshorty"

exports.ShortURL = require "./ShortURL"
exports.Hit      = require "./Hit"
exports.HitStat  = require "./HitStat"
exports.Helpers  = require "./helpers"

