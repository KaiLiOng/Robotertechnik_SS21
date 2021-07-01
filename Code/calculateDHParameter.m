% Calculate Denavit Hartenberg parameter by using vector and 
% quartenion orientation in  and relative to base coordinate system
% How?
% Change the input quaternion into rotation matrix
% From the rotation matrix grab a, alpha, d and theta
% Use a, alpha, d and theta to calculate the Denavit Hartenberg parameter

function [a, alpha, d, tetha] = calculateDHParameter(base_vector,quaternion_0, quaternion_vector)

    previous_d=0;
    previous_a=0;
    previous_alpha=0;
    previous_theta = 0;
    
    for i=1:length(quaternion_0) % Start loop from 1st link until max link number
        
        q0 = quaternion_0(i); % Define quaternion orientation scalar part
        q  = quaternion_vector(i,:); % Define quaternion orientation q vector part
        r  = base_vector(i,:); % Define r vector
        Q =  UnitQuaternion(Quaternion([q0,q]));
        
        %Calculate rotation matrix from quaternion (Q)
        RotMat = Q.R;
                
        % Calculate DH a:
        % DH a is the distance between the zi-1 and zi axis along the xi axis
        a_i = r(1); % Define a_i value from vector r
        if a_i == previous_a % If a_i == previous_a , there is no distance
            a_i = 0; 
        else
            a_i = abs(previous_a - r(1)); % if a_i ~= a_i-1, then r(1) value is subtracted from the previous_a
            if previous_a == 0 % if previous_a == 0, then a_i = r(1) 
                a_i = r(1);
            end
            previous_a = r(1); % Redefine previous_a value equal to r(1) 
        end
        
        % Calculate DH alpha:  
        % DH alpha is the angle between the zi and zi-i axis along xi axis
        acos(RotMat(3,3)); 
        if acos(RotMat(3,3)) == previous_alpha % RotMat(3,3) contains cos(alpha)
            alpha_i = 0;
        else
            alpha_i = abs(acos(RotMat(3,3)) - previous_alpha);
            previous_alpha = acos(RotMat(3,3));
        end
        
        % Calculate DH d:
        % DH d is the distance between the xi-1 and xi axis along the Zi-1 axis
        d_i = r(3);
        if d_i == previous_d
            d_i = 0;
        else
            d_i = abs(previous_d - r(3));
            previous_d = r(3);
        end
        
        % Calculate DH tetha:
        acos(RotMat(1,1)); % RotMat(1,1) contains cos(tetha)
        if acos(RotMat(1,1)) == previous_theta 
            tetha_i = 0;
        else
            tetha_i = abs(acos(RotMat(1,1)) - previous_theta);
            previous_theta = acos(RotMat(1,1));
        end
        
        % return value to the function
        a(i,1) = a_i;
        alpha(i,1) = alpha_i;
        d(i,1) = d_i;
        tetha(i,1) = tetha_i;
        
    end % End loop
end

