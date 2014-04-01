{spawn} = require 'child_process'
gulp = require 'gulp'
gutil = require 'gulp-util'
coffee = require 'gulp-coffee'

gulp.task 'coffee', ->
  gulp.src './coffee/index.coffee'
  .pipe coffee()
  .pipe gulp.dest './'

gulp.task 'test', ->
  spawn 'node_modules/.bin/mocha', [
    '--compilers', 'coffee:coffee-script'
    '--require', 'coffee-script/register'
    '-R', 'spec'
  ], stdio: 'inherit'
  .on 'close', (code) -> gutil.log 'Test done!' if code == 0