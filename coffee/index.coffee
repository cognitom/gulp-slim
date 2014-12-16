spawn = require('spawn-cmd').spawn
through  = require 'through2'
gutil = require 'gulp-util'

PLUGIN_NAME = 'gulp-slim'

module.exports = (options = {}) ->

  # build a command with arguments
  cmnd = 'slimrb'
  args = []

  if options.bundler
    cmnd = 'bundle'
    args = ['exec', 'slimrb']

  args.push '-s' # read input from standard input
  args.push '-p' if options.pretty
  args.push '-e' if options.erb
  args.push '-c' if options.compile
  args.push '-r' if options.rails
  args.push '-t' if options.translator
  args.push '-l' if options.logicLess

  if options.options
    if options.options.constructor is Array
      options.options.forEach (opt) ->
        args.push "-o"
        args.push opt
    else if options.options.constructor is String
      args.push '-o'
      args.push options.options

  through.obj (file, encoding, callback) ->

    if file.isNull()
      @push file
      return callback()

    if file.isStream()
      @emit 'error', new gutil.PluginError PLUGIN_NAME, 'Streaming not supported'
      return callback()

    # relace the extension
    original_file_path = file.path
    ext = if options.erb then '.erb' else '.html'
    file.path = gutil.replaceExtension file.path, ext

    program = spawn cmnd, args

    # create buffer
    b = new Buffer 0
    eb = new Buffer 0

    # add data to buffer
    program.stdout.on 'readable', =>
      while chunk = program.stdout.read()
        b = Buffer.concat [b, chunk], b.length + chunk.length

    # return data
    program.stdout.on 'end', =>
      file.contents = b
      @push file
      callback()

    # Handle errors
    program.stderr.on 'readable', =>
      while chunk = program.stderr.read()
        eb = Buffer.concat [eb, chunk], eb.length + chunk.length

    program.stderr.on 'end', =>
      if eb.length > 0
        console.log("Slim error in file (" + original_file_path + "):\n" + eb)
        process.exit(1)

    # pass data to standard input
    program.stdin.write file.contents, =>
      program.stdin.end()
