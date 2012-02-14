WORDS = require "./words"

exports.getUtcNow = ->
  now = new Date()
  now_utc = new Date now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate(),  now.getUTCHours(), now.getUTCMinutes(), now.getUTCSeconds()

exports.setCreated = (next) ->
  created = @emit 'get', 'created'
  if not created
    now = exports.getUtcNow()
    @created = now
  next()

random = (items) ->
  index = Math.floor ( Math.random() * items.length )
  return items[index]

# Random Letter Hashing  
CHARS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".split("")

defaultLength = 6

boringHash = (length= defaultLength) ->
  result = []
  for i in [1..length]
    char = random CHARS
    result.push char

  return result.join ""

# Word Hashing 
upOrDown = (letter) ->
  f = random [String.prototype.toUpperCase, String.prototype.toLowerCase]
  return f.apply letter

wordHash = (words = WORDS)->
  result = []

  word = random words
  result.push upOrDown(i) for i in word
 
  return result.join ""

# Export 
exports.generateHash = boringHash

exports.boringHash = boringHash
exports.wordHash = wordHash
