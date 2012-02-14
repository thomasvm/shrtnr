helpers = require "../models/helpers"
assert = require "assert"

describe 'hash generation', ->
  describe 'generateWord', ->
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
