#--------------------------------------------------------------------------------
#    WordNet Search - 3.1
#    - [1]WordNet home page - [2]Glossary - [3]Help
#  Word to search for: rod_________________ Search WordNet
#  Display Options: [(Select option to change)] Change
#  Key: "S:" = Show Synset (semantic) relations, "W:" = Show Word
#  (lexical) relations
#  Display options for sense: (gloss) "an example sentence"
# Noun
#   * [4]S: (n) rod (a long thin implement made of metal or wood)
#   * [5]S: (n) rod (any rod-shaped bacterium)
#   * [6]S: (n) [7]perch, rod, [8]pole (a linear measure of 16.5 feet)
#   * [9]S: (n) [10]perch, rod, [11]pole (a square rod of land)
#   * [12]S: (n) rod, [13]rod cell, [14]retinal rod (a visual receptor
#     cell that is sensitive to dim light)
#   * [15]S: (n) [16]gat, rod (a gangster's pistol)
# References
# 1. http://wordnet.princeton.edu/
# 2. http://wordnet.princeton.edu/man/wngloss.7WN.html
# ...
sub query_wordnet($){
    my $word =$_[0];
    open my $R, qq!lynx -dump "http://wordnetweb.princeton.edu/perl/webwn?s=$word" | !;
    my $ret={};
    my $endheader=0;#saw end of header
    my $startfooter=0;
    $ret->{word} = $word;
    while (<$R>) {
	$_=clean_lynx($_);
	# clean up S: annotation
	$_ =~ s/- S: /- /;
	if (/Display options for sense/) {
	    $_="";
	    $endheader=1;
	}
	if ($endheader && /^References/) {
	    $startfooter=1;
	}
	if ($startfooter && $_) {
	    $ret->{reference} .= "$_\n";
	}
	if ($endheader && !$startfooter && $_ ne "") {
	    $ret->{definition} .= "$_\n";
	}
    }
    return $ret;
}

1;
