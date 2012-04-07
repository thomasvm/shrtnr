# shrtnr

## What?
Very simple node.js url shortenener created using

* coffee-script
* express-js
* mongoose
* jade

The example is running at [shrtnr.nodester.com](shrtnr.nodester.com)

What makes this different from other Shortening services
is that hash possibilities are taken from a set of predefined
words and then converted to some kind of l33t variant. The 
current set of words consists of names related to the 
[Godfather](http://www.imdb.com/title/tt0068646/) trilogy movies.

So, for example, 

 * the word Chicago might result in a shorturl that ends with
   Ch!c4G0
 * DonVito might end up being D0NvITO

## How to run?

* Clone this repository
* Install the needed packages using

		npm install

* Fire up mongodb on your local machine, or 

		export GETSHORTY_MONGODB_URL=<your mongodb url> 

* Then launch

		node app.js		

That's it
