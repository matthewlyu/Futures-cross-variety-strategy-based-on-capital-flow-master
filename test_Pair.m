clear all;

clc;

 

targetList(1).Market    =  'SHFE';

targetList(1).Code  =  'AG0000';

 

 

targetList(2).Market    =   'SHFE';

targetList(2).Code  = 'AU0000';

 

%计算轨道周期
entroy_score=1;
Freq=1;

%每次触发交易条件则交易一手

 

 

%-------实时交易需要输入账号，回测回放已经默认账号，不再需要输入账号------%

 

%回测

% 在回测时设置初始资本1000000元

AccountList(1) = {'FutureBackReplay'};

%

% clear all;

tic;

traderRunBacktestV2('BackTest_Pair',@Pair,{entroy_score},AccountList,targetList,'min',1,20140101,20151231,'FWard');

% traderRunBacktest('BackTestTwoLinesO',@TwoLinesO,{len1,len2,shareNum,stoploss,stopprofit,trailinggap},AccountList,targetList,'min',3,20150101,20150131,'FWard');

toc;