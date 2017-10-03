# ABSTRACT: set up SmartCAT
package SmartCAT::Command::initialize;
use SmartCAT -command;
use Data::Dumper;

sub opt_spec {
    return (
        [ 'token_id:s' => 'An id of SmartCAT account' ],
        [ 'token:s'    => 'API token' ],
    )
}

sub execute {
  my ($self, $opt, $args) = @_;

  my $key = $self->app->getAuthKey($opt->{token_id}, $opt->{token});

  print "Everything has been initialized.  (Not really.)\n";
}

1;