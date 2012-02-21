helpers = require "./models/helpers"
spawn = require('child_process').spawn
mochacmd = if process.platform == "win32" then "mocha.cmd" else "mocha"

option '-n', '--number [NUMBER]', 'number of words to generate'
option '-w', '--watch', 'Watch files for change and automatically recompile'

# Run tests
task 'tests', 'Run mocha', ->
  mocha = spawn mochacmd, ['--require', 'should', '--reporter', 'spec'], { customFds: [0,1,2] }
  mocha.on('exit', process.exit)

# Generate words
task 'genwords', 'Generate some word hashes', (options) ->
  number = options.number or 10
  for i in [1..number]
    console.log helpers.wordHash()

###
 Web Toolkit v0.4 (by M@ McCray)
 http://gist.github.com/515035

 NOTE: This is meant to be used as a Cakefile (Coffee's RAKE equivalent).
###

COFFEE_SRC="private/coffee"
LESS_SRC="private/less"

JS_OUT= "public/javascript"
CSS_OUT= "public/stylesheets"

options= # These will get overwritten by the commandline
  watch: no

puts = console.log

task 'compile', "Compiles all source files into dist files...", (opts) ->
  options = opts
  task_compile_js()
  task_compile_css()

task 'compile:js', "Compiles all coffee files into js files...", (opts) ->
  options = opts
  task_compile_js()

task 'compile:css', "Compiles all less files into css files...", (opts) ->
  options = opts
  task_compile_css()

fs = cs = less = exec = null

compile_to_js= (filename) ->
  temp = filename.split('/').last()
  out_filename = "#{JS_OUT}/#{ temp.replace('.coffee', '.js') }"
  try
    src = fs.readFileSync filename, 'utf8'
    js = cs.compile src
    fs.writeFileSync out_filename, js
    puts " - #{out_filename}"
  catch err
    puts " - #{out_filename}"
    puts "   ^ #{err}"

compile_to_css = (filename) ->
  temp = filename.split('/').last()
  out_filename = "#{CSS_OUT}/#{ temp.replace('.less', '.css') }"
  try
    src = fs.readFileSync filename, 'utf8'
    less.parse src, (e, tree) ->
      puts e if(e)
      fs.writeFileSync out_filename, tree.toCSS()
      puts " - #{out_filename}"
  catch err
    puts " - #{out_filename}"
    puts "   ^ #{err.message} (col #{err.column})"
    puts "     Near: #{err.extract}"

watch_file = (filename, callback)->
  return unless options.watch
  fs.watch filename, persistent:true, interval:1500 , (curr, prev) ->
    try
      callback(filename)
    catch err
      null

task_compile_js =  ->
  fs = require('fs')
  cs = require('coffee-script')
  fs.readdir COFFEE_SRC, (err, files) ->
    for file in files
      file = "#{COFFEE_SRC}/#{file}"
      compile_to_js file

task_compile_css = ->
  fs = require('fs')
  less = new require('less').Parser({
    paths: [ LESS_SRC ]
  })
  fs.readdir LESS_SRC, (err, files) ->
    for file in files
      continue if file[0] == '_'
      file = "#{LESS_SRC}/#{file}"
      compile_to_css file
      watch_file file, compile_to_css

Array::last= -> this[this.length - 1]


