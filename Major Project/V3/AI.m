% V1.2

% % % MAIN: GamePlay AI for Concentration
% % % MTRX5700 Major Assignment 2015
% % % Authors: Kausthub Krishnamurthy & James Ferris & Sachith
% Gunawardhana

% % % REVISION HISTORY
% % % v0 old working method
% % % v1.1 new method setup done
% % % v1.2 control flow done

% % % SUBFUNCTIONS LISTING
% % % [numCards, numFUP, numFDWN, coordsFUP, coordsFDWN] = surveyField(I);
% % % 
% % % [viewed, shape, colour, filler, count] = readCard(I);
% % % 
% % % [matchFlag, matchIndex] = compareCards(numCards, index, cards, gameMode);
% % % 
% % % removePair(cards, matchIndex, nextUnknown);
% % % 
% % % peekFlag = unpeekCard(x, y, pose);
% % % 
% % % peekFlag = peekAt(x, y, pose);


clear all
close all
clc

% Game Setup

% Open Network Connection
global t;
t = tcpip('192.168.0.1', 2020, 'NetworkRole', 'client');
fopen(t);

% Camera Setup
vid = videoinput('pointgrey',1, 'Mono8_640x480');
pause(1);

% card struct: implementation
% cards = struct('index', {},'x', {}, 'y', {}, 'pose', {}, 'histVec', {}, 'viewedFlag', {});
cards = struct('index', {},'x', {}, 'y', {}, 'pose', {}, 'shape', {}, 'colour', {}, 'filler', {}, 'count', {}, 'viewedFlag', {});

% TODO Hide the arm
% Image Capture
I = getsnapshot(vid);
[numCards, numFUP, numFDWN, coordsFUP, coordsFDWN] = surveyField(I);
% TODO Unhide the arm


% Gameplay Flags & Variables
gameOver = 0;
numRemaining = numCards;
nextUnknown = 1;
peekingFlag = 0;


% Pre-Game Error Checking
if(numFUP ~= 0)
    disp 'ERROR: Incorrect Setup. All cards must begin Face Down'
    disp ':: ABORTING GAME ::'
    % Close Network Port and Camera
    delete(vid)
    fclose(t);
    quit;
end
if(~(numFDWN > 0))
    disp 'ERROR: Incorrect Setup :: Not enough cards for a playable instance of the game'
    disp ':: ABORTING GAME ::'
    % Close Network Port and Camera
    delete(vid)
    fclose(t);
    quit
end

%populate cards struct
for i = 1:numCards
    cards(i).index = i;
    cards(i).x = coordsFDWN(i,1);
    cards(i).y = coordsFDWN(i,2);
    cards(i).pose = coordsFDWN(i,3);
    cards(i).viewedFlag = 0;
end




% start game
while(gameOver == 0)
    % update field state
    I = getsnapshot(vid);
    [numCards, numFUP, numFDWN, coordsFUP, coordsFDWN] = surveyField(I);

    if(numFUP ~= 0)
        disp 'ERROR: Incorrect Setup. All cards must begin Face Down'
        disp ':: ABORTING GAME ::'
        % Close Network Port and Camera
        delete(vid)
        fclose(t);
        quit;
    end
    if(~(numFDWN > 0))
        disp 'ERROR: Incorrect Setup :: Not enough cards for a playable instance of the game'
        disp ':: ABORTING GAME ::'
        % Close Network Port and Camera
        delete(vid)
        fclose(t);
        quit
    end



    if(numFDWN >= 2)
    %play the game
        if(peekingFlag == 0)
%           peek at the next unkown card
            peekingFlag = peekAt(cards(nextUnknown).x, cards(nextUnknown).y, cards(nextUnknown).pose);
        else
            % Image Capture
            I = getsnapshot(vid);

            % Read the card
            [viewed, cards(nextUnknown).shape, cards(nextUnknown).colour, cards(nextUnknown).filler, cards(nextUnknown).count] = readCard(I);
            if(viewed ~= 1)
                disp 'ERROR: Card Reading Error'
                disp ':: ABORTING GAME ::'
                % Close Network Port and Camera
                delete(vid)
                fclose(t);
                quit
            end
            
            matchFlag = 0;
            [matchFlag, matchIndex] = compareCards(numCards, nextUnknown, cards, 15);%numCards, index, cards, gameMode
            if(matchFlag == 1)
                disp 'Hey I have seen this before'
                removePair(cards, matchIndex);
                cards(nextUnkown).viewedFlag = viewed;
                nextUnknown = nextUnknown + 1;
                matchFlag = 0;
                peekingFlag = 0;
            else
                disp 'YAY! A NEW CARD!'
                peekingFlag = unpeekCard(cards(nextUnknown).x, cards(nextUnknown).y, cards(nextUnknown).pose);
                cards(nextUnkown).viewedFlag = viewed;
                nextUnknown = nextUnknown + 1;
            end            
        end
    elseif(numFDWN == 1)
        % TODO remove last card
        disp 'GAME OVER'
        % Close Network Port and Camera
        delete(vid)
        fclose(t);
        gameOver = 1;
    else
        % end the game
        disp 'GAME OVER'
        % Close Network Port and Camera
        delete(vid)
        fclose(t);
        gameOver = 1;
    end
end