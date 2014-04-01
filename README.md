# gulp-slim [![Build Status](https://travis-ci.org/cognitom/gulp-slim.svg?branch=master)](https://travis-ci.org/cognitom/gulp-slim)

Plugin to compile Slim templates for piping with [gulp](https://github.com/wearefractal/gulp). Uses [Slim](http://slim-lang.com/).


## Install

```bash
gem install slim
npm install gulp-slim --save-dev
```


## Usage

```javascript
var slim = require("slim");

gulp.task('slim', function(){
  gulp.src("./src/slim/*.slim")
    .pipe(slim({
      pretty: true
    }))
    .pipe(gulp.dest("./dist/html/"));
});
```

or write it in CoffeeScript.

```coffeescript
slim = require 'slim'

gulp.task 'slim', ->
  gulp.src './src/slim/*.slim'
  .pipe slim
    pretty: true
  .pipe gulp.dest './dist/html/'
```


## Changelog

v0.0.1 - Initial release
v0.0.2 - Add some tests
v0.0.3 - Register to npm

