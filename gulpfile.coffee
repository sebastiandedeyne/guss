# Modules
del           = require 'del'
gulp          = require 'gulp'
autoprefixer  = require 'gulp-autoprefixer'
base64        = require 'gulp-base64'
bourbon       = require 'node-bourbon'
coffee        = require 'gulp-coffee'
concat        = require 'gulp-concat'
frontmatter   = require 'gulp-front-matter'
gulpif        = require 'gulp-if'
include       = require 'gulp-include'
minifyCSS     = require 'gulp-minify-css'
rename        = require 'gulp-rename'
sass          = require 'gulp-sass'
uglify        = require 'gulp-uglify'
webserver     = require 'gulp-webserver'
path          = require 'path'
runSequence   = require 'run-sequence'
swig          = require 'swig'
through       = require 'through2'
yaml          = require 'yamljs'
{argv}        = require 'yargs'


# Load configuration
config = yaml.load 'config.yml'

# Dev environment by default
if !argv.production
  argv.dev = true


# Tasks
gulp.task 'css', ->
  sassSettings = 
    includePaths: bourbon.includePaths

  base64Settings = 
    extensions: ['svg']
    maxImageSize: 8 * 1024

  autoprefixerSettings = 
    browsers: [ 'last 2 versions' ]
    cascade: false

  if argv.debug64
    base64Settings.debug = true

  gulp.src 'css/**/*.scss'
    .pipe sass(sassSettings).on 'error', (error) ->
      console.log do error.toString
      @emit 'end'
    .pipe autoprefixer autoprefixerSettings
    .pipe gulpif !argv.dev, do minifyCSS
    .pipe base64 base64Settings
    .pipe gulp.dest(config.destination + '/css')

  gulp.src 'css/**/*.css'
    .pipe autoprefixer autoprefixerSettings
    .pipe gulpif !argv.dev, do minifyCSS
    .pipe gulp.dest(config.destination + '/css')

    
gulp.task 'js', ->
  coffeeSettings = 
    bare: true

  gulp.src [
      'js/**/*.coffee',
      '!js/**/_*.coffee'
    ]
    .pipe include()
    .pipe coffee(coffeeSettings).on 'error', (error) ->
      console.log do error.toString
      @emit 'end'
    .pipe gulpif !argv.dev, do uglify
    .pipe gulp.dest(config.destination + '/js')

  gulp.src [
    'js/**/*.js'
  ]
  .pipe include()
  .pipe gulpif !argv.dev, do uglify
  .pipe gulp.dest(config.destination + '/js')


gulp.task 'assets', ->
  gulp.src [
    'assets/**/**'
  ]
  .pipe gulp.dest(config.destination)


gulp.task 'views', ->
  siteData = config

  # Credit where credit's due:
  # http://www.rioki.org/2014/06/09/jekyll-to-gulp.html
  gulp.src [
    'views/**/*.html'
    '!views/{_*,_*/**}'
  ]
  .pipe frontmatter
    property: 'page'
    remove: true
  .pipe do ->
    through.obj (file, enc, cb) ->
      layout = file.page.layout || 'default'
      template = swig.compileFile path.join('views', '_layouts', layout + '.html')
      data =
        site: siteData
        page: file.page
      data['content'] = swig.render file.contents.toString(), { locals: data }
      file.contents = new Buffer template(data), 'utf8'
      @push file
      do cb
  .pipe rename (path) ->
    path.extname = '.html'
    if config.pretty_permalinks
      if path.basename isnt 'index'
        path.dirname = path.basename
        path.basename = 'index'
    return
  .pipe gulp.dest(config.destination)


gulp.task 'watch', ->
  console.log 'Watching for changes...'
  gulp.watch '/css/**/**', ['css']
  gulp.watch '/js/**/**', ['js']
  gulp.watch '/assets/**/**', ['assets']
  gulp.watch '/views/**/**', ['views']


gulp.task 'webserver', ->
  port = config.server_port || 8000
  gulp.src config.destination
    .pipe webserver
      port: port


gulp.task 'clean', ->
  del config.destination


gulp.task 'build', ['clean'], ->
  if argv.dev
    console.log 'Generating development build'
  else
    console.log 'Generating production build'

  del config.destination, ->
    gulp.start ['css', 'js', 'assets', 'views']


gulp.task 'serve', ['build'], ->
  gulp.start [ 'webserver', 'watch' ]
