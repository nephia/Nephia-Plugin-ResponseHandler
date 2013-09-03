package Nephia::Plugin::ResponseHandler;
use 5.008005;
use strict;
use warnings;
use parent 'Nephia::Plugin';
use Nephia::Response;

our $VERSION = "0.01";

sub new {
    my ($class, %opts) = @_;
    my $self = $class->SUPER::new(%opts);
    $self->app->{response_handler} = $opts{handler};
    $self->app->{response_handler}{HASH}   ||= $self->can('_hash_handler');
    $self->app->{response_handler}{ARRAY}  ||= $self->can('_array_handler');
    $self->app->{response_handler}{SCALAR} ||= $self->can('_scalar_handler');
    my $app = $self->app;
    $app->action_chain->after('Core', ResponseHandler => $self->can('_response_handler'));
    return $self;
}

sub _response_handler {
    my ($app, $context) = @_;
    my $res = $context->get('res');
    my $type = ref($res) || 'SCALAR';
    if ($app->{response_handler}{$type}) {
        $app->{response_handler}{$type}->($app, $context);
    }
    return $context;
}

sub _hash_handler {
    my ($app, $context) = @_;
    my $res = $context->get('res');
    $res->{template} ?
        $context->set('res' => Nephia::Response->new(200, ['Content-Type' => 'text/html; charset=UTF-8'], $app->dsl('render')->(delete($res->{template}), $res)) ) :
        $app->dsl('json_res')->($res)
    ;
}

sub _array_handler {
    my ($app, $context) = @_;
    my $res = $context->get('res');
    $context->set('res' => Nephia::Response->new(@$res));
}

sub _scalar_handler {
    my ($app, $context) = @_;
    my $res = $context->get('res');
    $context->set('res' => Nephia::Response->new(200, [], $res));
}

1;
__END__

=encoding utf-8

=head1 NAME

Nephia::Plugin::ResponseHandler - A plugin for Nephia that provides response-handling feature

=head1 SYNOPSIS

    use Nephia plugins => [
        'JSON',
        'View::MicroTemplate' => {...},
        'ResponseHandler'
    ];
    ### now you can as following ...
    app {
        my $type = param('type');
        $type eq 'json' ? +{foo => 'bar'} :
        $type eq 'html' ? +{foo => 'bar', template => 'index.html'} :
        $type eq 'str'  ? 'foo = bar' :
                          [200, [], 'foo = bar'] 
        ;
    };
    
    ### or you may sepcify your original handler
    use Nephia plugins => [
        'ResponseHandler' => {
            HASH   => \&hash_handler,
            ARRAY  => \&array_handler,
            SCALAR => \&scalar_handler,
        },
    ];
    sub hash_handler {
        my ($app, $context) = @_;
        my $res = $context->get('res');
        ### here make some changes to $res
        $context->set(res => $res);
    }
    sub array_handler {
        ...
    }
    sub scalar_handler {
        ...
    }


=head1 DESCRIPTION

Nephia::Plugin::ResponseHandler provides response-handling feature for Nephia app.

=head1 LICENSE

Copyright (C) ytnobody.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

ytnobody E<lt>ytnobody@gmail.comE<gt>

=cut

