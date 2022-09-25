 clear all
 close all
A = imread('lena.bmp');
 %B= A(:,:,1);
%fprintf(fileID,'uint8_t lena[240*240]=\n');
%fprintf(fileID,'{\n');

% fileID = fopen('lena.txt','r');
%  k2=zeros(240,240);
% for   y = 1:240
%     for x = 1:240
%     
% k2(y,x)=str2double(fgetl(fileID));
% 
%     end
% end 

% imshow(mat2gray(k2,[0 256]))
% fprintf(fileID,'\n};')
% fileID = fopen('lena.txt','w');
%fprintf(fileID,'uint8_t lena[240*240]=\n');
%fprintf(fileID,'{\n');
% for y = 1:240;
%    for x = 1:240;
% fprintf(fileID,'%d\n',A(y,x));
%    end
% end
% fprintf(fileID,'\n};');
% 
%fclose(fileID);
% 
% 
clear all;
close all;

s = serialport('COM7',115200);
s.Timeout = 240;
while(str2double(readline(s))~=221)
end
    

k2=zeros(240,240);
for   y = 1:240
    for x = 1:240
    
k2(y,x)=str2double(readline(s));

    end
end 
I2 = mat2gray(k2,[0 256]);
imshow(I2)

figure(3)



title(caption, 'FontSize', 14);
drawnow; 
while(1)
    str2double(readline(s))
end