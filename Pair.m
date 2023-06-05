function Pair(bInit,bDayBegin,cellPar)
global g_idxSignal;
global TLen;
global g_idxKM;
global g_idxKD;
entroy_score=cellPar{1};
if bInit
    g_idxKM = traderRegKData('min',1);
    g_idxKD =traderRegKData('day',1);
    TLen = length(g_idxKM(:,1));
    g_idxSignal = traderRegUserIndi(@getSignal,{g_idxKM,g_idxKD,entroy_score}); 
else
    data = traderGetRegKData(g_idxKM,1,false);
    if isnan(data(5,end))|| isnan(data(13,end)) || data(1,end) ~= data(9,end)
        return
    end
    signal = traderGetRegUserIndi(g_idxSignal,1);
    mean1=signal(1);
    up_limit=signal(2);
    down_limit=signal(3);
    ratio=signal(4);
    strr=signal(5);
    spread=data(5)-data(13)*ratio-strr;
    if 100*ratio+strr<=0
        return
    end
    mp=traderGetAccountPositionV2(1,1:TLen);
    if spread <= down_limit && mp(1)==0&&mp(2)==0
        orderID1 = traderSellShortV2(1,1,100,0,'market','sell1');
        orderID2= traderBuyV2(1,2,100*ratio+strr,0,'market','buy1');
    end
    if spread >= mean1 && mp(1)>0 && mp(2)<0
        traderPositionToV2(1,1,0,0,'market','close');
        traderPositionToV2(1,2,0,0,'market','close');
    end
    if spread >= up_limit && mp(1)==0 &&mp(2)==0
        orderID3 = traderBuyV2(1,1,100,0,'market','buy2');
        orderID4= traderSellShortV2(1,2,100*ratio+strr,0,'market','sell2');
    end
    if spread <= mean1 && mp(1)<0 && mp(2)>0
        traderPositionToV2(1,1,0,0,'market','close');
        traderPositionToV2(1,2,0,0,'market','close');
    end
end
end
function value=getSignal(cellPar,bpPFCell)
value = [0,0,0,0,0];
idxKM =cellPar{1};
idxK =cellPar{2};
entroy_score =cellPar{3};
regKMatrixM = traderGetRegKData(idxKM,60,false,bpPFCell);
regKMatrixM(:,any(isnan(regKMatrixM),1))=[];

if isempty(regKMatrixM)
    return
end

%共有时间
regKMatrix = traderGetRegKData(idxK,60,false,bpPFCell);
regKMatrix(:,any(isnan(regKMatrix),1))=[];

if isempty(regKMatrix)
    return
end
%共有时间
Time = intersect(regKMatrix(1,:),regKMatrix(9,:));
[~,loc1] = ismember(Time,regKMatrix(1,:));
[~,loc2] = ismember(Time,regKMatrix(9,:));
current_data = regKMatrix(1:8,loc1);
next_data = regKMatrix(9:end,loc2);
[~,KLen]=size(current_data);
if KLen < 20
    return
end
Fit = polyfit(current_data(5,:),next_data(5,:),1);
%
TimeM = intersect(regKMatrixM(1,:),regKMatrixM(9,:));
[~,loc1M] = ismember(TimeM,regKMatrixM(1,:));
[~,loc2M] = ismember(TimeM,regKMatrixM(9,:));
current_dataM = regKMatrixM(1:8,loc1M);
next_dataM = regKMatrixM(9:end,loc2M);
[~,KLenM]=size(current_dataM);
if KLenM < 20
    return
end
rsd1 = next_dataM(5,:)-current_dataM(5,:)*Fit(1)-Fit(2);
std1=std(rsd1,1);
mean1=mean(rsd1);
up_limit=mean1+entroy_score*std1;
down_limit = mean1-entroy_score*std1;
value(1)=mean1;
value(2)=up_limit;
value(3)=down_limit;
value(4)=Fit(1);
value(5)=Fit(2);

end