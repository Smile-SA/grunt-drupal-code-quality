'use strict';

module.exports = function(grunt) {
  var path = require('path');
  var installDir = __dirname;
  var projectDir = path.resolve('.');

  /* Reset grunt base path */
  grunt.file.setBase(installDir);

  /* Load configuration */
  grunt.initConfig({
    eslint: {
      options: {
        config: '.eslintrc'
      },
      src: [projectDir + '/**/*.js', '!' + projectDir + '/**/*.min.js']
    },
    csslint : {
      options : {
        csslintrc: '.csslintrc',
      },
      app : {
        src : [projectDir + '/**/*.css', '!' + projectDir + '/**/*.min.css']
      }
    }
  });

  /* Load all plugins */
  grunt.loadNpmTasks("grunt-contrib-csslint");
  grunt.loadNpmTasks("gruntify-eslint");

  /* Define tasks */
  grunt.registerTask('check', ['eslint', 'csslint']);
  grunt.registerTask('default', 'check');

  /* Help task */
  grunt.task.registerTask(
    'help',
    'Help task.',
    function() {
      grunt.log.writeln('');
      grunt.log.writeln('Availables commands :');
      grunt.log.writeln('');
      grunt.log.writeln('* grunt eslint  : run eslint task (JavaScript validation)');
      grunt.log.writeln('* grunt csslint : run csslint tasks (CSS validation)');
      grunt.log.writeln('* grunt check   : run both');
      grunt.log.writeln('* grunt         : same as check');
    }
  );
};
