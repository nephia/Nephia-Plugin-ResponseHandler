use strict;
use warnings;
use Test::More;
use Plack::Test;
use HTTP::Request::Common;
use Nephia::Core;

my $v = Nephia::Core->new(
    plugins => [
        'View::MicroTemplate' => { 
            include_path => [File::Spec->catdir(qw/t tmpl/)],
        }, 
        'JSON',
        'ResponseHandler',
    ],
    app => sub {
        my $req = req();
        $req->path_info eq '/json'   ? +{foo => 'bar'} :
        $req->path_info eq '/html'   ? +{name => 'html', template => 'foo.html'} :
        $req->path_info eq '/array'  ? [200, [], 'foobar'] :
        $req->path_info eq '/scalar' ? 'scalar!' :
                                       [404, [], 'not found']
        ;
    },
);

subtest json => sub {
    test_psgi $v->run, sub {
        my $cb = shift;
        my $res = $cb->(GET '/json');
        is $res->content, '{"foo":"bar"}', 'output JSON';
    };
};

subtest html => sub {
    test_psgi $v->run, sub {
        my $cb = shift;
        my $res = $cb->(GET '/html');
        is $res->content, 'Hello, html!'."\n", 'output HTML';
    };
};

subtest array => sub {
    test_psgi $v->run, sub {
        my $cb = shift;
        my $res = $cb->(GET '/array');
        is $res->content, 'foobar', 'output ARRAY';
    };
};

subtest scalar => sub {
    test_psgi $v->run, sub {
        my $cb = shift;
        my $res = $cb->(GET '/scalar');
        is $res->content, 'scalar!', 'output SCALAR';
    };
};

done_testing;
