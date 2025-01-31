%V2.1
% % % FUNCTION:	readCard
% % % MTRX5700 Major Assignment 2015
% % % Authors: Sachith Gunawardhana & Kausthub Krishnamurthy & James Ferris

% % % REVISION HISTORY
% % % v0 function stub
% % % v1.1 imported into function format
% % % v1.2 filler done (block needs testing)
% % % v2.1 count
%TODO
% - block
% - count
% - colour

% % % SUBFUNCTIONS LISTING
% % %

function [viewed, shape, colour, filler, count] = readCard(I)
% returns a set of feature values for the card on the image

% OUTPUTS
% % viewed    - flag returns 1 if a card is viewed
% % shape	  - 1 (rectangle), 2 (triangle), 3 (elipse), 0 (default unknown)
% % colour	  - 1 (red), 2 (green), 3 (blue), 0 (default unknown)
% % filler	  - 1 (empty), 2 (shaded), 3 (filled), 0 (default unknown)
% % count	  - number of shapes (1 for now)


% INPUTS
% % I 		  - Image captured from vid

% defaults set
viewed = 0;
face_up(1).shape = 0;
face_up(1).colour = 0;
face_up(1).filler = 0;
face_up(1).count = 1;
face_up(1).perim=0;
face_up(1).MeanPerim=0;
face_up(1).MeanIntensity=0;
face_up(1).Intensity=0;


% I=rgb2gray(I); %for testing only
BW=double(I)/255; %convert to double
% figure,imshow(BW);

%FIND FACEUP CARD
Icheck=imcrop(BW,[183.5 2.5 254 221]); 
% Icheck=imcrop(BW,[401.5 569.5 152 182]); %for testing only
I2=Icheck>0.72;  %identify faceup card
I3=imfill(I2,'holes'); %fill all holes but the shape was gone
se=strel('square',9);
IE=imerode(I3,se);
I4=imclearborder(IE,4);
Iout=bwareaopen(I4,1000);
U=bwconncomp(Iout);
N=U.NumObjects;

if N>0;
    Bwoutline=bwperim(Iout); %create a outline
    border=Icheck;
    border(Bwoutline)=0;
    % figure, imshow(border);

    %ISOLATE FACEUP
    cards=Icheck;
    mask=Iout<0.5; %create a mask to isolate the face up
    cards(mask)=0;
    CC2=bwconncomp(cards); %find the connected blobs

    s2=regionprops(CC2,'BoundingBox'); %identify the card boundary


    %EXTRACT ISOLATED FACEUP
    face_up(1).image=imcrop(Icheck,s2(1).BoundingBox);

    %DETECT FEATURES
    E=edge(face_up(1).image,'canny');
    T10=imfill(E,'holes');
    T11=bwareaopen(T10,200);

    CC3=bwconncomp(T11);
    s3=regionprops(CC3,'Perimeter');

    for i=1:length(s3)
        face_up(1).perim(i)=s3(i).Perimeter;
    end

    face_up(1).MeanPerim=mean(face_up(1).perim);

    %DEFINING CARD
    %SHAPE
    face_up(1).shape = 0;
    if face_up(1).MeanPerim<165 && face_up(1).MeanPerim>145;
        face_up(1).shape=1; %1 rectangle in set card
    elseif (face_up(1).MeanPerim<124 && face_up(1).MeanPerim>116)||(face_up(1).MeanPerim<87 && face_up(1).MeanPerim>81);
        face_up(1).shape=2; %1 trangle in set card
    elseif face_up(1).MeanPerim<137 && face_up(1).MeanPerim>125;
        face_up(1).shape=3; %1 elipse in set card
    end

    %SHAPE COUNT
    face_up(1).count=CC3.NumObjects;

    %FILLER
    TT=face_up(1).image;
    st2=regionprops(T11,TT,'MeanIntensity');

    for i=1:length(st2)
        face_up(1).Intensity(i)=st2(i).MeanIntensity;
    end

    face_up(1).MeanIntensity=mean(face_up(1).Intensity);

    if face_up(1).MeanIntensity>0.7
        face_up(1).filler=1; %not shaded
    elseif face_up(1).MeanIntensity<0.7 && face_up(1).MeanIntensity>0.5
        face_up(1).filler=2; %shaded
    elseif face_up(1).MeanIntensity<0.5
        face_up(1).filler=3; %block
    end

    %OUTPUT VALUES
    shape = face_up(1).shape;
    filler = face_up(1).filler;
    colour = face_up(1).colour;
    count = face_up(1).count;

    %DISPLAY
    if face_up(1).shape==1
        disp 'RECTANGLE'
        viewed = 1;
    elseif face_up(1).shape==2
        disp 'TRANGLE'
        viewed = 1;
    elseif face_up(1).shape==3
        disp 'ELIPSE'
        viewed = 1;
    elseif face_up(1).shape==0
        disp 'UNABLE TO DETERMINE SHAPE'
        viewed = 0;
    end

    if face_up(1).filler == 3
        disp 'BLOCK'
    elseif face_up(1).filler==2
        disp 'SHADED'
    elseif face_up(1).filler==1
        disp 'NOT SHADED'
    else
        disp 'UNABLE TO DETERMINE FILLER'
    end

    fprintf('Shape count = %d\n\n',count);

    % imshow(cards);
else
    viewed=-1;
end    
    
end


    