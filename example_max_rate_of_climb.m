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

%% Max ROC
[v_max_roc, max_roc, P_max_roc] = ...
    max_rate_of_climb_speed(params, h, disa, params.mtow);

fprintf('V max ROC: %.0f kt\n', v_max_roc / units.knot)
fprintf('Max ROC: %.0f ft/min\n', max_roc / units.foot_per_minute)
fprintf('P: %.0f hp\n', P_max_roc / units.hp)

%% Forward climb
figure

lamb_c = max_roc/omega/R;

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
plot(v_max_roc / units.knot, P_max_roc / units.kilowatt, 'o')
plot(speed_vec / units.knot, ...
    ones(size(speed_vec))*params.power_max / units.kilowatt, '--r')

title('Climb','interpreter','latex')
xlabel('$TAS$ [kt]','interpreter','latex')
ylabel('$P$ [kW]','interpreter','latex')
legend('Power','Max rate of climb','Max power','location','northwest')
figure_format











