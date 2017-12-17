%{
    This test encodes a message, displays the steganography and decrypts
    the message with a key
    Author: Simon W.
    Repository: www.github.com/swoldemi/GanoGraphic
%}
clear; clc;

% Create a new Encoder object with the class constructor
enc = SteganographicEncoder('original.xxx', 'Hello World!');

% Confirm the image is valid
try
    checkFile(enc)
catch InvalidImageException
    msgbox(InvalidImageException.message, InvalidImageException.identifier)
    return
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

% Write the steganographic image to the disk
saveGano(enc)
