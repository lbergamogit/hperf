function [vh, P] = max_cruise_speed(params, altitude, disa, mass)
%MAX_CRUISE_SPEED
%
%   [VH, P] = MAX_CRUISE_SPEED(PARAMS, ALTITUDE, DISA, MASS)
%   calculates the maximum speed VH, in forward flight.

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
lamb_c = 0;

    function res = fobj(V)
        % Power
        mu = V/omega/R;
        lamb_i = induced_speed_ratio(mu, lamb_c, lamb_i0);
        cp = power_coefficient(k, CT, lamb_i, sig, cd0, mu, fa, R, ...
            lamb_c, eta);
        P = cp*rho*A*(omega*R)^3;
        res = (P - Pmax)^2;
    end

% Find min power speed
vma = min_power_speed(params, altitude, disa, mass);

% Max cruise speed. Set initial guess after min power speed.
vh = fminsearch(@fobj, 1.5*vma);

end
