function [MSE_id, MSE_val, theta, phi_id, phi_val, e_id, e_val, y_hat_id, y_hat_val]=calculate_for_prediction(N_id, N_val,m,na,nb,u_id, y_id, u_val, y_val)
phi_id=create_phi_matrix(N_id, m, na, nb, y_id, u_id);
theta=phi_id\y_id;
y_hat_id=phi_id*theta;
e_id=y_id(1:length(y_hat_id))-y_hat_id;
MSE_id=mean(e_id.^2);

phi_val=create_phi_matrix(N_val, m, na, nb, y_val, u_val);
y_hat_val=phi_val*theta;
e_val=y_val(1:length(y_hat_val))-y_hat_val;
MSE_val=mean(e_val.^2);
end