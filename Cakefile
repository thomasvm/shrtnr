helpers = require "./models/helpers"
spawn = require('child_process').spawn
mochacmd = if process.platform == "win32" then "mocha.cmd" else "mocha"

option '-n', '--number [NUMBER]', 'number of words to generate'

task 'tests', 'Run mocha', ->
  mocha = spawn mochacmd, ['--require', 'should', '--reporter', 'spec'], { customFds: [0,1,2] }
  mocha.on('exit', process.exit)

task 'genwords', 'Generate some word hashes', (options) ->
  number = options.number or 10
  for i in [1..number]
    console.log helpers.wordHash()

