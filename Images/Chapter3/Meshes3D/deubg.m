%% Draw the cylinder
figure(1);
clear all; clf;

  r1=[10 10 10]';
  r2=[35 20 40]';
  R=1;
  N=7;

[X, Y, Z] = cylinder2P(R, N,r1,r2);
fv = surf2patch(X,Y,Z);

surf(X,Y,Z);
axis equal;