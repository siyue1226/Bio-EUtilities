package Bio::Tools::EUtilities::Link::UrlLink;

use utf8;
use base qw(Bio::Root::Root Bio::Tools::EUtilities::EUtilDataI);

# ABSTRACT: Class for EUtils UrlLinks.
# AUTHOR:   Chris Fields <cjfields@bioperl.org>
# OWNER:    2006-2013 Chris Fields
# LICENSE:  Perl_5

=head1 SYNOPSIS

  # ...

=head1 DESCRIPTION

  # ...

=cut

=head2 get_dbfrom

 Title    : get_dbfrom
 Usage    :
 Function :
 Returns  :
 Args     :

=cut

sub get_dbfrom { return shift->{'_dbfrom'}; }

=head2 get_attribute

 Title    : get_attribute
 Usage    :
 Function :
 Returns  :
 Args     :

=cut

sub get_attribute { return shift->{'_attribute'}; }

=head2 get_icon_url

 Title    : get_icon_url
 Usage    :
 Function :
 Returns  :
 Args     :

=cut

sub get_icon_url { return shift->{'_iconurl'}; }

=head2 get_subject_type

 Title    :
 Usage    :
 Function :
 Returns  :
 Args     :

=cut

sub get_subject_type { return shift->{'_subjecttype'}; }

=head2 get_url

 Title    : get_url
 Usage    :
 Function :
 Returns  :
 Args     :

=cut

sub get_url {
    my $self = shift;
    # fix Entrz LinkOut URLS without the full URL
    if ($self->{'_url'} && $self->{'_url'} =~ m{^/}) {
        $self->{'_url'} = 'http://www.ncbi.nih.gov'.$self->{'_url'};
    }
    return $self->{'_url'};
}

=head2 get_link_name

 Title    : get_link_name
 Usage    :
 Function :
 Returns  :
 Args     :

=cut

sub get_link_name { return shift->{'_linkname'};  }

=head2 get_provider_name

 Title    : get_provider_name
 Usage    :
 Function :
 Returns  :
 Args     :

=cut

sub get_provider_name { return shift->{'_provider_name'}; }

=head2 get_provider_abbr

 Title    : get_provider_abbr
 Usage    :
 Function :
 Returns  :
 Args     :

=cut

sub get_provider_abbr { return shift->{'_provider_nameabbr'}; }

=head2 get_provider_id

 Title    : get_provider_id
 Usage    :
 Function :
 Returns  :
 Args     :

=cut

sub get_provider_id { return shift->{'_provider_id'}[0]; }

=head2 get_provider_icon_url

 Title    : get_provider_icon_url
 Usage    :
 Function :
 Returns  :
 Args     :

=cut

sub get_provider_icon_url { return shift->{'_provider_iconurl'}; }

=head2 get_provider_url

 Title    : get_provider_url
 Usage    :
 Function :
 Returns  :
 Args     :

=cut

sub get_provider_url { return shift->{'_provider_url'}; }

# private method

sub _add_data {
    my ($self, $data) = @_;
    if (exists $data->{Provider}) {
        map {$self->{'_provider_'.lc $_} = $data->{Provider}->{$_};
            } keys %{$data->{Provider}};
        delete $data->{Provider};
    }
    map {$self->{'_'.lc $_} = $data->{$_} if $data->{$_}} keys %$data;
}

=head2 to_string

 Title    : to_string
 Usage    : $foo->to_string()
 Function : converts current object to string
 Returns  : none
 Args     : (optional) simple data for text formatting
 Note     : Used generally for debugging and for various print methods

=cut

sub to_string {
    my $self = shift;
    my $level = shift || 0;
    my $pad = 20 - $level;
    #        order     method                    name
    my %tags = (1 => ['get_link_name'          => 'Link Name'],
                2 => ['get_subject_type'       => 'Subject Type'],
                3 => ['get_dbfrom'             => 'DB From'],
                4 => ['get_attribute'          => 'Attribute'],
                6 => ['get_icon_url'           => 'IconURL'],
                7 => ['get_url'                => 'URL'],
                8 => ['get_provider_name'      => 'Provider'],
                9 => ['get_provider_abbr'      => 'ProvAbbr'],
                10 => ['get_provider_id'       => 'ProvID'],
                11 => ['get_provider_url'      => 'ProvURL'],
                12 => ['get_provider_icon_url' => 'ProvIcon'],
                );
    my $string = '';
    for my $tag (sort {$a <=> $b} keys %tags) {
        my ($m, $nm) = ($tags{$tag}->[0], $tags{$tag}->[1]);
        my $content = $self->$m();
        next unless $content;
        $string .= $self->_text_wrap(
                 sprintf("%-*s%-*s:",$level, '',$pad, $nm,),
                 ' ' x ($pad).':',
                 $content)."\n";
    }
    return $string;
}

1;
