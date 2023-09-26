Class web.DHCEQUseContext Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 增加、修改数据
/// w ##Class(web.DHCEQUseContext).UpdateUseContextMonth("^^13828^2017^^",1)
ClassMethod UpdateUseContextMonth(UseContextInfo, Yearflag)
{
	n Plist,RowID
	
	s RowID=$P(UseContextInfo,"^",1)
	s Plist(1)=$P(UseContextInfo,"^",1) ;rowid
	//s Plist(2)=$P(UseContextInfo,"^",2) ;年度汇总报告ID
	s Plist(3)=$P(UseContextInfo,"^",3) ;EquipDR
	s Plist(4)=$P(UseContextInfo,"^",4) ;Year
	s Plist(5)=$P(UseContextInfo,"^",5) ;Month
	s Plist(6)=$P(UseContextInfo,"^",6) ;预期满意度
	s Plist(7)=$P(UseContextInfo,"^",7) ;实际满意度
	s Plist(8)=$P(UseContextInfo,"^",8) ;患者满意度
	s Plist(9)=$P(UseContextInfo,"^",9) ;填补诊治空白
	s Plist(10)=$P(UseContextInfo,"^",10) ;服务特殊人群
	s Plist(11)=$P(UseContextInfo,"^",11) ;其他社会效益
	s Plist(12)=$P(UseContextInfo,"^",12) ;培养研究生数量
	s Plist(13)=$P(UseContextInfo,"^",13) ;培养进修人员数量
	s Plist(14)=$P(UseContextInfo,"^",14) ;承担的其他科研教学任务
	s Plist(15)=$P(UseContextInfo,"^",15) ;总分(得分)
	s Plist(16)=$P(UseContextInfo,"^",16) ;经济效益分析
	s Plist(17)=$P(UseContextInfo,"^",17) ;使用评价（维修维护、运行情况）
	s Plist(18)=$P(UseContextInfo,"^",18) ;简要评价
	s Plist(19)=$P(UseContextInfo,"^",19) ;总体评价
	s Plist(20)=$P(UseContextInfo,"^",20) ;设备收入
	s Plist(21)=$P(UseContextInfo,"^",21) ;检查人次
	s Plist(22)=$P(UseContextInfo,"^",22) ;实际工作量
	s Plist(23)=$P(UseContextInfo,"^",23) ;阳性例数
	s Plist(24)=$P(UseContextInfo,"^",24) ;开机时间
	s Plist(25)=$P(UseContextInfo,"^",25) ;故障次数
	s Plist(26)=$P(UseContextInfo,"^",26) ;维修次数
	s Plist(27)=$P(UseContextInfo,"^",27) ;保养次数
	s Plist(28)=$P(UseContextInfo,"^",28) ;检测次数
	s Plist(29)=$P(UseContextInfo,"^",29) ;预约等待时间
	s Plist(30)=$P(UseContextInfo,"^",30) ;平均工作小时/日
	s Plist(31)=$P(UseContextInfo,"^",31) ;实际工作天数
	s Plist(32)=$P(UseContextInfo,"^",32) ;故障天数（0.5天起计算）
	//s Plist(33)=$P(UseContextInfo,"^",33) ;AddUserDR
	//s Plist(34)=$P(UseContextInfo,"^",34) ;AddDate
	//s Plist(35)=$P(UseContextInfo,"^",35) ;AddTime
	//s Plist(36)=$P(UseContextInfo,"^",36) ;UpdateUserDR
	//s Plist(37)=$P(UseContextInfo,"^",37) ;UpdateDate
	//s Plist(38)=$P(UseContextInfo,"^",38) ;UpdateTime
	//s Plist(39)=$P(UseContextInfo,"^",39) ;SubmitUserDR
	//s Plist(40)=$P(UseContextInfo,"^",40) ;SubmitDate
	//s Plist(41)=$P(UseContextInfo,"^",41) ;SubmitTime
	//s Plist(42)=$P(UseContextInfo,"^",42) ;AuditUserDR
	//s Plist(43)=$P(UseContextInfo,"^",43) ;AuditDate
	//s Plist(44)=$P(UseContextInfo,"^",44) ;AuditTime
	s Plist(45)="N" ;InvalidFlag
	s RowidFind=""
	if (Yearflag=1)
	{
    	&SQL(select UC_RowID into :RowidFind from SQLUSER.DHC_EQUseContext where UC_Year=:Plist(4) and UC_Month is NULL and UC_EquipDR=:Plist(3))
	}
	else
	{
		&SQL(select UC_RowID into :RowidFind from SQLUSER.DHC_EQUseContext where UC_Year=:Plist(4) and UC_Month=:Plist(5) and UC_EquipDR=:Plist(3))
	}
	if (RowidFind="")
	{
		s Plist(33)=$P(UseContextInfo,"^",33) ;AddUserDR
		s Plist(34)=$P(UseContextInfo,"^",34) ;AddDate
		s Plist(35)=$P(UseContextInfo,"^",35) ;AddTime
		s Plist(46)=2 ;Status
		&SQL(insert into sqluser.DHC_EQUseContext values :Plist())
		q SQLCODE
	}
	else
	{	i (RowidFind'=RowID) q "-1000"
		s Plist(36)=$P(UseContextInfo,"^",36) ;UpdateUserDR
	    s Plist(37)=$P(UseContextInfo,"^",37) ;UpdateDate
	    s Plist(38)=$P(UseContextInfo,"^",38) ;UpdateTime
		s Plist(46)=2 ;Status
		&SQL(update sqluser.DHC_EQUseContext values :Plist() where UC_RowID=:RowidFind)
		q SQLCODE
	}
}

ClassMethod SaveUseContext(val, Yearflag)
{
    Set $ZT="ERROR" //2009-08-10 党军
	TSTART //2009-08-10 党军
    s length=$l(val,"&")
	f i=1:1:length  d
	.s UseContextInfo=$p(val,"&",i)
	.s SQLCODE=..UpdateUseContextMonth(UseContextInfo,Yearflag)
	.q:SQLCODE'=0
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
    q SQLCODE
ERROR 
	Set ErrorMsg=$ZE	          
	TROLLBACK		      
	Quit "<ERROR>"_ErrorMsg
}

/// 根据rowid号删除数据
ClassMethod DeleteUseContextMonth(RowID)
{
	if RowID'=""
	{
		&SQL(update sqluser.DHC_EQUseContext set UC_InvalidFlag='Y' where UC_RowID=:RowID)
		q SQLCODE
	}
	q "删除失败"
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQUseContext","GetUseContext","21716","1")
Query GetUseContext(EquipDR As %String = "", YearFlag As %String = "0") As %Query(ROWSPEC = "TRowID:%String,TYear:%String,TMonth:%String,TExpectedSatis:%String,TActualSatis:%String,TPatientSatis:%String,TNewFunction:%String,TSpecialService:%String,TOtherSocial:%String,TGraduateNum:%String,TStaffNum:%String,TOtherTasks:%String,TTotalScore:%String,TBenefitAnalysis:%String,TUseEvaluation:%String,TBriefEvaluation:%String,TOverallEvaluation:%String,TIncome:%String,TPersonTime:%String,TActualWorkLoad:%String,TPositiveCases:%String,TRunTime:%String,TFailureTimes:%String,TMaintTimes:%String,TPMTimes:%String,TDetectionTimes:%String,TWaitingTimes:%String,TAverageWorkHour:%String,TActualWorkDays:%String,TFailureDays:%String,TStatus:%String")
{
}

ClassMethod GetUseContextExecute(ByRef qHandle As %Binary, EquipDR As %String = "", YearFlag As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i EquipDR=""  Quit $$$OK
	s Year=0
 	f  s Year=$o(^DHCEQUseContext(0,"EquipYearMonth",EquipDR,Year)) q:Year=""  d
 	.s Month=""
 	.f  s Month=$o(^DHCEQUseContext(0,"EquipYearMonth",EquipDR,Year,Month)) q:Month=""  d
 	..q:(YearFlag="1")&&(Month'=0)
 	..q:(YearFlag="0")&&(Month=0)
 	..s rowid=0
 	..f  s rowid=$o(^DHCEQUseContext(0,"EquipYearMonth",EquipDR,Year,Month,rowid)) q:rowid=""  d
 	...s (TExpectedSatis,TActualSatis,TPatientSatis,TTotalScore,TBenefitAnalysis,TUseEvaluation,TBriefEvaluation,TOverallEvaluation,TIncome,TPersonTime)=""
 	...s (TActualWorkLoad,TPositiveCases,TRunTime,TFailureTimes,TMaintTimes,TPMTimes,TDetectionTimes,TWaitingTimes,TAverageWorkHour,TActualWorkDays,TFailureDays,TUCHold1,TUCHold2,TUCHold3,TUCHold4,TUCHold5)=""
 	...s datalist=$g(^DHCEQUseContext(rowid))
 	...q:$p(datalist,"^",44)="Y"
	...d BuildDataGetUseContext
	Quit $$$OK
BuildDataGetUseContext
	d ResetVariablesGetUseContext
	s TRowID = rowid
	s TBenefitSummaryDR=$p(datalist,"^",1)
	s TEquipDR=$p(datalist,"^",2)
	s TYear=$p(datalist,"^",3)
	s TMonth=$p(datalist,"^",4)
	s TExpectedSatis=$p(datalist,"^",5)
	s TActualSatis=$p(datalist,"^",6)
	s TPatientSatis=$p(datalist,"^",7)
	s TNewFunction=$p(datalist,"^",8)
	s TSpecialService=$p(datalist,"^",9)
	s TOtherSocial=$p(datalist,"^",10)
	s TGraduateNum=$p(datalist,"^",11)
	s TStaffNum=$p(datalist,"^",12)
	s TOtherTasks=$p(datalist,"^",13)
	s TTotalScore=$p(datalist,"^",14)
	s TBenefitAnalysis=$p(datalist,"^",15)
	s TUseEvaluation=$p(datalist,"^",16)
	s TBriefEvaluation=$p(datalist,"^",17)
	s TOverallEvaluation=$p(datalist,"^",18)
	s TIncome=$p(datalist,"^",19)
	s TPersonTime=$p(datalist,"^",20)
	s TActualWorkLoad=$p(datalist,"^",21)
	s TPositiveCases=$p(datalist,"^",22)
	s TRunTime=$p(datalist,"^",23)      //##Class(web.DHCEQCommon).TransValueToPage(,"time")
	s TFailureTimes=$p(datalist,"^",24)
	s TMaintTimes=$p(datalist,"^",25)
	s TPMTimes=$p(datalist,"^",26)
	s TDetectionTimes=$p(datalist,"^",27)
	s TWaitingTimes=$p(datalist,"^",28)
	s TAverageWorkHour=$p(datalist,"^",29)
	s TActualWorkDays=$p(datalist,"^",30)
	s TFailureDays=$p(datalist,"^",31)
	s TStatusDR=$p(datalist,"^",45)
	d OutputRowGetUseContext
	quit
OutputRowGetUseContext
	s Data=$lb(TRowID,TYear,TMonth,TExpectedSatis,TActualSatis,TPatientSatis,TNewFunction,TSpecialService,TOtherSocial,TGraduateNum,TStaffNum,TOtherTasks,TTotalScore,TBenefitAnalysis,TUseEvaluation,TBriefEvaluation,TOverallEvaluation,TIncome,TPersonTime,TActualWorkLoad,TPositiveCases,TRunTime,TFailureTimes,TMaintTimes,TPMTimes,TDetectionTimes,TWaitingTimes,TAverageWorkHour,TActualWorkDays,TFailureDays,TStatus)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetUseContext
	s (TRowID,TYear,TMonth,TExpectedSatis,TActualSatis,TPatientSatis,TNewFunction,TSpecialService,TOtherSocial,TGraduateNum,TStaffNum,TOtherTasks,TTotalScore,TBenefitAnalysis,TUseEvaluation,TBriefEvaluation,TOverallEvaluation,TIncome,TPersonTime,TActualWorkLoad,TPositiveCases,TRunTime,TFailureTimes,TMaintTimes,TPMTimes,TDetectionTimes,TWaitingTimes,TAverageWorkHour,TActualWorkDays,TFailureDays,TStatus)=""
	quit
}

ClassMethod GetUseContextFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUseContextExecute ]
{
	
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetUseContextClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUseContextExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##Class(web.DHCEQUseContext).GatherUseContext("2017-08")
ClassMethod GatherUseContext(MonthStr)
{
	s Year=$p(MonthStr,"-",1)
	s Month=$p(MonthStr,"-",2)
	
	s SQLCODE=0
 	s EquipID=0
 	f  s EquipID=$o(^DHCEQBenefitEquipList(0,"Equip",EquipID)) q:(EquipID="")||(SQLCODE'=0)  d
 	.s (Income,PersonTime,ActualWorkLoad,PositiveCases)=0
 	.s (ConsumableFee,ConsumablePayFee)=0
 	.k PLIST
 	.//根据每月汇总表的数据获取收入、工作量、检查人次、阳性率、耗材成本等数据
 	.i $Data(^DHCEQUseRecordStat(0,"SourceMonth",1,EquipID,Year,Month))'=0 d
	..s rowid=0
	..f  s rowid=$o(^DHCEQUseRecordStat(0,"SourceMonth",1,EquipID,Year,Month,rowid)) q:rowid=""  d
	...s Datalist=$g(^DHCEQUseRecordStat(rowid))
	...s Income=Income+$p(Datalist,"^",7)
	...s PersonTime=PersonTime+$p(Datalist,"^",15)
	...s ActualWorkLoad=ActualWorkLoad+$p(Datalist,"^",8)
	...s PositiveCases=PositiveCases+$p(Datalist,"^",17)
	...s TConsumableFeeInfo=##Class(web.DHCEQBenefitAnalyReport).GetUseRecordConsumableFeeNew(rowid)
	...s ConsumableFee=ConsumableFee+$p(TConsumableFeeInfo,"^",1)
	...s ConsumablePayFee=ConsumablePayFee+$p(TConsumableFeeInfo,"^",2)
	.
 	.s PLIST(3)=EquipID
 	.s PLIST(4)=Year
 	.s PLIST(5)=Month
 	.s PLIST(20)=Income
 	.s PLIST(21)=PersonTime
 	.s PLIST(22)=ActualWorkLoad
 	.s PLIST(23)=PositiveCases
 	.s PLIST(24)=""		//RunTime
 	.//取维修相关数据
 	.s MaintInfo=##Class(web.DHCEQBenefitAnalyReport).GetOutFeeByLifeInfo(EquipID,MonthStr,MonthStr,"31")
 	.s PLIST(25)=$p(MaintInfo,"^",2)		//FailureTimes
 	.s PLIST(26)=$p(MaintInfo,"^",2)		//MaintTimes
 	.//取保养数据
 	.s PMInfo=##Class(web.DHCEQBenefitAnalyReport).GetOutFeeByLifeInfo(EquipID,MonthStr,MonthStr,"33")
 	.s PLIST(27)=$p(PMInfo,"^",2)			//PMTimes
 	.//取检查数据
 	.s DetectionInfo=##Class(web.DHCEQBenefitAnalyReport).GetOutFeeByLifeInfo(EquipID,MonthStr,MonthStr,"32")
 	.s PLIST(28)=$p(DetectionInfo,"^",2)	//DetectionTimes
 	.s PLIST(29)=""		//WaitingTimes
 	.s PLIST(30)=""		//AverageWorkHour
 	.s PLIST(31)=""		//ActualWorkDays
 	.s PLIST(32)=$p(MaintInfo,"^",3)		//FailureDays
 	.s PLIST(46)="2"
 	.s RowidFind=""
 	.&SQL(select UC_RowID into :RowidFind from SQLUSER.DHC_EQUseContext where UC_Year=:Year and UC_Month=:Month and UC_EquipDR=:EquipID)
 	.i RowidFind="" d
 	..&SQL(Insert Into SQLUSER.DHC_EQUseContext Values :PLIST())
 	.e  d
	..&SQL(Update SQLUSER.DHC_EQUseContext Values :PLIST() where UC_RowID = :RowidFind)
	..i SQLCODE=100 s SQLCODE=0
	.q:SQLCODE'=0
	.///modified by ZY0276 20210720
	.//02 设备折旧
	.s DepreFee=##Class(web.DHCEQ.BA.BUSUsedResource).GetResourceDataByCode("05",EquipID,$p(MonthStr,"-",1),$p(MonthStr,"-",2))
	.i +$p(DepreFee,"^",1)>0 s SQLCODE=##class(web.DHCEQUsedResource).SaveUsedResource(Year,Month,"1",EquipID,"05",+$p(DepreFee,"^",1))
	.q:SQLCODE'=0
	.//21 设备保修合同费用
	.s GuaranteeFee=##Class(web.DHCEQ.BA.BUSUsedResource).GetGuaranteeFee(EquipID,MonthStr,MonthStr)
	.i GuaranteeFee>0 s SQLCODE=##class(web.DHCEQUsedResource).SaveUsedResource(Year,Month,"1",EquipID,"08",GuaranteeFee)
	.q:SQLCODE'=0
	.//22 维修费用
	.i +$p(MaintInfo,"^",1)>0 s SQLCODE=##class(web.DHCEQUsedResource).SaveUsedResource(Year,Month,"1",EquipID,"07",+$p(MaintInfo,"^",1))
	.q:SQLCODE'=0
	.//32 耗材支出费用
	.i +ConsumableFee>0 s SQLCODE=##class(web.DHCEQUsedResource).SaveUsedResource(Year,Month,"1",EquipID,"13",ConsumableFee,ConsumablePayFee)
	.q:SQLCODE'=0
	
	q SQLCODE
}

Storage Default
{
<Data name="DHCEQUseContextDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQUseContextD</DataLocation>
<DefaultData>DHCEQUseContextDefaultData</DefaultData>
<IdLocation>^web.DHCEQUseContextD</IdLocation>
<IndexLocation>^web.DHCEQUseContextI</IndexLocation>
<StreamLocation>^web.DHCEQUseContextS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
