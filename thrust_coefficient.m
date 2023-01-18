function CT = thrust_coefficient(T, rho, R, omega)
%THRUST_COEFFICIENT
%
%   CT = THRUST_COEFFICIENT(CT) returns the thrust coefficient, given
%   thrust T, air density RHO, rotor radius R and rotor angular speed
%   OMEGA.

A = pi*R^2;
Vtip = omega*R;
CT = T/rho/A/Vtip^2;

end