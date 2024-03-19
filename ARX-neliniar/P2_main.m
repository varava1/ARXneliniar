clear all; close all; clc;
load('iddata-01.mat')

% Datele de identificare
u_id=id.u;
y_id=id.y;
t_id=id_array(:,1);

% Datele de validare
u_val=val.u;
y_val=val.y;
t_val=val_array(:,1);

Ts=t_id(2)-t_id(1); % perioada de esantionare 

% Reprezentarea grafica a intrarii de identificare
figure
plot(t_id, u_id,'LineWidth',1)
xlabel("t")
ylabel("u id")
title("Date de identificare - intrare")
legend("u id")

% Reprezentarea grafica a iesirii de identificare
figure
plot(t_id, y_id,'LineWidth',1)
xlabel("t")
ylabel("y id")
title("Date de identificare - ieșire")
legend("y id")

% Reprezentarea grafica a intrarii de validare
figure
plot(t_val, u_val,'LineWidth',1)
xlabel("t")
ylabel("u val")
title("Date de validare - intrare")
legend("u val")

% Reprezentarea grafica a iesirii de validare
figure
plot(t_val,y_val,'LineWidth',1)
xlabel("t")
ylabel("y val")
title("Date de validare - ieșire")
legend("y val")

N_id=length(u_id); % numarul datelor de identificare
N_val=length(u_val); % numarul datelor de validare

grad_maxim=10; %gradul maxim al polinomului 
ordin_maxim=5; %ordinul maxim al sistemului

poz=1;

for m=1:grad_maxim
    for na=1:ordin_maxim
        nb=na; % consideram na=nb pentru simplitate 
        
        % predictie
        [MSE_pr_id(poz), MSE_pr_val(poz), theta, phi_id, phi_val, e_id, e_val, y_hat_id, y_hat_val]=calculate_for_prediction(N_id,N_val,m,na,nb,u_id, y_id, u_val, y_val);
        
        % simulare
        [y_tilda_val,e_val, MSE_sim_val(poz)] = calculate_for_simulation(N_val, m, na, nb, theta, u_val, y_val);
        [y_tilda_id,e_id, MSE_sim_id(poz)] = calculate_for_simulation(N_id, m, na, nb, theta, u_id, y_id);
        
        % actualizare variabile 
        y_hat_pr_id(:,poz)=y_hat_id;
        y_hat_pr_val(:,poz)=y_hat_val;

        y_hat_sim_id(:,poz)=y_tilda_id;
        y_hat_sim_val(:,poz)=y_tilda_val;

        theta(:,poz)=theta'; 

        order_vector(poz)=na; 

        poz=poz+1;
    end
end

%% -----------------------------PREDICTIE-----------------------------

%% MSE minima pe datele de identificare
[MSE10, index10]=min(MSE_pr_id);
sys_degree10=ceil(index10/ordin_maxim);
sys_order10=order_vector(index10);
%=> m=4, na=nb=5
%=> MSE pe id: 1.063903e-17
%=> MSE pe val: 1.647723e+07
%=> FENOMEN SUPRAANTRENARE
figure
plot(y_id,'LineWidth',1)
hold on
plot(y_hat_pr_id(:, index10),'LineWidth',1)
title(sprintf("Comparatie intre \ny-id si y-hat-id pentru m=%d, na=nb=%d => MSE=%d", sys_degree10, sys_order10, MSE10))
legend("valori reale ale functiei (IDENTIFICARE)", "valori aproximate (PREDICTIE)")

figure
plot(y_val,'LineWidth',1)
hold on
plot(y_hat_pr_val(:, index10),'LineWidth',1)
title(sprintf("Comparatie intre \ny-val si y-hat-val pentru m=%d, na=nb=%d => MSE=%d", sys_degree10, sys_order10, MSE_pr_val(index10)))
legend("valori reale ale functiei (VALIDARE)", "valori aproximate (PREDICTIE)")

%% MSE minima pe datele de validare
[MSE11, index11]=min(MSE_pr_val);
sys_degree11=ceil(index11/ordin_maxim);
sys_order11=order_vector(index11);
%=> MSE pe id: 0.20375
%=> MSE pe val: 0.19241

figure
plot(y_id,'LineWidth',1)
hold on
plot(y_hat_pr_id(:, index11),'LineWidth',1)
title(sprintf("Comparatie intre \ny-id si y-hat-id pentru m=%d, na=nb=%d => MSE=%.5f", sys_degree11, sys_order11, MSE_pr_id(index11)))
legend("valori reale ale functiei (IDENTIFICARE)", "valori aproximate (PREDICTIE)")

figure
plot(y_val,'LineWidth',1)
hold on
plot(y_hat_pr_val(:, index11),'LineWidth',1)
title(sprintf("Comparatie intre \ny-val si y-hat-val pentru m=%d, na=nb=%d => MSE=%.5f", sys_degree11, sys_order11, MSE11))
legend("valori reale ale functiei (VALIDARE)", "valori aproximate (PREDICTIE)")

%% grad mic, ordin mare => FENOMEN SUPRAANTRENARE 
index30=18;
sys_degree30=ceil(index30/ordin_maxim);
sys_order30=order_vector(index30);

figure
plot(y_id,'LineWidth',1)
hold on
plot(y_hat_pr_id(:, index30),'LineWidth',1)
title(sprintf("Comparatie intre \ny-id si y-hat-id pentru m=%d, na=nb=%d => MSE=%.5f", sys_degree30, sys_order30, MSE_pr_id(index30)))
legend("valori reale ale functiei (IDENTIFICARE)", "valori aproximate (PREDICTIE)")

figure
plot(y_val,'LineWidth',1)
hold on
plot(y_hat_pr_val(:, index30),'LineWidth',1)
title(sprintf("Comparatie intre \ny-val si y-hat-val pentru m=%d, na=nb=%d => MSE=%.5f", sys_degree30, sys_order30, MSE_pr_val(index30)))
legend("valori reale ale functiei (VALIDARE)", "valori aproximate (PREDICTIE)")

%% -----------------------------SIMULARE-----------------------------

%% MSE minima pe datele de identificare
[MSE20, index20]=min(MSE_sim_id);
sys_degree20=ceil(index20/ordin_maxim);
sys_order20=order_vector(index20);
%=> MSE pe id: 0.72468
%=> MSE pe val: 1.15986

figure
plot(y_id,'LineWidth',1)
hold on
plot(y_hat_sim_id(:, index20),'LineWidth',1)
title(sprintf("Comparatie intre \ny-id si y-hat-id pentru m=%d, na=nb=%d => MSE=%.5f", sys_degree20, sys_order20, MSE20))
legend("valori reale ale functiei (IDENTIFICARE)", "valori aproximate (SIMULARE)")

figure
plot(y_val,'LineWidth',1)
hold on
plot(y_hat_sim_val(:, index20),'LineWidth',1)
title(sprintf("Comparatie intre \ny-val si y-hat-val pentru m=%d, na=nb=%d => MSE=%.5f", sys_degree20, sys_order20, MSE_sim_val(index20)))
legend("valori reale ale functiei (VALIDARE)", "valori aproximate (SIMULARE)")

%% MSE minima pe datele de validare
[MSE21, index21]=min(MSE_sim_val);
sys_degree21=ceil(index21/ordin_maxim);
sys_order21=order_vector(index21);
%=> MSE pe id: 0.72468
%=> MSE pe val: 1.15986

figure
plot(y_id,'LineWidth',1)
hold on
plot(y_hat_sim_id(:, index21),'LineWidth',1)
title(sprintf("Comparatie intre \ny-id si y-hat-id pentru m=%d, na=nb=%d => MSE=%.5f", sys_degree21, sys_order21, MSE_sim_id(index21)))
legend("valori reale ale functiei (IDENTIFICARE)", "valori aproximate (SIMULARE)")

figure
plot(y_val,'LineWidth',1)
hold on
plot(y_hat_sim_val(:, index21),'LineWidth',1)
title(sprintf("Comparatie intre \ny-val si y-hat-val pentru m=%d, na=nb=%d => MSE=%.5f", sys_degree21, sys_order21, MSE21))
legend("valori reale ale functiei (VALIDARE)", "valori aproximate (SIMULARE)")

%% grad mic, ordin mic => FENOMEN SUBANTRENARE
index50=1;
sys_degree50=ceil(index50/ordin_maxim);
sys_order50=order_vector(index50);

figure
plot(y_id,'LineWidth',1)
hold on
plot(y_hat_sim_id(:, index50),'LineWidth',1)
title(sprintf("Comparatie intre \ny-id si y-hat-id pentru m=%d, na=nb=%d => MSE=%.5f", sys_degree50, sys_order50, MSE_sim_id(index50)))
legend("valori reale ale functiei (IDENTIFICARE)", "valori aproximate (SIMULARE)")

figure
plot(y_val,'LineWidth',1)
hold on
plot(y_hat_sim_val(:, index50),'LineWidth',1)
title(sprintf("Comparatie intre \ny-val si y-hat-val pentru m=%d, na=nb=%d => MSE=%.5f", sys_degree50, sys_order50, MSE_sim_val(index20)))
legend("valori reale ale functiei (VALIDARE)", "valori aproximate (SIMULARE)")


%% -----------------------------MSE-----------------------------
%%
figure
subplot(211),plot(1:grad_maxim, MSE_pr_id(1:grad_maxim), LineWidth=1)
xlabel("grad sistem")
ylabel("MSE id")
legend("MSE id")
subplot(212),plot(1:grad_maxim, MSE_pr_val(1:grad_maxim), LineWidth=1)
xlabel("grad sistem")
ylabel("MSE val")
legend("MSE val")
sgtitle('PREDICTIE: Evolutie MSE in functie de gradul sistemului')

%%
figure
subplot(211),plot(1:ordin_maxim, MSE_pr_id(1:ordin_maxim), LineWidth=1)
xlabel("ordin sistem")
ylabel("MSE id")
legend("MSE id")
subplot(212),plot(1:ordin_maxim, MSE_pr_val(1:ordin_maxim), LineWidth=1)
xlabel("ordin sistem")
ylabel("MSE val")
legend("MSE val")
sgtitle('PREDICTIE: Evolutie MSE in functie de ordinul sistemului')

%%
figure
subplot(211),plot(1:grad_maxim, MSE_sim_id(1:grad_maxim), LineWidth=1)
xlabel("grad sistem")
ylabel("MSE id")
legend("MSE id")
subplot(212),plot(1:grad_maxim, MSE_sim_val(1:grad_maxim), LineWidth=1)
xlabel("grad sistem")
ylabel("MSE val")
legend("MSE val")
sgtitle('SIMULARE: Evolutie MSE in functie de gradul sistemului')

%%
figure
subplot(211),plot(1:ordin_maxim, MSE_sim_id(1:ordin_maxim), LineWidth=1)
xlabel("ordin sistem")
ylabel("MSE id")
legend("MSE id")
subplot(212),plot(1:ordin_maxim, MSE_sim_val(1:ordin_maxim), LineWidth=1)
xlabel("ordin sistem") 
ylabel("MSE val")
legend("MSE val")
sgtitle('SIMULARE: Evolutie MSE in functie de ordinul sistemului')

%% all 3
figure
plot(y_val,'LineWidth',1)
hold on
plot(y_hat_pr_val(:, index11),"green", 'LineWidth',1)
hold on
plot(y_hat_sim_val(:,index21),"magenta",'LineWidth',1)
title("Comparatie intre y-val, y-hat-val (predictie), y-hat-val (simulare)")
legend("valori reale ale functiei (VALIDARE)", "valori aproximate (PREDICTIE)", "valori aproximate (SIMULARE)")


%% all 3
figure
plot(y_id,'LineWidth',1)
hold on
plot(y_hat_pr_id(:, index10),"green", 'LineWidth',1)
hold on
plot(y_hat_sim_id(:,index20),"magenta",'LineWidth',1)
title("Comparatie intre y-id, y-hat-id (predictie), y-hat-id (simulare)")
legend("valori reale ale functiei (IDENTIFICARE)", "valori aproximate (PREDICTIE)", "valori aproximate (SIMULARE)")