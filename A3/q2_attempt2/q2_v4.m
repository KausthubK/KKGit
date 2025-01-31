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

diary './q2Output4'

%Get laser data
time2 = laserObs(:,1) + (laserObs(:,2)*10^-6) - 1115116000;%get in microseconds


%Extracting range & intensity data from LaserObs

f1=1;
range = zeros(length(laserObs), (size(laserObs,2)-2)/2);
% intensity = zeros(length(laserObs), (size(laserObs,2)-2)/2);

%Extracting range & intensity data from LaserObs
for i=1:length(laserObs)  
   for f2=3:2:size(laserObs,2)
%        if(laserObs(i,f2) < 8)
            range(i,f1)=laserObs(i,f2);
        %     intensity(i,f1)=laserObs(i,f2+1);
            f1=f1+1;
%        end
   end
   f1=1;
end

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

interval = 20;

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
        if iters(1) >= length(time1)-interval
            time1(iters(1)) = 1.496*10^8;
        else
            iters(1) = iters(1) + interval;
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
        
             
        % Get X,Y coordinates for laser ob data
        
        for i = 1:size(range,2)
            if (range(iters(2),i) < 8.0 && range(iters(2),i) > 0.0001)
                lasersX = ourX + range(iters(2),i)*cos(((i-1)*0.5)*RADIANS+ourHeading);
                lasersY = ourY + range(iters(2),i)*sin(((i-1)*0.5)*RADIANS+ourHeading);
                diary ON
                fprintf('%d\t%d\n', lasersX, lasersY);
                diary OFF
            end
        end
        
        %increment
        if iters(2) >= length(time2)-interval
            time2(iters(2)) = 1.496*10^8;
        else
            iters(2) = iters(2) + interval;
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






















