%V1

function peekFlag = peekAt(x, y, pose)

% given an x & y position will pick up the block at that point will move the arm to the peek coordinates

% move to x, y & pickUpHeight (30)
% close gripper
% move tool up (Z) 25
% move J5 to +90 degrees
% move J3 to +90 degrees
% move J2 to -90 degrees
% move J1 to 0 degrees
% move J4 to 0 degrees
% move J6 to 0 degrees
peekFlag = 1;
end

