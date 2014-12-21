gulp   = require 'gulp'
coffee = require 'gulp-coffee'
slim   = require './coffee/'

gulp.task 'coffee', ->
  gulp.src './coffee/index.coffee'
  .pipe coffee()
  .pipe gulp.dest './'

gulp.task 'test', ->
  gulp.src 'test/fixtures/test.slim'
  .pipe slim pretty:true
  .pipe gulp.dest './temp/'

gulp.task 'test-error', ->
  gulp.src 'test/fixtures/error.slim'
  .pipe slim()
  .pipe gulp.dest './temp/'
