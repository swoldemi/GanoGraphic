%This program decodes a Steganography image for a message given a stegagraphic image and key

%Simon Woldemichael
%Turned in Thursday October, 8, 2015 for bonus points

clear; clc;

%Create a new Encoder object
enc = SteganographicEncoder;
enc.Image = 'original.png';
enc.Message = 'Hello World!';

%Confirm the image is valid
try
    checkFile(enc)
catch InvalidImageException
    disp('hi')
end

if enc.Valid == 1
    disp('Continuing with encryption')
end