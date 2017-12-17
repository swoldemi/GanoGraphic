%{
    This handle class encodes an image using the LSB algorithm of
    steganographic encoding

%}
classdef SteganographicEncoder < handle
    properties
        Message % The message to be embeded into the image
        Image % The image to be used for encoding
        Valid % Logical value to confirm that the image is valid
    end
    methods
        %{
            Check the file extension and throw an exception if it is not
            Currently only supporting PNG and TIFF files
        %}
        function cf = checkFile(obj)
            [file_name, file_extension] = strtok(obj.Image, '.');
            msgID = 'checkFile:invalidImage';
            msg = strcat(file_name, ' is not an image.');
            InvalidImageException = MException(msgID, msg);
            if strcmp('.png', file_extension) == 0 && strncmp('.tiff', file_extension, 4) == 0
               obj.Valid = 0;
               throw(InvalidImageException)
            else
                obj.Valid = 1;
            end
        end
    end    
end