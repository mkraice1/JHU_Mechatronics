for j=1:100
COM1=serial('/dev/cu.usbmodem3129931','BaudRate',115200,'OutputBufferSize',4800,'InputBufferSize',4800);
fopen(COM1);
counter = 0;
image = zeros(0);
i=1;
while i==1
    header = fscanf(COM1,'%f ');
    if header(1) == 1234567
    i=0;
    end
end
while counter ~= 60
    d=fscanf(COM1,'%f ');
    image=[image,d];
    counter = counter+1;
end
image=image';
image=(image-min(min(image)))/(max(max(image))-min(min(image)));
imshow(image);
fclose(COM1);
delete(COM1);
clear COM1;
pause(0.5);
end