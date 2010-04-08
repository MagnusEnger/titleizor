#!/opt/local/bin/perl -w

# Copyright 2010 Magnus Enger Libriotech
# 
# This file is part of titleizor.
# 
# titleizor is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# titleizor is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with titleizor. If not, see <http://www.gnu.org/licenses/>.
# 
# Source code available from:
# http://github.com/MagnusEnger/titleizor

use Getopt::Long;
use Pod::Usage;
use Image::Magick;
use File::Slurp;
use strict;

my ($img, $out, $text, $dir, $verbose) = get_options();

if ($img && $out && $text) { 
	titleize_img($img, $out, $text, $verbose); 
} elsif ($dir) {
	if (!-e $dir) {
		die "Directory \"$dir\" does not exist!\n";
	}
	if (!-e $dir . "titles.txt") {
		die $dir . "titles.txt does not exist!\n";
	}
	# TODO: Check for trailing slash
	my $outdir = $dir . "out/";
	if ($verbose) {
		print "\n";
		print "Directory: $dir\n";
		print "Output directory: $outdir\n";
	}
	# Read the list of files and titles from file
	my @lines = read_file($dir . "titles.txt");
	foreach my $line (@lines) {
		$line =~ s/\n//g;
		my ($file, $title) = split(/,/, $line);
		# Print some info
		if ($verbose) {
			print "\n----- Filename: $file -----\n";
			print "Title:   $title\n";
			print "Infile:  $dir$file\n";
			print "Outfile: $outdir$file\n";
		}
		titleize_img($dir . $file, $outdir . $file, $title, $verbose);
	}
	print "\n";
} else {
	die "Missing parameters!\n";	
}

# FUNCTIONS

sub titleize_img {

	my ($img, $out, $text, $verbose) = @_; 
	my $status;
	
	my $orig = new Image::Magick;
	$orig->Read($img);
	
	# Print out some basic info about the image
	if ($verbose) {
		print "\n";
		print "Image:       ", $img, "\n";
		print "Out:         ", $out, "\n";
		print "Text:        ", $text, "\n";
		print_img_info($orig);
	}
	
	# $orig->Display();
	
	# Create a new image to hold the title
	my $title = new Image::Magick;
	
	# Calculate number of pixels to add to the height
	my $add_height = ($orig->Get("height") * 5) / 100;
	my $new_height = $orig->Get("height") + $add_height;
	
	# Set some properties of the new image, based on those of the old one
	$status = $title->Set(
		'size'        => $orig->Get('width') . "x" . $new_height, 
		'type'        => $orig->Get('type'), 
		'compression' => $orig->Get('compression'), 
		# 'density'     => $orig->Get('density'), # This messes up the dimensions of the text somehow...
		'depth'       => $orig->Get('depth')
	);
	die "$status" if $status;
	$status = $title->ReadImage('xc:black'); 
	die "$status" if $status;
	
	$status = $title->Annotate(
		'text' => $text, 
		'font' => 'Arial', 
		'pointsize' => $add_height - 5, 
		# 'family' => '', 
		'style' => 'Normal', 
		# 'stretch' => '', 
		'weight' => 50, 
		# 'density' => '', 
		# 'align' => '', 
		'stroke' => 'white', 
		# 'stroke_width' => '', 
		'fill' => 'white', 
		# 'box' => '', 
		'x' => 0, 
		'y' => 0, 
		# 'geometry' => '', 
		'gravity' => 'South-West', 
		'antialias' => 1, 
		# 'translate' => '', 
		# 'scale' => '', 
		# 'rotate' => '', 
		# 'skewX' => '', 
		# 'skewY' => ''
	);
	die "$status" if $status;
	
	$status = $title->Composite(
		'compose' => 'Atop', 
		'image' => $orig, 
		# 'geometry' => '', 
		# 'x' => '', 
		# 'y' => '', 
		# 'opacity' => 100, 
		'gravity' => 'North' 
	);
	die "$status" if $status;
	
	$status = $title->Write("tiff:" . $out);
	die "$status" if $status;
	
	if ($verbose) {
		print "\nOutput:   $out\n";
		my $titled = new Image::Magick;
		$titled->Read($out);
		print_img_info($titled);
	}

}

sub print_img_info {

	my $img = shift;

	print "Filesize:    ", $img->Get("filesize"), "\n";
	print "Height:      ", $img->Get("height"), "\n";
	print "Width:       ", $img->Get("width"), "\n";
	print "Format:      ", $img->Get("format"), "\n";
	print "Interlace:   ", $img->Get("interlace"), "\n";
	print "Density:     ", $img->Get("density"), "\n";
	print "Depth:       ", $img->Get("depth"), "\n";
	print "Compression: ", $img->Get("compression"), "\n";
	print "Type:        ", $img->Get("type"), "\n";
	print "Quality:     ", $img->Get("quality"), "\n";
	
}

# Get commandline options
sub get_options {
	my $img = '';
	my $out = '';
	my $text = '';
	my $dir = '';
	my $verbose = 0;
	my $help = '';
	
	GetOptions("i|img=s" => \$img,
	        "o|out=s" => \$out, 
	        "t|text=s" => \$text,
	        "d|dir=s" => \$dir,
	           "v|verbose!" => \$verbose,
	           'h|?|help'   => \$help
	           );
	
	pod2usage(-exitval => 0) if $help;
	if (!$dir && !$img) {
		pod2usage( -msg => "\nMissing Argument: -i, --img OR -d, --dir required\n", -exitval => 1);
	}
	# pod2usage( -msg => "\nMissing Argument: -o, --out required\n", -exitval => 1) if !$out;
	
	return ($img, $out, $text, $dir, $verbose);
}   

__END__

=head1 NAME
    
titleizor.pl - Add titles below TIFF images. 
        
=head1 SYNOPSIS
            
titleizor.pl -i my_picture.tif -o my_picture_with_title.tif -t "This is my picture"

titleizor.pl -d ../images/ -v
               
=head1 OPTIONS
              
=over 8
                                                   
=item B<-i, --img>

A single picture to process. 

=item B<-o, --out>

Destination for a single picture. 
                                                       
=item B<-t, --text>

Text to add to a single picture

=item B<-d, --dir>

Looks for a file called titles.txt in the given directory, with the format "filename,title" and adds given titles to listed files. 

=item B<-v, --verbose>

Turn on verbose output.

=item B<-h, -?, --help>
                                               
Prints this help message and exits.

=back
                                                               
=cut