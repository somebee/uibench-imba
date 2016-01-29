'use strict';
var gulp = require('gulp');
var gutil = require('gulp-util');
var webpack = require('webpack');
var WebpackDevServer = require('webpack-dev-server');
var ghPages = require('gulp-gh-pages');
var path = require('path');

gulp.task('html', function() {
  gulp.src('web/index.html')
      .pipe(gulp.dest('build'));
});

gulp.task('build', function(callback) {
  var cfg = {
    entry: ['./web/src/main.imba'],
    output: {
      path: path.join(__dirname, 'web'),
      filename: 'bundle.js'
    },
    resolve: {
      extensions: ['', '.js', '.imba']
    },
    module: {
      loaders: [{
        test: /\.imba?$/,
        exclude: /(node_modules)/,
        loaders: ['imba-loader']
      }]
    },
    plugins: [
      new webpack.NoErrorsPlugin(),
      new webpack.DefinePlugin({'process.env': {NODE_ENV: JSON.stringify('production')}}),
      new webpack.optimize.DedupePlugin(),
      new webpack.optimize.UglifyJsPlugin()
    ]
  };

  webpack(cfg, function(err, stats) {
    if (err) throw new gutil.PluginError('build', err);
    gutil.log('[build]', stats.toString({colors: true}));
    callback();
  });
});


gulp.task('serve', function(callback) {
  var cfg = {
    entry: [
      'webpack-dev-server/client?http://0.0.0.0:8081',
      './web/src/main.imba'
    ],
    devtool: 'eval',
    debug: true,
    output: {
      path: path.join(__dirname, 'build'),
      filename: 'bundle.js'
    },
    resolve: {
      extensions: ['', '.js', '.imba']
    },
    module: {
      loaders: [{
        test: /\.imba?$/,
        exclude: /(node_modules)/,
        loaders: ['imba-loader']
      }]
    },
    plugins: [
      new webpack.NoErrorsPlugin(),
      new webpack.DefinePlugin({'process.env': {NODE_ENV: JSON.stringify('production')}}),
      new webpack.optimize.DedupePlugin(),
      new webpack.optimize.UglifyJsPlugin()
    ]
  };

  new WebpackDevServer(webpack(cfg), {
    contentBase: './',
    stats: {
      colors: true
    }
  }).listen(8081, '0.0.0.0', function (err) {
    if (err) throw new gutil.PluginError('webpack-dev-server', err);
    gutil.log('[serve]', 'http://localhost:8081/webpack-dev-server/index.html');
  });
});

gulp.task('deploy', ['default'], function () {
  return gulp.src('./build/**/*')
      .pipe(ghPages());
});

gulp.task('default', ['html', 'build']);
