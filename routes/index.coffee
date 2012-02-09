models = require "../models"
ShortURL = models.ShortURL
Hit = models.Hit
HitStat = models.HitStat

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
  ShortURL.findOne hash: hash, (err, shorturl) ->
    return res.redirect '/error' if err or not shorturl

    HitStat.findOne _id: shorturl._id, (err, doc) ->
      res.write "stats #{doc.value.count}"
      res.end()

exports.redirect = (req, res, hash) ->
  ShortURL.findOne hash: hash, (err, doc) ->
    return res.redirect '/error' if err or not doc

    referer = req.header('Referer')

    hit = new Hit url_id: doc._id, referer: referer
    hit.save ->
      # start job to generate stats
      Hit.generateHitStats(doc._id)

      # redirect
      return res.redirect doc.url
  
