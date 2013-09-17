requires 'perl', '5.008001';
requires 'Data::Nest', '0.03';
requires 'Scalar::Util';

on 'test' => sub {
    requires 'Test::More', '0.98';
};
