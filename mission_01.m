function mission_inputs = mission_01
%MISSION_01 Mission parameters.
%
%   MISSION_INPUTS = MISSION_01() returns a structure with mission 
%   parameters.

units = units_conversion;

% General parameters
mission_inputs.delta_isa = 20;
mission_inputs.range = 300 * units.nautical_mile; % Set 0 for max range

% Departure
mission_inputs.departure_altitude = 0 * units.foot;
mission_inputs.departure_hover_height = 6 * units.foot + 2427 * units.milimiter;
mission_inputs.departure_hover_time = 5 * units.minute;

% Climb
mission_inputs.rate_of_climb = 1000 * units.foot_per_minute; % Set 0 max power
mission_inputs.climb_speed = 0; % Set 0 for Vy

% Cruise
mission_inputs.cruise_altitude = 2000 * units.foot;
mission_inputs.cruise_speed = 0; % Set 0 for max range speed

% Reserve
mission_inputs.reserve_time = 20 * units.minute;
mission_inputs.reserve_speed = 0; % Set 0 for max endurance speed

% Descent
mission_inputs.rate_of_descent = 1000 * units.foot_per_minute; % Set 0 min power
mission_inputs.descent_speed = 0; % Set 0 for Vy

% Arrival
mission_inputs.arrival_altitude = 0 * units.foot;
mission_inputs.arrival_hover_height = 6 * units.foot + 2427 * units.milimiter;
mission_inputs.arrival_hover_time = 5 * units.minute;

end