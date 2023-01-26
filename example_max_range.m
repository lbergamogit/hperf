clear
close all
clc

units = units_conversion;

% Helicopter parameters
params = helicopter_01();

% Unpack
R = params.main_rotor.radius;
m = params.mtow;
cd0 = params.main_rotor.cd0;
k = params.main_rotor.k;
omega = params.main_rotor.omega;
fa = params.fa;
b = params.main_rotor.blades;
c = params.main_rotor.chord;
eta = params.eta_mech;

% Condition
h = 1000 * units.foot;
disa = 0;

% Calculated parameters
rho = atmosphere(h, disa);
sig = solidity(b, c, R);
T = m*9.81;
A = pi*R^2;

% Thrust coefficient
CT = thrust_coefficient(T, rho, R, omega);

% Induced speed at hover
lamb_i0 = induced_speed_ratio_hover(CT);

%% Max range speed
[v_max_range, P_max_range] = ...
    max_range_speed(params, h, disa, params.mtow);

fprintf('V max range: %.0f kt\n', v_max_range / units.knot)
fprintf('P max range: %.0f hp\n', P_max_range / units.hp)

%% Cruise
figure

lamb_c = 0;

speed_vec = (0:100)' * units.knot;
P_vec = nan(size(speed_vec));
for i_speed = 1:length(speed_vec)
    
    v = speed_vec(i_speed);
    mu = v/omega/R;
    lamb_i = induced_speed_ratio(mu, lamb_c, lamb_i0);
    CP = ...
        power_coefficient(k, CT, lamb_i, sig, cd0, mu, fa, R, lamb_c, eta);
    P = CP*rho*A*(omega*R)^3;
    
    P_vec(i_speed) = P;
    
end

plot(speed_vec / units.knot, P_vec / units.kilowatt)
hold on
plot(v_max_range / units.knot, P_max_range / units.kilowatt, 'o')
plot(speed_vec / units.knot, ...
    ones(size(speed_vec))*params.power_max / units.kilowatt, '--r')
plot(speed_vec / units.knot, interp1([0 v_max_range], [0 P_max_range], ...
    speed_vec, 'linear', 'extrap') / units.kilowatt, '--k')

title('Cruise','interpreter','latex')
xlabel('$TAS$ [kt]','interpreter','latex')
ylabel('$P$ [kW]','interpreter','latex')
legend('Power','Max range speed','Max power','location','southeast')
figure_format











