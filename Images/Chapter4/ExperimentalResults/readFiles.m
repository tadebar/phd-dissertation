function [ raw ] = readFiles(dir, i )
%READPOLYFILE Reads the polynomial coefficients saved by Ultrasteer

raw.a = csvread([dir 'a_' num2str(i) '.txt']);
raw.b = csvread([dir 'b_' num2str(i) '.txt']);
raw.x = csvread([dir 'x_' num2str(i) '.txt']);
raw.z = csvread([dir 'z_' num2str(i) '.txt']);
raw.impts = csvread([dir 'impts_' num2str(i) '.txt']);
raw.scpts = csvread([dir 'scpts_' num2str(i) '.txt']);
raw.t = csvread([dir 't_' num2str(i) '.txt']);
raw.u = csvread([dir 'u_' num2str(i) '.txt']);
end

