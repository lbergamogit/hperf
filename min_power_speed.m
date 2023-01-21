function [vma, P] = min_power_speed(params, altitude, disa, mass)
%MIN_POWER_SPEED Minimum power for level flight.
%
%   [VMA, P] = MIN_POWER_SPEED(PARAMS, ALTITUDE, DISA, MASS) calculates
%   minimum power P for horizontal flight and the correspondig speed VMA.
%   VMA is the maximum autonomy speed.

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

    function P = fobj(V)
        % Power
        mu = V/omega/R;
        lamb_i = induced_speed_ratio(mu, lamb_c, lamb_i0);
        cp = power_coefficient(k, CT, lamb_i, sig, cd0, mu, fa, R, ...
            lamb_c, eta);
        P = cp*rho*A*(omega*R)^3;
    end

% Minimum power speed
[vma, P] = fminsearch(@fobj, 20);

end
