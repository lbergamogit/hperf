function cp = power_coefficient(k, CT, lamb_i, sig, cd0, mu, fa, R, ...
    lamb_c, eta)
%POWER_COEFFICIENT Rotor power coefficient.
%
%   CP = POWER_COEFFICIENT(K, CT, LAMB_I, SIG, CD0, MU, FA, R, LAMB_C, ...
%   ETA) returns the power coefficient given induced power 
%   factor K (tipically between 1.10 and 1.20), thrust coefficient CT, 
%   induced speed ratio LAMB_I, solidity SIG, blade profile drag CD0, 
%   advance ratio MU, equivalent fuselage drag area FA, rotor radius R, 
%   climb speed ratio LAMB_C and mechanical efficiency ETA.

A = pi*R^2;

cp = (k * CT * lamb_i + ... % Induced power
    sig * cd0/8 * (1 + 4.6*mu^2) + ... % Blade profile power
    0.5 * mu^3 * fa/A + ... % Fuselage drag power
    CT * lamb_c) ... % Climb power
    / eta; % Mechanical efficiency

end
