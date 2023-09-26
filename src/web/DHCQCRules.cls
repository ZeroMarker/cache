/// 名称: 判断质控规则
/// 描述: 按照设定的质控规则判断
/// 编写者: 戴义
/// 编写日期: 2013-03-01
/// 修改批次的单浓度判断。重新对多浓度批次规则进行整合
/// 把质控规则改为按照cls方法走。DaiYi 2014-09-15
Class web.DHCQCRules Extends %Persistent
{

//d ##class(web.DHCQCRules).QcRules("AC1500||63401||9001||A1130||1^63401^1")

ClassMethod QcRules(RowId) As %String
{
  //Set RowId="AC1500||63346||9001||A1130||1^63346^1"
  Set RowId=$Get(RowId)
  //定义变量
  Set QCRowId=$Piece(RowId,"^",1),QCDate=$Piece(RowId,"^",2),QCOrdId=$Piece(RowId,"^",3)
  Set TCCode=$Piece(QCRowId,"||",4),MachineCode=$Piece(QCRowId,"||",1)
  Set QCId=$Piece(QCRowId,"||",3)
  IF '$Length(QCDate) Quit 0
  If '$Length(QCOrdId) Quit 0
  Set QCData=$Get(^DHCQCIV(QCRowId,QCDate,QCOrdId))
  If '$Length(QCData) Quit 0
  Set QCResult=$Piece($Get(QCData),"^",3)
  Set MatLotLevNoRowId=$Piece($Get(QCData),"^",6)
  //取质控结果的质控物，批号，浓度代码。
  Set MatLotRowId=$PIece(MatLotLevNoRowId,"||",1,2)
  Set MatCode=$PIece(MatLotLevNoRowId,"||",1)
  Set LotCode=$PIece(MatLotLevNoRowId,"||",2)
  Set LevNo=$PIece(MatLotLevNoRowId,"||",3)
  //取出靶值，标准差。DaiYi 2014-06-19 传参数取当前数据的Mean,SD
  Set (MEAN,SD)=""
  s Ret=..QueryMeanSD(MatLotRowId,TCCode,LevNo,QCDate)
  s MEAN=$p($g(Ret),"^",1),SD=$p($g(Ret),"^",2)
  //取质控规则
  Set Ret=..UpdateRule(QCRowId,QCDate,QCOrdId,"","")
  If MEAN="" Quit 0
  If SD="" Quit 0
  If MEAN="0.0000001" Quit 0
  If SD="0.0000001" Quit 0
  Set RuleNumFlag=0
  Set RuleCode="" For  Set RuleCode=$Order(^DHCQCMATRL(MatCode,RuleCode)) Quit:RuleCode=""  Do
  .Set RuleStatus=$E($Piece($Get(^DHCQCMATRL(MatCode,RuleCode)),"^",1),1)
  .//禁止的不参与计算。DaiYi 2013-05-20
  .If RuleStatus="Disable" Quit
  .; check 1-2S rule
  .If RuleCode="A",RuleNumFlag<8  Do
  ..b ;234
  ..If QCResult>(MEAN+(2*SD)) Set Ret=..UpdateRule(QCRowId,QCDate,QCOrdId,RuleCode,RuleStatus),RuleNumFlag=6
  ..If QCResult<(MEAN-(2*SD)) Set Ret=..UpdateRule(QCRowId,QCDate,QCOrdId,RuleCode,RuleStatus),RuleNumFlag=6
  .; check 1-3S rule
  .If RuleCode="B" Do
  ..If QCResult>(MEAN+(3*SD)) Do
  ...Set Ret=..UpdateRule(QCRowId,QCDate,QCOrdId,RuleCode,RuleStatus)
  ...Set RuleNumFlag=10
  ..If QCResult<(MEAN-(3*SD)) Do
  ...Set Ret=..UpdateRule(QCRowId,QCDate,QCOrdId,RuleCode,RuleStatus)
  ...Set RuleNumFlag=10
  .; check 2-2S rule //同时判断两个点
  .If RuleCode="C",RuleNumFlag<7 Do
  ..Set RuleFlag=0
  ..//同时大于2SD情况考虑
  ..//Set Ret=$$sNRule(1,MachineCode,TCCode,QCDate,QCId,QCOrdId,MEAN,SD,2)
  ..If QCResult>(MEAN+(2*SD)) DO
  ...Set Ret=..sNRule(1,MachineCode,TCCode,QCDate,QCId,QCOrdId,MEAN,SD,2,MatLotLevNoRowId)
  ...If Ret=1 Do
  ....Set Ret=..UpdateRule(QCRowId,QCDate,QCOrdId,RuleCode,RuleStatus)
  ....Set RuleNumFlag=9
  ..If QCResult<(MEAN+((-2)*SD)) DO
  ...Set Ret=..sNRule(1,MachineCode,TCCode,QCDate,QCId,QCOrdId,MEAN,SD,-2,MatLotLevNoRowId)
  ...If Ret=1 Do 
  ....Set Ret=..UpdateRule(QCRowId,QCDate,QCOrdId,RuleCode,RuleStatus)
  ....Set RuleNumFlag=9
  .; check 2 of 3S rule //同时判断两个点
  .If RuleCode="D" Do
  .; check 4-1S rule //同时判断连续的4个点
  .If RuleCode="E",RuleNumFlag<8 Do
  ..If (QCResult>(MEAN+(SD))) Do
  ...Set Ret=..sNRule41s(3,MachineCode,TCCode,QCDate,QCId,QCOrdId,MEAN,SD,1,MatLotLevNoRowId)
  ...If Ret>=3 Do
  ....Set Ret=..UpdateRule(QCRowId,QCDate,QCOrdId,RuleCode,RuleStatus)
  ....Set RuleNumFlag=7
  ..If (QCResult<(MEAN+((-1)*SD))) Do
  ...Set Ret=..sNRule41s(3,MachineCode,TCCode,QCDate,QCId,QCOrdId,MEAN,SD,-1,MatLotLevNoRowId)
  ...If Ret>=3  Do
  ....Set Ret=..UpdateRule(QCRowId,QCDate,QCOrdId,RuleCode,RuleStatus)
  ....Set RuleNumFlag=7
  .; check 3-1S rule //同时判断两个点
  .If RuleCode="F" Do
  ..If QCResult>(MEAN+(SD)) Do
  ...Set Ret=..sNRule41s(2,MachineCode,TCCode,QCDate,LevNo,QCOrdId,MEAN,SD,1,MatLotLevNoRowId)
  ...If Ret=4 Set Ret=..UpdateRule(QCRowId,QCDate,QCOrdId,RuleCode,RuleStatus)
  ..If QCResult<(MEAN+((-1)*SD)) Do
  ...Set Ret=..sNRule41s(2,MachineCode,TCCode,QCDate,LevNo,QCOrdId,MEAN,SD,-1,MatLotLevNoRowId)
  ...If Ret=4 Set Ret=..UpdateRule(QCRowId,QCDate,QCOrdId,RuleCode,RuleStatus)
  .; check 10X rule //同时判断10个点
  .If RuleCode="G",RuleNumFlag<7  Do
  ..If QCResult>MEAN Do
  ...Set Ret=..sNRule10x(9,MachineCode,TCCode,QCDate,QCId,QCOrdId,MEAN,SD,1,MatLotLevNoRowId)
  ...If Ret>9 Do
  ....Set Ret=..UpdateRule(QCRowId,QCDate,QCOrdId,RuleCode,RuleStatus)
  ....Set RuleNumFlag=7 
  ..If QCResult<MEAN Do
  ...Set Ret=..sNRule10x(9,MachineCode,TCCode,QCDate,QCId,QCOrdId,MEAN,SD,1,MatLotLevNoRowId)
  ...If Ret>9 Set Ret=..UpdateRule(QCRowId,QCDate,QCOrdId,RuleCode,RuleStatus),RuleNumFlag=7   
  .; check 7X rule //同时判断7个点
  .If RuleCode="H",RuleNumFlag<7  Do
  ..If QCResult>MEAN Do
  ...Set Ret=..sNRule10x(6,MachineCode,TCCode,QCDate,QCId,QCOrdId,MEAN,SD,1,MatLotLevNoRowId)
  ...If Ret>6 Set Ret=..UpdateRule(QCRowId,QCDate,QCOrdId,RuleCode,RuleStatus)
  ..If QCResult<MEAN Do
  ...Set Ret=..sNRule10x(5,MachineCode,TCCode,QCDate,QCId,QCOrdId,MEAN,SD,-1,MatLotLevNoRowId)
  ...If Ret>6 Set Ret=..UpdateRule(QCRowId,QCDate,QCOrdId,RuleCode,RuleStatus)  
  .; check 6X rule //同时判断6个点
  .If RuleCode="I",RuleNumFlag<7  Do
  ..If QCResult>MEAN Do
  ...Set Ret=..sNRule10x(5,MachineCode,TCCode,QCDate,QCId,QCOrdId,MEAN,SD,1,MatLotLevNoRowId)
  ...If Ret>5 Set Ret=..UpdateRule(QCRowId,QCDate,QCOrdId,RuleCode,RuleStatus)
  ..If QCResult<MEAN Do
  ...Set Ret=..sNRule10x(5,MachineCode,TCCode,QCDate,QCId,QCOrdId,MEAN,SD,-1,MatLotLevNoRowId)
  ...If Ret>5 Set Ret=..UpdateRule(QCRowId,QCDate,QCOrdId,RuleCode,RuleStatus)  
  .; check R-4S rule //同时判断两个点
  .If RuleCode="R",RuleNumFlag<10 Do
  ..Set Ret=..sN2Rule(1,MachineCode,TCCode,QCDate,QCId,QCOrdId,MEAN,SD,QCResult,MatLotLevNoRowId)
  ..If Ret=1 Do
  ...Set Ret=..UpdateRule(QCRowId,QCDate,QCOrdId,RuleCode,RuleStatus)
  ...Set RuleNumFlag=8  
  Quit 0
}

/// Creator：      DaiYi
/// CreatDate：    20140619
/// Description:： 查询批次项目的靶值,标准差
/// Table：        QC_MaterialLot
/// Input：        MatLotRowId:批次代码,TCCode:项目代码,LevNo:浓度,QCDate:质控日期
///                
/// Output：       MEAN:标准差，SD：SD
/// Return：       0
/// Others：
ClassMethod QueryMeanSD(MatLotRowId, TCCode, LevNo, QCDate) As %String
{
  //N (MatLotRowId,TCCode,LevNo,QCDate)
  /*
  Set MatLotData=$Get(^DHCQCTC(MatLotRowId,TCCode,LevNo))
  Set XSDFlag=$Piece(MatLotData,"^",12)
  Set MouthXSDFlag=$Piece(MatLotData,"^",13)
  Set (MEAN,SD)=""
  If XSDFlag="Y" Do
  .Set MEAN=$Piece(MatLotData,"^",9),SD=$Piece(MatLotData,"^",10)
  Else  Do
  .Set MEAN=$Piece(MatLotData,"^",6),SD=$Piece(MatLotData,"^",7)
  If MouthXSDFlag="Y" Do
  .Set AccQCDate=$ZD(QCDate,3)
  .Set AccQCDateYear=$Piece(AccQCDate,"-",1),AccQCDateMouth=$Piece(AccQCDate,"-",2)
  .Set AccRowId=MatLotRowId_"||"_TCCode_"||"_LevNo
  .Set AccRet=..QueryAccXSD(AccRowId,AccQCDateYear,AccQCDateMouth)
  .Set MEAN=$Piece(AccRet,"^",1),SD=$Piece(AccRet,"^",2)
  Q MEAN_"^"_SD
  */
  s Ret=##class(web.DHCQCMachineDataView).QuerySetUpXSD(MatLotRowId,TCCode,LevNo,QCDate)
  q Ret
}

/// Creator：      DaiYi
/// CreatDate：    20140619
/// Description:： 返回当前项目的SD值
/// Table：        QC_MaterialLot,DHCQC_itemvalue
/// Input：        MatLotRowId:批次代码,TCCode:项目代码,LevNo:浓度,QCDate:质控日期,QCResult:当前结果
///                
/// Output：       MEAN:标准差，SD：SD
/// Return：       0
/// Others：
ClassMethod QuitSD(MatLotRowId, TCCode, LevNo, QCDate, QCResult) As %String
{
   //n (MatLotRowId,TCCode,LevNo,QCDate,QCResult)
   s Ret=..QueryMeanSD(MatLotRowId,TCCode,LevNo,QCDate)
   s MEAN=$p($g(Ret),"^",1),SD=$p($g(Ret),"^",2)
   s RetSD=0
   i SD>0.00000001 s RetSD=$fn(((QCResult-MEAN)/SD),"",0)
   q RetSD
}

/// Creator：      DaiYi
/// CreatDate：    20130301
/// Description:： 查询数据是否满足相应质控规则。
/// Table：        DHCQC_itemvalue,^DHCQCLOT
/// Input：        Num:查询点数,MachineCode:仪器代码,TCCode:项目代码,QCDate:质控日期,QCOrdId:质控标示
///                MEAN:标准差，SD：SD，RuleNum:SD的数量。
/// Output：       ""
/// Return：       0
/// Others：
ClassMethod sNRule(Num, MachineCode, TCCode, QCDate, QCId, QCOrdId, MEAN, SD, RuleNum, MatLotLevNoRowId) As %String
{
 //New (Num,MachineCode,TCCode,QCDate,QCId,QCOrdId,MEAN,SD,RuleNum,MatLotLevNoRowId )
 Set Num=$Get(Num),MachineCode=$Get(MachineCode),TCCode=$Get(TCCode),QCDate=$Get(QCDate),QCOrdId=$Get(QCOrdId)
 Set MEAN=$Get(MEAN),SD=$Get(SD),RuleNum=$Get(RuleNum),QCId=$Get(QCId)
 Set Ret=0,RetFlag=0
 s CurQCDate=QCDate
 //对于多个点的情况：1.当天的点不判断。2.判断前一天的有效数据。
 If $Data(^DHCQCIVTCi(MachineCode,TCCode,QCDate,QCId,QCOrdId)) Do
 .For  Set QCDate=$Order(^DHCQCIVTCi(MachineCode,TCCode,QCDate),-1) Quit:(RetFlag=Num)||(QCDate="")  Do
 ..Set CurQCId="" For  Set CurQCId=$Order(^DHCQCIVTCi(MachineCode,TCCode,QCDate,CurQCId),-1) Quit:(CurQCId="")  Do
 ...If CurQCId'=QCId Quit      //不属于同一浓度的退出
 ...Set CurLevNo="" For  Set CurLevNo=$Order(^DHCQCIVTCi(MachineCode,TCCode,QCDate,CurQCId,CurLevNo),-1) Quit:CurLevNo=""  Do
 ....//同浓度 ^DHCQCIVTCi("AC1500","A1130",63247,9001,1,"AC1500||63247||9001||A1130||1",63247,1)
 ....If RetFlag=Num Quit
 ....Set CurOrdId="" For  Set CurOrdId=$Order(^DHCQCIVTCi(MachineCode,TCCode,QCDate,CurQCId,CurLevNo,CurOrdId),-1) Quit:CurOrdId=""  Do
 .....If RetFlag=Num Quit 
 .....Set RetData=$Get(^DHCQCIV(CurOrdId,QCDate,CurLevNo))
 .....Set TestRemoveData=$Piece($Get(RetData),"^",12)
 .....If TestRemoveData=2 Quit
 .....//非同一批次，不参与计算
 .....If MatLotLevNoRowId'=$Piece(RetData,"^",6) Quit
 .....Set QcResult=$Piece(RetData,"^",3)
 .....If RuleNum>0 Do
 ......If QcResult>(MEAN+(RuleNum*SD)) Set Ret=Ret+1
 .....If RuleNum<0 Do
 ......If QcResult<(MEAN+(RuleNum*SD)) Set Ret=Ret+1
 .....Set RetFlag=RetFlag+1
 //对于2SD,还需要找当天其他浓度的结果进行判断
 s QCDate=CurQCDate,RetFlag=0
 i (Ret=0),$d(^DHCQCIVTCi(MachineCode,TCCode,QCDate)) d
 .Set CurQCId="" For  Set CurQCId=$Order(^DHCQCIVTCi(MachineCode,TCCode,QCDate,CurQCId),-1) Quit:(CurQCId="")  Do
 ..If CurQCId=QCId Quit      //不属于同一浓度的退出
 ..Set CurLevNo="" For  Set CurLevNo=$Order(^DHCQCIVTCi(MachineCode,TCCode,QCDate,CurQCId,CurLevNo),-1) Quit:CurLevNo=""  Do
 ...//同浓度 ^DHCQCIVTCi("AC1500","A1130",63247,9001,1,"AC1500||63247||9001||A1130||1",63247,1)
 ...If RetFlag=Num Quit
 ...Set CurOrdId="" For  Set CurOrdId=$Order(^DHCQCIVTCi(MachineCode,TCCode,QCDate,CurQCId,CurLevNo,CurOrdId),-1) Quit:CurOrdId=""  Do
 ....If RetFlag=Num Quit 
 ....Set RetData=$Get(^DHCQCIV(CurOrdId,QCDate,CurLevNo))
 ....Set TestRemoveData=$Piece($Get(RetData),"^",12)
 ....If TestRemoveData=2 Quit
 ....//非同一批次，不参与计算
 ....If $p(MatLotLevNoRowId,"||",1,2)'=$p($Piece(RetData,"^",6),"||",1,2) Quit
 ....Set QcResult=$Piece(RetData,"^",3)
 ....s RetMean=..QueryMeanSD($p($Piece(RetData,"^",6),"||",1,2),TCCode,$p($Piece(RetData,"^",6),"||",3),QCDate)
 ....s MEAN=$p($g(RetMean),"^",1),SD=$p($g(RetMean),"^",2)
 ....If RuleNum>0 Do
 .....If QcResult>(MEAN+(RuleNum*SD)) Set Ret=Ret+1
 ....If RuleNum<0 Do
 .....If QcResult<(MEAN+(RuleNum*SD)) Set Ret=Ret+1
 ....Set RetFlag=RetFlag+1
 Quit Ret
}

/// Creator：      DaiYi
/// CreatDate：    20130301
/// Description:： 查询数据是否满足4-1s规则
///                判断这个规则，必须有一个点超过2SD。如果不满足条件，就退出。修改于2015-03-29
/// Table：        DHCQC_itemvalue,^DHCQCLOT
/// Input：        Num:查询点数,MachineCode:仪器代码,TCCode:项目代码,QCDate:质控日期,QCOrdId:质控标示
///                MEAN:标准差，SD：SD，RuleNum:SD的数量。
/// Output：       ""
/// Return：       0
/// Others：
ClassMethod sNRule41s(Num, MachineCode, TCCode, QCDate, QCId, QCOrdId, MEAN, SD, RuleNum, MatLotLevNoRowId) As %String
{
 //New (Num,MachineCode,TCCode,QCDate,QCId,QCOrdId,MEAN,SD,RuleNum,MatLotLevNoRowId)
 Set Num=$Get(Num),MachineCode=$Get(MachineCode),TCCode=$Get(TCCode),QCDate=$Get(QCDate),QCOrdId=$Get(QCOrdId)
 Set MEAN=$Get(MEAN),SD=$Get(SD),RuleNum=$Get(RuleNum),QCId=$Get(QCId)
 Set Ret=0,RetFlag=0,RetFlag2=0
 s CurQCDate=QCDate
 //对于多个点的情况：1.当天的点不判断。2.判断前一天的有效数据。
 If $Data(^DHCQCIVTCi(MachineCode,TCCode,QCDate,QCId,QCOrdId)) Do
 .For  Set QCDate=$Order(^DHCQCIVTCi(MachineCode,TCCode,QCDate),-1) Quit:(RetFlag=Num)||(QCDate="")  Do
 ..Set CurQCId="" For  Set CurQCId=$Order(^DHCQCIVTCi(MachineCode,TCCode,QCDate,CurQCId)) Quit:(CurQCId="")  Do
 ...If CurQCId'=QCId Quit      //不属于同一浓度的退出
 ...Set CurLevNo="" For  Set CurLevNo=$Order(^DHCQCIVTCi(MachineCode,TCCode,QCDate,CurQCId,CurLevNo)) Quit:CurLevNo=""  Do
 ....//同浓度 ^DHCQCIVTCi("AC1500","A1130",63247,9001,1,"AC1500||63247||9001||A1130||1",63247,1)
 ....If RetFlag=Num Quit
 ....Set CurOrdId="" For  Set CurOrdId=$Order(^DHCQCIVTCi(MachineCode,TCCode,QCDate,CurQCId,CurLevNo,CurOrdId)) Quit:CurOrdId=""  Do
 .....If RetFlag=Num Quit 
 .....Set RetData=$Get(^DHCQCIV(CurOrdId,QCDate,CurLevNo))
 .....Set TestRemoveData=$Piece($Get(RetData),"^",12)
 .....If TestRemoveData=2 Quit
 .....b ;9999
 .....//非同一批次，不参与计算
 .....If MatLotLevNoRowId'=$Piece(RetData,"^",6) Quit
 .....Set QcResult=$Piece(RetData,"^",3)
 .....If RuleNum>0 Do
 ......If (QcResult>=(MEAN+(RuleNum*SD))) Set Ret=Ret+1
 ......//判断是否有大于2SD的点做记录 2015-03-29
 ......i (QcResult>(MEAN+(2*SD))) s RetFlag2=1
 .....If RuleNum<0 Do
 ......If (QcResult<=(MEAN+(RuleNum*SD))),(QcResult>(MEAN+((-2)*SD))) Set Ret=Ret+1
 ......//判断是否有大于2SD的点做记录 2015-03-29
 ......i (QcResult<(MEAN+(-2*SD))) s RetFlag2=1
 .....Set RetFlag=RetFlag+1
 //对于2SD,还需要找当天其他浓度的结果进行判断
 s QCDate=CurQCDate,RetFlag=0
 i (Ret<3),$d(^DHCQCIVTCi(MachineCode,TCCode,QCDate)) d
 .//不用批次的，需要找4个点，并且得从当前的日期往下找项目
 .s Ret=0,QCDate=QCDate+1,Num=3
 .f  s QCDate=$o(^DHCQCIVTCi(MachineCode,TCCode,QCDate),-1) q:QCDate=""  d
 ..Set CurQCId="" For  Set CurQCId=$Order(^DHCQCIVTCi(MachineCode,TCCode,QCDate,CurQCId)) Quit:(CurQCId="")  Do
 ...Set CurLevNo="" For  Set CurLevNo=$Order(^DHCQCIVTCi(MachineCode,TCCode,QCDate,CurQCId,CurLevNo)) Quit:CurLevNo=""  Do
 ....If RetFlag=Num Quit
 ....Set CurOrdId="" For  Set CurOrdId=$Order(^DHCQCIVTCi(MachineCode,TCCode,QCDate,CurQCId,CurLevNo,CurOrdId)) Quit:CurOrdId=""  Do
 .....If RetFlag=Num Quit 
 .....Set RetData=$Get(^DHCQCIV(CurOrdId,QCDate,CurLevNo))
 .....Set TestRemoveData=$Piece($Get(RetData),"^",12)
 .....If TestRemoveData=2 Quit
 .....//非同一批次，不参与计算
 .....If $p(MatLotLevNoRowId,"||",1,2)'=$p($Piece(RetData,"^",6),"||",1,2) Quit
 .....Set QcResult=$Piece(RetData,"^",3)
 .....s RetMean=..QueryMeanSD($p($Piece(RetData,"^",6),"||",1,2),TCCode,$p($Piece(RetData,"^",6),"||",3),QCDate)
 .....s MEAN=$p($g(RetMean),"^",1),SD=$p($g(RetMean),"^",2)
 .....If RuleNum>0 Do
 ......If (QcResult>=(MEAN+(RuleNum*SD))) Set Ret=Ret+1
 ......//判断是否有大于2SD的点做记录 2015-03-29
 ......i (QcResult>(MEAN+(2*SD))) s RetFlag2=1
 .....If RuleNum<0 Do
 ......If (QcResult<=(MEAN+(RuleNum*SD))),(QcResult>(MEAN+((-2)*SD))) Set Ret=Ret+1
 ......//判断是否有大于2SD的点做记录 2015-03-29
 ......i (QcResult<(MEAN+(-2*SD))) s RetFlag2=1
 .....Set RetFlag=RetFlag+1
 i (Ret>0) d
 .i RetFlag2<1 s Ret=0 
 Quit Ret
}

/// Creator：      DaiYi
/// CreatDate：    20130301
/// Description:： 查询数据是否满足10x规则
/// Table：        DHCQC_itemvalue,^DHCQCLOT
/// Input：        Num:查询点数,MachineCode:仪器代码,TCCode:项目代码,QCDate:质控日期,QCOrdId:质控标示
///                MEAN:标准差，SD：SD，RuleNum:SD的数量。
/// Output：       ""
/// Return：       0
/// Others：
ClassMethod sNRule10x(Num, MachineCode, TCCode, QCDate, QCId, QCOrdId, MEAN, SD, RuleNum, MatLotLevNoRowId) As %String
{
 //New (Num,MachineCode,TCCode,QCDate,QCId,QCOrdId,MEAN,SD,RuleNum,MatLotLevNoRowId )
 Set Num=$Get(Num),MachineCode=$Get(MachineCode),TCCode=$Get(TCCode),QCDate=$Get(QCDate),QCOrdId=$Get(QCOrdId)
 Set MEAN=$Get(MEAN),SD=$Get(SD),RuleNum=$Get(RuleNum),QCId=$Get(QCId),MatLotLevNoRowId=$g(MatLotLevNoRowId)
 Set Ret=0,RetFlag=0
 s CurQCDate=QCDate
 //对于多个点的情况：1.当天的点不判断。2.判断前一天的有效数据。
 If $Data(^DHCQCIVTCi(MachineCode,TCCode,QCDate,QCId,QCOrdId)) Do
 .For  Set QCDate=$Order(^DHCQCIVTCi(MachineCode,TCCode,QCDate),-1) Quit:(RetFlag=Num)||(QCDate="")  Do
 ..Set CurQCId="" For  Set CurQCId=$Order(^DHCQCIVTCi(MachineCode,TCCode,QCDate,CurQCId)) Quit:(CurQCId="")  Do
 ...If CurQCId'=QCId Quit      //不属于同一浓度的退出
 ...Set CurLevNo="" For  Set CurLevNo=$Order(^DHCQCIVTCi(MachineCode,TCCode,QCDate,CurQCId,CurLevNo)) Quit:CurLevNo=""  Do
 ....//同浓度 ^DHCQCIVTCi("AC1500","A1130",63247,9001,1,"AC1500||63247||9001||A1130||1",63247,1)
 ....If RetFlag=Num Quit
 ....Set CurOrdId="" For  Set CurOrdId=$Order(^DHCQCIVTCi(MachineCode,TCCode,QCDate,CurQCId,CurLevNo,CurOrdId)) Quit:CurOrdId=""  Do
 .....If RetFlag=Num Quit 
 .....Set RetData=$Get(^DHCQCIV(CurOrdId,QCDate,CurLevNo))
 .....Set TestRemoveData=$Piece($Get(RetData),"^",12)
 .....If TestRemoveData=2 Quit
 .....//非同一批次，不参与计算
 .....b ;0981
 .....If MatLotLevNoRowId'=$Piece(RetData,"^",6) Quit
 .....Set QcResult=$Piece(RetData,"^",3)
 .....If RuleNum>0 Do
 ......If (QcResult>=(MEAN+(RuleNum*SD))) Set Ret=Ret+1
 .....If RuleNum<0 Do
 ......If (QcResult<=(MEAN+(RuleNum*SD))) Set Ret=Ret+1
 .....Set RetFlag=RetFlag+1
 //对于2SD,还需要找当天其他浓度的结果进行判断
 s QCDate=CurQCDate,RetFlag=0
 i (Ret<Num),$d(^DHCQCIVTCi(MachineCode,TCCode,QCDate)) d
 .//不用批次的，需要找9个点，并且得从当前的日期往下找项目
 .s Ret=0,QCDate=QCDate+1,Num=Num+1
 .f  s QCDate=$o(^DHCQCIVTCi(MachineCode,TCCode,QCDate),-1) q:QCDate=""  d
 ..Set CurQCId="" For  Set CurQCId=$Order(^DHCQCIVTCi(MachineCode,TCCode,QCDate,CurQCId)) Quit:(CurQCId="")  Do
 ...Set CurLevNo="" For  Set CurLevNo=$Order(^DHCQCIVTCi(MachineCode,TCCode,QCDate,CurQCId,CurLevNo)) Quit:CurLevNo=""  Do
 ....If RetFlag=Num Quit
 ....Set CurOrdId="" For  Set CurOrdId=$Order(^DHCQCIVTCi(MachineCode,TCCode,QCDate,CurQCId,CurLevNo,CurOrdId)) Quit:CurOrdId=""  Do
 .....If RetFlag=Num Quit 
 .....Set RetData=$Get(^DHCQCIV(CurOrdId,QCDate,CurLevNo))
 .....Set TestRemoveData=$Piece($Get(RetData),"^",12)
 .....If TestRemoveData=2 Quit
 .....//非同一批次，不参与计算
 .....If $p(MatLotLevNoRowId,"||",1,2)'=$p($Piece(RetData,"^",6),"||",1,2) Quit
 .....Set QcResult=$Piece(RetData,"^",3)
 .....s RetMean=..QueryMeanSD($p($Piece(RetData,"^",6),"||",1,2),TCCode,$p($Piece(RetData,"^",6),"||",3),QCDate)
 .....s MEAN=$p($g(RetMean),"^",1),SD=$p($g(RetMean),"^",2)
 .....If RuleNum>0 Do
 ......If (QcResult>=(MEAN)) d 
 .......Set Ret=Ret+1 
 .....If RuleNum<0 Do
 ......If (QcResult<=(MEAN)) Set Ret=Ret+1
 .....Set RetFlag=RetFlag+1
 Quit Ret
}

/// Creator：      DaiYi
/// CreatDate：    20130301
/// Description:： 更新质控规则
/// Table：        DHCQC_itemvalue,^DHCQCLOT
/// Input：        QCRowId:RowId,QCDate:质控日期,QCOrdId：序号,RuleCode：质控规则,RuleStatus：质控状态
/// Output：       ""
/// Return：       0
/// Others： 
ClassMethod QueryAccXSD(RowId, QCYear, QCMouth) As %String
{
    //New (RowId, QCYear, QCMouth)
	Set RowId=$Get(RowId),QCYear=$Get(QCYear),QCMouth=$Get(QCMouth)
	Set AccRet="^^"
	Set CurQCYear=QCYear,CurQCMouth=""
	//使用上一个月的靶值,标准差
	If QCMouth=1 Do
	.Set CurQCMouth=12,CurQCYear=CurQCYear-1
	Else  Do
	.Set CurQCMouth=QCMouth-1,CurQCYear=QCYear
	If $Data(^DHCQCAT(RowId,CurQCYear,CurQCMouth)) Do
	.Set StrAccData=$Get(^DHCQCAT(RowId,CurQCYear,CurQCMouth))
	.Set AccRet=$Piece(StrAccData,"^",4)_"^"_$Piece(StrAccData,"^",5)
	Else  Do
	.Set StrAccData=$Get(^DHCQCAT(RowId,QCYear,QCMouth))
	.Set AccRet=$Piece(StrAccData,"^",4)_"^"_$Piece(StrAccData,"^",5)
	Quit AccRet
}

/// Creator：      DaiYi
/// CreatDate：    20130301
/// Description:： 查询连续的点是否满足相应质控规则。
/// Table：        DHCQC_itemvalue,^DHCQCLOT
/// Input：        Num:查询点数,MachineCode:仪器代码,TCCode:项目代码,QCDate:质控日期,QCOrdId:质控标示
///                MEAN:标准差，PointFlag:是在标准差的上方
/// Output：       ""
/// Return：       0
/// Others：
ClassMethod sNGRule(Num, MachineCode, TCCode, QCDate, LevNo, QCOrdId, MEAN, PointFlag) As %String
{
 //New (Num,MachineCode,TCCode,QCDate,LevNo,QCOrdId,MEAN,PointFlag,MatLotLevNoRowId)
 Set Num=$Get(Num),MachineCode=$Get(MachineCode),TCCode=$Get(TCCode),QCDate=$Get(QCDate),QCOrdId=$Get(QCOrdId)
 Set MEAN=$Get(MEAN),PointFlag=$Get(PointFlag),RetFlag=0,LevNo=$Get(LevNo)
 Set Ret=0
 Set QCDate=QCDate+1
 If PointFlag=1 Do
 .For  Set QCDate=$Order(^DHCQCIVTCi(MachineCode,TCCode,QCDate),-1) Quit:(RetFlag>Num)||(QCDate="")  Do
 ..Set CurQCId="" For  Set CurQCId=$Order(^DHCQCIVTCi(MachineCode,TCCode,QCDate,CurQCId),-1) Quit:(CurQCId="")  Do
 ...If CurQCId'=LevNo Quit
 ...Set CurLevNo=QCOrdId For  Set CurLevNo=$Order(^DHCQCIVTCi(MachineCode,TCCode,QCDate,CurQCId,CurLevNo),-1) Quit:CurLevNo=""  Do
 ....If RetFlag>Num Quit
 ....Set CurOrdId="" For  Set CurOrdId=$Order(^DHCQCIVTCi(MachineCode,TCCode,QCDate,CurQCId,CurLevNo,CurOrdId),-1) Quit:CurOrdId=""  Do
 .....If RetFlag>Num Quit 
 .....Set CurRowId="" For  Set CurRowId=$Order(^DHCQCIVTCi(MachineCode,TCCode,QCDate,CurQCId,CurLevNo,CurOrdId,CurRowId),-1) Quit:CurRowId=""  Do
 ......If RetFlag>Num Quit
 ......Set RetData=$Get(^DHCQCIV(CurOrdId,QCDate,CurLevNo))
 ......Set TestRemoveData=$Piece($Get(RetData),"^",12)
 ......If TestRemoveData=2 Quit
 ......//非同一批次，不参与计算
 ......If MatLotLevNoRowId'=$Piece(TestRemoveData,"^",6) Quit
 ......Set QcResult=$Piece(RetData,"^",3)
 ......If (QcResult>MEAN) Set Ret=Ret+1
 ......Set RetFlag=RetFlag+1
 Else  Do
 .For  Set QCDate=$Order(^DHCQCIVTCi(MachineCode,TCCode,QCDate),-1) Quit:(RetFlag>Num)||(QCDate="")  Do
 ..Set CurQCId="" For  Set CurQCId=$Order(^DHCQCIVTCi(MachineCode,TCCode,QCDate,CurQCId),-1) Quit:(CurQCId="")  Do
 ...If CurQCId'=LevNo Quit
 ...Set CurLevNo="" 
 ...For  Set CurLevNo=$Order(^DHCQCIVTCi(MachineCode,TCCode,QCDate,CurQCId,CurLevNo),-1) Quit:CurLevNo=""  Do
 ....If RetFlag>Num Quit
 ....Set CurOrdId="" For  Set CurOrdId=$Order(^DHCQCIVTCi(MachineCode,TCCode,QCDate,CurQCId,CurLevNo,CurOrdId),-1) Quit:CurOrdId=""  Do
 .....If RetFlag>Num Quit 
 .....Set CurRowId="" For  Set CurRowId=$Order(^DHCQCIVTCi(MachineCode,TCCode,QCDate,CurQCId,CurLevNo,CurOrdId,CurRowId),-1) Quit:CurRowId=""  Do
 ......If RetFlag>Num Quit
 ......Set RetData=$Get(^DHCQCIV(CurOrdId,QCDate,CurLevNo))
 ......Set TestRemoveData=$Piece($Get(RetData),"^",12)
 ......If TestRemoveData=2 Quit
 ......//非同一批次，不参与计算
 ......If MatLotLevNoRowId'=$Piece(TestRemoveData,"^",6) Quit
 ......Set QcResult=$Piece(RetData,"^",3)
 ......If (QcResult<MEAN) Set Ret=Ret+1
 ......Set RetFlag=RetFlag+1
 Quit Ret
}

/// Creator：      DaiYi
/// CreatDate：    20130301
/// Description:： 更新质控规则
/// Table：        DHCQC_itemvalue,^DHCQCLOT
/// Input：        QCRowId:RowId,QCDate:质控日期,QCOrdId：序号,RuleCode：质控规则,RuleStatus：质控状态
/// Output：       ""
/// Return：       0
/// Others： 
ClassMethod UpdateRule(QCRowId, QCDate, QCOrdId, RuleCode, RuleStatus) As %String
{
  //New (QCRowId,QCDate,QCOrdId,RuleCode,RuleStatus)
  Set QCRowId=$Get(QCRowId),QCDate=$Get(QCDate),QCOrdId=$Get(QCOrdId),RuleCode=$Get(RuleCode),RuleStatus=$Get(RuleStatus)
  Set $Piece(^DHCQCIV(QCRowId,QCDate,QCOrdId),"^",15)=RuleCode
  Set $Piece(^DHCQCIV(QCRowId,QCDate,QCOrdId),"^",16)=RuleStatus
  Quit 1
}

/// Creator：      DaiYi
/// CreatDate：    20130301
/// Description:： 判断两个点是否超过4SD。是根据同一天的点判断
/// Table：        DHCQC_itemvalue,^DHCQCLOT
/// Input：        Num:查询点数,MachineCode:仪器代码,TCCode:项目代码,QCDate:质控日期,QCOrdId:质控标示
///                MEAN:标准差，SD：SD，Result:当前结果。
/// Output：       ""
/// Return：       0
/// Others：
ClassMethod sN2Rule(Num, MachineCode, TCCode, QCDate, QCId, QCOrdId, MEAN, SD, Result, MatLotLevNoRowId) As %String
{
 //New (Num,MachineCode,TCCode,QCDate,QCId,QCOrdId,MEAN,SD,Result,MatLotLevNoRowId )
 Set Num=$Get(Num),MachineCode=$Get(MachineCode),TCCode=$Get(TCCode),QCDate=$Get(QCDate),QCOrdId=$Get(QCOrdId)
 Set MEAN=$Get(MEAN),SD=$Get(SD),Result=$Get(Result),QCId=$Get(QCId)
 Set Ret=0,RetFlag=0
 //判断实际点的SD值
 s OldSD=$fn(((Result-MEAN)/SD),"",2)
 //对于多个点的情况：1.只判断当天的点
 If $Data(^DHCQCIVTCi(MachineCode,TCCode,QCDate,QCId,QCOrdId)) Do
 .//Set QCDate=$Order(^DHCQCIVTCi(MachineCode,TCCode,QCDate),-1)
 .Set CurQCId="" For  Set CurQCId=$Order(^DHCQCIVTCi(MachineCode,TCCode,QCDate,CurQCId),-1) Quit:CurQCId=""  Do
 ..If CurQCId'=QCId Quit
 ..Set CurLevNo="" For  Set CurLevNo=$Order(^DHCQCIVTCi(MachineCode,TCCode,QCDate,CurQCId,CurLevNo),-1) Quit:CurLevNo=""  Do
 ...//同浓度
 ...Set CurOrdId="" For  Set CurOrdId=$Order(^DHCQCIVTCi(MachineCode,TCCode,QCDate,CurQCId,CurLevNo,CurOrdId),-1) Quit:CurOrdId=""  Do
 ....If RetFlag=Num Quit 
 ....Set CurRowId="" For  Set CurRowId=$Order(^DHCQCIVTCi(MachineCode,TCCode,QCDate,CurQCId,CurLevNo,CurOrdId,CurRowId),-1) Quit:CurRowId=""  Do
 .....If RetFlag=Num Quit
 .....Set RetData=$Get(^DHCQCIV(CurOrdId,QCDate,CurLevNo))
 .....Set TestRemoveData=$Piece($Get(RetData),"^",12)
 .....If TestRemoveData=2 Quit
 .....//非同一批次，不参与计算
 .....If $p(MatLotLevNoRowId,"||",1,2)'=$p($Piece(RetData,"^",6),"||",1,2) Quit
 .....//临时取X,SD
 .....s RetMean=..QueryMeanSD($p($Piece(RetData,"^",6),"||",1,2),TCCode,$p($Piece(RetData,"^",6),"||",3),QCDate)
 .....Set QcResult=$Piece(RetData,"^",3)
 .....s CurMEAN=$p(RetMean,"^",1),CurSD=$p(RetMean,"^",2)
 .....s CurCalSD=$fn(((QcResult-CurMEAN)/CurSD),"",2)
 .....i (OldSD-CurCalSD)>4  Set Ret=1
 .....i (OldSD-CurCalSD)<-4  Set Ret=1
 .....Set RetFlag=RetFlag+1
 Quit Ret
}

Storage Default
{
<Data name="DHCQCRulesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCQCRulesD</DataLocation>
<DefaultData>DHCQCRulesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCQCRulesD</IdLocation>
<IndexLocation>^web.DHCQCRulesI</IndexLocation>
<StreamLocation>^web.DHCQCRulesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
