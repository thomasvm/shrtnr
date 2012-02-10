exports.getUtcNow = ->
  now = new Date()
  now_utc = new Date now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate(),  now.getUTCHours(), now.getUTCMinutes(), now.getUTCSeconds()

exports.setCreated = (next) ->
  created = @emit 'get', 'created'
  if not created
    now = exports.getUtcNow()
    console.log "Forcing created: #{now} #{@}"
    @created = now
  next()

CHARS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".split("")

defaultLength = 6

randomChar= ->
  random = Math.floor ( Math.random() * CHARS.length )
  return CHARS[random]

exports.generateHash = (length= defaultLength) ->
  result = []
  for i in [1..length]
    char = randomChar()
    result.push char

  return result.join ""

exports.validateUrl = (url) ->
  # shameless rip of https://github.com/chriso/node-validator/blob/master/lib/validator.js 
  return url.match /^(?:(?:ht|f)tp(?:s?)\:\/\/|~\/|\/)?(?:\w+:\w+@)?((?:(?:[-\w\d{1-3}]+\.)+(?:com|org|net|gov|mil|biz|info|mobi|name|aero|jobs|edu|co\.uk|ac\.uk|it|fr|tv|museum|asia|local|travel|[a-z]{2}))|((\b25[0-5]\b|\b[2][0-4][0-9]\b|\b[0-1]?[0-9]?[0-9]\b)(\.(\b25[0-5]\b|\b[2][0-4][0-9]\b|\b[0-1]?[0-9]?[0-9]\b)){3}))(?::[\d]{1,5})?(?:(?:(?:\/(?:[-\w~!$+|.,=]|%[a-f\d]{2})+)+|\/)+|\?|#)?(?:(?:\?(?:[-\w~!$+|.,*:]|%[a-f\d{2}])+=?(?:[-\w~!$+|.,*:=]|%[a-f\d]{2})*)(?:&(?:[-\w~!$+|.,*:]|%[a-f\d{2}])+=?(?:[-\w~!$+|.,*:=]|%[a-f\d]{2})*)*)*(?:#(?:[-\w~!$ |\/.,*:;=]|%[a-f\d]{2})*)?$/i or url.length > 2083
