% Verify Action
choice = questdlg('What would you like to do?', ...
	'GanoGraphic Menu', ...
	'Encrypt','Decrypt','Exit');

% Handle response
switch choice
    case 'Encrypt'
        % Take in user input
        prompt = {'Enter image name:', 'Enter message:'};
        dlg_title = 'GanoGraphic Steganography Encryption';
        num_lines = 1;
        default_ans = {'.png, .tiff, or .tiff only', 'Hello friend.'};
        result = inputdlg(prompt, dlg_title, num_lines, default_ans, 'on');
        encrypt(result);
        
    case 'Decrypt'
        % Take in user input
        prompt = {'Enter steganographic image name:', 'Enter encrypted decryption key name:'};
        dlg_title = 'GanoGraphic Steganography Decryption';
        num_lines = 1;
        default_ans = {'', ''};
        result = inputdlg(prompt, dlg_title, num_lines, default_ans, 'on');
        decrypt(result);
    case 'Exit'
        return;
end

function encrypt(result)
    % BEGIN ENCRYPTION
    % Create a new Encoder object with the class constructor
    enc = SteganographicEncoder(result{1}, result{2});

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
    %showImage(enc)

    % Prepare the message
    prepareMessage(enc)

    % Preform the steganography
    encode(enc)

    % Encrypt and save the key to the disk
    saveKey(enc)

    % Write the steganographic image to the disk
    saveGano(enc)

    % Show the steganographic image
    %showImage(enc)
end

function decrypt(result)
    %BEGIN DECRYPTION
    % Create a new Decoder object with the class constructor
    dec = SteganographicDecoder(result{1}, result{2});

    % Confirm the image is valid
    try
        checkFile(dec)
    catch InvalidGanoImageException
        msgbox(InvalidGanoImageException.message, InvalidGanoImageException.identifier)
        return
    end

    % Load in the image
    loadSteganography(dec)

    % Load the decryption key
    loadDecryptionKey(dec)

    % Decrypt the message
    decode(dec)

    % Display the message
    msgbox(strcat('Message:', dec.DecryptedMessage))
end
