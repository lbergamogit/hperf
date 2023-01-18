function s = solidity(b, c, r)
%SOLIDITY Rotor solidity.
%
%   S = SOLIDITY(B, C, R) returns the rotor solidity given number of blades B,
%   chord C and rotor radius R.

s = b*c/pi/r;

end