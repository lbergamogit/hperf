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

% Thrust coefficient
CT = thrust_coefficient(T, rho, R, omega);

%% Hover

% Induced speeds
lamb_i0 = induced_speed_ratio_hover(CT);
mu = 0;
lamb_c = 0;
lamb_i = lamb_i0;

% Power coefficient in hover
CP_hover = power_coefficient(k, CT, lamb_i, sig, cd0, mu, fa, R, lamb_c, eta);

% Dimensional quantities
A = pi*R^2;
T = CT*rho*A*(omega*R)^2;
P = CP_hover*rho*A*(omega*R)^3;

% Figure of merit
FM = figure_of_merit(CT, CP_hover);

% Results
fprintf('Hover:\n')
fprintf('CT = %.4e\n', CT)
fprintf('CP = %.4e\n', CP_hover)
fprintf('FM = %.4f\n', FM)
fprintf('T = %.0f N\n', T)
fprintf('P = %.2f kW\n', P / units.kilowatt)


%% Forward climb

% Speed and rate of climb grid
speed_vec = (0:100)' * units.knot;
roc_vec = (0:500:1500)' * units.foot_per_minute;

figure
P_vec = zeros(size(speed_vec));
leg = cell(size(roc_vec));
for i_roc = 1:length(roc_vec)
    
    roc = roc_vec(i_roc);
    lamb_c = roc/omega/R;
    
    for i_speed = 1:length(speed_vec)
        
        v = speed_vec(i_speed);
        mu = v/omega/R;
        lamb_i = induced_speed_ratio(mu, lamb_c, lamb_i0);
        CP = power_coefficient(k, CT, lamb_i, sig, cd0, mu, fa, R, lamb_c, eta);
        P = CP*rho*A*(omega*R)^3;
        
        P_vec(i_speed) = P;
        
    end
    
    plot(speed_vec / units.knot, P_vec / units.kilowatt)
    hold on
    leg{i_roc} = sprintf('$ROC$ = %.0f ft/min', roc / units.foot_per_minute);
    
end

title('Climb','interpreter','latex')
xlabel('$TAS$ [kt]','interpreter','latex')
ylabel('$P$ [kW]','interpreter','latex')
legend(leg,'interpreter','latex')
figure_format







