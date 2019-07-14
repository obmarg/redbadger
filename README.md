## Red Badger Coding Test

This is my solution to the Red Badger coding test.

I chose to solve this problem using Elm for a few reasons:

1. I like Elm and it's been a while since I got a chance to use it.
2. It can compile into a single HTML file so my solution can be run without
   installing anything.
3. The Elm compiler can easily be installed via npm (which I'm assuming most
   devs will already have) so it's easy for anyone to build if the pre-compiled
   version isn't sufficient.
4. I've been looking for an excuse to play with elm/parser for a while and this
   challenge seemed like as good an excuse as any.

As UI design was not the focus of the problem, the UI is seriously crap.  Two
text boxes & a button.

The majority of the interesting code is in `Robot.elm`, but there's also a bunch
of code for parsing the input in `Input.elm`.

### Running

The repository contains a pre-compiled version of the app in index.html.  You
can just open that if you want.

### Building & Running Tests

The only pre-requisite for building/running the tests is npm.  You can run the
tests via `npm test` and build the project via `npm run-script build`.
