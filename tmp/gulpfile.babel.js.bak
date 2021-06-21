// Script: gulpfile.babel.js
// by: William C. Canin

'use strict';

import gulp from 'gulp';
import eslint from 'gulp-eslint';
import uglify from 'gulp-uglify';
import imagemin from 'gulp-imagemin';
import htmlmin from 'gulp-htmlmin';

// Task to minify the javascript of your site
gulp.task('js', () =>
    gulp.src(['public/assets/js/**/*.js'])
        .pipe(eslint())
        // .pipe(eslint.format())
        // .pipe(eslint.failAfterError())
        .pipe(uglify())
        .pipe(gulp.dest('public/assets/js'))
);

// Task to minify the HTML of your site
gulp.task('html', () =>
    gulp.src(['public/**/*.html'])
        .pipe(htmlmin({ collapseWhitespace: true }))
        .pipe(gulp.dest('public'))
);

// Task to optimize images from the folder "assets/images".
gulp.task('imagemin', () => 
    gulp.src(['public/assets/images/**/*'])
        .pipe(imagemin([
            imagemin.gifsicle({interlaced: true}),
            imagemin.jpegtran({progressive: true}),
            imagemin.optipng({optimizationLevel: 5}),
            imagemin.svgo({
                plugins: [
                    {removeViewBox: true},
                    {cleanupIDs: false}
                ]
            })
        ]))
        .pipe(gulp.dest('public/assets/images'))
);

// Task to compile and build all website
gulp.task('build', gulp.series(['js', 'html', 'imagemin']));

