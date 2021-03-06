# gettext-pythonic v1.1.2

[![Build Status](https://travis-ci.org/vphantom/gettext-pythonic.svg?branch=v1.1.2)](https://travis-ci.org/vphantom/gettext-pythonic) [![Coverage Status](https://coveralls.io/repos/github/vphantom/gettext-pythonic/badge.svg?branch=v1.1.2)](https://coveralls.io/github/vphantom/gettext-pythonic?branch=v1.1.2)

Tiny [po2json](https://github.com/mikeedwards/po2json)-compatible gettext with variable substitution.

This is a simplification of some of the ideas found at [localeplanet.com](http://www.localeplanet.com/).


## Installation & Usage

### Client-side, stand-alone using Bower

```shell
bower install gettext-pythonic --save
```

You can then integrate `bower_components/gettext-pythonic/gettext-pythonic.min.js` to your build as needed.  (The non-minified version is a CommonJS module, not suitable for direct browser use.)  This was generated using `browserify --standalone` and is thus safe as-is or with various module systems.  Stand-alone example:

```html
<script src="gettext-pythonic.min.js"></script>
...
<script type="text/javascript"><!--
  window.__ = gettext.gettext;
  window.n_ = gettext.ngettext;
  gettext.load(someJSONdata);
  alert(__("This sentence is in English."));
  alert(n_("One result:", "%{count} results:", 23, {count: 23}));
// --></script>
```

### Node.JS and client-side (CommonJS)

```shell
npm install gettext-pythonic --save
```

In Node.JS or if you're using Browserify to bundle CommonJS modules together for client-side use, you can choose whichever name you'd like, although keep in mind that following conventions tends to work best.  In JavaScript, the most common names to avoid conflicts with Underscore.JS are `gettext()`/`ngettext()` and short forms `__()`/`n_()`.

```js
var gettext = require('gettext-pythonic');
var __ = gettext.gettext;
var n_ = gettext.ngettext;
...
gettext.load(require('locales/fr.json'));
console.log(__("This sentence is in English."));
```


## JSON langage data

### Basic JSON

If all you need is a quick and dirty 1:1 translation with substitutions but no plural forms, you don't need to use xgettext and po2json: a simple object where each key is a source string and each value is the translated version, will also work (including variable substitution).

Example:

```json
var myLanguage = {
  "English original": "Translated equivalent",
  "Another one": "..."
};
```

Or if you want plural forms, but still no xgettext, use arrays with one
element offset (that's just how PO files are structured):

```json
var myLanguage = {
  "There is one result": [
    null,
    "Il y a %{count} résultat",
    "Il y a %{count} résultats"
  ]
};
```

### po2json with GNU gettext

Maintain your English PO template the standard way, with our friendly function aliases:

```sh
xgettext -L JavaScript -k -k__ -kgettext -kn_:1,2 -kngettext:1,2 --force-po -o locales/messages.pot ...files...
```

Use tools such as poedit to maintain the translations, such as a `locales/fr.po` for example, then use [po2json](https://github.com/mikeedwards/po2json) to generate the JSON equivalent of each non-English PO file:

```sh
po2json locales/fr.po htdocs/locale_fr.json --fuzzy
```

It is then up to you to feed the resulting JSON data to `gettext.load()` at run-time.


## API

### gettext(englishString[, envObject])

(a.k.a. `__(...)`)

The supplied `englishString` is looked up in the current language and substituted if found.  The optional `envObject` is used for variable substitution (see below).

### gettext.ngettext(englishString, englishPluralString, count[, envObject])

(a.k.a. `n_(...)`)

Like its C counterpart, `ngettext()` expects a singular and a plural string, followed by the number on which to decide which version to return.  (Other languages may have more than two variants, but gettext conveniently requires that English be used for keys.)  The optional `envObject` is used for variable substitution (see below).

### gettext.load(translationObject)

Loads the supplied translation object (either a basic set of pairs or an output of `po2json`).


## Variable substitution

Instead of going for a sprintf() means of substituting variables, which couldn't be reordered, I implemented ["pythonic string formatting"](http://davedash.com/2010/11/19/pythonic-string-formatting-in-javascript/) with an added percentage to help translators, which makes both of the following possible:

```js
__("Talking about %{0} and %{1}.", [somevar, othervar]);
__("Talking about %{foo} and %{bar}.", {'foo': somevar, 'bar': othervar});
```

Since the whole point is to be independent of argument order, I recommend always using the named variation.

## MIT License

Copyright (c) 2016 Stephane Lavergne <https://github.com/vphantom>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
