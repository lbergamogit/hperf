function [vy, roc, P] = ...
    max_rate_of_climb_speed(params, altitude, disa, mass)
%MAX_RATE_OF_CLIMB_SPEED
%
%   [VY, ROC, P] = MAX_RATE_OF_CLIMB_SPEED(PARAMS, ALTITUDE, DISA, MASS)
%   calculates the speed VY for which the helicopter achieves maximum rate
%   of climb ROC with corresponding power P.

% Unpack
R = params.main_rotor.radius;
cd0 = params.main_rotor.cd0;
k = params.main_rotor.k;
omega = params.main_rotor.omega;
b = params.main_rotor.blades;
c = params.main_rotor.chord;
fa = params.fa;
eta = params.eta_mech;
Pmax = params.power_max;

% Calculated parameters
rho = atmosphere(altitude, disa);
T = mass*9.81;
A = pi*R^2;
sig = solidity(b, c, R);

% Thrust coefficient
CT = thrust_coefficient(T, rho, R, omega);

% Induced speeds
lamb_i0 = induced_speed_ratio_hover(CT);

cp = 0; % Initialize to be used outside fobj

% Optimization with fminsearch and power restriction included as a 
% penalty in objective function to avoid license required for fmincon.
res = fminsearch(@fobj, [0, 20]);
roc = res(1);
vy = res(2);

% Power at max ROC
P = cp*rho*A*(omega*R)^3;

    function res = fobj(x)
        % Objective function to optimize for maximum rate of climb with
        % power restriction.
        Vc = x(1);
        V = x(2);
        
        % Power
        mu = V/omega/R;
        lamb_c = Vc/omega/R;
        lamb_i = induced_speed_ratio(mu, lamb_c, lamb_i0);
        cp = power_coefficient(k, CT, lamb_i, sig, cd0, mu, fa, R, ...
            lamb_c, eta);
        delta_P = (cp*rho*A*(omega*R)^3 - Pmax)^2;
        res = delta_P/1e2 - Vc*1000;
    end

end