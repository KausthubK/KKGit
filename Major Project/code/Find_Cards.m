close all
clear
clc

I=imread('test_image11.png');%read the image
BW=double(I)/255; %convert to double
% figure,imshow(BW);

%FIND FACEDOWN CARDS
T1=BW<0.1;
T2=imclearborder(T1,4);
T3=imfill(T2,'holes');
FDWN=bwareaopen(T3,1000);
CC1=bwconncomp(FDWN);
numFDWN=CC1.NumObjects;

sFDWN=regionprops(CC1,'centroid'); %find centroids of face down cards
centroidsFDWN=cat(1,sFDWN.Centroid); %cetroids of face downs

%figure,imshow(FDWN);

%FIND FACEUP CARDS
I2=BW>0.91;  %identify faceup card
I3=imfill(I2,'holes'); %fill all holes but the shape was gone

LB=3000;
UB=4000;
I4=xor(bwareaopen(I3,LB),bwareaopen(I3,UB));%remove blobs greater than UB area and less than LB

Iout=imclearborder(I4,4); %remove blobs attached to the border
Iout=bwareaopen(Iout,1000); %remove smalle pixels
%figure,imshow(Iout);

Bwoutline=bwperim(Iout); %create a outline
border=BW;
border(Bwoutline)=0;
% figure, imshow(border);

%ISOLATE FACEUP
cards=BW;
mask=Iout<0.5; %create a mask to isolate the face up
cards(mask)=0;
CC2=bwconncomp(cards); %find the connected blobs
numFUP=CC2.NumObjects; %number of Faceup cards
numCards=numFUP+numFDWN; %number of cards
% figure, imshow(cards)
% imwrite(cards,'t3.png');



s2=regionprops(CC2,'BoundingBox'); %identify the card boundary

for i=1:numFUP
    %EXTRACT ISOLATED FACEUP
    face_up(i).image=imcrop(BW,s2(i).BoundingBox);
    
    %DETECT FEATURES
    E=edge(face_up(i).image,'canny');
    T10=imfill(E,'holes');
    T11=bwareaopen(T10,200);
%     figure,imshow(T11);

    CC3=bwconncomp(T11);
    s3=regionprops(CC3,'Perimeter');
    face_up(i).perim=s3.Perimeter;
    
    %DEFINING CARD
    if s3.Perimeter<82 && s3.Perimeter>75;
        face_up(i).flag=1; %1 rectangle in set card
    else s3.Perimeter<71 && s3.Perimeter>64;
        face_up(i).flag=2; %1 trangle in set card
    end
end


%POSITION OF FACEUPS
sFUP=regionprops(CC2,'centroid'); %find centroids of regions
centroids=cat(1,sFUP.Centroid); %make a array using centroids in the structured array
% figure, imshow(BW)
% hold on
% plot(centroids(:,1),centroids(:,2),'b*') %plot centorids with boxes
% hold off

if numFUP==2
    if face_up(1).flag==face_up(2).flag;
        disp 'A Match Found Fuckkkerrrrssssss'
    end
end


% numCards
% numFUP
% numFDWN