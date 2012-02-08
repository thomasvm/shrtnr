mongoose = require "mongoose"
exports.ShortURL = require "./ShortURL"
exports.Hit      = require "./Hit"

mongoose.connect "mongodb://localhost/getshorty"
