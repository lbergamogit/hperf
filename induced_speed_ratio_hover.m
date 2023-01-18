function lamb_i0 = induced_speed_ratio_hover(CT)
%LAMB_I0 Induced speed at hover.
%
%   LAMB_I0 = INDUCED_SPEED_HOVER(CT) returns the induced speed at 
%   Hover given thrust coefficient CT.

lamb_i0 = (CT/2)^0.5;

end
