'use strict';

module.exports = function(grunt) {
  var path = require('path');
  var env = grunt.file.readJSON('env.json');

  /* Load configuration */
  grunt.initConfig({
    csslint : {
      options : {
        csslintrc: '.csslintrc',
      },
      app : {
        src : [
          env.projectDir + '/**/*.css',
          '!' + env.projectDir + '/**/*.min.css'
        ]
      }
    },
    eslint: {
      options: {
        config: '.eslintrc'
      },
      app: {
        src: [
          env.projectDir + '/**/*.js',
          '!' + env.projectDir + '/**/*.min.js'
        ]
      }
    },
    phpcs: {
      options: {
        bin: './vendor/bin/phpcs',
        standard: 'Drupal',
        warningSeverity: 0
      },
      app: {
        src: [
          env.projectDir + '/**/*.php',
          env.projectDir + '/**/*.inc',
          env.projectDir + '/**/*.module',
          env.projectDir + '/**/*.install',
          '!' + env.projectDir + '/**/*.features*.inc',
          '!' + env.projectDir + '/**/*.field_group.inc'
        ]
      }
    },
    phpmd: {
      options: {
        bin: './vendor/bin/phpmd',
        reportFormat: 'text',
        rulesets: 'codesize,unusedcode',
        exclude: '*.features*.inc,*.field_group.inc'
      },
      app: {
        dir: env.projectDir
      }
    },
    gitIndexFiles: {
      app: {
        options: {
          gitDir: env.gitDir,
          workTree: env.workTree,
          configSrcPath : [
            'csslint.app.src',
            'eslint.app.src',
            'phpcs.app.src'
          ]
        }
      }
    }
  });

  /* Load all plugins */
  grunt.loadNpmTasks('grunt-contrib-csslint');
  grunt.loadNpmTasks('grunt-git-index-files');
  grunt.loadNpmTasks('grunt-phpcs');
  grunt.loadNpmTasks('grunt-phpmd');
  grunt.loadNpmTasks('gruntify-eslint');

  /* Define tasks */
  grunt.registerTask('check', ['csslint', 'eslint', 'phpcs', 'phpmd']);
  grunt.registerTask('checkCommit', ['gitIndexFiles', 'check']);
  grunt.registerTask('default', 'check');

  /* Help task */
  grunt.task.registerTask(
    'help',
    'Help task.',
    function() {
      grunt.log.writeln('');
      grunt.log.writeln('Availables commands :');
      grunt.log.writeln('');
      grunt.log.writeln('* grunt csslint       : run csslint tasks (CSS coding standards).');
      grunt.log.writeln('* grunt eslint        : run eslint task (JavaScript coding standards).');
      grunt.log.writeln('* grunt phpcs         : run phpcs task (PHP coding standards).');
      grunt.log.writeln('* grunt phpmd         : run phpmd tasks (PHP mess detector).');
      grunt.log.writeln('* grunt check         : run all above.');
      grunt.log.writeln('* grunt gitIndexFiles : modify the files set of other task for limiting to git index files only.');
      grunt.log.writeln('* grunt checkCommit   : launch the check task just after the gitIndexFiles task.');
      grunt.log.writeln('* grunt               : same as check');
    }
  );
};
