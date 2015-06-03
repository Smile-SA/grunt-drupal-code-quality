'use strict';

module.exports = function(grunt) {
  var path = require('path');
  var installDir = __dirname;
  var projectDir = path.resolve('.');

  /* Reset grunt base path */
  grunt.file.setBase(installDir);

  /* Load configuration */
  grunt.initConfig({
    csslint : {
      options : {
        csslintrc: '.csslintrc',
      },
      app : {
        src : [projectDir + '/**/*.css', '!' + projectDir + '/**/*.min.css']
      }
    },
    eslint: {
      options: {
        config: '.eslintrc'
      },
      app: {
        src: [projectDir + '/**/*.js', '!' + projectDir + '/**/*.min.js']
      }
    },
    phpcs: {
      options: {
        bin: './vendor/bin/phpcs',
        standard: 'Drupal'
      },
      app: {
        src: [projectDir + '/**/*.php', projectDir + '/**/*.inc', projectDir + '/**/*.module', projectDir + '/**/*.install']
      }
    },
    phpmd: {
      options: {
        bin: './vendor/bin/phpmd'
      },
      app: {
        dir: projectDir
      }
    }
  });

  /* Load all plugins */
  grunt.loadNpmTasks("grunt-contrib-csslint");
  grunt.loadNpmTasks('grunt-phpcs');
  grunt.loadNpmTasks('grunt-phpmd');
  grunt.loadNpmTasks("gruntify-eslint");

  /* Define tasks */
  grunt.registerTask('check', ['csslint', 'eslint', 'phpcs', 'phpmd']);
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
