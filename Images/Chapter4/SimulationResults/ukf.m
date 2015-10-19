function [x,P,K]=ukf(x,P,Q,R,u,z)
% UKF   Unscented Kalman Filter for nonlinear dynamic systems
% [x, P] = ukf(f,x,P,h,z,Q,R) returns state estimate, x and state covariance, P 
% for nonlinear dynamic system (for simplicity, noises are assumed as additive):
%           x_k+1 = f(x_k,u_k,w_k) 
%           z_k   = g(x_k,v_k)
% where w ~ N(0,Q) meaning w is gaussian noise with covariance Q
%       v ~ N(0,R) meaning v is gaussian noise with covariance R
% Inputs:   x: "a priori" state estimate
%           P: "a priori" estimated state covariance
%           Q: process noise covariance 
%           R: measurement noise covariance
%           u: current control input
%           z: current measurement
% Output:   x: "a posteriori" state estimate
%           P: "a posteriori" state covariance
%
%
n=numel(x);                                 %numer of states
m=numel(z);                                 %numer of measurements
alpha=1e-3;                                 %default, tunable
ki=0;                                       %default, tunable
beta=2;                                     %default, tunable
lambda=alpha^2*(n+ki)-n;                    %scaling factor
c=n+lambda;                                 %scaling factor
Wm=[lambda/c 0.5/c+zeros(1,2*n)];           %weights for means
Wc=Wm;
Wc(1)=Wc(1)+(1-alpha^2+beta);               %weights for covariance
c=sqrt(c);
X=sigmas(x,P+Q,c);                            %sigma points around x
[x1,X1,P1,X2]=utf(X,Wm,Wc,n,Q,u);           %unscented transformation of process
[z1,Z1,P2,Z2]=utg(X1,Wm,Wc,m,R);            %unscented transformation of measurements
P12=X2*diag(Wc)*Z2';                        %transformed cross-covariance
K=P12*inv(P2);
x=x1+K*(z-z1);                              %state update
P=P1-K*P12';                                %covariance update


function [y,Y,P,Y1]=utf(X,Wm,Wc,n,Q,u)
%Unscented Transformation of Process
%Input:
%        X: sigma points
%       Wm: weights for mean
%       Wc: weights for covariance
%        n: number of outputs of f
%        Q: process noise covariance
%        u: input vector
%Output:
%        y: transformed mean
%        Y: transformed sampling points
%        P: transformed covariance
%       Y1: transformed deviations

L=size(X,2);
y=zeros(n,1);
Y=zeros(n,L);
for k=1:L                   
    Y(:,k)=f(X(:,k),u,zeros(6,1));       
    y=y+Wm(k)*Y(:,k);       
end
Y1=Y-y(:,ones(1,L));
% P=Y1*diag(Wc)*Y1'+Q;
P=Y1*diag(Wc)*Y1';          

function [y,Y,P,Y1]=utg(X,Wm,Wc,n,R)
%Unscented Transformation
%Input:
%        X: sigma points
%       Wm: weights for mean
%       Wc: weights for covariance
%        m: number of outputs of g
%        R: measurement noise covariance
%Output:
%        y: transformed mean
%        Y: transformed smapling points
%        P: transformed covariance
%       Y1: transformed deviations

L=size(X,2);
y=zeros(n,1);
Y=zeros(n,L);
for k=1:L                   
    Y(:,k)=g(X(:,k));       
    y=y+Wm(k)*Y(:,k);       
end
Y1=Y-y(:,ones(1,L));
P=Y1*diag(Wc)*Y1'+R;    

function X=sigmas(x,P,c)
%Sigma points around reference point
%Inputs:
%       x: reference point
%       P: covariance
%       c: coefficient
%Output:
%       X: Sigma points

[A,p] = chol(P);
if( p )
    display('Error, P is not positive definite')
end
A = c*A';
Y = x(:,ones(1,numel(x)));
X = [x Y+A Y-A]; 