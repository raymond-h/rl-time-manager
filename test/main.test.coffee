chai = require 'chai'
{expect} = chai
chai.should()

repeatPromise = (n, fn) ->
	p = Promise.resolve()
	while n > 0
		p = p.then fn
		n -= 1
	p

TimeManager = require '../src/index'

describe 'TimeManager', ->
	tm = tm2 = null
	ticked = []

	tick1 = (n) ->
		-> ticked.push(n); 5
	tick2 = (n) ->
		-> ticked.push(n); 10

	target1 = target2 = target3 = null
	target21 = target22 = null

	beforeEach ->
		target1 = { tick: tick1('a'), tickRate: 5 }
		target2 = { tick: tick1('b'), tickRate: 10 }
		target3 = { tick: tick1('c'), tickRate: 20 }

		target21 = { tick: tick1('a'), tickRate: 5 }
		target22 = { tick: tick2('b'), tickRate: 5 }

		ticked = []
		tm = new TimeManager
		tm2 = new TimeManager

	describe '#add()', ->
		it 'adds a single target', ->
			tm.add target1

			tm.targets.should.deep.equal [target1]

		it 'adds multiple targets', ->
			tm.add target1, target2, target3

			tm.targets.should.deep.equal [target3, target2, target1]

	describe '#remove()', ->
		beforeEach ->
			tm.add target1, target2, target3

		it 'removes a single target', ->
			tm.remove target3

			tm.targets.should.deep.equal [target2, target1]

		it 'removes multiple targets', ->
			tm.remove target1, target2, target3

			tm.targets.should.deep.equal []

	describe 'ticking', ->
		beforeEach ->
			tm.add target1, target2, target3
			tm2.add target21, target22

		describe '#tick()', ->
			it 'calls targets\' tick() method', ->
				repeatPromise 3, -> tm.tick()

				.then ->
					ticked.should.deep.equal ['a', 'b', 'c']

			it 'should tick targets according to tick rate', ->
				repeatPromise 10, -> tm.tick()

				.then ->
					ticked.should.deep.equal [
						'a', 'b', 'c', 'c', 'b'
						'c', 'c', 'a', 'b', 'c'
					]

			it 'should tick targets according to returned cost', ->
				repeatPromise 10, -> tm2.tick()

				.then ->
					ticked.should.deep.equal [
						'a', 'b', 'a', 'b', 'a'
						'a', 'b', 'a', 'a', 'b'
					]

		describe '#tickSync()', ->
			it 'calls targets\' tick() method', ->
				tm.tickSync() for i in [1..3]

				ticked.should.deep.equal ['a', 'b', 'c']

			it 'should tick targets according to tick rate', ->
				tm.tickSync() for i in [1..10]

				ticked.should.deep.equal [
					'a', 'b', 'c', 'c', 'b'
					'c', 'c', 'a', 'b', 'c'
				]

			it 'should tick targets according to returned cost', ->
				tm2.tickSync() for i in [1..10]

				ticked.should.deep.equal [
					'a', 'b', 'a', 'b', 'a'
					'a', 'b', 'a', 'a', 'b'
				]