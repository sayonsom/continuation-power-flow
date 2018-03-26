% CPF

clc 
clear all
close all
ReadData;

maxiterations=100;
tolerance=1e-3;

Ybus=Calculate_Ybus(BusData,BranchData);       % Function to calculate Ybus.

% reordering the buses to line them up as Slack, PV, PQ
posPV=BusData(:,4)==2;
posSL=BusData(:,4)==3;  % index of Slack and PV buses

aux1=(1-posPV-posSL);
aux1(aux1==1)=transpose(1:length(aux1(aux1==1)));
auxPos=[transpose(1:length(posPV)) posPV+posSL  aux1];

N=max(BusData(:,1));
% ---- BEGIN: Setting Voltage, at Slack and PV buses ---
V=ones(N,1);
d= zeros(N,1);% flat start.
% ---- END: Setting Voltage, at Slack and PV buses ---

V(posSL+posPV==1)= BusData(posSL+posPV==1,5);

%Scheduled Values
Psch= BusData(:,9)-BusData(:,7);
Qsch= BusData(:,10)-BusData(:,8);

Pschred=Psch(posSL==0);
Qschred=Qsch((posSL+posPV)==0);

dred=d(posSL==0);Vred=V((posSL+posPV)==0);
% K matrix is the column of PQscheduled values.
K=[Pschred;Qschred];    
tolerance=1e-3;
maxiterations=25;

% --- USER INPUT: WHICH BUS CPF TO DO? ---
BusForCPF=14;
% ----------------------------------------


%changefactor --> mutlipier to designate rate of load change at bus i as lambda
%changes

changefactor = 0.75; 

Y_Vph1=[];
Y_Vph2=[];
Y_Vph3=[];

X_LamdaPh1=[];
X_LamdaPh2=[];
X_LamdaPh3=[];

% PART 1 --> USING LOAD CHANGE IS CONTINUATION FACTOR     
    sigma=0.1;             % setting step size.
    lambda=0;              % setting lambda.
    while true
        % Predictor Step
            d_V_L=[dred;Vred;lambda];    % Column vector delta, V and lambda.
            [~,J]=Jacobian_NRLF(Ybus,V,d,posSL,posPV); % Calculating Jacobian matrix
            ek=[zeros(1,size(J,2)) 1];  % Defining row vector ek zeros and 1 at the end.
            K=[Pschred;Qschred];    % K matrix is the column of scheduled values.
            JKe=[J -K;ek];
            d_V_L=d_V_L+sigma*(JKe\ek');
            dred=d_V_L(1:length(dred));
			d(posSL==0)=dred;
            Vred=d_V_L(length(dred)+[1:length(Vred)]);
			V(posSL+posPV==0)=Vred;
            lambda=d_V_L(end);
        % Corrector Step
            [V,d,Pcalc,Qcalc,dP,dQ,dPred,dQred,dPdQred,temp]=NRLF(V,d,Ybus,lambda*Psch,lambda*Qsch,posSL,posPV,tolerance,maxiterations);
                
            if temp<maxiterations
                Y_Vph1=[Y_Vph1 ; V(BusForCPF)]; 
                X_LamdaPh1=[X_LamdaPh1;lambda];
                Last_d=d;Last_V=V;Last_LamdaPh1=lambda;
            else
                % Returning lambda, V and Angles(d) for the last 
                % converged iteration
                d=Last_d;
				V=Last_V;
				lambda=Last_LamdaPh1;
                dred=d(posSL==0);
				Vred=V((posSL+posPV)==0);
                break;  % If Newton Raphson does not converge.
            end
                
    end
% if the pf did not converge, change the continuation parameter and step
% size

    sigma=0.005;             % Defining Sigma.
    Last_Lamda=Last_LamdaPh1;

    while true
        % Predictor Step
            d_V_L=[dred;Vred;lambda];    % Column vector delta, V and lambda.
            [~,J]=Jacobian_NRLF(Ybus,V,d,posSL,posPV); % Calculating Jacobian matrix
            ek=[zeros(1,length(dred)+length(Vred)) 0];  % Defining row vector ek zeros and 1 at the end.
            ek(length(dred)+auxPos(BusForCPF,3))=-1; % Defining V at the bus as the continuation Variable
            JKe=[J -K;ek];
            ZerosOne=[zeros(length(dred)+length(Vred),1); 1];
            d_V_L=d_V_L+sigma*(JKe\ZerosOne);
            dred=d_V_L(1:length(dred));d(posSL==0)=dred;
            Vred=d_V_L(length(dred)+[1:length(Vred)]);V(posSL+posPV==0)=Vred;
            lambda=d_V_L(end);
             display('Predictor step -- [lambda value -- voltage at bus]');
			 [lambda V(BusForCPF)]
        % Corrector Step
            [~,J]=Jacobian_NRLF(Ybus,V,d,posSL,posPV); % Calculating Jacobian matrix
            [Pcalc,Qcalc,dP,dQ,dPred,dQred,dPdQred]=Calculate_PcalcQcalc(V,d,Ybus,lambda*Psch,lambda*Qsch,posSL,posPV); % Calculating P and Q Injected    
            RHS= [dPdQred ; 0];
            JPh2=[J -lambda*K;ek];
            dddVredL = JPh2\RHS;    % Calculating deltaDelta and DeltaV/V and Delta lambda
            d(posSL==0)=d(posSL==0)+dddVredL(1:N-1);
            V(posSL+posPV==0)=V(posSL+posPV==0)+dddVredL(N:length(dddVredL)-1);
            lambda=lambda+dddVredL(end);
            dred=d(posSL==0);
			Vred=V((posSL+posPV)==0);
            Y_Vph2=[Y_Vph2 ; 
				V(BusForCPF)]; 
            X_LamdaPh2=[X_LamdaPh2;lambda];

            if lambda > Last_Lamda
                Last_Lamda=lambda;
                LastV=V(BusForCPF);
            end
            if lambda<=changefactor*Last_LamdaPh1
                break;
            end
    end
% Change back the continuation parameter to power.
    sigma=0.1;             % Defining Sigma.
    while 1
        % Predictor Step
            d_V_L=[dred;Vred;lambda];    % Column vector delta, V and lambda.
            [~,J]=Jacobian_NRLF(Ybus,V,d,posSL,posPV); % Calculating Jacobian matrix
            ek=[zeros(1,size(J,2)) -1];  % Defining row vector ek zeros and 1 at the end.
            K=[Pschred;Qschred];    % K matrix is the column of scheduled values.
            JKe=[J -K;ek];
            d_V_L=d_V_L+sigma*(JKe\abs(ek)');
            dred=d_V_L(1:length(dred));d(posSL==0)=dred;
            Vred=d_V_L(length(dred)+[1:length(Vred)]);V(posSL+posPV==0)=Vred;
            lambda=d_V_L(end);

        % Corrector Step
            [V,d,Pcalc,Qcalc,dP,dQ,dPred,dQred,dPdQred,temp]=NRLF(V,d,Ybus,lambda*Psch,lambda*Qsch,posSL,posPV,tolerance,maxiterations);
                
            if temp<maxiterations && lambda>=0
                Y_Vph3=[Y_Vph3 ; V(BusForCPF)]; 
                X_LamdaPh3=[X_LamdaPh3;lambda];
            else
                break; % if no convergence is reached.
            end
    end
% End  -  PHASE 3 of the curve    
plot(X_LamdaPh1,Y_Vph1,'-og',X_LamdaPh2,Y_Vph2,'-*k',X_LamdaPh3,Y_Vph3,'-^r','LineWidth',2)
xlabel('lambda','FontSize',10)
ylabel('Voltage in P.U.','FontSize',10)
title(strcat('Loadability Curve for Bus #',num2str(BusForCPF)),'Fontsize',12)
grid on
% axis square
xlim=[0 4.5];ylim=[0 1.2];
