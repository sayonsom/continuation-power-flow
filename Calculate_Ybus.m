function Ybus=Calculate_Ybus(BusData,BranchData)


N=max(BusData(:,1)); % number of buses
Ybus=zeros(N);
% Calculating Ybus Elements off-diagonal
for i=1:N
    for j=i+1:N
        pos=(BranchData(:,1)==i & BranchData(:,2)==j) | (BranchData(:,1)==j & BranchData(:,2)==i);
        if any(pos)
            a=BranchData(pos,15);
            if a==0
                Ybus(i,j)= -1/(BranchData(pos,7)+(1i)*BranchData(pos,8));
            end
        end
    end
end
Ybus=Ybus+transpose(Ybus);
Ybus=Ybus+diag(-sum(Ybus,2));
for i=1:N
    pos=(BranchData(:,1)==i | BranchData(:,2)==i);
    if any(pos)
        Ybus(i,i) = Ybus(i,i)+sum((0.5i).*BranchData(pos,9))+sum(BusData(i,15)+(1i)*BusData(i,16)); 
    end
end
% For transformers
pos=BranchData(:,15)>0;
pos=pos.*[1:length(pos)]';
pos(pos==0)=[];
for n=pos'
    i=BranchData(n,1);
    j=BranchData(n,2);
    t=1/BranchData(n,15);
    Y=1./(BranchData(n,7)+1i*BranchData(n,8));
    Ybus(i,i)=Ybus(i,i)+Y*(abs(t)^2);
    Ybus(i,j)=Ybus(i,j)-conj(t)*Y;
    Ybus(j,i)=Ybus(j,i)-t*Y;
    Ybus(j,j)=Ybus(j,j)+Y;
end
% -----------------    END: Building the Ybus Matrix   ------------------
