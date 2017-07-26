COM1=serial('/dev/cu.usbmodem3129931','BaudRate',115200,'OutputBufferSize',4800,'InputBufferSize',4800);
fopen(COM1);
for j=1:1000
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
image = (image-min(min(image)))/(max(max(image))-min(min(image)));
image = single(image');
imagesc(image);
pause(0.1);
end
fclose(COM1);
delete(COM1);
clear COM1;