% 
% 
%{
    This test encodes a message, displays the steganography and decrypts
    the message with a key
    Author: Simon Woldemichael
    Repository: www.github.com/swoldemi/GanoGraphic
%}
clear; clc;

% Create a new Encoder object
enc = SteganographicEncoder;
enc.ImageName = 'original.png';
enc.Message = 'Hello World!';

% Confirm the image is valid
try
    checkFile(enc)
catch InvalidImageException
    msgbox(InvalidImageException.message, InvalidImageException.identifier)
    %exit
end

% Load the image
loadImage(enc)

% Show the image
showImage(enc)
