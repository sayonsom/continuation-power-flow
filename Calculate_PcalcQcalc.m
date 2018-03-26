function [Pcalc,Qcalc,dP,dQ,dPred,dQred,dPdQred]=Calculate_PcalcQcalc(V,d,Ybus,Psch,Qsch,posSL,posPV)
% This function calculates P and Q based on the Ybus, the 
% Voltages and its Angles.


Scalc=conj( V.*exp(1i*d)).*(Ybus*(V.*exp(1i*d)));
Pcalc=real(Scalc);
Qcalc=-imag(Scalc);
dP=Psch-Pcalc;dQ=Qsch-Qcalc;
dPred=dP(posSL==0);
dQred=dQ(posSL+posPV==0);
dPdQred=[dPred;dQred];
