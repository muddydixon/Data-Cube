# NAME

Data::Cube - It's new $module

# SYNOPSIS

    use Data::Cube;

    my $cube = new Data::Cube("Product", "Country"); # specify dimension

# DESCRIPTION

Data::Cube is ...

## METHODS



    my $cube = new Data::Cube();
    $cube->add_dimension();
    $cube->add_hierarchy();
    $cube->add_measure();

    $cube->reorder_dimension();

    $cube->dice();
    $cube->slide();

    $cube->rollup();

# LICENSE

Copyright (C) muddydixon.
Apache License Version 2.0

# AUTHOR

muddydixon <muddydixon@gmail.com>
