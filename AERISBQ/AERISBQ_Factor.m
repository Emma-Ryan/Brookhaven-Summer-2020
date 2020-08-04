function [p, q] = AERISBQ_Factor(N)
    v1 = BQF;
	v2 = BQF;
    i = 1; %%Analagous to row number of matrix. 
    
    v1.value = zeros(i,4);
    v2.value = zeros(i,4);
    
    BQF_v = {v1, v2};
    
    %%Initializing with values obtained Round 0.
    v1.value(1,1:4) = BQF.BQF_construction(2, 1, 1, N);
   
    r(i) = v1.value(i, 2);
    s(i) = v1.value(i, 3);
    
    total_forms = 0;
    round_number = 0;
    
    foundSolution = false;
    
    while ~foundSolution
        %%At new round, move to next available row position and clear v2 (the child vector).
        round_number = round_number + 1;
        final_v1 = size(v1);
        i = final_v1(1) + 1;
        v2.value = zeros(i,4);
        
        %%Calculate new child BQFs from the previously added BQFs in v1.
        previous_round_i = v1(1, :) == 2^(round_number - 1);
        previous_i_change = size(previous_round_i); 
        previous_i_change = previous_i_change(1);
        delta_i_previous = (i - 1) - previous_i_change; 
        
        a = 2.^(round_number + 1);
        
        if v1(1, :) == 2^(round_number - 1)
            w = 1;
            
            for k = ((i - 1) - delta_i_previous):(i - 1)
                BQF_children_round_i = BQF.BQF_create_children(a, r(k), s(k), N);
                BQF_children_round_i_size = size(BQF_children_round_i);
                BQF_children_round_i_size = BQF_children_round_i_size(1);
                BQF_children_round_i_final(w:(w + (BQF_children_round_i_size)), 1:4) = BQF_children_round_i;
                w = w + BQF_children_round_i_size + 1;
            end
        end
            
        %%Input newly formed BQFs into v2 and remove permutations.   
        v2.value(1:w, 1:3) = BQF_children_round_i_final(1:w, 1:3);
        v2.value = BQF.BQF_remove_permutations(v2, w);       
            
        %%Adding new BQFs (with removed permutations) into v1. 
        size_v2 = size(v2);
        size_v2 = size_v2(1);
        v1.value(i:(i + size_v2), 1:3) = v2(:, 1:3);
        
        total_forms = total_forms + size_v2;
        
        delta_i_current = (i + size_v2) - i;   
        
        if v1(1, :) == 2^(round_number + 1)  
            for z = i:(i + delta_i_current)
                p = v1(1, z) + v1(z, 2);  
            
                if mod(N, p) == 0
                    q = N/p;
                    foundSolution = true;
                else
                    q = v1(1, z) + v1(z, 3);
                        if mod(N, q) == 0
                            p = N/q;
                            foundSolution = true;
                        end
                end
            end
        end
        
            if foundSolution
                if (p > q)
                    swap(p, q);
                end
            end
    end
            