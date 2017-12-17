%{
    This handle class encodes an image using the LSB algorithm of
    steganographic encoding

%}
classdef SteganographicEncoder < handle
    properties
        Message % The message to be embeded into the image
        ImageName % The name of the image to be used
        Valid % Logical value to confirm that the image is valid
        ImageData % The pixel data of the image
        DecryptionKey % Locations of all of the bytes that were encoded
        MessageLength % The length of the message
        MessageASCII % The ASCII equivalents of the message
        MessageBinary % Binary conversion of the message
    end
    methods
        
        %{
            Check the file extension and throw an exception if it is not
            Currently only supporting PNG and TIFF files
        %}
        function checkFile(obj)
            [file_name, file_extension] = strtok(obj.ImageName, '.');
            msgID = 'checkFile:invalidImage';
            msg = strcat(obj.ImageName, ' is not an image.');
            InvalidImageException = MException(msgID, msg);
            if strcmp('.png', file_extension) == 0 && strncmp('.tiff', file_extension, 4) == 0
               obj.Valid = 0;
               throw(InvalidImageException)
            else
                obj.Valid = 1;
            end
        end
        
        %{
            Read in the image
        %}
        function loadImage(obj)
            obj.ImageData = imread(obj.ImageName);
        end
        
        %{
            Show the image
        %}
        function showImage(obj)
            imshow(obj.ImageData)
        end
                
        %{
            Prepare the encryption object's message properties        
        %}
        function prepareMessage(obj)
            obj.MessageLength = length(obj.Message);
            obj.MessageASCII = uint8(obj.Message);
            obj.MessageBinary = de2bi(obj.MessageASCII, 8);
        end
        
        %{
            Encode the image by replacing the least significant bits of the 
            pixels in the image with the bits of the message        
        %}
        function encode(obj)
            obj.DecryptionKey = randperm(numel(obj.ImageData), numel(obj.MessageBinary));
            
            % Convert pixel values from dec to binary
            binConversion = de2bi(obj.ImageData(obj.DecryptionKey), 8);
            
            % Replace the LSB of each binary value to hold bits of the
            % message
            binConversion(1:obj.MessageLength*8) = obj.MessageBinary(1:obj.MessageLength*8);
            
            % Convert decimal pixel values and put replace them in the image
            encryptedCells = bi2de(binConversion);
            
            % Embed the encrypted message in the image
            % ImageData is now the steganographic image
            obj.ImageData(obj.DecryptionKey) = encryptedCells;           
        end
    end    
end