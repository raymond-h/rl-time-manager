_ = require 'lodash'
Promise = require 'bluebird'

wrapPromise = Promise.resolve.bind(Promise)

module.exports = class TimeManager
	constructor: (@wrapPromise = wrapPromise) ->
		@targets = []

	add: (targets...) ->
		for target in targets
			target.nextTick ?= 0

			i = _.sortedIndex @targets, target, (t) -> -t.nextTick
			@targets.splice i, 0, target

	remove: (targets...) -> _.pull @targets, targets...

	adjustNextTicks: (add) ->
		(t.nextTick += add) for t in @targets

	tick: (callback) ->
		if @targets.length > 0
			[..., target] = @targets

			@wrapPromise target.tick()
			.then (cost = 0) =>
				rate = _.result target, 'tickRate'

				# rate > 0 means this target should be scheduled again
				if rate > 0
					@adjustNextTicks -target.nextTick
					target.nextTick = cost / rate

				# otherwise, if 0, it should never be scheduled
				# AKA an infinite amount of time until next schedule
				else target.nextTick = Infinity

				@add @targets.pop() if rate is 0 or cost isnt 0

			.nodeify callback

		else process.nextTick callback