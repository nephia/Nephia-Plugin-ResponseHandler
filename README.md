# NAME

Voson::Plugin::ResponseHandler - A plugin for Voson that provides response-handling feature

# SYNOPSIS

    use Voson plugins => [
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
    use Voson plugins => [
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



# DESCRIPTION

Voson::Plugin::ResponseHandler provides response-handling feature for Voson app.

# LICENSE

Copyright (C) ytnobody.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

ytnobody <ytnobody@gmail.com>
