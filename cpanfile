requires 'perl', '5.008001';
requires 'Nephia';
requires 'Nephia::Plugin::JSON';
requires 'Nephia::Plugin::View::MicroTemplate';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

