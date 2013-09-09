use strict;
use Test::More;
use Carp;
use Data::Dumper;

use Data::Cube;

my $cube = new Data::Cube("Country", "Product");

my @header = split /\s+/, (<DATA>);
while(<DATA>){
    chomp;
    my @data = split(/\s+/, $_);
    my %obj;
    foreach my $attr (@header) {
        if($attr !~ /^\s*$/){
            $obj{$attr} = shift @data;
        }else{
            shift @data;
        }
    }
    $cube->put(\%obj);
}

$cube->add_hierarchy("Date", "Month",
                     sub {
                         my $d = shift;
                         if($d =~ /^(\d+)\/(\d+)\/(\d+)$/){
                             my ($m, $d, $Y) = ($1, $2, $3);
                             return "$Y/$m";
                         }
                         undef;
                     });

$cube->add_hierarchy("Month", "Year",
                     sub {
                         my $d = shift;
                         if($d =~ /^(\d+)\/(\d+)$/){
                             my ($Y, $m) = ($1, $2);
                             return "$Y";
                         }
                         undef;
                     });
$cube->measure("totalUnit", sub {my ($sum, @data) = (0, @_); foreach my $d (@data){ $sum += $d->{Units};} $sum; });
warn Dumper $cube->slice("Product", "Pencil");


ok 1;


done_testing;

__DATA__
    Date         Country   SalesPerson     Product     Units   Unit_Cost       Total
    3/15/2005         US       Sorvino      Pencil        56        2.99      167.44
    3/7/2006          US       Sorvino      Binder         7       19.99      139.93
    8/24/2006         US       Sorvino        Desk         3      275.00      825.00
    9/27/2006         US       Sorvino         Pen        76        1.99      151.24
    5/22/2005         US      Thompson      Pencil        32        1.99       63.68
    10/14/2006        US      Thompson      Binder        57       19.99     1139.43
    4/18/2005         US       Andrews      Pencil        75        1.99      149.25
    4/10/2006         US       Andrews      Pencil        66        1.99      131.34
      10/31/2006        US       Andrews      Pencil       114        1.29      147.06
      12/21/2006        US       Andrews      Binder        28        4.99      139.72
      2/26/2005         CA          Gill         Pen        51       19.99     1019.49
      1/15/2006         CA          Gill      Binder        46        8.99      413.54
      5/14/2006         CA          Gill      Pencil        94        1.29      121.26
      5/31/2006         CA          Gill      Binder       102        8.99      916.98
      9/10/2006         CA          Gill      Pencil        98        1.29      126.42
      2/9/2005          UK       Jardine      Pencil       125        4.99      623.75
      5/5/2005          UK       Jardine      Pencil        90        4.99      449.10
      3/24/2006         UK       Jardine      PenSet        76        4.99      379.24
      11/17/2006        UK       Jardine      Binder        39        4.99      194.61
      12/4/2006         UK       Jardine      Binder        94       19.99     1879.06
      1/23/2005         US        Kivell      Binder        50       19.99      999.50
      11/25/2005        US        Kivell      PenSet        96        4.99      479.04
      6/17/2006         US        Kivell        Desk         5      125.00      625.00
      8/7/2006          US        Kivell      PenSet        42       23.95     1005.90
      6/25/2005         UK        Morgan      Pencil        90        4.99      449.10
      10/5/2005         UK        Morgan      Binder        28        8.99      251.72
      7/21/2006         UK        Morgan      PenSet        55       12.49      686.95
      9/1/2005          US         Smith        Desk         2      125.00      250.00
      12/12/2005        US         Smith      Pencil        67        1.29       86.43
      2/1/2006          US         Smith      Binder        87       15.00     1305.00
      7/12/2005         US        Howard      Binder        29        1.99       57.71
      4/27/2006         US        Howard         Pen        96        4.99      479.04
      1/6/2005          CA         Jones      Pencil        95        1.99      189.05
      4/1/2005          CA         Jones      Binder        76        4.99      379.24
      6/8/2005          CA         Jones      Binder        60        8.99      539.40
      8/15/2005         US         Jones      Pencil        35        4.99      174.65
      9/18/2005         US         Jones      PenSet        16       15.99      255.84
      10/22/2005        US         Jones         Pen        64        8.99      575.36
      2/18/2006         CA         Jones      Binder         4        4.99       19.96
      7/4/2006          CA         Jones      PenSet        61        4.99      304.39
      7/29/2005         UK         Hogan      Binder        81       19.99     1619.19
      11/8/2005         UK         Hogan         Pen        12       19.99      239.88
      12/29/2005        UK         Hogan      PenSet        74       15.99     1183.26
