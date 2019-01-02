#--------------------------------------------------------------------------------

# return query object
# ret->{word} -- word
# ret->{definition} -- text
# ret->{reference} -- references
# AONAWARE output format (handled with lynx first...)
# skip headers:
#                            Definition Lookup
#                        Search for ____________________
#                  Using dictionary
# [Any_________________________________________________________]
#                           Search  Clear Form
#        ________________________________________________________
# 3 definitions found for inveterate:
# OR
# No definitions found for asdfasdf.
# ...
#           ________________________________________________________
#    [9]Aonaware Web Services
# References
#    1. http://services.aonaware.com/DictService/Default.aspx?action=dictinfo&query=gcide
#    2. http://services.aonaware.com/DictService/Default.aspx?action=dictinfo&query=gcide
# ...
sub query_aonaware($) {
    my $word =$_[0];
    open my $R, qq!lynx "http://services.aonaware.com/DictService/Default.aspx?action=define&dict=*&query=$word" -dump | !;
    my $ret={};
    my $endheader=0; # saw end of header
    my $startfooter=0; # saw beginning of footer
    my $footer = ""; # contents of the footer
    $ret->{word} = $word;
    while (<$R>) {
	$_=clean_lynx($_);
	if (/definitions found for/) {
	    $_="";
	    $endheader=1;
	}
	# lynx shows this footer 
	if ($endheader && /^\s+______________/) {
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
