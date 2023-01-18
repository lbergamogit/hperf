function [rho, p, T, a] = atmosphere(h, disa)
%ATMOSPHERE Atmosphere model up to 20km.
%
%   [RHO, P, T, A] = ATMOSPHERE(H) returns air density RHO, pressure
%   P, temperature T and sound speed A, given height H in meters for 
%   the ISA atmosphere.
%
%   [RHO, P, T, A] = ATMOSPHERE(H, DISA) considers a temperature variation
%   DISA (in K or degC) relative to standard temperature.

if nargin < 2
    disa = 0;
end

R = 287.0528;
p0 = 101325;
g = 9.80665;
T0 = 288.15;
gam = 1.4;
h_trop = 11000;
h_max = 20000;

if any(h > h_max)
    error('Altitude should be less than %.0fm.', h_max)
end

if h < h_trop
    T_isa = T0 - 6.5e-3*h;
else
    T_isa = 216.65;
end

T = T_isa + disa;

p = p0 * exp(-g/R./T_isa.*h);

rho = p/R./T;

a = (gam*R*T).^0.5;

end