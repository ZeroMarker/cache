Class web.DHCEQ.EM.BUSMaintPlan Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// MZY0121		2022-04-15		增加维护个人标识PrivateFlag
/// MZY0076	2021-05-25	增加CycleType,MonthStr参数
/// Creator:CZF 20180423
/// Description:保养计划
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSMaintPlan","GetMaintPlanNew","","","","","","","")
Query GetMaintPlanNew(BussType, Name, MaintLocDR, MaintTypeDR, QXType As %String = "", MaintNo As %String = "", Schedule As %String = "", MaintUserDR As %String = "", CycleType As %String = "", MonthStr As %String = "", PrivateFlag As %String = "") As %Query(ROWSPEC = "TRowID:%String,TName:%String,TCycleNum:%String,TCycleUnitDR:%String,TMaintTypeDR:%String,TMaintType:%String,TFromDate:%String,TEndDate:%String,TPreWarnDaysNum:%String,TMaintFee:%String,TMaintLocDR:%String,TMaintLoc:%String,TMaintUserDR:%String,TMaintUser:%String,TMaintModeDR:%String,TMaintMode:%String,TRemark:%String,TStatus:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TModelDR:%String,TModel:%String,TRow:%String,TMaintNo:%String,TLastExDate:%String,TNextExDate:%String,TLastPlanExeID:%String,TStatus:%String,TLastExSchedule:%String,TExeUser:%String,THold1User:%String,TMonthStr:%String,TStage:%String,TAlertType:%String")
{
}

ClassMethod GetMaintPlanNewExecute(ByRef qHandle As %Binary, BussType, Name, MaintLocDR, MaintTypeDR, QXType As %String = "", MaintNo As %String = "", Schedule As %String = "", MaintUserDR As %String = "", CycleType As %String = "", MonthStr As %String = "", PrivateFlag As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1
	s rowid=0
	
	f  s rowid=$o(^DHCEQMaintPlan(rowid))  quit:rowid=""  d
	.d ResetVariablesGetMaintPlanNew
	.s TRowID = rowid
	.q:$p($g(^DHCEQMaintPlan(rowid)),"^",36)="Y"
	.s TName = $p($g(^DHCEQMaintPlan(rowid)),"^",1)
	.q:(Name'="")&&(TName'[Name)
	.s TType = $p($g(^DHCEQMaintPlan(rowid)),"^",2)
	.q:(TType'=BussType)&&(BussType'="")
	.s TSourceType = $p($g(^DHCEQMaintPlan(rowid)),"^",3)
	.;add by csj 20181102
	.s TSourceID = $p($g(^DHCEQMaintPlan(rowid)),"^",4)
	.i TSourceType=1  d
	..s TSourceID=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TSourceID)),"^",2)
	.e  i TSourceType=2  d
	..s TSourceID=$p($g(^DHCEQCCode("DHCEQCMasterItem",TSourceID)),"^",1)
	.e  i TSourceType=3  d
	..s TSourceID=$p($g(^DHCEQEquip(TSourceID)),"^",1)
	.i TSourceType'=""  s TSourceType =$CASE(TSourceType,"1":"设备分类","2":"设备项","3":"设备")
	.;end by csj 20181102
	.s TStatus = $p($g(^DHCEQMaintPlan(rowid)),"^",26)
	.q:TStatus'=2
	.s TModelDR =$p($g(^DHCEQMaintPlan(rowid)),"^",5)
	.i TModelDR'="" s TModel=$p($G(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.s TCycleNum = $p($g(^DHCEQMaintPlan(rowid)),"^",7)
	.s TCycleUnitDR = $p($g(^DHCEQMaintPlan(rowid)),"^",8)
	.s TCycleUnit=""
	.i TCycleUnitDR '="" s TCycleUnit = $p($g(^DHCEQCCode("DHCEQCCycleUnit",TCycleUnitDR)),"^",2)
	.s TCycleNum=TCycleNum_TCycleUnit
	.s TMaintTypeDR = $p($g(^DHCEQMaintPlan(rowid)),"^",9)
	.q:((MaintTypeDR'="")&&(TMaintTypeDR'=MaintTypeDR))
	.i TMaintTypeDR '="" s TMaintType = $p($g(^DHCEQCCode("DHCEQCMaintType",TMaintTypeDR)),"^",2)
	.s TFromDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaintPlan(rowid)),"^",10),"date")
	.s TEndDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaintPlan(rowid)),"^",11),"date")
	.s TPreWarnDaysNum = $p($g(^DHCEQMaintPlan(rowid)),"^",12)
	.s TMaintFee = $p($g(^DHCEQMaintPlan(rowid)),"^",13)
	.S TMaintFee=TMaintFee+##Class(web.DHCEQ.EM.BUSMaintPlan).GetOtherFee(rowid,1)
	.s TMaintFee=##Class(web.DHCEQCommon).FormatNumber(TMaintFee,"")
	.s TMaintLocDR = $p($g(^DHCEQMaintPlan(rowid)),"^",14)
	.q:(TMaintLocDR'=MaintLocDR)&(MaintLocDR'="")
	.q:((TMaintLocDR'="")&&(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TMaintLocDR)))) //2010-10-28 DJ
	.i TMaintLocDR '="" s TMaintLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TMaintLocDR)
	.s TMaintUserDR = $p($g(^DHCEQMaintPlan(rowid)),"^",15)
	.q:(PrivateFlag=1)&&(##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))'=TMaintUserDR)	;MZY0121		2022-04-15
	.q:(MaintUserDR'="")&&(MaintUserDR'=TMaintUserDR)
	.i TMaintUserDR '="" s TMaintUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TMaintUserDR)
	.;modify by lmm 2019-01-12 end 804709
	.s TMaintModeDR = $p($g(^DHCEQMaintPlan(rowid)),"^",16)
	.i TMaintModeDR '="" s TMaintMode = $p($g(^DHCEQCCode("DHCEQCMaintMode",TMaintModeDR)),"^",2)
	.s TRemark = $p($g(^DHCEQMaintPlan(rowid)),"^",25)
	.s THold1=$p($g(^DHCEQMaintPlan(rowid)),"^",40)
	.s THold1User = ##Class(web.DHCEQCommon).GetTrakNameByID("user", THold1)	//czf 2021-02-01 1756587
	.s THold2=$p($g(^DHCEQMaintPlan(rowid)),"^",41)
	.s THold3=$p($g(^DHCEQMaintPlan(rowid)),"^",42)
	.s THold4=$p($g(^DHCEQMaintPlan(rowid)),"^",43)
	.s THold5=$p($g(^DHCEQMaintPlan(rowid)),"^",44)
	.s TTotalFee=$p($g(^DHCEQMaintPlan(rowid)),"^",45)
	.s TCycleType=$p($g(^DHCEQMaintPlan(rowid)),"^",46)	//CZF0134 2021-02-23
	.;q:(TCycleType=1)||(TCycleType=4)	;不显示固定周期和风险等级计划	add by czf 20190401
	.q:(CycleType'="")&&(TCycleType'=CycleType)
	.q:((TCycleType=3)||(TCycleType=6))&&(##Class(web.DHCEQ.EM.BUSMaintPlan).CheckMaintPlanExecute(rowid)=1)   /// Modfied by zc0122 2022-10-12 一次性计划过滤
	.s TFeeType=$p($g(^DHCEQMaintPlan(rowid)),"^",47)
	.s TSDate=$p($g(^DHCEQMaintPlan(rowid)),"^",48)
	.s TEDate=$p($g(^DHCEQMaintPlan(rowid)),"^",49)
	.// MZY0101	2296655		2021-11-22
	.; "5":"固定月份(周期)","6":"固定月份(一次)"
	.;i (CycleType=5)||(CycleType=6) 
	.s TMonthStr=$E(##Class(web.DHCEQCommon).TransValueToPage(TSDate,"date"),0,7)	;取开始日期的年月
	.q:(MonthStr'="")&&(MonthStr'=TMonthStr)
	.s TMaintNo=$p($g(^DHCEQMaintPlan(rowid)),"^",50)
	.q:(MaintNo'="")&&(TMaintNo'=MaintNo)
	.s TWarnInfo=..GetWarnDaysNum(rowid)
	.s TLastExDate=$p(TWarnInfo,"^",2)
	.s TLastExDate=##Class(web.DHCEQCommon).TransValueToPage(TLastExDate,"date")
	.s TNextExDate=$p(TWarnInfo,"^",3)
	.q:(TNextExDate-TPreWarnDaysNum)>(+$h)  //Modfied by zc0125 未到预警期的计划不显示
	.;Modify by zx 2022-06-24 BUG:2744761
	.;输出预警类型:1 超期预警;2 正常预警;
	.i TNextExDate<=+$H s TAlertType=1
	.i TNextExDate-TPreWarnDaysNum<=+$H<TNextExDate s TAlertType=2
	.s TNextExDate=##Class(web.DHCEQCommon).TransValueToPage(TNextExDate,"date")
	.s TLastExSchedule="未执行"
	.s DisExecutedNum=0
	.s TLastPlanExeID=$o(^DHCEQPlanExecute(0,"MaintPlan",rowid,""),-1)
	.i TLastPlanExeID'="" d
	..s TStatus=$p($g(^DHCEQPlanExecute(TLastPlanExeID)),"^",6)
	..i TStatus=1 s TLastPlanExeID=""
	..q:TStatus=1		//执行单已完成
	..s TExeUserDR=$p($g(^DHCEQPlanExecute(TLastPlanExeID)),"^",9)
	..s TExeUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", TExeUserDR)
	..s DisExecutedNum=$p($g(^DHCEQPlanExecute(TLastPlanExeID)),"^",4)-$p($g(^DHCEQPlanExecute(TLastPlanExeID)),"^",5)
	..i DisExecutedNum>0 s TLastExSchedule=DisExecutedNum_"台未执行"
	..e  s TLastExSchedule="待完成"
	.q:(Schedule=1)&&(TLastExSchedule'="未执行")  ;modify by lmm 2019-01-12 804696
	.q:(Schedule=2)&&(TLastExSchedule="未执行")
	.;;q:(TLastPlanExeID="")&&($p(TWarnInfo,"^",1)=0)	MZY0120	2022-04-13
	.;s TWarnIcon=##Class(web.DHCEQ.EM.BUSMaintPlan).GetWarnIcon(TNextExDate,TPreWarnDaysNum)
	.;s TName=TWarnIcon_"^"_TName
	.// MZY0076	2021-05-25
	.s ExecuteIDs=##Class(web.DHCEQ.EM.BUSMaintPlan).GetExecuteIDs(rowid)
	.i ExecuteIDs'="" d
	..s Length=$l(ExecuteIDs,",")
	..for i=1:1:Length  d
	...s ExecuteID=$p(ExecuteIDs,",",i)
	...if (TStage'="") s TStage=TStage_","
	...s TStage=TStage_##Class(web.DHCEQCommon).GetTrakNameByID("user", $p($g(^DHCEQPlanExecute(ExecuteID)),"^",9))
	..s TStage=TStage_"执行中."
	.
	.d OutputRowGetMaintPlanNew
	Quit $$$OK
OutputRowGetMaintPlanNew
	s Data=$lb(TRowID,TName,TCycleNum,TCycleUnitDR,TMaintTypeDR,TMaintType,TFromDate,TEndDate,TPreWarnDaysNum,TMaintFee,TMaintLocDR,TMaintLoc,TMaintUserDR,TMaintUser,TMaintModeDR,TMaintMode,TRemark,TStatus,THold1,THold2,THold3,THold4,THold5,TModelDR,TModel,TRow,TMaintNo,TLastExDate,TNextExDate,TLastPlanExeID,TStatus,TLastExSchedule,TExeUser,THold1User,TMonthStr,TStage,TAlertType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set TRow=TRow+1
	quit
ResetVariablesGetMaintPlanNew
	s (TRowID,TName,TCycleNum,TCycleUnitDR,TMaintTypeDR,TMaintType,TFromDate,TEndDate,TPreWarnDaysNum,TMaintFee,TMaintLocDR,TMaintLoc,TMaintUserDR,TMaintUser,TMaintModeDR,TMaintMode,TRemark,TStatus,THold1,THold2,THold3,THold4,THold5,TModelDR,TModel,TMaintNo,TLastExDate,TNextExDate,TLastPlanExeID,TStatus,TWarnInfo,TExeUserDR,TExeUser,THold1User,TMonthStr,TStage,TAlertType)=""
	quit
}

ClassMethod GetMaintPlanNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintPlanNewExecute ]
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

ClassMethod GetMaintPlanNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaintPlanNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Command:w ##Class(web.DHCEQ.EM.BUSMaintPlan).GetLastPlanExelID("4","15","5")
/// modify by lmm 2020-08-19 
/// desc:获取该设备维护计划的上次执行维护记录id
ClassMethod GetLastPlanExelID(MaintPlanID, PlanExeID, EquipDR)
{
	i (MaintPlanID="")||(PlanExeID="")||(EquipDR="") q ""
	s (LastPERowID,PELRowID,MaintID)=""
	s PERowID=0
	f  s PERowID=$o(^DHCEQPlanExecute(0,"MaintPlan",MaintPlanID,PERowID)) quit:(PERowID="")||(PERowID=PlanExeID)  d
	.s LastPERowID=PERowID
	i LastPERowID'=""  d
	.s PELRowID=0
	.f  s PELRowID=$o(^DHCEQPlanExecuteList(0,"PlanExecute",LastPERowID,PELRowID)) quit:(PELRowID="")  d
	..s LastEquipDR=$p($g(^DHCEQPlanExecuteList(PELRowID)),"^",2)
	..q:(LastEquipDR'=EquipDR)
	..s MaintID = $p($g(^DHCEQPlanExecuteList(PELRowID)),"^",3)
	q MaintID
}

/// MZY0099	2160617		2021-11-13	增加传入参数:FromDate
/// Creator:Add by CZF 20180503
/// Description:根据计划单ID获取计划预警信息
/// w ##class(web.DHCEQ.EM.BUSMaintPlan).GetWarnDaysNum(2)
ClassMethod GetWarnDaysNum(MaintPlanID, FromDate As %String = "")
{
	n BussType,CycleNum,CycleUnitDR,CycleDays,CycleType,TempDate,LastDate,NextDate,id,MaintDate,pass
	s pass=1
	s (TempDate,LastDate,NextDate)=""
	s BussType = $p($g(^DHCEQMaintPlan(MaintPlanID)),"^",2)
	s CycleNum = $p($g(^DHCEQMaintPlan(MaintPlanID)),"^",7)
	s CycleUnitDR = $p($g(^DHCEQMaintPlan(MaintPlanID)),"^",8)
	i FromDate="" s FromDate = $p($g(^DHCEQMaintPlan(MaintPlanID)),"^",10)	;启用日期
	s PreWarnDaysNum = $p($g(^DHCEQMaintPlan(MaintPlanID)),"^",12)
	s CycleType=$p($g(^DHCEQMaintPlan(MaintPlanID)),"^",46)	//CZF0134 2021-02-23 begin
	//s TempFlag=$p($g(^DHCEQMaintPlan(MaintPlanID)),"^",46)
	//s FixTimeFlag=$p($g(^DHCEQMaintPlan(MaintPlanID)),"^",47)
	s SDate=$p($g(^DHCEQMaintPlan(MaintPlanID)),"^",48)
	s EDate=$p($g(^DHCEQMaintPlan(MaintPlanID)),"^",49)
	s LastPlanExeID=$o(^DHCEQPlanExecute(0,"MaintPlan",MaintPlanID,""),-1)
	i LastPlanExeID=""
	{
		// MZY0083	2034404		2021-07-19
		s LastDate=""
		if (CycleType=1)||(CycleType=4)
		{
			s NextDate=FromDate
		}
		else
		{
			s NextDate=SDate
			i NextDate="" s NextDate=FromDate	// MZY0085	1975493		2021-07-28
		}
	}
	else
	{
		// MZY0083	2034404		2021-07-19
		s LastDate=$p($g(^DHCEQPlanExecute(LastPlanExeID)),"^",7)
		i (CycleType=3)||(CycleType=6)	;临时计划
		{
			s NextDate=""
		}
		elseif (CycleType=2)||(CycleType=5)	;固定时间
		{
			i (CycleNum'="")
			{
				s TempDate=$zd(LastDate,3)
				i CycleUnitDR=1
				{
					s $p(TempDate,"-",1)=$p(TempDate,"-",1)+CycleNum
				}
				i CycleUnitDR=2
				{
					s $p(TempDate,"-",2)=$p(TempDate,"-",2)+CycleNum
					i $p(TempDate,"-",2)>12
					{
						s $p(TempDate,"-",2)=$p(TempDate,"-",2)-12
						s $p(TempDate,"-",1)=$p(TempDate,"-",1)+1
					}
				}
				i CycleUnitDR=3
				{
					s TempDate=LastDate+CycleNum
					s TempDate=$zd(TempDate,3)
				}
				s TempDate=$p(TempDate,"-",1)
			}
			else
			{
				s TempDate=$p($zd(LastDate,3),"-",1)+1
			}		//CZF0134 2021-02-23 end
			s TempDate=$ZDH(TempDate_"-"_$p($zd(SDate,3),"-",2,3),3)
			i TempDate>EDate
			{
				s NextDate=""
			}
			else
			{
				s NextDate=TempDate
			}
		}
		else		;固定周期
		{
			s TempDate=$zd(LastDate,3)
			i CycleUnitDR=1
			{
				s $p(TempDate,"-",1)=$p(TempDate,"-",1)+CycleNum
				s NextDate=##Class(web.DHCEQCommon).TransValueFromPage(TempDate,"date")
			}
			i CycleUnitDR=2
			{
				s $p(TempDate,"-",2)=$p(TempDate,"-",2)+CycleNum
				If $p(TempDate,"-",2)>12
				{
					s $p(TempDate,"-",2)=$p(TempDate,"-",2)-12
					s $p(TempDate,"-",1)=$p(TempDate,"-",1)+1
				}
			    s NextDate=##Class(web.DHCEQCommon).TransValueFromPage(TempDate,"date")
			}
			i CycleUnitDR=3
			{
				Set NextDate=LastDate+CycleNum
			}
		}
	}
	i (NextDate="") 
	{
		s pass=0
	}
	elseif(NextDate>($p($h,",",1)+PreWarnDaysNum)) 
	{
		s pass=0
	}
	
	quit pass_"^"_LastDate_"^"_NextDate
}

/// Creator:CZF 20180423
/// Description:执行计划设备明细
/// add by lmm 2020-04-24 添加入参：ExecuteFlag
/// Command:d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSMaintPlan","GetPlanExecuteList","4","15","","")
/// modified by czf 新增入参TMPType和TMaintTypeDR
Query GetPlanExecuteList(MPID, PEID, MaintLocDR As %String = "", MaintDR As %String = "", EquipDR As %String = "", ExecuteFlag As %String = "") As %Query(ROWSPEC = "TRowID:%String,TPlanExecuteID:%String,TEquipID:%String,TEquipNo:%String,TStockLocDR:%String,TStockLoc:%String,TName:%String,TModelDR:%String,TModel:%String,TMaintID:%String,TExecuteFlag:%String,TMaintLocDR:%String,TMaintLoc:%String,TExecuteDate:%String,TExecuteTime:%String,TResult:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TRow:%String,TExeUserDR:%String,TExeUser:%String,TPlanExecuteNo:%String,TMPType:%String,TMaintTypeDR:%String,TLastExecuteDate:%String,TCertificateNo:%String,TMaintDate:%String,TAffixDR:%String,TAffix:%String")
{
}

ClassMethod GetPlanExecuteListExecute(ByRef qHandle As %Binary, MPID, PEID, MaintLocDR As %String = "", MaintDR As %String = "", EquipDR As %String = "", ExecuteFlag As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1
	i (MPID="") Quit $$$OK
	
	s PERowID=0
	f  s PERowID=$o(^DHCEQPlanExecute(0,"MaintPlan",MPID,PERowID)) quit:PERowID=""  d
	.q:(PEID'="")&&(PEID'=PERowID)
	.s rowid=0
	.f  s rowid=$o(^DHCEQPlanExecuteList(0,"PlanExecute",PERowID,rowid))  quit:rowid=""  d
	..d ResetVariablesGetPlanExecuteList
	..s TRowID = rowid
	..s TPlanExecuteID = PERowID
	..s TPlanExecuteNo=$p($g(^DHCEQPlanExecute(PERowID)),"^",1)	//add by csj 20181103
	..s TEquipID = $p($g(^DHCEQPlanExecuteList(rowid)),"^",2)
	..q:(EquipDR'="")&&(EquipDR'=TEquipID)	//add by csj 20181103
	..;i TEquipID'="" d	// MZY0076	2021-05-25
	..;add by lmm 2020-08-19 begin
	..s LastMaintID= ##Class(web.DHCEQ.EM.BUSMaintPlan).GetLastPlanExelID(MPID,PERowID,TEquipID)
	..i LastMaintID'="" d
	...s TLastExecuteDate=$p($g(^DHCEQMaint(LastMaintID)),"^",5)  //modify by lmm 2020-11-18
	...s TLastExecuteDate=##Class(web.DHCEQCommon).TransValueToPage(TLastExecuteDate,"date")
	..;add by lmm 2020-08-19 end
	..s EQStatus= $p($g(^DHCEQEquip(TEquipID)),"^",38)
	..q:EQStatus="3"  //add by sjh SJH0039 2020-11-13  过滤已报废设备
	..s TEquipNo = $p($g(^DHCEQEquip(TEquipID)),"^",71)
	..s TStockLocDR = $p($g(^DHCEQEquip(TEquipID)),"^",67)
	..s TStockLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TStockLocDR)
	..s TName = $p($g(^DHCEQEquip(TEquipID)),"^",1)
	..s TModelDR = $p($g(^DHCEQEquip(TEquipID)),"^",3)
	..s TModel=##Class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
	..s TMaintID = $p($g(^DHCEQPlanExecuteList(rowid)),"^",3)
	..q:(MaintDR'="")&&(TMaintID'=MaintDR)		//add by csj 20181103
	..s TExecuteFlag = $p($g(^DHCEQPlanExecuteList(rowid)),"^",4)
	..q:(ExecuteFlag'="")&&(TExecuteFlag'=ExecuteFlag)   //add by lmm 2020-04-24
	..i TExecuteFlag="Y" s TExecuteFlag="已执行"
	..e  s TExecuteFlag="未执行"
	..i TMaintID'="" d
	...s TExecuteDate=$p($g(^DHCEQMaint(TMaintID)),"^",5)  //modify by lmm 2020-11-18
	...s TExecuteDate=##Class(web.DHCEQCommon).TransValueToPage(TExecuteDate,"date")
	...s THold1=$p($g(^DHCEQMaint(TMaintID)),"^",9)		// MZY0073	1837863		2021-04-26
	...s TExecuteTime=$p($g(^DHCEQMaint(TMaintID)),"^",20)
	...s TExecuteTime=##Class(web.DHCEQCommon).TransValueToPage(TExecuteTime,"time")
	...s TAffixDR=$p($g(^DHCEQMaint(TMaintID)),"^",27)		//Add By DJ 2021-07-12
	...i TAffixDR'="" s TAffix=$p($g(^DHCEQAffix(TAffixDR)),"^",4)
	...;modify by lmm 2020-09-07 1485651
	...s TCertificateID=$o(^DHCEQCertificateInfo(0,"Source",4,TMaintID,""))
	...i TCertificateID'=""  d
	....s TCertificateNo=$p($g(^DHCEQCertificateInfo(TCertificateID)),"^",4)
	....s TMaintDate=$p($g(^DHCEQCertificateInfo(TCertificateID)),"^",8)
	....s TMaintDate=##Class(web.DHCEQCommon).TransValueToPage(TMaintDate,"date")
	..s TResult =$p($g(^DHCEQPlanExecuteList(rowid)),"^",5)
	..s TRemark =$p($g(^DHCEQPlanExecuteList(rowid)),"^",6)
	..i THold1="" s THold1=$p($g(^DHCEQPlanExecuteList(rowid)),"^",7)	// MZY0073	1837863		2021-04-26
	..s THold2=$p($g(^DHCEQPlanExecuteList(rowid)),"^",8)
	..s THold3=$p($g(^DHCEQPlanExecuteList(rowid)),"^",9)
	..s THold4=$p($g(^DHCEQPlanExecuteList(rowid)),"^",10)
	..s THold5=$p($g(^DHCEQPlanExecuteList(rowid)),"^",11)
	..s TExeUserDR=$p($g(^DHCEQPlanExecute(PERowID)),"^",9)
	..s TExeUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TExeUserDR)
	..s TMPType=$p($g(^DHCEQMaintPlan(MPID)),"^",2)		
	..s TMaintTypeDR=$p($g(^DHCEQMaintPlan(MPID)),"^",9)
	..d OutputRowGetPlanExecuteList
	Quit $$$OK
	
OutputRowGetPlanExecuteList
	s Data=$lb(TRowID,TPlanExecuteID,TEquipID,TEquipNo,TStockLocDR,TStockLoc,TName,TModelDR,TModel,TMaintID,TExecuteFlag,TMaintLocDR,TMaintLoc,TExecuteDate,TExecuteTime,TResult,THold1,THold2,THold3,THold4,THold5,TRow,TExeUserDR,TExeUser,TPlanExecuteNo,TMPType,TMaintTypeDR,TLastExecuteDate,TCertificateNo,TMaintDate,TAffixDR,TAffix)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set TRow=TRow+1  //add by zx 2015-09-17
	quit
ResetVariablesGetPlanExecuteList
	s (TRowID,TPlanExecuteID,TEquipID,TEquipNo,TStockLocDR,TStockLoc,TName,TModelDR,TModel,TMaintID,TExecuteFlag,TMaintLocDR,TMaintLoc,TExecuteDate,TExecuteTime,TResult,THold1,THold2,THold3,THold4,THold5,TExeUserDR,TExeUser,TPlanExecuteNo,TMPType,TMaintTypeDR,LastMaintID,TLastExecuteDate,TCertificateID,TCertificateNo,TMaintDate,TAffixDR,TAffix)=""
	quit
}

ClassMethod GetPlanExecuteListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPlanExecuteListExecute ]
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

ClassMethod GetPlanExecuteListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPlanExecuteListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSMaintPlan","GetPlanName",2,"",11434,571,"","","",5)
/// Modify By QW20160202 增加筛选条件,TypeCode As %String = "" 区分计量和检查
/// Modify by zx 2020-09-02 移动端增加类组参数
Query GetPlanName(BussType, Name, EquipDR As %String = "", MaintLocDR As %String = "", QXType As %String = "", CurLocID As %String = "", TypeCode As %String = "", MaintTypeDR As %String = "", CurGroupID As %String = "") As %Query(ROWSPEC = "TName:%String,TRowID:%String,TSourceType:%String,TSourceID:%String,TPlanExecuteID:%String,TPlanExecuteListID:%String")
{
}

ClassMethod GetPlanNameExecute(ByRef qHandle As %Binary, BussType, Name, EquipDR, MaintLocDR, QXType As %String = "", CurLocID As %String = "", TypeCode As %String = "", MaintTypeDR As %String = "", CurGroupID As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	;s ^DHCEQMozy("GetPlanName")=BussType
	i CurLocID="" s CurLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	s index=1
	s rowid=0
	f  s rowid=$o(^DHCEQMaintPlan(0,"Type",BussType,rowid))  quit:rowid=""  d
	.d ResetVariablesGetPlanName
	.s TRowID = rowid
	.q:(MaintTypeDR="5")&&(EquipDR'="")&&(##Class(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttributeYN(EquipDR)'="Y")	//add by csj 2020-03-23  排除非计量设备 需求号：1229637
	.q:(TypeCode'="")&&($p($g(^DHCEQMaintPlan(rowid)),"^",9)="")  ;Add By QW20160202
	.i TypeCode'="" q:$p($g(^DHCEQCCode("DHCEQCMaintType",$p($g(^DHCEQMaintPlan(rowid)),"^",9))),"^",1)'=TypeCode ;Add By QW20160202
	.Quit:$p($g(^DHCEQMaintPlan(rowid)),"^",36)="Y"
	.Quit:$p($g(^DHCEQMaintPlan(rowid)),"^",26)'="2"
	.s TName = $p($g(^DHCEQMaintPlan(rowid)),"^",1)
	.q:(Name'="")&&(TName'[Name)
	.q:(EquipDR'="")&&((","_##Class(web.DHCEQ.EM.BUSMaintPlan).GetMaintEquips("2",rowid,"",CurGroupID)_",")'[(","_EquipDR_","))	//modify by lmm 2020-04-26 1290268
	.s TSourceType = $p($g(^DHCEQMaintPlan(rowid)),"^",3)
	.s TSourceID = $p($g(^DHCEQMaintPlan(rowid)),"^",4)
	.i TSourceType=1  d
	..s TSourceID=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TSourceID)),"^",2)
	.e  i TSourceType=2  d
	..s TSourceID=$p($g(^DHCEQCCode("DHCEQCMasterItem",TSourceID)),"^",1)
	.e  i TSourceType=3  d
	..s TSourceID=$p($g(^DHCEQEquip(TSourceID)),"^",1)
	.i TSourceType'=""  s TSourceType =$CASE(TSourceType,"1":"设备分类","2":"设备项","3":"设备")
	.s TMaintFee = $p($g(^DHCEQMaintPlan(rowid)),"^",13)
	.S TMaintFee=TMaintFee+##Class(web.DHCEQ.EM.BUSMaintPlan).GetOtherFee(rowid,1)
	.s TMaintLocDR = $p($g(^DHCEQMaintPlan(rowid)),"^",14)
	.q:(TMaintLocDR'=MaintLocDR)&(MaintLocDR'="")
	.q:((TMaintLocDR'="")&&(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TMaintLocDR,CurLocID,CurGroupID)))) //2010-10-28 DJ
	.i TMaintLocDR '="" s TMaintLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TMaintLocDR)
	.;需求号:265786	Mozy	2016-10-13
	.s TMaintTypeDR = $p($g(^DHCEQMaintPlan(rowid)),"^",9)
	.q:(MaintTypeDR'="")&&(TMaintTypeDR'=MaintTypeDR)
	.;add by mwz 2019-12-15 1131347 begin
	.s TEquipRangeStr=##Class(web.DHCEQMaintPlanNew).GetRangeDesc("2",rowid,TSourceType,TSourceID)  
	.s TEquipRangeType=$p(TEquipRangeStr,"#",1)
	.s TEquipRangeDesc=$p(TEquipRangeStr,"#",2)
	.q:(TEquipRangeType="")||(TEquipRangeDesc="")  
	.i ($l(TEquipRangeType,",")>3) s TEquipRangeType=$p(TEquipRangeType,",",1)_","_$p(TEquipRangeType,",",2)_".."
	.i ($l(TEquipRangeDesc,",")>3) s TEquipRangeDesc=$p(TEquipRangeDesc,",",1)_","_$p(TEquipRangeDesc,",",2)_".."
	.s TSourceType=TEquipRangeType
	.s TSourceID=TEquipRangeDesc
	.;add by mwz 2019-12-15 1131347 end
	.//MZY0119	2573140		2022-04-07 获取最近一次的执行记录单
	.s TPlanExecuteID=+$o(^DHCEQPlanExecute(0,"MaintPlan",rowid,""),-1)
	.;q:TPlanExecuteID=""
	.;q:($p($g(^DHCEQPlanExecute(TPlanExecuteID)),"^",6)'="0")
	.s CurPlanExecuteListID=0
	.f  s CurPlanExecuteListID=$o(^DHCEQPlanExecuteList(0,"PlanExecute",TPlanExecuteID,CurPlanExecuteListID)) q:(CurPlanExecuteListID="")||(TPlanExecuteListID'="")  d
	..q:($p($g(^DHCEQPlanExecuteList(CurPlanExecuteListID)),"^",2)'=EquipDR)
	..s TPlanExecuteListID=CurPlanExecuteListID
	.d OutputRowGetPlanName
	Quit $$$OK
OutputRowGetPlanName
	s Data=$lb(TName,TRowID,TSourceType,TSourceID,TPlanExecuteID,TPlanExecuteListID)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetPlanName
	s (TRowID,TName,TSourceType,TSourceID,TPlanExecuteID,TPlanExecuteListID)=""
	quit
}

ClassMethod GetPlanNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPlanNameExecute ]
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

ClassMethod GetPlanNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPlanNameExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by lmm 2018-10-18
/// 描述：获取维护单信息
/// 入参：RowID 维护id
/// w ##Class(web.DHCEQ.EM.BUSMaintPlan).GetOneMaintPlan("1")
ClassMethod GetOneMaintPlan(RowID As %Library.String)
{
	new result,resultex,No
	s (result,resultex,No)=""
	s result= $g(^DHCEQMaintPlan(RowID))
	s resultex=resultex_"^"	;SourceType				1
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$CASE($p(result,"^",3),"1":"设备分类","2":"设备项","3":"设备")
	s resultex=resultex_"^"	;SourceID
	i ($p(result,"^",3)'="")&&($p(result,"^",4)'="")  d
	.i $p(result,"^",3)=1  d
	..s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCEquipeCat",$p(result,"^",4))),"^",2)
	.e  i $p(result,"^",3)=2  d
	..s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMasterItem",$p(result,"^",4))),"^",1)
	.e  i $p(result,"^",3)=3  d
	..s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",4))),"^",1)		;2
	..s No =$p($g(^DHCEQEquip($p(result,"^",4))),"^",71)
	
	s resultex=resultex_"^"	;ModelDR			3
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCModel",$p(result,"^",5))),"^",2)
	s resultex=resultex_"^"	;CycleUnitDR		4
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCCycleUnit",$p(result,"^",8))),"^",2)
	s resultex=resultex_"^"	;MaintTypeDR		5
	i $p(result,"^",9)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMaintType",$p(result,"^",9))),"^",2)
	s $p(result,"^",10)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",10),"date")	;FromDate
	// MZY0076	2021-05-25
	i ($p(result,"^",10)="")&&(($p(result,"^",46)=5)||($p(result,"^",46)=6)) d
	.; "5":"固定月份(周期)","6":"固定月份(一次)"
	.s $p(result,"^",10)=$E(##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",48),"date"),0,7)	;SDate
	s $p(result,"^",11)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",11),"date")	;EndDate	
	//s $p(result,"^",13)=$p(result,"^",13)+##Class(web.DHCEQ.EM.BUSMaintPlan).GetOtherFee(RowID)	;maintFee	
	s $p(result,"^",13)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",13),"")
	s resultex=resultex_"^"	;MaintLocDR			6
	i $p(result,"^",14)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",14))
	s resultex=resultex_"^"	;MaintUserDR		7
	i $p(result,"^",15)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",15))
	s resultex=resultex_"^"	;MaintModeDR		8
	i $p(result,"^",16)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMaintMode",$p(result,"^",16))),"^",2)
	s resultex=resultex_"^"	;ContractDR			9
	i $p(result,"^",17)'=""  d
	.s resultex=resultex_$p($g(^DHCEQContract($p(result,"^",17))),"^",2)
	s $p(result,"^",18)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",18),"bool")	;MeasureFlag
	s resultex=resultex_"^"	;MeasureDeptDR		10
	i $p(result,"^",19)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMeasureDept",$p(result,"^",19))),"^",1)
	s resultex=resultex_"^"	;ServiceDR			11
	i $p(result,"^",22)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("service",$p(result,"^",22)) //CZF0093	modify by zyq 2022-12-06
	s resultex=resultex_"^"	;Status				12
	i $p(result,"^",26)'=""  d
	.;modify by lmm 2020-04-27 1285572
	.s resultex=resultex_$CASE($p(result,"^",26),"0":"新增","1":"提交","2":"审核","3":"作废")
	s resultex=resultex_"^"	;UpdateUserDR		13
	i $p(result,"^",27)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",27))
	s $p(result,"^",28)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",28),"date")	;UpdateDate
	s resultex=resultex_"^"	;SubmitUserDR		14
	i $p(result,"^",30)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",30))
	s $p(result,"^",31)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",31),"date")	;SubmitDate
	s resultex=resultex_"^"	;AuditUserDR		15
	i $p(result,"^",33)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",33))
	s $p(result,"^",34)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",34),"date")	;AuditDate
	s $p(result,"^",36)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",36),"bool")	;InvalidFlag
	s resultex=resultex_"^"	;DelUserDR			16
	i $p(result,"^",37)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",37))
	s $p(result,"^",38)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",38),"date")	;DelDate
	s MonthStr=""
	i $p(result,"^",48)'=""  d
	.s MonthStr=$P($ZD($p(result,"^",48),3),"-",1,2)
	.s $p(result,"^",48)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",48),"date")
	i $p(result,"^",49)'=""  d
	.s $p(result,"^",49)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",49),"date")
	s resultex=resultex_"^"	;No					17
	
	i No'=""  d
	.s resultex=resultex_No
	s resultex=resultex_"^"
	i $p(result,"^",40)'=""  d		//czf 2021-02-01 1756587
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",40))
	// MZY0076	2021-05-25
	s Stage=""
	s ExecuteIDs=##Class(web.DHCEQ.EM.BUSMaintPlan).GetExecuteIDs(RowID)
	i ExecuteIDs="" d
	.s Stage="未执行!"
	e  d
	.s Length=$l(ExecuteIDs,",")
	.for i=1:1:Length  d
	..s ExecuteID=$p(ExecuteIDs,",",i)
	..if (Stage'="") s Stage=Stage_","
	..s Stage=Stage_##Class(web.DHCEQCommon).GetTrakNameByID("user", $p($g(^DHCEQPlanExecute(ExecuteID)),"^",9))
	.s Stage=Stage_"执行中."
	s resultex=resultex_"^"_Stage
	s resultex=resultex_"^"_MonthStr	// MZY0093	2021-09-08
	
	s result=result_resultex
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

/// ----------------------------------
/// add:zy 2011-03-23  No ZY0066
/// 描述:新增、更新
/// w ##Class(web.DHCEQ.EM.BUSMaintPlan).SaveData("^22^2^^^^^1^2^^^^24^33^^3^^^^^3^^^^^3^0^^^^^^^^^true^^","^^2^^Y^N^N^false^false^false","^1^2,3^Y")
/// ----------------------------------
ClassMethod SaveData(val, EquipRangeval, EquipRangevalList)
{
	new RowID,User,Date,Time
	k PLIST
	Set $ZT="ERRORSave"
	s User=##class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))   //add by lmm 2018-11-05
	s Date=+$H
	s Time=$P($H,",",2)
	s RowID = $p(val,"^",1)	;RowID
	
	s PLIST(2) = $p(val,"^",2)	;Name
	s PLIST(3) = $p(val,"^",3)	;Type
	s PLIST(4) = $p(val,"^",4)	;SourceType
	s PLIST(5) = $p(val,"^",5)	;SourceIDDR
	s PLIST(6) = $p(val,"^",6)	;ModelDR
	s PLIST(7) = $p(val,"^",7)	;Content
	s PLIST(8) = $p(val,"^",8)	;CycleNum
	s PLIST(9) = $p(val,"^",9)	;CycleUnitDR
	s PLIST(10) = $p(val,"^",10)	;MaintTypeDR
	s PLIST(11) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",11),"date")	;FromDate
	s PLIST(12) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",12),"date")	;EndDate
	s PLIST(13) = $p(val,"^",13)	;PreWarnDaysNum
	s PLIST(14) = $p(val,"^",14)	;MaintFee
	//add by lmm 2018-12-18 begin
	i $p(val,"^",15)=""  d
	.s MaintLocDR=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	e  d
	.s MaintLocDR=$p(val,"^",15)
	s PLIST(15) = MaintLocDR	;MaintLocDR
	//add by lmm 2018-12-18 end
	s PLIST(16) = $p(val,"^",16)	;MaintUserDR
	s PLIST(17) = $p(val,"^",17)	;MaintModeDR
	s PLIST(18) = $p(val,"^",18)	;ContractDR
	s PLIST(19) = $p(val,"^",19)	;MeasureFlag
	s PLIST(20) = $p(val,"^",20)	;MeasureDeptDR
	s PLIST(21) = $p(val,"^",21)	;MeasureHandler
	s PLIST(22) = $p(val,"^",22)	;MeasureTel
	s PLIST(23) = $p(val,"^",23)	;ServiceDR
	s PLIST(24) = $p(val,"^",24)	;ServiceHandler
	s PLIST(25) = $p(val,"^",25)	;ServiceTel
	s PLIST(26) = $p(val,"^",26)	;Remark
	s PLIST(27) = "0"				;Status
	s PLIST(28) = User				;UpdateUserDR
	s PLIST(29) = Date				;UpdateDate
	s PLIST(30) = Time				;UpdateTime
	/*	
	s PLIST(31) = $p(val,"^",2)	;SubmitUserDR
	s PLIST(32) = $p(val,"^",2)	;SubmitDate
	s PLIST(33) = $p(val,"^",2)	;SubmitTime
	s PLIST(34) = $p(val,"^",2)	;AuditUserDR
	s PLIST(35) = $p(val,"^",2)	;AuditDate
	s PLIST(36) = $p(val,"^",2)	;AuditTime
	*/
	s PLIST(37) = "N"  ;$p(val,"^",28)	;InvalidFlag
	/*
	s PLIST(38) = $p(val,"^",2)	;DelUserDR
	s PLIST(39) = $p(val,"^",2)	;DelDate
	s PLIST(40) = $p(val,"^",2)	;DelTime
	*/
	s PLIST(41) = $p(val,"^",29)	;Hold1 指定工程师
	s PLIST(42) = $p(val,"^",30)	;Hold2
	s PLIST(43) = $p(val,"^",31)	;Hold3
	s PLIST(44) = $p(val,"^",32)	;Hold4
	s PLIST(45) = $p(val,"^",33)	;Hold5
	//add by lmm 2018-04-25 begin LMM0036 
	
	s PLIST(46) = $p(val,"^",34)	;TotalFee
	//s PLIST(47) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",35),"bool")	;TempPlanFlag	//CZF0134 2021-02-23
	//s PLIST(48) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",36),"bool")	;FixTimeFlag
	s PLIST(47) = $p(val,"^",35)	;CycleType
	s PLIST(48) = $p(val,"^",36)	;FeeType
	s PLIST(49) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",37),"date")	;SDate
	s PLIST(50) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",38),"date")	;EDate
		
	TSTART

	if RowID=""
	{
		s PLIST(51) = ##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQMaintPlan",Date)	;PlanNo modify by lmm 2019-01-10 更换生成编号位置
		&SQL(insert into sqluser.DHC_EQMaintPlan values :PLIST())
		s RowID=$G(%ROWID)
	}
	else
	{
		&SQL(update sqluser.DHC_EQMaintPlan values :PLIST() where MP_RowID=:RowID)
	}
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^"_RowID
	}
	

	s $p(EquipRangeval,"^",4)=RowID
	s Return=##Class(web.DHCEQ.EM.BUSEquipRange).SaveEquipRange(EquipRangeval,EquipRangevalList)	//CZF0134 2021-02-23
	s SQLCODE=$p(Return,"^",1)
	s RRRowID=$p(Return,"^",2)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^"_RowID
	}
	
 	TCOMMIT
 	q SQLCODE_"^"_RowID_"^"_RRRowID		//CZF0134 2021-02-23
ERRORSave 
 	TROLLBACK		         //回滚事务
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORSave"_ErrorMsg     //返回错误消息 ;
}

/// ----------------------------------
/// add:zy 2011-03-23  No ZY0066
/// 描述:提交
/// w ##Class(web.DHCEQ.EM.BUSMaintPlan).SubmitData("3^^^516^1^^")
/// ----------------------------------
ClassMethod SubmitData(RowID)
{
	new User,Date,Time
	k AppList,PLIST
	s User=##class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))   //add by lmm 2018-11-05
	s Date=+$H
	s Time=$P($H,",",2)
	Set $ZT="ERRORSubmit"
	s PLIST(27) = "2"	;Status 	
	s PLIST(31) = User	;SubmitUserDR
	s PLIST(32) = Date	;SubmitDate
	s PLIST(33) = Time	;SubmitTime	
	s PLIST(34) = User	;AuditUserDR
	s PLIST(35) = Date	;AuditDate
	s PLIST(36) = Time	;AuditTime
	//Modefied by zc0119 2022-6-20 添加分险等级设备校验 begin
	i $p($g(^DHCEQMaintPlan(RowID)),"^",46)=4
	{
		i ##Class(web.DHCEQ.EM.BUSMaintPlan).CheckEquipInRisk(RowID)=0  q "-1001"  //Modefied by zc0122 2022-10-12 修改返回值  q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1001","当前计划单存在未进行风险等级的信息!")
	}
	//Modefied by zc0119 2022-6-20 添加分险等级设备校验 begin
	TSTART
	&SQL(update sqluser.DHC_EQMaintPlan values :PLIST() where MP_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
 	TCOMMIT
 	q RowID
ERRORSubmit 
 	TROLLBACK		         //回滚事务
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORSubmit"_ErrorMsg     //返回错误消息 ;
}

/// ----------------------------------
/// add:zy 2011-03-23  No ZY0066
/// 描述:删除
/// w ##Class(web.DHCEQ.EM.BUSEquipRange).DeleteData("9^^^516^1^^")
/// ----------------------------------
ClassMethod DeleteData(RowID, EquipRangeID)
{
	 
	Set $ZT="ERRORDelete"	
	TSTART	
	&sql(Delete from sqluser.DHC_EQMaintPlanItem where MPI_MaintPlanDR=:RowID)
	i SQLCODE=100 s SQLCODE=0
	i SQLCODE
	{
		TROLLBACK
		q return
	}
	&sql(Delete from sqluser.DHC_EQMaintPlanPart where MPP_MaintPlanDR=:RowID)
	i SQLCODE=100 s SQLCODE=0
	i SQLCODE
	{
		TROLLBACK
		q return
	} 
	&sql(Delete from sqluser.DHC_EQMaintPlan where MP_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	
	//add by lmm 2018-04-26 begin LMM0036
	s SQLCODE=##Class(web.DHCEQ.EM.BUSEquipRange).DeleteEquipRange(EquipRangeID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^"_RowID
	}
	
	//add by lmm 2018-04-26 end LMM0036
	
	TCOMMIT
	q SQLCODE
ERRORDelete 
 	TROLLBACK		         //回滚事务
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORDelete"_ErrorMsg     //返回错误消息 ;
}

/// w ##Class(web.DHCEQ.EM.BUSMaintPlan).GetWarnIcon()
ClassMethod GetWarnIcon(sourceID As %String = "")
{
	i sourceID="" Quit ""
	s TWarnInfo=##class(web.DHCEQ.EM.BUSMaintPlan).GetWarnDaysNum(sourceID)
	s Nextdate=$p(TWarnInfo,"^",3)
	s PreWarnDaysNum=$p($g(^DHCEQMaintPlan(sourceID)),"^",12)
	
	i Nextdate<=+$H q "../images/websys/sys_warning.gif"
	i Nextdate-PreWarnDaysNum<=+$H<Nextdate q "../images/websys/sys_information.gif"
	q ""
}

/// Creator:Add By CZF 2018-04-26
/// Description:保存计划执行单
/// Input:保养计划ID,维护类型
/// Command:w ##Class(web.DHCEQ.EM.BUSMaintPlan).ExecuteMaintPlan(2,1)
/// modify by lmm 2019-01-12 804385 增加入参：计量标记
/// MZY0093	2021-09-08	增加执行日期
ClassMethod ExecuteMaintPlan(MPRowID, MeasureFlag, User As %String = "", Loc As %String = "", ExeDate As %String = "")
{
	n Date,Time
	s $ZT="ERRORExecute"
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i Loc="" s Loc=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	s Date=+$H
	s Time=$P($H,",",2)
	i ExeDate="" s ExeDate=Date
	k PLIST
	s PLIST(3)=MPRowID
	s PLIST(4)=Loc					//执行科室
	s MPEquipIDs=##Class(web.DHCEQ.EM.BUSMaintPlan).GetMaintEquips(2,MPRowID,MeasureFlag)  //modify by lmm 2019-01-12
	s PLIST(5)=$l(MPEquipIDs,",")	//设备总数
	s PLIST(6)=0		//已执行设备总数
	s PLIST(7)=0		//状态
	s PLIST(8)=ExeDate
	s PLIST(9)=Time
	s PLIST(10)=User
	
	TSTART	
 	
	s PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQPlanExecute",Date)
	&SQL(insert into sqluser.DHC_EQPlanExecute values :PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	s RowID=$G(%ROWID)
	
 	s SQLCODE=##Class(web.DHCEQ.EM.BUSMaintPlan).SavePlanExecuteList(RowID,MPEquipIDs)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
 	s ID=RowID
 	q ID
ERRORExecute 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "<ERRORExecute>"_ErrorMsg     //返回错误消息 ;
}

/// Creator:Add By CZF 2018-04-26
/// Description:保存计划执行明细
/// Input:执行计划ID,计划设备ID串
/// Command:w ##Class(web.DHCEQ.EM.BUSMaintPlan).SavePlanExecuteList(1,"2,3,4,5")
ClassMethod SavePlanExecuteList(PERowID, EquipIDs)
{
	n flag,i,Length
	s flag=0
	
	s MPID=$p($g(^DHCEQPlanExecute(PERowID)),"^",2)			//modified by czf 2020-04-30 begin
	
	i EquipIDs'="" d
	.s Length=$l(EquipIDs,",")
	.f i=1:1:Length d
	..k PLISTMX
	..s PLISTMX(2)=PERowID
	..s PLISTMX(3)=$p(EquipIDs,",",i)
	..s PLISTMX(8)=$p($g(^DHCEQMaintPlan(MPID)),"^",13)
	..s EQID=$p(EquipIDs,",",i)
	..s ItemDR=$p($g(^DHCEQEquip(EQID)),"^",7)
	..i (PLISTMX(8)="")&&(ItemDR'="") s PLISTMX(8)=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",20)		//modified by czf 2020-04-30 end
	..;s PLISTMX(4)=0
	..s PLISTMX(5)="N"		//ExecuteFlag
	..&SQL(insert into sqluser.DHC_EQPlanExecuteList values :PLISTMX())
	..i SQLCODE s flag=SQLCODE
	
	q flag
}

/// 速率优化,重写原有方法
/// Creator:Add By ZX 2019-02-26 ZX0058
/// Description:获取设备范围限定中的设备ID串
/// Input: Sourcetype 来源类型(计划执行单:2);MPID 来源ID;MeasureFlag 计量标志,ListIDFlag 设备ListID需要标志
/// Output: 设备id, "," 号分割
/// add by zx 2019-07-06 移动端需要传入安全组权限
/// Command:w ##Class(web.DHCEQ.EM.BUSMaintPlan).GetMaintEquips("2","3","")
/// modify by lmm 2020-04-13 修改功能  所有条件为交集关系，并非并集
/// modify by zyq 2023-01-18 添加判断是否需要PM计划中设备ListID
ClassMethod GetMaintEquips(Sourcetype, MPID, MeasureFlag As %String = "", GroupID As %String = "", ListIDFlag As %String = "")
{
	n RangeIDs,ERID,Type,ERLID,MaintEquipIDs,MaintEquipID,ERLValue,Sort,ERLIDs
	s (RangeIDs,ERID,MaintEquipIDs,MaintEquipID,ERLValue,Sort,ERLIDs)=""
	
	s (ItemIDs,EquipIDs,LocIDs,EquipCatIDs,StatCatIDs,EquipTypeIDs)=""
	s RangeIDs=ItemIDs_"$"_EquipIDs_"$"_LocIDs_"$"_EquipCatIDs_"$"_StatCatIDs_"$"_EquipTypeIDs
	
	s ERID=$o(^DHCEQEquipRange(0,"SourceID",Sourcetype,MPID,ERID))
	i ERID="" q ""
	i $o(^DHCEQEquipRangeList(0,"LimitType",ERID,0))="" q ""
	
	s Type=0
	f  s Type=$o(^DHCEQEquipRangeList(0,"LimitType",ERID,Type)) q:Type=""  d
	.//Type 1:设备类组 2:设备类型 3:设备分类 4:科室 5:设备 6:设备项
	.//add by zx 2019-07-06 过滤取消类型
	.s Sort=$CASE(Type,"":"","1":4,"2":5,"3":6,"4":7,"5":8,"6":9)
	.s listsort=$CASE(Type,"":"","1":6,"2":5,"3":4,"4":3,"5":2,"6":1)
	.q:$p($g(^DHCEQEquipRange(ERID)),"^",Sort)="N"
	.s ERLID=0
	.f  s ERLID=$o(^DHCEQEquipRangeList(0,"LimitType",ERID,Type,ERLID)) q:ERLID=""  d
	..s ERLValue=$p($g(^DHCEQEquipRangeList(ERLID)),"^",3)
	..i ListIDFlag=1 d //add by zyq 2023-01-27 begin
	...s ERLIDValue=ERLID_":"_ERLValue
	..e  d
	...s ERLIDValue=ERLID //add by zyq 2023-01-27 end
	..i $p(RangeIDs,"$",listsort)=""  d
	...s $p(RangeIDs,"$",listsort)=ERLIDValue
	..e  d
	...s $p(RangeIDs,"$",listsort)=$p(RangeIDs,"$",listsort)_","_ERLIDValue
	
	q ##Class(web.DHCEQ.EM.BUSMaintPlan).GetRangeEquipNew(RangeIDs,MeasureFlag,GroupID)
}

/// Creator:Add By CZF 2018-04-26
/// Description:获取设备范围限定中的设备ID串
/// Input:限定的串
/// Command:w ##Class(web.DHCEQ.EM.BUSMaintPlan).GetRangeEquip("3078$$103$$$")
/// modify by lmm 2019-01-12 804385 增加入参：MeasureFlag 计量标记
/// modify by lmm 2020-04-13 原方法还原 条件并集改为交集关系
ClassMethod GetRangeEquipNew(Values, MeasureFlag As %String = "", GroupID As %String = "")
{
	i Values="" q ""
	s ItemIDs=$p(Values,"$",1)
	i ItemIDs'="" s ItemIDs=","_ItemIDs_","
	s EquipIDs=$p(Values,"$",2)
	s LocIDs=$p(Values,"$",3)
	i LocIDs'="" s LocIDs=","_LocIDs_","
	s EquipCatIDs=$p(Values,"$",4)
	i EquipCatIDs'="" s EquipCatIDs=","_EquipCatIDs_","
	s StatCatIDs=$p(Values,"$",5)
	i StatCatIDs'="" s StatCatIDs=","_StatCatIDs_","
	s EquipTypeIDs=$p(Values,"$",6)
	i EquipTypeIDs'="" s EquipTypeIDs=","_EquipTypeIDs_","
	s Equips=""
	i EquipIDs'="" 
	{
		//modify by lmm 2020-12-17 begin 1646991
		s len=$l(EquipIDs,",")
		for i=1:1:len  d
		.s RowID=$p($p(EquipIDs,",",i),":",2) //modify by zyq 2023/01/17
		.i RowID="" s RowID=$p(EquipIDs,",",i)
		.q:RowID=""
		.s InvalidFlag=$p($g(^DHCEQEquip(RowID)),"^",59)
		.q:InvalidFlag'="N"
		.s StockStatus=$p($g(^DHCEQEquip(RowID)),"^",60)
		.q:StockStatus=3
		.q:StockStatus=0
		.s Status=$p($g(^DHCEQEquip(RowID)),"^",38)
		.q:Status=3
		.i Equips=""  d
		..s Equips=$p(EquipIDs,",",i)
		.e  d
		..s Equips=Equips_","_$p(EquipIDs,",",i)
		//modify by lmm 2020-12-17 end 1646991
	}
	if (ItemIDs'="")||(LocIDs'="")||(EquipCatIDs'="")||(StatCatIDs'="")||(EquipTypeIDs'="") //else  modify by zyq 2022-12-22
	{
		s RowID=0
		f  s RowID=$o(^DHCEQEquip(RowID)) q:RowID=""  d
		.s InvalidFlag=$p(^DHCEQEquip(RowID),"^",59)
		.q:InvalidFlag'="N"
		.s StockStatus=$p(^DHCEQEquip(RowID),"^",60)
		.q:StockStatus=3
		.;add by lmm 2018-05-07 begin
		.q:StockStatus=0
		.s Status=$p(^DHCEQEquip(RowID),"^",38)
		.q:Status=3
		.s EquipTypeDR=$p(^DHCEQEquip(RowID),"^",63)
		.s TClassFlag=$p(^DHCEQEquip(RowID),"^",83)
		.q:("1"'=##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,GroupID,"","1"))&&(TClassFlag="Y")
		.;add by lmm 2018-05-07 end
		.;modify by lmm 2019-01-12 begin 804385
		.;s TMeasureFlag=$p(^DHCEQEquip(RowID),"^",15)
		.s TMeasureFlag=##Class(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttributeGroup("01","3",RowID)
		.q:(MeasureFlag'="")&&(MeasureFlag'=TMeasureFlag)
		.;modify by lmm 2019-01-12 end 804385
		.s EquipTypeDR=$p(^DHCEQEquip(RowID),"^",63)
		.s StatCatDR=$p(^DHCEQEquip(RowID),"^",75)
		.s EquipCatDR=$p(^DHCEQEquip(RowID),"^",4)
		.s StoreLocDR=$p(^DHCEQEquip(RowID),"^",67)
		.s ItemDR=$p(^DHCEQEquip(RowID),"^",7)
		.q:(ItemIDs'="")&&(ItemIDs'[(","_ItemDR_","))
		.q:(LocIDs'="")&&(LocIDs'[(","_StoreLocDR_","))
		.q:(EquipCatIDs'="")&&(EquipCatIDs'[(","_EquipCatDR_","))
		.q:(StatCatIDs'="")&&(StatCatIDs'[(","_StatCatDR_","))
		.q:(EquipTypeIDs'="")&&(EquipTypeIDs'[(","_EquipTypeDR_","))
		.i Equips="" s Equips=RowID
		.e  s Equips=Equips_","_RowID
	}
	q Equips
}

/// Creator:Add By ZX 2019-02-26 ZX0058
/// Description:获取设备范围限定中的设备ID串
/// Input: Value:限定的串; Type:限定类型; MeasureFlag:计量标志
/// Output: 设备id, "," 号分割
/// Command:w ##Class(web.DHCEQ.EM.BUSMaintPlan).GetRangeEquip(1,1)
ClassMethod GetRangeEquip(Value, Type, MeasureFlag As %String = "", GroupID As %String = "")
{
	new EquipID,EquipIDs
	s (EquipID,EquipIDs)=""
	i (Value="")||(Type="") q ""
	//Type 1:设备类组 2:设备类型 3:设备分类 4:科室 5:设备 6:设备项
	i Type="1" d
	.d SetEquipTypeData
	e  i Type="2" d
	.d SetStatCatData
	e  i Type="3" d
	.d SetEquipCatData
	e  i Type="4" d
	.d SetLocData
	e  i Type="5" d
	.s EquipIDs=Value
	e  i Type="6" d
	.d SetItemData
	
	q EquipIDs

SetItemData
	s StoreLocID=0
	f  s StoreLocID=$o(^DHCEQEquip(0,"StoreLocItem",StoreLocID)) q:StoreLocID=""  d
	.s EquipID=0
	.f  s EquipID=$o(^DHCEQEquip(0,"StoreLocItem",StoreLocID,Value,EquipID)) q:EquipID=""  d
	..d CheckEquip
	quit
	
SetLocData
	s EquipID=0
	f  s EquipID=$o(^DHCEQEquip(0,"StoreLoc",Value,EquipID)) q:EquipID=""  d
	.d CheckEquip
	quit
	
SetEquipCatData
	s EquipCatStr=##Class(web.DHCEQCEquipeCat).GetChildIDsByCatID(Value)
	s Len=$l(EquipCatStr,"^")
	s i=0
	f i=1:1:Len  d
	.s ChildsSourceID=$p(EquipCatStr,"^",i)
	.s StoreLocID=0
	.f  s StoreLocID=$o(^DHCEQEquip(0,"StoreLocEquipCat",StoreLocID)) quit:StoreLocID=""  d
	..s EquipID=0
	..f  s EquipID=$o(^DHCEQEquip(0,"StoreLocEquipCat",StoreLocID,ChildsSourceID,EquipID)) quit:EquipID=""  d
	...d CheckEquip
	quit
SetStatCatData
	s StoreLocID=0
	f  s StoreLocID=$o(^DHCEQEquip(0,"StoreLocStatCat",StoreLocID)) q:StoreLocID=""  d
	.s EquipTypeID=0
	.f  s EquipTypeID=$o(^DHCEQEquip(0,"StoreLocStatCat",StoreLocID,EquipTypeID)) q:EquipTypeID=""  d
	..s EquipID=0
	..f  s EquipID=$o(^DHCEQEquip(0,"StoreLocStatCat",StoreLocID,EquipTypeID,Value,EquipID)) q:EquipID=""  d
	...d CheckEquip
	quit
	
SetEquipTypeData
	s StockStatus=0
	f  s StockStatus=$o(^DHCEQEquip(0,"StoreEquipType","N",StockStatus)) q:StockStatus=""  d
	.s StoreLocID=0
	.f  s StoreLocID=$o(^DHCEQEquip(0,"StoreEquipType","N",StockStatus,StoreLocID)) q:StoreLocID=""  d
	..s EquipID=0
	..f  s EquipID=$o(^DHCEQEquip(0,"StoreEquipType","N",StockStatus,StoreLocID,Value,EquipID)) q:EquipID=""  d
	...d CheckEquip
	quit
	
CheckEquip
	s InvalidFlag=$p(^DHCEQEquip(EquipID),"^",59)
	q:InvalidFlag'="N"
	s StockStatus=$p(^DHCEQEquip(EquipID),"^",60)
	q:(StockStatus=3)||(StockStatus=0)
	s Status=$p(^DHCEQEquip(EquipID),"^",38)
	q:Status=3
	;s TMeasureFlag=$p(^DHCEQEquip(RowID),"^",15)
	s TMeasureFlag=##Class(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttributeGroup("01","3",EquipID)    //modify by CSJ 2020-04-08 检查是否属于计量组
	q:(MeasureFlag'="")&&(MeasureFlag'=TMeasureFlag)
	//add by lmm 2019-06-04 过滤简易台账范类设备
	s TEquipTypeDR=$p(^DHCEQEquip(EquipID),"^",63)
	s TClassFlag=$p(^DHCEQEquip(EquipID),"^",83)
	q:("1"'=##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,GroupID,"","1"))&&(TClassFlag="Y")
	//add by lmm 2019-06-04 过滤简易台账范类设备
		
	i EquipIDs'="" s EquipIDs=EquipIDs_","
	s EquipIDs=EquipIDs_EquipID
	quit
}

ClassMethod PlanExeFinish(PlanExeID)
{
	k PLIST
	
	s PLIST(7)=1		;状态
	s PLIST(12)=+$H		;完成日期
	s PLIST(13)=$p(+$H,",",2) ;完成时间
	&SQL(Update sqluser.DHC_EQPlanExecute values :PLIST() Where PE_RowID=:PlanExeID)
	i SQLCODE q SQLCODE
	
	q PlanExeID
}

/// modified by czf 872660
/// d ##class(web.DHCEQ.EM.BUSMaintPlan).DeletePlanExecute(64,406)
ClassMethod DeletePlanExecute(PERowID, val)
{
	Set $ZT="ERRORDeletePlanExe"
	TSTART
	s PELRowID=""
	s len=$l(val,",")
	//add by csj 20190514 删除生命周期信息
	f i=1:1:len
	{
		s PELRowID=$p(val,",",i)
		s MaintDR = $P(^DHCEQPlanExecuteList(PELRowID),"^",3)
		s BussType = $P(^DHCEQMaint(MaintDR),"^",2)
		i BussType=1 d
		.s SourceType=32            //保养
		i BussType=2 d
		.s SourceType=33            //检查
		&SQL(delete from SQLUSER.DHC_EQLifeInfo where LI_SourceType = :SourceType and LI_SourceID=:MaintDR)
		i SQLCODE=100 s SQLCODE=0
		q:SQLCODE	
	}
	if SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	//end by csj 20190514
	f i=1:1:len
	{
		s PELRowID=$p(val,",",i)
		&SQL(delete SQLUSER.DHC_EQMaint WHERE MT_RowID IN (SELECT PEL_MaintDR FROM SQLUSER.DHC_EQPlanExecuteList WHERE PEL_PlanExecuteDR=:PERowID and PEL_RowID=:PELRowID) )
		i SQLCODE=100 s SQLCODE=0
		q:SQLCODE	
	}
	if SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	f i=1:1:len
	{
		s PELRowID=$p(val,",",i)
		&SQL(update SQLUSER.DHC_EQPlanExecuteList set PEL_MaintDR=NULL,PEL_ExecuteResult=NUll,PEL_ExecuteFlag='N',PEL_Remark=NULL,PEL_Hold1=NULL where PEL_PlanExecuteDR=:PERowID and PEL_RowID=:PELRowID )		//modified by czf 1283059
		q:SQLCODE
	}
	if SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	s ExecuteNum=$p(^DHCEQPlanExecute(PERowID),"^",5)-len
	&SQL(update sqluser.DHC_EQPlanExecute Set PE_ExecutedNum=:ExecuteNum where PE_RowID=:PERowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	/*
	&SQL(delete SQLUSER.DHC_EQPlanExecute where PE_RowID=:PERowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}*/
	TCOMMIT
	q SQLCODE
ERRORDeletePlanExe 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORDelete"_ErrorMsg     //返回错误消息 ;
}

/// w ##Class(web.DHCEQ.EM.BUSMaintPlan).ExecutePlan(1,"1^1^1^完好",1)
/// modify by lmm 2019-05-16 896639 增加入参Remark
/// MZY0093	2021-09-08	调整参数
ClassMethod ExecutePlan(PERowID, PlanEquipInfo, BussType, Remark As %String = "")
{
	n Flag,InfoLength,PlanEquip
	s $ZT="ERRORExecutePlan"
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	
	TSTART
	
	s Flag=0
	// MZY0093	2021-09-08
	s InfoLength=$l(PlanEquipInfo,",")
	f n=1:1:InfoLength
	{
		k PLISTMX
		s PlanEquip=$p(PlanEquipInfo,",",n)
		//更新DHC_EQMaint
		s PlanID=$p(PlanEquip,"^",1)
		s EquipID=$p(PlanEquip,"^",2)
		s MaintFee=$p(PlanEquip,"^",5)	//czf 1283059
		s ExecuteDate=##Class(web.DHCEQCommon).TransValueFromPage($p(PlanEquip,"^",8),"date")	//add by lmm 执行日期
		s PLISTMX(2)=EquipID
		s PLISTMX(3)=BussType
		s PLISTMX(4)=PlanID
		s PLISTMX(5)=$p($g(^DHCEQMaintPlan(PlanID)),"^",9)	;MaintTypeDR
		i ExecuteDate="" s ExecuteDate=Date   //Modefied by zc0092 2020-12-23  执行日期为空取系统日期
		s PLISTMX(6)=ExecuteDate	;MaintDate   ;modify by lmm 2020-11-18
		s PLISTMX(7)=$p($g(^DHCEQMaintPlan(PlanID)),"^",14)	;MaintLocDR
		s PLISTMX(8)=$p($g(^DHCEQMaintPlan(PlanID)),"^",15)	;MaintUserDR
		i PLISTMX(8)="" s PLISTMX(8)=User		//czf 1283059
		s PLISTMX(9)=$p($g(^DHCEQMaintPlan(PlanID)),"^",16)	;MaintModeDR
		s PLISTMX(10)=##Class(web.DHCEQ.EM.BUSMaintPlan).GetOtherFee(PlanID,"1")+MaintFee	//$p($g(^DHCEQMaintPlan(PlanID)),"^",13) // Modified By QW20190312BUG:846568  //czf 1283059
		s PLISTMX(11)=""	;NormalFlag
		s PLISTMX(12)=""	;ManageLocDR
		s PLISTMX(13)=$p($g(^DHCEQEquip(EquipID)),"^",19)	;UseLocDR
		s PLISTMX(14)=2		;Status
		s PLISTMX(15)=$p($g(^DHCEQMaintPlan(PlanID)),"^",25)
		s PLISTMX(16)=User
		s PLISTMX(17) = Date	;UpdateDate
		s PLISTMX(18) = Time	;UpdateTime
		s PLISTMX(19) = User	;AuditUserDR
		s PLISTMX(20) = Date	;AuditDate
		s PLISTMX(21) = Time	;AuditTime
		s PLISTMX(25) = MaintFee	//$p($g(^DHCEQMaintPlan(PlanID)),"^",13)   ;OtherFee  //czf 1283059
		s PLISTMX(26) = ""	;Hold1
		s PLISTMX(27) = ""	;Hold2
		s PLISTMX(28) = $p(PlanEquip,"^",9)	;Hold3		// MZY0093	2021-09-08
		s PLISTMX(29) = ""	;Hold4
		s PLISTMX(30) = ""	;Hold5
		s PLISTMX(31) = $p($g(^DHCEQMaintPlan(PlanID)),"^",18)	;MeasureFlag
		s PLISTMX(32) = $p($g(^DHCEQMaintPlan(PlanID)),"^",19)	;MeasureDeptDR
		s PLISTMX(33) = $p($g(^DHCEQMaintPlan(PlanID)),"^",20)	;MeasureHandler
		s PLISTMX(34) = $p($g(^DHCEQMaintPlan(PlanID)),"^",21)	;MeasureTel
		s PLISTMX(35) = ""	;MeasureUsers
		s PLISTMX(36) = $p($g(^DHCEQMaintPlan(PlanID)),"^",22)	;ServiceDR
		s PLISTMX(37) = $p($g(^DHCEQMaintPlan(PlanID)),"^",23)	;ServiceHandler
		s PLISTMX(38) = $p($g(^DHCEQMaintPlan(PlanID)),"^",24)	;ServiceTel
		s PLISTMX(39) = ""	;ServiceUsers
		s PLISTMX(40) = "N"	;InvalidFlag
		&SQL(insert into sqluser.DHC_EQMaint values :PLISTMX())
		s MaintRowID=$G(%ROWID)
		i SQLCODE s Flag=SQLCODE
		
		//更新DHC_EQPlanExecuteList执行标记,执行结果
		// MZY0093	2021-09-08
		s PELID=$p(PlanEquip,"^",3)
		s Result=$p(PlanEquip,"^",4)
		&SQL(update sqluser.DHC_EQPlanExecuteList Set PEL_ExecuteFlag='Y',PEL_ExecuteResult=:Result,PEL_MaintDR=:MaintRowID,PEL_Hold1=:MaintFee where PEL_RowID=:PELID)  //czf 1283059
		i SQLCODE s Flag=SQLCODE
		Quit:Flag
		s SQLCODE=##class(web.DHCEQ.EM.BUSMaint).InsertEQLifeInfo(MaintRowID,User)
		i SQLCODE s Flag=SQLCODE
		Quit:Flag
		//modify by lmm 2020-03-05 LMM0062
		s MaintTypeDR=$p($g(^DHCEQMaintPlan(PlanID)),"^",9)	
		if (BussType=1)
		{
			s SourceType="71"
		}
		elseif (BussType=2)&&(MaintTypeDR=4)
		{
			s SourceType="72-2"
		}
		elseif (BussType=2)&&(MaintTypeDR=5)
		{
			s SourceType="72-1"
		}
		s OperateInfo="^"_SourceType_"^"_PELID_"^"_User_"^^0"
	 	s SQLCODE=##Class(web.DHCEQ.Plat.BUSOperateLog).SaveData(OperateInfo,"3")
		i SQLCODE s Flag=SQLCODE
		Quit:Flag
		//add by lmm 2020-09-07 1485651
		s PL(2)="4"    			//检查记录类型
		s PL(3)=MaintRowID     //检查记录DR  
		// MZY0093	2021-09-08
		s PL(5)=$p(PlanEquip,"^",6)  ;Add By QW20160314增加计量号 
		s PL(9)=##Class(web.DHCEQCommon).TransValueFromPage($p(PlanEquip,"^",7),"date")		//证书效期，直接存在直接存在DHC_EQCertificateInfo不做维护
		s tmpid=""
		&SQL(SELECT CI_RowID INTO:tmpid FROM SQLUSER.DHC_EQCertificateInfo WHERE CI_SourceID=:MaintRowID AND CI_SourceType='4')
		i (PL(9)'="")||(PL(5)'="")
		{
			i (tmpid="")
			{
				s PL(3)=MaintRowID
				&SQL(INSERT INTO SQLUSER.DHC_EQCertificateInfo VALUES:PL())	
				i SQLCODE s Flag=SQLCODE
			}
			else
			{
				&SQL(UPDATE SQLUSER.DHC_EQCertificateInfo VALUES:PL() WHERE CI_SourceID=:MaintRowID AND CI_SourceType='4')
				i SQLCODE s Flag=SQLCODE
			}
		}
		else
		{
			i tmpid'=""
			{
				&SQL(DELETE FROM SQLUSER.DHC_EQCertificateInfo WHERE CI_SourceID=:MaintRowID AND CI_SourceType='4')  
				i SQLCODE=100 s SQLCODE=0
				i SQLCODE s Flag=SQLCODE
			}			
		}
		// MZY0093	2021-09-08	生成PM模版数据
		Quit:Flag
		s PMRTemplateDR=+##Class("web.DHCEQ.EM.BUSEquipRange").GetRangSourceByEquip(EquipID,3,1)
		i PMRTemplateDR>0
		{
			&SQL(insert into SQLUSER.DHC_EQPMReport (PMR_TemplateDR,PMR_MaintDR,PMR_Status,PMR_InvalidFlag) Values (:PMRTemplateDR,:MaintRowID,'0','N'))
			i SQLCODE s Flag=SQLCODE
			Quit:Flag
			s PMReportDR=$g(%ROWID)
			
			s dataList=""
			s Sort=0
			f  s Sort=$o(^DHCEQCCode("DHCEQCPMTemplateList",0,"PMTLTemplateDR",PMRTemplateDR,Sort)) q:Sort=""  d
			.s TemplateListDR=""
			.f  s TemplateListDR=$o(^DHCEQCCode("DHCEQCPMTemplateList",0,"PMTLTemplateDR",PMRTemplateDR,Sort,TemplateListDR)) q:TemplateListDR=""  d
			..s MaintItemDR=$p($g(^DHCEQCCode("DHCEQCPMTemplateList",TemplateListDR)),"^",2)
			..q:MaintItemDR=""
			..q:$p($g(^DHCEQCCode("DHCEQCMaintItem",MaintItemDR)),"^",4)="Y"
			..s Sort=$p($g(^DHCEQCCode("DHCEQCPMTemplateList",TemplateListDR)),"^",4)
			..s DefaultVal=$p($g(^DHCEQCCode("DHCEQCPMTemplateList",TemplateListDR)),"^",5)
			..i DefaultVal="" s DefaultVal=0
			..if (dataList'="") s dataList=dataList_"#"
			..s dataList=dataList_"^^"_MaintItemDR_"^"_DefaultVal_"^^^"_Sort_"^^^^^^"
			
			s SQLCODE=##Class(web.DHCEQ.Process.DHCEQPMReportList).SaveMPReportListNew(PMReportDR,dataList)
			i SQLCODE s Flag=SQLCODE
		}
	}
	i Flag
	{
		TROLLBACK
		q Flag
	}
	// MZY0091	2083796		2021-08-26	更新DHC_EQPlanExecute表已执行数量
	s ExecuteNum=0
	s tmpPELRowID=""
	f  s tmpPELRowID=$o(^DHCEQPlanExecuteList(0,"PlanExecute",PERowID,tmpPELRowID)) quit:(tmpPELRowID="")  d
	.i $p($g(^DHCEQPlanExecuteList(tmpPELRowID)),"^",4)="Y" s ExecuteNum=ExecuteNum+1		;PEL_ExecuteFlag
	&SQL(update sqluser.DHC_EQPlanExecute Set PE_ExecutedNum=:ExecuteNum,PE_Remark=:Remark where PE_RowID=:PERowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
 	q PERowID
ERRORExecutePlan 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "<ERRORExecute>"_ErrorMsg     //返回错误消息 ;
}

// MODIFY BY LMM 2020-03-05 LMM0062

/*
ClassMethod SavaOperateInfo(SourceType, SourceID)
{
	n valList,TSourceType,TSourceID
	k PLIST
	i SourceType=""||SourceID="" q -1
	s Date=+$H
	s Time=$p($H,",",2)
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Flag=0
	
	s PLIST(2)=SourceType
	s PLIST(3)=SourceID
	s PLIST(4)=Date
	s PLIST(5)=Time
	s PLIST(6)=User
	s PLIST(9)="N"

	&SQL(Insert Into SQLUSER.DHC_EQOperateInfo Values :PLIST())
	s OIRowID=$G(%ROWID)
	
	i SQLCODE s Flag=SQLCODE

	q Flag
}
*/
/// w ##Class(web.DHCEQPlanExecute).GetExecutePlanByID("1")
ClassMethod GetPlanExecuteByID(rowid)
{
	i rowid="" q ""
	new result,resultex,LocCode
	s (result,resultex,LocCode)=""
	s result= ^DHCEQPlanExecute(rowid)
	s resultex=resultex_"^"	;PlanName
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQMaintPlan($p(result,"^",2))),"^",1)
	s resultex=resultex_"^"	;ExecuteLoc
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",3))   //modify by lmm 2019-05-16 896410
	.s LocCode=$p($g(^DHCEQCCode("DHCEQCDepartment",$p(result,"^",3))),"^",1)   //modify by lmm 2019-05-16 896410
	s resultex=resultex_"^"	;BeginDate
	i $p(result,"^",7)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",7),"date")
	s resultex=resultex_"^"	;BeginTime
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",8),"time")
	s resultex=resultex_"^"	;User
	i $p(result,"^",9)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",9))
	s resultex=resultex_"^"	;BussType
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQMaintPlan($p(result,"^",2))),"^",2)
	
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex
}

/// type: 1,计划;否则就是记录
/// w ##class(web.DHCEQ.EM.BUSMaintPlan).GetOtherFee(6)
ClassMethod GetOtherFee(RowID, type As %String = "")
{
	i RowID="" q 0
	new id,Fee,TotalFee,PartFee
	s (id,Fee,TotalFee,PartFee)=0
	if type=1
	{		
		for  set id=$order(^DHCEQMaintPlanPart(0,"MaintPlan",RowID,id))  quit:id=""  d
		.Quit:$p($g(^DHCEQMaintPlanPart(id)),"^",7)'="Y"
		.set Fee=$p($g(^DHCEQMaintPlanPart(id)),"^",5)
		.Set TotalFee=TotalFee+Fee
	}
	else
	{
		// Modified By QW20190312BUG:846568 回传partfee,maitfee从界面取
		&sql(select sum(MTP_TotalFee) into :PartFee from sqluser.DHC_EQMaintPart where MTP_MaintDR=:RowID and MTP_FeeFlag='Y')
		i PartFee="" s PartFee=0
		s TotalFee=PartFee
		// End By QW20190312BUG:846568
	}
	q ##Class(web.DHCEQCommon).FormatNumber(TotalFee,"")
}

/// add:lmm 2020-04-27 1285572
/// 描述:删除
/// w ##Class(web.DHCEQ.EM.BUSMaintPlan).CancelSubmitData("4")
/// ----------------------------------
ClassMethod CancelSubmitData(RowID)
{
	 
	Set $ZT="ERRORCancelSubmit"	
	TSTART	
	s PLIST(27)="3"
	&SQL(update sqluser.DHC_EQMaintPlan values :PLIST() where MP_RowID=:RowID)
	//&sql(Delete from sqluser.DHC_EQMaintPlan where MP_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	
	TCOMMIT
	q SQLCODE
ERRORCancelSubmit
 	TROLLBACK		         //回滚事务
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORCancelSubmit"_ErrorMsg     //返回错误消息 ;
}

/// add by lmm 2020-12-02
/// 描述：根据入参查找维护计划id和范围id
/// w ##Class(web.DHCEQ.EM.BUSMaintPlan).GetMaintPlanID("^333333^2^^^^^1^2^5^2020-12-01^^2^^^^^^^^^^^^^^2^N^^^^^^^^N^^","^^2^^N^N^N^N^Y^N")
ClassMethod GetMaintPlanID(MaintPlanInfo, EquipRangeInfo)
{
	i (MaintPlanInfo="")||(EquipRangeInfo="") q ""
	s PlanName=$p(MaintPlanInfo,"^",2)
	s PlanTypeDR=$p(MaintPlanInfo,"^",3)
	s MaintTypeDR=$p(MaintPlanInfo,"^",10)
	s CycleNum=$p(MaintPlanInfo,"^",8)
	s CycleUnitDR=$p(MaintPlanInfo,"^",9)
	//s FromDate=$p(MaintPlanInfo,"^",11)
	i ($p(MaintPlanInfo,"^",11)'="")  d
	.s FromDate=$zdh($p(MaintPlanInfo,"^",11),3)
	e  d
	.s FromDate=""
	s PreWarnDaysNum=$p(MaintPlanInfo,"^",13)
	s MaintFee=$p(MaintPlanInfo,"^",14)
	s MeasureDeptDR=$p(MaintPlanInfo,"^",20)
	//s FixTimeFlag=$p(MaintPlanInfo,"^",36)		;CZF0134 2021-02-23
	s MPCycleType=$p(MaintPlanInfo,"^",36)
	i ($p(MaintPlanInfo,"^",37)'="")  d
	.s SDate=$zdh($p(MaintPlanInfo,"^",37),3)
	e  d
	.s SDate=""
	i ($p(MaintPlanInfo,"^",38)'="")  d
	.s EDate=$zdh($p(MaintPlanInfo,"^",38),3)
	e  d
	.s EDate=""
	s SourceType=$p(EquipRangeInfo,"^",3)
	s EquipTypeFlag=$p(EquipRangeInfo,"^",5)
	s StatCatFlag=$p(EquipRangeInfo,"^",6)
	s LocFlag=$p(EquipRangeInfo,"^",8)
	s EquipFlag=$p(EquipRangeInfo,"^",9)
	s ItemFlag=$p(EquipRangeInfo,"^",10)
	s planid=""
	if (MPCycleType=2)	;固定时间
	{
		&SQL(select MP_RowID into:planid from sqluser.DHC_EQMaintPlan where MP_InvalidFlag='N' and MP_Status='0' and MP_Name =:PlanName and MP_MaintTypeDR=:MaintTypeDR and MP_CycleType=:MPCycleType and MP_PreWarnDaysNum=:PreWarnDaysNum and MP_CycleNum=:CycleNum and MP_CycleUnitDR=:CycleUnitDR  and MP_SDate=:SDate and MP_EDate=:EDate)
	}
	else
	{
		&SQL(select MP_RowID into:planid from sqluser.DHC_EQMaintPlan where MP_InvalidFlag='N' and MP_Status='0' and MP_Name =:PlanName and MP_MaintTypeDR=:MaintTypeDR and MP_CycleType=:MPCycleType and MP_PreWarnDaysNum=:PreWarnDaysNum and MP_CycleNum=:CycleNum and MP_CycleUnitDR=:CycleUnitDR  and MP_FromDate = :FromDate)
	}
	if planid="" q ""
	s equiprangeid=""	
	&SQL(select ER_RowID into:equiprangeid from sqluser.DHC_EQEquipRange where ER_SourceType = :SourceType and ER_SourceID=:planid and ER_EquipTypeFlag=:EquipTypeFlag and ER_StatCatFlag = :StatCatFlag and ER_LocFlag = :LocFlag and ER_EquipFlag = :EquipFlag and ER_ItemFlag=:ItemFlag)
	
	i equiprangeid="" q ""
	
	q planid_"^"_equiprangeid
}

/// Author:add by CZF0134 2021-02-23
/// Description: 维护计划设备预警
/// MZY0091	2074805,2078709		2021-08-26	取消TempPlanFlag条件
/// Command:d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSMaintPlan","GetPlanAlertNew","1","","","",1)
Query GetPlanAlertNew(BussType As %String = "", EquipDR As %String = "", MaintLocDR As %String = "", MaintTypeDR As %String = "", QXType As %String = "", PlanNameDR As %String = "", No As %String = "", PlanName As %String = "", FixTimeFlag As %String = "") As %Query(ROWSPEC = "TRowID:%String,TName:%String,TSourceType:%String,TEquip:%String,TEquipDR:%String,TModel:%String,TModelDR:%String,TNo:%String,TCycleNum:%String,TMaintType:%String,TMaintTypeDR:%String,TLastDate:%String,TNextDate:%String,TPreWarnDaysNum:%String,TMaintFee:%String,TMaintLoc:%String,TMaintLocDR:%String,TMaintUser:%String,TMaintUserDR:%String,TMaintMode:%String,TMaintModeDR:%String,TRemark:%String,TStatus:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TUseLocDR:%String,TUseLoc:%String,TRow:%String,TLocation:%String,TMeasureFlag:%String,TEquipRangeDR:%String,TPERowID:%String,TPELRowID:%String")
{
}

ClassMethod GetPlanAlertNewExecute(ByRef qHandle As %Binary, BussType As %String = "", EquipDR As %String = "", MaintLocDR As %String = "", MaintTypeDR As %String = "", QXType As %String = "", PlanNameDR As %String = "", No As %String = "", PlanName As %String = "", FixTimeFlag As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	set Job=$j
 	d ##Class(web.DHCEQCommon).KillTempGlobal("DHCEQMaintAlertNew")
	s index=1
	s TRow=1
	;s ^CZF("m")=BussType_"^"_EquipDR_"^"_MaintLocDR_"^"_MaintTypeDR_"^"_QXType_"^"_PlanNameDR_"^"_No_"^"_PlanName_"^"_FixTimeFlag
	s FixTimeFlag=##Class(web.DHCEQCommon).TransValueFromPage(FixTimeFlag,"bool")
	// s TempPlanFlag=##Class(web.DHCEQCommon).TransValueFromPage(TempPlanFlag,"bool")	MZY0091	2074805,2078709		2021-08-26	取消该条件
	s rowid=0
	f  s rowid=$o(^DHCEQMaintPlan(0,"Type",BussType,rowid))  quit:rowid=""  d
	.q:(PlanNameDR'="")&&(PlanNameDR'=rowid)
	.d CheckPlan
	.q:pass=0
	.s (EquipIDs,TMeasureFlag)=""
	.i TMaintTypeDR=5 s TMeasureFlag="Y"
	.s EquipIDs=##Class(web.DHCEQ.EM.BUSMaintPlan).GetMaintEquips(2,rowid,TMeasureFlag)
	.q:EquipIDs=""
	.s TCycleType=$p($g(^DHCEQMaintPlan(rowid)),"^",46)	;周期类型 "1":"固定周期","2":"固定时间(周期)","3":"固定时间(一次)","4":"风险等级","5":"固定月份(周期)","6":"固定月份(一次)","":"其他"
	.s len=$l(EquipIDs,",")
	.f i=1:1:len d
	..s EquipID=$p(EquipIDs,",",i)
	..q:EquipID=""
	..q:((TCycleType=3)||(TCycleType=6))&&(##Class(web.DHCEQ.EM.BUSMaintPlan).CheckMaintPlanEquipExecute(BussType,rowid,EquipID)=1) /// Modfied by zc0125 2022-12-09 判断计划内的某台设备是否已执行
	..d CheckEquipID
	..q:pass=0
	..d OutputRowGetPlanAlertNew
	
	k ^DHCEQTemp("DHCEQMaintAlertNew",Job)
	Quit $$$OK
CheckPlan
	s pass=1
	s TStatus = $p($g(^DHCEQMaintPlan(rowid)),"^",26)
	if (TStatus'="2")
	{
		s pass=0
		q
	}
	if ($p($g(^DHCEQMaintPlan(rowid)),"^",36)="Y")
	{
		s pass=0
		q
	}
	set TMaintTypeDR=$p($g(^DHCEQMaintPlan(rowid)),"^",9)
	if (TMaintTypeDR'=MaintTypeDR)&(MaintTypeDR'="")
	{
		s pass=0
		q
	}
 	if (MaintLocDR'="")&&(MaintLocDR'=$p($g(^DHCEQMaintPlan(rowid)),"^",14))
	{
		s pass=0
		q
	}
	quit
CheckEquipID
	s pass=1
	if (EquipDR'="")&(EquipDR'=EquipID)
	{
		s pass=0
		q
	}
	if (No'="")&&($p($g(^DHCEQEquip(EquipID)),"^",71)'[No)
	{
		s pass=0
		q
	}
	if $p($g(^DHCEQEquip(EquipID)),"^",38)>"2"
	{
		s pass=0
		q
	}
	set StockStatus=$p($g(^DHCEQEquip(EquipID)),"^",60)
	if (StockStatus="0")||(StockStatus>"2")
	{
		s pass=0
		q
	}
	if ($p($g(^DHCEQEquip(EquipID)),"^",59))'="N"
	{
		s pass=0
		q
	}
	s RiskEvalID=""
	s EquipStatDR=$p($g(^DHCEQEquip(EquipID)),"^",75)
	s EquipCatDR=$p($g(^DHCEQEquip(EquipID)),"^",4)
	s ItemDR=$p($g(^DHCEQEquip(EquipID)),"^",7)
	//过滤风险等级中未设置保养周期的设备
	if (TCycleType=4)	//设备风险等级
	{
		s RiskEvalID=$o(^DHCEQRiskEvaluation(0,"Source",3,EquipID,RiskEvalID),-1)
		i RiskEvalID="" s RiskEvalID=$o(^DHCEQRiskEvaluation(0,"Source",2,ItemDR,RiskEvalID),-1)
		i RiskEvalID="" s RiskEvalID=$o(^DHCEQRiskEvaluation(0,"Source",1,EquipCatDR,RiskEvalID),-1)
		i RiskEvalID="" s RiskEvalID=$o(^DHCEQRiskEvaluation(0,"Source",0,EquipStatDR,RiskEvalID),-1)
		i RiskEvalID=""
		{
			s pass=0
			q
		}
		s RiskGradeDR=$p($g(^DHCEQRiskEvaluation(RiskEvalID)),"^",5)
	}
	// MZY0085	1975493		2021-07-28	增加执行单过滤
	s PEFlag=""
	s tpmPERowID=""
	f  s tpmPERowID=$o(^DHCEQPlanExecute(0,"MaintPlan",rowid,tpmPERowID)) quit:(tpmPERowID="")||(PEFlag'="")  d
	.q:$p($g(^DHCEQPlanExecute(tpmPERowID)),"^",6)'=0		;状态:0执行中	1完成	2作废
	.s tmpPELRowID=""
	.f  s tmpPELRowID=$o(^DHCEQPlanExecuteList(0,"PlanExecute",tpmPERowID,tmpPELRowID)) quit:(tmpPELRowID="")||(PEFlag'="")  d
	..q:$p($g(^DHCEQPlanExecuteList(tmpPELRowID)),"^",4)="Y"					;PEL_ExecuteFlag
	..i $p($g(^DHCEQPlanExecuteList(tmpPELRowID)),"^",2)=EquipID s PEFlag=1		;PEL_EquipDR
	s (str,LastDate,NextDate)=""
	s str=##class(web.DHCEQ.EM.BUSMaintPlan).WarnDaysNum(rowid,EquipID)
	if ($p(str,"^",1)=0)&&(PEFlag="")
	{
		s pass=0
		q
	}
	s LastDate=$p(str,"^",2)
	s NextDate=$p(str,"^",3)
	quit
OutputRowGetPlanAlertNew	
	d ResetVariablesGetPlanAlertNew
	s TRowID = rowid
	s TName = $p($g(^DHCEQMaintPlan(rowid)),"^",1)
	s TEquip=$p($g(^DHCEQEquip(EquipID)),"^",1)
	s TEquipDR=EquipID
	s TModelDR =$p($g(^DHCEQEquip(EquipID)),"^",3)
	s TNo =$p($g(^DHCEQEquip(EquipID)),"^",71)
	s TCycleNum = $p($g(^DHCEQMaintPlan(rowid)),"^",7)
	s TCycleUnitDR = $p($g(^DHCEQMaintPlan(rowid)),"^",8)
	s TCycleType=$p($g(^DHCEQMaintPlan(rowid)),"^",46)			//modified by czf 20190321
	//	MZY0091	2074805,2078709		2021-08-26	取消TempPlanFlag条件,修正固定时间计划范围
	q:(FixTimeFlag="Y")&&((TCycleType=2)||(TCycleType=3)||(TCycleType=5)||(TCycleType=6))
	//q:(TempPlanFlag="Y")&&(TCycleType=3)
	i TCycleType=4 d
	.s TCycleNum=$p($g(^DHCEQCCode("DHCEQCRiskGrade",RiskGradeDR)),"^",7)
	.s TCycleUnitDR=$p($g(^DHCEQCCode("DHCEQCRiskGrade",RiskGradeDR)),"^",8)
	i TCycleUnitDR '="" s TCycleUnit = $p($g(^DHCEQCCode("DHCEQCCycleUnit",TCycleUnitDR)),"^",2)
	s TCycleNum=TCycleNum_TCycleUnit
	s TMaintTypeDR = $p($g(^DHCEQMaintPlan(rowid)),"^",9)
	s TLastDate =##Class(web.DHCEQCommon).TransValueToPage(LastDate,"date")
	s TNextDate =##Class(web.DHCEQCommon).TransValueToPage(NextDate,"date")
	s TPreWarnDaysNum = $p($g(^DHCEQMaintPlan(rowid)),"^",12)
	s TMaintFee = $p($g(^DHCEQMaintPlan(rowid)),"^",13)
	S TMaintFee=TMaintFee+##Class(web.DHCEQMaintPlanNew).GetOtherFee(rowid,1)
	s TMaintLocDR = $p($g(^DHCEQMaintPlan(rowid)),"^",14)
	s TMaintUserDR = $p($g(^DHCEQMaintPlan(rowid)),"^",15)
	s TMaintModeDR = $p($g(^DHCEQMaintPlan(rowid)),"^",16)
	s TRemark = $p($g(^DHCEQMaintPlan(rowid)),"^",25)
	s TStatus = $p($g(^DHCEQMaintPlan(rowid)),"^",26)
	s THold1=$p($g(^DHCEQMaintPlan(rowid)),"^",40)
	s THold2=$p($g(^DHCEQMaintPlan(rowid)),"^",41)
	s THold3=$p($g(^DHCEQMaintPlan(rowid)),"^",42)
	s THold4=$p($g(^DHCEQMaintPlan(rowid)),"^",43)
	s THold5=$p($g(^DHCEQMaintPlan(rowid)),"^",44)	
	i TModelDR'="" s TModel=$p($G(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	i TMaintTypeDR '="" s TMaintType = $p($g(^DHCEQCCode("DHCEQCMaintType",TMaintTypeDR)),"^",2)
	i TMaintLocDR '="" s TMaintLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TMaintLocDR)	// MZY0099	2180651		2021-11-13
	i TMaintUserDR '="" s TMaintUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TMaintUserDR)
	i TMaintModeDR '="" s TMaintMode = $p($g(^DHCEQCCode("DHCEQCMaintMode",TMaintModeDR)),"^",2)
	i TStatus'=""  s TStatus = $CASE(TStatus,"0":"新增","1":"提交","2":"审核")
	s TUseLocDR =$p($g(^DHCEQEquip(EquipID)),"^",19)  //UseLocDR
	i TUseLocDR '="" s TUseLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TUseLocDR)
	s TLocation = $p($g(^DHCEQEquip(EquipID)),"^",72)
	i TLocation'="" s TLocation=$p($g(^DHCEQCCode("DHCEQCLocation",TLocation)),"^",2)
	Set TMeasureFlag=$p($g(^DHCEQEquip(TEquipDR)),"^",15)
	If TMeasureFlag'="Y" Set TMeasureFlag=""
	s TEquipRangeDR=$o(^DHCEQEquipRange(0,"SourceID","2",rowid,""))
	; MZY0085	1975493		2021-07-28	关联执行单及明细
	s tpmPERowID=""
	f  s tpmPERowID=$o(^DHCEQPlanExecute(0,"MaintPlan",rowid,tpmPERowID),-1) quit:(tpmPERowID="")||(PELRowID'="")  d
	.q:$p($g(^DHCEQPlanExecute(tpmPERowID)),"^",6)'=0		;状态:0执行中	1完成	2作废
	.
	.s tmpPELRowID=""
	.f  s tmpPELRowID=$o(^DHCEQPlanExecuteList(0,"PlanExecute",tpmPERowID,tmpPELRowID)) quit:(tmpPELRowID="")||(PELRowID'="")  d
	..q:$p($g(^DHCEQPlanExecuteList(tmpPELRowID)),"^",4)="Y"		;PEL_ExecuteFlag
	..q:$p($g(^DHCEQPlanExecuteList(tmpPELRowID)),"^",2)'=TEquipDR	;PEL_EquipDR
	..s PERowID=tpmPERowID
	..s PELRowID=tmpPELRowID
	
	Set Data=$lb(TRowID,TName,TSourceType,TEquip,TEquipDR,TModel,TModelDR,TNo,TCycleNum,TMaintType,TMaintTypeDR,TLastDate,TNextDate,TPreWarnDaysNum,TMaintFee,TMaintLoc,TMaintLocDR,TMaintUser,TMaintUserDR,TMaintMode,TMaintModeDR,TRemark,TStatus,THold1,THold2,THold3,THold4,THold5,TUseLocDR,TUseLoc,TRow,TLocation,TMeasureFlag,TEquipRangeDR,PERowID,PELRowID)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set TRow=TRow+1 
	quit
ResetVariablesGetPlanAlertNew
	Set (TRowID,TName,TSourceType,TEquip,TEquipDR,TModel,TModelDR,TNo,TCycleNum,TCycleUnit,TMaintType,TMaintTypeDR,TLastDate,TNextDate,TPreWarnDaysNum,TMaintFee,TMaintLoc,TMaintLocDR,TMaintUser,TMaintUserDR,TMaintMode,TMaintModeDR,TRemark,TStatus,THold1,THold2,THold3,THold4,THold5,TUseLocDR,TUseLoc,TLocation,TMeasureFlag,TEquipRangeDR,PERowID,PELRowID)=""
	quit
}

ClassMethod GetPlanAlertNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPlanAlertExecute ]
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

ClassMethod GetPlanAlertNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPlanAlertExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by zx 2015-09-14 
/// modified by CZF0134 2021-02-23
/// Description:维护计划设备预警信息
/// w ##class(web.DHCEQ.EM.BUSMaintPlan).WarnDaysNum(2,26238)
ClassMethod WarnDaysNum(MaintPlanID, EquipID)
{
	new BussType,CycleNum,CycleUnitDR,CycleDays,TempDate,LastDate,NextDate,id,MaintDate,pass
	s pass=1
	s (TempDate,LastDate,NextDate)=""
	s BussType = $p($g(^DHCEQMaintPlan(MaintPlanID)),"^",2)
	s CycleNum = $p($g(^DHCEQMaintPlan(MaintPlanID)),"^",7)
	s CycleUnitDR = $p($g(^DHCEQMaintPlan(MaintPlanID)),"^",8)
	s FromDate = $p($g(^DHCEQMaintPlan(MaintPlanID)),"^",10)		;启用日期
	s PreWarnDaysNum = $p($g(^DHCEQMaintPlan(MaintPlanID)),"^",12)	;预警天数
	//s TempFlag=$p($g(^DHCEQMaintPlan(MaintPlanID)),"^",46)			//add by czf 20190320 begin
	//s FixTimeFlag=$p($g(^DHCEQMaintPlan(MaintPlanID)),"^",47)
	// MZY0083	2034404		2021-07-19
	;周期类型 "1":"固定周期","2":"固定时间(周期)","3":"固定时间(一次)","4":"风险等级","5":"固定月份(周期)","6":"固定月份(一次)","":"其他"
	s CycleType=$p($g(^DHCEQMaintPlan(MaintPlanID)),"^",46)
	;s SDate=$p($g(^DHCEQMaintPlan(MaintPlanID)),"^",48)
	;s EDate=$p($g(^DHCEQMaintPlan(MaintPlanID)),"^",49)
	if (CycleType=2)||(CycleType=5)	//固定时间周期为空时周期按一年计
	{
		if (CycleNum="")
		{
			s CycleNum=1
			s CycleUnitDR=1
		}
	}
	if (CycleType=4)
	{
		s (CycleNum,CycleUnitDR)=""
		s EquipStatDR=$p($g(^DHCEQEquip(EquipID)),"^",75)
		s EquipCatDR=$p($g(^DHCEQEquip(EquipID)),"^",4)
		s ItemDR=$p($g(^DHCEQEquip(EquipID)),"^",7)
		s RiskEvalID=""
		s RiskEvalID=$o(^DHCEQRiskEvaluation(0,"Source",3,EquipID,""),-1)
		i RiskEvalID="" d
		.s RiskEvalID=$o(^DHCEQRiskEvaluation(0,"Source",2,ItemDR,RiskEvalID),-1)
		.i RiskEvalID="" d
		..s RiskEvalID=$o(^DHCEQRiskEvaluation(0,"Source",1,EquipCatDR,RiskEvalID),-1)
		..i RiskEvalID="" d
		...s RiskEvalID=$o(^DHCEQRiskEvaluation(0,"Source",0,EquipStatDR,RiskEvalID),-1)
		i RiskEvalID'="" d
		.s RiskGradeDR=$p($g(^DHCEQRiskEvaluation(RiskEvalID)),"^",5)
		.s CycleNum=$p(^DHCEQCCode("DHCEQCRiskGrade",RiskGradeDR),"^",7)
		.s CycleUnitDR=$p(^DHCEQCCode("DHCEQCRiskGrade",RiskGradeDR),"^",8)
	}
	//add by czf 20190320 end
	if $Data(^DHCEQMaint(0,"SourceID",BussType,MaintPlanID,EquipID))=0
	{
		// MZY0083	2034404		2021-07-19
		s LastDate=""
		if (CycleType=1)||(CycleType=4)
		{
			//"1":"固定周期"	"4":"风险等级"
			s NextDate=FromDate
		}
		else
		{
			// "2":"固定时间(周期)","3":"固定时间(一次)","5":"固定月份(周期)","6":"固定月份(一次)"
			s NextDate=$p($g(^DHCEQMaintPlan(MaintPlanID)),"^",48)	;SDate
			i NextDate="" s NextDate=FromDate	// MZY0085	1975493		2021-07-28
		}
	}
	else
	{
		s id=0
		for  set id =$order(^DHCEQMaint(0,"SourceID",BussType,MaintPlanID,EquipID,id)) q:id=""  d  //2015-09-14 Bug ZX0032
		.q:$p($g(^DHCEQMaint(id)),"^",39)="Y"		;MT_InvalidFlag
		.s MaintDate=$p($g(^DHCEQMaint(id)),"^",5)
		.i MaintDate>TempDate s TempDate=MaintDate	;最近一次的维护日期
		
		s LastDate=TempDate
		if LastDate="" 
		{
			// MZY0083	2034404		2021-07-19	无有效保养记录
			if (CycleType=1)||(CycleType=4)
			{
				s NextDate=FromDate
			}
			else
			{
				s NextDate=$p($g(^DHCEQMaintPlan(MaintPlanID)),"^",48)	;SDate
				i NextDate="" s NextDate=FromDate	// MZY0085	1975493		2021-07-28
			}
		}
		else
		{
			// MZY0083	2034404		2021-07-19
			;周期类型 "1":"固定周期","2":"固定时间(周期)","3":"固定时间(一次)","4":"风险等级","5":"固定月份(周期)","6":"固定月份(一次)","":"其他"
			if (CycleType=3)||(CycleType=6)		;一次性计划
			{
				s NextDate=+$p($g(^DHCEQMaintPlan(MaintPlanID)),"^",48)
				i (NextDate>0)&&(LastDate>NextDate) s NextDate=""
			}
			else
			{
				s TempDate=$ZD(LastDate,3)
				If CycleUnitDR=1
				{
					Set $Piece(TempDate,"-",1)=$Piece(TempDate,"-",1)+CycleNum
					Set NextDate=$ZDH(TempDate,3)
				}
				If CycleUnitDR=2
				{
					Set $Piece(TempDate,"-",1)=$Piece(TempDate,"-",1)+(CycleNum\12)					;计算年数
					Set $Piece(TempDate,"-",2)=$Piece(TempDate,"-",2)+CycleNum-((CycleNum\12)*12)	;计算月数
					
					;跨年处理
					If $Piece(TempDate,"-",2)>12
					{
						Set $Piece(TempDate,"-",2)=$Piece(TempDate,"-",2)-12
						Set $Piece(TempDate,"-",1)=$Piece(TempDate,"-",1)+1
					}
					
					Set NextDate=$ZDH($PIECE(TempDate,"-",1,2)_"-01",3)+$Piece(TempDate,"-",3)		;月初数+偏移天数
				}
				If CycleUnitDR=3
				{
					Set NextDate=LastDate+CycleNum
				}
			}
		}
	}
	if NextDate="" s pass=0
	else  if (NextDate>($p($h,",",1)+PreWarnDaysNum)) s pass=0
	quit pass_"^"_LastDate_"^"_NextDate
}

/// Creator:Mozy	2021-3-15
/// Description:计划设备明细
/// Command:d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSMaintPlan","PlanEquipList","^No=^FileNo=^Name=^UseLocDR=^RiskGrade=^ManuFactoryDR=^LeaveFactoryNo=^MinValue=^MaxValue=^EquipTypeDR=^StatCatDR=^EquipCatDR=^BeginInStockDate=^EndInStockDate=^Chk=1","","")
/// 		d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSMaintPlan","PlanEquipList","",35)
Query PlanEquipList(Data As %String = "", MPID As %String = "", PEID As %String = "", MaintLocDR As %String = "", MaintDR As %String = "", EquipDR As %String = "", ExecuteFlag As %String = "") As %Query(ROWSPEC = "TRowID:%String,TNo:%String,TFileNo:%String,TName:%String,TModel:%String,TUnit:%String,TOriginalFee:%String,TDisplayStatus:%String,TEquipType:%String,TUseLoc:%String,TRiskGrade:%String,TInDate:%String,TStartDate:%String,TManuFactory:%String,TManuFactoryNo:%String,TManuFactoryDate:%String,TListID:%String,TStage:%String")
{
}

ClassMethod PlanEquipListExecute(ByRef qHandle As %Binary, Data As %String = "", MPID As %String = "", PEID As %String = "", MaintLocDR As %String = "", MaintDR As %String = "", EquipDR As %String = "", ExecuteFlag As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1
	;s ^TMPMozy("web.DHCEQ.EM.BUSMaintPlan")=Data_","_MPID
	i (MPID="")
	{
		Quit:Data=""
		Set No=##class(web.DHCEQCommon).GetDataByName(Data,"No")
		Set FileNo=##class(web.DHCEQCommon).GetDataByName(Data,"FileNo")
		Set Name=##class(web.DHCEQCommon).GetDataByName(Data,"Name")
		Set UseLocDR=##class(web.DHCEQCommon).GetDataByName(Data,"UseLocDR")
		Set RiskGrade=##class(web.DHCEQCommon).GetDataByName(Data,"RiskGrade")
		Set ManuFactoryDR=##class(web.DHCEQCommon).GetDataByName(Data,"ManuFactoryDR")
		Set LeaveFactoryNo=##class(web.DHCEQCommon).GetDataByName(Data,"LeaveFactoryNo")
		Set MinValue=##class(web.DHCEQCommon).GetDataByName(Data,"MinValue")
		Set MaxValue=##class(web.DHCEQCommon).GetDataByName(Data,"MaxValue")
		Set EquipTypeDR=##class(web.DHCEQCommon).GetDataByName(Data,"EquipTypeDR")
		Set StatCatDR=##class(web.DHCEQCommon).GetDataByName(Data,"StatCatDR")
		Set EquipCatDR=##class(web.DHCEQCommon).GetDataByName(Data,"EquipCatDR")
		Set BeginInStockDate=##class(web.DHCEQCommon).GetDataByName(Data,"BeginInStockDate")
		Set EndInStockDate=##class(web.DHCEQCommon).GetDataByName(Data,"EndInStockDate")
		Set BeginInStockDate=##class(web.DHCEQCommon).TransValueFromPage(BeginInStockDate,"date")
		Set EndInStockDate=##class(web.DHCEQCommon).TransValueFromPage(EndInStockDate,"date")
		Set Chk=##class(web.DHCEQCommon).GetDataByName(Data,"Chk")
		Set EngineerDR=##class(web.DHCEQCommon).GetDataByName(Data,"EngineerDR")	;MZY0083	2034340		2021-07-19
		
		s rowid=0
		f  s rowid=$o(^DHCEQEquip(rowid)) quit:rowid=""  d
		.d ResetVariablesPlanEquipList
		.s TRowID = rowid
		.s EquipData=$g(^DHCEQEquip(TRowID))
		.q:$p(EquipData,"^",59)'="N"
		.Set TEquipTypeDR=$p(EquipData,"^",63)
		.q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
		.q:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR)
		.s TEquipType = ##class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR)
		.s TStatus = $p(EquipData,"^",38)
		.q:TStatus=3
		.s TDisplayStatus=##Class(web.DHCEQ.EM.BUSEquip).GetEquipStatusDisplay(TStatus)
		.s TStockStatus=$p(EquipData,"^",60)
		.q:(TStockStatus=0)||(TStockStatus=3)
		.s TInStockListDR = $p(EquipData,"^",70)
		.i TInStockListDR="" d
		..s InStockDate=$p(EquipData,"^",45)
		.else  d
		..s InStockDR=$p($g(^DHCEQInStockList(TInStockListDR)),"^",1)
		..s InStockDate=$p(^DHCEQInStock(+InStockDR),"^",13)
		.q:(BeginInStockDate'="")&&(InStockDate<BeginInStockDate)
		.q:(EndInStockDate'="")&&(InStockDate>EndInStockDate)
		.s TInDate = ##Class(web.DHCEQCommon).TransValueToPage(InStockDate, "date")
		.s TUseLocDR = $p(EquipData,"^",19)
		.q:(UseLocDR'="")&&(UseLocDR'=TUseLocDR)
		.s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TUseLocDR)
		.s TOriginalFee=$p(EquipData,"^",27)
		.q:(MinValue'="")&&(MinValue>TOriginalFee)
		.q:(MaxValue'="")&&(MaxValue<TOriginalFee)
		.s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"")
		.s TManuFactoryDR = $p(EquipData,"^",26)
		.q:(ManuFactoryDR'="")&&(ManuFactoryDR'=TManuFactoryDR)
		.s TManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer", TManuFactoryDR)
		.Set TManuFactoryNo=$p(EquipData,"^",10)
		.q:(LeaveFactoryNo'="")&&(TManuFactoryNo'[LeaveFactoryNo)
		.s TManuFactoryDate = ##Class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",11), "date")
		.s TModel=##Class(web.DHCEQCommon).GetTrakNameByID("model", $p(EquipData,"^",3))
		.s TLimitYearsNum = $p(EquipData,"^",31)
		.s TNo = $ZCONVERT($p(EquipData,"^",71),"U")
		.q:(No'="")&&(TNo'[$ZCONVERT(No, "U"))
		.s TFileNo = $ZCONVERT($p(EquipData,"^",85),"U")
		.q:(FileNo'="")&&(TFileNo'[$ZCONVERT(FileNo, "U"))
		.s TName = $p(EquipData,"^",1)
		.q:(Name'="")&&(TName'[Name)
		.s TStatCatDR = $p(EquipData,"^",75)
		.q:(StatCatDR'="")&&(TStatCatDR'=StatCatDR)
		.s TEquiCatDR = $p(EquipData,"^",4)
		.q:(EquipCatDR'="")&&(TEquiCatDR'=EquipCatDR)
		.s TStartDate = ##Class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",44),"date")
		.s TUnit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom", $p(EquipData,"^",5))
		.q:(EngineerDR'="")&&(##Class(web.DHCEQCommon).CheckManageLimit(EngineerDR,"","",TEquipTypeDR,TStatCatDR,TEquiCatDR,$p(EquipData,"^",67),TRowID,$p(EquipData,"^",7)))	;MZY0083	2034340		2021-07-19
		.
		.s RiskGradeDR=""
		.s SourceType=0
		.for  s SourceType=$o(^DHCEQRiskEvaluation(0,"Source",SourceType)) quit:(SourceType="")  d
		..s SourceID=0
		..for  s SourceID=$o(^DHCEQRiskEvaluation(0,"Source",SourceType,SourceID)) quit:(SourceID="")  d
		...;0:设备类型|1：设备分类|2：设备项|3：设备
		...q:(SourceType=0)&&(TStatCatDR'=SourceID)
		...q:(SourceType=1)&&(TEquiCatDR'=SourceID)
		...q:(SourceType=2)&&($p(EquipData,"^",7)'=SourceID)
		...q:(SourceType=3)&&(TRowID'=SourceID)
		...
		...s rerowid=0
		...for  s rerowid=$o(^DHCEQRiskEvaluation(0,"Source",SourceType,SourceID,rerowid)) quit:(rerowid="")  d
		....i RiskGradeDR="" d
		.....s RiskGradeDR=$p($g(^DHCEQRiskEvaluation(rerowid)),"^",5)
		....e  d
		.....i (RiskGradeDR>$p($g(^DHCEQRiskEvaluation(rerowid)),"^",5)) s RiskGradeDR=$p($g(^DHCEQRiskEvaluation(rerowid)),"^",5)
		.
		.q:(RiskGrade'="")&&(RiskGradeDR'=RiskGrade)
		.i RiskGradeDR'="" s TRiskGrade=$p($g(^DHCEQCCode("DHCEQCRiskGrade",RiskGradeDR)),"^",2)
		.
		.;最近执行状况
		.s PERowID=""
		.f  s PERowID=$o(^DHCEQPlanExecute(PERowID),-1) quit:(PERowID="")||(TStage'="")  d
		..q:PERowID=0
		..q:$p($g(^DHCEQPlanExecute(PERowID)),"^",6)=2		; 0执行中	1完成	2作废
		..q:($p($g(^DHCEQPlanExecute(PERowID)),"^",6)=0)&&($p($g(^DHCEQMaintPlan(+$p($g(^DHCEQPlanExecute(PERowID)),"^",2))),"^",26)'=2)	; MZY0111	2401962		2022-01-14	过滤又已作废计划生成并且执行中的记录
		..s FindFlag=0
		..s PELRowID=0
		..f  s PELRowID=$o(^DHCEQPlanExecuteList(0,"PlanExecute",PERowID,PELRowID)) quit:(PELRowID="")||(FindFlag=1)  d
		...i TRowID=$p($g(^DHCEQPlanExecuteList(PELRowID)),"^",2) s FindFlag=1
		..q:FindFlag=0
		..;s TStage=##Class(web.DHCEQCommon).GetTrakNameByID("user", $p($g(^DHCEQPlanExecute(PERowID)),"^",9))_"("_$E(##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQPlanExecute(PERowID)),"^",7),"date"),0,7)_")"
		..s TStage=##Class(web.DHCEQCommon).GetTrakNameByID("user", $p($g(^DHCEQPlanExecute(PERowID)),"^",9))_"("_$p($g(^DHCEQPlanExecute(PERowID)),"^",1)_")"
		..i $p($g(^DHCEQPlanExecute(PERowID)),"^",6)=0 s TStage=TStage_"执行中."
		..i $p($g(^DHCEQPlanExecute(PERowID)),"^",6)=1 s TStage=TStage_"执行完成."
		.
		.s FindFlag=0		; 未建计划
		.i Chk=1 d
		..; 检索计划设备范围
		..s ERID=0
		..f  s ERID=$o(^DHCEQEquipRange(ERID)) q:(ERID="")||(FindFlag=1)  d
		...s MPID=0		;保养检查计划
		...i $p($g(^DHCEQEquipRange(ERID)),"^",2)=2 s MPID=$p($g(^DHCEQEquipRange(ERID)),"^",3)
		...q:$p($g(^DHCEQMaintPlan(MPID)),"^",26)'=2	;0:新增|1:提交|2:审核|3:作废
		...
		...s Type=0			; 1:类组,2:类型,3:分类,4:科室,5:设备,6:设备项
		...f  s Type=$o(^DHCEQEquipRangeList(0,"LimitValue",ERID,Type)) q:(Type="")||(FindFlag=1)  d
		....s Value=0
		....f  s Value=$o(^DHCEQEquipRangeList(0,"LimitValue",ERID,Type,Value)) q:(Value="")||(FindFlag=1)  d
		.....i (Type=1)&&(Value=TEquipTypeDR) s FindFlag=1
		.....i (Type=2)&&(Value=TStatCatDR) s FindFlag=1
		.....i (Type=3)&&(Value=TEquiCatDR) s FindFlag=1
		.....i (Type=4)&&(Value=$p(EquipData,"^",67)) s FindFlag=1
		.....i (Type=5)&&(Value=TRowID) s FindFlag=1
		.....i (Type=6)&&(Value=$p(EquipData,"^",7)) s FindFlag=1
		.q:FindFlag=1
		.
		.d OutputRowPlanEquipList
	}
	else
	{
		//Modefied by zc0114 2022-01-22 根据计划单获取设备范围 begin
		;s ERID=$o(^DHCEQEquipRange(0,"SourceID",2,MPID,""))
		;i ERID="" Quit $$$OK
		s EquipIDs=##Class(web.DHCEQ.EM.BUSMaintPlan).GetMaintEquips("2",MPID,"","",1) //modify by zyq 2023-01-17
		;s ERLID=0
		;f  s ERLID=$o(^DHCEQEquipRangeList(0,"LimitType",ERID,5,ERLID)) q:ERLID=""  d
		s Length=$l(EquipIDs,",")
		f i=1:1:Length d
		.;q:$p($g(^DHCEQEquipRangeList(ERLID)),"^",4)'="Y"
		.d ResetVariablesPlanEquipList
		.;s TListID=ERLID
		.s TRowID=$p($p(EquipIDs,",",i),":",2)   //$p($g(^DHCEQEquipRangeList(ERLID)),"^",3)   //Modefied by zc0114 2022-01-22 根据计划单获取设备范围 end\
		.s TListID=$p($p(EquipIDs,",",i),":",1) //modify by zyq 2023-01-17
		.s EquipData=$g(^DHCEQEquip(TRowID))
		.s TEquipTypeDR=$p(EquipData,"^",63)
		.q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
		.s TEquipType = ##class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR)
		.s TStatus = $p(EquipData,"^",38)
		.s TDisplayStatus=##Class(web.DHCEQ.EM.BUSEquip).GetEquipStatusDisplay(TStatus)
		.s TStockStatus=$p(EquipData,"^",60)
		.q:(TStockStatus=0)||(TStockStatus=3)
		.s TInStockListDR = $p(EquipData,"^",70)
		.i TInStockListDR="" d
		..s InStockDate=$p(EquipData,"^",45)
		.else  d
		..s InStockDate=$p($g(^DHCEQInStockList(TInStockListDR)),"^",1)
		..s InStockDate=$p(^DHCEQInStock(InStockDate),"^",13)
		.s TInDate = ##Class(web.DHCEQCommon).TransValueToPage(InStockDate, "date")
		.s TUseLocDR = $p(EquipData,"^",19)
		.s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TUseLocDR)
		.s TOriginalFee=$p(EquipData,"^",27)
		.s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"")
		.s TManuFactoryDR = $p(EquipData,"^",26)
		.s TManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer", TManuFactoryDR)
		.s TManuFactoryNo=$p(EquipData,"^",10)
		.s TManuFactoryDate = ##Class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",11), "date")
		.s TModel=##Class(web.DHCEQCommon).GetTrakNameByID("model", $p(EquipData,"^",3))
		.s TLimitYearsNum = $p(EquipData,"^",31)
		.s TNo = $ZCONVERT($p(EquipData,"^",71),"U")
		.s TFileNo = $ZCONVERT($p(EquipData,"^",85),"U")
		.s TName = $p(EquipData,"^",1)
		.s TStatCatDR = $p(EquipData,"^",75)
		.s TEquiCatDR = $p(EquipData,"^",4)
		.s TStartDate = ##Class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",44),"date")
		.s TUnit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom", $p(EquipData,"^",5))
		.
		.s RiskGradeDR=""
		.s SourceType=0
		.for  s SourceType=$o(^DHCEQRiskEvaluation(0,"Source",SourceType)) quit:(SourceType="")  d
		..s SourceID=0
		..for  s SourceID=$o(^DHCEQRiskEvaluation(0,"Source",SourceType,SourceID)) quit:(SourceID="")  d
		...;0:设备类型|1：设备分类|2：设备项|3：设备
		...q:(SourceType=0)&&(TStatCatDR'=SourceID)
		...q:(SourceType=1)&&(TEquiCatDR'=SourceID)
		...q:(SourceType=2)&&($p(EquipData,"^",7)'=SourceID)
		...q:(SourceType=3)&&(TRowID'=SourceID)
		...
		...s rerowid=0
		...for  s rerowid=$o(^DHCEQRiskEvaluation(0,"Source",SourceType,SourceID,rerowid)) quit:(rerowid="")  d
		....i RiskGradeDR="" d
		.....s RiskGradeDR=$p($g(^DHCEQRiskEvaluation(rerowid)),"^",5)
		....e  d
		.....i (RiskGradeDR>$p($g(^DHCEQRiskEvaluation(rerowid)),"^",5)) s RiskGradeDR=$p($g(^DHCEQRiskEvaluation(rerowid)),"^",5)
		.i RiskGradeDR'="" s TRiskGrade=$p($g(^DHCEQCCode("DHCEQCRiskGrade",RiskGradeDR)),"^",2)
		.
		.;最近执行状况
		.s PERowID=$o(^DHCEQPlanExecute(0,"MaintPlan",MPID,""),-1)
		.i PERowID'="" d
		..q:$p($g(^DHCEQPlanExecute(PERowID)),"^",6)'=0		; 0执行中	1完成	2作废
		..
		..s PELRowID=0
		..f  s PELRowID=$o(^DHCEQPlanExecuteList(0,"PlanExecute",PERowID,PELRowID)) quit:(PELRowID="")  d
		...q:TRowID'=$p($g(^DHCEQPlanExecuteList(PELRowID)),"^",2)
		...s TStage=##Class(web.DHCEQCommon).GetTrakNameByID("user", $p($g(^DHCEQPlanExecute(PERowID)),"^",9))_"("_$E(##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQPlanExecute(PERowID)),"^",7),"date"),0,7)_")"
		...i $p($g(^DHCEQPlanExecute(PERowID)),"^",6)=0 s TStage=TStage_"执行中."
		...i $p($g(^DHCEQPlanExecute(PERowID)),"^",6)=1 s TStage=TStage_"执行完成."
		.d OutputRowPlanEquipList
	}
	Quit $$$OK
	
OutputRowPlanEquipList
	Set Data=$lb(TRowID,TNo,TFileNo,TName,TModel,TUnit,TOriginalFee,TDisplayStatus,TEquipType,TUseLoc,TRiskGrade,TInDate,TStartDate,TManuFactory,TManuFactoryNo,TManuFactoryDate,TListID,TStage)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set TRow=TRow+1
	quit
ResetVariablesPlanEquipList
	Set (TRowID,TNo,TFileNo,TName,TModel,TUnit,TOriginalFee,TDisplayStatus,TEquipType,TUseLoc,TRiskGrade,TInDate,TStartDate,TManuFactory,TManuFactoryNo,TManuFactoryDate,TListID,TStage)=""
	quit
}

ClassMethod PlanEquipListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PlanEquipListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod PlanEquipListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PlanEquipListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQ.EM.BUSMaintPlan).AppendEquip(40, "83,84")
ClassMethod AppendEquip(MaintPlanID, EquipDRStr)
{
	s $ZT="ERRORAppendEquip"
	i MaintPlanID="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9000, "未选择追加计划单!")
	i EquipDRStr="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9000, "未选择设备!")
	
	new ERRowID, EquipRangeval, EquipRangevalList, Return
	s ERRowID=$o(^DHCEQEquipRange(0,"SourceID",2,MaintPlanID,""))
	i ERRowID=""
	{
		s EquipRangeval="^^2^^N^N^N^N^Y^N"
	}
	else
	{
		s EquipRangeval=ERRowID_"^^^^^^^^^"
		for i=3:1:10  d
		.s $p(EquipRangeval,"^",i)=$p(^DHCEQEquipRange(ERRowID),"^",i-1)	; ^2^34^N^N^N^N^Y^N^^^^^^^
		s $p(EquipRangeval,"^",9)="Y"	;EquipFlag
	}
	
	s EquipRangevalList=""
	s Length=$l(EquipDRStr,",")
	for i=1:1:Length  d
	.s EquipID=$p(EquipDRStr,",",i)
	.if (EquipRangevalList'="") s EquipRangevalList=EquipRangevalList_"&"
	.s EquipRangevalList=EquipRangevalList_"^5^"_EquipID_"^Y"
	s Return=##Class(web.DHCEQ.EM.BUSEquipRange).SaveEquipRange(EquipRangeval,EquipRangevalList)
	//s Return=##Class(web.DHCEQ.EM.BUSEquipRange).SaveEquipRangeList(ERRowID,valList)
	
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson($p(Return,"^",1))
	
ERRORAppendEquip
	Set ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// 根据计划单获取正在执行中的计划执行表
/// w ##Class(web.DHCEQ.EM.BUSMaintPlan).GetExecuteIDs(39)
ClassMethod GetExecuteIDs(MPRowID)
{
	i MPRowID="" q ""
	n PERowID,ExecuteIDs
	s ExecuteIDs=""
	s PERowID=0
	f  s PERowID=$o(^DHCEQPlanExecute(0,"MaintPlan",MPRowID,PERowID)) quit:PERowID=""  d
	.q:$p($g(^DHCEQPlanExecute(PERowID)),"^",6)'=0
	.s:ExecuteIDs'="" ExecuteIDs=ExecuteIDs_","
	.s ExecuteIDs=ExecuteIDs_PERowID
 	Quit ExecuteIDs
}

/// Description:追加设备至执行单
/// w ##class(web.DHCEQ.EM.BUSMaintPlan).UpdateExecuteList(21,"10")
ClassMethod UpdateExecuteList(MPRowID, EquipDRStr As %String = "")
{
	i MPRowID="" q 0
	s ExecuteIDs=##Class(web.DHCEQ.EM.BUSMaintPlan).GetExecuteIDs(MPRowID)
	i ExecuteIDs="" q 0
	
	n SQLCODE,EquipDRLen,ExecuteLen,EquipID,ExecuteID,i,j,ERRowID,SupportRowIDs,FindFlag,ERLID
	Set $ZT="ERRORUpdateExecuteList"
	Set SQLCODE=0
	s ERRowID=$o(^DHCEQEquipRange(0,"SourceID",2,MPRowID,""))
	;s ^TMPMozy("web.DHCEQ.EM.BUSMaintPlan.Assign")=MPRowID_","_EquipDRStr
	
	TSTART
	s ExecuteLen=$l(ExecuteIDs,",")
	i EquipDRStr'=""
	{
		; 将追加的设备插入至相关执行单中
		s EquipDRLen=$l(EquipDRStr,",")
		for i=1:1:EquipDRLen q:SQLCODE'=0  d
		.s EquipID=$p(EquipDRStr,",",i)
		.
		.for j=1:1:ExecuteLen q:SQLCODE'=0  d
		..s ExecuteID=$p(ExecuteIDs,",",j)
		..
		..; ^DHCEQPlanExecuteList(0,"PlanExecute",28,64)=""
		..s FindFlag=0		; 查找该设备是否已存在当前执行单中
		..s PELRowID=0
		..f  s PELRowID=$o(^DHCEQPlanExecuteList(0,"PlanExecute",ExecuteID,PELRowID)) quit:PELRowID=""  d
		...i $P(^DHCEQPlanExecuteList(PELRowID),"^",2)=EquipID s FindFlag=1
		..
		..;插入新执行明细
		..i FindFlag=0 d
		...k PLISTMX
		...s PLISTMX(2)=ExecuteID
		...s PLISTMX(3)=EquipID
		...;s PLISTMX(4)=0
		...s PLISTMX(5)="N"		//ExecuteFlag
		...s PLISTMX(8)=$p($g(^DHCEQMaintPlan(MPRowID)),"^",13)
		...s ItemDR=$p($g(^DHCEQEquip(EquipID)),"^",7)
		...i (PLISTMX(8)="")&&(ItemDR'="") s PLISTMX(8)=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",20)
		...&SQL(insert into sqluser.DHC_EQPlanExecuteList values :PLISTMX())
		...q:SQLCODE'=0
		...
		...; 更新计划执行表的设备总数
		...&SQL(update sqluser.DHC_EQPlanExecute set PE_TotalNum=1+PE_TotalNum where PE_RowID=:ExecuteID)
		i SQLCODE'=0
		{
			TROLLBACK
			q SQLCODE
		}
	}
	else
	{
		; 根据计划的设备范围定义表对执行单进行更新
		; 删除执行明细
		for i=1:1:ExecuteLen q:SQLCODE'=0  d
		.s ExecuteID=$p(ExecuteIDs,",",i)
		.s TotalNum=$p($g(^DHCEQPlanExecute(ExecuteIDs)),"^",4)
		.; 更新计划执行表
		.s MaintLocDR=$p($g(^DHCEQMaintPlan(MPRowID)),"^",14)
		.s MaintUserDR=$p($g(^DHCEQMaintPlan(MPRowID)),"^",15)
		.&SQL(update sqluser.DHC_EQPlanExecute set PE_ExecuteLocDR=:MaintLocDR,PE_BeginUserDR=:MaintUserDR where PE_RowID=:ExecuteID)
		.q:SQLCODE'=0
		.
		.; ^DHCEQPlanExecuteList(0,"PlanExecute",28,64)=""
		.s PELRowID=0
		.f  s PELRowID=$o(^DHCEQPlanExecuteList(0,"PlanExecute",ExecuteID,PELRowID)) quit:PELRowID=""  d
		..s FindFlag=0		; 查找该设备是否已存在当前执行单中
		..s EquipID=0
		..f  s EquipID=$o(^DHCEQEquipRangeList(0,"LimitValue",ERRowID,5,EquipID)) q:(EquipID="")||(FindFlag=1)  d
		...s ERLID=$o(^DHCEQEquipRangeList(0,"LimitValue",ERRowID,5,EquipID,""))
		...q:$p($g(^DHCEQEquipRangeList(ERLID)),"^",4)'="Y"
		...;s EquipID=$p($g(^DHCEQEquipRangeList(ERLID)),"^",3)
		...i $P(^DHCEQPlanExecuteList(PELRowID),"^",2)=EquipID d
		....s FindFlag=1
		....if SupportRowIDs'="" s SupportRowIDs=SupportRowIDs_","	;已存在的设备ID
		....s SupportRowIDs=SupportRowIDs_EquipID
		..
		..Quit:$P(^DHCEQPlanExecuteList(PELRowID),"^",3)'=""	;执行过的明细应当保留
		..Quit:FindFlag=0
		..Set TotalNum=TotalNum-1
		..&SQL(delete from SQLUSER.DHC_EQPlanExecuteList where PEL_RowID = :PELRowID)	;删除无效的明细记录(即未执行且不在计划范围内
		.q:SQLCODE'=0
		.
		.&SQL(update sqluser.DHC_EQPlanExecute set PE_TotalNum=:TotalNum where PE_RowID=:ExecuteID)
		i SQLCODE'=0
		{
			TROLLBACK
			q SQLCODE
		}
		
		; 追加执行明细
		s EquipID=0
		f  s EquipID=$o(^DHCEQEquipRangeList(0,"LimitValue",ERRowID,5,EquipID)) q:(EquipID="")||(SQLCODE'=0)  d
		.s ERLID=$o(^DHCEQEquipRangeList(0,"LimitValue",ERRowID,5,EquipID,""))
		.q:$p($g(^DHCEQEquipRangeList(ERLID)),"^",4)'="Y"
		.;s EquipID=$p($g(^DHCEQEquipRangeList(ERLID)),"^",3)
		.q:(","_SupportRowIDs_",")[(","_EquipID_",")
		.
		.;各执行表插入新执行明细
		.for i=1:1:ExecuteLen q:SQLCODE'=0  d
		..s ExecuteID=$p(ExecuteIDs,",",i)
		..s TotalNum=$p($g(^DHCEQPlanExecute(ExecuteIDs)),"^",4)
		..k PLISTMX
		..s PLISTMX(2)=ExecuteID
		..s PLISTMX(3)=EquipID
		..;s PLISTMX(4)=0
		..s PLISTMX(5)="N"		//ExecuteFlag
		..s PLISTMX(8)=$p($g(^DHCEQMaintPlan(MPRowID)),"^",13)
		..s ItemDR=$p($g(^DHCEQEquip(EquipID)),"^",7)
		..i (PLISTMX(8)="")&&(ItemDR'="") s PLISTMX(8)=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",20)
		..&SQL(insert into sqluser.DHC_EQPlanExecuteList values :PLISTMX())
		..q:SQLCODE'=0
		..Set TotalNum=TotalNum+1
		..&SQL(update sqluser.DHC_EQPlanExecute set PE_TotalNum=:TotalNum where PE_RowID=:ExecuteID)
		i SQLCODE'=0
		{
			TROLLBACK
			q SQLCODE
		}
	}
	
	TCOMMIT
	q SQLCODE

ERRORUpdateExecuteList
 	TROLLBACK		         //回滚事务
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORAssign"_ErrorMsg     //返回错误消息
}

/// Description:维护计划派单
/// w ##class(web.DHCEQ.EM.BUSMaintPlan).Assign(29,202,12,"2021-04-01","2021-04-30")
ClassMethod Assign(MPRowID, MaintLocDR, MaintUserDR, SDate, EDate)
{
	i MPRowID="" q 0
	Set $ZT="ERRORAssign"
	Set SQLCODE=0
	;s ^TMPMozy("web.DHCEQ.EM.BUSMaintPlan.Assign")=MPRowID_","_MaintLocDR_","_MaintUserDR_","_SDate_","_EDate
	i MaintLocDR="" s MaintLocDR=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	i MaintUserDR="" s MaintUserDR=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s SDate = ##Class(web.DHCEQCommon).TransValueFromPage(SDate, "date")	// MZY0093	2021-09-08
	; 判断重复派单	MaintUserDR
	s PlanExeID=$o(^DHCEQPlanExecute(0,"MaintPlan",MPRowID,""),-1)
	i (PlanExeID'="")&&($p($g(^DHCEQPlanExecute(PlanExeID)),"^",6)=0)
	{
		// 作废当前正在执行的计划执行表
		&SQL(update sqluser.DHC_EQPlanExecute set PE_Status=2 where PE_RowID=:PlanExeID)
	}
	s SQLCODE=##Class(web.DHCEQ.EM.BUSMaintPlan).ExecuteMaintPlan(MPRowID,"",MaintUserDR,MaintLocDR,SDate)	// MZY0093	2021-09-08
	
	q SQLCODE
ERRORAssign
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORAssign"_ErrorMsg     //返回错误消息
}

/// w ##Class(web.DHCEQ.EM.BUSMaintPlan).SaveDataSimple("user")
ClassMethod SaveDataSimple(val)
{
	Set $ZT="ERRORSaveDataSimple"
	s RowID = $p(val,"^",1)
	i RowID="" q 0
	s Name = $p(val,"^",2)
	s MaintLocDR = $p(val,"^",3)
	s MaintUserDR = $p(val,"^",4)
	s SDate = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",5),"date")
	s EDate = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",6),"date")
	&SQL(update sqluser.DHC_EQMaintPlan set MP_Name=:Name, MP_MaintLocDR=:MaintLocDR, MP_MaintUserDR=:MaintUserDR, MP_SDate=:SDate, MP_EDate=:EDate where MP_RowID=:RowID)
	
	q SQLCODE_"^"_RowID
ERRORSaveDataSimple
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORSaveDataSimple"_ErrorMsg     //返回错误消息 ;
}

/// Author ZX 2021-03-26
/// Desc 获取保养检查模板明细信息,用于生成保养检查项目明细清单
/// Input Type:类型 1,保养用 2,检查用 3,维修用; TemplateDR:模板ID; EquipDR:设备ID; ItemFactorKey:因素关键字; GroupID:类组ID;
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSMaintPlan","GetTemplateList","1","20","5","3","37","","85")
/// Modify by zx 2021-07-14 参数调整,不局限于设备id获取模板 
Query GetTemplateList(Type, TemplateDR As %String = "", RangeType As %String = "", RangeID As %String = "", MaintDR As %String = "", ItemFactorKey As %String = "", GroupID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TMaintItemDR:%String,TNote:%String,TSort:%String,TDefaultVal:%String,TItemFactorKey:%String,TItemCode:%String,TItemDesc:%String,TItemRemark:%String,TItemType:%String,TItemItemCatDR:%String,TItemItemCat:%String,TItemNote:%String,TItemDateType:%String,TItemDisplayType:%String,TItemQualitative:%String,TItemSettingFlag:%String,TItemMultiChoiceFlag:%String,TMaintItemValues:%String,TMaintItemNormalValues:%String,TPMReportListID:%String,TTemplateDR:%String,TTemplate:%String")
{
}

ClassMethod GetTemplateListExecute(ByRef qHandle As %Binary, Type, TemplateDR As %String = "", RangeType As %String = "", RangeID As %String = "", MaintDR As %String = "", ItemFactorKey As %String = "", GroupID As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	i GroupID="" s GroupID=%session.Get("LOGON.GROUPID")
	s index=1
	//模板id和设备id不能同时为空
	i (TemplateDR="")&&(RangeID="")&&(MaintDR="") Quit $$$OK
	s RecievedItemDR=""  //一个项目仅获取一次
	s PMReportDR=""
	
	//Modify by zx 2021-05-28 退出判断报错问题处理
	s TemplateListDR=0
	if MaintDR'="" d
	.s PMReportDR=$o(^DHCEQPMReport(0,"MaintDR",MaintDR,0))
	.q:PMReportDR=""
	.s TTemplateDR=$p($g(^DHCEQPMReport(PMReportDR)),"^",1)
	.i TTemplateDR'="" s TTemplate=$p($g(^DHCEQCCode("DHCEQCPMTemplate",TTemplateDR)),"^",2)
	.s PMReportListDR=0
	.f  s PMReportListDR=$o(^DHCEQPMReportList(0,"ReportDR",PMReportDR,PMReportListDR)) q:PMReportListDR=""  d
	..d ResetVariablesGetTemplateList
	..s TMaintItemDR=$p($g(^DHCEQPMReportList(PMReportListDR)),"^",2)
	..q:TMaintItemDR=""
	..s TNote=$p($g(^DHCEQPMReportList(PMReportListDR)),"^",4)
	..s TSort=$p($g(^DHCEQPMReportList(PMReportListDR)),"^",6)
	..s TDefaultVal=$p($g(^DHCEQPMReportList(PMReportListDR)),"^",3)
	..s TItemFactorKey=$p($g(^DHCEQPMReportList(PMReportListDR)),"^",10)
	..q:(ItemFactorKey'="")&(ItemFactorKey'=TItemFactorKey)
	..s TPMReportListID=PMReportListDR  /// ZC2021-4-14 增加输出TPMReportListID
	..s ReportListFactorID=$o(^DHCEQPMReportListFactor(0,"ReportListDR",PMReportListDR,""))
	..i ReportListFactorID'="" s TFactorID=$p($g(^DHCEQPMReportListFactor(ReportListFactorID)),"^",2)
	..i (","_RecievedItemDR_",")'[(","_TMaintItemDR_",") d
	...i RecievedItemDR'="" s RecievedItemDR=RecievedItemDR_","
	...s RecievedItemDR=RecievedItemDR_TMaintItemDR
	...d GetTemplateListInfo
	else  if TemplateDR'="" d
	.s TTemplateDR=TemplateDR
	.s TTemplate=$p($g(^DHCEQCCode("DHCEQCPMTemplate",TTemplateDR)),"^",2)
	.s Sort=0
	.f  s Sort=$o(^DHCEQCCode("DHCEQCPMTemplateList",0,"PMTLTemplateDR",TemplateDR,Sort)) q:Sort=""  d
	..f  s TemplateListDR=$o(^DHCEQCCode("DHCEQCPMTemplateList",0,"PMTLTemplateDR",TemplateDR,Sort,TemplateListDR)) q:TemplateListDR=""  d
	...d ResetVariablesGetTemplateList
	...s TRowID=TemplateListDR
	...s TMaintItemDR=$p($g(^DHCEQCCode("DHCEQCPMTemplateList",TRowID)),"^",2)
	...q:TMaintItemDR=""
	...s TNote=$p($g(^DHCEQCCode("DHCEQCPMTemplateList",TRowID)),"^",3)
	...s TSort=$p($g(^DHCEQCCode("DHCEQCPMTemplateList",TRowID)),"^",4)
	...s TDefaultVal=$p($g(^DHCEQCCode("DHCEQCPMTemplateList",TRowID)),"^",5)
	...s TItemFactorKey=$p($g(^DHCEQCCode("DHCEQCPMTemplateList",TRowID)),"^",6)
	...q:(ItemFactorKey'="")&(ItemFactorKey'=TItemFactorKey)
	...q:$p($g(^DHCEQCCode("DHCEQCMaintItem",TMaintItemDR)),"^",4)="Y"
	...i (","_RecievedItemDR_",")'[(","_TMaintItemDR_",") d
	....i RecievedItemDR'="" s RecievedItemDR=RecievedItemDR_","
	....s RecievedItemDR=RecievedItemDR_TMaintItemDR
	....d GetTemplateListInfo
	else  d
	.//Modify by zx 2021-05-27 根据优先级获取模板
	.s TemplateDR=##Class(web.DHCEQ.EM.BUSMaintPlan).GetTemplateByEquip(Type, RangeType, RangeID)
	.s Sort=0
	.i TemplateDR'="" d
	..s TTemplateDR=TemplateDR
	..s TTemplate=$p($g(^DHCEQCCode("DHCEQCPMTemplate",TTemplateDR)),"^",2)
	..f  s Sort=$o(^DHCEQCCode("DHCEQCPMTemplateList",0,"PMTLTemplateDR",TemplateDR,Sort)) q:Sort=""  d
	...f  s TemplateListDR=$o(^DHCEQCCode("DHCEQCPMTemplateList",0,"PMTLTemplateDR",TemplateDR,Sort,TemplateListDR)) q:TemplateListDR=""  d
	....d ResetVariablesGetTemplateList
	....s TRowID=TemplateListDR
	....s TMaintItemDR=$p($g(^DHCEQCCode("DHCEQCPMTemplateList",TRowID)),"^",2)
	....q:TMaintItemDR=""
	....s TNote=$p($g(^DHCEQCCode("DHCEQCPMTemplateList",TRowID)),"^",3)
	....s TSort=$p($g(^DHCEQCCode("DHCEQCPMTemplateList",TRowID)),"^",4)
	....s TDefaultVal=$p($g(^DHCEQCCode("DHCEQCPMTemplateList",TRowID)),"^",5)
	....s TItemFactorKey=$p($g(^DHCEQCCode("DHCEQCPMTemplateList",TRowID)),"^",6)
	....q:(ItemFactorKey'="")&(ItemFactorKey'=TItemFactorKey)
	....q:$p($g(^DHCEQCCode("DHCEQCMaintItem",TMaintItemDR)),"^",4)="Y"
	....i (","_RecievedItemDR_",")'[(","_TMaintItemDR_",") d
	.....i RecievedItemDR'="" s RecievedItemDR=RecievedItemDR_","
	.....s RecievedItemDR=RecievedItemDR_TMaintItemDR
	.....d GetTemplateListInfo
	
	Quit $$$OK

GetTemplateListInfo
	s TItemCode=$p($g(^DHCEQCCode("DHCEQCMaintItem",TMaintItemDR)),"^",1)
	s TItemDesc=$p($g(^DHCEQCCode("DHCEQCMaintItem",TMaintItemDR)),"^",2)
	s TItemRemark=$p($g(^DHCEQCCode("DHCEQCMaintItem",TMaintItemDR)),"^",3)
	s TItemType=$p($g(^DHCEQCCode("DHCEQCMaintItem",TMaintItemDR)),"^",5)
	s TItemItemCatDR=$p($g(^DHCEQCCode("DHCEQCMaintItem",TMaintItemDR)),"^",6)
	i TItemItemCatDR'="" s TItemItemCat=$p($g(^DHCEQCCode("DHCEQCMaintItemCat")),"^",3)
	s TItemNote=$p($g(^DHCEQCCode("DHCEQCMaintItem",TMaintItemDR)),"^",8)
	s TItemDateType=$p($g(^DHCEQCCode("DHCEQCMaintItem",TMaintItemDR)),"^",9)
	s TItemDisplayType=$p($g(^DHCEQCCode("DHCEQCMaintItem",TMaintItemDR)),"^",10)
	s TItemQualitative=$p($g(^DHCEQCCode("DHCEQCMaintItem",TMaintItemDR)),"^",11)
	s TItemSettingFlag=$p($g(^DHCEQCCode("DHCEQCMaintItem",TMaintItemDR)),"^",12)
	s TItemMultiChoiceFlag=$p($g(^DHCEQCCode("DHCEQCMaintItem",TMaintItemDR)),"^",13)
	s TMaintItemValues=##Class(web.DHCEQ.EM.BUSMaintPlan).GetMaintItemValues(TMaintItemDR)
	s TMaintItemNormalValues=##Class(web.DHCEQ.EM.BUSMaintPlan).GetMaintItemNormalValues(TMaintItemDR,PMReportDR)
	d OutputRowGetTemplateList
	
	quit
OutputRowGetTemplateList
	s Data=$lb(TRowID,TMaintItemDR,TNote,TSort,TDefaultVal,TItemFactorKey,TItemCode,TItemDesc,TItemRemark,TItemType,TItemItemCatDR,TItemItemCat,TItemNote,TItemDateType,TItemDisplayType,TItemQualitative,TItemSettingFlag,TItemMultiChoiceFlag,TMaintItemValues,TMaintItemNormalValues,TPMReportListID,TTemplateDR,TTemplate)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetTemplateList
	s (TRowID,TMaintItemDR,TNote,TSort,TDefaultVal,TItemFactorKey,TItemCode,TItemDesc,TItemRemark,TItemType,TItemItemCatDR,TItemItemCat,TItemNote,TItemDateType,TItemDisplayType,TItemQualitative,TItemSettingFlag,TItemMultiChoiceFlag,TMaintItemValues,TMaintItemNormalValues,TPMReportListID,TFactorID)=""
	quit
}

ClassMethod GetTemplateListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTemplateListExecute ]
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

ClassMethod GetTemplateListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTemplateListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQ.EM.BUSMaintPlan).GetMaintItemValues("3")
ClassMethod GetMaintItemValues(MaintItemDR)
{
	n MIVRowID,Value,Desc,NormalType
	s (MIVRowID,Value,Desc,NormalType)=""
	s Result=##class(web.DHCEQ.Plat.JsonObject).%New()
	s MIVRowID=0
	f  s MIVRowID=$o(^DHCEQCCode("DHCEQMCMaintItemValues",0,"MaintItemDR",MaintItemDR,MIVRowID)) q:MIVRowID=""  d
	.q:$p($g(^DHCEQCCode("DHCEQMCMaintItemValues",MIVRowID)),"^",5)="Y"
	.s Item=##class(web.DHCEQ.Plat.JsonObject).%New()
	.s Value=$p($g(^DHCEQCCode("DHCEQMCMaintItemValues",MIVRowID)),"^",2)
	.d Item.%Set("Value",Value)
	.s Desc=$p($g(^DHCEQCCode("DHCEQMCMaintItemValues",MIVRowID)),"^",3)
	.d Item.%Set("Desc",Desc)
	.s NormalType=$p($g(^DHCEQCCode("DHCEQMCMaintItemValues",MIVRowID)),"^",4)
	.d Item.%Set("NormalType",NormalType)
	.d Result.%Set("Item"_MIVRowID,Item)
	
	q Result.%ToJSON()
}

/// w ##Class(web.DHCEQ.EM.BUSMaintPlan).GetMaintItemNormalValues("12","6")
/// Modify by zx 2021-08-24 增加质控后获取值域信息时改变处理
ClassMethod GetMaintItemNormalValues(MaintItemDR, ValPMReportDR)
{
	n MINVRowID,ValueType,AllFlag,NormalValue,MinValue,MaxValue,ItemFactorKey
	s (MINVRowID,ValueType,AllFlag,NormalValue,MinValue,MaxValue,ItemFactorKey)=""
	s Result=##class(web.DHCEQ.Plat.JsonObject).%New()
	s MINVRowID=0
	f  s MINVRowID=$o(^DHCEQCCode("DHCEQMCMaintItemNormalValues",0,"MaintItemDR",MaintItemDR,MINVRowID)) q:MINVRowID=""  d
	.s Item=##class(web.DHCEQ.Plat.JsonObject).%New()
	.s ValueType=$p($g(^DHCEQCCode("DHCEQMCMaintItemNormalValues",MINVRowID)),"^",2)
	.d Item.%Set("ValueType",ValueType)
	.s AllFlag=$p($g(^DHCEQCCode("DHCEQMCMaintItemNormalValues",MINVRowID)),"^",3)
	.d Item.%Set("AllFlag",AllFlag)
	.s ItemFactorKey=$p($g(^DHCEQCCode("DHCEQMCMaintItemNormalValues",MINVRowID)),"^",7)
	.d Item.%Set("ItemFactorKey",ItemFactorKey)
	.s NormalValue=$p($g(^DHCEQCCode("DHCEQMCMaintItemNormalValues",MINVRowID)),"^",4)
	.//当报告不为空,取报告中的值
	.i PMReportDR'="" d
	..s NormalValue=##Class(web.DHCEQ.EM.BUSMaintPlan).GetNormalValueByReport(ValPMReportDR,MaintItemDR,ItemFactorKey)
	.d Item.%Set("NormalValue",NormalValue)
	.s MinValue=$p($g(^DHCEQCCode("DHCEQMCMaintItemNormalValues",MINVRowID)),"^",5)
	.d Item.%Set("MinValue",MinValue)
	.s MaxValue=$p($g(^DHCEQCCode("DHCEQMCMaintItemNormalValues",MINVRowID)),"^",6)
	.d Item.%Set("MaxValue",MaxValue)
	.s MaintItemFactorFlag=0
	.s MaintItemFactorDR=0
	.f  s MaintItemFactorDR=$o(^DHCEQCCode("DHCEQMCMaintItemFactor",0,"NormalValuesDR",MINVRowID,MaintItemFactorDR)) q:MaintItemFactorDR=""  d
	..s MaintItemFactorFlag=1
	..s CurFactorDR=$p($g(^DHCEQCCode("DHCEQMCMaintItemFactor",MaintItemFactorDR)),"^",2)
	..;q:(FactorDR'="")&&(FactorDR'=CurFactorDR)  //取消根据因素过滤
	..d Item.%Set("MaintItemFactor",MaintItemFactorDR)
	..s FactorCat=$p($g(^DHCEQCCode("DHCEQMCFactor",CurFactorDR)),"^",2)
	..s FactorDesc=$p($g(^DHCEQCCode("DHCEQMCFactor",CurFactorDR)),"^",4)
	..d Item.%Set("FactorDesc",FactorCat_FactorDesc)
	..d Result.%Set("ItemFactor"_MINVRowID,Item)
	.i MaintItemFactorFlag=0 d
	..d Result.%Set("Item"_MINVRowID,Item)
	
	q Result.%ToJSON()
}

/// Author:add by ZX 2021-02-23
/// Description: 维护计划设备预警
/// Command:d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSMaintPlan","GetMaintPlanByEquip","1","","","","","","","","85")
Query GetMaintPlanByEquip(BussType As %String = "", EquipDR As %String = "", MaintLocDR As %String = "", MaintTypeDR As %String = "", QXType As %String = "", PlanNameDR As %String = "", No As %String = "", PlanName As %String = "", CurGroupID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TName:%String,TNo:%String,TMaintType:%String,TMaintLoc:%String,TMaintUser:%String,TMaintMode:%String,TModel:%String,TRemark:%String,TPlanExecuteID:%String,TPlanExecuteListID:%String,TPExecuteBeginDate:%String,TMaintID:%String")
{
}

ClassMethod GetMaintPlanByEquipExecute(ByRef qHandle As %Binary, BussType As %String = "", EquipDR As %String = "", MaintLocDR As %String = "", MaintTypeDR As %String = "", QXType As %String = "", PlanNameDR As %String = "", No As %String = "", PlanName As %String = "", CurGroupID As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
 	if CurGroupID="" s CurGroupID=%session.Get("LOGON.GROUPID")
 	
	s index=1
	s rowid=0
	f  s rowid=$o(^DHCEQMaintPlan(0,"Type",BussType,rowid))  quit:rowid=""  d
	.q:(PlanNameDR'="")&&(PlanNameDR'=rowid)
	.d CheckEquipPlan
	.q:pass=0
	.s (EquipIDs,TMeasureFlag)=""
	.i TMaintTypeDR=5 s TMeasureFlag="Y"
	.s EquipIDs=##Class(web.DHCEQ.EM.BUSMaintPlan).GetMaintEquips(2,rowid,TMeasureFlag,CurGroupID)
	.q:EquipIDs=""
	.s len=$l(EquipIDs,",")
	.f i=1:1:len d
	..s EquipID=$p(EquipIDs,",",i)
	..q:EquipID=""
	..d CheckMaintPlanEquipID
	..q:pass=0
	..s TPlanExecuteID=$o(^DHCEQPlanExecute(0,"MaintPlan",rowid,""),-1)
	..q:TPlanExecuteID=""
	..q:($p($g(^DHCEQPlanExecute(TPlanExecuteID)),"^",6)'="0")
	..s TPlanExecuteListID=""
	..s CurPlanExecuteListID=0
	..f  s CurPlanExecuteListID=$o(^DHCEQPlanExecuteList(0,"PlanExecute",TPlanExecuteID,CurPlanExecuteListID)) q:(CurPlanExecuteListID="")||(TPlanExecuteListID'="")  d
	...q:($p($g(^DHCEQPlanExecuteList(CurPlanExecuteListID)),"^",2)'=EquipID)
	...s TPlanExecuteListID=CurPlanExecuteListID
	...d OutputRowGetMaintPlanByEquip
	
	Quit $$$OK
CheckEquipPlan
	s pass=1
	if ($p($g(^DHCEQMaintPlan(rowid)),"^",26)'="2")
	{
		s pass=0
		q
	}
	if ($p($g(^DHCEQMaintPlan(rowid)),"^",36)="Y")
	{
		s pass=0
		q
	}
	set TMaintTypeDR=$p($g(^DHCEQMaintPlan(rowid)),"^",9)
	if (TMaintTypeDR'=MaintTypeDR)&(MaintTypeDR'="")
	{
		s pass=0
		q
	}
 	if (MaintLocDR'="")&&(MaintLocDR'=$p($g(^DHCEQMaintPlan(rowid)),"^",14))
	{
		s pass=0
		q
	}
	quit
CheckMaintPlanEquipID
	s pass=1
	if (EquipDR'="")&(EquipDR'=EquipID)
	{
		s pass=0
		q
	}
	if (No'="")&&($p($g(^DHCEQEquip(EquipID)),"^",71)'[No)
	{
		s pass=0
		q
	}
	if $p($g(^DHCEQEquip(EquipID)),"^",38)>"2"
	{
		s pass=0
		q
	}
	set StockStatus=$p($g(^DHCEQEquip(EquipID)),"^",60)
	if (StockStatus="0")||(StockStatus>"2")
	{
		s pass=0
		q
	}
	if ($p($g(^DHCEQEquip(EquipID)),"^",59))'="N"
	{
		s pass=0
		q
	}
	quit
OutputRowGetMaintPlanByEquip	
	d ResetVariablesGetMaintPlanByEquip
	s TRowID = rowid
	s TName = $p($g(^DHCEQMaintPlan(rowid)),"^",1)
	s TNo = $p($g(^DHCEQMaintPlan(rowid)),"^",50)
	s TMaintTypeDR = $p($g(^DHCEQMaintPlan(rowid)),"^",9)
	s TMaintLocDR = $p($g(^DHCEQMaintPlan(rowid)),"^",14)
	s TMaintUserDR = $p($g(^DHCEQMaintPlan(rowid)),"^",15)
	s TMaintModeDR = $p($g(^DHCEQMaintPlan(rowid)),"^",16)
	s TRemark = $p($g(^DHCEQMaintPlan(rowid)),"^",25)
	i TModelDR'="" s TModel=$p($G(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	i TMaintTypeDR '="" s TMaintType = $p($g(^DHCEQCCode("DHCEQCMaintType",TMaintTypeDR)),"^",2)
	i TMaintLocDR '="" s TMaintLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TMaintLocDR)		// MZY0099	2180651		2021-11-13
	i TMaintUserDR '="" s TMaintUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TMaintUserDR)
	i TMaintModeDR '="" s TMaintMode = $p($g(^DHCEQCCode("DHCEQCMaintMode",TMaintModeDR)),"^",2)
	s TPExecuteBeginDate = $p($g(^DHCEQPlanExecute(TPlanExecuteID)),"^",7)
	s TPExecuteBeginDate=##Class(web.DHCEQCommon).TransValueToPage(TPExecuteBeginDate,"date")
	s TMaintID = $p($g(^DHCEQPlanExecuteList(TPlanExecuteListID)),"^",3)
	s Data=$lb(TRowID,TName,TNo,TMaintType,TMaintLoc,TMaintUser,TMaintMode,TModel,TRemark,TPlanExecuteID,TPlanExecuteListID,TPExecuteBeginDate,TMaintID)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetMaintPlanByEquip
	Set (TRowID,TName,TNo,TMaintTypeDR,TMaintType,TMaintLocDR,TMaintLoc,TMaintUserDR,TMaintUser,TMaintModeDR,TMaintMode,TModelDR,TModel,TRemark,TPExecuteBeginDate,TMaintID)=""
	quit
}

ClassMethod GetMaintPlanByEquipFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPlanAlertExecute ]
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

ClassMethod GetMaintPlanByEquipClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPlanAlertExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Author: add by ZX 2021-05-27
/// Description: 根据设备信息获取最优级别模板
/// Input: BussType,业务类型; RangeSourceType,限定来源类型,默认'5'为设备 SourceID,限定来源id
/// w ##Class(web.DHCEQ.EM.BUSMaintPlan).GetTemplateByEquip("1", "5", "9")
ClassMethod GetTemplateByEquip(BussType, SourceRangeType As %String = "5", SourceID)
{
	n ResultTempLateDR,NextRangeType,NextSourceID
	s (ResultTempLateDR,NextRangeType,NextSourceID)=""
	
	s NextRangeType=SourceRangeType
	s NextSourceID=SourceID
	//从设备层级开始,逐层往下,当前层无满足模板时,取下一层所需信息
	if NextRangeType="5"
	{
		d GetResultTempLate
		d SetSourceInfo
	}
	i ResultTempLateDR'="" q ResultTempLateDR
	if NextRangeType="6"
	{
		d GetResultTempLate
		d SetSourceInfo
	}
	i ResultTempLateDR'="" q ResultTempLateDR
	//模板暂时不考虑按科室分
	if NextRangeType="3"
	{
		d GetResultTempLate
		d SetSourceInfo
	}
	i ResultTempLateDR'="" q ResultTempLateDR
	if NextRangeType="2"
	{
		d GetResultTempLate
		d SetSourceInfo
	}
	i ResultTempLateDR'="" q ResultTempLateDR
	if NextRangeType="1"
	{
		d GetResultTempLate
	}
	
	q ResultTempLateDR
	
GetResultTempLate
	q:NextSourceID=""
	s ResultRangID=""
	s RangListID=0
	f  s RangListID=$o(^DHCEQEquipRangeList(0,"Value",NextSourceID,RangListID)) q:(RangListID="")||(ResultTempLateDR'="")  d
	.q:$p($g(^DHCEQEquipRangeList(RangListID)),"^",4)="N"  //过滤不可访问类型
	.s RangeType=$p($g(^DHCEQEquipRangeList(RangListID)),"^",2)
	.q:NextRangeType'=RangeType
	.s RangID=$p($g(^DHCEQEquipRangeList(RangListID)),"^",1)
	.q:RangID="" //主表为空过滤
	.q:$p($g(^DHCEQEquipRange(RangID)),"^",2)'="3"  //只取模板限定
	.s TempLateDR=$p($g(^DHCEQEquipRange(RangID)),"^",3)
	.q:TempLateDR="" //过滤模板为空
	.q:($p($g(^DHCEQCCode("DHCEQCPMTemplate",TempLateDR)),"^",1))'=BussType
	.s ResultTempLateDR=TempLateDR
	
	quit
SetSourceInfo
	i (SourceRangeType="5")&&(NextRangeType="5")
	{
		//来源设备获取设备项
		s NextSourceID=$p($g(^DHCEQEquip(SourceID)),"^",7)
		s NextRangeType="6"
	}
	elseif (SourceRangeType="5")&&(NextRangeType="6")
	{
		//来源设备获取分类
		s NextSourceID=$p($g(^DHCEQEquip(SourceID)),"^",4)
		s NextRangeType="3"
	}
	elseif (SourceRangeType="6")&&(NextRangeType="6")
	{
		//来源设备项获取分类
		s NextSourceID=$p($g(^DHCEQCCode("DHCEQCMasterItem",SourceID)),"^",4)
		s NextRangeType="3"
	}
	elseif (SourceRangeType="5")&&(NextRangeType="3")
	{
		//来源设备项获取类型
		s NextSourceID=$p($g(^DHCEQEquip(SourceID)),"^",75)
		s NextRangeType="2"
	}
	elseif (SourceRangeType="6")&&(NextRangeType="3")
	{
		//来源设备项获取类型
		s NextSourceID=$p($g(^DHCEQCCode("DHCEQCMasterItem",SourceID)),"^",5)
		s NextRangeType="2"
	}
	elseif (SourceRangeType="5")&&(NextRangeType="2")
	{
		//来源设备项获取类组
		s NextSourceID=$p($g(^DHCEQEquip(SourceID)),"^",63)
		s NextRangeType="1"
	}
	elseif (SourceRangeType="6")&&(NextRangeType="2")
	{
		//来源设备项获取类组
		s NextSourceID=$p($g(^DHCEQCCode("DHCEQCMasterItem",SourceID)),"^",3)
		s NextRangeType="1"
	}
	elseif (SourceRangeType="2")&&(NextRangeType="2")
	{
		//来源设备项获取类组
		s NextSourceID=""
		s NextRangeType="1"
		
		s SourceFinanceTypeDR=$p($g(^DHCEQCCode("DHCEQCStatCat",SourceID)),"^",12)
		s SourceEquipTypeDR=0
		f  s SourceEquipTypeDR=$o(^DHCEQCCode("DHCEQCEquipType",SourceEquipTypeDR)) q:(SourceEquipTypeDR="")||(NextSourceID'="")  d
		.q:$p($g(^DHCEQCCode("DHCEQCEquipType",SourceEquipTypeDR)),"^",9)'=SourceFinanceTypeDR
		.s NextSourceID=SourceEquipTypeDR
	}
	else
	{
		//其余情况下一层级不存在,结束运行
		s NextRangeType=""
	}
	
	quit
}

/// author zx 2021-07-15
/// desc 根据报告获取定量元素值
/// input SourceType:质控记录关联业务类型, SourceID:质控记录关联业务id
/// output MaintID
/// w ##Class(web.DHCEQ.EM.BUSMaintPlan).GetNormalValueByReport("43","10","0402$CHAR(4)0301")
ClassMethod GetNormalValueByReport(ValueReportDR, ValueItemDR, ValueItemFactorKey)
{
	s ResultValue=""
	i (ValueReportDR="")||(ValueItemDR="") q ""
	s ValRLRowID=0
	f  s ValRLRowID=$o(^DHCEQPMReportList(0,"ReportDR",ValueReportDR,ValRLRowID)) q:(ValRLRowID="")||(ResultValue'="")  d
	.q:($p($g(^DHCEQPMReportList(ValRLRowID)),"^",2))'=ValueItemDR
	.q:(ValueItemFactorKey'="")&&(ValueItemFactorKey'=($p($g(^DHCEQPMReportList(ValRLRowID)),"^",10)))
	.s ResultValue=$p($g(^DHCEQPMReportList(ValRLRowID)),"^",3)
	
	q ResultValue
}

/// Modefied by zc0119 2022-6-20 判断计划单中的设备是否都是分险等级设备
/// w ##Class(web.DHCEQ.EM.BUSMaintPlan).CheckEquipInRisk("1")
ClassMethod CheckEquipInRisk(MaintPlanDR)
{
	s Flag=1
	s ERRowID=$o(^DHCEQEquipRange(0,"SourceID",2,MaintPlanDR,0))
	i ERRowID="" q ""
	s StatCatFlag=$p($g(^DHCEQEquipRange(ERRowID)),"^",5)  
	s EquipCatFlag=$p($g(^DHCEQEquipRange(ERRowID)),"^",6)  
	s EquipFlag=$p($g(^DHCEQEquipRange(ERRowID)),"^",8)  
	s ItemFlag=$p($g(^DHCEQEquipRange(ERRowID)),"^",9)  
	if (EquipFlag="Y")
	{
		s EquipDR=0
		f  s EquipDR=$o(^DHCEQEquipRangeList(0,"LimitValue",ERRowID,5,EquipDR))  q:(EquipDR="")||(Flag'="1")  d
		.i ('$d(^DHCEQRiskEvaluation(0,"Source",3,EquipDR))&&(Flag'="0"))  d
		..s ItemDR=$p($g(^DHCEQEquip(EquipDR)),"^",7)
		..i ('$d(^DHCEQRiskEvaluation(0,"Source",2,ItemDR))&&(Flag'="0"))  d
		...s Flag=0
		...s EquipCatDR=$p($g(^DHCEQEquip(EquipDR)),"^",4)
		...s StatCatDR=$p($g(^DHCEQEquip(EquipDR)),"^",75)
		...i $d(^DHCEQRiskEvaluation(0,"Source",1,EquipCatDR)) d
		....s Flag=1
		...i $d(^DHCEQRiskEvaluation(0,"Source",0,StatCatDR)) d
		....s Flag=1
		
	}
	i Flag'=1 q Flag
	if (ItemFlag="Y")
	{
		s ItemDR=0
		f  s ItemDR=$o(^DHCEQEquipRangeList(0,"LimitValue",ERRowID,6,ItemDR))  q:(ItemDR="")||(Flag'="1")  d
		.i ('$d(^DHCEQRiskEvaluation(0,"Source",2,ItemDR))&&(Flag'="0"))  d
		..s EquipCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",4)
		..s StatCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",5)
		..s Flag=0
		..i $d(^DHCEQRiskEvaluation(0,"Source",1,EquipCatDR)) d
		...s Flag=1
		..i $d(^DHCEQRiskEvaluation(0,"Source",0,StatCatDR)) d
		...s Flag=1
	}
	i Flag'=1 q Flag
	if (EquipCatFlag="Y")
	{
		s EquipCatDR=0
		f  s EquipCatDR=$o(^DHCEQEquipRangeList(0,"LimitValue",ERRowID,3,EquipCatDR))  q:(EquipCatDR="")||(Flag'="1")  d
		.q:$d(^DHCEQRiskEvaluation(0,"Source",1,EquipCatDR))
		.s Flag=0
	}
	i Flag'=1 q Flag
	if (StatCatFlag="Y")
	{
		s StatCatDR=0
		f  s StatCatDR=$o(^DHCEQEquipRangeList(0,"LimitValue",ERRowID,2,StatCatDR))  q:(StatCatDR="")||(Flag'="1")  d
		.q:$d(^DHCEQRiskEvaluation(0,"Source",0,StatCatDR))
		.s Flag=0
	}
	i Flag'=1 q Flag
	q Flag
}

/// Modfied by zc0124 2022-10-31 判断计划是否已执行
/// w ##Class(web.DHCEQ.EM.BUSMaintPlan).CheckMaintPlanExecute("6")
ClassMethod CheckMaintPlanExecute(MaintPlanDR)
{
	s vFlag=0
	i MaintPlanDR="" q vFlag
	; 检索计划设备范围
	s PERowID=0
	f  s PERowID=$o(^DHCEQPlanExecute(0,"MaintPlan",MaintPlanDR,PERowID)) q:(PERowID="")||(vFlag=1)  d
	.q:$p($g(^DHCEQPlanExecute(PERowID)),"^",6)'=1
	.s vFlag=1
	q vFlag
}

/// Modfied by zc0125 2022-12-09 判断计划内的某台设备是否已执行
/// w ##Class(web.DHCEQ.EM.BUSMaintPlan).CheckMaintPlanEquipExecute("6")
ClassMethod CheckMaintPlanEquipExecute(vBussType, vMaintPlanDR, vEquipDR)
{
	s vFlag=0
	i (vMaintPlanDR="")||(vEquipDR="")||(vBussType="") q vFlag
	; 检索计划设备范围
	s mRowID=0
	f  s mRowID=$o(^DHCEQMaint(0,"Equip",vBussType,vEquipDR,mRowID)) q:(mRowID="")||(vFlag=1)  d
	.q:$p($g(^DHCEQMaint(mRowID)),"^",39)="Y"
	.q:$p($g(^DHCEQMaint(mRowID)),"^",3)'=vMaintPlanDR
	.s vFlag=1
	q vFlag
}

/// Modfied by zc0122 2022-10-12 判断设备是否存在计划
/// w ##Class(web.DHCEQ.EM.BUSMaintPlan).CheckEquipInMaintplan("43")
ClassMethod CheckEquipInMaintplan(vEquipDR)
{
	s vFlag=0
	i vEquipDR="" q vFlag_"^"
	; 检索计划设备范围
	s ERID=0
	f  s ERID=$o(^DHCEQEquipRange(ERID)) q:(ERID="")||(vFlag=1)  d
	.q:$p($g(^DHCEQEquipRange(ERID)),"^",2)'=2
	.s MPID=$p($g(^DHCEQEquipRange(ERID)),"^",3)
	.q:$p($g(^DHCEQMaintPlan(MPID)),"^",26)'=2	;0:新增|1:提交|2:审核|3:作废
	.s Type=0			; 1:类组,2:类型,3:分类,4:科室,5:设备,6:设备项
	.f  s Type=$o(^DHCEQEquipRangeList(0,"LimitValue",ERID,Type)) q:(Type="")||(vFlag=1)  d
	..s Value=0
	..f  s Value=$o(^DHCEQEquipRangeList(0,"LimitValue",ERID,Type,Value)) q:(Value="")||(vFlag=1)  d
	...i (Type=1)&&(Value=$p($g(^DHCEQEquip(vEquipDR)),"^",63)) s vFlag=1
	...i (Type=2)&&(Value=$p($g(^DHCEQEquip(vEquipDR)),"^",75)) s vFlag=1
	...i (Type=3)&&(Value=$p($g(^DHCEQEquip(vEquipDR)),"^",4)) s vFlag=1
	...i (Type=4)&&(Value=$p($g(^DHCEQEquip(vEquipDR)),"^",67)) s vFlag=1
	...i (Type=5)&&(Value=vEquipDR) s FindFlag=1
	...i (Type=6)&&(Value=$p($g(^DHCEQEquip(vEquipDR)),"^",7)) s vFlag=1
	q vFlag_"^"_$p($g(^DHCEQEquip(vEquipDR)),"^",71)
}

}
