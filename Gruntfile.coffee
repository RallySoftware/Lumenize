module.exports = (grunt) ->

	config=
		clean:
			build: 'build/**'
			coverage: 'coverage/**'
			deploy: 'deploy/**'

		coffee:
			compile:
				options:
					bare: false
				expand: true
				flatten: true
				src: ['src/*.coffee', 'src/tztime/*.coffee']
				dest: 'build'
				ext: '.js'

		copy:
			main:
				files: [
					# {expand: true, src: ['bower_components/timezone-js/src/date.js'], dest: 'build', filter: 'isFile', flatten: true}
					{expand: true, src: ['lib/timezone-js.0.4.11.custom.js'], dest: 'build', filter: 'isFile', flatten: true}
					# {expand: true, src: ['lib/timezone-js.js'], dest: 'build', filter: 'isFile', flatten: true}
					{expand: true, src: ['src/tztime/tzdata.js'], dest: 'build', filter: 'isFile', flatten: true}
				]

		convert:
			options:
				explicitArray: false
				type: 'csv'
			csv2json:
				files: [
					{
						expand: true,
						cwd: 'files/tz/',
						src: ['**/*'],
						dest: 'build/tz/',
						ext: '.json'
					}
				]

		# karma:
		# 	continuous:
		# 		configFile: 'karma.conf.js'
		# 		singleRun: true
		# 		colors: false

		requirejs:
			options:
				baseUrl: 'build'
				name: 'lumenize'
				paths:
					lodash: 'empty:'
					json2: '../bower_components/JSON-js/json2'
					'tzdata/northamerica': 'tzdata'
			min:
				options:
					out: 'deploy/lumenize.min.js'
					optimize: 'uglify2'
			dev:
				options:
					out: 'deploy/lumenize.js'
					optimize: 'none'

	@initConfig config

	# Load modules from npm package.json
	require('matchdep').filterDev('grunt-*').forEach @loadNpmTasks

	@registerTask 'build', ['coffee', 'copy', 'requirejs']
	@registerTask 'test', ['build', 'karma:continuous']
	@registerTask 'default', ['build']
