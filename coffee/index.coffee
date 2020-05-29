spawn       = require('spawn-cmd').spawn
through     = require 'through2'
replaceExt = require 'replace-ext'
path        = require 'path'
PluginError = require 'plugin-error'

PLUGIN_NAME = 'gulp-slim'

module.exports = (options = {}) ->

  # build a command with arguments
  cmnd = 'slimrb'
  args = []
  spawn_options = {}

  if options.bundler
    cmnd = 'bundle'
    args = ['exec', 'slimrb']

  args.push '-s' # read input from standard input
  args.push '-p' if options.pretty
  args.push '-e' if options.erb
  args.push '-c' if options.compile
  args.push '--rails' if options.rails

  if options.translator
    args.push '-r'
    args.push 'slim/translator'

  if options.logicLess
    args.push '-r'
    args.push 'slim/logic_less'

  if options.include
    args.push '-r'
    args.push 'slim/include'

  if options.data
    args.push '--locals'
    args.push JSON.stringify options.data

  if options.require
    if options.require.constructor is Array
      options.require.forEach (lib) ->
        args.push '-r'
        args.push lib
    else if options.require.constructor is String
        args.push '-r'
        args.push options.require

  if options.options
    if options.options.constructor is Array
      options.options.forEach (opt) ->
        args.push "-o"
        args.push opt
    else if options.options.constructor is String
      args.push '-o'
      args.push options.options

  spawn_options.env = options.environment if options.environment

  through.obj (file, encoding, callback) ->

    if file.isNull()
      return callback null, file

    if file.isStream()
      return callback new PluginError PLUGIN_NAME, 'Streaming not supported'

    # relace the extension
    original_file_path = file.path
    ext = if options.erb then '.erb' else '.html'
    file.path = replaceExt file.path, ext

    spawn_options.cwd = path.dirname(file.path) if options.chdir

    program = spawn cmnd, args, spawn_options

    # create buffer
    b = new Buffer 0
    eb = new Buffer 0

    # add data to buffer
    program.stdout.on 'readable', ->
      while chunk = program.stdout.read()
        b = Buffer.concat [b, chunk], b.length + chunk.length

    # return data
    program.stdout.on 'end', ->
      file.contents = b
      callback null, file

    # handle errors
    program.stderr.on 'readable', ->
      while chunk = program.stderr.read()
        eb = Buffer.concat [eb, chunk], eb.length + chunk.length

    program.stderr.on 'end', ->
      if eb.length > 0
        err = eb.toString()
        msg = "Slim error in file (#{original_file_path}):\n#{err}"
        return callback new PluginError PLUGIN_NAME, msg

    # pass data to standard input
    program.stdin.write file.contents, ->
      program.stdin.end()
