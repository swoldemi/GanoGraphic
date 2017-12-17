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
        EncryptionKey % Locations of all of the bytes that were encoded
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
        
        
    end    
end