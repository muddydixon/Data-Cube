package Data::Cube;
use 5.008005;
use strict;
use warnings;
use Carp;
use Data::Dumper;
use Data::Nest;

our $VERSION = "0.01";

sub new {
    my $self = shift;

    my @dims = @_;

    bless {
        cells    => {},

        dims     => \@dims,
        records  => [],
        measures => [{name => "count", func => sub { my @data = @_; scalar @data;}}],
        hiers    => {},
        cells    => undef,
    }, $self;
};

# データを追加する
sub put {
    my $self = shift;
    my $data = shift;
    push @{$self->{records}}, $data;
};

# 次元の追加
sub add_dimension {
    my $self = shift;
    my $dim = shift;
    push @{$self->{dims}}, $dim;
    $self;
};

sub add_hierarchy {
    my $self = shift;
    my $child = shift;
    my $parent = shift;
    my $rule = shift;

    $self->{hiers}{$parent} = [] unless exists $self->{hiers}{$parent};
    push @{$self->{hiers}{$parent}}, $child;

    foreach my $record (@{$self->{records}}){
        $record->{$parent} = $rule->($record->{$child});
    }
    $self;
}

# 次元の削除
sub remove_dimension {
    my $self = shift;
    my $data = shift;
    while(my ($i, $dim) = each @{$self->{dims}}){

    }
    $self;
};

# 演算をセットする
sub measure {
    my $self = shift;
    my $name = shift;
    my $func = shift;

    # TODO: validation

    push @{$self->{measures}}, {name => $name, func => $func};
    $self;
};

# 一つの要素についてより詳細な分割を行う
sub drilldonw {
};

# いくつかの要素を一つの要素にまとめ上げる
sub drillup {
};

# ひとつの要素を固定し取り出す
sub slice {
    my $self = shift;
    my ($dim, $key) = @_;

    my @dims = @{$self->{dims}};
    while(my ($i, $d) = each @dims){
        if($d eq $dim){
            splice @dims, $i, 1;
        }
        if($i == scalar @dims - 1){
            carp "Error";
            return 0;
        }
    }
    unshift @dims, $dim;

    my $entries = $self->rollup(@dims);
    foreach my $entry (@$entries){
        if($entry->{key} eq $key){
            return $entry;
        }
    }
};

# サブキューブを取り出す
sub dice {
};

# すべてのセルで演算を行う
sub rollup {
    my $self = shift;
    my @dims = @_;

    my @Dims = @{$self->{dims}};
    if(scalar @dims > 0){
        @Dims = @dims;
    }

    my $nest = new Data::Nest();
    foreach my $dim (@Dims){
        $nest->key($dim);
    }
    foreach my $roll (@{$self->{measures}}){
        $nest->rollup($roll->{name}, $roll->{func});
    }
    $self->{cells} = $nest->entries($self->{records});
};

sub fromDateToMonth {
    my $d = shift;
    warn $d."\n";
    if($d =~ /^(\d+)\/(\d+)\/(\d+)/){
        my ($m, $d, $Y) = ($1, $2, $3);
        return "$Y/$m";
    }
    undef;
};

1;
__END__

=encoding utf-8

=head1 NAME

Data::Cube - It's new $module

=head1 SYNOPSIS

    use Data::Cube;

=head1 DESCRIPTION

Data::Cube is ...

==head2 METHODS

    my $cube = new Data::Cube();
    $cube->slide();
    $cube->dice();
    $cube->rollup();

=head1 LICENSE

Copyright (C) muddydixon.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

muddydixon E<lt>muddydixon@gmail.comE<gt>

=cut
