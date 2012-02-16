helpers = require "../models/helpers"
words = require "../models/words"
assert = require "assert"

describe 'helpers', ->
  describe '#generateWord', ->
    describe 'default', ->
      it 'should return a value', ->
        value = helpers.wordHash()
        assert.notEqual 0, value.length
    
    describe 'with own array', ->
      testWords = ['test']
      it 'should return a value', ->
        value = helpers.wordHash(testWords)
        assert.notEqual 0, value.length

      it 'should be casing of value', ->
        value = helpers.wordHash(testWords)
        assert.equal value.toLowerCase(), testWords[0]

    describe 'calculate possibilities', ->
      it 'should be big enough', ->
        count = 0
        for word in words.list
          count += Math.pow 2, word.length
        count.should.be.above 1100
        console.log "It's #{count}"
        
