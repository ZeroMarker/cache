Class web.DHCEQMaintPlanNew Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCEQMaintPlanNew","GetMaintPlan","2","","","5","1","","","","")
/// modify by lmm 2018-12-06 增加入参：EquipRangeType,EquipRangeValue 出参：TEquipRangeType,TEquipRangeDesc
/// midify by lmm 2020-04-28 增加出参：TLastExDate	CZF0134 2021-02-23 增加出参TEquipRangeID
/// MZY0121		2022-04-15		增加维护个人标识PrivateFlag
Query GetMaintPlan(BussType, Name, MaintLocDR, MaintTypeDR, QXType As %String = "", SourceTypeDR, SourceIDDR, EquipRangeType As %String = "", EquipRangeValue As %String = "", CancelFlag As %String = "", StartDate As %String = "", EndDate As %String = "", PrivateFlag As %String = "") As %Query(ROWSPEC = "TRowID:%String,TName:%String,TSourceType:%String,TSourceID:%String,TCycleNum:%String,TCycleUnitDR:%String,TMaintTypeDR:%String,TMaintType:%String,TFromDate:%String,TEndDate:%String,TPreWarnDaysNum:%String,TMaintFee:%String,TMaintLocDR:%String,TMaintLoc:%String,TMaintUserDR:%String,TMaintUser:%String,TMaintModeDR:%String,TMaintMode:%String,TRemark:%String,TStatus:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TModelDR:%String,TModel:%String,TRow:%String,TEquipRangeType:%String,TEquipRangeDesc:%String,TLastExDate:%String,THold1User:%String,TEquipRangeID:%String,TCycleType:%String")
{
}

ClassMethod GetMaintPlanExecute(ByRef qHandle As %Binary, BussType, Name, MaintLocDR, MaintTypeDR, QXType As %String = "", SourceTypeDR, SourceIDDR, EquipRangeType As %String = "", EquipRangeValue As %String = "", CancelFlag As %String = "", StartDate As %String = "", EndDate As %String = "", PrivateFlag As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	// MZY0076	2021-05-25
	i StartDate="" d
	.s StartDate=0
	e  d
 	.s StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date") 
 	i EndDate="" d
 	.s EndDate=99999
 	e  d
 	.s EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date") 
	s index=1
	s TRow=1
	s rowid=0
	f  s rowid=$o(^DHCEQMaintPlan(rowid)) quit:rowid=""  d
	.d ResetVariablesGetMaintPlan
	.s TRowID = rowid
	.Quit:$p($g(^DHCEQMaintPlan(rowid)),"^",36)="Y"
	.s TName = $p($g(^DHCEQMaintPlan(rowid)),"^",1)
	.q:(Name'="")&&(TName'[Name)
	.s TType = $p($g(^DHCEQMaintPlan(rowid)),"^",2)
	.q:(TType'=BussType)&&(BussType'="")
	.s TSourceType = $p($g(^DHCEQMaintPlan(rowid)),"^",3)
	.;quit:(SourceTypeDR'="")&&(SourceTypeDR'=TSourceType)  ;modify by lmm 2019-01-13 804471
	.s TSourceID = $p($g(^DHCEQMaintPlan(rowid)),"^",4)
	.;quit:(SourceIDDR'="")&&(SourceIDDR'=TSourceID)  ;modify by lmm 2019-01-13 804471
	.i TSourceID '=""  d
	..i TSourceType=1  d
	...s TSourceID=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TSourceID)),"^",2)
	..e  i TSourceType=2  d
	...s TSourceID=$p($g(^DHCEQCCode("DHCEQCMasterItem",TSourceID)),"^",1)
	..e  i TSourceType=3  d
	...s TSourceID=$p($g(^DHCEQEquip(TSourceID)),"^",1)
	.s TModelDR =$p($g(^DHCEQMaintPlan(rowid)),"^",5)
	.i TModelDR'="" s TModel=$p($G(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.i TSourceType'=""  s TSourceType =$CASE(TSourceType,"1":"设备分类","2":"设备项","3":"设备")
	.s TCycleNum = $p($g(^DHCEQMaintPlan(rowid)),"^",7)
	.s TCycleUnitDR = $p($g(^DHCEQMaintPlan(rowid)),"^",8)
	.i TCycleUnitDR '="" s TCycleUnit = $p($g(^DHCEQCCode("DHCEQCCycleUnit",TCycleUnitDR)),"^",2)
	.s TCycleNum=TCycleNum_TCycleUnit   //modify by lmm 2020-05-13
	.s TMaintTypeDR = $p($g(^DHCEQMaintPlan(rowid)),"^",9)
	.q:((MaintTypeDR'="")&&(TMaintTypeDR'=MaintTypeDR))
	.i TMaintTypeDR '="" s TMaintType = $p($g(^DHCEQCCode("DHCEQCMaintType",TMaintTypeDR)),"^",2)
	.// MZY0076	2021-05-25
	.s TFromDate=$p($g(^DHCEQMaintPlan(rowid)),"^",48)
	.i TFromDate="" s TFromDate=$p($g(^DHCEQMaintPlan(rowid)),"^",10)
	.q:(TFromDate<StartDate)&&(TFromDate'="")
	.q:(TFromDate>EndDate)&&(TFromDate'="")
	.s TFromDate = ##Class(web.DHCEQCommon).TransValueToPage(TFromDate, "date")
	.s TEndDate=$p($g(^DHCEQMaintPlan(rowid)),"^",49)
	.i TEndDate="" s TEndDate=$p($g(^DHCEQMaintPlan(rowid)),"^",11)
	.s TEndDate = ##Class(web.DHCEQCommon).TransValueToPage(TEndDate, "date")
	.s TPreWarnDaysNum = $p($g(^DHCEQMaintPlan(rowid)),"^",12)
	.s TMaintFee = $p($g(^DHCEQMaintPlan(rowid)),"^",13)
	.S TMaintFee=TMaintFee+##Class(web.DHCEQMaintPlanNew).GetOtherFee(rowid,1)
	.s TMaintFee=##Class(web.DHCEQCommon).FormatNumber(TMaintFee,"")
	.s TMaintLocDR = $p($g(^DHCEQMaintPlan(rowid)),"^",14)
	.q:(TMaintLocDR'=MaintLocDR)&(MaintLocDR'="")
	.q:((TMaintLocDR'="")&&(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TMaintLocDR)))) //2010-10-28 DJ
	.i TMaintLocDR '="" s TMaintLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TMaintLocDR)
	.s TMaintUserDR = $p($g(^DHCEQMaintPlan(rowid)),"^",15)
	.q:(PrivateFlag=1)&&(##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))'=TMaintUserDR)	;MZY0121		2022-04-15
	.i TMaintUserDR '="" s TMaintUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TMaintUserDR)
	.s TMaintModeDR = $p($g(^DHCEQMaintPlan(rowid)),"^",16)
	.i TMaintModeDR '="" s TMaintMode = $p($g(^DHCEQCCode("DHCEQCMaintMode",TMaintModeDR)),"^",2)
	.s TRemark = $p($g(^DHCEQMaintPlan(rowid)),"^",25)
	.s TStatus = $p($g(^DHCEQMaintPlan(rowid)),"^",26)
	.q:(CancelFlag="")&&(TStatus=3)
	.q:(CancelFlag'="")&&(TStatus'=3)
	.i TStatus'=""  s TStatus = $CASE(TStatus,"0":"新增","1":"提交","2":"审核","3":"作废",:"")
	.s THold1=$p($g(^DHCEQMaintPlan(rowid)),"^",40)
	.s THold1User = ##Class(web.DHCEQCommon).GetTrakNameByID("user", THold1)	//czf 2021-02-01 1756587
	.s THold2=$p($g(^DHCEQMaintPlan(rowid)),"^",41)
	.s THold3=$p($g(^DHCEQMaintPlan(rowid)),"^",42)
	.s THold4=$p($g(^DHCEQMaintPlan(rowid)),"^",43)
	.s THold5=$p($g(^DHCEQMaintPlan(rowid)),"^",44)
	.s TEquipRangeID=$o(^DHCEQEquipRange(0,"SourceID","2",rowid,""))	//CZF0134 2021-02-23
	.s TEquipRangeStr=##Class(web.DHCEQMaintPlanNew).GetRangeDesc("2",rowid,SourceTypeDR,SourceIDDR)  ;modify by lmm 2019-01-13 804471
	.s TEquipRangeType=$p(TEquipRangeStr,"#",1)
	.s TEquipRangeDesc=$p(TEquipRangeStr,"#",2)
	.q:(TEquipRangeType="")||(TEquipRangeDesc="")  ;modify by lmm 2019-01-13 804471
	.i ($l(TEquipRangeType,",")>3) s TEquipRangeType=$p(TEquipRangeType,",",1)_","_$p(TEquipRangeType,",",2)_".."
	.i ($l(TEquipRangeDesc,",")>3) s TEquipRangeDesc=$p(TEquipRangeDesc,",",1)_","_$p(TEquipRangeDesc,",",2)_".."
	.s TWarnInfo=##Class(web.DHCEQ.EM.BUSMaintPlan).GetWarnDaysNum(rowid)
	.s TLastExDate=$p(TWarnInfo,"^",2)
	.s TLastExDate=##Class(web.DHCEQCommon).TransValueToPage(TLastExDate,"date")
	.s TCycleType = $CASE($p($g(^DHCEQMaintPlan(rowid)),"^",46),"1":"固定周期","2":"固定时间(周期)","3":"固定时间(一次)","4":"风险等级","5":"固定月份(周期)","6":"固定月份(一次)","":"其他")	// MZY0076	2021-05-25
	.d OutputRowGetMaintPlan
	Quit $$$OK
OutputRowGetMaintPlan
	Set Data=$lb(TRowID,TName,TSourceType,TSourceID,TCycleNum,TCycleUnitDR,TMaintTypeDR,TMaintType,TFromDate,TEndDate,TPreWarnDaysNum,TMaintFee,TMaintLocDR,TMaintLoc,TMaintUserDR,TMaintUser,TMaintModeDR,TMaintMode,TRemark,TStatus,THold1,THold2,THold3,THold4,THold5,TModelDR,TModel,TRow,TEquipRangeType,TEquipRangeDesc,TLastExDate,THold1User,TEquipRangeID,TCycleType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set TRow=TRow+1
	quit
ResetVariablesGetMaintPlan
	s (TRowID,TName,TSourceType,TSourceID,TCycleNum,TCycleUnitDR,TMaintTypeDR,TMaintType,TFromDate,TEndDate,TPreWarnDaysNum,TMaintFee,TMaintLocDR,TMaintLoc,TMaintUserDR,TMaintUser,TMaintModeDR,TMaintMode,TRemark,TStatus,THold1,THold2,THold3,THold4,THold5,TModelDR,TModel,TEquipRangeStr,TEquipRangeType,TEquipRangeDesc,TCycleUnit,TWarnInfo,TLastExDate,THold1User,TEquipRangeID,TCycleType)=""
	quit
}

ClassMethod GetMaintPlanFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintPlanExecute ]
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

ClassMethod GetMaintPlanClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaintPlanExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by zx 2015-09-14 增加按计划名称查询条件 Bug ZX0032
Query GetPlanAlert(BussType, EquipDR, MaintLocDR, MaintTypeDR, QXType, PlanNameDR, No, PlanName) As %Query(ROWSPEC = "TRowID:%String,TName:%String,TSourceType:%String,TEquip:%String,TEquipDR:%String,TModel:%String,TModelDR:%String,TNo:%String,TCycleNum:%String,TMaintType:%String,TMaintTypeDR:%String,TLastDate:%String,TNextDate:%String,TPreWarnDaysNum:%String,TMaintFee:%String,TMaintLoc:%String,TMaintLocDR:%String,TMaintUser:%String,TMaintUserDR:%String,TMaintMode:%String,TMaintModeDR:%String,TRemark:%String,TStatus:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TUseLocDR:%String,TUseLoc:%String,TRow:%String,TLocation:%String,TMeasureFlag:%String")
{
}

ClassMethod GetPlanAlertExecute(ByRef qHandle As %Binary, BussType, EquipDR, MaintLocDR, MaintTypeDR, QXType, PlanNameDR, No, PlanName) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	set Job=$j
 	d ##Class(web.DHCEQCommon).KillTempGlobal("DHCEQMaintAlertNew")
	s index=1
	s TRow=1  //add by zx 2015-09-17
	//"3":"设备"
	s SourceType=3
	s sourceid=0
	f  s sourceid=$o(^DHCEQMaintPlan(0,"SourceType",BussType,SourceType,sourceid))  quit:sourceid=""  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQMaintPlan(0,"SourceType",BussType,SourceType,sourceid,rowid))  quit:rowid=""  d
	..q:(PlanNameDR'="")&&(PlanNameDR'=rowid) //Bug  ZX0032
	..s EquipID=sourceid
	..q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,$p($g(^DHCEQEquip(EquipID)),"^",67))))
	..d CheckPlan
	..q:pass=0
	..d CheckEquipID
	..q:pass=0
	..d OutputRowGetPlanAlert
	//"2":"设备项"
	s SourceType=2
	s sourceid=0
	f  s sourceid=$o(^DHCEQMaintPlan(0,"SourceType",BussType,SourceType,sourceid))  quit:sourceid=""  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQMaintPlan(0,"SourceType",BussType,SourceType,sourceid,rowid))  quit:rowid=""  d
	..//先找有机型限制的,记在global中,
	..q:(PlanNameDR'="")&&(PlanNameDR'=rowid) //Bug  ZX0032
	..q:$p($g(^DHCEQMaintPlan(rowid)),"^",5)=""
	..d CheckPlan
	..q:pass=0
	..s StoreLocID=0
	..f  s StoreLocID=$o(^DHCEQEquip(0,"StoreLocItem",StoreLocID)) quit:StoreLocID=""  d
	...q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLocID)))
	...s EquipID=0
	...f  s EquipID=$o(^DHCEQEquip(0,"StoreLocItem",StoreLocID,sourceid,EquipID))  quit:EquipID=""  d
	....d CheckEquipID
	....q:pass=0
	....d OutputRowGetPlanAlert
	s SourceType=2
	s sourceid=0
	f  s sourceid=$o(^DHCEQMaintPlan(0,"SourceType",BussType,SourceType,sourceid))  quit:sourceid=""  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQMaintPlan(0,"SourceType",BussType,SourceType,sourceid,rowid))  quit:rowid=""  d
	..//没有机型限制的能在global中找到的设备就是上面已经输出的,过滤掉不输出
	..q:(PlanNameDR'="")&&(PlanNameDR'=rowid) //Bug  ZX0032
	..q:$p($g(^DHCEQMaintPlan(rowid)),"^",5)'=""
	..d CheckPlan
	..q:pass=0
	..s StoreLocID=0
	..f  s StoreLocID=$o(^DHCEQEquip(0,"StoreLocItem",StoreLocID)) quit:StoreLocID=""  d
	...q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLocID)))
	...s EquipID=0
	...f  s EquipID=$o(^DHCEQEquip(0,"StoreLocItem",StoreLocID,sourceid,EquipID))  quit:EquipID=""  d
	....d CheckEquipID
	....q:pass=0
	....d OutputRowGetPlanAlert
	//"1":"设备分类"
	s SourceType=1
	s sourceid=0
	f  s sourceid=$o(^DHCEQMaintPlan(0,"SourceType",BussType,SourceType,sourceid))  quit:sourceid=""  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQMaintPlan(0,"SourceType",BussType,SourceType,sourceid,rowid))  quit:rowid=""  d
	..q:(PlanNameDR'="")&&(PlanNameDR'=rowid) //Bug  ZX0032
	..d CheckPlan
	..q:pass=0
	..s EquipCatStr=##Class(web.DHCEQCEquipeCat).GetChildIDsByCatID(sourceid)
	..s Len=$l(EquipCatStr,"^")
	..s i=0
	..f i=1:1:Len  d
	...s ChildsSourceID=$p(EquipCatStr,"^",i)
	...s StoreLocID=0
	...f  s StoreLocID=$o(^DHCEQEquip(0,"StoreLocItem",StoreLocID)) quit:StoreLocID=""  d
	....q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLocID)))
	....s EquipID=0
	....f  set EquipID=$order(^DHCEQEquip(0,"StoreLocEquipCat",StoreLocID,ChildsSourceID,EquipID))  quit:EquipID=""  d
	.....d CheckEquipID
	.....q:pass=0
	.....d OutputRowGetPlanAlert
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
	if ($p($g(^DHCEQEquip(EquipID)),"^",59))'="N"	//add by czf 577148
	{
		s pass=0
		q
	}
	s (str,LastDate,NextDate)=""
	s str=##Class(web.DHCEQMaintPlanNew).WarnDaysNum(rowid,EquipID)
	if ($p(str,"^",1)=0)
	{
		s pass=0
		q
	}
	///过滤计量计划中来源为设备分类和设备项的非计量设备  modified by czf 2017-03-28 需求号：336771
	if (TMaintTypeDR=5)&&((SourceType=1)||(SourceType=2))&&($p($g(^DHCEQEquip(EquipID)),"^",15)'="Y")
	{
		s pass=0
		q
	}
	/// 过滤计量设备
	///增加计量类型筛选条件  modified by czf 2017-03-28 需求号：336771
	if (TMaintTypeDR=5)&&($p($g(^DHCEQMaintPlan(rowid)),"^",18)="Y")&&($p($g(^DHCEQEquip(EquipID)),"^",15)'="Y")
	{
		s pass=0
		q
	}
	/// 280902 Add By BRB 2016-11-12 实现通过保养科室的查询
 	if (MaintLocDR'="")&&(MaintLocDR'=$p($g(^DHCEQMaintPlan(rowid)),"^",14))
	{
		s pass=0
		q
	}
	s LastDate=$p(str,"^",2)
	s NextDate=$p(str,"^",3)
	if (SourceType=3)
	{
		s ^DHCEQTemp("DHCEQMaintAlertNew",Job,BussType,"3",EquipID)=""
	}
	elseif (SourceType=2)
	{
		if $D(^DHCEQTemp("DHCEQMaintAlertNew",Job,BussType,"3",EquipID))
		{
			s pass=0
			q
		}
		s (PlanModelID,EQModelID)=""
		s PlanModelID = $p($g(^DHCEQMaintPlan(rowid)),"^",5)
		s EQModelID = $p($g(^DHCEQEquip(EquipID)),"^",3)
		if (PlanModelID'="")&&(PlanModelID'=EQModelID)
		{
			s pass=0
			q
		}
		if PlanModelID=""
		{
			if $Get(^DHCEQTemp("DHCEQMaintAlertNew",Job,BussType,"2",EquipID))'=""
			{
				s pass=0
				q
			}
		}
		s ^DHCEQTemp("DHCEQMaintAlertNew",Job,BussType,"2",EquipID)=PlanModelID
	}
	elseif (SourceType=1)
	{
		if $Data(^DHCEQTemp("DHCEQMaintAlertNew",Job,BussType,"3",EquipID))
		{
			s pass=0
			q
		}
		if $Data(^DHCEQTemp("DHCEQMaintAlertNew",Job,BussType,"2",EquipID))
		{
			s pass=0
			q
		}
	}
	quit
OutputRowGetPlanAlert	
	d ResetVariablesGetPlanAlert
	s TRowID = rowid
	s TName = $p($g(^DHCEQMaintPlan(rowid)),"^",1)
	s TEquip=$p($g(^DHCEQEquip(EquipID)),"^",1)
	s TEquipDR=EquipID
	s TModelDR =$p($g(^DHCEQEquip(EquipID)),"^",3)
	s TNo =$p($g(^DHCEQEquip(EquipID)),"^",71)
	s TCycleNum = $p($g(^DHCEQMaintPlan(rowid)),"^",7)
	s TCycleUnitDR = $p($g(^DHCEQMaintPlan(rowid)),"^",8)
	i TCycleUnitDR '="" s TCycleUnit = $p($g(^DHCEQCCode("DHCEQCCycleUnit",TCycleUnitDR)),"^",2)
	s TCycleNum=TCycleNum_TCycleUnit
	s TMaintTypeDR = $p($g(^DHCEQMaintPlan(rowid)),"^",9)
	s TLastDate =##Class(web.DHCEQCommon).TransValueToPage(LastDate,"date") 	;##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaintPlan(rowid)),"^",10),"date")
	s TNextDate =##Class(web.DHCEQCommon).TransValueToPage(NextDate,"date") 	;##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaintPlan(rowid)),"^",11),"date")
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
	i TMaintLocDR '="" s TMaintLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", MaintLocDR)
	i TMaintUserDR '="" s TMaintUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TMaintUserDR)
	i TMaintModeDR '="" s TMaintMode = $p($g(^DHCEQCCode("DHCEQCMaintMode",TMaintModeDR)),"^",2)
	i TStatus'=""  s TStatus = $CASE(TStatus,"0":"新增","1":"提交","2":"审核")
	s TUseLocDR =$p($g(^DHCEQEquip(EquipID)),"^",19)  //UseLocDR
	i TUseLocDR '="" s TUseLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TUseLocDR)
	s TLocation = $p($g(^DHCEQEquip(EquipID)),"^",72)
	i TLocation'="" s TLocation=$p($g(^DHCEQCCode("DHCEQCLocation",TLocation)),"^",2)
	Set TMeasureFlag=$p($g(^DHCEQEquip(TEquipDR)),"^",15)
	If TMeasureFlag'="Y" Set TMeasureFlag=""
	s Data=$lb(TRowID,TName,TSourceType,TEquip,TEquipDR,TModel,TModelDR,TNo,TCycleNum,TMaintType,TMaintTypeDR,TLastDate,TNextDate,TPreWarnDaysNum,TMaintFee,TMaintLoc,TMaintLocDR,TMaintUser,TMaintUserDR,TMaintMode,TMaintModeDR,TRemark,TStatus,THold1,THold2,THold3,THold4,THold5,TUseLocDR,TUseLoc,TRow,TLocation,TMeasureFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set TRow=TRow+1  //add by zx 2015-09-17
	quit
ResetVariablesGetPlanAlert
	Set (TRowID,TName,TSourceType,TEquip,TEquipDR,TModel,TModelDR,TNo,TCycleNum,TCycleUnit,TMaintType,TMaintTypeDR,TLastDate,TNextDate,TPreWarnDaysNum,TMaintFee,TMaintLoc,TMaintLocDR,TMaintUser,TMaintUserDR,TMaintMode,TMaintModeDR,TRemark,TStatus,THold1,THold2,THold3,THold4,THold5,TUseLocDR,TUseLoc,TLocation,TMeasureFlag)=""
	quit
}

ClassMethod GetPlanAlertFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPlanAlertExecute ]
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

ClassMethod GetPlanAlertClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPlanAlertExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##class(web.DHCEQMaintPlanNew).WarnDaysNum(2,26238)
/// add by zx 2015-09-14 修改根据设备遍历预警日期的索引，同一设备不同计划分开预警
ClassMethod WarnDaysNum(MaintPlanID, EquipID)
{
	new BussType,CycleNum,CycleUnitDR,CycleDays,TempDate,LastDate,NextDate,id,MaintDate,pass
	s pass=1
	s (TempDate,LastDate,NextDate)=""
	s BussType = $p($g(^DHCEQMaintPlan(MaintPlanID)),"^",2)
	s CycleNum = $p($g(^DHCEQMaintPlan(MaintPlanID)),"^",7)
	s CycleUnitDR = $p($g(^DHCEQMaintPlan(MaintPlanID)),"^",8)
	;s CycleDays=CycleNum*($CASE(CycleUnitDR,"1":"365","2":"30","3":"1"))
	s FromDate = $p($g(^DHCEQMaintPlan(MaintPlanID)),"^",10)
	s PreWarnDaysNum = $p($g(^DHCEQMaintPlan(MaintPlanID)),"^",12)
	//if $Data(^DHCEQMaint(0,"Equip",BussType,EquipID))=0
	if $Data(^DHCEQMaint(0,"SourceID",BussType,MaintPlanID,EquipID))=0  //2015-09-14 Bug ZX0032
	{
		s TempDate=FromDate
	}
	else
	{
		s id=0
		//for  set id =$order(^DHCEQMaint(0,"Equip",BussType,EquipID,id)) q:id=""  d
		for  set id =$order(^DHCEQMaint(0,"SourceID",BussType,MaintPlanID,EquipID,id)) q:id=""  d  //2015-09-14 Bug ZX0032
		.q:$p($g(^DHCEQMaint(id)),"^",39)="Y"
		.s MaintDate=$p($g(^DHCEQMaint(id)),"^",5)
		.i MaintDate>TempDate s TempDate=MaintDate
		i TempDate="" s TempDate=FromDate
	}
	s LastDate=TempDate
	/// Mozy	2017-8-30 调整周期计算方式
	;s NextDate=LastDate+CycleDays
	Set TempDate=$ZD(LastDate,3)
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
	///Mozy	2017-8-30	end
	if (NextDate>($p($h,",",1)+PreWarnDaysNum)) s pass=0
	quit pass_"^"_LastDate_"^"_NextDate
}

/// modify by lmm 2018-12-04
/// modify by lmm 2019-08-29 增加入参 BussType MaintTypeDR
ClassMethod GetSourceType(name, width, Type, BussType As %String = "", MaintTypeDR As %String = "") As %String
{
	;;下拉列表
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")
	;w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	if Type=1 w "<option value=></option>"
	if (BussType="1")
	{
		w "<option value=4>科室</option>"
		w "<option value=5>设备</option>"
		w "<option value=6>设备项</option>"
		
	}
	elseif ((BussType="2")&&(MaintTypeDR="4"))
	{
		w "<option value=1>类组</option>"
		w "<option value=2>类型</option>"
		w "<option value=4>科室</option>"
		w "<option value=5>设备</option>"
		w "<option value=6>设备项</option>"
	}
	elseif ((BussType="2")&&(MaintTypeDR="5"))
	{
		// MZY0075	1905639		2021-05-20
		w "<option value=4>科室</option>"
		w "<option value=5>设备</option>"
		w "<option value=6>设备项</option>"
	}
	else
	{
		w "<option value=1>类组</option>"
		w "<option value=2>类型</option>"
		w "<option value=4>科室</option>"
		w "<option value=5>设备</option>"
		w "<option value=6>设备项</option>"
	}
	w "</select>",!
}

/// ----------------------------------
/// add:zy 2011-03-23  No ZY0066
/// 描述:新增、更新
/// w ##Class(web.DHCEQMaintPlanNew).SaveData("^1111^1^^^^3^1^2^1^2018-04-18^^22^12^164^^1^^^^^^^2^2^3^^^^^^^^^N^N^^","^2^2^^Y^Y^N^Y^N^N","^1^2,1^Y&^2^2,1^Y&^^^4^164^Y&^^4^139^Y")
/// ----------------------------------
ClassMethod SaveData(val, EquipRangeval, EquipRangevalList)
{
	new RowID,User,Date,Time
	k PLIST
	Set $ZT="ERRORSave"
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
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
	s PLIST(15) = $p(val,"^",15)	;MaintLocDR
	s PLIST(16) = $p(val,"^",16)	;MaintUserDR
	s PLIST(17) = $p(val,"^",17)	;MaintModeDR
	s PLIST(18) = $p(val,"^",18)	;ContractDR
	s PLIST(19) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",19),"bool")	;MeasureFlag
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
	s PLIST(37) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",28),"bool")	;InvalidFlag
	/*
	s PLIST(38) = $p(val,"^",2)	;DelUserDR
	s PLIST(39) = $p(val,"^",2)	;DelDate
	s PLIST(40) = $p(val,"^",2)	;DelTime
	*/
	s PLIST(41) = $p(val,"^",29)	;Hold1
	s PLIST(42) = $p(val,"^",30)	;Hold2
	s PLIST(43) = $p(val,"^",31)	;Hold3
	s PLIST(44) = $p(val,"^",32)	;Hold4
	s PLIST(45) = $p(val,"^",33)	;Hold5
	//add by lmm 2018-04-25 begin LMM0036 
	
	s PLIST(46) = $p(val,"^",34)	;TotalFee
	s PLIST(47) = $p(val,"^",35)	;TempPlanFlag
	s PLIST(48) = $p(val,"^",36)	;FixTimeFlag
	s PLIST(49) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",37),"date")	;SDate
	s PLIST(50) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",38),"date")	;EDate
		
	TSTART
	s PLIST(51) = ##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQMaintPlan",Date)	;PlanNo

	if RowID=""
	{
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
	s SQLCODE=##Class(web.DHCEQEquipRange).SaveEquipRange(EquipRangeval,EquipRangevalList)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^"_RowID
	}
	
	//add by lmm 2018-04-26 end LMM0036
	
 	TCOMMIT
 	q SQLCODE_"^"_RowID
ERRORSave 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORSave"_ErrorMsg     //返回错误消息 ;
}

/// ----------------------------------
/// add:zy 2011-03-23  No ZY0066
/// 描述:删除
/// w ##Class(web.DHCEQMaintPlanNew).DeleteData("9^^^516^1^^")
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
	s SQLCODE=##Class(web.DHCEQEquipRange).DeleteEquipRange(EquipRangeID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^"_RowID
	}
	
	//add by lmm 2018-04-26 end LMM0036
	
	TCOMMIT
	q SQLCODE
ERRORDelete 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORDelete"_ErrorMsg     //返回错误消息 ;
}

/// ----------------------------------
/// add:zy 2011-03-23  No ZY0066
/// 描述:提交
/// w ##Class(web.DHCEQMaintPlanNew).SubmitData("3^^^516^1^^")
/// ----------------------------------
ClassMethod SubmitData(RowID)
{
	new User,Date,Time
	k AppList,PLIST
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
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
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORSubmit"_ErrorMsg     //返回错误消息 ;
}

/// ----------------------------------
/// add:zy 2011-03-23  No ZY0066
/// 描述:反提交
/// w ##Class(web.DHCEQMaintPlanNew).CancelSubmitData("2")
/// ----------------------------------
ClassMethod CancelSubmitData(RowID)
{
 	
	Set $ZT="ERRORCancel"
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	TSTART	
	s PLIST(37) = "Y"			;InvalidFlag
	s PLIST(38) = User			;DelUserDR
	s PLIST(39) = Date			;DelDate
	s PLIST(40) = Time			;DelTime
	&SQL(update sqluser.DHC_EQMaintPlan values :PLIST() where MP_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
ERRORCancel 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORCancel"_ErrorMsg     //返回错误消息 ;
}

/// w ##Class(web.DHCEQMaintPlanNew).GetOneMaintPlan("1")
ClassMethod GetOneMaintPlan(RowID As %Library.String)
{
	new result,resultex,No
	s (result,resultex,No)=""
	s result= ^DHCEQMaintPlan(RowID)
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
	s $p(result,"^",11)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",11),"date")	;EndDate	
	//s $p(result,"^",13)=$p(result,"^",13)+##Class(web.DHCEQMaintPlanNew).GetOtherFee(RowID)	;maintFee	
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
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCService",$p(result,"^",22))),"^",1)	
	s resultex=resultex_"^"	;Status				12
	i $p(result,"^",26)'=""  d
	.s resultex=resultex_$CASE($p(result,"^",26),"0":"新增","1":"提交","2":"审核","3":"作废",:"")  //modify by lmm 2020-05-06 1303188
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
	s resultex=resultex_"^"	;No					17
	i No'=""  d
	.s resultex=resultex_No
	s result=result_resultex
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

ClassMethod GetStatus(MaintPlanDR As %Library.String)
{
	i MaintPlanDR="" q ""
	q $p($g(^DHCEQMaintPlan(MaintPlanDR)),"^",26)
}

/// type: 1,计划;否则就是记录
/// w ##class(web.DHCEQMaintPlanNew).GetOtherFee(6)
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
		// Modified By QW20180726 BUG:QW0014 回传partfee,maitfee从界面取
		&sql(select sum(MTP_TotalFee) into :PartFee from sqluser.DHC_EQMaintPart where MTP_MaintDR=:RowID and MTP_FeeFlag='Y')
		i PartFee="" s PartFee=0
		s TotalFee=PartFee
	}
	q ##Class(web.DHCEQCommon).FormatNumber(TotalFee,"")
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQMaintPlanNew","GetPlanName",2,"",11434,571,"","","",5)
/// Modify By QW20160202 增加筛选条件,TypeCode As %String = "" 区分计量和检查
Query GetPlanName(BussType, Name, EquipDR As %String = "", MaintLocDR As %String = "", QXType As %String = "", CurLocID As %String = "", TypeCode As %String = "", MaintTypeDR As %String = "") As %Query(ROWSPEC = "TName:%String:名称,Hidden:%String,TSourceType:%String:类型,TSourceID:%String:编码")
{
}

ClassMethod GetPlanNameExecute(ByRef qHandle As %Binary, BussType, Name, EquipDR, MaintLocDR, QXType As %String = "", CurLocID As %String = "", TypeCode As %String = "", MaintTypeDR As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	
	i CurLocID'="" s CurLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",CurLocID)    //Modefied by zc0050  2019-10-19  CTLocID取值对应DHCEQCDepartment表中的值
	s index=1
	s rowid=0
	f  s rowid=$o(^DHCEQMaintPlan(0,"Type",BussType,rowid))  quit:rowid=""  d
	.d ResetVariablesGetPlanName
	.s TRowID = rowid
	.q:(TypeCode'="")&&($p($g(^DHCEQMaintPlan(rowid)),"^",9)="")  ;Add By QW20160202
	.i TypeCode'="" q:$p($g(^DHCEQCCode("DHCEQCMaintType",$p($g(^DHCEQMaintPlan(rowid)),"^",9))),"^",1)'=TypeCode ;Add By QW20160202
	.Quit:$p($g(^DHCEQMaintPlan(rowid)),"^",36)="Y"
	.Quit:$p($g(^DHCEQMaintPlan(rowid)),"^",26)'="2"
	.s TName = $p($g(^DHCEQMaintPlan(rowid)),"^",1)
	.q:(Name'="")&&(TName'[Name)
	.i EquipDR'="" q:##Class(web.DHCEQMaintPlanNew).CheckPlanByEquipID(rowid,EquipDR)=0
	.;add by lmm 2019-08-29 begin 990605
	.;s TSourceType = $p($g(^DHCEQMaintPlan(rowid)),"^",3)
	.;s TSourceID = $p($g(^DHCEQMaintPlan(rowid)),"^",4)
	.;i TSourceType=1  d
	.;.s TSourceID=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TSourceID)),"^",2)
	.;e  i TSourceType=2  d
	.;.s TSourceID=$p($g(^DHCEQCCode("DHCEQCMasterItem",TSourceID)),"^",1)
	.;e  i TSourceType=3  d
	.;.s TSourceID=$p($g(^DHCEQEquip(TSourceID)),"^",1)
	.;i TSourceType'=""  s TSourceType =$CASE(TSourceType,"1":"设备分类","2":"设备项","3":"设备")
	.s TEquipRangeStr=##Class(web.DHCEQMaintPlanNew).GetRangeDesc("2",rowid)  
	.s TSourceType=$p(TEquipRangeStr,"#",1)
	.s TSourceID=$p(TEquipRangeStr,"#",2)
	.q:(TSourceType="")||(TSourceID="")  ;modify by lmm 2019-01-13 804471
	.i ($l(TSourceType,",")>3) s TSourceType=$p(TSourceType,",",1)_","_$p(TSourceType,",",2)_".."
	.i ($l(TSourceID,",")>3) s TSourceID=$p(TSourceID,",",1)_","_$p(TSourceID,",",2)_".."
	.;add by lmm 2019-08-29 end
	.s TMaintFee = $p($g(^DHCEQMaintPlan(rowid)),"^",13)
	.S TMaintFee=TMaintFee+##Class(web.DHCEQMaintPlanNew).GetOtherFee(rowid,1)
	.s TMaintLocDR = $p($g(^DHCEQMaintPlan(rowid)),"^",14)
	.q:(TMaintLocDR'=MaintLocDR)&(MaintLocDR'="")
	.q:((TMaintLocDR'="")&&(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TMaintLocDR,CurLocID)))) //2010-10-28 DJ
	.i TMaintLocDR '="" s TMaintLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TMaintLocDR)
	.;需求号:265786	Mozy	2016-10-13
	.s TMaintTypeDR = $p($g(^DHCEQMaintPlan(rowid)),"^",9)
	.q:(MaintTypeDR'="")&&(TMaintTypeDR'=MaintTypeDR)
	.d OutputRowGetPlanName
	Quit $$$OK
OutputRowGetPlanName
	s Data=$lb(TName,TRowID,TSourceType,TSourceID)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetPlanName
	s (TRowID,TName,TSourceType,TSourceID)=""
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

/// 检测该设备是否符合该计划设置
/// 0:不符合	1:符合
/// w ##Class(web.DHCEQMaintPlanNew).CheckPlanByEquipID(4,8861)
ClassMethod CheckPlanByEquipID(PlanID, EquipID)
{
	new SourceType,SourceID,MaintLocID,pass,rowid
	s pass=0
	s SourceType = $p($g(^DHCEQMaintPlan(PlanID)),"^",3)
	s SourceID = $p($g(^DHCEQMaintPlan(PlanID)),"^",4)
	s MaintLocID = $p($g(^DHCEQMaintPlan(PlanID)),"^",14)
	if (SourceType="")||(SourceID="") q 0
	//"1":"设备分类","2":"设备项","3":"设备"
	if SourceType=1
	{
		;s rowid=0
		;f  s rowid=$o(^DHCEQEquip(0,"StoreLocEquipCat",MaintLocID,SourceID,rowid))  quit:(rowid="")||(pass=1)  d
		;.if (rowid=EquipID) s pass=1
		;Mozy0087	2012-8-24
		;If ($Piece($Get(^DHCEQEquip(EquipID)),"^",67)=MaintLocID)&($Piece($Get(^DHCEQEquip(EquipID)),"^",4)=SourceID) Set pass=1
		If $Piece($Get(^DHCEQEquip(EquipID)),"^",4)=SourceID Set pass=1 ;QW20160129
	}
	elseif SourceType=2
	{
		;s rowid=0
		;f  s rowid=$o(^DHCEQEquip(0,"StoreLocItem",MaintLocID,SourceID,rowid))  quit:(rowid="")||(pass=1)  d
		;.if (rowid=EquipID) s pass=1
		;Mozy0087	2012-8-24
		;If ($Piece($Get(^DHCEQEquip(EquipID)),"^",67)=MaintLocID)&($Piece($Get(^DHCEQEquip(EquipID)),"^",7)=SourceID) Set pass=1
		If $Piece($Get(^DHCEQEquip(EquipID)),"^",7)=SourceID Set pass=1  ;QW20160129
	}
	elseif SourceType=3
	{
		;if (EquipID=SourceID) s pass=1
		;Mozy0087	2012-8-24
		;if ($Piece($Get(^DHCEQEquip(EquipID)),"^",67)=MaintLocID)&(SourceID=EquipID) Set pass=1
		if SourceID=EquipID Set pass=1  ;QW20160129
	}
	q pass
}

/// w ##Class(web.DHCEQMaintPlanNew).GetWarnIcon()
ClassMethod GetWarnIcon(nextdate As %Library.String, TPreWarnDaysNum As %Library.String)
{
	i nextdate="" Quit ""
	i ##class(web.DHCEQCommon).TransValueFromPage(nextdate,"date")<=+$H  q "websys/sys_warning.gif"
	i ##class(web.DHCEQCommon).TransValueFromPage(nextdate,"date")<=+$H+TPreWarnDaysNum  q "websys/sys_information.gif"
	q ""
}

/// add by zx 2015-08-21 Bug0030
/// 通过设备搜索计划
/// d ##class(%ResultSet).RunQuery("web.DHCEQMaintPlanNew","GetPlanNameByEquip","2","3")
Query GetPlanNameByEquip(BussType, EquipDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TName:%String,TSourceType:%String,TSourceID:%String,TCycleNum:%String,TCycleUnitDR:%String,TMaintTypeDR:%String,TMaintType:%String,TFromDate:%String,TEndDate:%String,TPreWarnDaysNum:%String,TMaintFee:%String,TMaintLocDR:%String,TMaintLoc:%String,TMaintUserDR:%String,TMaintUser:%String,TMaintModeDR:%String,TMaintMode:%String,TRemark:%String,TStatus:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TModelDR:%String,TModel:%String")
{
}

ClassMethod GetPlanNameByEquipExecute(ByRef qHandle As %Binary, BussType, EquipDR As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s (EquipCatDR,ItemDR)=""
	i EquipDR="" Quit $$$OK
	s EquipCatDR = $p($g(^DHCEQEquip(EquipDR)),"^",4)
	s ItemDR = $p($g(^DHCEQEquip(EquipDR)),"^",7)
	s rowid=0
	f  s rowid=$o(^DHCEQMaintPlan(0,"SourceType",BussType,"1",EquipCatDR,rowid))  quit:rowid=""  d
	.d ResetVariablesGetPlanNameByEquip
	.s TSourceType=1
	.s TSourceID=EquipCatDR
	.s TSourceID=##Class(web.DHCEQCommon).GetTrakNameByID("equipcat",TSourceID)		//Add By DJ 2015-12-28
	.d GetMaintPlanInfo
	.d OutputRowGetPlanNameByEquip
	s rowid=0
	f  s rowid=$o(^DHCEQMaintPlan(0,"SourceType",BussType,"2",ItemDR,rowid))  quit:rowid=""  d
	.d ResetVariablesGetPlanNameByEquip
	.s TSourceType=2
	.s TSourceID=ItemDR
	.s TSourceID=##Class(web.DHCEQCommon).GetTrakNameByID("masteritem",TSourceID)	//Add By DJ 2015-12-28
	.d GetMaintPlanInfo
	.d OutputRowGetPlanNameByEquip
	s rowid=0
	f  s rowid=$o(^DHCEQMaintPlan(0,"SourceType",BussType,"3",EquipDR,rowid))  quit:rowid=""  d
	.d ResetVariablesGetPlanNameByEquip
	.s TSourceType=3
	.s TSourceID=EquipDR
	.s TSourceID=##Class(web.DHCEQCommon).GetTrakNameByID("equip",TSourceID)	//Add By DJ 2015-12-28
	.d GetMaintPlanInfo
	.d OutputRowGetPlanNameByEquip
	Quit $$$OK
GetMaintPlanInfo
    s TRowID=rowid
    s TName = $p($g(^DHCEQMaintPlan(rowid)),"^",1)
    s TModelDR =$p($g(^DHCEQMaintPlan(rowid)),"^",5)
	i TModelDR'="" s TModel=$p($G(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	i TSourceType'=""  s TSourceType =$CASE(TSourceType,"1":"设备分类","2":"设备项","3":"设备")
	s TCycleNum = $p($g(^DHCEQMaintPlan(rowid)),"^",7)
	s TCycleUnitDR = $p($g(^DHCEQMaintPlan(rowid)),"^",8)
	i TCycleUnitDR '="" s TCycleUnit = $p($g(^DHCEQCCode("DHCEQCCycleUnit",TCycleUnitDR)),"^",2)
	s TCycleNum=TCycleNum_TCycleUnit
	s TMaintTypeDR = $p($g(^DHCEQMaintPlan(rowid)),"^",9)
	i TMaintTypeDR '="" s TMaintType = $p($g(^DHCEQCCode("DHCEQCMaintType",TMaintTypeDR)),"^",2)
	s TFromDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaintPlan(rowid)),"^",10),"date")
	s TEndDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaintPlan(rowid)),"^",11),"date")
	s TPreWarnDaysNum = $p($g(^DHCEQMaintPlan(rowid)),"^",12)
	s TMaintFee = $p($g(^DHCEQMaintPlan(rowid)),"^",13)
	S TMaintFee=TMaintFee+##Class(web.DHCEQMaintPlanNew).GetOtherFee(rowid,1)
	s TMaintFee=##Class(web.DHCEQCommon).FormatNumber(TMaintFee,"")
	s TMaintLocDR = $p($g(^DHCEQMaintPlan(rowid)),"^",14) 
	i TMaintLocDR '="" s TMaintLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TMaintLocDR)
	s TMaintUserDR = $p($g(^DHCEQMaintPlan(rowid)),"^",15)
	i TMaintUserDR '="" s TMaintUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TMaintUserDR)
	s TMaintModeDR = $p($g(^DHCEQMaintPlan(rowid)),"^",16)
	i TMaintModeDR '="" s TMaintMode = $p($g(^DHCEQCCode("DHCEQCMaintMode",TMaintModeDR)),"^",2)
	s TRemark = $p($g(^DHCEQMaintPlan(rowid)),"^",25)
	s TStatus = $p($g(^DHCEQMaintPlan(rowid)),"^",26)
	i TStatus'=""  s TStatus = $CASE(TStatus,"0":"新增","1":"提交","2":"审核")
	s THold1=$p($g(^DHCEQMaintPlan(rowid)),"^",40)
	s THold2=$p($g(^DHCEQMaintPlan(rowid)),"^",41)
	s THold3=$p($g(^DHCEQMaintPlan(rowid)),"^",42)
	s THold4=$p($g(^DHCEQMaintPlan(rowid)),"^",43)
	s THold5=$p($g(^DHCEQMaintPlan(rowid)),"^",44)
    quit
OutputRowGetPlanNameByEquip
	s Data=$lb(TRowID,TName,TSourceType,TSourceID,TCycleNum,TCycleUnitDR,TMaintTypeDR,TMaintType,TFromDate,TEndDate,TPreWarnDaysNum,TMaintFee,TMaintLocDR,TMaintLoc,TMaintUserDR,TMaintUser,TMaintModeDR,TMaintMode,TRemark,TStatus,THold1,THold2,THold3,THold4,THold5,TModelDR,TModel)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetPlanNameByEquip
	s (TRowID,TName,TSourceType,TSourceID,TCycleNum,TCycleUnitDR,TMaintTypeDR,TMaintType,TFromDate,TEndDate,TPreWarnDaysNum,TMaintFee,TMaintLocDR,TMaintLoc,TMaintUserDR,TMaintUser,TMaintModeDR,TMaintMode,TRemark,TStatus,THold1,THold2,THold3,THold4,THold5,TModelDR,TModel)=""
	quit
}

ClassMethod GetPlanNameByEquipFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPlanNameByEquipExecute ]
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

ClassMethod GetPlanNameByEquipClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPlanNameByEquipExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// HISUI改造
/// add by czf 20180817
/// w ##Class(web.DHCEQMaintPlanNew).GetWarnIconNew()
ClassMethod GetWarnIconNew(nextdate As %Library.String, TPreWarnDaysNum As %Library.String)
{
	i nextdate="" Quit ""
	s imgsrc=""
	i ##class(web.DHCEQCommon).TransValueFromPage(nextdate,"date")<=+$H  
	{
		s imgsrc="websys/sys_warning.gif"
		q "<img src='../images/"_imgsrc_"' border='0' style='vaertical-align:middle;'>"
	}
	i ##class(web.DHCEQCommon).TransValueFromPage(nextdate,"date")<=+$H+TPreWarnDaysNum 
	{
		s imgsrc="websys/sys_information.gif"
		q "<img src='../images/"_imgsrc_"' border='0' style='vaertical-align:middle;'>"
	}
	q ""
}

/// Creator:CZF 20180423
/// Description:保养计划
/// d ##class(%ResultSet).RunQuery("web.DHCEQMaintPlanNew","GetMaintPlanNew","","","","","","")
Query GetMaintPlanNew(BussType, Name, MaintLocDR, MaintTypeDR, QXType As %String = "", MaintNo As %String = "", Schedule As %String = "") As %Query(ROWSPEC = "TRowID:%String,TName:%String,TCycleNum:%String,TCycleUnitDR:%String,TMaintTypeDR:%String,TMaintType:%String,TFromDate:%String,TEndDate:%String,TPreWarnDaysNum:%String,TMaintFee:%String,TMaintLocDR:%String,TMaintLoc:%String,TMaintUserDR:%String,TMaintUser:%String,TMaintModeDR:%String,TMaintMode:%String,TRemark:%String,TStatus:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TModelDR:%String,TModel:%String,TRow:%String,TMaintNo:%String,TLastExDate:%String,TNextExDate:%String,TLastPlanExeID:%String,TStatus:%String,TLastExSchedule:%String,TExeUser:%String")
{
}

ClassMethod GetMaintPlanNewExecute(ByRef qHandle As %Binary, BussType, Name, MaintLocDR, MaintTypeDR, QXType As %String = "", MaintNo As %String = "", Schedule As %String = "") As %Status
{
	;s ^CZF("mp")=BussType_"^"_Name_"^"_MaintLocDR_"^"_MaintTypeDR_"^"_QXType_"^"_SourceTypeDR_"^"_SourceIDDR_"^"_MaintNo
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
	.s TStatus = $p($g(^DHCEQMaintPlan(rowid)),"^",26)
	.q:TStatus'=2
	.s TModelDR =$p($g(^DHCEQMaintPlan(rowid)),"^",5)
	.i TModelDR'="" s TModel=$p($G(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.s TCycleNum = $p($g(^DHCEQMaintPlan(rowid)),"^",7)
	.s TCycleUnitDR = $p($g(^DHCEQMaintPlan(rowid)),"^",8)
	.i TCycleUnitDR '="" s TCycleUnit = $p($g(^DHCEQCCode("DHCEQCCycleUnit",TCycleUnitDR)),"^",2)
	.s TCycleNum=TCycleNum_TCycleUnit
	.s TMaintTypeDR = $p($g(^DHCEQMaintPlan(rowid)),"^",9)
	.q:((MaintTypeDR'="")&&(TMaintTypeDR'=MaintTypeDR))
	.i TMaintTypeDR '="" s TMaintType = $p($g(^DHCEQCCode("DHCEQCMaintType",TMaintTypeDR)),"^",2)
	.s TFromDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaintPlan(rowid)),"^",10),"date")
	.s TEndDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaintPlan(rowid)),"^",11),"date")
	.s TPreWarnDaysNum = $p($g(^DHCEQMaintPlan(rowid)),"^",12)
	.s TMaintFee = $p($g(^DHCEQMaintPlan(rowid)),"^",13)
	.S TMaintFee=TMaintFee+##Class(web.DHCEQMaintPlanNew).GetOtherFee(rowid,1)
	.s TMaintFee=##Class(web.DHCEQCommon).FormatNumber(TMaintFee,"")
	.s TMaintLocDR = $p($g(^DHCEQMaintPlan(rowid)),"^",14)
	.q:(TMaintLocDR'=MaintLocDR)&(MaintLocDR'="")
	.q:((TMaintLocDR'="")&&(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TMaintLocDR)))) //2010-10-28 DJ
	.i TMaintLocDR '="" s TMaintLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TMaintLocDR)
	.s TMaintUserDR = $p($g(^DHCEQMaintPlan(rowid)),"^",15)
	.i TMaintUserDR '="" s TMaintUser = $p($g(^SSU("SSUSR",TMaintUserDR)),"^",2)
	.s TMaintModeDR = $p($g(^DHCEQMaintPlan(rowid)),"^",16)
	.i TMaintModeDR '="" s TMaintMode = $p($g(^DHCEQCCode("DHCEQCMaintMode",TMaintModeDR)),"^",2)
	.s TRemark = $p($g(^DHCEQMaintPlan(rowid)),"^",25)
	.s THold1=$p($g(^DHCEQMaintPlan(rowid)),"^",40)
	.s THold2=$p($g(^DHCEQMaintPlan(rowid)),"^",41)
	.s THold3=$p($g(^DHCEQMaintPlan(rowid)),"^",42)
	.s THold4=$p($g(^DHCEQMaintPlan(rowid)),"^",43)
	.s THold5=$p($g(^DHCEQMaintPlan(rowid)),"^",44)
	.s TTotalFee=$p($g(^DHCEQMaintPlan(rowid)),"^",45)
	.s TTempFlag=$p($g(^DHCEQMaintPlan(rowid)),"^",46)
	.s TFixTimeFlag=$p($g(^DHCEQMaintPlan(rowid)),"^",47)
	.s TSDate=$p($g(^DHCEQMaintPlan(rowid)),"^",48)
	.s TEDate=$p($g(^DHCEQMaintPlan(rowid)),"^",49)
	.s TMaintNo=$p($g(^DHCEQMaintPlan(rowid)),"^",50)
	.q:(MaintNo'="")&&(TMaintNo'=MaintNo)
	.s TWarnInfo=..GetWarnDaysNum(rowid)
	.s TLastExDate=$p(TWarnInfo,"^",2)
	.s TLastExDate=##Class(web.DHCEQCommon).TransValueToPage(TLastExDate,"date")
	.s TNextExDate=$p(TWarnInfo,"^",3)
	.s TNextExDate=##Class(web.DHCEQCommon).TransValueToPage(TNextExDate,"date")
	.s TLastExSchedule="未执行"
	.s DisExecutedNum=0
	.s TLastPlanExeID=$o(^DHCEQPlanExecute(0,"MaintPlan",rowid,""),-1)
	.i TLastPlanExeID'="" d
	..s TStatus=$p($g(^DHCEQPlanExecute(TLastPlanExeID)),"^",6)
	..q:TStatus=1		//执行单已完成
	..s TExeUserDR=$p($g(^DHCEQPlanExecute(TLastPlanExeID)),"^",9)
	..s TExeUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", TExeUserDR)
	..s DisExecutedNum=$p($g(^DHCEQPlanExecute(TLastPlanExeID)),"^",4)-$p($g(^DHCEQPlanExecute(TLastPlanExeID)),"^",5)
	..i DisExecutedNum>0 s TLastExSchedule=DisExecutedNum_"台未执行"
	..e  s TLastExSchedule="待完成"
	.q:(Schedule=1)&&(DisExecutedNum>0)
	.q:(Schedule=2)&&(TLastExSchedule="未执行")
	.q:(TLastPlanExeID="")&&($p(TWarnInfo,"^",1)=0)
	.s TWarnIcon=##Class(web.DHCEQMaintPlanNew).GetWarnIcon(TNextExDate,TPreWarnDaysNum)
	.s TName=TWarnIcon_"^"_TName
	.d OutputRowGetMaintPlanNew
	Quit $$$OK
OutputRowGetMaintPlanNew
	s Data=$lb(TRowID,TName,TCycleNum,TCycleUnitDR,TMaintTypeDR,TMaintType,TFromDate,TEndDate,TPreWarnDaysNum,TMaintFee,TMaintLocDR,TMaintLoc,TMaintUserDR,TMaintUser,TMaintModeDR,TMaintMode,TRemark,TStatus,THold1,THold2,THold3,THold4,THold5,TModelDR,TModel,TRow,TMaintNo,TLastExDate,TNextExDate,TLastPlanExeID,TStatus,TLastExSchedule,TExeUser)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set TRow=TRow+1
	quit
ResetVariablesGetMaintPlanNew
	s (TRowID,TName,TCycleNum,TCycleUnitDR,TMaintTypeDR,TMaintType,TFromDate,TEndDate,TPreWarnDaysNum,TMaintFee,TMaintLocDR,TMaintLoc,TMaintUserDR,TMaintUser,TMaintModeDR,TMaintMode,TRemark,TStatus,THold1,THold2,THold3,THold4,THold5,TModelDR,TModel,TMaintNo,TLastExDate,TNextExDate,TLastPlanExeID,TStatus,TWarnInfo,TExeUserDR,TExeUser)=""
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

/// Creator:Add by CZF 20180503
/// Description:根据计划单ID获取预警信息
/// w ##class(web.DHCEQMaintPlanNew).GetWarnDaysNum(2)
ClassMethod GetWarnDaysNum(MaintPlanID)
{
	n BussType,CycleNum,CycleUnitDR,CycleDays,TempDate,LastDate,NextDate,id,MaintDate,pass
	s pass=1
	s (TempDate,LastDate,NextDate)=""
	s BussType = $p($g(^DHCEQMaintPlan(MaintPlanID)),"^",2)
	s CycleNum = $p($g(^DHCEQMaintPlan(MaintPlanID)),"^",7)
	s CycleUnitDR = $p($g(^DHCEQMaintPlan(MaintPlanID)),"^",8)
	s FromDate = $p($g(^DHCEQMaintPlan(MaintPlanID)),"^",10)	;启用日期
	s PreWarnDaysNum = $p($g(^DHCEQMaintPlan(MaintPlanID)),"^",12)
	s TempFlag=$p($g(^DHCEQMaintPlan(MaintPlanID)),"^",46)
	s FixTimeFlag=$p($g(^DHCEQMaintPlan(MaintPlanID)),"^",47)
	s SDate=$p($g(^DHCEQMaintPlan(MaintPlanID)),"^",48)
	s EDate=$p($g(^DHCEQMaintPlan(MaintPlanID)),"^",49)
	s LastPlanExeID=$o(^DHCEQPlanExecute(0,"MaintPlan",MaintPlanID,""),-1)
	i LastPlanExeID=""
	{
		s LastDate=""
		if (FixTimeFlag="Y")
		{
			s NextDate=SDate
		}
		else
		{
			s NextDate=FromDate
		}
	}
	else
	{
		s LastDate=$p($g(^DHCEQPlanExecute(LastPlanExeID)),"^",7)
		i TempFlag="Y"
		{
			s NextDate=""
		}
		elseif (FixTimeFlag="Y")
		{
			s TempDate=$p($zd(LastDate,3),"-",1)+1
			s TempDate=TempDate_"-"_$p($zd(SDate,3),"-",2,3)
			i TempDate>EDate
			{
				s NextDate=""
			}
			else
			{
				s NextDate=TempDate
			}
		}
		else
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
/// Command:d ##class(%ResultSet).RunQuery("web.DHCEQMaintPlanNew","GetPlanExecuteList","1","","","")
Query GetPlanExecuteList(MPID, PEID, MaintLocDR As %String = "", MaintDR As %String = "", EquipDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TPlanExecuteID:%String,TEquipID:%String,TEquipNo:%String,TStockLocDR:%String,TStockLoc:%String,TName:%String,TModelDR:%String,TModel:%String,TMaintID:%String,TExecuteFlag:%String,TMaintLocDR:%String,TMaintLoc:%String,TExecuteDate:%String,TExecuteTime:%String,TResult:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TRow:%String,TExeUserDR,TExeUser")
{
}

ClassMethod GetPlanExecuteListExecute(ByRef qHandle As %Binary, MPID, PEID, MaintLocDR As %String = "", MaintDR As %String = "", EquipDR As %String = "") As %Status
{
	//s ^CZF("mp")=PEID_"^"_MaintLocDR_"^"_MaintDR_"^"_EquipDR
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
	..s TEquipID = $p($g(^DHCEQPlanExecuteList(rowid)),"^",2)
	..i TEquipID'="" d
	..s TEquipNo = $p($g(^DHCEQEquip(TEquipID)),"^",71)
	..s TStockLocDR = $p($g(^DHCEQEquip(TEquipID)),"^",67)
	..s TStockLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TStockLocDR)
	..s TName = $p($g(^DHCEQEquip(TEquipID)),"^",1)
	..s TModelDR = $p($g(^DHCEQEquip(TEquipID)),"^",3)
	..s TModel=##Class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
	..s TMaintID = $p($g(^DHCEQPlanExecuteList(rowid)),"^",3)
	..s TExecuteFlag = $p($g(^DHCEQPlanExecuteList(rowid)),"^",4)
	..i TExecuteFlag="Y" s TExecuteFlag="已执行"
	..e  s TExecuteFlag="未执行"
	..i TMaintID'="" d
	...s TExecuteDate=$p($g(^DHCEQMaint(TMaintID)),"^",19)
	...s TExecuteDate=##Class(web.DHCEQCommon).TransValueToPage(TExecuteDate,"date")
	...s TExecuteTime=$p($g(^DHCEQMaint(TMaintID)),"^",20)
	...s TExecuteTime=##Class(web.DHCEQCommon).TransValueToPage(TExecuteTime,"time")
	..s TResult =$p($g(^DHCEQPlanExecuteList(rowid)),"^",5)
	..s TRemark =$p($g(^DHCEQPlanExecuteList(rowid)),"^",6)
	..s THold1=$p($g(^DHCEQPlanExecuteList(rowid)),"^",7)
	..s THold2=$p($g(^DHCEQPlanExecuteList(rowid)),"^",8)
	..s THold3=$p($g(^DHCEQPlanExecuteList(rowid)),"^",9)
	..s THold4=$p($g(^DHCEQPlanExecuteList(rowid)),"^",10)
	..s THold5=$p($g(^DHCEQPlanExecuteList(rowid)),"^",11)
	..s TExeUserDR=$p($g(^DHCEQPlanExecute(PERowID)),"^",9)
	..s TExeUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TExeUserDR)
	..d OutputRowGetPlanExecuteList
	Quit $$$OK
	
OutputRowGetPlanExecuteList
	s Data=$lb(TRowID,TPlanExecuteID,TEquipID,TEquipNo,TStockLocDR,TStockLoc,TName,TModelDR,TModel,TMaintID,TExecuteFlag,TMaintLocDR,TMaintLoc,TExecuteDate,TExecuteTime,TResult,THold1,THold2,THold3,THold4,THold5,TRow,TExeUserDR,TExeUser)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set TRow=TRow+1  //add by zx 2015-09-17
	quit
ResetVariablesGetPlanExecuteList
	s (TRowID,TPlanExecuteID,TEquipID,TEquipNo,TStockLocDR,TStockLoc,TName,TModelDR,TModel,TMaintID,TExecuteFlag,TMaintLocDR,TMaintLoc,TExecuteDate,TExecuteTime,TResult,THold1,THold2,THold3,THold4,THold5,TExeUserDR,TExeUser)=""
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

/// Creator:Add By CZF 2018-04-26
/// Description:保存计划执行单
/// Input:保养计划ID,维护类型
/// Command:w ##Class(web.DHCEQMaintPlanNew).ExecuteMaintPlan(2,1)
ClassMethod ExecuteMaintPlan(MPRowID)
{
	n User,Date,Time
	s $ZE="ERRORExecute"
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	; Mozy0234	2019-11-26
	s Loc=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))	; Mozy0234	2019-11-26
	s Date=+$H
	s Time=$P($H,",",2)
	k PLIST
	s PLIST(3)=MPRowID
	s PLIST(4)=Loc					//执行科室
	s MPEquipIDs=..GetMaintEquips(2,MPRowID)
	s PLIST(5)=$l(MPEquipIDs,",")	//设备总数
	s PLIST(6)=0		//已执行设备总数
	s PLIST(7)=0		//状态
	s PLIST(8)=Date
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
	
 	s SQLCODE=..SavePlanExecuteList(RowID,MPEquipIDs)
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
	Set ErrorMsg=$ZT	     //得到系统返回的错误消息
 	Quit "<ERRORExecute>"_ErrorMsg     //返回错误消息 ;
}

/// Creator:Add By CZF 2018-04-26
/// Description:保存计划执行明细
/// Input:执行计划ID,计划设备ID串
/// Command:w ##Class(web.DHCEQMaintPlanNew).SavePlanExecuteList(1,"2,3,4,5")
ClassMethod SavePlanExecuteList(PERowID, EquipIDs)
{
	n flag,i,Length
	s flag=0
	
	i EquipIDs'="" d
	.s Length=$l(EquipIDs,",")
	.f i=1:1:Length d
	..k PLISTMX
	..s PLISTMX(2)=PERowID
	..s PLISTMX(3)=$p(EquipIDs,",",i)
	..;s PLISTMX(4)=0
	..s PLISTMX(5)="N"		//ExecuteFlag
	..&SQL(insert into sqluser.DHC_EQPlanExecuteList values :PLISTMX())
	..i SQLCODE s flag=SQLCODE
	
	q flag
}

/// Creator:Add By CZF 2018-04-26
/// Description:获取设备范围限定中的设备ID串
/// Input:来源类型(计划执行单:2),来源ID
/// Command:w ##Class(web.DHCEQMaintPlanNew).GetMaintEquips()
ClassMethod GetMaintEquips(Sourcetype, MPID)
{
	n RangeIDs,ERID,MaintEquipIDs
	s (RangeIDs,ERID,MaintEquipIDs)=""
	
	s ERID=""
	s ERID=$o(^DHCEQEquipRange(0,"SourceID",Sourcetype,MPID,ERID))
	i ERID'="" d
	.s RangeIDs=..GetEquipRangeIDs(ERID,1)
	.s RangeIDs=..GetEquipRangeIDs(ERID,2)_"$"_RangeIDs
	.s RangeIDs=..GetEquipRangeIDs(ERID,3)_"$"_RangeIDs
	.s RangeIDs=..GetEquipRangeIDs(ERID,4)_"$"_RangeIDs
	.s RangeIDs=..GetEquipRangeIDs(ERID,5)_"$"_RangeIDs
	.s RangeIDs=..GetEquipRangeIDs(ERID,6)_"$"_RangeIDs
	
	s MaintEquipIDs=..GetRangeEquip(RangeIDs)
	q MaintEquipIDs
}

/// Creator:Add By CZF 2018-04-26
/// Description:获取设备范围限定表中限定的类型的值
/// Input:EquipRangeID,类型
/// Command:w ##Class(web.DHCEQMaintPlanNew).GetEquipRangeIDs()
ClassMethod GetEquipRangeIDs(EquipRangeID, Type)
{
	s ValueIDs=""
	s ERLID=0
	f  s ERLID=$o(^DHCEQEquipRangeList(0,"LimitType",EquipRangeID,Type,ERLID)) q:ERLID=""  d
	.s ERLValue=$p($g(^DHCEQEquipRangeList(ERLID)),"^",3)
	.i ValueIDs="" s ValueIDs=ERLValue
	.e  s ValueIDs=ValueIDs_","_ERLValue
	
	q ValueIDs
}

/// Creator:Add By CZF 2018-04-26
/// Description:获取设备范围限定中的设备ID串
/// Input:限定的串
/// Command:w ##Class(web.DHCEQMaintPlanNew).GetRangeEquip("$23,24,25,26,27,28,29$$$$")
ClassMethod GetRangeEquip(Values)
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
		s Equips=EquipIDs
	}
	else
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
		.;add by lmm 2018-05-07 end
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

/// add by lmm 2018-12-05
/// 入参：SourceType：来源类型
///      SourceID：来源id
///      EquipRangeType：设备范围类型
///      EquipRangeValue：设备范围类型id
/// Command:w ##Class(web.DHCEQMaintPlanNew).GetRangeDesc("2","23")
ClassMethod GetRangeDesc(SourceType, SourceID, EquipRangeType As %String = "", EquipRangeValue As %String = "")
{
	s (TEquipRangeID,TEquipRangeTypes,TValues)=""
	s TEquipRangeID=$o(^DHCEQEquipRange(0,"SourceID",SourceType,SourceID,""))
	s TEquipRangeListID=0
	f  s TEquipRangeListID=$o(^DHCEQEquipRangeList(0,"LimitDR",TEquipRangeID,TEquipRangeListID))  quit:TEquipRangeListID=""  d
	.s (TEquipRangeTypeID,TEquipRangeType,ValueID,TRangeCode,TValue)=""
	.s TEquipRangeTypeID=$p($g(^DHCEQEquipRangeList(TEquipRangeListID)),"^",2)
	.q:(EquipRangeType'="")&&(EquipRangeType'=TEquipRangeTypeID)
	.i TEquipRangeTypeID'=""  s TEquipRangeType = $CASE(TEquipRangeTypeID,"1":"类组","2":"类型","3":"分类","4":"科室","5":"设备","6":"设备项")
	.i TEquipRangeTypes="" s TEquipRangeTypes=TEquipRangeType
	.e  i (TEquipRangeType'[TEquipRangeTypes)  s TEquipRangeTypes=TEquipRangeTypes_","_TEquipRangeType
	.;modify by lmm 2019-08-30 994942 begin
	.s ValueIDs=$p($g(^DHCEQEquipRangeList(TEquipRangeListID)),"^",3)
	.s len=$l(ValueIDs,",")
	.f i=1:1:len  d
	..s ValueID=$p(ValueIDs,",",i)
	..q:(EquipRangeValue'="")&&(EquipRangeValue'=ValueID)
	..i TEquipRangeTypeID'=""  s TRangeCode = $CASE(TEquipRangeTypeID,"1":"equiptype","2":"statcat","3":"equipcat","4":"dept","5":"equip","6":"masteritem")
	..i TRangeCode'=""  s TValue=##Class(web.DHCEQCommon).GetTrakNameByID(TRangeCode, ValueID)
	..i TValues="" s TValues=TValue
	..e  s TValues=TValues_","_TValue
	..;modify by lmm 2019-08-30 994942 begin
	q TEquipRangeTypes_"#"_TValues
}

}
