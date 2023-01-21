function params = helicopter_01()
%HELICOPTER_01 Helicopter parameters.
%
%   PARAMS = HELICOPTER_01() returns a structure with helicopter parameters.

units = units_conversion;

params = struct();

% Mass
params.empty_mass = 380       * units.kilogram;
params.mtow       = 720       * units.kilogram;
params.fuel_mass  = 160 * 0.8 * units.kilogram;

% Power and consumption
params.power_max            = 180 * units.hp;
params.eta_mech             = 0.8;
params.specific_consumption = 0.5 * (units.pound/units.hp/units.hour);

% Aerodynamics
params.fa  = 6 * units.foot^2;

% Main rotor
params.main_rotor.radius = 3.85 * units.meter;
params.main_rotor.chord  = 0.18 * units.meter;
params.main_rotor.blades = 3;
params.main_rotor.omega  = 492  * units.rpm;
params.main_rotor.cd0 = 0.012;
params.main_rotor.k = 1.15;

% Tail rotor
params.tail_rotor.radius = 0.6  * units.meter;
params.tail_rotor.chord  = 0.14 * units.meter;
params.tail_rotor.blades = 2;
params.tail_rotor.omega  = 3100 * units.rpm;
