module.exports = (grunt) ->
	pkg = grunt.file.readJSON('package.json')
	coffeelintConfig = grunt.file.readJSON('coffeelint-config.json')

	grunt.initConfig
		coffee:
			main:
				files:
					'dist/connect-instagram-proxy.js': 'src/connect-instagram-proxy.coffee'

		coffeelint:
			main:
				files: 
					src: ['test/**/*.coffee', 'src/**/*.coffee']
			options: coffeelintConfig

		watch:
			main:
				files: ['test/**', 'src/**', 'libs/**', 'utils/**']
				tasks: ['coffeelint', 'coffee', 'mochaTest']

		mochaTest:
			main:
				options:
					reporter: 'nyan'
				src: ['test/**/*-test.coffee']


	# Registering tasks
	tasks =
		build: ['test']
		default: ['testWatch']
		test: ['coffeelint', 'coffee', 'mochaTest']
		testWatch: ['test', 'watch']
	
	grunt.registerTask taskName, taskArray for taskName, taskArray of tasks

	# Load NPM tasks
	grunt.loadNpmTasks name for name of pkg.devDependencies when name[0..5] is 'grunt-'

