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
%detect edges
level = graythresh(image);
image_1 = imbinarize(image,level);
[~, threshold] = edge(image_1, 'sobel');
fudgeFactor = .5;
BWs = edge(image_1,'sobel', threshold * fudgeFactor);
num_edge_pixel = 0;
horizontal = 0;
vertical = 0;
for i=1:60
    for j=1:80
        if BWs(i,j) == 1
            num_edge_pixel = num_edge_pixel + 1;
            horizontal = horizontal + i;
            vertical = vertical + j;
        end
    end
end
horizontal = round(horizontal/num_edge_pixel);
vertical = round(vertical/num_edge_pixel);
Segout = image; 
Segout(BWs) = 255;
Segout = insertShape(Segout,'Rectangle',[vertical horizontal-15 20 20],'LineWidth',2,'Color','red');
imshow(Segout), title('lock the target');
end
fclose(COM1);
delete(COM1);
clear COM1;