clear
clc
close all

DEGREES = 180/pi;
RADIANS = pi/180;


positionData = load('q1output1.txt');

laserObs = load('laserObs.txt');

%Get output data
time1 = positionData(:,1);
Xpos = positionData(:,2);
Ypos = positionData(:,3);
heading = positionData(:,4);
velocity = positionData(:,5);
turnRate = positionData(:,6);

diary './q2Output1'

%Get laser data
time2 = laserObs(:,1) + (laserObs(:,2)*10^-6) - 1115116000;%get in microseconds
f1=1;
f2=3;


%Extracting range & intensity data from LaserObs

iMax = size(laserObs,1);    %rows
jMax = size(laserObs,2);    %columns

range = zeros(1,(jMax - 2)/2);
intensity = zeros(1,(jMax - 2)/2);

% i = 1;

% j = 4;
% n = 1;
% while(j <= jMax)
%         if ((laserObs(i, j - 1) < 8.0) && (laserObs(i, j - 1) > 0.0))
%             range(n) = laserObs(i, j - 1);
%             intensity(n) = laserObs(i, j);
%             n = n + 1;
%         end
%         j = j + 2;
% end
% if (i <= iMax)
%     i = i + 1;
% end

lasersX = 0;
lasersY = 0;

% alphaP = 0.5;
% alphaTH = 0.5;

lastTime = 0;
deltaT = 0;

latestVel = 0;
latestTurnRate = 0;

ourX = 0;
ourY = 0;
ourHeading = 0;

indLengths = [length(time1), length(time2)];
maxIters = max(indLengths);

%iters [velInd, posInd, compInd, lasInd];
iters = [2, 2];
runFlags = [0, 0];
loopFlag = 1;
loopCount = 2;
%%loop starts



while(loopFlag == 1)
    loopCount = loopCount + 1;
    time = [time1(iters(1)), time2(iters(2))];
    nextT = min(time);
    
    
    for i = 1:2
        if time(i) == nextT
            runFlags(i) = 1;
        else
            runFlags(i) = 0;
        end
    end
    
    %if Positiondata
    if(runFlags(1) == 1)
        deltaT = time1(iters(1)) - lastTime;              
        latestVel = velocity(iters(1));
        latestTurnRate = turnRate(iters(1));
        ourX = Xpos(iters(1));
        ourY = Ypos(iters(1));
        ourHeading = heading(iters(1));
        
        lastTime = time1(iters(1));%
        runFlags(1) = 0;
        if iters(1) == length(time1)
            time1(iters(1)) = 1.496*10^8;
        else
            iters(1) = iters(1) + 1;
        end
    end
    
% % if laser
     if(runFlags(2) == 1)
        deltaT = time2(iters(2)) - lastTime;
        pr = predictionStage(ourX, ourY, ourHeading, deltaT, latestTurnRate, latestVel);
        ourX = pr(1);
        ourY = pr(2);
        ourHeading = pr(3);
        lastTime = time2(iters(2));%
        runFlags(2) = 0;
        
        %Get laser data
        j = 4;
        n = 1;
        while(j <= jMax)
%                 if ((laserObs(iters(2), j - 1) < 8.0) && (laserObs(iters(2), j - 1) > 0.0001))
                    range(n) = laserObs(iters(2), j - 1);
                    intensity(n) = laserObs(iters(2), j);
                    n = n + 1;
%                 end
                j = j + 2;
        end
        
        % Get X,Y coordinates for laser ob data
        
        for i = 1:length(range)
            if (range(i) < 8.0 && range(i) > 0.0001)
                lasersX = ourX + range(i)*cos(((i-1)*0.5)-ourHeading);
                lasersY = ourY + range(i)*sin(((i-1)*0.5)-ourHeading);
                diary ON
                fprintf('%d\t%d\n', lasersX, lasersY);
                diary OFF
            end
        end
        
        %increment
        if iters(2) == length(time2)
            time2(iters(2)) = 1.496*10^8;
        else
            iters(2) = iters(2) + 1;
        end
        
        
     end

%check loop
    if(time1(iters(1)) == 1.496*10^8)
        if(time2(iters(2)) == 1.496*10^8)
                     loopFlag = 0;
        end
    end
    
%plot stuff
% hold on
% title('Obstacles');
% xlabel('x-axis');
% ylabel('y-axis');
% legend('')
% drawnow
end






















