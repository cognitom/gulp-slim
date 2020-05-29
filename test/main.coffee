should = require 'should'
slim = require '../coffee/'
Vinyl = require 'vinyl'
fs = require 'fs'
path = require 'path'

createFile = (slimFileName, contents) ->
  base = path.join __dirname, 'fixtures'
  filePath = path.join base, slimFileName

  new Vinyl
    cwd: __dirname
    base: base
    path: filePath
    contents: contents || fs.readFileSync filePath

describe 'gulp-slim', () ->
  describe 'slim()', () ->
    it 'should pass file when it isNull()', (done) ->
      stream = slim()
      emptyFile =
        isNull: () -> true
      stream.on 'data', (data) ->
        data.should.equal emptyFile
        done()
      stream.write emptyFile

    it 'should emit error when file isStream()', (done) ->
      stream = slim()
      streamFile =
        isNull: () -> false
        isStream: () -> true
      stream.on 'error', (err) ->
        err.message.should.equal 'Streaming not supported'
        done()
      stream.write streamFile

    it 'should compile single slim file', (done) ->
      slimFile = createFile 'test.slim'
      stream = slim()
      stream.on 'data', (htmlFile) ->
        should.exist htmlFile
        should.exist htmlFile.path
        should.exist htmlFile.relative
        should.exist htmlFile.contents
        htmlFile.path.should.equal path.join __dirname, 'fixtures', 'test.html'
        String(htmlFile.contents).should.equal fs.readFileSync path.join(__dirname, 'expect/test.html'), 'utf8'
        done()
      stream.write slimFile

    it 'should compile single slim file with pretty option', (done) ->
      slimFile = createFile 'test.slim'
      stream = slim pretty:true
      stream.on 'data', (htmlFile) ->
        should.exist htmlFile
        should.exist htmlFile.path
        should.exist htmlFile.relative
        should.exist htmlFile.contents
        htmlFile.path.should.equal path.join __dirname, 'fixtures', 'test.html'
        String(htmlFile.contents).should.equal fs.readFileSync path.join(__dirname, 'expect/test-pretty.html'), 'utf8'
        done()
      stream.write slimFile

    it 'should compile single slim file with one custom option', (done) ->
      slimFile = createFile 'test.slim'
      stream = slim options: 'attr_quote="\'"'
      stream.on 'data', (htmlFile) ->
        should.exist htmlFile
        should.exist htmlFile.path
        should.exist htmlFile.relative
        should.exist htmlFile.contents
        htmlFile.path.should.equal path.join __dirname, 'fixtures', 'test.html'
        String(htmlFile.contents).should.equal fs.readFileSync path.join(__dirname, 'expect/test-single-quotes.html'), 'utf8'
        done()
      stream.write slimFile

    it 'should compile single slim file with two custom options', (done) ->
      slimFile = createFile 'test.slim'
      stream = slim options: ['attr_quote="\'"', 'js_wrapper=:cdata']
      stream.on 'data', (htmlFile) ->
        should.exist htmlFile
        should.exist htmlFile.path
        should.exist htmlFile.relative
        should.exist htmlFile.contents
        htmlFile.path.should.equal path.join __dirname, 'fixtures', 'test.html'
        String(htmlFile.contents).should.equal fs.readFileSync path.join(__dirname, 'expect/test-single-quotes-cdata.html'), 'utf8'
        done()
      stream.write slimFile

    it 'should compile single slim file with data option', (done) ->
      slimFile = createFile 'data.slim'
      stream = slim
        data:
          name: 'Testsuite'
          list: [1,2,3]
      stream.on 'data', (htmlFile)->
        should.exist htmlFile
        should.exist htmlFile.path
        should.exist htmlFile.relative
        should.exist htmlFile.contents
        htmlFile.path.should.equal path.join __dirname, 'fixtures', 'data.html'
        String(htmlFile.contents).should.equal fs.readFileSync path.join(__dirname, 'expect/data.html'), 'utf8'
        done()
      stream.write slimFile

    it 'should compile include a slim file when include library is requried', (done) ->
      slimFile = createFile 'test_include.slim'
      stream = slim require: 'slim/include', options: 'include_dirs=[".", "test/fixtures", "test/fixtures/includes"]'
      stream.on 'data', (htmlFile) ->
        should.exist htmlFile
        should.exist htmlFile.path
        should.exist htmlFile.relative
        should.exist htmlFile.contents
        htmlFile.path.should.equal path.join __dirname, 'fixtures', 'test_include.html'
        String(htmlFile.contents).should.equal fs.readFileSync path.join(__dirname, 'expect/test_include.html'), 'utf8'
        done()
      stream.write slimFile

    it 'should compile a slim file when included file is in same directory', (done) ->
      slimFile = createFile 'test_include.slim'
      stream = slim require: 'slim/include', chdir: true
      stream.on 'data', (htmlFile) ->
        should.exist htmlFile
        should.exist htmlFile.path
        should.exist htmlFile.relative
        should.exist htmlFile.contents
        htmlFile.path.should.equal path.join __dirname, 'fixtures', 'test_include.html'
        String(htmlFile.contents).should.equal fs.readFileSync path.join(__dirname, 'expect/test_include.html'), 'utf8'
        done()
      stream.write slimFile

    it 'should include additional file with include plugin', (done) ->
      slimFile = createFile 'include.slim'
      stream = slim {
        pretty:true
        include: true
        options: "include_dirs=['.', 'test/fixtures']"
      }
      stream.on 'data', (htmlFile) ->
        should.exist htmlFile
        should.exist htmlFile.path
        should.exist htmlFile.relative
        should.exist htmlFile.contents
        htmlFile.path.should.equal path.join __dirname, 'fixtures', 'include.html'
        String(htmlFile.contents).should.equal fs.readFileSync path.join(__dirname, 'expect/include.html'), 'utf8'
        done()
      stream.write slimFile
