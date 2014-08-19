package OMV::RegexFor::Tags;
# $Id$

use strict;
use warnings;
use MT;

use vars qw( $VENDOR $MYNAME $FULLNAME );
$FULLNAME = join '::',
        (($VENDOR, $MYNAME) = (split /::/, __PACKAGE__)[0, 1]);

sub instance { MT->component( $FULLNAME ); }



sub RegexFor { return _regex_common( 'RegexFor', @_ ); }
sub RegexReplace { return _regex_common( 'RegexReplace', @_ ); }

sub _regex_common {
    my( $tag, $ctx, $args, $cond ) = @_;

    # required: any value from variable or tag
    my $val;
    if( defined( my $var = $args->{var} || $args->{name} )) {
        $val = $ctx->var( $var ) || '';
    }
    elsif( defined( my $tag = $args->{tag} )) {
        $tag =~ s/^MT:?//i;
        require Storable;
        my $local_args = Storable::dclone($args);
        $val = $ctx->tag( $tag, $local_args, $cond )
            or return $ctx->error( &instance->translate( 'Unknown tag found: [_1]', $tag ));
    }
    defined $val
        or return $ctx->error( &instance->translate( 'Parameter \'[_1]\' is required', 'var' ));

    # required: regular expression pattern
    my $regex = defined $args->{regex}
        ? $args->{regex}
        : return $ctx->error();
    eval { $regex = qr/$regex/ };
    $@ and return $ctx->error( $@ );

    # optional: trim the inner content of block.
    my $trim = defined $args->{trim}
        ? $args->{trim}
        : 1;

    my $token = $ctx->stash ('tokens');
    my $builder = $ctx->stash ('builder');
    my $vars = $ctx->{__stash}{vars} ||= {};

    ### mt:RegexFor block tag
    if( $tag eq 'RegexFor' ) {
        my $block_out;
        $val =~ s{$regex}{sub {
            $vars->{"__\$${_}__"} = eval "\$$_" foreach( 1..$#+ );
            defined( my $out = $builder->build( $ctx, $token, $cond ))
                or return $ctx->error( $builder->errstr );
            $block_out .= $out;
        }->()}egi;
        return $block_out;
    }

    ### mt:RegexReplace block tag
    elsif( $tag eq 'RegexReplace' ) {
        $val =~ s{$regex}{sub {
            $vars->{"__\$${_}__"} = eval "\$$_" foreach( 1..$#+ );
            defined( my $out = $builder->build( $ctx, $token, $cond ))
                or return $ctx->error( $builder->errstr );
            $out =~ s/^\s+|\s+$//g if $trim;
            $out;
        }->()}egi;
        return $val;
    }

    return $ctx->error( &instance->translate( 'That action ([_1]) is apparently not implemented!', $tag ));
}

1;