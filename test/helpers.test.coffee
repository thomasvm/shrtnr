helpers = require "../models/helpers"
words = require "../models/words"
assert = require "assert"
should = require "should"

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
        # disable leet
        old = words.leet
        words.leet = {}

        # test
        value = helpers.wordHash(testWords)
        assert.equal value.toLowerCase(), testWords[0]

        # reset leet
        words.leet = old

    describe 'calculate possibilities', ->
      describe 'without leet', ->
        it "should be above 2400", ->
          count = 0
          for word in words.list
            count += Math.pow 2, word.length

          console.log "Its #{count}"
          count.should.be.above 2400

      describe "with leet", ->
        it 'should be big enough', ->
          count = 0
          leet = words.leet

          for word in words.list
            wordCount = 1
            # Loop words
            for c in word
              letterCount = 2
              if leet[c]
                letterCount += leet[c].length
              # multiple with possibilities
              wordCount *= letterCount
            # add value for word
            count += wordCount

          console.log "It's #{count}"
          count.should.be.above 40000

  describe "#toLeet", ->
    describe 'no leet', ->
      it 'should return upper or lower', ->
        value = helpers.toLeet('a', {})
        ['a', 'A'].should.include value

    describe 'with leet chars', ->
      it 'should sometimes give extra value', ->
        value = ''
        count = 0
        value = helpers.toLeet 'a', { a: [ '4' ]} until value is '4' or count++ >= 50
        value.should.equal '4'

  describe "#validateUrl", ->
    describe 'without protocol', ->
      it 'should return be false', ->
        isValid = helpers.validateUrl "nodester.com"
        isValid.should.be.false
    describe 'with protocol', ->
      it 'should return be true', ->
        isValid = helpers.validateUrl "http://nodester.com"
        isValid.should.be.true

  describe "#analyzeUrl", ->
    describe 'without protocol', ->
      result = helpers.analyzeUrl "nodester.com"
      it 'should be valid', ->
        result.isUrl.should.be.true
      it 'should indicate no protocol', ->
        result.hasProtocol.should.be.false

    describe 'with protocol', ->
      result = helpers.analyzeUrl "http://nodester.com"
      it 'should be valid', ->
        result.isUrl.should.be.true
      it 'should indicate protocol', ->
        result.hasProtocol.should.be.true
        
