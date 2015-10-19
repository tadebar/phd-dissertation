function X=sigmas(x,P,Q)
%Sigma points around reference point
%Inputs:
%       x: reference point
%       P: covariance
%       Q: process noise covariance 
%Output:
%       X: Sigma points


% Get size of state of vector
n = size(P,1);
% Get matrix square root
S = chol(P+Q)';
% Find equally spaced vectors
W = [S -S].*sqrt(n);
% display(W*W'./(2*n));
% Add the first 3 elements of W (position) vectors to mean directly 
YY = x(:,ones(1,2*n));
X(1:3,:) = YY(1:3,:) + W(1:3,:);
% Transform the last 3 elements into quaternion, then multiply
q_W = rot2quat(W(4:6,:));
X(4:7,:) = quatmultiply(YY(4:7,:)',q_W)';
end