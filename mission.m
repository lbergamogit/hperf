function mission_outputs = mission(helicopter, mission_inputs)
%MISSION Mission performance.
%
%   MISSION_OUTPUTS = MISSION(HELICOPTER, MISSION_INPUTS) calculates
%   mission performace for the helicopter defined by HELICOPTER struct
%   and mission parameters in MISSON_INPUTS struct.
%
%   Examples of helicopter and mission parameters structures are returned
%   by the functions HELICOPTER_01 and MISSION_01, respectively.

units = units_conversion;

%% Unpack
R = helicopter.main_rotor.radius;
cd0 = helicopter.main_rotor.cd0;
k = helicopter.main_rotor.k;
omega = helicopter.main_rotor.omega;
fa = helicopter.fa;
b = helicopter.main_rotor.blades;
c = helicopter.main_rotor.chord;
eta = helicopter.eta_mech;

% Calculated parameters
sig = solidity(b, c, R);
A = pi*R^2;

%% Outputs
P_ind = zeros(6,1);
P_profile = zeros(6,1);
P_parasite = zeros(6,1);
P_misc = zeros(6,1);
P_climb = zeros(6,1);
P_descent = zeros(6,1);
P_total = zeros(6,1);
speed = zeros(6,1);
fuel = zeros(6,1);
time = zeros(6,1);
distance = zeros(6,1);

%% Calculate mission

% Iteration control
tol = 1e-4;
max_iter = 100;
iter = 0;

% Starting secant method
cruise_time_old = 0;
rem_fuel_old = helicopter.fuel_mass;
range_old = 0;
cruise_time = 10 * units.minute;

while iter < max_iter
    
    iter = iter + 1;
    
    %% Hover in ground effect at departure - PHASE 1 ======================
    h = mission_inputs.departure_altitude;
    h_agl = mission_inputs.departure_hover_height;
    disa = mission_inputs.delta_isa;
    rho = atmosphere(h, disa);
    m = helicopter.mtow;
    
    % Thrust coefficient
    T = m*9.81;
    CT = thrust_coefficient(T, rho, R, omega);
    
    % Induced speed
    lamb_i0 = induced_speed_ratio_hover(CT);
    lamb_c = 0;
    mu = 0;
    v_ind_ratio = ground_effect(h_agl, R);
    lamb_i = induced_speed_ratio(mu, lamb_c, lamb_i0) * v_ind_ratio;
    
    % Power
    [cp, cp_i, cp_p, cp_f, cp_c, cp_misc] = ...
        power_coefficient(k, CT, lamb_i, sig, cd0, mu, fa, R, lamb_c, eta);
    P_dim = rho*A*(omega*R)^3;
    
    % Fuel
    t = mission_inputs.departure_hover_time;
    m_fuel_burn = cp * P_dim * t * helicopter.specific_consumption;
    
    % Distance
    dist = 0;
    
    % Outputs
    P_total(1) = P_dim * cp;
    P_ind(1) = P_dim * cp_i;
    P_profile(1) = P_dim * cp_p;
    P_parasite(1) = P_dim * cp_f;
    P_climb(1) = P_dim * cp_c;
    P_misc(1) = P_dim * cp_misc;
    speed(1) = 0;
    fuel(1) = m_fuel_burn;
    time(1) = t;
    distance(1) = dist;
    
    %% Climb - PHASE 2 ====================================================
    h = (mission_inputs.departure_altitude + ...
        mission_inputs.cruise_altitude)/2;
    disa = mission_inputs.delta_isa;
    rho = atmosphere(h, disa);
    m = m - m_fuel_burn;
    
    % Thrust coefficient
    T = m*9.81;
    CT = thrust_coefficient(T, rho, R, omega);
    
    % Speed
    if mission_inputs.climb_speed == 0
        % Max rate of climb (Vy)
        [v, roc] = max_rate_of_climb_speed(helicopter, h, disa, m);
    else
        v = mission_inputs.climb_speed;
    end
    
    % Rate of climb, if set
    if mission_inputs.rate_of_climb ~= 0
        roc = mission_inputs.rate_of_climb;
    end
    
    % Induced speed
    lamb_i0 = induced_speed_ratio_hover(CT);
    lamb_c = roc/omega/R;
    mu = v/omega/R;
    lamb_i = induced_speed_ratio(mu, lamb_c, lamb_i0);
    
    % Power
    [cp, cp_i, cp_p, cp_f, cp_c, cp_misc] = ...
        power_coefficient(k, CT, lamb_i, sig, cd0, mu, fa, R, lamb_c, eta);
    P_dim = rho*A*(omega*R)^3;
    
    % Fuel
    t = (mission_inputs.cruise_altitude - ...
        mission_inputs.departure_altitude) / roc;
    m_fuel_burn = cp * P_dim * t * helicopter.specific_consumption;
    
    % Distance
    dist = t * v;
    
    % Outputs
    P_total(2) = P_dim * cp;
    P_ind(2) = P_dim * cp_i;
    P_profile(2) = P_dim * cp_p;
    P_parasite(2) = P_dim * cp_f;
    P_climb(2) = P_dim * cp_c;
    P_misc(2) = P_dim * cp_misc;
    speed(2) = v;
    fuel(2) = m_fuel_burn;
    time(2) = t;
    distance(2) = dist;
    
    %% Cruise - PHASE 3 ===================================================
    h = mission_inputs.cruise_altitude;
    disa = mission_inputs.delta_isa;
    rho = atmosphere(h, disa);
    m = m - m_fuel_burn;
    
    % Thrust coefficient
    T = m*9.81;
    CT = thrust_coefficient(T, rho, R, omega);
    
    % Speed
    if mission_inputs.cruise_speed == 0
        % Max range speed
        v = max_range_speed(helicopter, h, disa, m);
    else
        v = mission_inputs.cruise_speed;
    end
    
    % Induced speed
    lamb_i0 = induced_speed_ratio_hover(CT);
    lamb_c = 0;
    mu = v/omega/R;
    lamb_i = induced_speed_ratio(mu, lamb_c, lamb_i0);
    
    % Power
    [cp, cp_i, cp_p, cp_f, cp_c, cp_misc] = ...
        power_coefficient(k, CT, lamb_i, sig, cd0, mu, fa, R, lamb_c, eta);
    P_dim = rho*A*(omega*R)^3;
    
    % Fuel
    t = cruise_time;
    m_fuel_burn = cp * P_dim * t * helicopter.specific_consumption;
    
    % Distance
    dist = t * v;
    
    % Outputs
    P_total(3) = P_dim * cp;
    P_ind(3) = P_dim * cp_i;
    P_profile(3) = P_dim * cp_p;
    P_parasite(3) = P_dim * cp_f;
    P_climb(3) = P_dim * cp_c;
    P_misc(3) = P_dim * cp_misc;
    speed(3) = v;
    fuel(3) = m_fuel_burn;
    time(3) = t;
    distance(3) = dist;
    
    %% Reserve - PHASE 4 ==================================================
    h = mission_inputs.cruise_altitude;
    disa = mission_inputs.delta_isa;
    rho = atmosphere(h, disa);
    m = m - m_fuel_burn;
    
    % Thrust coefficient
    T = m*9.81;
    CT = thrust_coefficient(T, rho, R, omega);
    
    % Speed
    if mission_inputs.reserve_speed == 0
        % Max endurance speed
        v = min_power_speed(helicopter, h, disa, m);
    else
        v = mission_inputs.reserve_speed;
    end
    
    % Induced speed
    lamb_i0 = induced_speed_ratio_hover(CT);
    lamb_c = 0;
    mu = v/omega/R;
    lamb_i = induced_speed_ratio(mu, lamb_c, lamb_i0);
    
    % Power
    [cp, cp_i, cp_p, cp_f, cp_c, cp_misc] = ...
        power_coefficient(k, CT, lamb_i, sig, cd0, mu, fa, R, lamb_c, eta);
    P_dim = rho*A*(omega*R)^3;
    
    % Fuel
    t = mission_inputs.reserve_time;
    m_fuel_burn = cp * P_dim * t * helicopter.specific_consumption;
    
    % Distance
    dist = 0;
    
    % Outputs
    P_total(4) = P_dim * cp;
    P_ind(4) = P_dim * cp_i;
    P_profile(4) = P_dim * cp_p;
    P_parasite(4) = P_dim * cp_f;
    P_climb(4) = P_dim * cp_c;
    P_misc(4) = P_dim * cp_misc;
    speed(4) = v;
    fuel(4) = m_fuel_burn;
    time(4) = t;
    distance(4) = dist;
    
    %% Descent - PHASE 5 ==================================================
    h = (mission_inputs.arrival_altitude + ...
        mission_inputs.cruise_altitude)/2;
    disa = mission_inputs.delta_isa;
    rho = atmosphere(h, disa);
    m = m - m_fuel_burn;
    
    % Thrust coefficient
    T = m*9.81;
    CT = thrust_coefficient(T, rho, R, omega);
    
    % Speed
    if mission_inputs.descent_speed == 0
        % Descent at max rate of climb (Vy)
        v = max_rate_of_climb_speed(helicopter, h, disa, m);
    else
        v = mission_inputs.descent_speed;
    end
    
    roc = -abs(mission_inputs.rate_of_descent);
    
    % Induced speed
    lamb_i0 = induced_speed_ratio_hover(CT);
    lamb_c = roc/omega/R;
    mu = v/omega/R;
    lamb_i = induced_speed_ratio(mu, lamb_c, lamb_i0);
    
    % Power
    [cp, cp_i, cp_p, cp_f, cp_c, cp_misc] = ...
        power_coefficient(k, CT, lamb_i, sig, cd0, mu, fa, R, lamb_c, eta);
    P_dim = rho*A*(omega*R)^3;
    
    % Fuel
    t = (mission_inputs.cruise_altitude - ...
        mission_inputs.arrival_altitude) / abs(roc);
    m_fuel_burn = cp * P_dim * t * helicopter.specific_consumption;
    
    % Distance
    dist = t * v;
    
    % Outputs
    P_total(5) = P_dim * cp;
    P_ind(5) = P_dim * cp_i;
    P_profile(5) = P_dim * cp_p;
    P_parasite(5) = P_dim * cp_f;
    P_descent(5) = P_dim * cp_c;
    P_misc(5) = P_dim * cp_misc;
    speed(5) = v;
    fuel(5) = m_fuel_burn;
    time(5) = t;
    distance(5) = dist;
    
    %% Hover in ground effect at arrival - PHASE 6 ========================
    h = mission_inputs.arrival_altitude;
    h_agl = mission_inputs.arrival_hover_height;
    disa = mission_inputs.delta_isa;
    rho = atmosphere(h, disa);
    m = m - m_fuel_burn;
    
    % Thrust coefficient
    T = m*9.81;
    CT = thrust_coefficient(T, rho, R, omega);
    
    % Induced speed
    lamb_i0 = induced_speed_ratio_hover(CT);
    lamb_c = 0;
    mu = 0;
    v_ind_ratio = ground_effect(h_agl, R);
    lamb_i = induced_speed_ratio(mu, lamb_c, lamb_i0) * v_ind_ratio;
    
    % Power
    [cp, cp_i, cp_p, cp_f, cp_c, cp_misc] = ...
        power_coefficient(k, CT, lamb_i, sig, cd0, mu, fa, R, lamb_c, eta);
    P_dim = rho*A*(omega*R)^3;
    
    % Fuel
    t = mission_inputs.arrival_hover_time;
    m_fuel_burn = cp * P_dim * t * helicopter.specific_consumption;
    
    % Distance
    dist = 0;
    
    % Outputs
    P_total(6) = P_dim * cp;
    P_ind(6) = P_dim * cp_i;
    P_profile(6) = P_dim * cp_p;
    P_parasite(6) = P_dim * cp_f;
    P_climb(6) = P_dim * cp_c;
    P_misc(6) = P_dim * cp_misc;
    speed(6) = 0;
    fuel(6) = m_fuel_burn;
    time(6) = t;
    distance(6) = dist;
    
    % Update cruise time with secant method
    if mission_inputs.range == 0
        % Iterate for maximum range
        rem_fuel = helicopter.fuel_mass - sum(fuel);
        cruise_time_new = cruise_time - (cruise_time - cruise_time_old) / ...
            (rem_fuel - rem_fuel_old)*rem_fuel;
        cruise_time = cruise_time_new;
        err = abs(rem_fuel);
        if err < tol
            break
        end
    else
        % Iterate for fixed range
        range = sum(distance);
        cruise_time_new = cruise_time - (cruise_time - cruise_time_old) / ...
            (range - range_old)*(range - mission_inputs.range);
        cruise_time = cruise_time_new;
        err = abs(range - mission_inputs.range);
        if err < tol
            break
        end
    end
    
end

%% Print results
fprintf('Terminated in %d iterations, error = %.4e\n\n', iter, err)

col_width = 10;
n_cols = 12;
fprintf([repmat(['+' repmat('-', 1, col_width+2)], 1, n_cols) '+\n'])
fprintf([repmat(['| %' num2str(col_width) 's '], 1, n_cols) '|\n'], ...
    'Phase', ...
    'P total', ...
    'P induced', ...
    'P profile', ...
    'P parasite', ...
    'P climb', ...
    'P descent', ...
    'P misc', ...
    'TAS', ...
    'Fuel', ...
    'Time', ...
    'Distance')
fprintf([repmat(['| %' num2str(col_width) 's '], 1, n_cols) '|\n'], ...
    '[-]', ...
    '[kW]', ...
    '[kW]', ...
    '[kW]', ...
    '[kW]', ...
    '[kW]', ...
    '[kW]', ...
    '[kW]', ...
    '[kt]', ...
    '[l]', ...
    '[min]', ...
    '[nm]')
fprintf([repmat(['+' repmat('-', 1, col_width+2)], 1, n_cols) '+\n'])
for i_row = 1:length(time)
    fprintf([repmat(['| %' num2str(col_width) '.1f '], 1, n_cols) '|\n'], ...
        i_row, ...
        P_total(i_row) / units.kilowatt, ...
        P_ind(i_row) / units.kilowatt, ...
        P_profile(i_row) / units.kilowatt, ...
        P_parasite(i_row) / units.kilowatt, ...
        P_climb(i_row) / units.kilowatt, ...
        P_descent(i_row) / units.kilowatt, ...
        P_misc(i_row) / units.kilowatt, ...
        speed(i_row) / units.knot, ...
        fuel(i_row) / 0.8, ...
        time(i_row) / units.minute, ...
        distance(i_row) / units.nautical_mile)
end
fprintf([repmat(['+' repmat('-', 1, col_width+2)], 1, n_cols) '+\n'])

total_time = sum(time);
hh = floor(total_time / 3600);
mm = floor((total_time - hh * 3600) / 60);
ss = floor(total_time - hh * 3600 - mm * 60);
fprintf('\nTotal fuel: %.1f l\n', sum(fuel) / 0.8)
fprintf('Total time: %d:%02d:%02d\n', hh, mm, ss)
fprintf('Range: %.1f nm\n', sum(distance) / units.nautical_mile)

mission_outputs.P_total = P_total;
mission_outputs.P_ind = P_ind;
mission_outputs.P_profile = P_profile;
mission_outputs.P_parasite = P_parasite;
mission_outputs.P_climb = P_climb;
mission_outputs.P_descent = P_descent;
mission_outputs.P_misc = P_misc;
mission_outputs.speed = speed;
mission_outputs.fuel = fuel;
mission_outputs.time = time;
mission_outputs.distance = distance;

end