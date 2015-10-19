function [ done ] = checkCompletion( mu_x, p, epsilon )
%CHECKCOMPLETION Returns a boolean flag to indicate whether the simulation
%completion conditions have been met
% Inputs:
% mu_x - the current estimated state ([x y z a b g]')
% p - the target point
% epsilon - the tolerance 
% Outputs:
% done - a boolean flag indicating completion

if ( abs( mu_x(3) - p(3) ) <= epsilon || mu_x(3) > p(3))
    done = true;
else
    done = false;
end