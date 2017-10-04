# ABSTRACT: set up SmartCAT
package SmartCAT::Command::sync_stores;
use SmartCAT -command;
use Class::Load;
use Data::Dumper;

sub opt_spec {
    return (
        [ 'project:s'  => 'Id of the project' ],
        [ 'token_id:s' => 'An id of SmartCAT account' ],
        [ 'token:s'    => 'API token' ],
    )
}

sub execute {
  my ($self, $opt, $args) = @_;

  my $key = $self->app->getAuthKey($opt->{token_id}, $opt->{token});

  my @documents = $self->app->getProjectDocuments($opt->{project}, $opt->{token_id}, $opt->{token});

  print "Everything has been initialized.  (Not really.)\n";
}

1;