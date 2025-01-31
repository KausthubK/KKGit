% %  numDWN,numFUP,FACEDOWN_POSITION(Xreal,Yreal,OrAn1), FACEUP_POSITIONI(FUP_Xreal,FUP_Yreal,FUP_OrAn1)

close all
clear
clc

I=imread('test_image35.png'); % read image

%FIND FACE DOWNS
I2=imcrop(I,[68.5 4.5 491 472]); %isolate the workingspace
I3=double(I2)/255;  %convert to double
I4=adapthisteq(I3); %enhance contrast using adaptive histogram equalization
I5=I4<0.10;%0.1 %0.11 % find boxes using a threshold

C1=bwareaopen(I5,1000); %remove objects less than 1000 pixels/ Remove unnessosary regions
se=strel('square',8);  %create a structuring element of size 15 square
C2=imclose(C1,se); %morphologicaly close image
FDWN=imfill(C2,'holes'); %fill holes


s=regionprops(FDWN,'centroid'); %find centroids of regions
centroids=cat(1,s.Centroid); %make a array using centroids in the structured array

x1=centroids(:,1);
y1=centroids(:,2);

%ORIENTATION Face Downs
TR=2;
LT=8;

p=regionprops(FDWN,'Extrema')

for i=1:length(p)
    
    sides1=p(i).Extrema(TR,:)-p(i).Extrema(LT,:); %sides of the square
    OrAn1(i)=rad2deg(atan(-sides1(2)/sides1(1))); %note the 'minus' sign compensates for the y-values in image cordinates
    
end


%find fiducial box_1 (-270,220)

for i=1:length(x1)
    if ((x1(i)< 60 && x1(i)>50)&& (y1(i)<442 && y1(i)>432 ))
        B1=[x1(i),y1(i)];
    end
end
OrAn1(B1(1,1)==x1)=[];
x1(B1(1,1)==x1)=[]; %remove cordinates of fiducial boxes
y1(B1(1,2)==y1)=[];


%find fiducial box_2 (270,220)
for i=1:length(x1)
    if ((x1(i)< 459 && x1(i)>249)&& (y1(i)<431 && y1(i)>421 ))
        B2=[x1(i),y1(i)];
    end
end
OrAn1(B2(1,1)==x1)=[];
x1(B2(1,1)==x1)=[];
y1(B2(1,2)==y1)=[];


%find fiducial box_3 (-270,523)
for i=1:length(x1)
    if ((x1(i)< 53 && x1(i)>43)&& (y1(i)<223 && y1(i)>213 ))
        B3=[x1(i),y1(i)];
    end
end

OrAn1(B3(1,1)==x1)=[];
x1(B3(1,1)==x1)=[];
y1(B3(1,2)==y1)=[];

% coordsFDWN(:,3)=OrAn1;

%When only fiducial boxes present
TF=isempty(x1);
if TF==1
    warning('No objects detected other than fiducial boxes')
end

Yr=abs(p_dist(B1,B2,x1,y1)); %distance from line going along centroids of box1 & box 2 (reference)
Xr=p_dist(B1,B3,x1,y1);  %distance from line going along centroids of box1 & box 3 (reference)

%Matching with world cordinates
    %X 792.8691 = 540 real , %Y 433.3300 = 303 real                                    
Yreal=((Yr*303)/219.3306)+220;    %REAL Y CORDINATE of Face DOWNs 
Xreal=((Xr*540)/399.4796)-270;    %REAL x CORDINATE of Face DOWNs

coordsFDWN(:,1)=Xreal; %adding to variable coordsFDWN 
coordsFDWN(:,2)=Yreal;

numFDWN=length(Xreal);  %no of face down cards

if numFDWN~=0    
coordsFDWN(:,3)=OrAn1;
end

%FIND FACE UPS
FUP1=I3>0.91;  %identify faceup card
FUP3=imfill(FUP1,'holes'); %fill all holes but the shape was gone

LB=3000;
UB=4000;
FUP4=xor(bwareaopen(FUP3,LB),bwareaopen(FUP3,UB));%remove blobs greater than UB area and less than LB

Iout=imclearborder(FUP4,4); %remove blobs attached to the border
Iout=bwareaopen(Iout,1000); %remove smalle pixels


%ISOLATE FACEUP
cards=I3;
mask=Iout<0.5; %create a mask to isolate the face up
cards(mask)=0;
CC2=bwconncomp(cards); %find the connected blobs
numFUP=CC2.NumObjects; %number of Faceup cards
numCards=numFUP+numFDWN; %number of cards

%POSITION OF FACEUPS
s2=regionprops(Iout,'centroid'); %find centroids of regions
FUPcentroids=cat(1,s2.Centroid);

FUP_x1=FUPcentroids(:,1);
FUP_y1=FUPcentroids(:,2);

FUP_Yr=abs(p_dist(B1,B2,FUP_x1,FUP_y1)); %distance from line going along centroids of box1 & box 2 (reference)
FUP_Xr=p_dist(B1,B3,FUP_x1,FUP_y1);  %distance from line going along centroids of box1 & box 3 (reference)

FUP_Yreal=((FUP_Yr*303)/219.3306)+220;    %REAL Y CORDINATE of Face UPs 
FUP_Xreal=((FUP_Xr*540)/399.4796)-270;    %REAL X CORDINATE of Face UPs

coordsFUP(:,1)=FUP_Xreal;
coordsFUP(:,2)=FUP_Yreal;

%ORIENTATION Face Ups
p2=regionprops(Iout,'Extrema');

for i=1:length(p2)
    
    sides2=p2(i).Extrema(TR,:)-p2(i).Extrema(LT,:); %sides of the square
    FUP_OrAn1(i)=rad2deg(atan(-sides2(2)/sides2(1))); %note the 'minus' sign compensates for the y-values in image cordinates
    coordsFUP(:,3)=FUP_OrAn1(i);
end



numFDWN
numFUP

