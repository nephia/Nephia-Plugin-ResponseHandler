requires 'perl', '5.008001';
requires 'Voson';
requires 'Voson::Plugin::JSON';
requires 'Voson::Plugin::View::MicroTemplate';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

