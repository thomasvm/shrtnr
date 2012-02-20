models = require "../models"
ShortURL = models.ShortURL
Hit = models.Hit
HitStat = models.HitStat

render_error = (res, msg) ->
  res.errors.push msg
  return res.render 'error', errors: res.errors, title: "Error"

module.exports =
  index: (req, res) ->
    res.render 'index', title: 'Express'

  create: (req, res) ->
    res.render 'create', title: "Create"

  create_post: (req, res) ->
    url = req.body.url
    isUrl = models.Helpers.validateUrl url

    if not isUrl
      return res.render 'create', title: "Create", error: "Not a valid url"

    su = new ShortURL url: url
    su.generateHash ->
      su.save ->
        res.redirect "/created/#{su.hash}"

  created: (req, res, hash) ->
    ShortURL.findOne hash: hash, (err, doc) ->
      return res.redirect '/' if err

      res.render 'created',
        title: "Created a short url",
        shorturl: doc

  stats: (req, res, hash) ->
    ShortURL.findOne hash: hash, (err, shorturl) ->
      return render_error res, "URL does not exist [#{hash}]" if err or not shorturl

      HitStat.findOne _id: shorturl._id, (err, doc) ->
        res.render "stats",
          title: "Statistics",
          shorturl: shorturl, stat: doc

  redirect: (req, res, hash) ->
    ShortURL.findOne hash: hash, (err, doc) ->
      return render_error res, "URL does not exist [#{hash}]" if err or not doc

      referer = req.header('Referer')

      hit = new Hit url_id: doc._id, referer: referer
      hit.save ->
        # start job to generate stats
        Hit.generateHitStats(doc._id)

        # redirect
        return res.redirect doc.url
    
