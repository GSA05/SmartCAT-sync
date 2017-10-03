# ABSTRACT: set up SmartCAT
package SmartCAT::Command::initialize;
use SmartCAT -command;

sub execute {
  my ($self, $opt, $args) = @_;

  print "Everything has been initialized.  (Not really.)\n";
}

1;