# ABSTRACT: set up SmartCAT
package SmartCAT::Command::update_stores;
use SmartCAT -command;
use Class::Load;
use Data::Dumper;

sub opt_spec {
    return (
        [ 'po_path:s'  => 'Path to the po files' ],
        [ 'project:s'  => 'Id of the project' ],
        [ 'token_id:s' => 'An id of SmartCAT account' ],
        [ 'token:s'    => 'API token' ],
    )
}

sub execute {
    my ($self, $opt, $args) = @_;

    my @documents = $self->app->getProjectDocuments($opt->{project}, $opt->{token_id}, $opt->{token});

    foreach my $document (@documents) {
      $self->app->updateFile($opt->{po_path}, $opt->{project}, $opt->{token_id}, $opt->{token}, $document->{id}, $document->{name}, $document->{targetLanguage});
  }
}

1;