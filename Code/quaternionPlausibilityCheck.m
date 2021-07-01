% Check the input quaternion orientation relative to the base coordinate
% coordinate system whether it is plausible or not
% How?
% 1) q0^2+q1^2+q2^2+q3^2 == 1
% 2) |q0|<= 1 && |q1|<=1 && |q2|<=1 && |q3|<=1 

function [plausible, msg] = quaternionPlausibilityCheck(quaternion_0,quaternion_vector)
    % 1) Check whether q0^2+q1^2+q2^2+q3^2 == 1
    for i=1: length(quaternion_0) % Start loop from 1st link until max link number
       criticalPoint = (quaternion_0(i)^2) + (quaternion_vector(i,1)^2) + (quaternion_vector(i,2)^2) + (quaternion_vector(i,3)^2);
       if criticalPoint <= 1.02 && criticalPoint >= 0.98 % Check whether the critical point is in between +- 0.2 tolerance
           plausible = 1; % plausible
       else
            msg = "Please check the input quaternion again! \nError: q0^2+q1^2+q2^2+q3^2 ~= 1  ";
            plausible=0;  % not plausible
            return;
       end
    end   % End loop

    % 2) Check whether |q0|<= 1 && |q1|<=1 && |q2|<=1 && |q3|<=1 
    for i=1: length(quaternion_0) % Start loop from 1st link until max link number
        if quaternion_0(i) <= 1 && abs(quaternion_vector(i,1)) <= 1  && abs(quaternion_vector(i,2)) <= 1   && abs(quaternion_vector(i,3)) <= 1
            plausible = 1;  % plausible
        else
            msg = "Please check the input quaternion again! \nError: |q0|~<= 1 | |q1|<=1 | |q2|<=1 | |q3|<=1";
            plausible=0;    % not plausible
            return;
        end
    end % End loop
    
    % Send "OK" message when input quaternion orientation is plausible
    msg = "OK";
    
end

