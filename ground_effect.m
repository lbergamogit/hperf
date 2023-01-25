function v_ind_ratio = ground_effect(h_agl, R)
%GROUND_EFFECT
%
%   V_IND_RATIO = GROUND_EFFECT(H_AGL, R) calcualtes V_IND_RATIO =
%   VI_IGE/VI_OGE, the ratio between induced speeds in ground effect (IGE)
%   and out of ground effect (OGE) for a rotor with radius R at a height
%   above ground H_AGL.

% Data from Prouty
ge_data = [ ...
    0.058532695374800645, 0.5605304212168487
    0.12711323763955343, 0.6266770670826833
    0.19090909090909092, 0.6778471138845553
    0.26905901116427433, 0.7365054602184087
    0.3647527910685805, 0.7889235569422777
    0.4588516746411483, 0.8301092043681747
    0.5800637958532695, 0.8737909516380655
    0.6629984051036683, 0.9012480499219968
    0.7842105263157895, 0.9324492979719189
    0.9022328548644338, 0.9549141965678627
    1.0218500797448167, 0.9748829953198128
    1.2000000000000000, 1.0000000000000000
    ];

% h_agl over rotor diameter
h_over_D = h_agl/2/R;

% saturate input
h_over_D = max(h_over_D, 0.058532695374800645);
h_over_D = min(h_over_D, 1.2);

% interpolate
v_ind_ratio = interp1(ge_data(:,1), ge_data(:,2), h_over_D);

end