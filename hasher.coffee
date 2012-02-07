CHARS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".split("")

defaultLength = 6

randomChar= ->
  random = Math.floor ( Math.random() * CHARS.length )
  return CHARS[random]

generateHash = (length= defaultLength) ->
  result = []
  for i in [1..length]
    char = randomChar()
    result.push char

  return result.join ""

module.exports = generateHash
  
