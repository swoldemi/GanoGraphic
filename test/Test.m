%{
    This test encodes a message, displays the steganography and decrypts
    the message with a key
    Author: Simon W.
    Repository: www.github.com/swoldemi/GanoGraphic
%}
clear; clc;
%{
% BEGIN ENCRYPTION
% Create a new Encoder object with the class constructor
enc = SteganographicEncoder('original.png', 'Hello World!');

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

% Show the steganographic image
showImage(enc)
%}

% BEGIN DECRYPTION
% Create a new Decoder object with the class constructor
dec = SteganographicDecoder('Gano-original.png', 'GanoDecryptionKey.MAT');

% Confirm the image is valid
try
    checkFile(dec)
catch InvalidGanoImageException
    msgbox(InvalidGanoImageException.message, InvalidGanoImageException.identifier)
    return
end