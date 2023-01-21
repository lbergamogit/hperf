function [cp, cp_i, cp_p, cp_f, cp_c, cp_misc] = ...
    power_coefficient(k, CT, lamb_i, sig, cd0, mu, fa, R, lamb_c, eta)
%POWER_COEFFICIENT Rotor power coefficient.
%
%   CP = POWER_COEFFICIENT(K, CT, LAMB_I, SIG, CD0, MU, FA, R, LAMB_C, ...
%   ETA) returns the power coefficient given induced power 
%   factor K (tipically between 1.10 and 1.20), thrust coefficient CT, 
%   induced speed ratio LAMB_I, solidity SIG, blade profile drag CD0, 
%   advance ratio MU, equivalent fuselage drag area FA, rotor radius R, 
%   climb speed ratio LAMB_C and mechanical efficiency ETA.
%
%   [CP, CP_I, CP_P, CP_F, CP_C, CP_MISC] = POWER_COEFFICIENT(...) returns
%   the cp breakdown:
%      CP_I: Induced
%      CP_P: Blade profile
%      CP_F: Fuselage (parasite)
%      CP_C: Climb
%      CP_MISC: Miscellaneous

A = pi*R^2;

cp_i = k * CT * lamb_i; % Induced power
cp_p = sig * cd0/8 * (1 + 4.6*mu^2); % Blade profile power
cp_f = 0.5 * mu^3 * fa/A; % Fuselage drag power
cp_c = CT * lamb_c; % Climb power

cp_req = cp_i + cp_p + cp_f + cp_c;

cp_misc = (1 - eta) * cp_req;

cp = cp_req + cp_misc;

end
