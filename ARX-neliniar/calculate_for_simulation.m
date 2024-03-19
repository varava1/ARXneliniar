function [y_tilda,e,MSE] = calculate_for_simulation(N, m, na, nb, theta, u, y)

y_tilda=zeros(N,1);

for k=1:N
    phi_row=create_phi_row(m,na,nb,y_tilda,u,k);
    y_tilda(k)=phi_row*theta(1:length(phi_row));
end

e=y_tilda-y(1:length(y_tilda));
MSE=mean(e.^2);

end
