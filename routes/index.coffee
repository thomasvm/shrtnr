models = require "../models"
ShortURL = models.ShortURL
Hit = models.Hit

exports.index = (req, res) ->
  res.render 'index', title: 'Express'

exports.create = (req, res) ->
  res.render 'create', title: "Create"

exports.create_post = (req, res) ->
  su = new ShortURL url: req.body.url
  su.generateHash ->
    su.save ->
      res.redirect '/'

exports.stats = (req, res, hash) ->
  res.render 'stats'

exports.redirect = (req, res, hash) ->
  ShortURL.findOne hash: hash, (err, doc) ->
    return res.redirect '/error' if err or not doc

    hit = new Hit url_id: doc._id
    hit.save ->
      return res.redirect doc.url
  
