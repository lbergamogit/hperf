function lamb_i = induced_speed_ratio(mu, lamb_c, lamb_i0)
%INDUCED_SPEED_RATIO Induced speed ratio in forward flight.
%
%   LAMB_I = INDUCED_SPEED_RATIO(MU, LAMB_C, LAMB_I0) returns the induced 
%   speed in forward flight with advance ratio MU, climb induced speed 
%   ratio LAMB_C and induced speed ratio at hover LAMB_I0.
%
%   MU = V/OMEGA/R
%   LAMB_C = VC/OMEGA/R
%   LAMB_I0 = (CT/2)^0.5
%   Where V is the airspeed, VC is the climb speed, OMEGA is the rotor 
%   angular speed, R is the rotor radius, RHO is the air density and
%   A is the rotor disk area.

invalid = (lamb_c < -lamb_i0/4) & (lamb_c > -2);
if invalid
    warning(['Out of momentum theory valid range.\n', ...
        '  lamb_i0 = %f\n', ...
        '  lamb_c  = %f\n'], lamb_i0, lamb_c);
end

fres = @(lamb_i) lamb_i0^2/(mu^2 + (lamb_c + lamb_i)^2)^0.5 - lamb_i;

lamb_i = fzero(fres, lamb_i0);

end
