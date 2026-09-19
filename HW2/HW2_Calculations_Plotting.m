clc; clear;
%% DISCLAIMER: Guides TO USE THIS CODE.
%Go to https://github.com/JTAGUA/AOE4474_Labs.git and download the folder
%The only change this code needs is to fix the paths of each folder in
%lines 22, 110, 111 and 112

%% Definition of the global variable
D = 0.24; % [m] Diameter of the propeller
R = 287.05; % J/(kg*K)
mu0 = 1.716 * 10^(-5); %[Pa*s]
S = 110.4; %[K] Sutherland's Constant
Temp_0 = 273.15; %[K] Reference Temperature

%% First Part: Calculation for a fixed wind tunnel velocity
%Plot comparing thrust coefficient for the J = 0 condition as a function of
%Reynolds number

%Experiment was conducted for an specific wind tunnel velocity and Reynolds
%number was changed by changing the rotational speed of the propeller in
%order to change thrust and torque.

%Data gathering from excel
folder_1 = 'C:\Users\Jacobo_Tagua\Desktop\VTECH\AOE 4474_Propellers and Turbines\LABS\HW2\DATA\Fixed Tunnel Velocity'; 
patron_1 = fullfile(folder_1, '*.csv');
files_1 = dir(patron_1);
Nfiles_1 = length(files_1);

n_elec_1 = zeros(Nfiles_1, 1); % [rpm] Propeller's rotational speed (Electric)
n_opt_1 = zeros(Nfiles_1, 1); % [rpm] Propeller's rotational speed (Optical)
T_1 = zeros(Nfiles_1, 1); % [N] Propeller's Thrust
Q_1 = zeros(Nfiles_1, 1); % [N*m] Propeller's Torque

% Loop to read files
for i = 1:Nfiles_1
    Route = fullfile(folder_1, files_1(i).name);
    Data = readmatrix(Route);

    % Data extraction by column
    torque = Data(:, 9);
    thrust = Data(:, 10);
    rpm_elec = Data(:, 13);
    rpm_opt = Data(:, 14);

    Q_1(i, 1) = mean(torque, 'omitnan'); 
    T_1(i, 1) = mean(thrust, 'omitnan'); 
    n_elec_1(i, 1) = mean(rpm_elec, 'omitnan'); 
    n_opt_1(i, 1) = mean(rpm_opt, 'omitnan');  
end

V_1 = 2.2591; %[m/s] Wind velocity
Temp_1 = 21.75 + 273.15; % [K]
P_1 = 0.947403 * 101325; % [Pa]
%Select the measurement for the rpm (we are going to select the optical measurement)
n_1 = n_opt_1 / 60; %rps

%Density and viscosity (obtained from the temperature and barometric
%readings)
Rho_1 = P_1 / (R * Temp_1); %[kg/m^3] For one wind tunnel velocity
mu_1 = mu0 * (Temp_1/Temp_0)^(1.5)*((Temp_0 + S)/(Temp_1 + S));  %[Pa*s] For one wind tunnel velocity

%Dimensionless Variables
Re_1 = (Rho_1 .* n_1 .* D^2) ./ mu_1 % Calculate Reynolds number for each condition
J_1 = V_1 ./ (n_1 .* D); %Advance Ratio
CT_1 = T_1 ./ (Rho_1 .* n_1.^2 .* D^4) %Thrust coefficient
CQ_1 = Q_1 ./ (Rho_1 .* n_1.^2 .* D^5) %Torque coefficient
Efficiency_1 = CT_1 .* J_1 ./ (CQ_1 .* 2*pi) %Propellers Efficiency


%PLOTTING

fig1 = figure('Name', 'Propeller Performance Tabs 1', 'NumberTitle', 'off');
tgroup1 = uitabgroup(fig1);

tab1_1 = uitab(tgroup1, 'Title', 'Thrust (Ct)');
ax1_1 = axes('Parent', tab1_1);
plot(ax1_1, Re_1, CT_1, '-.b', 'linewidth', 2, 'MarkerSize', 15, 'MarkerFaceColor', 'b')
xlabel(ax1_1, 'Reynolds Number (Re)')
ylabel(ax1_1, 'Thrust Coefficient (Ct)')
title('Thrust Coefficient vs Reynolds Number')
grid(ax1_1, 'on')

tab2_1 = uitab(tgroup1, 'Title', 'Torque (Cq)');
ax2_1 = axes('Parent', tab2_1);
plot(ax2_1, Re_1, CQ_1, '-.g', 'LineWidth', 2, 'MarkerSize', 15, 'MarkerFaceColor', 'g')
xlabel(ax2_1, 'Reynolds Number (Re)')
ylabel(ax2_1, 'Torque Coefficient (Cq)')
title('Torque Coefficient vs Reynolds Number')
grid(ax2_1, 'on')

tab3_1 = uitab(tgroup1, 'Title', 'Efficiency (η)');
ax3_1 = axes('Parent', tab3_1);
plot(ax3_1, Re_1, Efficiency_1, '-.r', 'linewidth', 2, 'MarkerSize', 15, 'MarkerFaceColor', 'r')
xlabel(ax3_1, 'Reynolds Number (Re)')
ylabel(ax3_1, 'Efficiency (η)')
title('Efficiency vs Reynolds Number')
grid(ax3_1, 'on')

%% Second Part: Calculations for 3 different Reynolds numbers.
%Plot of thrust coefficient, torque coefficient, and propeller efficiency
%as a function of Reynolds Number 

%Experiment was conducted for 3 different Reynolds number, for each fixed
%rotation speed of the propeller we get a Reynolds number (rho*n*D^2/mu) 
%and we can vary Tunnel Velocity to change Thrust, Torque and Efficiency
    %Assumption: For each tunnel velocity rho and mu vary but we will 
    %consider them "constant" for analysis purposes

%Data gathering from excel
folder_2 = cell(3,1);

folder_2{1} = 'C:\Users\Jacobo_Tagua\Desktop\VTECH\AOE 4474_Propellers and Turbines\LABS\HW2\DATA\Re1'; 
folder_2{2} = 'C:\Users\Jacobo_Tagua\Desktop\VTECH\AOE 4474_Propellers and Turbines\LABS\HW2\DATA\Re2'; 
folder_2{3} = 'C:\Users\Jacobo_Tagua\Desktop\VTECH\AOE 4474_Propellers and Turbines\LABS\HW2\DATA\Re3'; 
patron_2 = fullfile(folder_2{1}, '*.csv');
files_2 = dir(patron_2);
Nfiles_2 = length(files_2);

n_elec_2 = zeros(Nfiles_2, 3); % [rpm] Propeller's rotational speed (Electric)
n_opt_2 = zeros(Nfiles_2, 3); % [rpm] Propeller's rotational speed (Optical)
T_2 = zeros(Nfiles_2, 3); % [N] Propeller's Thrust
Q_2 = zeros(Nfiles_2, 3); % [N*m] Propeller's Torque

% Loop to read files
for j = 1:3
    patron_2 = fullfile(folder_2{j}, '*.csv');
    files_2 = dir(patron_2);
    for i = 1:Nfiles_2(1)
        Route = fullfile(folder_2{j}, files_2(i).name);
        Data = readmatrix(Route);

    % Data extraction by column
        torque = Data(:, 9);
        thrust = Data(:, 10);
        rpm_elec = Data(:, 13);
        rpm_opt = Data(:, 14);

        Q_2(i, j) = mean(torque, 'omitnan'); 
        T_2(i, j) = mean(thrust, 'omitnan'); 
        n_elec_2(i, j) = mean(rpm_elec, 'omitnan'); 
        n_opt_2(i, j) = mean(rpm_opt, 'omitnan');  
    end
end
V_2 = [0, 2.259, 4.777, 7.499, 10.042]' ; %[m/s] Wind Velocity
Temp_2 = [21.75, 21.75, 21.437, 21.562, 29.625]' + 273.15; % [K]
P_2 = [0.9474182, 0.947403, 0.9474667, 0.9474023, 0.9474482]' .* 101325; % [Pa]
n_2 = n_opt_2 / 60; %rps

Rho_2 = P_2 ./ (R .* Temp_2); %[kg/m^3] For one wind tunnel velocity
mu_2 = mu0 .* (Temp_2./Temp_0).^(1.5).*((Temp_0 + S)./(Temp_2 + S));%[Pa*s] For one wind tunnel velocity


%Dimensionless Variables
Re_2 = zeros(Nfiles_2, 3);
J_2 = zeros(Nfiles_2, 3);
CT_2 = zeros(Nfiles_2, 3);
CQ_2 = zeros(Nfiles_2, 3);
Efficiency_2 = zeros(Nfiles_2, 3);

for i = 1:3
    Re_2(:, i) = (Rho_2 .* n_2(:, i) .* D^2) ./ mu_2; % Calculate Reynolds number for each condition
    J_2(:, i) = V_2 ./ (n_2(:, i) .* D); %Advance Ratio
    CT_2(:, i) = T_2(:, i) ./ (Rho_2 .* n_2(:, i).^2 .* D^4); %Thrust coefficient
    CQ_2(:, i) = Q_2(:, i) ./ (Rho_2 .* n_2(:, i).^2 .* D^5); %Torque coefficient
    Efficiency_2(:, i) = CT_2(:,i) .* J_2(:, i) ./ (CQ_2(:, i) .* (2*pi)); %Propellers Efficiency
end

Re_2_Average = [mean(Re_2(:,1)), mean(Re_2(:,2)), mean(Re_2(:,3))] ./ 10^(5);

%PLOTTING

fig2 = figure('Name', 'Propeller Performance Tabs 2', 'NumberTitle', 'off');
tgroup2 = uitabgroup(fig2);

tab2_2 = uitab(tgroup2, 'Title', 'Thrust (Ct)');
ax1_2 = axes('Parent', tab2_2);

plot(ax1_2, J_2(:, 1), CT_2(:, 1), '-.b', 'LineWidth', 2, 'MarkerSize', 15, 'MarkerFaceColor', 'b') 
hold(ax1_2, 'on')
plot(ax1_2, J_2(:, 1), CT_2(:, 2), '-.g', 'LineWidth', 2, 'MarkerSize', 15, 'MarkerFaceColor', 'g')
plot(ax1_2, J_2(:, 1), CT_2(:, 3), '-.r', 'LineWidth', 2, 'MarkerSize', 15, 'MarkerFaceColor', 'r')
hold(ax1_2, 'off')

xlabel(ax1_2, 'Advance Ratio (J)')
ylabel(ax1_2, 'Thrust Coefficient (Ct)')
title('Thrust Coefficient vs Advance Ratio')
legend("Re = " + string(round(Re_2_Average, 1)) + " \times 10^5")
grid(ax1_2, 'on')

tab2_2 = uitab(tgroup2, 'Title', 'Torque (Cq)');
ax2_2 = axes('Parent', tab2_2);

plot(ax2_2, J_2(:, 2), CQ_2(:, 1), '-.b', 'LineWidth', 2, 'MarkerSize', 15, 'MarkerFaceColor', 'b') 
hold(ax2_2, 'on')
plot(ax2_2, J_2(:, 2), CQ_2(:, 2), '-.g', 'LineWidth', 2, 'MarkerSize', 15, 'MarkerFaceColor', 'g')
plot(ax2_2, J_2(:, 2), CQ_2(:, 3), '-.r', 'LineWidth', 2, 'MarkerSize', 15, 'MarkerFaceColor', 'r')
hold(ax2_2, 'off')

xlabel(ax2_2, 'Advance Ratio (J))')
ylabel(ax2_2, 'Torque Coefficient (Cq)')
title('Torque Coefficient vs Advance Ratio')
legend("Re = " + string(round(Re_2_Average, 1)) + " \times 10^5")
grid(ax2_2, 'on')

tab3_2 = uitab(tgroup2, 'Title', 'Efficiency (η)');
ax3_2 = axes('Parent', tab3_2);

plot(ax3_2, J_2(:, 3), Efficiency_2(:, 1), '-.b', 'LineWidth', 2, 'MarkerSize', 15, 'MarkerFaceColor', 'b') 
hold(ax3_2, 'on')
plot(ax3_2, J_2(:, 3), Efficiency_2(:, 2), '-.g', 'LineWidth', 2, 'MarkerSize', 15, 'MarkerFaceColor', 'g')
plot(ax3_2, J_2(:, 3), Efficiency_2(:, 3), '-.r', 'LineWidth', 2, 'MarkerSize', 15, 'MarkerFaceColor', 'r')
hold(ax3_2, 'off')

ylim(ax3_2, [0, 0.8])
xlabel(ax3_2, 'Advance Ratio (J)')
ylabel(ax3_2, 'Efficiency (η)')
title('Efficiency vs Advance Ratio')
legend("Re = " + string(round(Re_2_Average, 1)) + " \times 10^5")
grid(ax3_2, 'on')