function fm = figure_of_merit(ct, cp)
%FIGURE_OF_MERIT
%
%   FM = FIGURE_OF_MERIT(CT, CP) returns the rotor figure of merit given
%   thrust coefficient CT and power coefficient CP.

fm = ct^1.5/2^0.5/cp;

end