# rl-time-manager
Time manager for roguelikes

## Installing
`npm install rl-time-manager`

## Example usage
```js
var TimeManager = require('rl-time-manager');

function tick() {
	return 5; // Cost of whatever was done this tick, can be an arbitrary integer
}

var timeManager = new TimeManager(),
	monster1	= { tick: tick, tickRate: 10 },
	monster2	= { tick: tick, tickRate: 5 };

// Tick rates of stuff is also an arbitrary integer

timeManager.add(monster1, monster2);

// call timeManager.tick(cb) several times (it's async, returns a promise or uses a callback)
// Actor turn order: #1, #1, #2, #1, #1, #2, ...
```
    
## License
The MIT License (MIT)

Copyright (c) 2015 Raymond Hammarling

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.