%{
    This test encodes a message, displays the steganography and decrypts
    the message with a key
    Author: Simon W.
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

% Show the original image
showImage(enc)

% Prepare the message
prepareMessage(enc)

% Preform the steganography
encode(enc)

% Save the key to the disk
saveKey(enc)