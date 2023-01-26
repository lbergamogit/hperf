clear
close all
clc

% Load helicopter parameters
helicopter = helicopter_01;

% Load mission parameters
mission_inputs = mission_01;

% Execute mission calculation
mission_outputs = mission(helicopter, mission_inputs);