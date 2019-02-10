use strict;
our $opt_t;
our $opt_all;

# {"list":
#      [{"definition":"Abbreviation for \"[my face when]\"" example:"zzz", thumbs_up:12345, thumbs_down:123 }
#       ,{"definition":"Abbreviation for \"[My Face When]\"" ...}
#      ]
# }

sub query_urbandict($) {
    my $ret;
    my $obj=fetch_json("https://api.urbandictionary.com/v0/define?term=$_[0]");
    my $out;
    my $idx=0;
    if ($obj && $obj->{list}) {
        my $list=$obj->{list};
        foreach my $elem(@$list) {
            # choose only definitions that enjoy popular support
            if ($elem->{thumbs_up} > $elem->{thumbs_down}*4) {
                if ($out) {
                    $out .= "\n";
                }
                $idx++;
                my $def = "urbandict: $elem->{definition}\n";
                if ($elem->{example}) {
                    $def .= "example: $elem->{example}\n";
                }
                $def =~ s/\s+$//;
                # urbandictionary is ridiculous. 
                if (!$opt_all) {
                    $def = limitlines($def,3);
                }
                $out .= $def;
                # include only first 2 definitions from urbandict
                # unless -v is specified (-a raises -v)
                if (!$opt_all && $idx>1) {
                    last;
                }
            }
        }
    }
    $ret->{definition}=$out;
    return $ret;
}

1;
