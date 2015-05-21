close all
clear
clc

%read the image
I=imread('test_image11.png');
BW=double(I)/255; %convert to double

I2=BW>0.91;  %identify faceup card
I3=imfill(I2,'holes'); %fill all holes but the shape was gone

%remove blobs greater than some area and less than some area
LB=3000;
UB=4000;
I4=xor(bwareaopen(I3,LB),bwareaopen(I3,UB));

Iout=imclearborder(I4,4); %remove blobs attached to the border
Iout=bwareaopen(Iout,1000); %remove smalle pixels
imshow(Iout);

%create a outline
Bwoutline=bwperim(Iout);
border=BW;
border(Bwoutline)=0;
imshow(border)

%isolate face upp
cards=BW;
mask=Iout<0.5; %create a mask to isolate the face up
cards(mask)=0;
figure, imshow(cards)
% imwrite(cards,'t3.png');

CC=bwconncomp(cards); %find the connected blobs
s2=regionprops(CC,'BoundingBox'); %identify the card boundary
face_up=imcrop(BW,s2.BoundingBox);
figure,imshow(face_up);

%find Features
corners = detectFASTFeatures(cards);
figure, imshow(BW); hold on
plot(corners)
