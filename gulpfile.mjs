// (c) 2025 - William C. Canin


import { deleteAsync } from "del";
import gulp from "gulp";
import htmlmin from "gulp-htmlmin";
import imagemin, { gifsicle, optipng, svgo } from "gulp-imagemin";
import uglify from "gulp-uglify";

// clean
export function clean_objects() {
  const objs = [
    "node_modules",
    ".bundle-cache",
    ".jekyll-cache",
    "package-lock.json",
    "Gemfile.lock",
  ];
  return deleteAsync(objs);
}

// minify js
export function javascripts() {
  return gulp
    .src("../public/assets/js/**/*.js")
    .pipe(uglify())
    .pipe(gulp.dest("../public/assets/js"));
}

// minify html
export function html_minify() {
  return gulp
    .src("../public/**/*.html")
    .pipe(htmlmin({ collapseWhitespace: true, removeComments: true }))
    .pipe(gulp.dest("../public"));
}

// optimize images
export function images_minify() {
  return gulp
    .src("../public/assets/images/**/*")
    .pipe(
      imagemin([
        gifsicle({ interlaced: true }),
        optipng({ optimizationLevel: 5 }),
        svgo({
          plugins: [
            {
              name: "removeViewBox",
              active: true,
            },
            {
              name: "collapseGroups",
              active: false,
            },
          ],
        }),
      ])
    )
    .pipe(gulp.dest("../public/assets/images"));
}

// tasks
export const build = gulp.series(
  gulp.parallel(html_minify, javascripts, images_minify)
);
export default build;
