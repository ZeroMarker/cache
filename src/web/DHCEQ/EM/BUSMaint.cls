Class web.DHCEQ.EM.BUSMaint Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// modified by czf 1283063 增加出参TMaintTime CZF0134 2021-02-23 增加入参MaintIDs和出参TEquipRangeID
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSMaint","GetMaint","2","2","","","5","","","","","","")
Query GetMaint(BussType, EquipDR, MaintLocDR, MaintUserDR, MaintTypeDR, StartDate, EndDate, Status, QXType As %String = "", CurUser, TypeCode, User As %String = "", LocID As %String = "", MaintIDs As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquip:%String,TEquipDR:%String,TModelDR:%String,TModel:%String,TMaintPlanDR:%String,TMaintPlan:%String,TMaintTypeDR:%String,TMaintType:%String,TMaintDate:%String,TMaintLocDR:%String,TMaintLoc:%String,TMaintUserDR:%String,TMaintUser:%String,TMaintModeDR:%String,TMaintMode:%String,TTotalFee:%String,TNormalFlag:%String,TManageLocDR:%String,TManageLoc:%String,TUseLocDR:%String,TUseLoc:%String,TStatus:%String,TOtherFee:%String,TRemark:%String,TEquipNo:%String,TRow:%String,THold1:%String,TMaintTime:%String,TMaintYear:%String,TEquipRangeID:%String,TJob:%String,TMaintTypeDesc:%String")
{
}

ClassMethod GetMaintExecute(ByRef qHandle As %Binary, BussType, EquipDR, MaintLocDR, MaintUserDR, MaintTypeDR, StartDate, EndDate, Status, QXType As %String = "", CurUser, TypeCode, User As %String = "", LocID As %String = "", MaintIDs As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	//Modified By QW20181225 需求号:786608
 	s StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
    s EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	i StartDate="" s StartDate=0
	i EndDate="" s EndDate=+$h
	//add by lmm 2020-04-29
 	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	k ^DHCEQTemp("Maint",User)
	s PNum=1
	s TJob=$J
	//End By QW20181225 需求号:786608
	i MaintIDs'="" s MaintIDs=","_MaintIDs_","	//CZF0134 2021-02-23
	s index=1
	s TRow=1  //add by zx 2015-09-17
	i BussType'="" d		////czf 2021-09-20 begin
	.d BuildDataGetMaint
	e  d
	.s BussType=""
	.f  s BussType=$o(^DHCEQMaint(0,"Equip",BussType))  quit:BussType=""  d
	..d BuildDataGetMaint			//czf 2021-09-20 end
	Quit $$$OK
BuildDataGetMaint
	set EquipID=0
	f  s EquipID=$o(^DHCEQMaint(0,"Equip",BussType,EquipID))  quit:EquipID=""  d
	.q:(EquipDR'="")&&(EquipDR'=EquipID)
	.s TEquipDR = EquipID
	.s TEquip = $p($g(^DHCEQEquip(TEquipDR)),"^",1)
	.s TModel=""    ///modify by lmm 2017-03-26 352436
	.s TModelDR = $p($g(^DHCEQEquip(TEquipDR)),"^",3)
	.i TModelDR '= "" s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.s TEquipNo=$p($g(^DHCEQEquip(TEquipDR)),"^",71) //add by zx 2015-09-17
	.s rowid=0
	.f  s rowid=$o(^DHCEQMaint(0,"Equip",BussType,EquipID,rowid))  quit:rowid=""  d
	..q:(MaintIDs'="")&&(MaintIDs'[(","_rowid_","))		//CZF0134 2021-02-23
	..;Add By QW20160229 筛选个人单据
	..i CurUser'=""  d
	...s CurUserID="^"_CurUser_"^"
	...s useid="^"_$p($g(^DHCEQMaint(rowid)),"^",7)_"^"_$Piece($Get(^DHCEQMaint(rowid)),"^",15)_"^"_$Piece($Get(^DHCEQMaint(rowid)),"^",18)_"^"_$Piece($Get(^DHCEQMaint(rowid)),"^",21)_"^"_$Piece($Get(^DHCEQMaint(rowid)),"^",40)_"^" ;Add By QW20160229 筛选个人单据
	..q:(CurUser'="")&&(useid'[CurUserID) 
	..;End By QW20160229 筛选个人单据
	..d ResetVariablesGetMaint
	..s TRowID = rowid
	..s TMaintInvalidFlag = $p($g(^DHCEQMaint(rowid)),"^",39)	//无效标志
	..q:(TMaintInvalidFlag = "Y")								//2011-08-29 HZY0006 .判断是否有效.
	..s TMaintPlanDR = $p($g(^DHCEQMaint(rowid)),"^",3)
	..i TMaintPlanDR '="" d		//CZF0134 2021-02-23
	...s TMaintPlan = $p($g(^DHCEQMaintPlan(TMaintPlanDR)),"^",1)
	...s TEquipRangeID=$o(^DHCEQEquipRange(0,"SourceID","2",TMaintPlanDR,""))
	..s TMaintTypeDR = $p($g(^DHCEQMaint(rowid)),"^",4)
	..q:(TMaintTypeDR '= MaintTypeDR)&(MaintTypeDR '= "")
	..q:(TMaintTypeDR '="")&&(TypeCode'="")&&(TypeCode'=$p($g(^DHCEQCCode("DHCEQCMaintType",TMaintTypeDR)),"^",1)) ;Add By QW20160229
	..i TMaintTypeDR '="" s TMaintType = $p($g(^DHCEQCCode("DHCEQCMaintType",TMaintTypeDR)),"^",2)
	..i (BussType=1)&&(TMaintTypeDR="") s TMaintType="保养"		//add by czf
	..s TMaintDate =##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaint(rowid)),"^",5),"date")
	..q:($p($g(^DHCEQMaint(rowid)),"^",5)<StartDate)||($p($g(^DHCEQMaint(rowid)),"^",5)>EndDate)
	..i $p($g(^DHCEQMaint(rowid)),"^",5)'="" s TMaintYear= $p($zd($p($g(^DHCEQMaint(rowid)),"^",5),3),"-",1)	//czf 1730995
	..s TMaintTime=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaint(rowid)),"^",20),"time")	//czf 1283063
	..s TMaintLocDR = $p($g(^DHCEQMaint(rowid)),"^",6)
	..q:(TMaintLocDR '= MaintLocDR)&(MaintLocDR '= "")
	..;q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TMaintLocDR)))
	..i TMaintLocDR '=""  d
	...q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TMaintLocDR,LocID))) //modified by csj 20181126 需求号:757984
	...s TMaintLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TMaintLocDR)
	..s TMaintUserDR = $p($g(^DHCEQMaint(rowid)),"^",7)
	..q:(TMaintUserDR '= MaintUserDR)&(MaintUserDR '= "")
	..i TMaintUserDR '=""  d
	...s TMaintUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TMaintUserDR)
	..s TMaintModeDR = $p($g(^DHCEQMaint(rowid)),"^",8)
	..i TMaintModeDR '=""  d
	...s TMaintMode = $p($g(^DHCEQCCode("DHCEQMCMaintMode",TMaintModeDR)),"^",2)	// Mozy0252	826989		2020-3-3
	..s TTotalFee = ##Class(web.DHCEQCommon).FormatNumber(##Class(web.DHCEQ.EM.BUSMaintPlan).GetOtherFee(rowid),"")+$p($g(^DHCEQMaint(rowid)),"^",24) // Modified By QW20190312BUG:846568 
	..s TNormalFlag =##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaint(rowid)),"^",10),"bool")
	..s TManageLocDR = $p($g(^DHCEQMaint(rowid)),"^",11)
	..i TManageLocDR '="" s TManageLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TManageLocDR)
	..s TUseLocDR = $p($g(^DHCEQMaint(rowid)),"^",12)
	..i TUseLocDR '="" s TUseLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TUseLocDR)
	..s TStatus = $p($g(^DHCEQMaint(rowid)),"^",13)
	..q:(Status'="")&&(Status'=TStatus)
	..s TStatus=$CASE(TStatus,"0":"新增","1":"提交","2":"审核")
	..s THold1=$p($g(^DHCEQMaint(rowid)),"^",25)
	..s TRemark = $p($g(^DHCEQMaint(rowid)),"^",14)
	..s TOtherFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQMaint(rowid)),"^",24),"")
	..s TMaintTypeDesc=$case(BussType,"1":"保养","2":"检查","3":"维修",:"")		//czf 2021-09-20
	..s:(BussType=2)&&(TMaintTypeDR=4) TMaintTypeDesc="巡检"
	..s:(BussType=2)&&(TMaintTypeDR=5) TMaintTypeDesc="计量"
	..d OutputRowGetMaint
	quit
OutputRowGetMaint
	s Data=$lb(TRowID,TEquip,TEquipDR,TModelDR,TModel,TMaintPlanDR,TMaintPlan,TMaintTypeDR,TMaintType,TMaintDate,TMaintLocDR,TMaintLoc,TMaintUserDR,TMaintUser,TMaintModeDR,TMaintMode,TTotalFee,TNormalFlag,TManageLocDR,TManageLoc,TUseLocDR,TUseLoc,TStatus,TOtherFee,TRemark,TEquipNo,TRow,THold1,TMaintTime,TMaintYear,TEquipRangeID,TJob,TMaintTypeDesc)
	Set ^CacheTemp(repid,index)=Data
	//add by lmm 2020-04-29
	Set ^DHCEQTemp("Maint",User,TJob,PNum)=TRowID_"^"_TEquip_"^"_TEquipDR_"^"_TModelDR_"^"_TModel_"^"_TMaintPlanDR_"^"_TMaintPlan_"^"_TMaintTypeDR_"^"_TMaintType_"^"_TMaintDate_"^"_TMaintLocDR_"^"_TMaintLoc_"^"_TMaintUserDR_"^"_TMaintUser_"^"_TMaintModeDR_"^"_TMaintMode_"^"_TTotalFee_"^"_TNormalFlag_"^"_TManageLocDR_"^"_TManageLoc_"^"_TUseLocDR_"^"_TUseLoc_"^"_TStatus_"^"_TOtherFee_"^"_TRemark_"^"_TEquipNo_"^"_TRow_"^"_THold1
	s PNum=PNum+1
	Set index=index+1
	Set TRow=TRow+1  //add by zx 2015-09-17 
	quit
ResetVariablesGetMaint
	s (TRowID,TMaintPlanDR,TMaintPlan,TMaintTypeDR,TMaintType,TMaintDate,TMaintLocDR,TMaintLoc,TMaintUserDR,TMaintUser,TMaintModeDR,TMaintMode,TTotalFee,TNormalFlag,TManageLocDR,TManageLoc,TUseLocDR,TUseLoc,TStatus,TOtherFee,TRemark,TMaintTime,TMaintYear,TEquipRangeID,TMaintTypeDesc)=""
	quit
}

ClassMethod GetMaintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintExecute ]
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

ClassMethod GetMaintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaintExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetMaintEquipByPlanID(MaintPlanDR, Equip, QXType) As %Query(ROWSPEC = "TName:%String,Hidden:%String,TNo:%String,TModel:%String,TModelDR:%String")
{
}

ClassMethod GetMaintEquipByPlanIDExecute(ByRef qHandle As %Binary, MaintPlanDR, Equip, QXType) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	set Job=$j
	s index=1
	s Type = $p($g(^DHCEQMaintPlan(MaintPlanDR)),"^",2)
	s SourceType = $p($g(^DHCEQMaintPlan(MaintPlanDR)),"^",3)
	s SourceID = $p($g(^DHCEQMaintPlan(MaintPlanDR)),"^",4)
	s MaintLocDR=$p($g(^DHCEQMaintPlan(MaintPlanDR)),"^",14)
	if SourceType=1 d  //"1":"设备分类"
	.s EquipCatStr=##Class(web.DHCEQCEquipeCat).GetChildIDsByCatID(sourceid)
	.s Len=$l(EquipCatStr,"^")
	.s i=0
	.f i=1:1:Len  d
	..s ChildsSourceID=$p(EquipCatStr,"^",i)
	..s EquipID=0
	..f  set EquipID=$order(^DHCEQEquip(0,"StoreLocEquipCat",MaintLocDR,SourceID,EquipID))  quit:EquipID=""  d
	...d OutputRowGetMaintEquipByPlanID
	else  if SourceType=2 d  //"2":"设备项"
	.s EquipID=0
	.f  s EquipID=$o(^DHCEQEquip(0,"StoreLocItem",MaintLocDR,SourceID,EquipID))  quit:EquipID=""  d
	..d OutputRowGetMaintEquipByPlanID
	else  if SourceType=3 d  //"3":"设备"
	.s EquipID=SourceID
	.d OutputRowGetMaintEquipByPlanID
	Quit $$$OK
OutputRowGetMaintEquipByPlanID
	Quit:$p($g(^DHCEQEquip(EquipID)),"^",38)>"2"
	s TRowID=EquipID
	s TName =$p($g(^DHCEQEquip(EquipID)),"^",1)
	q:(Equip'="")&&((TName'[Equip)&&(No'[Equip))
	s No =$p($g(^DHCEQEquip(EquipID)),"^",71)
	s ModelDR =$p($g(^DHCEQEquip(EquipID)),"^",3)
	i ModelDR'="" s Model =##Class(web.DHCEQCommon).GetTrakNameByID("model",ModelDR)
	s Data=$lb(TName,TRowID,TNo,TModel,TModelDR)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetMaintEquipByPlanID
	Set (TName,TRowID,TNo,TModel,TModelDR)=""
	quit
}

ClassMethod GetMaintEquipByPlanIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintEquipByPlanIDExecute ]
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

ClassMethod GetMaintEquipByPlanIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaintEquipByPlanIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// MZY0076	2021-05-25
/// w ##Class(web.DHCEQ.EM.BUSMaint).GetOneMaintNew("19")
ClassMethod GetOneMaintNew(RowID As %Library.String = "")
{
	s $ZT="ERRORGetOneMaintNew"
	s ObjMaint=##Class(User.DHCEQMaint).%OpenId(RowID)
	s Maintnfo=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(ObjMaint)
	d Maintnfo.%Set("MTEquip",ObjMaint.MTEquipDR.EQName)
	if ObjMaint.MTSourceID'="" d Maintnfo.%Set("MTPlanName",$P($G(^DHCEQMaintPlan(ObjMaint.MTSourceID)),"^",1))
	d Maintnfo.%Set("MTMaintTypeDR_MTDesc",ObjMaint.MTMaintTypeDR.MTDesc)
	d Maintnfo.%Set("MTMaintLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjMaint.MTMaintLocDR))
	d Maintnfo.%Set("MTMaintUserDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjMaint.MTMaintUserDR))
	d Maintnfo.%Set("MTMaintModeDR_MMDesc",ObjMaint.MTMaintModeDR.MMDesc)
	d Maintnfo.%Set("MTUseLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjMaint.MTUseLocDR))
	s (PMReportDR,PMTemplateDR)=""
	s PMReportDR=$o(^DHCEQPMReport(0,"MaintDR",RowID,0))
	i PMReportDR'="" s PMTemplateDR=$p($g(^DHCEQPMReport(PMReportDR)),"^",1)
	d Maintnfo.%Set("PMReportDR",PMReportDR)
	d Maintnfo.%Set("PMRTemplateDR",PMTemplateDR)
	
	s PELDR=$o(^DHCEQPlanExecuteList(0,"Maint",RowID,0))
	// MZY0082	1965403		2021-07-14	修正获取执行单
	i PELDR'="" d
	.s PELPlanExecuteDR=$p($g(^DHCEQPlanExecuteList(+PELDR)),"^",1)
	.i PELPlanExecuteDR'="" d
	..d Maintnfo.%Set("PELPlanExecuteDR",PELPlanExecuteDR)
	..d Maintnfo.%Set("MTPlanExecute",$p($g(^DHCEQPlanExecute(+PELPlanExecuteDR)),"^",1))
	
	
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,Maintnfo)
ERRORGetOneMaintNew
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012",ErrorMsg)
}

/// w ##Class(web.DHCEQ.EM.BUSMaint).GetOneMaint("1")
ClassMethod GetOneMaint(rowid)
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQMaint(rowid)
	s resultex=resultex_"^"	;EquipDR		1
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",1))),"^",1)
	s resultex=resultex_"^"	;BussType		2
	i $p(result,"^",2)'=""  d  
	.s resultex=resultex_$CASE($p(result,"^",2),"1":"保养","2":"检查","3":"维修")
	s resultex=resultex_"^"	;MaintPlanDR	3
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQMaintPlan($p(result,"^",3))),"^",1)
	s resultex=resultex_"^"	;MaintTypeDR	4
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMaintType",$p(result,"^",4))),"^",2)
	s $p(result,"^",5)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",5),"date")	;MaintDate
	s resultex=resultex_"^"	;MaintLocDR		5
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",6))
	s resultex=resultex_"^"	;MaintUserDR	6
	i $p(result,"^",7)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",7))
	s resultex=resultex_"^"	;MaintModeDR	7
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQMCMaintMode",$p(result,"^",8))),"^",2)	// Mozy0252	826989		2020-3-3
	s $p(result,"^",9)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",9),"")
	s $p(result,"^",10)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",10),"bool")	;NormalFlag
	s resultex=resultex_"^"	;ManageLocDR	8
	i $p(result,"^",11)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",11))
	s resultex=resultex_"^"	;UseLocDR		9
	i $p(result,"^",12)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",12))
	
	s resultex=resultex_"^"	;Status			10
	i $p(result,"^",13)'=""  d
	.s resultex=resultex_$CASE($p(result,"^",13),"0":"新增","1":"提交","2":"审核")
	s resultex=resultex_"^"	;UpdateUserDR	11
	i $p(result,"^",15)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",15))
	s $p(result,"^",16)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",16),"date")	;UpdateDate
	s resultex=resultex_"^"	;AuditUserDR	12
	i $p(result,"^",18)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",18))
	s $p(result,"^",19)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",19),"date")	;AuditDate
	s resultex=resultex_"^"	;SubmitUserDR	13
	i $p(result,"^",21)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",21))
	s $p(result,"^",22)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",22),"date")	;SubmitDate
	s $p(result,"^",24)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",24),"")
	s $p(result,"^",30)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",30),"bool")	;MeasureFlag
	
	s resultex=resultex_"^"	;MeasureDeptDR		14
	i $p(result,"^",31)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMeasureDept",$p(result,"^",31))),"^",1)
	s resultex=resultex_"^"	;ServiceDR			15
	i $p(result,"^",35)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("service",$p(result,"^",35)) //CZF0093 modify by zyq 2022-11-09
	s $p(result,"^",39)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",39),"bool")	;InvalidFlag
	s resultex=resultex_"^"	;DelUserDR			16
	i $p(result,"^",40)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",40))
	s $p(result,"^",41)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",41),"date")	;DelDate
	
	;start by csj 20190111 整理拼串
	s resultex=resultex_"^"	;AvailableDate
	s CIRowID=$o(^DHCEQCertificateInfo(0,"Source",4,rowid,0))
	i CIRowID'="" s resultex=resultex_##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQCertificateInfo(CIRowID)),"^",8),"date")
	
	s resultex=resultex_"^"	;CertificateNo
	i CIRowID'="" s resultex=resultex_$p($g(^DHCEQCertificateInfo(CIRowID)),"^",4)
	
	s resultex=resultex_"^"	;add by csj 20181103 计划rowid
	//modified by csj 20191018 同一计划可对应多个执行单号
#;	i $p(result,"^",3)'=""  d
#;	.s PlanExecuteRowid=$o(^DHCEQPlanExecute("0","MaintPlan",$p(result,"^",3),"0"))
#;	.i PlanExecuteRowid'="" s resultex=resultex_PlanExecuteRowid	
	s PlanExecuteListDR = $o(^DHCEQPlanExecuteList("0","Maint",rowid,"0"))
	s PlanExecuteRowid =""
	i PlanExecuteListDR'="" d
	.s PlanExecuteRowid = $p($g(^DHCEQPlanExecuteList(PlanExecuteListDR)),"^",1)
	.s resultex=resultex_PlanExecuteRowid
		
	s resultex=resultex_"^"	
	i PlanExecuteRowid'="" s resultex=resultex_$p($g(^DHCEQPlanExecute(PlanExecuteRowid)),"^",1)	//add by csj 20181103 计划执行单号
	
	
	//add by lmm 2020-04-29 1279496
	s resultex=resultex_"^"	
	s ContractEquipName=""
	//modify by lmm 2020-05-08 1307160
	i $p(result,"^",25)'="" d
	.s ContractDR=$p($g(^DHCEQContractList($p(result,"^",25))),"^",1)
	.s ContractEquipName=$p($g(^DHCEQContract(ContractDR)),"^",1)
	.s resultex=resultex_ContractEquipName
	//add by lmm 2020-04-29 1279496
	//Add By DJ 2021-07-12
	s resultex=resultex_"^"	
	i $p(result,"^",27)'=""  d
	.s resultex=resultex_$p($g(^DHCEQAffix($p(result,"^",27))),"^",4)
	s result=result_resultex
	;end by csj 20190111 整理拼串
	
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

///  MZY0147	3164887		2022-12-20	修正入参为TemplateDR
/// add:zy 2011-03-23  No ZY0066
/// 描述:新增、更新
/// add by zx 2019-07-07 增加检查保养内容参数
/// w ##Class(web.DHCEQ.EM.BUSMaint).SaveData("^38058^1^6^1^21/03/2011^114^^^^true^^^^^^^^^^^false^^^^^^^^^true")
/// ----------------------------------
ClassMethod SaveData(val, type As %String = "", User As %String = "", TemplateDR As %String = "", PMReportList As %String = "")
{
	new RowID,Date,Time  //add by zx 2015-12-17
	k PLIST, PL
	Set $ZT="ERRORSave"
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID")) //add by zx 2015-12-17
	s Date=+$H
	s Time=$P($H,",",2)
	s RowID = $p(val,"^",1)	;RowID
	s PLIST(2) = $p(val,"^",2)	;EquipDR
	s PLIST(3) = $p(val,"^",3)	;BussType	2计量	2巡检	1保养
	s PLIST(4) = $p(val,"^",4)	;MaintPlanDR
	s PLIST(5) = $p(val,"^",5)	;MaintTypeDR	5计量 4巡检 null保养
	s PLIST(6) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",6),"date")	;MaintDate
	s PLIST(7) = $p(val,"^",7)	;MaintLocDR
	s PLIST(8) = $p(val,"^",8)	;MaintUserDR
	s PLIST(9) = $p(val,"^",9)	;MaintModeDR
	i RowID'=""
	{
		// Modified By QW20180726 BUG:QW0014 更新单据总金额totalfee=修改后maintfee+partfee
		s PLIST(10)=##Class(web.DHCEQ.EM.BUSMaintPlan).GetOtherFee(RowID)+$p(val,"^",16)
	}
	else
	{
		s PLIST(10) = +$p(val,"^",16)	;Total = OtherFee
	}
	s PLIST(11) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",11),"bool")	;NormalFlag
	s PLIST(12) = $p(val,"^",12)	;ManageLocDR
	s PLIST(13) = $p(val,"^",13)	;UseLocDR
	s PLIST(14) = $p(val,"^",14)	;Status
	i PLIST(14)="" s PLIST(14) = 0	;Status
	s PLIST(15) = $p(val,"^",15)	;Remark
	s PLIST(16) = User				;UpdateUserDR
	s PLIST(17) = Date				;UpdateDate
	s PLIST(18) = Time				;UpdateTime
	if (type=1)
	{
		s PLIST(19) = User				;AuditUserDR
		s PLIST(20) = Date				;AuditDate
		s PLIST(21) = Time				;AuditTime
	}
	/*
	s PLIST(22) = $p(val,"^",15)	;SubmitUserDR
	s PLIST(23) = $p(val,"^",15)	;SubmitDate
	s PLIST(24) = $p(val,"^",15)	;SubmitTime*/
	
	s PLIST(25) = +$p(val,"^",16)   ;OtherFee
	s PLIST(26) = $p(val,"^",17)	;Hold1
	s PLIST(27) = $p(val,"^",18)	;Hold2
	s PLIST(28) = $p(val,"^",19)	;Hold3
	s PLIST(29) = $p(val,"^",20)	;Hold4
	s PLIST(30) = $p(val,"^",21)	;Hold5
	s PLIST(31) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",22),"bool")	;MeasureFlag
	s PLIST(32) = $p(val,"^",23)	;MeasureDeptDR
	s PLIST(33) = $p(val,"^",24)	;MeasureHandler
	s PLIST(34) = $p(val,"^",25)	;MeasureTel
	s PLIST(35) = $p(val,"^",26)	;MeasureUsers
	s PLIST(36) = $p(val,"^",27)	;ServiceDR
	s PLIST(37) = $p(val,"^",28)	;ServiceHandler
	s PLIST(38) = $p(val,"^",29)	;ServiceTel
	s PLIST(39) = $p(val,"^",30)	;ServiceUsers
	s PLIST(40) =  ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",31),"bool")	;InvalidFlag
	
	s PL(2)="4"    			//检查记录类型
	s PL(3)=$p(val,"^",1)      //检查记录DR  
	s PL(5)=$p(val,"^",33)  ;Add By QW20160314增加计量号 
	s PL(9)=##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",32),"date")		//Add By HHM HHM0029 证书效期，直接存在直接存在DHC_EQCertificateInfo不做维护
	/*
	s PLIST(41) = $p(val,"^",21)	;DelUserDR
	s PLIST(42) = $p(val,"^",21)	;DelDate
	s PLIST(43) = $p(val,"^",21)	;DelTime
	*/
	TSTART
	if RowID=""
	{
		&SQL(insert into sqluser.DHC_EQMaint values :PLIST())
		s RowID=$G(%ROWID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		i (PL(9)'="")||(PL(5)'="")
		{
			s PL(3)=RowID
			&SQL(INSERT INTO SQLUSER.DHC_EQCertificateInfo VALUES:PL())			
		}
	}
	else
	{
		s tmpid=""
		&SQL(SELECT CI_RowID INTO:tmpid FROM SQLUSER.DHC_EQCertificateInfo WHERE CI_SourceID=:RowID AND CI_SourceType='4')
		i (PL(9)'="")||(PL(5)'="")
		{
			i (tmpid="")
			{
				s PL(3)=RowID
				&SQL(INSERT INTO SQLUSER.DHC_EQCertificateInfo VALUES:PL())	
				i SQLCODE
				{
					TROLLBACK
					q SQLCODE
				}				
			}
			else
			{
				&SQL(UPDATE SQLUSER.DHC_EQCertificateInfo VALUES:PL() WHERE CI_SourceID=:RowID AND CI_SourceType='4')
				i SQLCODE
				{
					TROLLBACK
					q SQLCODE
				}			
			}
		}
		else
		{
			i tmpid'=""
			{
				&SQL(DELETE FROM SQLUSER.DHC_EQCertificateInfo WHERE CI_SourceID=:RowID AND CI_SourceType='4')  
				i SQLCODE=100 s SQLCODE=0
				i SQLCODE
				{
					TROLLBACK
					q SQLCODE
				}
			}			
		}
		&SQL(update sqluser.DHC_EQMaint values :PLIST() where MT_RowID=:RowID)

	}
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	/* MZY0147	3164887		2022-12-20
	s PMReportDR=""
	i PMReport'=""
	{
		s ReturnInfo=##Class(web.DHCEQ.Process.DHCEQPMReport).SaveData(PMReport,"",RowID)
		s SQLCODE=$p(ReturnInfo,"^",1)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		s PMReportDR=$p(ReturnInfo,"^",2)
	}*/
	s PMReportDR=$o(^DHCEQPMReport(0,"MaintDR",RowID,""))
	if PMReportDR'=""
    {
		&SQL(Update SQLUSER.DHC_EQPMReport set PMR_TemplateDR=:TemplateDR where PMR_RowID = :PMReportDR)
		if SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"-90127")
		}
	}
	else
	{
		&SQL(insert into SQLUSER.DHC_EQPMReport (PMR_TemplateDR,PMR_MaintDR,PMR_Status,PMR_InvalidFlag) Values (:TemplateDR,:RowID,'0','N'))
		s PMReportDR=$g(%ROWID)
	}
	i (PMReportList'="")&&(PMReportDR'="")
	{
		// MZY0147	3164887		2022-12-20
		//s SQLCODE=##Class(web.DHCEQ.Process.DHCEQPMReportList).SaveMPReportList(PMReportDR,PMReportList)
		s SQLCODE=##Class(web.DHCEQ.Process.DHCEQPMReportList).SaveMPReportListNew(PMReportDR,PMReportList)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	s Status=PLIST(14)             //add by czf 388716 begin
	i Status=2  s SQLCODE=##class(web.DHCEQ.EM.BUSMaint).InsertEQLifeInfo(RowID,User)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}                                //add by czf 388716 end
	
	//start by csj 20191018 绑定计划执行明细
	k PEList
	s PlanExecuteDR = $p(val,"^",34)	;PlanExecuteDR
	s EquipDR = $p(val,"^",2)	;EquipDR
	;modify by lmm 2020-04-24 1290438
	i (PlanExecuteDR'="") d	//add by csj 20191021 有计划执行ID则绑定该计划执行单,防止SQLCODE为100
	.&SQL(update sqluser.DHC_EQPlanExecuteList  SET PEL_MaintDR=:RowID where PEL_PlanExecuteDR=:PlanExecuteDR and PEL_EquipDR=:EquipDR)
	
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	//end by csj 20191018 
	//modify by lmm 2020-04-24 维护提交后生成下列信息
	/*
	//start by csj 20200209 生成租赁维护对照
	s SQLCODE=##class("web.DHCEQ.RM.BUSShareResource").CreateRentMaintMap(EquipDR,2,RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	//end by csj 20200209 
	*/
 	TCOMMIT
 	q RowID
ERRORSave 
	TROLLBACK
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORSave"_ErrorMsg     //返回错误消息 ;
}

/// ----------------------------------
/// add:zy 2011-03-23  No ZY0066
/// 描述:删除
/// w ##Class(web.DHCEQ.EM.BUSMaint).DeleteData("9^^^516^1^^")
/// ----------------------------------
ClassMethod DeleteData(RowID)
{
	Set $ZT="ERRORDelete"	
	TSTART	
	&sql(Delete from sqluser.DHC_EQMaintItem where MTI_MaintDR=:RowID)
	i SQLCODE=100 s SQLCODE=0
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	&sql(Delete from sqluser.DHC_EQMaintPart where MTP_MaintDR=:RowID)
	i SQLCODE=100 s SQLCODE=0
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	&SQL(DELETE FROM SQLUSER.DHC_EQCertificateInfo WHERE CI_SourceID=:RowID AND CI_SourceType='4')   ;Add By HHM0029 20151203 
	i SQLCODE=100 s SQLCODE=0
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	&sql(Delete from sqluser.DHC_EQMaint where MT_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	//add by zx 2019-07-06 无效保养内容项目
	&SQL(Update SQLUSER.DHC_EQPMReport set PMR_InvalidFlag='Y' Where PMR_MaintDR=:RowID)
	i SQLCODE=100 s SQLCODE=0  // add by sjh SJH0039 2020-11-13 修改返回值为0
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
ERRORDelete 
	TROLLBACK
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORDelete"_ErrorMsg     //返回错误消息 ;
}

/// ----------------------------------
/// add:zy 2011-03-23  No ZY0066
/// 描述:提交
/// w ##Class(web.DHCEQ.EM.BUSMaint).SubmitData(121,"",1,21,"","Y")
ClassMethod SubmitData(RowID, PERowID, BussType, EquipID, User As %String = "", CancelFlag As %String = "")
{
	new Date,Time  //add by zx 2015-12-17
	k AppList,PLIST,PEList
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID")) //add by zx  2015-12-17
	s Date=+$H
	s Time=$P($H,",",2)
	Set $ZT="ERRORSubmit"
	s PLIST(14) = "2"	;Status 
	s PLIST(19) = User	;AuditUserDR
	s PLIST(20) = Date	;AuditDate
	s PLIST(21) = Time	;AuditTime
	s PLIST(22) = User	;SubmitUserDR
	s PLIST(23) = Date	;SubmitDate
	s PLIST(24) = Time	;SubmitTime
	//Modefied by zc0107 20211115 系统参数控制是否需要审核 begin
	i ((BussType=1)&&(##class(web.DHCEQCommon).GetSysInfo("501001")=1)) s PLIST(14) = "1"
	i ((BussType=2)&&(##class(web.DHCEQCommon).GetSysInfo("502001")=1)&&($p($g(^DHCEQMaint(RowID)),"^",4)'=5)) s PLIST(14) = "1"    //Modfied by zc0125 计量记录提交不需要审核
	//Modefied by zc0107 20211115 系统参数控制是否需要审核 end
	TSTART
	&SQL(update sqluser.DHC_EQMaint values :PLIST() where MT_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	s Status=PLIST(14)                              //add by czf 388716 begin
	i Status=2 s SQLCODE=##class(web.DHCEQ.EM.BUSMaint).InsertEQLifeInfo(RowID,User)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}  
	                                          //add by czf 388716 end
#;	/// 入参：PERowID 计划执行id
#;///      MaintRowID  保养id
#;///      EquipID  设备id
#;///      BussType 维护类型  1 保养 2 巡检
#;ClassMethod ExecutePlanByMaint(PERowID, MaintRowID, EquipID, BussType)
	//add by lmm 2020-05-07 begin 1301246
	//modify by lmm 2020-05-11
	i (CancelFlag="Y")&&(PERowID'="")
	{		
		&SQL(update sqluser.DHC_EQPlanExecuteList Set PEL_MaintDR = NULL where PEL_MaintDR=:RowID and PEL_PlanExecuteDR=:PERowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}	
	}
	i (PERowID'="")&&(CancelFlag="N")	s SQLCODE=##Class(web.DHCEQ.EM.BUSMaintExecute).ExecutePlanByMaint(PERowID,RowID,EquipID,BussType) ;modified by csj 20190213
	//add by lmm 2020-05-07 end 1301246
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	
	//add by lmm 2020-04-24 生成租赁维护对照 维护记录提交时生成
	s SQLCODE=##class("web.DHCEQ.RM.BUSShareResource").CreateRentMaintMap(EquipID,2,RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}	
	
	
 	TCOMMIT
 	q RowID
ERRORSubmit 
	TROLLBACK
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORSubmit"_ErrorMsg     //返回错误消息 ;
}

/// MZY0076	2021-05-25	增加对执行明细处理
/// ----------------------------------
/// add:zy 2011-03-23  No ZY0066
/// 描述:反提交
/// w ##Class(web.DHCEQ.EM.BUSMaint).CancelSubmitData("2")
/// ----------------------------------
ClassMethod CancelSubmitData(RowID, PlanExecuteListDR As %String = "")
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	Set $ZT="ERRORCancel"
	k PLIST
 	//s PLIST(14) = "0"			;Status
	s PLIST(40) = "Y"			;InvalidFlag
	s PLIST(41) = User			;DelUserDR
	s PLIST(42) = Date			;DelDate
	s PLIST(43) = Time			;DelTime
	TSTART
	&SQL(update sqluser.DHC_EQMaint values :PLIST() where MT_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	// MZY0083	1975540		2021-07-19	修正执行单的已执行数量
	i PlanExecuteListDR'=""
	{
		&SQL(update sqluser.DHC_EQPlanExecuteList set PEL_MaintDR=null,PEL_ExecuteFlag='N',PEL_ExecuteResult=null where PEL_RowID=:PlanExecuteListDR)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		s PERowID=$p(^DHCEQPlanExecuteList(PlanExecuteListDR),"^",1)
		i PERowID'=""
		{
			s ExecuteNum=$p(^DHCEQPlanExecute(PERowID),"^",5)-1
			&SQL(update sqluser.DHC_EQPlanExecute Set PE_ExecutedNum=:ExecuteNum where PE_RowID=:PERowID)
		}
	}
 	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
 	TCOMMIT
 	q RowID
ERRORCancel 
	TROLLBACK
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORCancel"_ErrorMsg     //返回错误消息 ;
}

/// w ##Class(web.DHCEQ.EM.BUSMaint).Execute("10^67442",1)
ClassMethod Execute(valRowIDs, BussType)
{
	new User,Date,Time,len,i,val,Plan,EquipID,flag,Str
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	set flag=0
	set len=$l(valRowIDs,",")
	for i=1:1:len
	{
		quit:flag'=0
		set val=$p(valRowIDs,",",i)
		set PlanID=$p(val,"^",1)
		set EquipID=$p(val,"^",2)
		set MaintTypeDR=$p($g(^DHCEQMaintPlan(PlanID)),"^",9)
		set MaintDate=##Class(web.DHCEQCommon).TransValueToPage(Date,"date")
		set MaintLocDR=$p($g(^DHCEQMaintPlan(PlanID)),"^",14)
		set MaintUserDR=$p($g(^DHCEQMaintPlan(PlanID)),"^",15)
		set MaintModeDR=$p($g(^DHCEQMaintPlan(PlanID)),"^",16)
		set TotalFee=##Class(web.DHCEQ.EM.BUSMaintPlan).GetOtherFee(PlanID,"1")  // Modified By QW20190312BUG:846568 取计划配件
		set NormalFlag=""
		set ManageLocDR=""
		set UseLocDR=$p($g(^DHCEQEquip(EquipID)),"^",19)  ///modify by lmm 2017-03-26
		set Status="2"
		set Remark=$p($g(^DHCEQMaintPlan(PlanID)),"^",25)
		set MaintFee=$p($g(^DHCEQMaintPlan(PlanID)),"^",13)
		set Hold1=""
		set Hold2=""
		set Hold3=""
		set Hold4=""
		set Hold5=""
		set MeasureFlag=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMaintPlan(PlanID)),"^",18),"bool")
		set MeasureDeptDR=$p($g(^DHCEQMaintPlan(PlanID)),"^",19)
		set MeasureHandler=$p($g(^DHCEQMaintPlan(PlanID)),"^",20)
		set MeasureTel=$p($g(^DHCEQMaintPlan(PlanID)),"^",21)
		set MeasureUsers=""
		set ServiceDR=$p($g(^DHCEQMaintPlan(PlanID)),"^",22)
		set ServiceHandler=$p($g(^DHCEQMaintPlan(PlanID)),"^",23)
		set ServiceTel=$p($g(^DHCEQMaintPlan(PlanID)),"^",24)
		set ServiceUsers=""
		set InvalidFlag=""
		set Str="^"_EquipID_"^"_BussType_"^"_PlanID_"^"_MaintTypeDR_"^"_MaintDate_"^"_MaintLocDR_"^"
		set Str=Str_MaintUserDR_"^"_MaintModeDR_"^"_TotalFee_"^"_NormalFlag_"^"_ManageLocDR_"^"
		set Str=Str_UseLocDR_"^"_Status_"^"_Remark_"^"_MaintFee_"^"_Hold1_"^"_Hold2_"^"_Hold3_"^"_Hold4_"^"_Hold5_"^"
		set Str=Str_MeasureFlag_"^"_MeasureDeptDR_"^"_MeasureHandler_"^"_MeasureTel_"^"_MeasureUsers_"^"
		set Str=Str_ServiceDR_"^"_ServiceHandler_"^"_ServiceTel_"^"_ServiceUsers_"^"_InvalidFlag
		set flag=##Class(web.DHCEQ.EM.BUSMaint).SaveData(Str,1)
		if flag>0 set flag=0
	}
	q flag
}

/// add:czf 2017-06-1 388716
/// 描述:执行计划和新建维护记录时写入生命周期表
ClassMethod InsertEQLifeInfo(RowID, User)
{
	new (RowID,User)
	q:RowID=""
	s SQLCODE=0
	s Date=+$H
	s Time=$P($H,",",2)
	s EquipID=$p($g(^DHCEQMaint(RowID)),"^",1)
	s BussType=$p($g(^DHCEQMaint(RowID)),"^",2)
	s MaintTypeDR=$p($g(^DHCEQMaint(RowID)),"^",4)
	
	k LI
	s LI(2)=EquipID //设备
	s LI(4)=$p($g(^DHCEQEquip(EquipID)),"^",19)   	//原使用科室
	s LI(5)=$p($g(^DHCEQEquip(EquipID)),"^",17) 	//原管理科室
	s LI(6)=$p($g(^DHCEQEquip(EquipID)),"^",67)  	//原库房
	s LI(7)=$p($g(^DHCEQEquip(EquipID)),"^",27)  	//原值
	s LI(8)=$p($g(^DHCEQEquip(EquipID)),"^",28)  	//原净值
	s LI(9)=$p($g(^DHCEQEquip(EquipID)),"^",19)  	//变动后使用科室
 	s LI(10)=$p($g(^DHCEQEquip(EquipID)),"^",17) 	//变动后管理科室
 	s LI(11)=$p($g(^DHCEQEquip(EquipID)),"^",67)  	//变动后库房
 	s LI(12)=$p($g(^DHCEQEquip(EquipID)),"^",27)  	//变动后原值
 	s LI(13)=$p($g(^DHCEQEquip(EquipID)),"^",28)  	//变动后净值
	s LI(16)=Date			//变动日期
	//begin add by jyp 2020-03-20 
	if ((##class(web.DHCEQCommon).GetSysInfo("401007")=1)&&($p($g(^DHCEQMaint(RowID)),"^",5)'="")) d
	.s LI(16)=$p($g(^DHCEQMaint(RowID)),"^",5)			//变动日期
	//end add by jyp 2020-03-20 
	s LI(17)=Time			//变动时间
	s LI(18)=$p($g(^DHCEQMaint(RowID)),"^",9)   	//费用
	s LI(19)="P"  			//生命周期类型
	i BussType=1 d
	.s LI(20)=32            //保养
	i BussType=2 d
	.s LI(20)=33            //检查
	.i MaintTypeDR=4 s LI(14)="巡检"
	.i MaintTypeDR=5 s LI(14)="计量"
	s LI(21)=RowID	//来源ID
	s LI(27)=User	//更新人
	s LI(28)=Date	//更新日期
	s LI(29)=Time	//更新时间
	&SQL(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI())
	q SQLCODE
}

/// Mozy0252	826991		2020-3-3
/// 维护费用明细
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSMaint","GetFeeInfo",14)
Query GetFeeInfo(RowID As %String = "") As %Query(ROWSPEC = "Row:%String,RowID:%String,Index:%String,Item:%String,Fee:%String")
{
}

ClassMethod GetFeeInfoExecute(ByRef qHandle As %Binary, RowID As %String = "") As %Status
{
 	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	If (RowID="") Quit $$$OK
 	
	Set Row=1
	Set index=1
	s Index=0
	f  s Index=$o(^DHCEQMaint(RowID,"FeeInfo",Index)) quit:Index=""  d
	.s Item = $p($g(^DHCEQMaint(RowID,"FeeInfo",Index)),"^",1)
	.s Fee = $p($g(^DHCEQMaint(RowID,"FeeInfo",Index)),"^",2)
	.s Fee=##Class(web.DHCEQCommon).FormatNumber(Fee,"")
	.d OutputRowGetFeeInfo
	Quit $$$OK
OutputRowGetFeeInfo
	Set Data=$lb(Row,RowID,Index,Item,Fee)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set Row=Row+1
	quit
}

ClassMethod GetFeeInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFeeInfoExecute ]
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

ClassMethod GetFeeInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFeeInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Mozy0252	826991		2020-3-3
/// 保存费用
/// w ##Class(web.DHCEQ.EM.BUSMaint).SaveFeeInfo("14^^ASDF^45")
ClassMethod SaveFeeInfo(val)
{
	s RowID = $p(val,"^",1)
	s Index = +$p(val,"^",2)
	s Item = $p(val,"^",3)
	s Fee = +$p(val,"^",4)
	i (RowID="") q 0
	i Index=0
	{
		s Index=1+$o(^DHCEQMaint(RowID,"FeeInfo",""),-1)
	}
	s ^DHCEQMaint(RowID,"FeeInfo",Index) = Item_"^"_Fee
	q 0
}

/// Mozy0252	826991		2020-3-3
/// 删除费用
/// w ##Class(web.DHCEQ.EM.BUSMaint).DeleteFeeInfo("14^45")
ClassMethod DeleteFeeInfo(val)
{
	s RowID = $p(val,"^",1)
	s Index = +$p(val,"^",2)
	i (RowID="")||(Index="") q 0
	
	k ^DHCEQMaint(RowID,"FeeInfo",Index)
	q 0
}

/// w ##Class(web.DHCEQCommon).GetNum()
/// add by lmm 2020-04-29
ClassMethod GetNum(node As %Library.String = "", job)
{
	s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s gnum=$o(^DHCEQTemp("Maint",curuser,job,""),-1)   
 	//s gnum=$o(^DHCEQTemp("Equip",+$H,$j,""),-1)
  	q gnum
}

/// add by lmm 2020-04-29
ClassMethod GetList(node As %Library.String = "", job, gnum, rows As %Library.String = "")
{
	s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s str=^DHCEQTemp("Maint",curuser,job,gnum)       //Modified by JYP0019 台账添加job对多用户进行限制
	if rows'=""
	{
		for i=1:1:rows-1
		{
			s str=str_$c(2)_^DHCEQTemp("Maint",curuser,job,gnum+i)        //Modified by JYP0019 台账添加job对多用户进行限制
		}
	}
 	//s str=^DHCEQTemp("Equip",+$H,$j,gnum)
  	q str
}

/// add by lmm 2020-08-10 1379412
/// desc:补录计量证书内容
ClassMethod SaveCertificateInfo(RowID, certificateinfo)
{
	s PL(2)="4"    			//检查记录类型
	s PL(3)=RowID      //检查记录DR  
	s PL(5)=$p(certificateinfo,"^",1)  ;Add By QW20160314增加计量号 
	s PL(9)=##Class(web.DHCEQCommon).TransValueFromPage($p(certificateinfo,"^",2),"date")		//Add By HHM HHM0029 证书效期，直接存在直接存在DHC_EQCertificateInfo不做维护
	s tmpid=""
	&SQL(SELECT CI_RowID INTO:tmpid FROM SQLUSER.DHC_EQCertificateInfo WHERE CI_SourceID=:RowID AND CI_SourceType='4')
	i (PL(9)'="")||(PL(5)'="")
	{
		i (tmpid="")
		{
			s PL(3)=RowID
			&SQL(INSERT INTO SQLUSER.DHC_EQCertificateInfo VALUES:PL())	
			i SQLCODE
			{
				q SQLCODE
			}
		}
		else
		{
			&SQL(UPDATE SQLUSER.DHC_EQCertificateInfo VALUES:PL() WHERE CI_SourceID=:RowID AND CI_SourceType='4')
			i SQLCODE
			{
				q SQLCODE
			}
		}
	}
	else
	{
		i tmpid'=""
		{
			&SQL(DELETE FROM SQLUSER.DHC_EQCertificateInfo WHERE CI_SourceID=:RowID AND CI_SourceType='4')  
			i SQLCODE=100 s SQLCODE=0
			i SQLCODE
			{
				q SQLCODE
			}
		}
	}
	q 0
}

/// MZY0076	2021-05-25
/// w ##Class(web.DHCEQ.EM.BUSMaint).SaveDataNew("{""MTEquip"":""网筐存储架"",""MTPlanName"":""杂（2021-04）"",""MTPlanExecute"":""PE2021030012"",""MTUseLocDR_CTLOCDesc"":""中医科"",""MTMaintUserDR_SSUSRName"":"""",""MTMaintDate"":""2021-04-07"",""MTMaintTypeDR_MTDesc"":"""",""MTMaintModeDR_MMDesc"":"""",""MTServiceDR_SVName"":"""",""MTServiceUsers"":"""",""MTMaintLocDR_CTLOCDesc"":"""",""MTServiceHandler"":"""",""MTServiceTel"":"""",""MTMaintFee"":"""",""ReadOnly"":"""",""MTRowID"":"""",""MTEquipDR"":""124"",""MTUseLocDR"":""214"",""MTMaintLocDR"":"""",""MTMaintUserDR"":"""",""CurDate"":""2021-04-07"",""MTType"":""1"",""MTSourceID"":"""",""MTMaintTypeDR"":"""",""MTMaintModeDR"":"""",""MTNormalFlag"":"""",""MTManageLocDR"":"""",""MTStatus"":"""",""MTMeasureDeptDR"":"""",""MTServiceDR"":"""",""MTMaintPlanDR"":""40"",""PELPlanExecuteDR"":""52"",""MTTotalFee"":"""",""PMRTemplateDR"":"""",""PMRRowID"":"""",""DHCEQTomcatServer"":""https://172.18.18.147:28080/"",""FTPPictureFilePath"":""/DHCEQ/DHCEQAppendFile/"",""MTRemark"":""""}","","78")
ClassMethod SaveDataNew(data, dataList, User As %Library.String = "")
{
	k LPLIST,MTRowID,PMReportDR,PELPlanExecuteDR
	s $ZT="ERRORSaveDataNew"
	
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
	s LPLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQMaint",JsonData,.LPLIST)
	s MTRowID = JsonData.%Get("MTRowID")
	s PMRTemplateDR = JsonData.%Get("PMRTemplateDR")
	s PMReportDR = JsonData.%Get("PMReportDR")
	s PELPlanExecuteDR = JsonData.%Get("PELPlanExecuteDR")
	s MTEquipDR = JsonData.%Get("MTEquipDR")
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i LPLIST(7)="" s LPLIST(7)=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	TStart
    if MTRowID'=""
    {
		&SQL(Update SQLUSER.DHC_EQMaint Values :LPLIST() where MT_RowID = :MTRowID)
		if SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"-90125")
		}
	}
	else
	{
		s LPLIST(14) = 0	;Status
		s LPLIST(16) = User 
		s LPLIST(17) =+$H			
		s LPLIST(18) =$p($H,",",2)	
		s LPLIST(40) = "N" 
		&SQL(insert into SQLUSER.DHC_EQMaint Values :LPLIST())
		s MTRowID=$g(%ROWID)
	}
	if SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"-90126")
	}
	if PMReportDR'=""
    {
		&SQL(Update SQLUSER.DHC_EQPMReport set PMR_TemplateDR=:PMRTemplateDR where PMR_RowID = :PMReportDR)
		if SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"-90127")
		}
	}
	else
	{
		&SQL(insert into SQLUSER.DHC_EQPMReport (PMR_TemplateDR,PMR_MaintDR,PMR_Status,PMR_InvalidFlag) Values (:PMRTemplateDR,:MTRowID,'0','N'))
		s PMReportDR=$g(%ROWID)
	}
	if SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"-90128")
	}
	s SQLCODE=##Class(web.DHCEQ.Process.DHCEQPMReportList).SaveMPReportListNew(PMReportDR,dataList)
	if SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"-90129")
	}
	if PELPlanExecuteDR'=""
    {
		&SQL(update sqluser.DHC_EQPlanExecuteList  SET PEL_MaintDR=:MTRowID where PEL_PlanExecuteDR=:PELPlanExecuteDR and PEL_EquipDR=:MTEquipDR)
		if SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"-90124")
		}
	}
	
	TCommit
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,MTRowID)
ERRORSaveDataNew
	TROLLBACK
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

/// add by czf
/// 获取设备总维护次数
/// w ##class(web.DHCEQ.EM.BUSMaint).GetEQMaintNum("13383","2019-01","2019-12","","")
ClassMethod GetEQMaintNum(EquipDR, StartMonth As %String = "", EndMonth As %String = "", BussType As %String = "", MaintTypeDR As %String = "")
{
	n (EquipDR,StartMonth,EndMonth,BussType,MaintTypeDR)
	n SourceType,vEQRowID,MRRowID,MaintNum,EquipID,rowid,PStartDate,PEndDate
	i StartMonth'="" Set PStartDate=$zdh(StartMonth_"-01",3)
 	e  s PStartDate=0
 	i EndMonth'="" Set PEndDate=##Class(web.DHCEQCommon).DateAddInt("M",1,$zdh(EndMonth_"-01",3))-1
	e  s PEndDate=+$h
	s MaintNum=0
	
	s TBussType=""
	f  s TBussType=$o(^DHCEQMaint(0,"Equip",TBussType))  quit:TBussType=""  d
	.q:(BussType'="")&&(BussType'=TBussType)
	.s EquipID=0
	.f  s EquipID=$o(^DHCEQMaint(0,"Equip",TBussType,EquipID))  quit:EquipID=""  d
	..q:(EquipDR'="")&&(EquipDR'=EquipID)
	..s rowid=0
	..f  s rowid=$o(^DHCEQMaint(0,"Equip",TBussType,EquipID,rowid))  quit:rowid=""  d
	...q:$p($g(^DHCEQMaint(rowid)),"^",39)="Y"
	...q:$p($g(^DHCEQMaint(rowid)),"^",13)'="2"
	...s TMaintTypeDR = $p($g(^DHCEQMaint(rowid)),"^",4)
	...q:(TMaintTypeDR '= MaintTypeDR)&(MaintTypeDR '= "")
	...s TMaintDate=$p($g(^DHCEQMaint(rowid)),"^",5)
	...q:(TMaintDate<PStartDate)||(TMaintDate>PEndDate)
	...s MaintNum=MaintNum+1
	q MaintNum
}

/// add by zc0122 2022-10-12
/// 批量审核维护记录
/// w ##Class(web.DHCEQ.EM.BUSMaint).BatckExecute("10,11",77)
ClassMethod BatckExecute(MaintIDs As %Library.String = "", User As %Library.String = "")
{
	new (MaintIDs,User)
 	k PLIST
 	Set $ZT="ERRORBatckExecute"
	s flag=0
	s SQLCODE=0
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	TStart
	s Length=$l(MaintIDs,",")
	for i=1:1:Length
	{
		q:flag'=0
		s rowid=$p(MaintIDs,",",i)
		i (rowid'="") 
		{
			s PLIST(14) = 2
		 	s PLIST(19) = User
		 	s PLIST(20) = +$H
		 	s PLIST(21) = $P($H,",",2)
		 	&SQL(Update SQLUSER.DHC_EQMaint Values :PLIST() where MT_RowID = :rowid)
		}
		if SQLCODE  
		{	
			TRollBack
			Set flag=SQLCODE 
		}
		s SQLCODE=##class(web.DHCEQ.EM.BUSMaint).InsertEQLifeInfo(rowid,User)
		i SQLCODE
		{
			TROLLBACK
			Set flag=SQLCODE 
		}  
	}
 TCommit
 q flag
ERRORBatckExecute 
	TROLLBACK
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORBatckExecute"_ErrorMsg     //返回错误消息 ;
}

/// add by cjc 20230223
/// 获取保养方式默认值
ClassMethod GetDefaultMaintValue()
{
	s rowid=##class(web.DHCEQCommon).GetSysInfo("503019")
	s Desc=$p($g(^DHCEQCCode("DHCEQMCMaintMode",rowid)),"^",2)
	s Code=$p($g(^DHCEQCCode("DHCEQMCMaintMode",rowid)),"^",1)
	s Data=rowid_"^"_Desc_"^"_Code
	q Data
}

}
