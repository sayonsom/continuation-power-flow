function [WholeJ,J]=Jacobian_NRLF(Ybus,V,d,posSL,posPV)



    N=length(V);    
    pos=[posSL;posSL+posPV];
    
    % -----------------    BEGIN: Building the Jacobian matrix   -------------
    % Elements J11
    % deriv_Pi/deriv_dj
    J11=-( abs(V)*transpose(abs(V)) ) .* abs(Ybus) .* ...
        sin( angle(Ybus) + repmat(transpose(d),N,1) - repmat(d,1,N) );
    J11=J11.*(1-eye(N));
    % deriv_Pi/deriv_di
    J11=J11-diag(sum(J11,2));
    
    % Elements J21
    % deriv_Qi/deriv_dj
    J21=-( abs(V)*transpose(abs(V)) ) .* abs(Ybus) .* ...
        cos( angle(Ybus) + repmat(transpose(d),N,1) - repmat(d,1,N) );
    J21=J21.*(1-eye(N));
    % deriv_Qi/deriv_di
    J21=J21-diag(sum(J21,2));
    
    % Elements J12
    % |Vj|*deriv_Pi/deriv_Vj 
    J12=J21.*(2*eye(size(J21))-ones(size(J21)));
    % Fixing the Diagonal elements "|Vi|*deriv_Pi/deriv_Vi" 
    J12=J12 + diag( 2*(abs(V).^2) .* real(diag(Ybus)) );

    
    % Elements J22
    % |Vj|*deriv_Qi/deriv_Vj 
    J22=J11.*(-2*eye(size(J21))+ones(size(J21)));
    % Fixing the Diagonal elements "|Vi|*deriv_Pi/deriv_Vi" 
    J22=J22 - diag( 2*(abs(V).^2) .* imag(diag(Ybus)) );
    
    J=[J11 J12;J21 J22];WholeJ=J;
    % delete empty Rows and Columns in Jacobian matrix and [dP dQ]
    J(:,pos>0)=[];J(pos>0,:)=[];
