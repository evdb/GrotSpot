package GrotSpot::Form::Advert;

use strict;
use warnings;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
with 'GrotSpot::Form::Render::Table';

has_field 'enabled' => (
    type             => 'Checkbox',
    label            => "Enabled",
);

has_field 'heading' => (
    type             => 'Text',
    label            => "Heading",
    required         => 1,
    required_message => 'Please enter a heading',
);

has_field 'blurb' => (
    type             => 'TextArea',
    label            => "Blurb",
    required         => 1,
    required_message => 'Please enter some blurb',
);


has_field 'price' => (
    type             => 'Text',
    label            => "Price",
    required         => 1,
    required_message => 'Please enter a price',
);

has_field 'url' => (
    type             => 'Text',
    label            => "URL",
    required         => 1,
    required_message => 'Please enter a url',
);

has_field 'image_url' => (
    type             => 'Text',
    label            => "Image URL",
    required         => 1,
    required_message => 'Please enter an image url',
);

has_field 'submit' => ( type => 'Submit' );

no HTML::FormHandler::Moose;

1;
