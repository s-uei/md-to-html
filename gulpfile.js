var gulp = require('gulp');
var pegjs = require('gulp-pegjs');
var rename = require('gulp-rename');


gulp.task('peg-compile', function () {
    return gulp.src('lib/rule.pegjs')
        .pipe(pegjs())
        .pipe(rename("index.js"))
        .pipe(gulp.dest('lib'));
});

gulp.task('default', () => {
    return gulp.watch(['lib/rule.pegjs'], gulp.parallel("peg-compile"));
});

