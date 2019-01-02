#--------------------------------------------------------------------------------

# Return definition of $_[0] as an object (see word)
# We use lynx to avoid dependency on HTML (ironic)
# wiktionary output looks like this:
#
#[1]Edit [2]Wiktionary (en) [3]Wiktionary Atom feed
# inveterate
#    Definition from Wiktionary, the free dictionary
#    [4]Jump to navigation [5]Jump to search
#    [ ]
# Contents
#    ... < some overview >
# English[[23]edit]
#    [24]WOTD - 12 July 2012
# Etymology[[25]edit]
#    From [26]Latin [27]inveteratus ("of long standing, chronic"), form of
#    [28]inveterare, from [29]in- ("in, into") + [30]veterare ("to age"),
#    from [31]vetus, form of [32]veteris ("old"); latter ancestor to
#    [33]veteran.
#    Cognate to Italian [34]inveterato.
# Pronunciation[[35]edit]
#      * [36]IPA^([37]key): /In|vEt@rIt/
#      * Rhymes: [38]-Et@rIt
#      * Hyphenation: in·vet·er·ate
# Adjective[[39]edit]
#    inveterate ([40]comparative [41]more inveterate, [42]superlative
#    [43]most inveterate)
#     1. [44]firmly [45]established from having been around for a [46]long
#        time; of long [47]standing
#    ...
# Synonyms[[56]edit]
#    ...
# Antonyms[[61]edit]
#    ...
# Related terms[[64]edit]
#    ...
# Translations[[67]edit]
#    firmly established
#    ...
#      * Russian: [85]zakorene'lyj [86](ru) (zakorenélyj)
# Verb[[128]edit]
#    ...
# Derived terms[[139]edit]
#      * [140]inveteration
# References[[141]edit]
#      * "[142]inveterate" in Douglas Harper, Online Etymology Dictionary,
#        2001-2018.
#      * [143]inveterate in [144]Webster's Revised Unabridged Dictionary, G.
#        & C. Merriam, 1913
# Anagrams[[145]edit]
#      * [146]Everettian, [147]entreative
#      __________________________________________________________________
# Italian[[148]edit]
# ...
# Latin[[156]edit]
# ...
# Personal tools
# Namespaces
# Variants
# Views
# More
# Search
# Navigation
# Tools
# In other languages
# Print/export
# References
#    Visible links:
#    1. https://en.wiktionary.org/w/index.php?title=inveterate&action=edit
#    ...
#  241. https://www.mediawiki.org/
#  ...
#    Hidden links:
#  243. https://en.wiktionary.org/wiki/Wiktionary:Main_Page
sub query_wiktionary($) {
    my $word =$_[0];
    open my $R, qq!lynx "https://en.wiktionary.org/wiki/$word" -dump | !;
    my $ret={};
    my $language="";
    my $phys_section="";
    # map of recognized languages
    # for each language, whether I want its data
    my %langs = (
	"English" => 1
	, "Catalan" => 0
	, "Czech" => 0
	, "French" => 0
	, "German" => 0
	, "Ido" => 0
	, "Irish" => 0
	, "Italian" => 0
	, "Japanese" => 0
	, "Latin" => 0
	, "Spanish" => 0
	, "Swedish" => 0
	);
    # map of recognized wiktionary sections
    # for each section, whether I want to query it
    my %subsections = (
	"Etymology" => !$opt_t
	,"Etymology 2" => !$opt_t
	,"Etymology 3" => !$opt_t
	,"Etymology 4" => !$opt_t
	, "Pronunciation" => !$opt_t
	, "Adjective" => !$opt_t
	, "Synonyms" => !$opt_t
	, "Antonyms" => !$opt_t
	, "Related" => !$opt_t
	, "Translations" => $opt_t
	, "Verb" => !$opt_t
	, "Translations to be checked" => ($opt_all)
	, "Derived" => ($opt_all && !$opt_t)
	, "References" => 0
	, "Anagrams" => ($opt_all && !$opt_t)
	);
    while (<$R>) {
	$_ = clean_lynx($_);
	# remove "edit" annotations
	$_ =~ s/\[edit\]//g;
	#section names align left,
	if (/^(\w+)/) {
	    $phys_section=$1;
	}
	#but could also be indented. because this is
	#web... in this case the section name
	#must be on a line by itself
	if (/^\s+(.+?)\s*$/ && $subsections{$1}) {
	    $phys_section=$1;
	}
	# switch language if the language is recognized
	if (defined($langs{$phys_section})) {
	    $language = $phys_section;
	}
	# deeply nested? - skip
	my $deep = ($_ =~ /^       /); 
	if ($deep && !$opt_all) {
	    $_="";
	}
	# subsection must be marked for display
	my $show = $subsections{$phys_section};
	$show = $show && !m/__________/;
	# and if we're not translating, language
	# section must match
	if (!$opt_t){
	    $show = $show && $langs{$language}>0;
	}
	if ($_ ne ""&& $show){
	    $ret->{definition} .= "$_\n";
	}
    }
    return $ret;
}

1;
