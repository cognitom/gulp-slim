# gulp-slim

Plugin to compile Slim templates for piping with [gulp](https://github.com/wearefractal/gulp). Uses [Slim](http://slim-lang.com/).


## Usage

```javascript
var slim = require("slim");

gulp.src("./src/slim/*.slim")
  .pipe(slim({
    pretty: true
  }))
  .pipe(gulp.dest("./dist/html/"));
```

```coffeescript
slim = require 'slim'

gulp.src './src/slim/*.slim'
.pipe slim
  pretty: true
.pipe gulp.dest './dist/html/'
```


## Changelog

v0.0.1 - Initial Release

