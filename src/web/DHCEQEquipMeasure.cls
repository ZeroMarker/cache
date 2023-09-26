/// Mozy	2015-11-3
/// 计量台帐
Class web.DHCEQEquipMeasure Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCEQEquipMeasure","GetEquipMeasureList","","","","","","","Y")
/// modify by lmm 351521
/// add by lmm 2020-04-27 IsDisused：是否报废 入参添加
/// modified by sjh 2020-10-16 修改IsDisused入参默认值为空
Query GetEquipMeasureList(Data As %String = "", QXType As %String = "", CurLocID As %String = "", CurGroupID As %String = "", CurHospID As %String = "", CurUserID As %String = "", IsDisused As %String = "") As %Query(ROWSPEC = "TRowID:%String,TRow:%String,TNo:%String,TEquip,TModel,TQuantity,TDisplayStatus,TUseLoc,TLocation,TUnit,TOriginalFee,TName,TCycleNum,TCycleUnit,TLastDate,TNextDate,TMaintFee,TPreWarnDaysNum,TCommonName,TMaintLoc,TMaintUser,TMaintMode,TEquipDR,TRemark:%String,TDisuseDate:%String") [ SqlProc ]
{
}

ClassMethod GetEquipMeasureListExecute(ByRef qHandle As %Binary, Data As %String = "", QXType As %String = "", CurLocID As %String = "", CurGroupID As %String = "", CurHospID As %String = "", CurUserID As %String = "", IsDisused As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	set Job=$j
 	Do ##Class(web.DHCEQCommon).KillTempGlobal("GetEquipMeasureList")
	i CurLocID'="" s CurLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",CurLocID)    //Modefied by zc0050  2019-10-19  CTLocID取值对应DHCEQCDepartment表中的值
	Set Data=##class(web.DHCEQCommon).UnEscape(Data)
	Set No=$ZCONVERT(##class(web.DHCEQCommon).GetDataByName(Data,"No"),"U")
 	Set Equip=$ZCONVERT(##class(web.DHCEQCommon).GetDataByName(Data,"Equip"),"U")
 	Set PlanNameDR=##class(web.DHCEQCommon).GetDataByName(Data,"PlanNameDR")
 	Set UseLocDR=##class(web.DHCEQCommon).GetDataByName(Data,"UseLocDR")
 	Set StartDate=##Class(web.DHCEQCommon).GetDataByName(Data,"StartDate")
	Set EndDate=##Class(web.DHCEQCommon).GetDataByName(Data,"EndDate")
	//modified by zy 2017-03-02 ZY0159 日期格式统一调整
	Set StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	Set EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	
	// 设置设备最近一次的检查计划
	Set BussType=2
	;start by csj 20190111 新版维护计划中不存在SourceType和SourceID,根据设备范围确定设备
	//Set SourceType=0
	//modify by lmm 2020-04-27
	if (IsDisused="N")
	{
		s mpid=0
		f  s mpid=$Order(^DHCEQMaintPlan(0,"Type",BussType,mpid)) q:mpid=""  d
		.q:($Piece($Get(^DHCEQMaintPlan(mpid)),"^",26)'="2")
		.q:($Piece($Get(^DHCEQMaintPlan(mpid)),"^",36)="Y")
		.s EquipRangeList = ##Class(web.DHCEQ.EM.BUSMaintPlan).GetMaintEquips("2",mpid)
		.s Len=$l(EquipRangeList,",")
		.f i=1:1:Len  Do
		..s EquipID = $p(EquipRangeList,",",i)
		..d SetEquipID
	}

	;end by csj 20190111
	/*
	For  Set SourceType=$Order(^DHCEQMaintPlan(0,"SourceType",BussType,SourceType)) Quit:SourceType=""  Do
	.Set SourceID=0
	.For  Set SourceID=$Order(^DHCEQMaintPlan(0,"SourceType",BussType,SourceType,SourceID)) Quit:SourceID=""  Do
	..Set mpid=0
	..For  Set mpid=$Order(^DHCEQMaintPlan(0,"SourceType",BussType,SourceType,SourceID,mpid)) Quit:mpid=""  Do
	...Quit:($Piece($Get(^DHCEQMaintPlan(mpid)),"^",26)'="2")
	...Quit:($Piece($Get(^DHCEQMaintPlan(mpid)),"^",36)="Y")
	...
	...;"3":"设备"
	...If SourceType=3 Do
	....Set EquipID=SourceID
	....;Quit:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,$Piece($Get(^DHCEQEquip(EquipID)),"^",67))))
	....Do SetEquipID
	...
	...;"2":"设备项
	...If SourceType=2 Do
	....Set StoreLocID=0
	....For  Set StoreLocID=$Order(^DHCEQEquip(0,"StoreLocItem",StoreLocID)) Quit:StoreLocID=""  Do
	.....;q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLocID)))
	.....Set EquipID=0
	.....For  Set EquipID=$Order(^DHCEQEquip(0,"StoreLocItem",StoreLocID,SourceID,EquipID)) Quit:EquipID=""  Do
	......Do SetEquipID
	...
	...;"1":"设备分类"
	...If SourceType=1 Do
	....Set EquipCatStr=##Class(web.DHCEQCEquipeCat).GetChildIDsByCatID(SourceID)
	....Set Len=$l(EquipCatStr,"^")
	....Set i=0
	....For i=1:1:Len  Do
	.....Set ChildsSourceID=$Piece(EquipCatStr,"^",i)
	.....Set StoreLocID=0
	.....For  Set StoreLocID=$Order(^DHCEQEquip(0,"StoreLocItem",StoreLocID)) Quit:StoreLocID=""  Do
	......;Quit:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLocID)))
	......Set EquipID=0
	......For  Set EquipID=$Order(^DHCEQEquip(0,"StoreLocEquipCat",StoreLocID,ChildsSourceID,EquipID)) Quit:EquipID=""  Do
	.......Do SetEquipID
	
	*/
	Set index=2
	Set TotalNum=0
	Set TotalFee=0
	Set rowid=0
	Set TRow=0
	s TotalMaintFee=0
	For  Set rowid=$Order(^DHCEQEquip(rowid)) Quit:rowid=""  Do
	.Do ResetVariablesGetEquipMeasureList
	.Set TRowID = rowid
	.s TEquipDR=TRowID
	.Set TInvalidFlag = $Piece($Get(^DHCEQEquip(rowid)),"^",59)
	.Quit:TInvalidFlag'="N"
	.;Set TMeasureFlag=$Piece($Get(^DHCEQEquip(rowid)),"^",15)   //modify by jyp 2019-09-01  设备属性相关调整
	.//modify by lmm 2020-05-19 强检设备属于计量设备 1324074
	.s TMeasureFlag=##Class(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttributeGroup("01","3",rowid)
	.;s TMeasureFlag=##Class(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttributeYN(rowid)    //modify by jyp 2019-09-01
	.Quit:TMeasureFlag'="Y"
	.s TRemark=$Piece($Get(^DHCEQEquip(rowid)),"^",34)	//modified by czf 618983
	.Set TStatus = $Piece($Get(^DHCEQEquip(rowid)),"^",38)
	.;modify by lmm 2020-04-27
	.;Quit:TStatus>2
	.Q:(IsDisused="Y")&&(TStatus'=3)
	.Q:(IsDisused="N")&&(TStatus=3)
	.Set StockStatus = $Piece($Get(^DHCEQEquip(rowid)),"^",60)
	.Quit:((StockStatus="0")||(StockStatus>"2"))    //add by wy 2017-12-28
	.Set TEquipTypeDR = $Piece($Get(^DHCEQEquip(rowid)),"^",63)
	.Quit:##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID)
	.If TEquipTypeDR '="" Set TEquipType = ##class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR)
	.Set TNo = $Piece($Get(^DHCEQEquip(rowid)),"^",71)
	.Quit:(No'="")&&(TNo'[No)
	.Set TCommonName = $Piece($Get(^DHCEQEquip(rowid)),"^",1)		//Add DJ 2016-12-02 begin
	.Quit:(Equip'="")&&(TCommonName'[Equip)
	.s TItemDR=$Piece($Get(^DHCEQEquip(rowid)),"^",7)
	.i TItemDR'="" s TEquip=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1)  //Add By DJ 2016-12-02 end
	.Set TModelDR = $Piece($Get(^DHCEQEquip(rowid)),"^",3)
	.If TModelDR '="" Set TModel = ##class(web.DHCEQCommon).GetTrakNameByID("model", TModelDR)
	.Set TQuantity=1
	.Set TUnitDR = $Piece($Get(^DHCEQEquip(rowid)),"^",5)
	.If TUnitDR '="" Set TUnit = ##class(web.DHCEQCommon).GetTrakNameByID("uom", TUnitDR)
	.Set TOriginalFee = $Piece($Get(^DHCEQEquip(rowid)),"^",27)
	.
	.Set TDisplayStatus=##class(web.DHCEQEquip).GetEquipStatusDisplay(TStatus)
	.Set TUseLocDR = $Piece($Get(^DHCEQEquip(rowid)),"^",19)
	.;Mozy	806376	2019-1-15
	.Quit:(UseLocDR'="")&&(TUseLocDR'=UseLocDR)
	.Set TStoreLocDR = $Piece($Get(^DHCEQEquip(rowid)),"^",67)
	.q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TStoreLocDR,CurLocID,CurGroupID,CurHospID)))
	.If TUseLocDR '="" Set TUseLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept", TUseLocDR)
	.Set TLocationDR = $Piece($Get(^DHCEQEquip(rowid)),"^",72)
	.If TLocationDR '="" Set TLocation = $Piece($Get(^DHCEQCCode("DHCEQCLocation",TLocationDR)),"^",2)
	.Set tmpStr=""
	.;modify by lmm 2020-05-13 begin
	.s TDisuseDate=$Piece($Get(^DHCEQEquip(rowid)),"^",89)
	.Set TDisuseDate =##Class(web.DHCEQCommon).TransValueToPage(TDisuseDate,"date")
	.s MTType=0
	.For  Set MTType=$Order(^DHCEQMaint(0,"Equip",MTType)) Quit:MTType=""  Do
	..q:MTType>2
	..s (maintrowid,TMaintFee)=0
	..For  Set maintrowid=$Order(^DHCEQMaint(0,"Equip",MTType,rowid,maintrowid)) Quit:maintrowid=""  Do
	...q:($Piece($Get(^DHCEQMaint(maintrowid)),"^",39)="Y")
	...q:($Piece($Get(^DHCEQMaint(maintrowid)),"^",13)'="2")
	...s TMaintFee=TMaintFee+$Piece($Get(^DHCEQMaint(maintrowid)),"^",9)
	...s TLastDate=$Piece($Get(^DHCEQMaint(maintrowid)),"^",5)
	.;modify by lmm 2020-04-27 报废计量设备不在计划内
	.;q:(IsDisused="N")&&'($Data(^TempDHCEQ("GetEquipMeasureList",Job,rowid)))	//add by csj 20190111 去除不存在检查计划的设备
	.;modify by lmm 2020-05-13 end 计量台账显示所有计量设备，包含无计划计量设备
	.; add by sjh SJH0037 2020-10-16 BEGIN  已报废计量台账取就近维护信息
	.if (IsDisused="Y")  d
	..s MTType=0
	..For  Set MTType=$Order(^DHCEQMaint(0,"Equip",MTType)) Quit:MTType=""  Do
	...s maintrowid=0
	...For  Set maintrowid=$Order(^DHCEQMaint(0,"Equip",MTType,rowid,maintrowid)) Quit:maintrowid=""  Do
	....q:($Piece($Get(^DHCEQMaint(maintrowid)),"^",39)="Y")
	....q:($Piece($Get(^DHCEQMaint(maintrowid)),"^",13)'="2")
	....Set TMaintLocDR = $Piece($Get(^DHCEQMaint(maintrowid)),"^",6)
	....i TMaintLocDR'=""  Set TMaintLoc =##class(web.DHCEQCommon).GetTrakNameByID("dept",TMaintLocDR)
	....Set TMaintUserDR = $Piece($Get(^DHCEQMaint(maintrowid)),"^",7)
	....i TMaintUserDR'="" Set TMaintUser =##class(web.DHCEQCommon).GetTrakNameByID("user",TMaintUserDR)
	....Set TMaintMode = $Piece($Get(^DHCEQMaint(maintrowid)),"^",8)
	....i TMaintMode '="" s TMaintMode = $p($g(^DHCEQCCode("DHCEQCMaintMode",TMaintMode)),"^",2)
	....Set TRemark = $Piece($Get(^DHCEQMaint(maintrowid)),"^",14)
	.;add by sjh SJH0037 2020-10-16 END  已报废计量台账取就近维护信息
	.If ($Data(^TempDHCEQ("GetEquipMeasureList",Job,rowid))) Do
	..Set tmpStr=$Get(^TempDHCEQ("GetEquipMeasureList",Job,rowid))
	..Set TNextDate=$Piece(tmpStr,"^",1)
	..Set TLastDate=$Piece(tmpStr,"^",2)
	..s TRowID=$Piece(tmpStr,"^",3)		//Add By DJ 2015-12-10
	..Set TName = $Piece($Get(^DHCEQMaintPlan($Piece(tmpStr,"^",3))),"^",1)
	..Set TCycleNum = $Piece($Get(^DHCEQMaintPlan($Piece(tmpStr,"^",3))),"^",7)
	..Set TCycleUnitDR = $Piece($Get(^DHCEQMaintPlan($Piece(tmpStr,"^",3))),"^",8)
	..// MZY0099	2160563		2021-11-13
	..If TCycleUnitDR '="" d
	...Set TCycleUnit = $Piece($Get(^DHCEQCCode("DHCEQCCycleUnit",TCycleUnitDR)),"^",2)
	..e  d
	...i $Piece($Get(^DHCEQMaintPlan(TRowID)),"^",46)=4 d
	....;	MPCycleType		根据风险等级计划
	....s RiskGradeDR=""
	....s SourceType=0
	....for  s SourceType=$o(^DHCEQRiskEvaluation(0,"Source",SourceType)) quit:(SourceType="")  d
	.....s SourceID=0
	.....for  s SourceID=$o(^DHCEQRiskEvaluation(0,"Source",SourceType,SourceID)) quit:(SourceID="")  d
	......;0:设备类型|1：设备分类|2：设备项|3：设备
	......q:(SourceType=0)&&($Piece($Get(^DHCEQEquip(rowid)),"^",75)'=SourceID)
	......q:(SourceType=1)&&($Piece($Get(^DHCEQEquip(rowid)),"^",4)'=SourceID)
	......q:(SourceType=2)&&($Piece($Get(^DHCEQEquip(rowid)),"^",7)'=SourceID)
	......q:(SourceType=3)&&(rowid'=SourceID)
	......s rerowid=0
	......for  s rerowid=$o(^DHCEQRiskEvaluation(0,"Source",SourceType,SourceID,rerowid)) quit:(rerowid="")  d
	.......i RiskGradeDR="" d
	........s RiskGradeDR=$p($g(^DHCEQRiskEvaluation(rerowid)),"^",5)
	.......e  d
	........i (RiskGradeDR>$p($g(^DHCEQRiskEvaluation(rerowid)),"^",5)) s RiskGradeDR=$p($g(^DHCEQRiskEvaluation(rerowid)),"^",5)
	....
	....i RiskGradeDR'="" d
	.....s TCycleNum=$p($g(^DHCEQCCode("DHCEQCRiskGrade",RiskGradeDR)),"^",7)
	.....s TCycleUnitDR=$p($g(^DHCEQCCode("DHCEQCRiskGrade",RiskGradeDR)),"^",8)
	.....If TCycleUnitDR '="" Set TCycleUnit = $Piece($Get(^DHCEQCCode("DHCEQCCycleUnit",TCycleUnitDR)),"^",2)
	..Set TCycleNum=TCycleNum_TCycleUnit
	..Set TPreWarnDaysNum = $Piece($Get(^DHCEQMaintPlan($Piece(tmpStr,"^",3))),"^",12)
	..;Set TMaintFee = $Piece($Get(^DHCEQMaintPlan($Piece(tmpStr,"^",3))),"^",13)   ;MODIFY BY LMM 2020-05-13
	..///add by lmm 351521
	..Set TMaintLocDR = $Piece($Get(^DHCEQMaintPlan($Piece(tmpStr,"^",3))),"^",14)
	..Set TMaintLoc =##class(web.DHCEQCommon).GetTrakNameByID("dept",TMaintLocDR)
	..Set TMaintUserDR = $Piece($Get(^DHCEQMaintPlan($Piece(tmpStr,"^",3))),"^",15)
	..Set TMaintUser =##class(web.DHCEQCommon).GetTrakNameByID("user",TMaintUserDR)
	..Set TMaintMode = $Piece($Get(^DHCEQMaintPlan($Piece(tmpStr,"^",3))),"^",16)
	..i TMaintMode '="" s TMaintMode = $p($g(^DHCEQCCode("DHCEQCMaintMode",TMaintMode)),"^",2)	//modified by czf 20180816 HISUI改造 618972
	.Quit:(PlanNameDR'="")&&(PlanNameDR'=$Piece(tmpStr,"^",3))
	.Quit:(StartDate'="")&&(TNextDate<StartDate)
	.Quit:(EndDate'="")&&(TNextDate>EndDate)
	.
	.;汇总
	.Set TLastDate =##Class(web.DHCEQCommon).TransValueToPage(TLastDate,"date")
	.Set TNextDate =##Class(web.DHCEQCommon).TransValueToPage(TNextDate,"date")
	.Set TotalMaintFee=TotalMaintFee+TMaintFee
	.Set TotalNum=TotalNum+TQuantity
	.Set TotalFee=TotalFee+TOriginalFee
	.s TEquip=##Class(web.DHCEQMaintPlanNew).GetWarnIconNew(TNextDate,TPreWarnDaysNum)_TEquip	//modified by czf 20180817 HISUI改造
	.Do OutputRowGetEquipMeasureList
	
	Set TotalFlag=##class(web.DHCEQCommon).GetSysInfo("401001")
	If (TotalFlag'="")&&(TotalFlag'="0")
	{
		If TotalFlag="1" Set TotalLoc=1
		If TotalFlag="2" Set TotalLoc=index+1
		If TotalFlag="3" Set TotalLoc=0
		Do ResetVariablesGetEquipMeasureList
		Set TRow="合计:"
		Set TQuantity=TotalNum
		Set TOriginalFee=TotalFee
		s TMaintFee=TotalMaintFee
		If TOriginalFee'="" Set TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"")
	    Set Data=$lb(TRowID,TRow,TNo,TEquip,TModel,TQuantity,TDisplayStatus,TUseLoc,TLocation,TUnit,TOriginalFee,TName,TCycleNum,TCycleUnit,TLastDate,TNextDate,TMaintFee,TPreWarnDaysNum)
		Set ^CacheTemp(repid,TotalLoc)=Data
	}
	k ^TempDHCEQ("GetEquipMeasureList",Job)
	Quit $$$OK
SetEquipID
	if EquipID="" quit
	//MODIFY BY LMM 2020-04-27
	if (IsDisused="Y")&&($Piece($Get(^DHCEQEquip(EquipID)),"^",38)'=3)
	{
		Quit
	}
	if (IsDisused="N")&&($Piece($Get(^DHCEQEquip(EquipID)),"^",38)=3)
	{
		Quit
	}
	
	Set StockStatus=$Piece($Get(^DHCEQEquip(EquipID)),"^",60)
	if (StockStatus="0")||(StockStatus>"2")
	{
		Quit
	}
	/// 过滤计量设备
	//modify by lmm 2020-05-19 强检设备属于计量设备 1324074
	//if ($Piece($Get(^DHCEQMaintPlan(mpid)),"^",18)="Y")&&(##Class(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttributeYN(rowid)'="Y")
	if ($Piece($Get(^DHCEQMaintPlan(mpid)),"^",18)="Y")&&(##Class(web.DHCEQ.EM.BUSEquipAttribute).CheckEquipHaveAttributeGroup("01","3",rowid)'="Y")
	{
		Quit
	}
	//modified by csj 20190111 新版维护计划中不存在SourceType和SourceID,根据设备范围确定设备
	/*
	if (SourceType=2)
	{
		Set (PlanModelID,EQModelID)=""
		Set PlanModelID = $Piece($Get(^DHCEQMaintPlan(mpid)),"^",5)
		Set EQModelID = $Piece($Get(^DHCEQEquip(EquipID)),"^",3)
		if (PlanModelID'="")&&(PlanModelID'=EQModelID)
		{
			Quit
		}
	}*/
	
	// MZY0099	2160617		2021-11-13
	Set (str,LastDate,NextDate,FDate)=""
	Set maintrowid=$Order(^DHCEQMaint(0,"Equip",2,EquipID,""),-1)
	i maintrowid'="" Set FDate=$Piece($Get(^DHCEQMaint(maintrowid)),"^",5)
	Set str=##class(web.DHCEQ.EM.BUSMaintPlan).GetWarnDaysNum(mpid, FDate)
	Set LastDate=$Piece(str,"^",2)
	Set NextDate=$Piece(str,"^",3)
	if ($Data(^TempDHCEQ("GetEquipMeasureList",Job,EquipID)))
	{
		Set CurDate=+$H
		Set tmpStr=+$Get(^TempDHCEQ("GetEquipMeasureList",Job,EquipID))
		If ($ZABS(NextDate-CurDate)<=$ZABS(tmpStr-CurDate)) Set ^TempDHCEQ("GetEquipMeasureList",Job,EquipID)=NextDate_"^"_LastDate_"^"_mpid
	}
	else
	{
		Set ^TempDHCEQ("GetEquipMeasureList",Job,EquipID)=NextDate_"^"_LastDate_"^"_mpid
	}
	Quit
OutputRowGetEquipMeasureList
	Set TRow=TRow+1
	If TOriginalFee'="" Set TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"")
	If TMaintFee'="" Set TMaintFee=##Class(web.DHCEQCommon).FormatNumber(TMaintFee,"")
	Set Data=$lb(TRowID,TRow,TNo,TEquip,TModel,TQuantity,TDisplayStatus,TUseLoc,TLocation,TUnit,TOriginalFee,TName,TCycleNum,TCycleUnit,TLastDate,TNextDate,TMaintFee,TPreWarnDaysNum,TCommonName,TMaintLoc,TMaintUser,TMaintMode,TEquipDR,TRemark,TDisuseDate)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetEquipMeasureList
	Set (TRowID,TNo,TEquip,TModel,TQuantity,TDisplayStatus,TUseLoc,TLocation,TUnit,TOriginalFee,TName,TCycleNum,TCycleUnit,TLastDate,TNextDate,TMaintFee,TPreWarnDaysNum,TCommonName,TMaintLoc,TMaintUser,TMaintMode,TEquipDR,TRemark,TDisuseDate)=""
	Quit
}

ClassMethod GetEquipMeasureListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipMeasureListExecute ]
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

ClassMethod GetEquipMeasureListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipMeasureListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
