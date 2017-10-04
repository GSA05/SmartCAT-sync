# ABSTRACT: set up SmartCAT
package SmartCAT::Command::update_stores;
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

    Class::Load::load_class('LWP::UserAgent');
    Class::Load::load_class('Mojo::URL');

    my $ua = LWP::UserAgent->new;

    #my $url = Mojo::URL->new('https://'.($opt->{token_id}).':'.($opt->{token}).'@smartcat.ai/api/integration/v1/project/document');
    my $url = Mojo::URL->new('https://smartcat.ai/api/integration/v1/project/document');
    $url->query({projectId => $opt->{project}});
    my $request = HTTP::Request->new('POST', $url->to_unsafe_string);

    my $boundary = 'X';
    my @rand = ('a'..'z', 'A'..'Z');
    for (0..14) {$boundary .= $rand[rand(@rand)];}

    $request->header('Content-Type' => 'multipart/form-data; boundary='.$boundary);
    $request->header('Authorization' => 'Basic '.$key);
    #$request->header('User-Agent' => '<i>Mozilla Firefox 5.0 :-)</i>');
    #$request->header('Referer' => '<i>http://somedomain.com/form</i>');
    #$request->protocol('HTTP/1.0');

    #my $header = HTTP::Headers->new;
    #$header->header('Content-Disposition' => 'form-data; name="documentModel"');
    #$header->header('Content-Type' => 'application/json');
    #my $file_content = HTTP::Message->new($header);
    #$file_content->add_content('{}');
    #$request->add_part($file_content);

    my $file = 'C:\Projects\Serge\Test\Test\po\0e811ad8-f350-475b-808f-895d85e54da9\ru\test.txt.po';
    open(my $fh, '<:bytes', $file);
    my $size = (stat $file)[7];
    my $header = HTTP::Headers->new;
    $header->header('Content-Disposition' => 'form-data; name="documentModel"; filename="test.txt"');
    $header->header('Content-Type' => 'application/octet-stream');
    my $file_content = HTTP::Message->new($header);
    $file_content->add_content($_) while <$fh>;
    $request->add_part($file_content);
    close $fh;

    print $request->as_string;

    my $response = $ua->request($request);
    if ($response->is_success) {
        print $response->content;
    } else {
        #die $response->status_line;
    }

    #my $tx = $ua->get('https://'.($opt->{token_id}).':'.($opt->{token}).'@smartcat.ai/api/integration/v1/project/0e811ad8-f350-475b-808f-895d85e54da9');
    #print $tx->result->body;

    print "Everything has been initialized.  (Not really.)\n";
}

1;