function [  ] = plotstate( q, vlength )
%PLOTSTATE plot a colored coordinate frame to indicate position and
%orientation based on the [x y z r p y] state. Plot on the figure with
%supplied handle hfig

% Convert state to transformation matrix
T = state2trans(q);
p = T(1:3,4);

% Define axis colors
col = 'rgb';

% Loop through x,y,z axes
for i = 1:3
    v = [p p+vlength*T(1:3,i)];
    plot3(v(1,:),v(3,:),v(2,:),col(i),'LineWidth',3);
end
plot3(p(1),p(3),p(2),'ko','MarkerSize',5,'MarkerFaceColor','k');

end

