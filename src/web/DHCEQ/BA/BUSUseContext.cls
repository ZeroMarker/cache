/// add by ZY0208 2020-02-27
Class web.DHCEQ.BA.BUSUseContext Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.BUSUseContext","GetUseContext","21716","1")
Query GetUseContext(EquipDR As %String = "", YearFlag As %String = "0") As %Query(ROWSPEC = "UCRowID:%String,UCYear:%String,UCMonth:%String,UCExpectedSatis:%String,UCActualSatis:%String,UCPatientSatis:%String,UCNewFunction:%String,UCSpecialService:%String,UCOtherSocial:%String,UCGraduateNum:%String,UCStaffNum:%String,UCOtherTasks:%String,UCTotalScore:%String,UCBenefitAnalysis:%String,UCUseEvaluation:%String,UCBriefEvaluation:%String,UCOverallEvaluation:%String,UCIncome:%String,UCPersonTime:%String,UCActualWorkLoad:%String,UCPositiveCases:%String,UCRunTime:%String,UCFailureTimes:%String,UCMaintTimes:%String,UCPMTimes:%String,UCDetectionTimes:%String,UCWaitingTimes:%String,UCAverageWorkHour:%String,UCActualWorkDays:%String,UCFailureDays:%String,UCStatus:%String")
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
	s UCRowID = rowid
	s UCBenefitSummaryDR=$p(datalist,"^",1)
	s UCEquipDR=$p(datalist,"^",2)
	s UCYear=$p(datalist,"^",3)
	s UCMonth=$p(datalist,"^",4)
	s UCExpectedSatis=$p(datalist,"^",5)
	s UCActualSatis=$p(datalist,"^",6)
	s UCPatientSatis=$p(datalist,"^",7)
	s UCNewFunction=$p(datalist,"^",8)
	s UCSpecialService=$p(datalist,"^",9)
	s UCOtherSocial=$p(datalist,"^",10)
	s UCGraduateNum=$p(datalist,"^",11)
	s UCStaffNum=$p(datalist,"^",12)
	s UCOtherTasks=$p(datalist,"^",13)
	s UCTotalScore=$p(datalist,"^",14)
	s UCBenefitAnalysis=$p(datalist,"^",15)
	s UCUseEvaluation=$p(datalist,"^",16)
	s UCBriefEvaluation=$p(datalist,"^",17)
	s UCOverallEvaluation=$p(datalist,"^",18)
	s UCIncome=$p(datalist,"^",19)
	s UCPersonTime=$p(datalist,"^",20)
	s UCActualWorkLoad=$p(datalist,"^",21)
	s UCPositiveCases=$p(datalist,"^",22)
	s UCRunTime=$p(datalist,"^",23)      //##Class(web.DHCEQCommon).TransValueToPage(,"time")
	s UCFailureTimes=$p(datalist,"^",24)
	s UCMaintTimes=$p(datalist,"^",25)
	s UCPMTimes=$p(datalist,"^",26)
	s UCDetectionTimes=$p(datalist,"^",27)
	s UCWaitingTimes=$p(datalist,"^",28)
	s UCAverageWorkHour=$p(datalist,"^",29)
	s UCActualWorkDays=$p(datalist,"^",30)
	s UCFailureDays=$p(datalist,"^",31)
	s UCStatusDR=$p(datalist,"^",45)
	d OutputRowGetUseContext
	quit
OutputRowGetUseContext
	s Data=$lb(UCRowID,UCYear,UCMonth,UCExpectedSatis,UCActualSatis,UCPatientSatis,UCNewFunction,UCSpecialService,UCOtherSocial,UCGraduateNum,UCStaffNum,UCOtherTasks,UCTotalScore,UCBenefitAnalysis,UCUseEvaluation,UCBriefEvaluation,UCOverallEvaluation,UCIncome,UCPersonTime,UCActualWorkLoad,UCPositiveCases,UCRunTime,UCFailureTimes,UCMaintTimes,UCPMTimes,UCDetectionTimes,UCWaitingTimes,UCAverageWorkHour,UCActualWorkDays,UCFailureDays,UCStatus)
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

ClassMethod SaveUseContextDataList(dataList, EquipID)
{
	new SQLCODE
	s SQLCODE=0
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")
	s Length=$L(dataList,SplitRowCode)
	for i=1:1:Length
	{
		q:SQLCODE'=0
		s valList=	$p(dataList,SplitRowCode,i)
		q:valList=""
		s SQLCODE=##Class(web.DHCEQ.BA.BUSUseContext).SaveData(valList,EquipID,0)
	}
	q SQLCODE
}

/// w ##Class(web.DHCEQ.BA.BUSUseContext).SaveData(valList, EquipID,DelIs)
ClassMethod SaveData(valList, EquipID, DelIs)
{
	new JsonData,SQLCODE,UCRowID
	s SQLCODE=0
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
 	s Time=$Piece($H,",",2)
	if (DelIs=1)
	{
	 	&SQL(Update SQLUSER.DHC_EQUseContext Set UC_InvalidFlag='Y',UC_Status='3' where UC_RowID = :valList) 
	}
	else
	{
		k UCPLIST
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
		s UCPLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQUseContext",JsonData,.UCPLIST)
		s UCPLIST(3)=EquipID
		s UCRowID = JsonData.UCRowID
		s UCPLIST(46)=2 ;Status
		if (UCRowID="")
		{
			s UCPLIST(33)=User ;AddUserDR
			s UCPLIST(34)=Date ;AddDate
			s UCPLIST(35)=Time ;AddTime
			&SQL(Insert Into SQLUSER.DHC_EQUseContext Values :UCPLIST())
		}
		else
		{
			s UCPLIST(36)=User ;UpdateUserDR
		    s UCPLIST(37)=Date ;UpdateDate
		    s UCPLIST(38)=Time ;UpdateTime
			&SQL(Update SQLUSER.DHC_EQUseContext Values :UCPLIST() where UC_RowID = :UCRowID) 
		}
	}
	q SQLCODE
}

/// add by ZY0247 2020-12-22
/// w ##Class(web.DHCEQ.BA.BUSUseContext).AutoCreateUseContext("2017-08")
ClassMethod AutoCreateUseContext(MonthStr, vEquipID As %String = "", updateFlag As %String = "")
{
	new Year,Month,SQLCODE,vJob,MStartDate,MEndDate
	s vJob=$j
	q:MonthStr="" ""
	s Year=$p(MonthStr,"-",1)
	s Month=$p(MonthStr,"-",2)
	s MStartDate=$ZDATEH(##Class(web.DHCEQReport).GetReportDate(MonthStr,"1","4"),4)
	s MEndDate=$ZDATEH(##Class(web.DHCEQReport).GetReportDate(MonthStr,"2","4"),4)
	
	s SQLCODE=0
 	s EquipID=0
 	f  s EquipID=$o(^DHCEQBenefitEquipList(0,"Equip",EquipID)) q:(EquipID="")||(SQLCODE'=0)  d
 	.q:(vEquipID'="")&&(vEquipID'=EquipID)
 	.s (Income,PersonTime,ActualWorkLoad,PositiveCases)=0
 	.s (ConsumableFee,ConsumablePayFee)=0
 	.k PLIST
 	.//变量只能在这里初始化
	.s (Income,PersonTime,ActualWorkLoad,PositiveCases,RunTime,WaitingTimes,AverageWorkHour,ActualWorkDays,ConsumableFee,ConsumablePayFee)=0
 	.//根据使用记录表的数据获取收入、工作量、检查人次、阳性率、耗材成本等数据
 	.//用使用记录中两个索引来处理
 	.s SumDataList=##Class(web.DHCEQ.BA.BUSUseRecordStat).GetUseRecordStat(MonthStr,1,EquipID)
 	.s PLIST(3)=EquipID
 	.s PLIST(4)=Year
 	.s PLIST(5)=Month
 	.
 	.s (ActualWorkDays,RunTime)=0
	.s vDate=MStartDate-1
	.f  s vDate=$o(^DHCEQUseRecord(0,"SourceDate",2,1,EquipID,vDate)) Q:(vDate="")||(vDate>MEndDate)  d
 	..s ActualWorkDays=ActualWorkDays+1
 	..s RunTime=RunTime+8
 	.
 	.s PLIST(20)=$p(SumDataList,"^",1)	//Income
 	.s PLIST(21)=$p(SumDataList,"^",6)  //PersonTime   zc2021-11-24
 	.s PLIST(22)=$p(SumDataList,"^",2)	//ActualWorkLoad
 	.s PLIST(23)=$p(SumDataList,"^",9)	//PositiveCases
 	.s PLIST(24)=""	//RunTime
 	.s PLIST(29)=""		//WaitingTimes
 	.s PLIST(30)=""		//AverageWorkHour
 	.s PLIST(31)=ActualWorkDays		//ActualWorkDays
 	.s PLIST(46)="2"
 	.s PLIST(47)=$p(SumDataList,"^",11)	//ConsumableFee
 	.s PLIST(48)=$p(SumDataList,"^",12)	//ConsumablePayFee
 	.s RowidFind=""
 	.&SQL(select UC_RowID into :RowidFind from SQLUSER.DHC_EQUseContext where UC_Year=:Year and UC_Month=:Month and UC_EquipDR=:EquipID)
 	.//根据updateFlag处理是更新还是新增
 	.i RowidFind="" d
 	..&SQL(Insert Into SQLUSER.DHC_EQUseContext Values :PLIST())
 	..s RowidFind=$g(%ROWID)
 	.e  d
	..&SQL(Update SQLUSER.DHC_EQUseContext Values :PLIST() where UC_RowID = :RowidFind)
	..i SQLCODE=100 s SQLCODE=0
	.q:SQLCODE'=0
	.
	.//根据资源类型写使用资源信息
	.s ResourceTypeID=0
	.f  s ResourceTypeID=$o(^DHCEQCCode("DHCEQCResourceType",ResourceTypeID))  quit:ResourceTypeID=""||SQLCODE'=0  d
	..
	..q:##Class(web.DHCEQ.BA.BUSUsedResource).CheckCanUseResource(ResourceTypeID,EquipID)'=1
	..
	..s datalist= $g(^DHCEQCCode("DHCEQCResourceType",ResourceTypeID))
	..q:$p(datalist,"^",4)="Y"
	..s ResourceTypeCode=$p(datalist,"^",1)
	..s ResourceData=##Class(web.DHCEQ.BA.BUSUsedResource).GetResourceDataByCode(ResourceTypeCode,EquipID,Year,Month)
	..s ResourceFee=+$p(ResourceData,"^",1)
	..s Times=+$p(ResourceData,"^",2)
	..s Days=+$p(ResourceData,"^",3)
	..s SQLCODE=0	//add by ZY0296 20220309
	..i ResourceFee>0 s SQLCODE=##class(web.DHCEQ.BA.BUSUsedResource).SaveUsedResourceDate(Year,Month,"1",EquipID,ResourceTypeID,ResourceFee)
	..q:SQLCODE'=0
	..//改维修相关数据
	..i ResourceTypeCode="07"  d
	...i Times>0  d
	....k PLIST
 	....s PLIST(25)=Times		//FailureTimes
 	....s PLIST(26)=Times		//MaintTimes
	....s PLIST(32)=Days		//FailureDays
	....s PLIST(24)=RunTime-Days	//RunTime
	....&SQL(Update SQLUSER.DHC_EQUseContext Values :PLIST() where UC_RowID = :RowidFind)
	....i SQLCODE=100 s SQLCODE=0
	..//改保养相关数据
	..e  i ResourceTypeCode="09"  d
	...i Times>0  d
	....k PLIST
 	....s PLIST(27)=Times			//PMTimes
	....&SQL(Update SQLUSER.DHC_EQUseContext Values :PLIST() where UC_RowID = :RowidFind)
	....i SQLCODE=100 s SQLCODE=0
	..//改检查相关数据
	..e  i ResourceTypeCode="10"  d
	...i Times>0  d
	....k PLIST
 	....s PLIST(28)=Times	//DetectionTimes
	....&SQL(Update SQLUSER.DHC_EQUseContext Values :PLIST() where UC_RowID = :RowidFind)
	....i SQLCODE=100 s SQLCODE=0
	..
	q SQLCODE
	
	/*
	.///add by ZY0276 20210720
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
	*/
}

}
