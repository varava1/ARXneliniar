function [phi]=create_phi_matrix(N,m,na,nb,y, u)
    for k=1:N
        
        variables=[];

        for i=1:na
            if k-i>0
                 variables(i)=y(k-i); %iesirea sistemului
            else 
                variables(i)=0;
            end
        
        end
        
        nk=1; %timpul mort

        for i=1:nb
            if k-nk-i>0
                 variables(na+i)=u(k-nk-i); %intrarea intarziata
            else
                variables(na+i)=0;
            end
        end
        
        current_powers=[];
    
        monomials=generate_monomials(variables, m, current_powers);
        phi(k,:)=monomials;
    end
end