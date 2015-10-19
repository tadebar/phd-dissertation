function z = g(x)
% f measurement equations for duty-cycled needle steering
%    z = g(x,v) returns measurement vector given the current state and. 
%    The measurement consists of the needle tip position
%    in R^3, and the needle tangent vector in R^3 (i.e., the z-axis of the
%    needle's tip frame.
% Inputs:   x: 6x1 state vector: [p (3x1 pos), r (3x1 rot)]' 
%           v: 6x1 measurement noise
% Output:   z: 6x1 measurement vector: [z_pos z_tang]'

%% Initialize variables
% Isolate state position vector and orientation quaternion 
% p = x(1:3);
% r = x(4:6);
% q = rot2quat(r);
% qv = rot2quat(v(4:6));
% 
% %% Return position output
% % Calculate tip position output as actual state plus gaussian noise
% z = zeros(6,1);
% z(1:3) = p + v(1:3);
% 
% %% Return tangent vector output
% % Rotate the z-axis based on state quaternion
% q = quatmultiply(q,qv);
% z(4:6) = quat2rot(q);

z = x;

%% eof