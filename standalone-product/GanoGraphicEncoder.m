%{
    This handle class encodes an image using the LSB algorithm of
    steganographic encoding for GanoGraphic
    Author: Simon W.
    Repository: www.github.com/swoldemi/GanoGraphic
%}
classdef GanoGraphicEncoder < handle
    properties
        Message % The message to be embeded into the image
        ImageName % The name of the image to be used
        Valid % Logical value to confirm that the image is valid
        ImageData % The pixel data of the image
        DecryptionKey % Locations of all of the bytes that were encoded
        MessageLength % The length of the message
        MessageASCII % The ASCII equivalents of the message
        MessageBinary % Binary conversion of the message
        State % Logical value stating whether or not the encryption has occcured
    end
    methods
 
        %{
            Constructor
        %}
        function obj = GanoGraphicEncoder(filename, message)
            obj.Message = message;
            obj.ImageName = filename;
            obj.State = 0;
        end
        %{
            Check the file extension and throw an exception if it is not
            Currently only supporting PNG and TIFF files
        %}
        function checkFile(obj)
            [file_name, file_extension] = strtok(obj.ImageName, '.'); %#ok<ASGLU>
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
            if obj.State == 0
                imshow(obj.ImageData)
                title('Original Image');
            else
                figure(2);
                imshow(obj.ImageData);
                title('Steganographic Image');
            end
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
            
            % Replace the LSB of each binary value to hold bits of the message
            binConversion(1:obj.MessageLength*8) = obj.MessageBinary(1:obj.MessageLength*8);
            
            % Convert decimal pixel values and put replace them in the image
            encryptedCells = bi2de(binConversion);
            
            % Embed the encrypted message in the image
            % ImageData is now the steganographic image
            obj.ImageData(obj.DecryptionKey) = encryptedCells;
            
            % Update State
            obj.State = 1;
        end
        
        %{
            Save the decryption key
            ***TO DO***: 
                 *      PCode the entire saveKey method
        %}
        function saveKey(obj, recipient)
            GanoDecryptionKey = obj.DecryptionKey;
            key_file = fopen('GanoDecryptionKey', 'wt');
            fprintf(key_file, '%u\n', GanoDecryptionKey);
            
            % Encrypt the key and delete the unencrypted key 
            p = fopen('private', 'rt');
            private = fscanf(p, '%s');
            fclose('all');
            
            enc_cmd = sprintf('gpg --passphrase %s -r "%s" --encrypt GanoDecryptionKey', private, recipient);
            enc_cmd = sprintf('%s && del /f GanoDecryptionKey', enc_cmd);
            [status, cmd_out] = system(enc_cmd);
        end
        
        
        %{
            Save the steganograpic image to the disk
        %}
        function saveGano(obj)
            new_file_name = strcat('GanoImage-', obj.ImageName);
            imwrite(obj.ImageData, new_file_name, 'png')
        end
    end
end