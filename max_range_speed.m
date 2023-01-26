function [vmr, P] = max_range_speed(params, altitude, disa, mass)
%MAX_RANGE_SPEED Speed for maximum range.
%
%   [VMR, P] = MAX_RANGE_SPEED(PARAMS, ALTITUDE, DISA, MASS) calculates
%   speed VMR for maximum range and the respective power P.

% Unpack
R = params.main_rotor.radius;
cd0 = params.main_rotor.cd0;
k = params.main_rotor.k;
omega = params.main_rotor.omega;
b = params.main_rotor.blades;
c = params.main_rotor.chord;
fa = params.fa;
eta = params.eta_mech;

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

    function range = fobj(V)
        % Specific range (negative for maximization)
        mu = V/omega/R;
        lamb_i = induced_speed_ratio(mu, lamb_c, lamb_i0);
        cp = power_coefficient(k, CT, lamb_i, sig, cd0, mu, fa, R, ...
            lamb_c, eta);
        P = cp*rho*A*(omega*R)^3;
        range = -V/P;
    end

% Maximum range speed
vmr = fminsearch(@fobj, 20);

end
