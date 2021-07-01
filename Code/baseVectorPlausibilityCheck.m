% Check whether the input vector in the base coordinate system is
% plausible or not
% How?
% Examine whether at least one of the input vector variable inside (x,y,z) 
% base coordinate is equal to the previous input vector
% If equal, the two links can be connected to the same joint

function plausible = baseVectorPlausibilityCheck(base_vector)
    [r, c] = size(base_vector);
    if r == 1
        plausible = 1; % plausible
        return;
    end
    
    for i=1:r-1 % Loop from 1 until max number of r minus 1
        % Check if two links can be connected
        if base_vector(i,1) == base_vector((i+1),1)  || base_vector(i,2) == base_vector((i+1),2)  || base_vector(i,3) == base_vector((i+1),3) 
            plausible=1; % plausible
        else
            plausible=0; % not plausible
            return; 
        end
    end % End loop
end
