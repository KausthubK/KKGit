clear
close all
clc

% % Prediction Stage

velocityObs = load('velocityObs.txt');

time = (velocityObs(:,1)*10^6) + velocityObs(:,2); %get in microseconds
velocity = velocityObs(:,3);
turnRate = velocityObs(:,4);
deltaT = zeros(length(time),1);

for i = 2:length(time)
    deltaT(i) = time(i) - time(i-1);           
end

predictions = zeros(length(velocity),3);

%check this
for i = 2:length(velocity)
    
    [ XvPred, YvPred, THvPred ] = predictionStage(predictions(i-1,1), predictions(i-1,2), predictions(i-1,3), deltaT(i), turnRate(i), velocity(i));
    predictions(i,1) = XvPred;
    predictions(i,2) = YvPred;
    predictions(i,3) = THvPred;
    
end

% % Observation Stage
% 
% beaconPosition = load('');
% radii = load('');
% angle = load('');
% observations = zeros(length(predictions), 3);
% 
% for i = 1:length(radii)
%     
%     [XvObs, YvObs, THvObs] = observationStage(beaconPosition(1,1), beaconPosition(2,1), beaconPosition(1,2), beaconPosition(2,2), radii(i,1), radii(i,2), angles(i,1), angles(i,2));
%     observations(i,1) = XvObs;
%     observations(i,2) = YvObs;
%     observations(i,3) = THvObs;
%     
% end
% 


% % Update Stage
% 
% 
% updated = zeros(length(predictions),3);
% 
% alphaP = 0.1;
% alphaTH = alphaP;
% 
% for i = 1:length(updated)
%     
%     [XvUpd, YvUpd, THvUpd] = updateStage(predictions(i,1), predictions(i,2), predictions(i,3), observations(i,1), observations(i,2), observations(i,3), alphaP, alphaTH);
%     updated(i,1) = XvUpd;
%     updated(i,2) = YvUpd;
%     updated(i,3) = THvUpd;
%     
% end
% 
