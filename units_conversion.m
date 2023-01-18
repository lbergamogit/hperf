function units = units_conversion
%UNITS_CONVERSION Units conversion
%
%  Conversion to base unit (SI): multiply by respective constant
%  Conversion from bras unit: divide by respective constant
%
%  Example:
%  V = 100 * units.knot; % Assing the value of 100 knots to V, converted to
%                          base unit (SI)
%  disp(V) % Show V in base (SI) unit
%
%  V_kt = V / units.knot; % Convert V to knot
%  disp(V_kt)
%
%  V_ftpmin = V / units.foot_per_minute; % Convert V to feet per minute
%  disp(V_ftpmin)

% Length
units.meter = 1;
units.milimiter = 1e-3;
units.foot = 0.3048;
units.inch = 0.0254;
units.kilometer = 1000;
units.nautical_mile = 1852;
units.statute_mile = 1609.34;

% Time
units.second = 1;
units.minute = 60;
units.hour = 3600;

% Mass
units.kilogram = 1;
units.pound = 0.453592;

% Force
units.newton = 1;
units.kilogram_force = 9.80665;
units.pound_force = 4.44822;

% Speed
units.meter_per_second = 1;
units.foot_per_minute = units.foot/units.minute;
units.foot_per_second = units.foot/units.second;
units.knot = units.nautical_mile/units.hour;
units.kilometer_per_hour = units.kilometer/units.hour;

% Acceleration
units.meter_per_second_2 = 1;
units.g = 9.80665;

% Power
units.watt = 1;
units.kilowatt = 1000;
units.hp = 745.7;

% Energy
units.joule = 1;
units.kilowatt_hour = units.kilowatt * units.hour;

% Current
units.ampere = 1;
units.miliampere = 0.001;

% Charge
units.coulomb = 1;
units.ampere_hour = units.hour;

% Angle
units.radian = 1;
units.degree = pi/180;

% Density
units.kilogram_per_meter_3 = 1;
units.pound_per_foot_3 = units.pound/units.foot^3;

% Frequency
units.radian_per_second = 1;
units.hertz = 2*pi;
units.rpm = 2*pi/60;

% assignin('caller', 'units', units)



