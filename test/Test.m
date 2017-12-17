%This program decodes a Steganography image for a message given a stegagraphic image and key

%Simon Woldemichael

clear; clc;

%Create a new Encoder object
enc = SteganographicEncoder;
enc.Image = 'original.xxx';
enc.Message = 'Hello World!';

%Confirm the image is valid
try
    checkFile(enc)
catch InvalidImageException
    msgbox(InvalidImageException.message, InvalidImageException.identifier)
end

if enc.Valid == 0
    %exit
end

%
