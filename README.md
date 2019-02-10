Word is a tool for looking up word definitions.
It performs multiple lookups in public online dictionaries,
 cleans and compactifies the output.

It presently supports the following sources:
* wiktionary
* urban dictionary
* wordnet
* aonaware

Source dictionaries can be selected on the command line.
To view just translations, add -t
With -a, all dictionaries are chosen, not just the default ones.

The tword utility filters output of word -t to a few common languages.

If log/word file exists (relative to current directory), word updates
it with a record, recording the lookup

### Example 1:
~~~
$ tword cancer
Source wiktionary:
Translations
   disease of uncontrolled cellular proliferation
French: cancer (fr) m
German: Krebs (de) m
Greek: karki'no*s (el) m (karkínos)
Italian: cancro (it) m
Russian: rak (ru) m (rak), (med.) zloka'chestvennaya
Spanish: cáncer (es) m
~~~

### Example 2:
~~~
# word nybble
Source wiktionary:
Etymology
   Punningly from nibble ("a small bite"), with the i changed to y by
   analogy with byte, as if that word had been formed in the same way
   from bite.

Source wordnet:
Noun
     - (n) nybble, nibble (a small byte)

Source urbandict:
urbandict: [Har har], computer programmers have a sense of humor.  It stands to reason that anything less than a [byte] would be a nybble.
~~~

### Example 3
~~~
$ word smh
Source urbandict:
urbandict: meaning, "[shaking my head]", smh is typically used when something is obvious, [plain old stupid], or [disappointment].
example: [You don't know] what smh [means]? smh
~~~

