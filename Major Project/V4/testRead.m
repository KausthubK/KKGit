% % % TEST: Read
% % % MTRX5700 Major Assignment 2015
% % % Authors: Kausthub Krishnamurthy & James Ferris & Sachith
% Gunawardhana

clear
close all
clc
cards = struct('index', {},'x', {}, 'y', {}, 'pose', {}, 'shape', {}, 'colour', {}, 'filler', {}, 'count', {}, 'viewedFlag', {});

numCards = 8;
gameMode = 10;

for(i = 1:numCards)
    cards(i).index = i;
    cards(i).x = 12.93;
    cards(i).y = 12.93;
    cards(i).pose = 12.93;
    cards(i).viewedFlag = 0;
end

%get images
disp  'reading...'
I20 = imread('../test_images_gray/test_image20.png');
I21 = imread('../test_images_gray/test_image21.png');
I22 = imread('../test_images_gray/test_image22.png');
I23 = imread('../test_images_gray/test_image23.png');
I24 = imread('../test_images_gray/test_image24.png');
I25 = imread('../test_images_gray/test_image25.png');
I26 = imread('../test_images_gray/test_image26.png');
I27 = imread('../test_images_gray/test_image27.png');

disp 'viewing...'
[cards(1).viewedFlag, cards(1).shape, cards(1).colour, cards(1).filler, cards(1).count] = readCard(I20);
cards(1).viewedFlag=0;
disp 'compare 1'
[matchFlag, matchIndex] = compareCards(numCards,1 , cards, gameMode)
cards(1).viewedFlag=1;

[cards(2).viewedFlag, cards(2).shape, cards(2).colour, cards(2).filler, cards(2).count] = readCard(I21);
cards(2).viewedFlag=0;
disp 'compare 2'
[matchFlag, matchIndex] = compareCards(numCards,2 , cards, gameMode)
cards(2).viewedFlag=1;

[cards(3).viewedFlag, cards(3).shape, cards(3).colour, cards(3).filler, cards(3).count] = readCard(I22);
cards(3).viewedFlag=0;
disp 'compare 3'
[matchFlag, matchIndex] = compareCards(numCards,3 , cards, gameMode)
cards(3).viewedFlag=1;

[cards(4).viewedFlag, cards(4).shape, cards(4).colour, cards(4).filler, cards(4).count] = readCard(I23);
cards(4).viewedFlag=0;
disp 'compare 4'
[matchFlag, matchIndex] = compareCards(numCards,4 , cards, gameMode)
cards(4).viewedFlag=1;

[cards(5).viewedFlag, cards(5).shape, cards(5).colour, cards(5).filler, cards(5).count] = readCard(I24);
cards(5).viewedFlag=0;
disp 'compare 5'
[matchFlag, matchIndex] = compareCards(numCards,5 , cards, gameMode)
cards(5).viewedFlag=1;

[cards(6).viewedFlag, cards(6).shape, cards(6).colour, cards(6).filler, cards(6).count] = readCard(I25);
cards(6).viewedFlag=0;
disp 'compare 6'
[matchFlag, matchIndex] = compareCards(numCards,6 , cards, gameMode)
cards(6).viewedFlag=1;

[cards(7).viewedFlag, cards(7).shape, cards(7).colour, cards(7).filler, cards(7).count] = readCard(I26);
disp 'compare 7'
cards(7).viewedFlag=0;
[matchFlag, matchIndex] = compareCards(numCards,7 , cards, gameMode)
cards(7).viewedFlag=1;

[cards(8).viewedFlag, cards(8).shape, cards(8).colour, cards(8).filler, cards(8).count] = readCard(I27);
disp 'compare 8'
cards(8).viewedFlag=0;
[matchFlag, matchIndex] = compareCards(numCards,8 , cards, gameMode)
cards(8).viewedFlag=1;