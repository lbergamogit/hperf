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


%% Min power
[vma, P_min] = min_power_speed(params, h, disa, params.mtow);

fprintf('V min power: %.0f kt\n', vma / units.knot)
fprintf('P min: %.0f hp\n', P_min / units.hp)

%% Forward level flight
figure

lamb_c = 0;

speed_vec = (0:120)' * units.knot;
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
plot(vma / units.knot, P_min / units.kilowatt, 'o')
plot(speed_vec / units.knot, ...
    ones(size(speed_vec))*params.power_max / units.kilowatt, '--r')

title('Cruise','interpreter','latex')
xlabel('$TAS$ [kt]','interpreter','latex')
ylabel('$P$ [kW]','interpreter','latex')
legend('Power','V min power','Max power','location','northwest')
figure_format











