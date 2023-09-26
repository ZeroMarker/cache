/// modified BY ZY0279 20210907  全新调整
/// add BY ZY0247 20201222
Class web.DHCEQ.BA.BUSUseRecordStat Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// modified by ZY0296 golable节点增加
/// 每月定期统计使用记录
/// 入参：MonthStr："YYYY-MM"
///       vSourceType：1:设备  2，设备项
///       vSourceID：设备ID  设备项ID
/// d ##Class(web.DHCEQ.BA.BUSUseRecordStat).GatherUseRecordStat("2020-07",1,1)
ClassMethod GatherUseRecordStat(MonthStr, vSourceType As %String = "", vSourceID As %String = "")
{
	new Year,Month,StartDate,EndDate,SourceType,SourceID
	new WorkLoadNum,TotalFee,URRowID,TWorkLoadNum,TTotalFee,TCancelDate
	new TempDate,tmpWorkLoadNum,tmpTotalFee,CheckNumPerItem,CheckPersonPerItem,ExposureNumPerItem
	new flag,Result,UseLocDR,valList,tmpDataList,Node
	new RequestDeptDR,DoctorID,Operator,ReportDoctorDR,CheckPart,AdmissionType
	new AddFlag,tmpExposureTime
	q:MonthStr="" ""
	s Year=$p(MonthStr,"-",1)
	s Month=$p(MonthStr,"-",2)
	s MStartDate=$ZDATEH(##Class(web.DHCEQReport).GetReportDate(MonthStr,"1","4"),4)
	s MEndDate=$ZDATEH(##Class(web.DHCEQReport).GetReportDate(MonthStr,"2","4"),4)
	s StartDate=MStartDate-1
	f  s StartDate=$o(^DHCEQUseRecord(0,"UseDate",StartDate))  q:(StartDate="")||(StartDate>MEndDate)  d
	.s SourceType=0
	.f  s SourceType=$o(^DHCEQUseRecord(0,"UseDate",StartDate,SourceType))  q:(SourceType="")  d
	..q:(vSourceType'="")&&(vSourceType'=SourceType)
	..s SourceID=0
	..f  s SourceID=$o(^DHCEQUseRecord(0,"UseDate",StartDate,SourceType,SourceID))  q:(SourceID="")  d
	...q:(vSourceID'="")&&(vSourceID'=SourceID)
	...s (WorkLoadNum,TotalFee)=0
	...s URRowID=0
	...f  s URRowID=$o(^DHCEQUseRecord(0,"UseDate",StartDate,SourceType,SourceID,URRowID))  q:URRowID=""  d
	....s DataList=$g(^DHCEQUseRecord(URRowID))
	....q:$p(DataList,"^",20)="Y"
	....q:$p(DataList,"^",19)<2
	....q:$p(DataList,"^",9)=""
	....s AddFlag=1
	....d SumUseRecordInfo
	
	;取消记录登记		//Modify DJ 2015-09-29 DJ0169 begin
	s StartDate=MStartDate-1
	f  s StartDate=$o(^DHCEQUseRecord(0,"CancelDate",StartDate))	q:(StartDate="")||(StartDate>MEndDate)  d
	.s URRowID=0
	.f  s URRowID=$o(^DHCEQUseRecord(0,"CancelDate",StartDate,URRowID))  q:URRowID=""  d
	..s DataList=$g(^DHCEQUseRecord(URRowID))
	..q:$p(DataList,"^",20)="Y"
	..q:$p(DataList,"^",19)<2
	..q:$p(DataList,"^",9)=""
	..s SourceType=$p(DataList,"^",1)
	..s SourceID=$p(DataList,"^",2)
	..s AddFlag=-1
	..d SumUseRecordInfo
	
	s (flag,Result)=0
	s SourceType=0
	f  s SourceType=$o(^DHCEQUseRecordStat("Temp",SourceType)) q:(SourceType="")||(flag'=0)  d
	.s SourceID=0
	.f  s SourceID=$o(^DHCEQUseRecordStat("Temp",SourceType,SourceID)) q:(SourceID="")||(flag'=0)  d
	..s ServiceItemID=0
	..f  s ServiceItemID=$o(^DHCEQUseRecordStat("Temp",SourceType,SourceID,ServiceItemID)) q:(ServiceItemID="")||(flag'=0)  d
	...s FirstFlag=0
	...s UseLocID=0
	...f  s UseLocID=$o(^DHCEQUseRecordStat("Temp",SourceType,SourceID,ServiceItemID,UseLocID)) q:(UseLocID="")||(flag'=0)  d
	....s Price=""
	....f  s Price=$o(^DHCEQUseRecordStat("Temp",SourceType,SourceID,ServiceItemID,UseLocID,Price)) q:(Price="")||(flag'=0)  d
	.....s WorkLoadUnitID=""
	.....f  s WorkLoadUnitID=$o(^DHCEQUseRecordStat("Temp",SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID)) q:(WorkLoadUnitID="")||(flag'=0)  d
	......s RequestDeptDR=""
	......f  s RequestDeptDR=$o(^DHCEQUseRecordStat("Temp",SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,RequestDeptDR)) q:(RequestDeptDR="")||(flag'=0)  d
	.......s DoctorID=""
	.......f  s DoctorID=$o(^DHCEQUseRecordStat("Temp",SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,RequestDeptDR,DoctorID)) q:(DoctorID="")||(flag'=0)  d
	........s Operator=""
	........f  s Operator=$o(^DHCEQUseRecordStat("Temp",SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,RequestDeptDR,DoctorID,Operator)) q:(Operator="")||(flag'=0)  d
	.........s ReportDoctorDR=""
	.........f  s ReportDoctorDR=$o(^DHCEQUseRecordStat("Temp",SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,RequestDeptDR,DoctorID,Operator,ReportDoctorDR)) q:(ReportDoctorDR="")||(flag'=0)  d
	..........s CheckPart=""
	..........f  s CheckPart=$o(^DHCEQUseRecordStat("Temp",SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,RequestDeptDR,DoctorID,Operator,ReportDoctorDR,CheckPart)) q:(CheckPart="")||(flag'=0)  d
	...........s FirstFlag=0
	...........s AdmissionType=""
	...........f  s AdmissionType=$o(^DHCEQUseRecordStat("Temp",SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,RequestDeptDR,DoctorID,Operator,ReportDoctorDR,CheckPart,AdmissionType)) q:(AdmissionType="")||(flag'=0)  d
	............
	............s FirstFlag=FirstFlag+1
	............s TempURSDate=$g(^DHCEQUseRecordStat("Temp",SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,RequestDeptDR,DoctorID,Operator,ReportDoctorDR,CheckPart,AdmissionType))
	............
	............s CheckQty=0
	............s PersonTime=0
	............s ExposureTime=0
	............;i FirstFlag=1  d			//Add By DJ 2015-09-29 DJ0169 //modified by wy 2021-10-22 WY0097 汇总生成月使用记录的程序逻辑调整
	............s CheckQty=+$g(^TempDHCEQ("UseRecordStat.JCLEQ",$J,SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,RequestDeptDR,DoctorID,Operator,ReportDoctorDR,CheckPart,AdmissionType))
	............s PersonTime=+$g(^TempDHCEQ("UseRecordStat.JCRCEQ",$J,SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,RequestDeptDR,DoctorID,Operator,ReportDoctorDR,CheckPart,AdmissionType))
	............s ExposureTime=+$g(^TempDHCEQ("UseRecordStat.BGCSEQ",$J,SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,RequestDeptDR,DoctorID,Operator,ReportDoctorDR,CheckPart,AdmissionType))
	............s objUseRecordStat=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	............d objUseRecordStat.%Set("URSRowID","")
	............d objUseRecordStat.%Set("URSSourceType",SourceType)
	............d objUseRecordStat.%Set("URSSourceID",SourceID)
	............d objUseRecordStat.%Set("URSYear",Year)
	............d objUseRecordStat.%Set("URSMonth",Month)
	............d objUseRecordStat.%Set("URSUseLocDR",UseLocID)
	............d objUseRecordStat.%Set("URSServiceItemDR",ServiceItemID)
	............d objUseRecordStat.%Set("URSInCome",+$p(TempURSDate,"^",2))
	............d objUseRecordStat.%Set("URSWorkLoadNum",+$p(TempURSDate,"^",1))
	............i WorkLoadUnitID>0 d objUseRecordStat.%Set("URSWorkLoadUnitDR",WorkLoadUnitID)
	............d objUseRecordStat.%Set("URSPrice",Price)
	............d objUseRecordStat.%Set("URSRemark","")
	............d objUseRecordStat.%Set("URSCheckNumPerItem",+$p(TempURSDate,"^",4))
	............d objUseRecordStat.%Set("URSCheckNum",CheckQty)
	............d objUseRecordStat.%Set("URSCheckPersonPerItem",+$p(TempURSDate,"^",5))
	............d objUseRecordStat.%Set("URSCheckPerson",PersonTime)
	............d objUseRecordStat.%Set("URSExposureNumPerItem",+$p(TempURSDate,"^",3))
	............d objUseRecordStat.%Set("URSExposureNum",ExposureTime)
	............i AdmissionType'="" d objUseRecordStat.%Set("URSAdmissionType",AdmissionType)
	............d objUseRecordStat.%Set("URSWaitTimeTotal",+$p(TempURSDate,"^",6))
	............d objUseRecordStat.%Set("URSCheckPart","")
	............i CheckPart>0  d objUseRecordStat.%Set("URSCheckPart",CheckPart)
	............d objUseRecordStat.%Set("URSDoctorID","")
	............i DoctorID>0 d objUseRecordStat.%Set("URSDoctorID",DoctorID)
	............d objUseRecordStat.%Set("URSRequestDeptDR","")
	............i RequestDeptDR>0 d objUseRecordStat.%Set("URSRequestDeptDR",RequestDeptDR)
	............d objUseRecordStat.%Set("URSPositiveFlag",+$p(TempURSDate,"^",7))
	............d objUseRecordStat.%Set("URSOperator","")
	............i Operator>0 d objUseRecordStat.%Set("URSOperator",Operator)
	............d objUseRecordStat.%Set("URSReportDoctorDR","")
	............i ReportDoctorDR>0 d objUseRecordStat.%Set("URSReportDoctorDR",ReportDoctorDR)
	............d objUseRecordStat.%Set("URSTWorkLoadNum",+$p(TempURSDate,"^",8))
	............s Result=##Class(web.DHCEQ.BA.BUSUseRecordStat).SaveUseRecordStat(objUseRecordStat)
	............i Result'>0 d
	.............s flag=1
	.............s ^DHCEQUseRecordStat("Gather","Result","Error",SourceType,SourceID,MonthStr)=Result
	............e  d
	.............q:$O(^DHCEQUseConsumableStat("Temp",SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,RequestDeptDR,DoctorID,Operator,ReportDoctorDR,CheckPart,AdmissionType,0))=""
	.............
	.............s UseConsumableItemID=0
	.............f  s UseConsumableItemID=$o(^DHCEQUseConsumableStat("Temp",SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,RequestDeptDR,DoctorID,Operator,ReportDoctorDR,CheckPart,AdmissionType,UseConsumableItemID)) quit:(UseConsumableItemID="")||(flag'=0)  d
	..............s ServDetItemID=""
	..............f  s ServDetItemID=$o(^DHCEQUseConsumableStat("Temp",SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,RequestDeptDR,DoctorID,Operator,ReportDoctorDR,CheckPart,AdmissionType,UseConsumableItemID,ServDetItemID)) quit:(ServDetItemID="")||(flag'=0)  d
	...............s UnitID=""
	...............f  s UnitID=$o(^DHCEQUseConsumableStat("Temp",SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,RequestDeptDR,DoctorID,Operator,ReportDoctorDR,CheckPart,AdmissionType,UseConsumableItemID,ServDetItemID,UnitID)) quit:(UnitID="")||(flag'=0)  d
	................s ConsumablePrice=""
	................f  s ConsumablePrice=$o(^DHCEQUseConsumableStat("Temp",SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,RequestDeptDR,DoctorID,Operator,ReportDoctorDR,CheckPart,AdmissionType,UseConsumableItemID,ServDetItemID,UnitID,ConsumablePrice)) quit:(ConsumablePrice="")||(flag'=0)  d
	.................s TempUCSData=$g(^DHCEQUseConsumableStat("Temp",SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,RequestDeptDR,DoctorID,Operator,ReportDoctorDR,CheckPart,AdmissionType,UseConsumableItemID,ServDetItemID,UnitID,ConsumablePrice))
	.................s TQuantity=+$p(TempUCSData,"^",1)
	.................s TAmount=+$p(TempUCSData,"^",2)
	.................s TPayAmount=+$p(TempUCSData,"^",3)
	.................s TPayPrice=+$p(TempUCSData,"^",4)
	.................s objUseConsumableStat=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	.................d objUseConsumableStat.%Set("UCSRowID","")
	.................d objUseConsumableStat.%Set("UCSUseRecordStatDR",Result)
	.................d objUseConsumableStat.%Set("UCSConsumableItemDR",UseConsumableItemID)
	.................d objUseConsumableStat.%Set("UCSUOMDR",UnitID)
	.................d objUseConsumableStat.%Set("UCSQuantity",+$p(TempUCSData,"^",1))
	.................d objUseConsumableStat.%Set("UCSPrice",ConsumablePrice)
	.................d objUseConsumableStat.%Set("UCSAmount",+$p(TempUCSData,"^",2))
	.................d objUseConsumableStat.%Set("UCSServiceItemDR",ServiceItemID)
	.................d objUseConsumableStat.%Set("UCSServDetItem",ServDetItemID)
	.................d objUseConsumableStat.%Set("UCSRemark","")
	.................d objUseConsumableStat.%Set("UCSHold1","")
	.................d objUseConsumableStat.%Set("UCSHold2","")
	.................d objUseConsumableStat.%Set("UCSHold3","")
	.................d objUseConsumableStat.%Set("UCSHold4","")
	.................d objUseConsumableStat.%Set("UCSHold5","")
	.................d objUseConsumableStat.%Set("UCSPayPrice",+$p(TempUCSData,"^",4))
	.................d objUseConsumableStat.%Set("UCSPayAmount",+$p(TempUCSData,"^",3))
	.................s ConsumableItemResult=##Class(web.DHCEQ.BA.BUSUseRecordStat).SaveUseConsumableStat(objUseConsumableStat)
	.................i ConsumableItemResult'>0 d
	..................s flag=1
	..................s ^DHCEQUseConsumableStat("Gather","Result","Error",SourceType,SourceID,MonthStr)=ConsumableItemResult
	
	k ^DHCEQUseRecordStat("Temp")
	k ^DHCEQUseConsumableStat("Temp")
	k ^TempDHCEQ("UseRecordStat.JCL")
	k ^TempDHCEQ("UseRecordStat.JCRC")
	k ^TempDHCEQ("UseRecordStat.BGCS")
	k ^TempDHCEQ("UseRecordStat.JCLEQ")
	k ^TempDHCEQ("UseRecordStat.JCRCEQ")
	k ^TempDHCEQ("UseRecordStat.BGCSEQ")
	k ^TempDHCEQ("UseRecordStat_JS.JCL")
	k ^TempDHCEQ("UseRecordStat_JS.JCRC")
	k ^TempDHCEQ("UseRecordStat_JS.BGCS")
	k ^TempDHCEQ("UseRecordStat.DXJCRC")
	k ^TempDHCEQ("UseRecordStat_JS.DXJCRC")
	
	q flag

SumUseRecordInfo
	s WorkLoadNum=+$p(DataList,"^",7)*AddFlag
	s WorkLoadUnitID=+$p(DataList,"^",8)
	s UseLocID=$p(DataList,"^",9)
	s PatientID=$p(DataList,"^",10)
	s Price=$p(DataList,"^",11)
	s TotalFee=$p(DataList,"^",12)*AddFlag
	s ServiceItemID=$p(DataList,"^",15)
	s URExType=$p(DataList,"^",16)
	s CancelDate=$p(DataList,"^",29)
	s Operator=+$p(DataList,"^",39)
	s PositiveFlag=$p(DataList,"^",40)
	i PositiveFlag="Y"  d
	.s PositiveFlag=1
	e  d
	.s PositiveFlag=0
	s SampleNo=$p(DataList,"^",41)
	s TExposureNum=$p(DataList,"^",42)*AddFlag
	s ExposureTime=##Class(web.DHCEQUseRecord).GetExposureNum(URExType,SampleNo)
	
	s AdmissionType=+$p(DataList,"^",52)
	s PreOccurDate=$p(DataList,"^",55)
	s PreOccurTime=$p(DataList,"^",56)
	s RegDate=$p(DataList,"^",59)
	s RegTime=$p(DataList,"^",60)
	//Modify by zx 2022-05-23 Bug 2670643
	//s WaitTimeTotal=PreOccurDate-RegDate
	//i WaitTimeTotal<1 s WaitTimeTotal=0
	s WaitTimeTotal=$fn(((+##Class(web.DHCEQCommon).TimeDiff(RegDate,RegTime,PreOccurDate,PreOccurTime,"0"))/3600),"",2)
	s CheckPart=+$p(DataList,"^",63)
	s DoctorID=+$p(DataList,"^",64)
	s RequestDeptDR=+$p(DataList,"^",65)
	s ReportDoctorDR=+$p(DataList,"^",66)
	s TWorkLoadNum=$p(DataList,"^",67)
	
	s TempDate=$g(^DHCEQUseRecordStat("Temp",SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,RequestDeptDR,DoctorID,Operator,ReportDoctorDR,CheckPart,AdmissionType))   //add by zx 2014-08-28
	
	s $p(TempDate,"^",1)=+$p(TempDate,"^",1)+WorkLoadNum	//总工作量
	s $p(TempDate,"^",2)=+$p(TempDate,"^",2)+TotalFee		//总金额
	s $p(TempDate,"^",3)=+$p(TempDate,"^",3)+TExposureNum	//曝光总次数
	s $p(TempDate,"^",4)=+$p(TempDate,"^",4)+1*AddFlag		//单项检查总量
	
	//单项人次总量
	i PatientID'=""  d
	.;当同一天同一台仪器同一个病人做同一个服务的使用记录不存在时,则登记该单项检查人次信息且单项检查人次加1
	.i ('$D(^TempDHCEQ("UseRecordStat.DXJCRC",$J,URExType,StartDate,SourceType,SourceID,PatientID,ServiceItemID))&&(AddFlag=1))  d
	..s ^TempDHCEQ("UseRecordStat.DXJCRC",$J,URExType,StartDate,SourceType,SourceID,PatientID,ServiceItemID)=1
	..s $p(TempDate,"^",5)=+$p(TempDate,"^",5)+1
	.;当同一天同一台仪器同一个病人做同一个服务的减少记录不存在时,则登记该单项检查人次信息且单项检查人次减1
	.i ('$D(^TempDHCEQ("UseRecordStat_JS.DXJCRC",$J,URExType,StartDate,SourceType,SourceID,PatientID,ServiceItemID))&&(AddFlag=-1))  d
	..s ^TempDHCEQ("UseRecordStat_JS.DXJCRC",$J,URExType,StartDate,SourceType,SourceID,PatientID,ServiceItemID)=1
	..s $p(TempDate,"^",5)=+$p(TempDate,"^",5)-1
	
	s $p(TempDate,"^",6)=+$p(TempDate,"^",6)+WaitTimeTotal	//等待总时间
	s $p(TempDate,"^",7)=+$p(TempDate,"^",7)+PositiveFlag	//阳性总数
	s $p(TempDate,"^",8)=+$p(TempDate,"^",8)+TWorkLoadNum	//技师工作总量
	
         //modified by wy 2021-10-22 WY0097 汇总生成月使用记录的程序逻辑调整
	;检查量
	i SampleNo'=""  d
	.;当病人医技流水号检查量的使用记录不存在时,则登记该流水号且检查量加1
	.i ('$D(^TempDHCEQ("UseRecordStat.JCL",$J,URExType,SampleNo))&&(AddFlag=1))  d
	..s ^TempDHCEQ("UseRecordStat.JCL",$J,URExType,SampleNo)=1
	..s ^TempDHCEQ("UseRecordStat.JCLEQ",$J,SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,RequestDeptDR,DoctorID,Operator,ReportDoctorDR,CheckPart,AdmissionType)=1+$g(^TempDHCEQ("UseRecordStat.JCLEQ",$J,SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,RequestDeptDR,DoctorID,Operator,ReportDoctorDR,CheckPart,AdmissionType))
	.;当病人医技流水号检查量的取消记录不存在时,则登记该流水号且检查量减1
	.i ('$D(^TempDHCEQ("UseRecordStat_JS.JCL",$J,URExType,SampleNo))&&(AddFlag=-1))  d
	..s ^TempDHCEQ("UseRecordStat_JS.JCL",$J,URExType,SampleNo)=1
	..s ^TempDHCEQ("UseRecordStat.JCLEQ",$J,SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,RequestDeptDR,DoctorID,Operator,ReportDoctorDR,CheckPart,AdmissionType)=+$g(^TempDHCEQ("UseRecordStat.JCLEQ",$J,SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,RequestDeptDR,DoctorID,Operator,ReportDoctorDR,CheckPart,AdmissionType))-1
	.;当病人医技流水号曝光的使用记录不存在时,则登记该流水号且增加曝光次数
	.i ('$D(^TempDHCEQ("UseRecordStat.BGCS",$J,URExType,SampleNo))&&(AddFlag=1))  d		//曝光次数
	..s ^TempDHCEQ("UseRecordStat.BGCS",$J,URExType,SampleNo)=1
	..s ^TempDHCEQ("UseRecordStat.BGCSEQ",$J,SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,RequestDeptDR,DoctorID,Operator,ReportDoctorDR,CheckPart,AdmissionType)=ExposureTime+$g(^TempDHCEQ("UseRecordStat.BGCSEQ",$J,SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,RequestDeptDR,DoctorID,Operator,ReportDoctorDR,CheckPart,AdmissionType))
	.;当病人医技流水号曝光的取消记录不存在时,则登记该流水号且减少曝光次数
	.i ('$D(^TempDHCEQ("UseRecordStat_JS.BGCS",$J,URExType,SampleNo))&&(AddFlag=-1))  d
	..s ^TempDHCEQ("UseRecordStat_JS.BGCS",$J,URExType,SampleNo)=1
	..s ^TempDHCEQ("UseRecordStat.BGCSEQ",$J,SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,RequestDeptDR,DoctorID,Operator,ReportDoctorDR,CheckPart,AdmissionType)=+$g(^TempDHCEQ("UseRecordStat.BGCSEQ",$J,SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,RequestDeptDR,DoctorID,Operator,ReportDoctorDR,CheckPart,AdmissionType))-ExposureTime
	;检查人次		//Add By DJ 2015-09-29 DJ0169 end
	i PatientID'=""  d
	.;当同一天同一台仪器同一个病人的使用记录不存在时,则登记该检查人次信息且检查人次加1
	.i ('$D(^TempDHCEQ("UseRecordStat.JCRC",$J,URExType,StartDate,SourceType,SourceID,PatientID))&&(AddFlag=1))  d
	..s ^TempDHCEQ("UseRecordStat.JCRC",$J,URExType,StartDate,SourceType,SourceID,PatientID)=1
	..s ^TempDHCEQ("UseRecordStat.JCRCEQ",$J,SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,RequestDeptDR,DoctorID,Operator,ReportDoctorDR,CheckPart,AdmissionType)=1+$g(^TempDHCEQ("UseRecordStat.JCRCEQ",$J,SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,RequestDeptDR,DoctorID,Operator,ReportDoctorDR,CheckPart,AdmissionType))
	.;当同一天同一台仪器同一个病人的取消记录不存在时,则登记该检查人次信息且检查人次减1
	.i ('$D(^TempDHCEQ("UseRecordStat_JS.JCRC",$J,URExType,StartDate,SourceType,SourceID,PatientID))&&(AddFlag=-1))  d
	..s ^TempDHCEQ("UseRecordStat_JS.JCRC",$J,URExType,StartDate,SourceType,SourceID,PatientID)=1
	..s ^TempDHCEQ("UseRecordStat.JCRCEQ",$J,SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,RequestDeptDR,DoctorID,Operator,ReportDoctorDR,CheckPart,AdmissionType)=+$g(^TempDHCEQ("UseRecordStat.JCRCEQ",$J,SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,RequestDeptDR,DoctorID,Operator,ReportDoctorDR,CheckPart,AdmissionType))-1
	
	s ^DHCEQUseRecordStat("Temp",SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,RequestDeptDR,DoctorID,Operator,ReportDoctorDR,CheckPart,AdmissionType)=TempDate
	
	s UCIRowID=0
	f  s UCIRowID=$o(^DHCEQUseConsumableItem(0,"UseRecord",URRowID,UCIRowID))  quit:UCIRowID=""  d
	.s ConDataList=$g(^DHCEQUseConsumableItem(UCIRowID))
	.q:$p(ConDataList,"^",7)=2
	.s UseConsumableItemID=+$p(ConDataList,"^",2) ;modified by cjt 20221205 需求号2888051 "$p"改为"+$p"
	.s UnitID=+$p(ConDataList,"^",3) ;modified by cjt 20221205 需求号2888051 "$p"改为"+$p"
	.s Quantity=+$p(ConDataList,"^",4)*AddFlag
	.s ConsumablePrice=+$p(ConDataList,"^",5)
	.s Amount=+$p(ConDataList,"^",6)*AddFlag
	.s TServiceItemID=+$p(ConDataList,"^",12)
	.s ServDetItemID=+$p(ConDataList,"^",13)
	.s ServDetItemQty=+$p(ConDataList,"^",14)
	.s PayPrice=+$p(ConDataList,"^",18)  //add by zx 2014-09-16 汇总消耗额外收费
	.s PayAmount=+$p(ConDataList,"^",19)*AddFlag
	.s ConTempDate=$g(^DHCEQUseConsumableStat("Temp",SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,RequestDeptDR,DoctorID,Operator,ReportDoctorDR,CheckPart,AdmissionType,UseConsumableItemID,ServDetItemID,UnitID,ConsumablePrice))   //add by zx 2014-08-28
	.s $p(ConTempDate,"^",1)=+$p(ConTempDate,"^",1)+Quantity
	.s $p(ConTempDate,"^",2)=+$p(ConTempDate,"^",2)+Amount
	.s $p(ConTempDate,"^",3)=+$p(ConTempDate,"^",3)+PayAmount
	.s $p(ConTempDate,"^",4)=+$p(ConTempDate,"^",4)+PayPrice
	.s ^DHCEQUseConsumableStat("Temp",SourceType,SourceID,ServiceItemID,UseLocID,Price,WorkLoadUnitID,RequestDeptDR,DoctorID,Operator,ReportDoctorDR,CheckPart,AdmissionType,UseConsumableItemID,ServDetItemID,UnitID,ConsumablePrice)=ConTempDate
	q
}

/// Add by：ZY0234 20200609
/// 入参：JsonData：采集数据中直接设置成json格式
/// modify by lmm 2018-05-22 增加入参 OeoStr：医嘱Rowid:部位代码@部位代码,检查项目描述;医嘱Rowid:部位代码@部位代码,检查项目描述
/// 返回：成功返回RowID，失败返回值小于等于0
/// w ##Class(web.DHCEQ.BA.BUSUseRecordStat).SaveDate("","N","1","1^615^23/05/2018^^23/05/2018^^1^^162^168313&王化根&男&38872^1634.00^1634.00^2018^05^2^DHC-RIS^MR20180522044^N^2^N^^^^^^^^1237^^阳性^^^","1443935||19:TB01~JC000065*1443935||18:TB01~JC000067*1443935||17:TB01~JC000768*1443935||16:TB01~JC000689")
ClassMethod SaveUseRecordStat(JsonData)
{
	new PLIST,RowID,SourceType,SourceID,Year,Month,ServiceItemDR,FindFlag
	new UseLocDR,WorkLoadUnitDR,Price,AdmissionType,CheckPart,DoctorID,RequestDeptDR,Operator,ReportDoctorDR
	k PLIST
	
	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQUseRecordStat",JsonData,.PLIST)
	s RowID=JsonData.URSRowID
	s SourceType=JsonData.URSSourceType
	s SourceID=JsonData.URSSourceID
	s Year=JsonData.URSYear
	s Month=JsonData.URSMonth
	s ServiceItemDR=JsonData.URSServiceItemDR
	
	s UseLocDR=JsonData.URSUseLocDR
	s WorkLoadUnitDR=JsonData.URSWorkLoadUnitDR
	s Price=JsonData.URSPrice
	s AdmissionType=JsonData.URSAdmissionType
	s CheckPart=JsonData.URSCheckPart
	s DoctorID=JsonData.URSDoctorID
	s RequestDeptDR=JsonData.URSRequestDeptDR
	s Operator=JsonData.URSOperator
	s ReportDoctorDR=JsonData.URSReportDoctorDR
	
	///在当月的数据重复汇总的时候，可以直接更新当月的汇总记录
	s FindFlag=""
	s FindURSRowID=0
	f  s FindURSRowID=$o(^DHCEQUseRecordStat(0,"SourceService",SourceType,SourceID,Year,Month,ServiceItemDR,FindURSRowID))  q:(FindURSRowID="")||(FindFlag'="")  d
	.//,UseLocID,Price,WorkLoadUnitID,RequestDeptDR,DoctorID,Operator,ReportDoctorDR,CheckPart,AdmissionType
	.s URSDatalist=$g(^DHCEQUseRecordStat(FindURSRowID))
	.s FindUseLocDR=$p(URSDatalist,"^",5)
	.q:FindUseLocDR'=UseLocDR
	.s FindWorkLoadUnitDR=$p(URSDatalist,"^",9)
	.q:FindWorkLoadUnitDR'=WorkLoadUnitDR
	.s FindPrice=$p(URSDatalist,"^",10)
	.q:FindPrice'=Price
	.s FindAdmissionType=$p(URSDatalist,"^",18)
	.q:FindAdmissionType'=AdmissionType
	.s FindCheckPart=$p(URSDatalist,"^",20)
	.q:FindCheckPart'=CheckPart
	.s FindDoctorID=$p(URSDatalist,"^",21)
	.q:FindDoctorID'=DoctorID
	.s FindRequestDeptDR=$p(URSDatalist,"^",22)
	.q:FindRequestDeptDR'=RequestDeptDR
	.s FindOperator=$p(URSDatalist,"^",24)
	.q:FindOperator'=Operator
	.s FindReportDoctorDR=$p(URSDatalist,"^",25)
	.q:FindReportDoctorDR'=ReportDoctorDR
	.s FindFlag=1
	.s RowID=FindURSRowID
	
	i RowID=""
	{
		&SQL(Insert Into SQLUSER.DHC_EQUseRecordStat Values :PLIST())
		Set URRowID=$g(%ROWID)
	}
	else
	{
		&SQL(Update SQLUSER.DHC_EQUseRecordStat Values :PLIST() where URS_RowID = :RowID)
	}
 	if SQLCODE 
 	{
	 	q SQLCODE
 	}
 	i RowID="" Set RowID=$g(%ROWID)
 	q RowID
}

/// Add by：ZY0234 20200609
/// 入参：JsonData：采集数据中直接设置成json格式
/// modify by lmm 2018-05-22 增加入参 OeoStr：医嘱Rowid:部位代码@部位代码,检查项目描述;医嘱Rowid:部位代码@部位代码,检查项目描述
/// 返回：成功返回RowID，失败返回值小于等于0
/// w ##Class(web.DHCEQ.BA.BUSUseRecordStat).SaveDate("","N","1","1^615^23/05/2018^^23/05/2018^^1^^162^168313&王化根&男&38872^1634.00^1634.00^2018^05^2^DHC-RIS^MR20180522044^N^2^N^^^^^^^^1237^^阳性^^^","1443935||19:TB01~JC000065*1443935||18:TB01~JC000067*1443935||17:TB01~JC000768*1443935||16:TB01~JC000689")
ClassMethod SaveUseConsumableStat(JsonData)
{
	new PLIST,RowID
	k PLIST
	
	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQUseConsumableStat",JsonData,.PLIST)
	s RowID=JsonData.UCSRowID
	if RowID=""
	{
		&SQL(Insert Into SQLUSER.DHC_EQUseConsumableStat Values :PLIST())
	}
	else
	{
		&SQL(Update SQLUSER.DHC_EQUseConsumableStat Values :PLIST() where UCS_RowID = :RowID)
	}
 	i RowID="" Set RowID=$g(%ROWID)
 	q RowID
}

/// 取时间段内汇总数据的合计
/// 入参：MonthStr："YYYY-MM"
///       vSourceType：1:设备  2，设备项
///       vSourceID：设备ID  设备项ID
/// w ##Class(web.DHCEQ.BA.BUSUseRecordStat).GetUseRecordStat("2020-07",1,1)
ClassMethod GetUseRecordStat(MonthStr, vSourceType As %String = "", vSourceID As %String = "")
{
	new Date,Year,Month,URSRowID,DataList,SumDataList
	s SumDataList=""
	s Year=$p(MonthStr,"-",1)
	s Month=$p(MonthStr,"-",2)
	s URSRowID=0
	f  s URSRowID=$o(^DHCEQUseRecordStat(0,"SourceMonth",vSourceType,vSourceID,Year,Month,URSRowID)) Q:URSRowID=""  d
	.s DataList=$g(^DHCEQUseRecordStat(URSRowID))
	.s $p(SumDataList,"^",1)=$p(SumDataList,"^",1)+$p(DataList,"^",7)	//总收入
	.s $p(SumDataList,"^",2)=$p(SumDataList,"^",2)+$p(DataList,"^",8)	//总工作量
	.s $p(SumDataList,"^",3)=$p(SumDataList,"^",3)+$p(DataList,"^",12)	//单项检查量
	.s $p(SumDataList,"^",4)=$p(SumDataList,"^",4)+$p(DataList,"^",13)	//检测量
	.s $p(SumDataList,"^",5)=$p(SumDataList,"^",5)+$p(DataList,"^",14)	//单项人次
	.s $p(SumDataList,"^",6)=$p(SumDataList,"^",6)+$p(DataList,"^",15)	//人次
	.s $p(SumDataList,"^",7)=$p(SumDataList,"^",7)+$p(DataList,"^",16)	//单项曝光次数
	.s $p(SumDataList,"^",8)=$p(SumDataList,"^",8)+$p(DataList,"^",17)	//曝光次数
	.s $p(SumDataList,"^",9)=$p(SumDataList,"^",9)+$p(DataList,"^",23)	//阳性例数
	.s $p(SumDataList,"^",10)=$p(SumDataList,"^",10)+$p(DataList,"^",26)	//技师工作量
	.
	.s UCSRowID=0
	.f  s UCSRowID=$o(^DHCEQUseConsumableStat(0,"UseRecordstat",URSRowID,UCSRowID)) Q:UCSRowID=""  d
	..s ConDataList=$g(^DHCEQUseConsumableStat(UCSRowID))
	..
	..s $p(SumDataList,"^",11)=$p(SumDataList,"^",11)+$p(ConDataList,"^",6)	//耗材总费用
	..s $p(SumDataList,"^",12)=$p(SumDataList,"^",12)+$p(ConDataList,"^",16)	//耗材额外收费
	..
	q SumDataList
}

}
