package SmartCAT;

use App::Cmd::Setup -app;
use Class::Load;
#use Data::Dumper;

sub getAuthKey {
    my ($self, $token_id, $token) = @_;

    Class::Load::load_class('MIME::Base64');
    my $key = MIME::Base64::encode_base64("$token_id:$token");

    return $key;
}

1;