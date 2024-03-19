function [phi_row]=create_phi_row(m,na,nb,y, u, number_of_row)
        variables=[];

        k=number_of_row;

        for i=1:na
            if k-i>0
                 variables(i)=y(k-i);
            else 
                variables(i)=0;
            end
        
        end
        
        nk=1; %timpul mort

        for i=1:nb
            if k-nk-i>0
                 variables(na+i)=u(k-nk-i);
            else
                variables(na+i)=0;
            end
        end

        current_powers=[];
    
        phi_row=generate_monomials(variables, m, current_powers);
end