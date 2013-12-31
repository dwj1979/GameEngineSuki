module.exports =(grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    concat:
      build:
        src: [
          'src/Suki.coffee'
          'src/Base.coffee'
          'src/Event.coffee'
          'src/Timer.coffee'
          'src/Entity.coffee'
          'src/Layer.coffee'
          'src/Scene.coffee'
          'src/Stage.coffee'
          'src/util.coffee'
          'src/components/*.coffee'
        ]
        dest: 'build/suki.coffee'
      test:
        src: [
          'test/suki.header'
          'build/suki.test.js'
          'test/suki.footer'
        ]
        dest: 'build/suki.test.js'
    coffee:
      build:
        options:
          sourceMap: true
        files:
          'build/suki.js': 'build/suki.coffee'
      test:
        options:
          bare: true
        files:
          'build/suki.test.js': 'build/suki.coffee'
    uglify:
      build:
        options:
          sourceMap: 'build/suki.min.js.map'
          sourceMapIn: 'build/suki.js.map'
          report: 'gzip'
        files:
          'build/suki.min.js': ['build/suki.js']
    mochaTest:
      test:
        options:
          reporter: 'spec'
          require: 'should'
          growl: true
        src: ['test/**/*.coffee']
    clean:
      test: ['build/*.test.*']
    watch:
      scripts:
        files: ['test/**/*.coffee', 'src/**/*.coffee']
        tasks: ['test']

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-mocha-test'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-clean'

  grunt.registerTask 'default', []
  grunt.registerTask 'build', ['concat:build', 'coffee:build', 'uglify']
  grunt.registerTask 'test', ['concat:build', 'coffee:test', 'concat:test', 'mochaTest:test', 'clean:test']

