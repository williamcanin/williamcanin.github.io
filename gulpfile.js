/*
File: gulpfile.js
Description: Script for tasks
License: MIT
-----------------------------------------------------------
Author: William Canin
-----------------------------------------------------------
*/

'use strict';

/* LOAD PLUGINS
______________________________________________________________________________________ */

    var gulp = require( 'gulp' ),
        deploy = require('gulp-deploy-git');

    gulp.task('deploy', function() {
      return gulp.src('_site/**/*')
        .pipe(deploy({
          repository: 'https://williamcanin@github.com/williamcanin/williamcanin.github.io.git',
          branches:   ['master']
        }));
    });