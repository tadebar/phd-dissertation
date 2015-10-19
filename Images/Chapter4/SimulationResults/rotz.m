function [ T ] = rotz( gamma )
%ROTZ Creates a homogeneous transformation matrix for a rotation around z.
%   [ T ] = rotz( gamma )
% Inputs:   gamma: rotation around z-axis (radians)
% Outputs:  T: 4x4 column-major transformation matrix
%
% author:   Troy Adebar
% date:     11/21/2013

T = [ cos(gamma) -sin(gamma) 0 0;
      sin(gamma)  cos(gamma) 0 0;
      0           0          1 0;
      0           0          0 1; ];

end

