# gulp-slim

Plugin to compile Slim templates for piping with [gulp](https://github.com/wearefractal/gulp). Uses [Slim](http://slim-lang.com/).


## Install

This plugin has not been published in npm yet. 

```bash
gem install slim
npm install git://github.com/cognitom/gulp-slim.git --save-dev
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

v0.0.1 - Initial Release

