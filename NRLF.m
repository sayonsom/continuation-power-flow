function [V,d,Pcalc,Qcalc,dP,dQ,dPred,dQred,dPdQred,it]=NRLF(V,d,Ybus,Psch,Qsch,posSL,posPV,Toler,Max_It)

it=0;N=length(V);
while 1
    [Pcalc,Qcalc,dP,dQ,dPred,dQred,dPdQred]=Calculate_PcalcQcalc(V,d,Ybus,Psch,Qsch,posSL,posPV); % Calculating P and Q Injected    
    if not(any(abs(dPdQred)>Toler) && (it<=Max_It))
        break;
    end
    it=it+1;
    [~,J]=Jacobian_NRLF(Ybus,V,d,posSL,posPV); % Calculating Jacobian matrix
    dddVred = J\dPdQred;    % Calculating deltaDelta and DeltaV/V
    dddV=1-[posSL;posSL+posPV];
    dddV(dddV==1)=dddVred;
    d=d+dddV(1:N);
    V=V.*(1+dddV(N+1:2*N));
end
