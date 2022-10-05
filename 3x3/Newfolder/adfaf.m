
A = imread('lena.bmp');
B = imread('lena.bmp');

A=A(:,:,1);
B=A(:,:,1);


for N=1:240
    for V=1:240
     B(V,N)=A(N,V);
    end 
end 

I2 = mat2gray(B,[0 256]);
figure(3)
imshow(I2)
drawnow; 