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
    my @files = $self->app->getFiles($opt->{po_path}, $opt->{project});

    my @newFiles;
    foreach my $file (@files) {
        my $new = 1;
        foreach my $document (@documents) {
            if ($document->{name}.'.po' eq $file) {
                $new = 0;
                last;
            }
        }
        if ($new) {
            push @newFiles, $file;
        }
    }

    my $path = $opt->{po_path}.'/'.$opt->{project};

    my $first_lang_dir;
    opendir(DIR, $path) or die $!;
    while (my $lang_dir = readdir(DIR)) {
      next if ($lang_dir =~ m/^\./);
      $first_lang_dir = $lang_dir;
      last;
    }
    closedir(DIR);

    foreach my $file (@newFiles) {
        $self->app->uploadFile($opt->{po_path}, $opt->{project}, $opt->{token_id}, $opt->{token}, $file, $first_lang_dir);
    }

    @documents = $self->app->getProjectDocuments($opt->{project}, $opt->{token_id}, $opt->{token});

    foreach my $document (@documents) {
      $self->app->updateFile($opt->{po_path}, $opt->{project}, $opt->{token_id}, $opt->{token}, $document->{id}, $document->{name}, $document->{targetLanguage});
    }
}

1;