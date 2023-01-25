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
lamb_c = 0;
mu = 0;
lamb_i0 = induced_speed_ratio_hover(CT);
lamb_i = induced_speed_ratio(mu, lamb_c, lamb_i0);
CP_oge = ...
    power_coefficient(k, CT, lamb_i, sig, cd0, mu, fa, R, lamb_c, eta);
P_oge = CP_oge*rho*A*(omega*R)^3;

%% Hover varying ground height
h_agl_vec = (0:.1:2)'*2*R * units.meter;
P_vec = nan(size(h_agl_vec));
for i_h_agl = 1:length(h_agl_vec)
    
    h_agl = h_agl_vec(i_h_agl);
    v_ind_ratio = ground_effect(h_agl, R);
    
    lamb_i = induced_speed_ratio(mu, lamb_c, lamb_i0) * v_ind_ratio;
    CP = ...
        power_coefficient(k, CT, lamb_i, sig, cd0, mu, fa, R, lamb_c, eta);
    P = CP*rho*A*(omega*R)^3;
    
    P_vec(i_h_agl) = P;
    
end

figure
subplot(1,2,1)
plot(h_agl_vec / units.foot, P_vec / units.kilowatt)
xlabel('$h_{AGL}$ [ft]','interpreter','latex')
ylabel('$P$ [kW]','interpreter','latex')

subplot(1,2,2)
plot(h_agl_vec/2/R, P_vec / P_oge)
xlabel('$h_{AGL}/D$','interpreter','latex')
ylabel('$P_{IGE}/P_{OGE}$','interpreter','latex')

figure_format











