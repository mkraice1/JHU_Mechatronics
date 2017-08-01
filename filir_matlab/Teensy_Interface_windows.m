END_CODE = 101010
header = 0

% Open serial port to communicate to Teensy
COM1=serial('COM4','BaudRate',115200,'OutputBufferSize',4800,'InputBufferSize',4800);
fopen(COM1);

% Do this for 1000 frames
for j=1:1000
    counter = 0;
    image = zeros(0);
    searching = 1;
    
    % Wait until we can get a full image
    while searching
        header = fscanf(COM1,'%f ');
        if header(1) == END_CODE
            searching = 0;
        end
    end
    
    % Gather each frame of the image
    while counter ~= 60
        d=fscanf(COM1,'%f ');
        sz = size(d)
        if sz(1) == 80
            image=[image,d];
        end
        counter = counter+1;
    end

    % Display the image
    image = (image-min(min(image)))/(max(max(image))-min(min(image)));
    image = single(image');
    imagesc(image);
    pause(0.02);
end

%Close and clear the serial ports
fclose(COM1);
delete(COM1);
clear COM1;