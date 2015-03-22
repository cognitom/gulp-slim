# gulp-slim [![Build Status](https://travis-ci.org/cognitom/gulp-slim.svg?branch=master)](https://travis-ci.org/cognitom/gulp-slim)

A [Slim](http://slim-lang.com/) plugin for [gulp](https://github.com/wearefractal/gulp).


## Install

```bash
gem install slim
npm install gulp-slim --save-dev
```


## Usage

```javascript
var gulp = require("gulp");
var slim = require("gulp-slim");

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
gulp = requier 'gulp'
slim = require 'gulp-slim'

gulp.task 'slim', ->
  gulp.src './src/slim/*.slim'
  .pipe slim pretty: true
  .pipe gulp.dest './dist/html/'
```


## Options

The options are the same as what's supported by `slimrb`.

- `pretty: true`
- `erb: true`
- `compile: true`
- `rails: true`
- `translator: true`
- `logicLess: true`

Set `bundler: true` to invoke `slimrb` via bundler.

You can require one of the [plug-ins](https://github.com/slim-template/slim/blob/master/README.md#plugins) available with Slim with the ```require``` key. Value can be ```string``` or ```array```.
```javascript
slim({
  require: 'slim/include'
  options: 'include_dirs=[".", "common/includes", "./includes"]'
})

slim({
  require: ['slim/include', 'slim/logic_less']
})
```
Note that when using slim/include you will likely need to use the 'include_dirs' option (as outlined above).  See the tests on how to configure include directories with the [inclulde partials plugin](https://github.com/slim-template/slim/blob/master/doc/include.md).

You can also add [custom options](https://github.com/slim-template/slim/blob/master/README.md#available-options) with ```options``` key. Value can be ```string``` or ```array```.

```javascript
slim({
  pretty: true,
  options: 'attr_quote="\'"'
})

slim({
  pretty: true,
  options: ['attr_quote="\'"', 'js_wrapper=:cdata']
})
```


## Some Scenarios

### With AngularJS

If you want to compile such a source.

```slim
doctype html
html ng-app="app" 
  head
  body ng-controller="YourController as ctrl"
    p {{ desc }}
    p
      | {{ something }}
      a ng-href="https://github.com/{{ user }}"

```

You need to specify a `attr_list_delims`. (or `attr_delims` if you use slimrb previous to 2.1.0)

```javascript
var gulp = require("gulp");
var slim = require("gulp-slim");

gulp.task('slim', function(){
  gulp.src("./src/slim/*.slim")
    .pipe(slim({
      pretty: true,
      options: "attr_list_delims={'(' => ')', '[' => ']'}"
    }))
    .pipe(gulp.dest("./dist/html/"));
});
```


### With Another Encoding

For example, if `slimrb`'s default is `US-ASCII` but you want to compile a source in `utf-8`, then use `encoding` option.

```javascript
var gulp = require("gulp");
var slim = require("gulp-slim");

gulp.task('slim', function(){
  gulp.src("./src/slim/*.slim")
    .pipe(slim({
      pretty: true,
      options: "encoding='utf-8'"
    }))
    .pipe(gulp.dest("./dist/html/"));
});

```
