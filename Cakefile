spawn = require('child_process').spawn
mochacmd = if process.platform == "win32" then "mocha.cmd" else "mocha"

task 'tests', 'Run mocha', ->
  mocha = spawn mochacmd, ['--require', 'should', '--reporter', 'spec'], { customFds: [0,1,2] }
  mocha.on('exit', process.exit)

