clear all;

clc;

 

targetList(1).Market    =  'SHFE';

targetList(1).Code  =  'AG0000';

 

 

targetList(2).Market    =   'SHFE';

targetList(2).Code  = 'AU0000';

 

%����������
entroy_score=1;
Freq=1;

%ÿ�δ���������������һ��

 

 

%-------ʵʱ������Ҫ�����˺ţ��ز�ط��Ѿ�Ĭ���˺ţ�������Ҫ�����˺�------%

 

%�ز�

% �ڻز�ʱ���ó�ʼ�ʱ�1000000Ԫ

AccountList(1) = {'FutureBackReplay'};

%

% clear all;

tic;

traderRunBacktestV2('BackTest_Pair',@Pair,{entroy_score},AccountList,targetList,'min',1,20140101,20151231,'FWard');

% traderRunBacktest('BackTestTwoLinesO',@TwoLinesO,{len1,len2,shareNum,stoploss,stopprofit,trailinggap},AccountList,targetList,'min',3,20150101,20150131,'FWard');

toc;