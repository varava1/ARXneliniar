% x - vector simbolic care reprezinta variabilele polinomului
% m - gradul polinomului 
% current_powers - puterile curente ale fiecarei variabile

function monomials = generate_monomials(x, m, current_powers)
    if length(current_powers) == length(x)
        prod = 1;

        for i = 1:length(x)
            prod = prod * x(i)^current_powers(i);
        end

        monomials = prod;
    else
        monomials = [];
        % power - potentiala putere care inca nu a fost asignata variabilei
        % curente
        for power = 0:m - sum(current_powers) 
            
            new_current_powers=[current_powers, power]; %concatenarea valorii power la setul curent de puteri
            
            new_result=generate_monomials(x, m, new_current_powers); %apel recursiv
            
            monomials = [monomials, new_result];
        end
    end
end



