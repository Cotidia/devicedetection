module.exports = (grunt) ->

    # Project configuration.
    grunt.initConfig({

        pkg: grunt.file.readJSON('package.json')

        coffee:
            frontend:
                files:
                    'dd.js':[
                        'src/devicedetection.coffee'
                    ]

        watch:
            frontend:
                files: [
                    'src/devicedetection.coffee'
                    ],
                tasks: ['frontend']
    })
         
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-watch'

    # Tasks
    grunt.registerTask 'frontend', [
        'coffee'
    ]

    # Watch Tasks
    grunt.registerTask 'watch', ['watch:frontend']