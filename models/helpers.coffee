exports.getUtcNow = ->
  now = new Date()
  now_utc = new Date now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate(),  now.getUTCHours(), now.getUTCMinutes(), now.getUTCSeconds()

exports.setCreated = (next) ->
  created = @emit 'get', 'created'
  if not created
    now = exports.getUtcNow()
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
  
