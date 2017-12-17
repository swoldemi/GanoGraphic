%{
    This handle class decodes an image using the decryption key returned
    by the encoder class
%}
classdef SteganographicDecoder < handle
    properties
        ImageName
        Valid
        ImageData
        DecryptionKey
        MessageLength
    end
    methods
 
        %{
            Constructor
        %}
        function obj = SteganographicDecoder(filename, key_name)
            obj.DecryptionKey = key_name;
            obj.ImageName = filename;
        end
        %{
            Check the file extension and throw an exception if it is not
            Currently only supporting PNG and TIFF files
        %}
        function checkFile(obj)
            msgID = 'checkFile:invalidImage';
            msg = strcat(obj.ImageName, ' is not a GanoGraphic image.');
            InvalidGanoImageException = MException(msgID, msg);
            if strcmp(strtok(obj.ImageName, '-'), 'Gano') == 0
               throw(InvalidGanoImageException)
            else
                obj.Valid = 1;
            end
        end
        
    end    
end