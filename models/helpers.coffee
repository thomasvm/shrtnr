words = require "./words"

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

class SimpleHasher
  @hash = (length= defaultLength) ->
    result = []
    for i in [1..length]
      char = random CHARS
      result.push char
  
    return result.join ""

# Word Hashing 
class WordHasher
  @toLeet = (letter, leet = words.leet) ->
    possibilities = [ letter.toUpperCase(), letter.toLowerCase() ]
  
    if leet[letter] != undefined
      possibilities = possibilities.concat leet[letter]
  
    return random possibilities
  
  @hash = (wordList = words.list)->
    result = []
  
    word = random wordList
    result.push @toLeet(i) for i in word
   
    return result.join ""

# Validate Url  
validateUrl = (url) ->
  # shameless rip of https://github.com/chriso/node-validator/blob/master/lib/validator.js 
  match = url.match /^(?:(?:ht|f)tp(?:s?)\:\/\/|~\/|\/)(?:\w+:\w+@)?((?:(?:[-\w\d{1-3}]+\.)+(?:com|org|net|gov|mil|biz|info|mobi|name|aero|jobs|edu|co\.uk|ac\.uk|it|fr|tv|museum|asia|local|travel|[a-z]{2}))|((\b25[0-5]\b|\b[2][0-4][0-9]\b|\b[0-1]?[0-9]?[0-9]\b)(\.(\b25[0-5]\b|\b[2][0-4][0-9]\b|\b[0-1]?[0-9]?[0-9]\b)){3}))(?::[\d]{1,5})?(?:(?:(?:\/(?:[-\w~!$+|.,=]|%[a-f\d]{2})+)+|\/)+|\?|#)?(?:(?:\?(?:[-\w~!$+|.,*:]|%[a-f\d{2}])+=?(?:[-\w~!$+|.,*:=]|%[a-f\d]{2})*)(?:&(?:[-\w~!$+|.,*:]|%[a-f\d{2}])+=?(?:[-\w~!$+|.,*:=]|%[a-f\d]{2})*)*)*(?:#(?:[-\w~!$ |\/.,*:;=]|%[a-f\d]{2})*)?$/i
  return match isnt null && url.length <= 2083

# Export 
exports.boringHash = SimpleHasher.hash

exports.wordHash = WordHasher.hash
exports.toLeet = WordHasher.toLeet

exports.generateHash = WordHasher.hash
exports.validateUrl = validateUrl
exports.random = random
