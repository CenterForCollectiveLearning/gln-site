gulp = require 'gulp'
gutil = require 'gulp-util'

sass = require 'gulp-sass'
rename = require 'gulp-rename'
browserify = require 'gulp-browserify'
ngAnnotate =  require 'gulp-ng-annotate'
coffeelint = require 'gulp-coffeelint'
coffee = require 'gulp-coffee'
autoprefixer = require 'gulp-autoprefixer'
concat = require 'gulp-concat'
uglify = require 'gulp-uglify'
rimraf = require 'gulp-rimraf'
runSequence = require 'run-sequence'

# CONFIG ---------------------------------------------------------

isProd = gutil.env.type is 'prod'

sources =
  html: 'app/**/*.html'
  sass: 'app/styles/styles.scss'
  coffee: 'app/scripts/*.coffee'
  assets: 'app/assets/**/*'
  libjs: 'app/scripts/lib/*.js'
  libcss: 'app/styles/lib/*.css'
  data: 'app/data/**/*'

destinations =
  css: 'dist/'
  html: 'dist/'
  js: 'dist/'
  assets: 'dist/assets'
  libjs: 'dist/lib/'
  libcss: 'dist/lib'
  data: 'dist/data/'

# TASKS -------------------------------------------------------------

express = require('express')
refresh = require('gulp-livereload')
livereload = require('connect-livereload')

LIVERELOADPORT = 35729
SERVERPORT = 8000

server = express()
server.use(livereload(port: LIVERELOADPORT))
server.use(express.static('./dist'))
server.all('/*', (req, res) -> res.sendFile('index.html', root: 'dist' ))

# Compile and concatenate scripts
gulp.task('coffee', ->
  gulp.src(sources.coffee)
    .pipe(coffee({bare: true})
    .on('error', gutil.log))
    .pipe(concat('app.js'))
    .pipe(if isProd then uglify() else gutil.noop())
    .pipe(gulp.dest(destinations.js))
)

# Compile stylesheets
gulp.task('sass', ->
  gulp.src(sources.sass)
    .pipe(sass(onError: (e) -> console.log(e)))
    .pipe(autoprefixer('last 2 versions', '> 1%', 'ie 8'))
    .pipe(gulp.dest(destinations.css))
)

# Lint coffeescript
# TODO Fix this
gulp.task('lint', ->
  gulp.src(sources.coffee)
  .pipe(coffeelint())
  .pipe(coffeelint.reporter())
)

gulp.task('data', ->
  gulp.src(sources.data).pipe(gulp.dest(destinations.data))
)

gulp.task('html', ->
  gulp.src(sources.html).pipe(gulp.dest(destinations.html))
)

gulp.task('assets', ->
  gulp.src(sources.assets).pipe(gulp.dest(destinations.assets))
)

gulp.task('libjs', ->
  gulp.src(sources.libjs).pipe(gulp.dest(destinations.libjs))
)

gulp.task('libcss', ->
  gulp.src(sources.libcss).pipe(gulp.dest(destinations.libcss))
)

# Watched tasks
gulp.task('watch', ->
  server.listen(SERVERPORT)
  refresh.listen(LIVERELOADPORT)

  gulp.watch sources.data, ['data']
  gulp.watch 'app/styles/*.scss', ['sass']
  gulp.watch sources.assets, ['assets']
  gulp.watch sources.html, ['html']
  gulp.watch sources.coffee, ['coffee', 'lint']
  gulp.watch sources.libjs, ['libjs']
  gulp.watch sources.libcss, ['libcss']

  gulp.watch('./dist/**').on('change', refresh.changed);
 )

# Remove /dist directory
gulp.task('clean', ->
  gulp.src(['dist/'], read: false)
  .pipe(rimraf(force: true))
)

# Build sequence
gulp.task('build', ->
  runSequence('clean', ['coffee', 'sass', 'data', 'html', 'libjs', 'libcss', 'assets'])
)

gulp.task('default', [
  'build'
  'watch'
])