% Jocabian of the residual

% J: the Jocabian of the residual with dimension equal to 
% (3*sensorNum X stateNum)

function J = jacob(r, x_est, fingerOrient_est, IMUOrient_est, measurement)

n = length(r);                                  % n = 3*frameNum
frameNum = length(IMUOrient_est);
stateNum = length(x_est);

% J(i,j) = dri_duj * duj_dxj   for i >= j
J = zeros(n, stateNum);
dri_duj = zeros(3,4);           % The last 3 columns of the matrix of computed quaternions
q_diag = [Quaternion(), Quaternion([0 -1 0 0]), Quaternion([0 0 -1 0]), Quaternion([0 0 0-1])];

for i = 1:frameNum                  % 3 joint residuals
    for j = 1:stateNum
        switch (j)
            case {1,4,7}                % For constant states
                index = ceil(j/3);
                if i < index            % Then ri doesn't depend on xj and we have J(i,j) = 0
                    continue;
                end
                
                parentOrient = fingerOrient_est(index);
                for k = 1:4
                    temp = IMUOrient_est(i).inv * IMUOrient_est(index) * q_diag(k) / parentOrient * measurement(i);
                    dri_duj(:,k) = 2 * temp.v';
                end
                
                alpha = acos(IMUOrient_est(index).s)*2;         % Rotation angle of the IMU orientation
                tolerance = 1e-3;
                
                if abs(alpha) < tolerance
                    S = 1/2 - alpha^2/48;
                    C = -1/24 + alpha/960;
                else
                    S = sin(alpha/2)/alpha;
                    C = (cos(alpha/2)/2 - S)/alpha^2;
                end
                
                x = (IMUOrient_est(index).v/S)';               % The angle-axis  representation
                duj_dxj = [-S/2*x' ; C*(x*x') + S*eye(length(x))];
                
                J(3*i-2:3*i, 3*index-2:3*index) = dri_duj * duj_dxj;
                
            case {10,13,16}             % For time-varying states
                index = ceil((j-9)/3);
                
                if i < index            % Then ri doesn't depend on xj and we have J(i,j) = 0
                    continue;
                end
                
                if index == 1
                    parentOrient = Quaternion();
                else
                    parentOrient = fingerOrient_est(index-1);
                end
                
                for k = 1:4
                    temp = IMUOrient_est(i).inv * fingerOrient_est(index) * q_diag(k) / parentOrient * measurement(i);
                    dri_duj(:,k) = 2 * temp.v';
                end
                
                alpha = acos(fingerOrient_est(index).s)*2;         % Rotation angle of the IMU orientation
                tolerance = 1e-3;
                
                if abs(alpha) < tolerance
                    S = 1/2 - alpha^2/48;
                    C = -1/24 + alpha/960;
                else
                    S = sin(alpha/2)/alpha;
                    C = (cos(alpha/2)/2 - S)/alpha^2;
                end
                
                x = (fingerOrient_est(index).v/S)';               % The angle-axis  representation
                duj_dxj = [-S/2*x' ; C*(x*x') + S*eye(length(x))];
                
                J(3*i-2:3*i, 3*(index+frameNum)-2:3*(index+frameNum)) = dri_duj * duj_dxj;
                
        end
        
%         if j > 9                    % Time-varying states
%             if j == 10           % for MCP(abduction/adduction)
%                 rotAxis = fingerOrient_est(1)*[0 1 0]';
%             else
%                 rotAxis = fingerOrient_est(1)*[0 0 1]';
%             end
%             duj_dxj = [-sin(x_est(j) / 2); rotAxis * cos(x_est(j) / 2)] / 2;    % Dimension: 4x1
%             J(3*i-2:3*i, j) = dri_duj * duj_dxj;
%         end

    end
end

