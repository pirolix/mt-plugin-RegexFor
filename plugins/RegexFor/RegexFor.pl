package MT::Plugin::Template::OMV::RegexFor;
# RegexFor (C) 2014 Piroli YUKARINOMIYA (Open MagicVox.net)
# This program is distributed under the terms of the GNU Lesser General Public License, version 3.
# $Id$

use strict;
use warnings;
use MT 5;

use vars qw( $VENDOR $MYNAME $FULLNAME $VERSION );
$FULLNAME = join '::',
        (($VENDOR, $MYNAME) = (split /::/, __PACKAGE__)[-2, -1]);
$VERSION = 'v0.10.386';

# http://www.sixapart.jp/movabletype/manual/object_reference/archives/mt_plugin.html
use base qw( MT::Plugin );
my $plugin = __PACKAGE__->new ({
    # Basic descriptions
    id => $FULLNAME,
    key => $FULLNAME,
    name => $MYNAME,
    version => $VERSION,
    author_name => 'Open MagicVox.net',
    author_link => 'http://www.magicvox.net/',
    plugin_link => 'http://www.magicvox.net/archive/2014/08191941/', # Blog
    doc_link => "http://lab.magicvox.net/trac/mt-plugins/wiki/$MYNAME", # tracWiki
    description => <<'HTMLHEREDOC',
<__trans phrase="Supply template tags for manipulating the strings extracted with regular expression.">
HTMLHEREDOC
    l10n_class => "${FULLNAME}::L10N",

    # Registry
    registry => {
        tags => {
            help_url => "http://lab.magicvox.net/trac/mt-plugins/wiki/$MYNAME#tag-%t",
            block => {
                RegexFor =>         "${FULLNAME}::Tags::RegexFor",
                RegexReplace  =>    "${FULLNAME}::Tags::RegexReplace",
            },
        },
    },
});
MT->add_plugin ($plugin);

sub instance { $plugin; }

1;