models = require "../models"
ShortURL = models.ShortURL
Hit = models.Hit
HitStat = models.HitStat
Helpers = models.Helpers

render_error = (res, msg) ->
  res.errors.push msg
  return res.render 'error', errors: res.errors, title: "Error"

getFullUrl = (req, doc) ->
  return "http://#{req.header('host')}/#{doc.hash}"

module.exports =
  index: (req, res) ->
    res.render 'index', title: 'Express'

  create: (req, res) ->
    res.render 'create', title: "home"

  create_post: (req, res) ->
    url = req.body.url

    analyzed = models.Helpers.analyzeUrl url

    if not analyzed.isUrl
      return res.render 'create', title: "home", error: "Not a valid url"

    # default to http if not present
    if not analyzed.hasProtocol
      url = "http://" + url

    su = new ShortURL url: url
    su.generateHash ->
      su.save ->
        res.redirect "/created/#{su.hash}"
        su.fetchTitle()

  created: (req, res, hash) ->
    ShortURL.findOne hash: hash, (err, doc) ->
      return res.redirect '/' if err

      res.render 'created',
        title: "success",
        shorturl: doc,
        fullurl: getFullUrl req, doc

  stats: (req, res, hash) ->
    ShortURL.findOne hash: hash, (err, shorturl) ->
      return render_error res, "URL does not exist [#{hash}]" if err or not shorturl

      HitStat.findOne _id: shorturl._id, (err, doc) ->
        res.render "stats",
          title: "statistics",
          shorturl: shorturl,
          stat: doc,
          fullurl: getFullUrl req, shorturl

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

  words: (req, res) ->
    words = require "../models/words"
 
    examples = []
    for x in [1..2]
      word = Helpers.random words
      wordHash = Helpers.wordHash word
      examples.push wordHash

    res.render "words",
      title: "words",
      words: words.list,
      examples: examples

  api:
    create: (req, res) ->
      url = req.body.url
      isUrl = models.Helpers.validateUrl url

      if not isUrl
        return res.json
          status: "nok",
          reason: "Provided values is not a URL"

      shorturl = new ShortURL({ url: url })
      shorturl.generateHash ->
        shorturl.save (err, doc) ->
          if err
            return res.json
              status: "nok",
              reason: err

          fullUrl = getFullUrl res, shorturl

          res.json
            status: "ok",
            value:
              hash: shorturl.hash,
              shortUrl: fullUrl,
              statUrl: "#{fullUrl}+",
              url: url

    
