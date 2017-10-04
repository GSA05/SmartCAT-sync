package SmartCAT;

use App::Cmd::Setup -app;
use Class::Load;
use Data::Dumper;

sub getAuthKey {
    my ($self, $token_id, $token) = @_;

    Class::Load::load_class('MIME::Base64');
    my $key = MIME::Base64::encode_base64("$token_id:$token");

    return $key;
}

sub getProjectDocuments {
    my ($self, $project, $token_id, $token) = @_;

    my $key = $self->getAuthKey($token_id, $token);

    Class::Load::load_class('LWP::UserAgent');
    Class::Load::load_class('Mojo::URL');
    Class::Load::load_class('JSON::XS');

    my $ua = LWP::UserAgent->new;

    my $url = Mojo::URL->new('https://smartcat.ai/api/integration/v1/project/'.($project));
    my $request = HTTP::Request->new('GET', $url->to_string);

    $request->header('Accept' => 'application/json');
    $request->header('Authorization' => 'Basic '.$key);
    #$request->protocol('HTTP/1.0');

    print $request->as_string;

    my $response = $ua->request($request);
    if ($response->is_success) {
        return (JSON::XS::decode_json($response->content))->{documents};
    } else {
        die $response->status_line;
    }
}

sub getFile {
  my ($self, $token_id, $token) = @_;
}

1;