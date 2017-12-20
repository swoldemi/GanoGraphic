%{
    This handle class decodes an image using the decryption key returned
    by the encoder class for GanoGraphic
    Author: Simon W.
    Repository: www.github.com/swoldemi/GanoGraphic
%}
classdef GanoGraphicDecoder < handle
    properties
        DecryptedMessage % The original message that was embedded in the image
        ImageName  % The name of the image to be used
        Valid % Logical value to confirm that the image is valid
        ImageData % The pixel data of the image
        DecryptionKey % Locations of all of the bytes that were encoded
        MessageLength % The length of the message
    end
    methods
 
        %{
            Constructor
        %}
        function obj = GanoGraphicDecoder(filename, key_name)
            obj.DecryptionKey = key_name;
            obj.ImageName = filename;
        end
        
        %{
            Check the file prefix to confirm that it was generated by the
            GanoGraphic encoder
        %}
        function checkFile(obj)
            msgID = 'checkFile:invalidImage';
            msg = strcat(obj.ImageName, ' is not a GanoGraphic image.');
            InvalidGanoImageException = MException(msgID, msg);
            if strcmp(strtok(obj.ImageName, '-'), 'GanoImage') == 0
               throw(InvalidGanoImageException)
            else
                obj.Valid = 1;
            end
        end
        
        %{
            Load the steganography
        %}
        function loadSteganography(obj)
            obj.ImageData = imread(obj.ImageName);
        end
        
        %{
            Decrypt and load the decryption key
        %}
        function loadDecryptionKey(obj)
            [status, cmd_out] = system('private.bat'); % GPG requires --batch option for symmetric decryption
            key_file = fopen('GanoDecryptionKey', 'rt');
            obj.DecryptionKey = fscanf(key_file, '%u');
            fclose(key_file);
            
        end
        
        %{
            Retrieve the message
        %}
        function decode(obj) 
            obj.MessageLength = length(obj.DecryptionKey)/8;
            
            % Retrieve all of the LSBs embeded in the image located
            % at the indices given in the decryption key
            % Use DEC2BIN since DE2BI converts to binary vectors
            obj.DecryptedMessage = dec2bin(obj.ImageData(obj.DecryptionKey), 8);
            obj.DecryptedMessage = reshape(obj.DecryptedMessage, [length(obj.DecryptionKey), 8]);
            
            % Convert the message to ASCII
            % use BIN2DEC since BI2DE assumes binary vectors
            obj.DecryptedMessage = obj.DecryptedMessage((length(obj.DecryptionKey):-1:1), 8);
            obj.DecryptedMessage = reshape(obj.DecryptedMessage, [obj.MessageLength, 8]);
            obj.DecryptedMessage = char(uint8(bin2dec(obj.DecryptedMessage)));
            
            % Reshape the text
            obj.DecryptedMessage = flip(reshape(obj.DecryptedMessage, [1, obj.MessageLength])); 
            
            % Clean up before exit
            obj.DecryptionKey = '';
            [status, cmd_out] = system('del GanoDecryptionKey.gpg && del GanoDecryptionKey');
        end
    end    
end