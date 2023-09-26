/// ----------------------------------
/// Add by CSJ 2019-04-19 新规范Web类改造
/// -------------------------------------------------
Class web.DHCEQ.EM.BUSBuyPlan Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Modified by CSJ 2019-10-08 
/// 描述:	采购计划查询Query改造
/// 入参:	RowID 采购计划RowID
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSBuyPlan","BuyPlanList",1)
Query BuyPlanList(RowID As %String = "") As %Query(ROWSPEC = "BPLRow:%String,BPLRowID:%String,BPLSourceTypeDR:%String,BPLSourceType:%String,BPLSourceID:%String,BPLModelDR:%String,BPLModelDR_MDesc:%String,BPLManuFacDR:%String,BPLManuFacDR_MFDesc:%String,BPLPriceFee:%String,BPLQuantityNum:%String,BPLTotalFee:%String,BPLRemark:%String,BPLBuyRequestListDR:%String,BPLExecNum:%String,BPLCurrencyDR:%String,BPLCurrencyDR_CDesc:%String,BPLEquipCatDR:%String,BPLEquipCatDR_ECDesc:%String,BPLArriveNum:%String,BPLItemDR:%String,BPLItemDR_IDesc:%String,BPLArriveDate:%String,BPLHold3:%String,TRefuseFlag:%String,TRefuseReason:%String,BPLContractNum:%String,BPLHold1:%String,BPLHold2:%String,BPLHold4:%String,BPLHold5:%String,BPLName:%String")
{
}

ClassMethod BuyPlanListExecute(ByRef qHandle As %Binary, RowID As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set TRow=0
	Set TotalNum=0
 	Set TotalFee=0
 	
	If RowID'=""
	{
		Set rowid=0
		For  Set rowid=$Order(^DHCEQBuyPlanList(0,"BuyPlan",RowID,rowid))  Quit:rowid=""  Do
		.Do ResetVariablesBuyPlanList
		.Set TRowID = rowid
		.Set TCommonName=$Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",2) 	//2013-06-24 DJ0118
		.Set TModelDR = $Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",3)
		.If TModelDR '="" Set TModel = $Piece($Get(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
		.Set TManuFactoryDR = $Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",4)
		.If TManuFactoryDR '="" Set TManuFactory =##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR) //$Piece($Get(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1)  //modified by CZF0093 2020-03-17
		.Set TPriceFee = ##Class(web.DHCEQCommon).FormatNumber($Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",6),"")
		.Set TQuantityNum = $Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",7)
		.Set TotalNum = TotalNum + TQuantityNum
		.Set TTotalFee = ##Class(web.DHCEQCommon).FormatNumber($Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",8),"")
		.Set TotalFee = TotalFee + TTotalFee
		.Set TRemark = $Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",9)
		.Set TBuyRequestListDR = $Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",10)
		.//start by csj 20190906
		.Set TItemDR = $Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",18)	
		.If TItemDR '="" Set TItem = ##class(web.DHCEQCommon).GetTrakNameByID("masteritem",TItemDR)
		.Set TSourceTypeDR=0
		.Set TSourceID=TItem
		.//end by csj 20190906
		.If TBuyRequestListDR'="" Do
		..Set TSourceTypeDR=1
		..Set BRDR = $Piece($Get(^DHCEQBuyRequestList(TBuyRequestListDR)),"^",1)
		..Set TSourceID = $Piece($Get(^DHCEQBuyRequest(BRDR)),"^",1)
		.Set TSourceType=##class(web.DHCEQ.EM.BUSBuyPlan).GetSourceType(TSourceTypeDR)
		.Set TExecNum = $Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",11)
		.Set TCurrencyDR = $Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",15)
		.If TCurrencyDR'="" Set TCurrency=$Piece($Get(^DHCEQCCode("DHCEQCCurrency",TCurrencyDR)),"^",2)
		.Set TEquipCatDR = $Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",16)
		.If TEquipCatDR'="" Set TEquipCat = $Piece($Get(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)
		.Set TArriveNum = $Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",17)
		.Set TArriveDate = $Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",19)
		.If TArriveDate '="" Set TArriveDate = ##class(web.DHCEQCommon).TransValueToPage(TArriveDate,"date")
		.Set THold3 = $Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",20)
		.Set TRefuseFlag = $Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",21)
		.Set TRefuseReason = $Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",22)
		.Set TContractNum = $Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",23)
		.Set THold1 = $Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",24)
		.Set THold2 = $Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",25)
		.Set THold4 = $Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",26)
		.Set THold5 = $Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",27)
		.Set TRow=TRow+1
		.
		.Do OutputRowBuyPlanList
	}
	
	If TRow=0
	{
		Do ResetVariablesBuyPlanList
		Set TRow=1
		Do OutputRowBuyPlanList
	}
	// 设备台帐查询合计显示方式
	// 0：不显示 1：显示在首行 2：显示在末行  3：显示在其它元素上
#;	Set TotalFlag=##class(web.DHCEQCommon).GetSysInfo("301006")
#;	If (TotalFlag'="")&&(TotalFlag'="0")
#;	{
#;		If TotalFlag="1" Set TotalLoc=1
#;		If TotalFlag="2" Set TotalLoc=index+1
#;		Do ResetVariablesBuyPlanList
#;		Set TRowID=-1
#;		Set TRow="合计:"
#;		Set TQuantityNum=TotalNum
#;		Set TTotalFee=TotalFee
#;		Do OutputRowBuyPlanList
#;	}
	
	Quit $$$OK
OutputRowBuyPlanList
	Set Data=$lb(TRow,TRowID,TSourceTypeDR,TSourceType,TSourceID,TModelDR,TModel,TManuFactoryDR,TManuFactory,TPriceFee,TQuantityNum,TTotalFee,TRemark,TBuyRequestListDR,TExecNum,TCurrencyDR,TCurrency,TEquipCatDR,TEquipCat,TArriveNum,TItemDR,TItem,TArriveDate,THold3,TRefuseFlag,TRefuseReason,TContractNum,THold1,THold2,THold4,THold5,TCommonName)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesBuyPlanList
	Set (TRowID,TSourceTypeDR,TSourceType,TSourceID,TModelDR,TModel,TManuFactoryDR,TManuFactory,TPriceFee,TQuantityNum,TTotalFee,TRemark,TBuyRequestListDR,TExecNum,TCurrencyDR,TCurrency,TEquipCatDR,TEquipCat,TArriveNum,TItemDR,TItem,TArriveDate,THold3,TRefuseFlag,TRefuseReason,TContractNum,THold1,THold2,THold4,THold5,TCommonName)=""
	Quit
}

ClassMethod BuyPlanListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BuyPlanListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
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

ClassMethod BuyPlanListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BuyPlanListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 采购计划单查询
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSBuyPlan","GetBuyPlan","","","","","0","0","","","2019-04-25","0","","N")
Query GetBuyPlan(QXType As %Library.String = "", ApproveRole As %Library.String = "", WaitAD As %Library.String = "", PlanName As %Library.String = "", Type As %Library.String = "", PlanType As %Library.String = "", PlanTypeList As %Library.String = "", StartDate As %Library.String = "", EndDate As %Library.String = "", StatusDR As %Library.String = "", PlanNo As %Library.String = "", InvalidFlag As %Library.String = "N") As %Query(ROWSPEC = "TRowID:%String,TPlanName:%String,TQuantityNum:%String,TTotalFee:%String,TRemark:%String,TPlanDate:%String,TStatus:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TEquipTypeDR:%String,TSubmitUserDR:%String,TSubmitDate:%String,TSubmitTime:%String,TAuditUserDR:%String,TAuditDate:%String,TAuditTime:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TPlanNo:%String,TPlanType:%String,TPlanYear:%String,TPurchaseTypeDR:%String,TRejectReason:%String,TRejectUserDR:%String,TRejectDate:%String,TRejectTime:%String,TUrgencyFlag:%String,TBuyAuditUserDR:%String,TBuyAuditDate:%String,TBuyAuditTime:%String,TBuyRemark:%String,TBuyStatus:%String,THold6:%String,THold7:%String,THold8:%String,TEquipType:%String,TSubmitUser:%String,TAuditUser:%String,TAddUser:%String,TUpdateUser:%String,TPurchaseType:%String,TRejectUser:%String,TBuyAuditUser:%String,TPurposeType:%String,TPurposeTypeDR:%String,TApproveRole:%String,TRow:%String")
{
}

ClassMethod GetBuyPlanExecute(ByRef qHandle As %Binary, QXType, ApproveRole, WaitAD, PlanName, Type, PlanType, PlanTypeList, StartDate, EndDate, StatusDR, PlanNo, InvalidFlag As %Library.String = "N") As %Status
{
 	new repid, index,rowid,CurRole
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set index=1
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("2")
	//Set rowid=0
	//For  Set rowid=$Order(^DHCEQBuyPlan(rowid))  Quit:rowid=""  Do
	
	//2011-07-14 HZY --添加按计划单号查询功能。Bug号：HZY0002
	if PlanNo'="" do
	.Set FindPlanNo=$Order(^DHCEQBuyPlan(0,"PlanNo"," "_PlanNo),-1)
	.For  Set FindPlanNo=$Order(^DHCEQBuyPlan(0,"PlanNo",FindPlanNo))  Quit:((FindPlanNo="")||(FindPlanNo'[PlanNo))  Do
	..Set rowid=0
    ..For  Set rowid=$Order(^DHCEQBuyPlan(0,"PlanNo",FindPlanNo,rowid))  Quit:rowid=""  Do
	...d FillDataGetBuyPlan
	e  do
	.Set rowid=0
	.For  set rowid=$Order(^DHCEQBuyPlan(rowid))  Quit:rowid=""  Do
	..d FillDataGetBuyPlan
	Quit $$$OK
	
FillDataGetBuyPlan	
	Do ResetVariablesGetBuyPlan
	Set TRowID = rowid
	s TInvalidFlag=$p($g(^DHCEQBuyPlan(TRowID)),"^",46) //2011-10-31 DJ DJ0098
	q:(InvalidFlag'="")&&(TInvalidFlag'=InvalidFlag) //2011-10-31 DJ DJ0098
	Quit:(PlanName="")&&(PlanType="")&&(PlanTypeList="")&&(StartDate="")&&(EndDate="")&&(StatusDR="")&&(PlanNo="")	//2011-07-14 HZY 在尾部增加代码&&(PlanNo="")。Bug号：HZY0002
	Set TPlanName = $Piece($Get(^DHCEQBuyPlan(rowid)),"^",1)
	Quit:(PlanName'="")&&(TPlanName'[PlanName)
	Set TQuantityNum = $Piece($Get(^DHCEQBuyPlan(rowid)),"^",2)
	Set TTotalFee = ##Class(web.DHCEQCommon).FormatNumber($Piece($Get(^DHCEQBuyPlan(rowid)),"^",3),"")
	Set TRemark = $Piece($Get(^DHCEQBuyPlan(rowid)),"^",4)
	If StartDate="" Set StartDate=0
	Else  Set StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date") //hisui改造 add by csj 20180613
	If EndDate="" Set EndDate=+$h
	Else  Set EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date") //hisui改造 add by csj 20180613
	Quit:($Piece($Get(^DHCEQBuyPlan(rowid)),"^",5)>EndDate)||($Piece($Get(^DHCEQBuyPlan(rowid)),"^",5)<StartDate)
	Set TPlanDate = ##Class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQBuyPlan(rowid)),"^",5),"date")
	Set TStatus = $Piece($Get(^DHCEQBuyPlan(rowid)),"^",6)
	Quit:(StatusDR'="")&&(StatusDR'=TStatus)
	Quit:((Type'="0")&&(StatusDR=""))&&(TStatus="0")
	Set TStatus=##Class(web.DHCEQCommon).GetEditStatusDisplay(TStatus)
	Set THold1 = $Piece($Get(^DHCEQBuyPlan(rowid)),"^",7)
	Set THold2 = $Piece($Get(^DHCEQBuyPlan(rowid)),"^",8)
	Set THold3 = $Piece($Get(^DHCEQBuyPlan(rowid)),"^",9)
	Set THold4 = $Piece($Get(^DHCEQBuyPlan(rowid)),"^",10)
	Set THold5 = $Piece($Get(^DHCEQBuyPlan(rowid)),"^",11)
	Set TEquipTypeDR = $Piece($Get(^DHCEQBuyPlan(rowid)),"^",12)
	Quit:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR))
	If TEquipTypeDR '="" Set TEquipType = $Piece($Get(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	Set TSubmitUserDR = $Piece($Get(^DHCEQBuyPlan(rowid)),"^",13)
	If TSubmitUserDR '=""  Do
	.Set TSubmitUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TSubmitUserDR)
	Set TSubmitDate = ##Class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQBuyPlan(rowid)),"^",14),"date")
	Set TSubmitTime = $Piece($Get(^DHCEQBuyPlan(rowid)),"^",15)
	Set TAuditUserDR = $Piece($Get(^DHCEQBuyPlan(rowid)),"^",16)
	If TAuditUserDR '=""  Do
	.Set TAuditUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUserDR)
	Set TAuditDate = ##Class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQBuyPlan(rowid)),"^",17),"date")
	Set TAuditTime = $Piece($Get(^DHCEQBuyPlan(rowid)),"^",18)
	Set TAddUserDR = $Piece($Get(^DHCEQBuyPlan(rowid)),"^",19)
	If TAddUserDR '=""  Do
	.Set TAddUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR)
	Set TAddDate = ##Class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQBuyPlan(rowid)),"^",20),"date")
	Set TAddTime = $Piece($Get(^DHCEQBuyPlan(rowid)),"^",21)
	Set TUpdateUserDR = $Piece($Get(^DHCEQBuyPlan(rowid)),"^",22)
	If TUpdateUserDR '=""  Do
	.Set TUpdateUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	Set TUpdateDate = ##Class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQBuyPlan(rowid)),"^",23),"date")
	Set TUpdateTime = $Piece($Get(^DHCEQBuyPlan(rowid)),"^",24)
	Set TPlanNo = $Piece($Get(^DHCEQBuyPlan(rowid)),"^",25)
	Set TPlanType = $Piece($Get(^DHCEQBuyPlan(rowid)),"^",26)
	q:TPlanType="2"		//年度分配计划作废
	Quit:((PlanType'="")&&(PlanType'=TPlanType))
	Set TPlanYear = $Piece($Get(^DHCEQBuyPlan(rowid)),"^",27)
	Set TPurchaseTypeDR = $Piece($Get(^DHCEQBuyPlan(rowid)),"^",28)
	If TPurchaseTypeDR '=""  Do
	.Set TPurchaseType = $Piece($Get(^DHCEQCCode("DHCEQCPurchaseType",TPurchaseTypeDR)),"^",2)
	Set TRejectReason = $Piece($Get(^DHCEQBuyPlan(rowid)),"^",29)
	Set TRejectUserDR = $Piece($Get(^DHCEQBuyPlan(rowid)),"^",30)
	If TRejectUserDR '=""  Do
	.Set TRejectUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TRejectUserDR)
	Set TRejectDate = ##Class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQBuyPlan(rowid)),"^",31),"date")
	Set TRejectTime = $Piece($Get(^DHCEQBuyPlan(rowid)),"^",32)
	Set TUrgencyFlag = $Piece($Get(^DHCEQBuyPlan(rowid)),"^",33)
	Set TBuyAuditUserDR = $Piece($Get(^DHCEQBuyPlan(rowid)),"^",34)
	If TBuyAuditUserDR '=""  Do
	.Set TBuyAuditUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TBuyAuditUserDR)
	Set TBuyAuditDate = ##Class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQBuyPlan(rowid)),"^",35),"date")
	Set TBuyAuditTime = $Piece($Get(^DHCEQBuyPlan(rowid)),"^",36)
	Set TBuyRemark = $Piece($Get(^DHCEQBuyPlan(rowid)),"^",37)
	Set TBuyStatus = $Piece($Get(^DHCEQBuyPlan(rowid)),"^",38)
	Set THold6 = $Piece($Get(^DHCEQBuyPlan(rowid)),"^",39)
	Set THold7 = $Piece($Get(^DHCEQBuyPlan(rowid)),"^",40)
	Set THold8 = $Piece($Get(^DHCEQBuyPlan(rowid)),"^",41)
	Set TPurposeTypeDR = $Piece($Get(^DHCEQBuyPlan(rowid)),"^",42)
	If TPurposeTypeDR '="" Do
	.Set TPurposeType = $Piece($Get(^DHCEQCCode("DHCEQCPurposeType",TPurposeTypeDR)),"^",2)
	Set AIRowID=$Order(^DHCEQApproveInfo(0,"SourceID",ApproveType,rowid,0))
	If AIRowID'="" Do
	.Set CurRole=$Piece(^DHCEQApproveInfo(AIRowID),"^",4)
	.Set TApproveRole=$Piece(^DHCEQApproveInfo(AIRowID),"^",7)
	If TApproveRole'="" Set TApproveRole=##class(web.DHCEQCommon).GetTrakNameByID("role",TApproveRole)	;Mozy0047	2011-3-22
	Quit:((WaitAD="checked")&&(CurRole'=ApproveRole))	;modified by csj 20181113
	Do OutputRowGetBuyPlan
	Quit 
OutputRowGetBuyPlan
	Set TRow=index	// 20150914  Mozy0165 序号
	Set Data=$lb(TRowID,TPlanName,TQuantityNum,TTotalFee,TRemark,TPlanDate,TStatus,THold1,THold2,THold3,THold4,THold5,TEquipTypeDR,TSubmitUserDR,TSubmitDate,TSubmitTime,TAuditUserDR,TAuditDate,TAuditTime,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TPlanNo,TPlanType,TPlanYear,TPurchaseTypeDR,TRejectReason,TRejectUserDR,TRejectDate,TRejectTime,TUrgencyFlag,TBuyAuditUserDR,TBuyAuditDate,TBuyAuditTime,TBuyRemark,TBuyStatus,THold6,THold7,THold8,TEquipType,TSubmitUser,TAuditUser,TAddUser,TUpdateUser,TPurchaseType,TRejectUser,TBuyAuditUser,TPurposeType,TPurposeTypeDR,TApproveRole,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetBuyPlan
	Set (TRowID,TPlanName,TQuantityNum,TTotalFee,TRemark,TPlanDate,TStatus,THold1,THold2,THold3,THold4,THold5,TEquipTypeDR,TSubmitUserDR,TSubmitDate,TSubmitTime,TAuditUserDR,TAuditDate,TAuditTime,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TPlanNo,TPlanType,TPlanYear,TPurchaseTypeDR,TRejectReason,TRejectUserDR,TRejectDate,TRejectTime,TUrgencyFlag,TBuyAuditUserDR,TBuyAuditDate,TBuyAuditTime,TBuyRemark,TBuyStatus,THold6,THold7,THold8,TEquipType,TSubmitUser,TAuditUser,TAddUser,TUpdateUser,TPurchaseType,TRejectUser,TBuyAuditUser,TPurposeType,TPurposeTypeDR,CurRole,TApproveRole,TRow)=""
	Quit
}

ClassMethod GetBuyPlanFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBuyPlanExecute ]
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

ClassMethod GetBuyPlanClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBuyPlanExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Add by CSJ 2019-04-19 采购计划表单明细
/// 入参：	rowid 采购计划rowid
/// w ##class(web.DHCEQ.EM.BUSBuyPlan).GetOneBuyPlan(3)
ClassMethod GetOneBuyPlan(rowid As %Library.String = "")
{
	s $ZT="ERRORGetOneBuyPlan"
	s ObjBuyPlan=##Class(User.DHCEQBuyPlan).%OpenId(rowid)
	s BuyPlanInfo=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjBuyPlan)
	d BuyPlanInfo.%Set("BPQuantityNum",ObjBuyPlan.BPQuantityNum)	//数量无需2位小数
	d BuyPlanInfo.%Set("BPEquipTypeDR_ETDesc",ObjBuyPlan.BPEquipTypeDR.ETDesc)
	d BuyPlanInfo.%Set("BPSubmitUserDR_SUDesc",##Class(web.DHCEQCommon).GetTrakNameByID("user",ObjBuyPlan.BPSubmitUserDR))
	d BuyPlanInfo.%Set("BPAddUserDR_AUDesc",##Class(web.DHCEQCommon).GetTrakNameByID("user",ObjBuyPlan.BPAddUserDR))
	d BuyPlanInfo.%Set("BPUpdateUserDR_UUDesc",##Class(web.DHCEQCommon).GetTrakNameByID("user",ObjBuyPlan.BPUpdateUserDR))
	d BuyPlanInfo.%Set("BPPurchaseTypeDR_PTDesc",ObjBuyPlan.BPPurchaseTypeDR.PTDesc)
	d BuyPlanInfo.%Set("BPRejectUserDR_RUDesc",##Class(web.DHCEQCommon).GetTrakNameByID("user",ObjBuyPlan.BPRejectUserDR))
	d BuyPlanInfo.%Set("BPBuyAuditUserDR_AUDesc",##Class(web.DHCEQCommon).GetTrakNameByID("user",ObjBuyPlan.BPBuyAuditUserDR))
	d BuyPlanInfo.%Set("BPPurposeTypeDR_PTDesc",ObjBuyPlan.BPPurposeTypeDR.PTDesc)
	d BuyPlanInfo.%Set("BPHold1_Desc",##Class(web.DHCEQCommon).GetTrakNameByID("user",ObjBuyPlan.BPHold1))	//add by csj 20191010
	d BuyPlanInfo.%Set("BPHold2_Desc",##Class(web.DHCEQCommon).GetTrakNameByID("user",ObjBuyPlan.BPHold2))	//add by csj 20191010
	d BuyPlanInfo.%Set("BPManageLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjBuyPlan.BPManageLocDR))		//czf 2021-09-02
	
	Set AppInfo=##class(web.DHCEQ.Plat.BUSApprove).GetApproveInfoBySourceID("2",rowid,"",BuyPlanInfo)
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("2")
	Set Opinion=##Class(web.DHCEQ.Plat.BUSApproveList).GetApproveListOpinion(ApproveType, rowid)
	d BuyPlanInfo.%Set("AuditOpinion",Opinion)
	q ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,BuyPlanInfo)
ERRORGetOneBuyPlan
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-9000",ErrorMsg)
}

/// Modified by CSJ 2019-10-08 
/// 描述:新增、更新、删除数据记录
/// w ##class(web.DHCEQ.EM.BUSBuyPlan).UpdateData("{""BPPlanNo"":""JH2019030001"",""BPPlanDate"":""2019-03-13"",""BPPlanName"":""PCR测定仪"",""BPPurchaseTypeDR_PTDesc"":""新购设备"",""BPEquipTypeDR_ETDesc"":""专用设备"",""BPPurposeTypeDR_PTDesc"":""教学"",""BPQuantityNum"":""2.00"",""BPTotalFee"":""4688.00"",""BPRowID"":""5"",""FromLocDR"":"""",""ReciverDR"":"""",""ToLocDR"":"""",""BPStatus"":""0"",""BPEquipTypeDR"":""3"",""BPPurchaseTypeDR"":""1"",""BPPurposeTypeDR"":""2"",""StatCatDR"":"""",""Job"":"""",""BPPlanType"":""0"",""BPHold1"":"""",""BPHold2"":"""",""BPHold3"":"""",""BPHold4"":"""",""BPHold5"":"""",""BPHold6"":"""",""BPHold7"":"""",""BPHold8"":"""",""BPUrgencyFlag"":"""",""BPBuyRemark"":"""",""BPPlanYear"":"""",""QXType"":"""",""Type"":""0"",""flag"":"""",""RoleStep"":""0"",""CurRole"":"""",""NextFlowStep"":"""",""ApproveSetDR"":""1"",""NextRoleDR"":"""",""CancelFlag"":"""",""CancelToFlowDR"":"""",""ApproveStatus"":"""",""ApproveTypeCode"":""14"",""ApproveRoleDR"":"""",""WaitAD"":""off"",""SplitNumCode"":""$CHAR(4)"",""SplitRowCode"":""$CHAR(3)"",""PrintFlag"":""0"",""BPSourceTypeDR"":"""",""BPSourceType"":"""",""BPSourceID"":"""",""EQItemDR"":"""",""BPRemark"":"""",""AuditOpinion"":""提交  侯典顺  2019-04-16 17:01:27\n11  侯典顺  2019-10-08 17:37:23"",""EditOpinion"":""提交"",""RejectReason"":""""}","{""BPLRow"":""1"",""BPLRowID"":""6"",""BPLSourceTypeDR"":""1"",""BPLSourceType"":""采购申请"",""BPLSourceID"":""PCR测定仪"",""BPLModelDR"":""6"",""BPLModelDR_MDesc"":""\\39"",""BPLManuFactoryDR"":""12"",""BPLManuFactoryDR_MFDesc"":""加拿大佳氧系统国际有限公司"",""BPLPriceFee"":""2344.00"",""BPLQuantityNum"":""2"",""BPLTotalFee"":""4688.00"",""BPLRemark"":"""",""BPLBuyRequestListDR"":""7"",""BPLExecNum"":"""",""BPLCurrencyDR"":"""",""BPLCurrencyDR_CDesc"":"""",""BPLEquipCatDR"":"""",""BPLEquipCatDR_ECDesc"":"""",""BPLArriveNum"":"""",""BPLItemDR"":""15"",""BPLItemDR_IDesc"":""PCR测定仪"",""BPLArriveDate"":""2019-03-28"",""BPLHold3"":"""",""TRefuseFlag"":""N"",""TRefuseReason"":"""",""BPLContractNum"":"""",""BPLHold1"":"""",""BPLHold2"":"""",""BPLHold4"":"""",""BPLHold5"":"""",""BPLCommonName"":""PCR测定仪""}","")
ClassMethod UpdateData(val As %Library.String = "", list As %Library.String = "", DelRowid As %Library.String = "", User As %String = "")
{
	Kill PLIST,LIST,rowid,Rowid
	Set $ZT="ERRORUpdateData"
	Set updDate=+$H
 	Set updTime=$Piece($H,",",2)
 	i User="" Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(val)
	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQBuyPlan",JsonData,.PLIST)
	s rowid = JsonData.BPRowID
	Set BPRowID=rowid
	Set PLIST(47)="N" //InvalidFlag //2011-10-31 DJ DJ0098
	i rowid'="" //2011-10-31 DJ DJ0098
	{
		s InvalidFlag=$p($g(^DHCEQBuyPlan(rowid)),"^",46)
		i InvalidFlag="Y" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1015","无效单据")
	}
	TStart
	If (rowid="")  //新增按钮操作
	{
	 	Set PLIST(7)=	0		// BP_Status	7
	 	Set PLIST(20)=	User	// BP_AddUserDR	20
		Set PLIST(21)=	updDate	// BP_AddDate	21
		Set PLIST(22)=	updTime	// BP_AddTime	22
	 	Set PLIST(26)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQBuyPlan",$h,"",JsonData.BPEquipTypeDR)	// Mozy	2016-10-21
	 	Set PLIST(40)=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))		// BP_ManageLocDR	Mozy0243	2020-01-11	1174785	设置管理部门
	 	&SQL(Insert Into SQLUSER.DHC_EQBuyPlan Values :PLIST())
	 }
	 Else  //更新按钮操作
	 {
	 	Set PLIST(23)=	User	// BP_UpdateUserDR	23
		Set PLIST(24)=	updDate	// BP_UpdateDate	24
		Set PLIST(25)=	updTime	// BP_UpdateTime	25
		&SQL(Update SQLUSER.DHC_EQBuyPlan Values :PLIST() where BP_RowID = :BPRowID)
	}
	If SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"错误信息:"_$g(%msg))
	}
	Set rowid=$Get(%ROWID)
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")
	Set Length=$Length(list,SplitRowCode)
	For i=1:1:Length  q:SQLCODE'=0  d
	.K LIST
	.Set valList= $Piece(list,SplitRowCode,i)
	.s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
	.s LIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQBuyPlanList",JsonData,.LIST)
	.s BPLRowid = JsonData.BPLRowID
	.Set LIST(2)=rowid						//	BPL_BuyPlanDR
	.Set LIST(6)="N"							//	BPL_TestFlag
	.Set LIST(13)=	User					//	BPL_UpdateUserDR
	.Set LIST(14)=	updDate					//	BPL_UpdateDate
	.Set LIST(15)=	updTime					//	BPL_UpdateTime
	.Set LIST(22)="N"						//  BPL_RefuseFlag
	.s BuyRequestListID=JsonData.BPLBuyRequestListDR
	.i BuyRequestListID'=""  d
	..s IdleQty=..CheckBuyRequestList(BuyRequestListID, rowid)
	..s QuantityNum=JsonData.BPLQuantityNum
	..;该采购申请明细已经被其它计划单使用!
	..i IdleQty<QuantityNum s SQLCODE=-1030	//modifeid by csj 2019-10-16 采用新消息
	.q:SQLCODE'=0
	.///modified by ZY 20211014 推荐型号信息只有在新增的时候带过来，更新时在采购申请变化时重写
	.If (BPLRowid="")  d
	..&SQL(Insert Into SQLUSER.DHC_EQBuyPlanList Values :LIST())
	..Set BPLRowid=$Get(%ROWID)
	..i BuyRequestListID'=""  d
	...&sql(Insert Into SQLUser.DHC_EQIFBList (IFBL_SourceType,IFBL_SourceID,IFBL_Vendor,IFBL_VendorDR,IFBL_Manufactory,IFBL_ManufactoryDR,IFBL_Model,IFBL_ModelDR,IFBL_Brand,IFBL_BrandDR,IFBL_Arg,IFBL_Price,IFBL_Amount,IFBL_WinFlag,IFBL_WinQty,IFBL_Candidacy,IFBL_CandidacySeq,IFBL_Score,IFBL_Remark,IFBL_ProviderHandler,IFBL_ProviderTel,IFBL_Configure,IFBL_Features,IFBL_DealPrice,IFBL_MaterialAndPrice,IFBL_Quanlity,IFBL_GuaranteePeriodNum,IFBL_ArriveNum,IFBL_Hold1,IFBL_Hold2,IFBL_Hold3,IFBL_Hold4,IFBL_Hold5) select '2',:BPLRowid,IFBL_Vendor,IFBL_VendorDR,IFBL_Manufactory,IFBL_ManufactoryDR,IFBL_Model,IFBL_ModelDR,IFBL_Brand,IFBL_BrandDR,IFBL_Arg,IFBL_Price,IFBL_Amount,IFBL_WinFlag,IFBL_WinQty,IFBL_Candidacy,IFBL_CandidacySeq,IFBL_Score,IFBL_Remark,IFBL_ProviderHandler,IFBL_ProviderTel,IFBL_Configure,IFBL_Features,IFBL_DealPrice,IFBL_MaterialAndPrice,IFBL_Quanlity,IFBL_GuaranteePeriodNum,IFBL_ArriveNum,IFBL_Hold1,IFBL_Hold2,IFBL_Hold3,IFBL_Hold4,IFBL_Hold5 from SQLUser.DHC_EQIFBList where IFBL_SourceType='1' and IFBL_SourceID=:BuyRequestListID) 
	.Else  d
	..s OldBuyRequestListID=$Piece($Get(^DHCEQBuyPlanList(BPLRowid)),"^",10)
	..&SQL(Update SQLUSER.DHC_EQBuyPlanList Values :LIST() where BPL_RowID = :BPLRowid)
	..If SQLCODE=100 Set SQLCODE=0
	..i (BuyRequestListID="")&&(BuyRequestListID'=OldBuyRequestListID) d
	...&SQL(delete from SQLUser.DHC_EQIFBList where IFBL_SourceType='2' and IFBL_SourceID = :BPLRowid)
	...If SQLCODE=100 Set SQLCODE=0
	...&sql(Insert Into SQLUser.DHC_EQIFBList (IFBL_SourceType,IFBL_SourceID,IFBL_Vendor,IFBL_VendorDR,IFBL_Manufactory,IFBL_ManufactoryDR,IFBL_Model,IFBL_ModelDR,IFBL_Brand,IFBL_BrandDR,IFBL_Arg,IFBL_Price,IFBL_Amount,IFBL_WinFlag,IFBL_WinQty,IFBL_Candidacy,IFBL_CandidacySeq,IFBL_Score,IFBL_Remark,IFBL_ProviderHandler,IFBL_ProviderTel,IFBL_Configure,IFBL_Features,IFBL_DealPrice,IFBL_MaterialAndPrice,IFBL_Quanlity,IFBL_GuaranteePeriodNum,IFBL_ArriveNum,IFBL_Hold1,IFBL_Hold2,IFBL_Hold3,IFBL_Hold4,IFBL_Hold5) select '2',:BPLRowid,IFBL_Vendor,IFBL_VendorDR,IFBL_Manufactory,IFBL_ManufactoryDR,IFBL_Model,IFBL_ModelDR,IFBL_Brand,IFBL_BrandDR,IFBL_Arg,IFBL_Price,IFBL_Amount,IFBL_WinFlag,IFBL_WinQty,IFBL_Candidacy,IFBL_CandidacySeq,IFBL_Score,IFBL_Remark,IFBL_ProviderHandler,IFBL_ProviderTel,IFBL_Configure,IFBL_Features,IFBL_DealPrice,IFBL_MaterialAndPrice,IFBL_Quanlity,IFBL_GuaranteePeriodNum,IFBL_ArriveNum,IFBL_Hold1,IFBL_Hold2,IFBL_Hold3,IFBL_Hold4,IFBL_Hold5 from SQLUser.DHC_EQIFBList where IFBL_SourceType='1' and IFBL_SourceID=:BuyRequestListID) 
	.If SQLCODE=100 Set SQLCODE=0  
	.q:SQLCODE'=0
	
	;add by csj 20191127 回写主表数量金额
#;	&SQL(Select sum(BPL_QuantityNum) into:TotalNum  from SQLUSER.DHC_EQBuyPlanList where BPL_BuyPlanDR = :BPRowID)
#;	&SQL(Select sum(BPL_PriceFee) into:TotalFee from SQLUSER.DHC_EQBuyPlanList where BPL_BuyPlanDR = :BPRowID)
#;	&SQL(Update SQLUSER.DHC_EQBuyPlan Set BP_QuantityNum=:TotalNum,BP_TotalFee =:TotalFee where BP_RowID = :BPRowID)
	If SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"错误信息:"_$g(%msg))
	}
	Set SQLCODE=##Class(web.DHCEQ.EM.BUSBuyPlan).DeleteBPList(DelRowid)		;删除明细
	If SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
    ///add by ZY 20220906  2685957
    ;更新采购计划单价、金额、数量
    Set SQLCODE=##class(web.DHCEQBuyPlanList).UpdateBuyPlan("","",rowid,1)
    If SQLCODE
    {
        If TransFlag'="N" TROLLBACK
        Quit SQLCODE
    }
        
	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,rowid)

ERRORUpdateData 
	TRollBack	
	Set ErrorMsg=$ZE	     			//得到系统返回的错误消息
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// Modified by CSJ 2019-10-15 返回值改为Json字符串输出
/// 描述:删除
/// w ##Class(web.DHCEQ.EM.BUSBuyPlan).SubmitData("2")
ClassMethod DeleteData(rowid, User As %String = "")
{
	TStart
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	&SQL(Update SQLUSER.DHC_EQBuyPlan Set BP_CancelUser=:User,BP_CancelDate=:Date,BP_CancelTime=:Time,BP_InvalidFlag='Y' Where BP_RowID=:rowid)
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	} //2011-10-31 DJ DJ0098 end
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
}

/// 创建:Mozy 2011-3-18
/// 描述:删除采购计划明细
/// w ##Class(web.DHCEQIFB).DeleteBPList(",0,0,0")
ClassMethod DeleteBPList(DelRowIDs)
{
	new Length,BPLRowID,Flag,i
	If DelRowIDs="" Quit 0
	
	Set Flag=0
	Set Length=$Length(DelRowIDs,",")
	for i=1:1:Length
	{
		Quit:Flag'=0
		Set BPLRowID=$Piece(DelRowIDs,",",i)
		If (BPLRowID>0)
		{
			&SQL(delete from sqluser.DHC_EQBuyPlanList where BPL_RowID=:BPLRowID)
			If SQLCODE Set Flag=SQLCODE
		}
	}
	Quit Flag
}

/// Modified by CSJ 2019-10-15 返回值改为Json字符串输出
/// 描述:提交
/// w ##Class(web.DHCEQ.EM.BUSBuyPlan).SubmitData("2^1^")
ClassMethod SubmitData(val)
{
	New BrlDR,PriceFee,MaxPrice
	Kill PLIST
	Set RowID=$Piece(val,"^",1)
	Quit:RowID="" ""
	i RowID'="" //2011-10-31 DJ DJ0098
	{
		s InvalidFlag=$p($g(^DHCEQBuyPlan(RowID)),"^",46)
		i InvalidFlag="Y" q -1015
	}
	s Status=$Piece($G(^DHCEQBuyPlan(RowID)),"^",6)
	if Status'="0" q -2015   //该记录状态不符合,不能执行操作!
	
	///add by ZY0209 判断设备项信息填写情况
	i ##Class(web.DHCEQ.Con.BUSContract).CheckMasterItem("92",RowID)=0 Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1002","'设备项'信息为空!")	//modified by csj 2020-04-08 通用名改为 设备项
	Set $ZT="ERRORSubmitData"
	Set User=$Piece(val,"^",2)
	Set updDate=+$H
 	Set updTime=$Piece($H,",",2)
 	
 	Set EquipType=$Piece($Get(^DHCEQBuyPlan(RowID)),"^",12)
	Set PurchaseType=$Piece($Get(^DHCEQBuyPlan(RowID)),"^",28)
	Set MaxPrice=0
	Set BplDR=0
	For  Set BplDR=$Order(^DHCEQBuyPlanList(0,"BuyPlan",RowID,BplDR)) Quit:BplDR=""  Do
	.Set PriceFee=+$Piece($Get(^DHCEQBuyPlanList(BplDR)),"^",6)
	.If PriceFee>MaxPrice Set MaxPrice=PriceFee
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("2")
	// ApproveType, EquipType, PurchaseType, SpecialType, MaxFee, YearFlag, ApproveCondition
	Set ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipType, PurchaseType, "", MaxPrice, "N", "")
	If ApproveSet="" Quit -4007
	Set ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, 0, "")
	Set AutoAuditFlag=$Piece(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	Set LastFlag=$Piece(ApproveFlow,"^",1)
	Set NextStep=$Piece(ApproveFlow,"^",2)
	Set NextRole=$Piece(ApproveFlow,"^",3)
	
	Set AppInfoStatus="1"			;Status
	
	Set AuditFlag=0
	If (AutoAuditFlag="Y")&&(NextStep="") 
	{
		Set AppInfoStatus="2"
		Set AuditFlag=1
		Set PLIST(17)=	User	// BP_AuditUserDR
		Set PLIST(18)=	updDate	// BP_AuditDate
		Set PLIST(19)=	updTime	// BP_AuditTime
	}
	Set ApproveInfoID=$Order(^DHCEQApproveInfo(0,"SourceID",ApproveType,RowID,0))
	
	TSTART
	Set SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,RowID,"2",User)		//Modify DJ 2016-04-05
	If SQLCODE
	{
		TROLLBACK
	 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,"","",AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	Set PLIST(7)=	AppInfoStatus		// BP_Status
 	Set PLIST(14)=	User	// BP_SubmitUserDR
	Set PLIST(15)=	updDate	// BP_SubmitDate
	Set PLIST(16)=	updTime	// BP_SubmitTime
	&SQL(Update SQLUSER.DHC_EQBuyPlan Values :PLIST() where BP_RowID=:RowID)
	if SQLCODE
	{
	 	TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	;最后一步,需要调用审核方法
	If AuditFlag=1
	{
		Set SQLCODE=##Class(web.DHCEQ.EM.BUSBuyPlan).LastAuditAction(RowID)
		If SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}		
	}
	Set SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("92", RowID, User, ApproveFlow_"^"_ApproveSet, "N", "", AuditFlag)
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
	
ERRORSubmitData 
	TRollBack	
	Set ErrorMsg=$ZE	     			//得到系统返回的错误消息
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)     //返回错误消息
}

/// Modified by CSJ 2019-10-15 返回值改为Json字符串输出
/// 描述:取消提交
/// w ##Class(web.DHCEQIFB).CancelSubmitData("8^1^")
ClassMethod CancelSubmitData(val As %Library.String = "", CurRole As %Library.String = "")
{
	Set RowID=$Piece(val,"^",1)
	Quit:RowID="" ""
	
	Set $ZT="ERRORCancelSubmitData"
	Set User=$Piece(val,"^",2)
	Set updDate=+$H
 	Set updTime=$Piece($H,",",2)
	Set CancelToFlowDR=$Piece(val,"^",3)
	Set RejectReason=$Piece(val,"^",5)
	
	;获取取消到上一步的信息
	Set Status="0"
	Set ApproveRoleDR=""
	Set Step=""
	Set ApproveFlow=""
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("2")
	//2015-10-08 ZY0146   取消提交的拒绝原因也写在DHC_EQApproveList表中。表增加一个审批标记:统一/拒绝 
	Set ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("2", RowID)
	Set RoleStep=##class(web.DHCEQCApproveSet).GetStepByRole(ApproveSet,CurRole)
	If (CancelToFlowDR'="")
	{
		Set ApproveRoleDR=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",2)
		Set Step=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",3)
		Set Status="1"
		Set ApproveFlow="N^"_Step_"^"_ApproveRoleDR_"^"_$Piece(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR),"^",7,11)
	}
	else
	{
		s ApproveFlow="^^^^^^^^"_ApproveSet	//Add By MZY 需求: 283957	20161111
	}
	TSTART

	;生成审批记录
	Set SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,RejectReason,"",CurRole,RoleStep,User,"1")
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,ApproveRoleDR,Step,"","",Status,"Y")
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	Set PLIST(7)=	Status	// BP_Status
	// BP_RejectReason
	//Set PLIST(30)=	RejectReason	;_"  "_##class(web.DHCEQCommon).GetTrakNameByID("user",User)_"  "_$ZD(updDate,3)	;取消人及取消日期
	//Set PLIST(31)=	User	// BP_RejectUserDR
	//Set PLIST(32)=	updDate	// BP_RejectDate
	//Set PLIST(33)=	updTime	// BP_RejectTime
	&sql(Update SQLUSER.DHC_EQBuyPlan Values :PLIST() where BP_RowID=:RowID)
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	Set SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("92", RowID, User, ApproveFlow_"^"_ApproveSet, "Y", CurRole)
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
ERRORCancelSubmitData 
	TRollBack	
	Set ErrorMsg=$ZE	     				//得到系统返回的错误消息
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)   //返回错误消息
}

/// Modified by CSJ 2019-10-15 返回值改为Json字符串输出
/// 描述:审核
/// w ##Class(web.DHCEQ.EM.BUSBuyPlan).AuditData("35^71^1^ty^","4","2","DHC_EQBuyPlan&^11111,138")
ClassMethod AuditData(val As %Library.String = "", CurRole As %Library.String = "", RoleStep As %Library.String = "", editFieldsInfo As %Library.String = "")
{
	Set RowID=$Piece(val,"^",1)
	Quit:RowID="" ""
	///add by CSJ 2020-04-08 判断设备项信息填写情况
	i ##Class(web.DHCEQ.Con.BUSContract).CheckMasterItem("92",RowID)=0 Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1002","'设备项'信息为空!")

	s Status=$Piece($G(^DHCEQBuyPlan(RowID)),"^",6)
	if Status'="1" q -2015   //该记录状态不符合,不能执行操作!
	
	Set $ZT="ERRORAuditData"
	Set User=$Piece(val,"^",2)
	Set updDate=+$H
 	Set updTime=$Piece($H,",",2)
 	Set Opinion=$Piece(val,"^",4)
	Set Remark=$Piece(val,"^",5)
	
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("2")
	Set ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("2", RowID)	
	If ApproveSet="" Quit -4007	
	Set ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, RoleStep, CurRole)
	
	Set AutoAuditFlag=$Piece(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	Set LastFlag=$Piece(ApproveFlow,"^",1)
	Set NextStep=$Piece(ApproveFlow,"^",2)
	Set NextRole=$Piece(ApproveFlow,"^",3)
	
	Set AppInfoStatus="1"	;Status	
	
	TSTART
	Set AuditFlag=0
	If ((NextStep="")||(LastFlag="Y"))
	{
		Set AuditFlag=1
		Set PLIST(7)=	2		// BP_Status
		Set PLIST(17)=	User	// BP_AuditUserDR
		Set PLIST(18)=	updDate	// BP_AuditDate
		Set PLIST(19)=	updTime	// BP_AuditTime
		&sql(Update SQLUSER.DHC_EQBuyPlan Values :PLIST() where BP_RowID=:RowID)
		If SQLCODE
		{
		 	TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		Set AppInfoStatus="2"	;Status
	}
	
	;生成审批记录
	Set SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,Opinion,Remark,CurRole,RoleStep)
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	
	;记录单据当前审批状态
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,RoleStep,CurRole,AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	
	;编辑要修改的字段
	If editFieldsInfo'=""
	{
		Set SQLCODE=##Class(web.DHCEQApprove).EditRoleReqFields(editFieldsInfo)
		If SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	
	;执行当前角色要执行的动作
	Set Actions=##Class(web.DHCEQCApproveAction).GetApproveActions(ApproveSet, RoleStep, CurRole)
	If Actions'=""
	{
		Set SQLCODE=##Class(web.DHCEQCApproveAction).DoActions(RowID,User,Actions)
		If SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	
	;最后一步,需要调用审核方法
	If AuditFlag=1
	{
		Set SQLCODE=##Class(web.DHCEQ.EM.BUSBuyPlan).LastAuditAction(RowID)
		If SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	Set SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("92", RowID, User, ApproveFlow_"^"_ApproveSet, "N", CurRole, AuditFlag)
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	TCOMMIT
	
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
ERRORAuditData 
	TRollBack	
	Set ErrorMsg=$ZE	     			//得到系统返回的错误消息
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)	//返回错误消息
}

/// 描述：最终审核时需调用此方法,执行审核中需要处理的数据在此处,需调用
/// w ##Class(web.DHCEQ.EM.BUSBuyPlan).LastAuditAction(5)
ClassMethod LastAuditAction(RowID)
{
	/*/ 采购申请审核后是否自动生成计划
	Set CreatePlanFlag=##class(web.DHCEQCommon).GetSysInfo("101002")
	If (CreatePlanFlag="1")		;&&(PLIST(17)="2")&&(YearFlag="N")
	{
		Set SQLCODE=##Class(web.DHCEQ.EM.BUSBuyPlan).CreatePlan(RowID_"^"_User,"N")
	}*/
	Quit 0	;SQLCODE
}

/// 描述：来源方式
ClassMethod GetSourceType(Type)
{
	Quit $CASE(Type,"0":"设备项","1":"采购申请",:"")
}

/// Modified by JDL 2011-04-25
/// 调整检索采购申请的顺序
/// ----------------------------
/// Mozy	2011-3-24
/// 采购计划明细获取采购申请明细项数据
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSBuyPlan","GetBuyRequestListByItem","","")
Query GetBuyRequestListByItem(BPDR As %String = "", Name As %String = "") As %Query(ROWSPEC = "TName:%String,Hidden:%String,Hidden:%String,TPrjName:%String,Hidden:%String,TModel:%String,Hidden:%String,TManuFac:%String,TPriceFee:%String,TQuantityNum:%String,Hidden:%String,Hidden:%String,TUnit:%String,TEquipCatDR:%String,TEquipCat:%String,TRequestLoc:%String,TUseLoc:%String,TCommonName:%String")
{
}

ClassMethod GetBuyRequestListByItemExecute(ByRef qHandle As %Binary, BPDR As %String = "", Name As %String = "") As %Status
{
	new repid, index, rowid, BPLDR
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	
	s TBuyRequestDR=0
	For  Set TBuyRequestDR=$Order(^DHCEQBuyRequestList(0,"BuyRequest",TBuyRequestDR))  Quit:TBuyRequestDR=""  Do
	.Set TStatus=$Piece($Get(^DHCEQBuyRequest(TBuyRequestDR)),"^",16)
	.Quit:TStatus'=2
	.Set TPrjName=$Piece($Get(^DHCEQBuyRequest(TBuyRequestDR)),"^",1)
	.
	.Set rowid=0
	.For  Set rowid=$Order(^DHCEQBuyRequestList(0,"BuyRequest",TBuyRequestDR,rowid))  Quit:rowid=""  Do
	..Do ResetVariablesGetBuyRequestListByItem
	..Set TRowID = rowid
	..
	..Set TQuantityNum=..CheckBuyRequestList(TRowID,BPDR)
	..Quit:TQuantityNum<1
	..
	..Set TCommonName=$Piece($Get(^DHCEQBuyRequestList(TRowID)),"^",2) //2013-06-24 DJ0118
	..Quit:(Name'="")&&(TCommonName'[Name)
	..Set TModelDR=$Piece($Get(^DHCEQBuyRequestList(TRowID)),"^",3)
	..If TModelDR'="" Set TModel=$Piece($Get(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	..Set TManuFacDR=$Piece($Get(^DHCEQBuyRequestList(TRowID)),"^",4)
	..If TManuFacDR'="" Set TManuFac=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFacDR)	//$Piece($Get(^DHCEQCCode("DHCEQCManufacturer",TManuFacDR)),"^",1)	//modified by CZF0093 2020-03-18
	..Set TPriceFee=$Piece($Get(^DHCEQBuyRequestList(TRowID)),"^",6)
	..Set TItemDR=$Piece($Get(^DHCEQBuyRequestList(TRowID)),"^",17)
	..If TItemDR'="" Set TUnitDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",7)
	..If TUnitDR'="" Set TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	..;2013-06-24 DJ0118
	..i TItemDR'="" s TEquipCatDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",4)
	..i TEquipCatDR'="" s TEquipCat=$Piece($Get(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)
	..s TRequestLoc=$p($g(^DHCEQBuyRequest(TBuyRequestDR)),"^",2)
	..s TUseLoc=$p($g(^DHCEQBuyRequest(TBuyRequestDR)),"^",4)
	..i TRequestLoc'="" s TRequestLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TRequestLoc)
	..i TUseLoc'="" s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLoc)
	..i TItemDR'="" s TName=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1)
	..Do OutputRowGetBuyRequestListByItem
	Quit $$$OK
OutputRowGetBuyRequestListByItem
	Set Data=$lb(TName,TRowID,TBuyRequestDR,TPrjName,TModelDR,TModel,TManuFacDR,TManuFac,TPriceFee,TQuantityNum,TItemDR,TUnitDR,TUnit,TEquipCatDR,TEquipCat,TRequestLoc,TUseLoc,TCommonName)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetBuyRequestListByItem
	Set (TName,TRowID,TModelDR,TModel,TManuFacDR,TManuFac,TPriceFee,TQuantityNum,TItemDR,TUnitDR,TUnit,TEquipCatDR,TEquipCat,TRequestLoc,TUseLoc,TCommonName)=""
	Quit
}

ClassMethod GetBuyRequestListByItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBuyRequestListByItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
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

ClassMethod GetBuyRequestListByItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBuyRequestListByItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Modified by jdl 2011-04-27
/// 根据条件检索获取可用的计划明细
/// 入参：
/// 	Name:检索的计划项目或设备名称
/// 	BussType:用到计划明细的业务， 1:招标 2:合同 3:验收
/// 	BussID:业务单ID
/// 返回:该业务单据可以选择的计划明细以及其数量
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSBuyPlan","GetBuyPlanList","","")
Query GetBuyPlanList(Name As %String = "", BussType As %String = "", BussID As %String = "") As %Query(ROWSPEC = "hidden:%String,TBPLName:%String,hidden:%String,TBPName:%String,hidden:%String,TModel:%String,hidden:%String,TManuFac:%String,TPriceFee:%String,TQuantityNum,TTotalFee:%String,hidden:%String,hidden:%String,TUnit:%String,TRequestLoc:%String,TUseLoc:%String,TCommonName:%String")
{
}

ClassMethod GetBuyPlanListExecute(ByRef qHandle As %Binary, Name As %String = "", BussType As %String = "", BussID As %String = "") As %Status
{
	new repid, index, rowid, BPLDR
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set rowid=0
	For  Set rowid=$Order(^DHCEQBuyPlanList(rowid))  Quit:rowid=""  Do
	.Do ResetVariablesGetBuyPlanList
	.Set TRowID = rowid
	.Set TBPDR=$Piece($Get(^DHCEQBuyPlanList(rowid)),"^",1)
	.;招标、合同、验收中,仅能使用状态为审核的计划明细
	.Quit:(BussType'="")&&($p($g(^DHCEQBuyPlan(TBPDR)),"^",6)'=2)
	.q:$p($g(^DHCEQBuyPlan(TBPDR)),"^",6)'=2
	.
	.if TBPDR'="" Set TBPName=$Piece($Get(^DHCEQBuyPlan(TBPDR)),"^",1)
	.Set TCommonName=$Piece($Get(^DHCEQBuyPlanList(rowid)),"^",2)	//2013-06-24 DJ0118
	.quit:(Name'="")&&(TCommonName'[Name)	//2013-06-24 DJ0118
	.Set TModelDR=$Piece($Get(^DHCEQBuyPlanList(rowid)),"^",3)
	.If TModelDR'="" Set TModel=$Piece($Get(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.Set TManuFacDR=$Piece($Get(^DHCEQBuyPlanList(rowid)),"^",4)
	.If TManuFacDR'="" Set TManuFac=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFacDR)	//$Piece($Get(^DHCEQCCode("DHCEQCManufacturer",TManuFacDR)),"^",1)	//modified by CZF0093
	.Set TPriceFee=$Piece($Get(^DHCEQBuyPlanList(rowid)),"^",6)
	.Set TQuantityNum=$Piece($Get(^DHCEQBuyPlanList(rowid)),"^",7)
	.;业务为招标时,检索其他招标中已经使用该计划明细的数量
	.;业务为合同时,如果该计划明细已有对应招标记录，则合同可用数应减去招标占用数，合同应从招标处选取数据。
	.i ((BussType=1)||(BussType=2))  d
	..Set BussListID=0
	..For  Set BussListID=$Order(^DHCEQIFBBag(0,"Extend",2,TRowID,BussListID)) Quit:BussListID=""  Do
	...Quit:((BussType=1)&&($Piece($Get(^DHCEQIFBBag(BussListID)),"^",1)=BussID))
	...Set TQuantityNum=TQuantityNum-$Piece($Get(^DHCEQIFBBag(BussListID)),"^",5)
	.;业务为招标时,除上面减去其它招标中已经占用的计划明细数量外，还需要减去合同来自计划的明细数量
	.;业务为合同时,除上面减去招标中已经使用该计划明细的数量，再减去其他合同中使用的计划明细数量
	.;Modify DJ 2017-08-04
	.i ((BussType=1)||(BussType=2))  d
	..Set BussListID=0
	..For  Set BussListID=$Order(^DHCEQContractList(0,"SourceID",1,TRowID,BussListID))  Quit:BussListID=""  Do
	...Quit:((BussType=2)&&($Piece($Get(^DHCEQContractList(BussListID)),"^",1)=BussID))
	...Set TQuantityNum=TQuantityNum-$Piece($Get(^DHCEQContractList(BussListID)),"^",7)
	.
	.Quit:TQuantityNum<1
	.
	.Set TTotalFee=TQuantityNum*TPriceFee
	.Set TItemDR=$Piece($Get(^DHCEQBuyPlanList(rowid)),"^",18)
	.If TItemDR'="" Set TUnitDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",7)
	.If TUnitDR'="" Set TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	.;2013-06-24 DJ0118
	.i TItemDR'="" s TBPLName=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1)
	.s BRLDR=$p($g(^DHCEQBuyPlanList(rowid)),"^",10)
	.i BRLDR'=""  d
	..s BRDR=$p($g(^DHCEQBuyRequestList(BRLDR)),"^",1)
	..s TRequestLoc=$p($g(^DHCEQBuyRequest(BRDR)),"^",2)
	..s TUseLoc=$p($g(^DHCEQBuyRequest(BRDR)),"^",4)
	..i TRequestLoc'="" s TRequestLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TRequestLoc)
	..i TUseLoc'="" s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLoc)
	.Do OutputRowGetBuyPlanList
	Quit $$$OK
OutputRowGetBuyPlanList
	Set Data=$lb(TRowID,TBPLName,TBPDR,TBPName,TModelDR,TModel,TManuFacDR,TManuFac,TPriceFee,TQuantityNum,TTotalFee,TItemDR,TUnitDR,TUnit,TRequestLoc,TUseLoc,TCommonName)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetBuyPlanList
	Set (TRowID,TBPLName,TBPDR,TBPName,TModelDR,TModel,TManuFacDR,TManuFac,TPriceFee,TQuantityNum,TTotalFee,TItemDR,TUnitDR,TUnit,TRequestLoc,TUseLoc,TCommonName)=""
	Quit
}

ClassMethod GetBuyPlanListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBuyPlanListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
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

ClassMethod GetBuyPlanListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBuyPlanListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Add by jdl 2011-04-26
/// Modified by CSJ 2020-04-20 添加计划明细ID、是否明细标志参数，控制可选采购申请来源剩余数量 需求号：1278375
/// 检测该申请明细在指定的计划单中 是否 可以使用
/// 入参：BuyRequestListID:采购申请明细ID
/// 	  BuyPlanID：采购计划单的ID
///       BPLRowID:计划明细ID
/// 	  ListFlag:是否明细标志 
/// 返回：其他计划单占用该采购申请明细申请数量后，剩余的申请数量，
/// w ##class(web.DHCEQ.EM.BUSBuyPlan).CheckBuyRequestList(16,"")
ClassMethod CheckBuyRequestList(BuyRequestListID, BuyPlanID, BPLRowID As %String = "", ListFlag As %String = "")
{
	n BuyPlanListID,IdleQty
	n (BuyRequestListID, BuyPlanID, BPLRowID,ListFlag)
	i BuyRequestListID="" q 0
	s IdleQty=$p($g(^DHCEQBuyRequestList(BuyRequestListID)),"^",7)
	i IdleQty<1 q 0
	
	s BuyPlanListID=0
	f  s BuyPlanListID=$o(^DHCEQBuyPlanList(0,"BuyRequestList",BuyRequestListID,BuyPlanListID)) q:BuyPlanListID=""  d
	.;自身计划单上的不计入
	.s BPRowID=$p($g(^DHCEQBuyPlanList(BuyPlanListID)),"^",1)	//2013-07-02 DJ0119 begin
	.q:(BuyPlanID=BPRowID)&&(ListFlag="")	//modified by csj 2020-04-20 明细标志则自身计划单同样计入
	.q:(BPLRowID'="")&&(BPLRowID=BuyPlanListID) //add by csj 2020-04-20 自身明细不计入
	.q:($p($g(^DHCEQBuyPlan(BPRowID)),"^",46)="Y")	//2013-07-02 DJ0119 end
	.s IdleQty=IdleQty-$p($g(^DHCEQBuyPlanList(BuyPlanListID)),"^",7)
	i IdleQty<1 q 0
	q IdleQty
}

/// Add by CSJ 2019-04-19
/// 描述:采购计划明细来源类型
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSBuyPlan","GetBPSourceType")
Query GetBPSourceType() As %Query(ROWSPEC = "TDesc:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod GetBPSourceTypeExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
 	s index=1
	;CustomValue="0^设备项&2^采购计划"
	s rowid=0
	s Code="01"
	s Desc="设备项"
	d OutputRowGetBPSourceType
	s rowid=1
	s Code="02"
	s Desc="采购申请"
	d OutputRowGetBPSourceType
	Quit $$$OK
OutputRowGetBPSourceType
	Set Data=$lb(Desc,rowid,Code)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetBPSourceTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetExtendTypeExecute ]
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

ClassMethod GetBPSourceTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetExtendTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Add by CSJ 2019-04-19 
/// 描述：采购计划明细来源
/// Modified by CSJ 2019-05-31 添加类组过滤、设备分类输出列
/// Modified by CSJ 2020-04-20 添加计划明细ID、是否明细标志参数，用于控制可选采购申请来源剩余数量 需求号：1278375
/// 入参：	SourceType 采购计划来源 
/// 		SourceTypeDesc  来源名称
/// 		BPRowID 采购计划RowID
/// 		EquipType 类组
///       	BPLRowID:计划明细ID
/// 	  	ListFlag:是否明细标志 
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSBuyPlan","GetBPSource",1,"","23","4","23")
Query GetBPSource(SourceType As %String = "", SourceTypeDesc As %String = "", BPRowID As %String = "", EquipType As %String = "", BPLRowID As %String = "", ListFlag As %String = "") As %Query(ROWSPEC = "TSourceID:%String,TItemDR:%String,TName:%String,TModelDR:%String,TModel:%String,TManuFcDR:%String,TManuFac:%String,TPriceFee:%String,TQuantityNum:%String,TTotalFee:%String,TNo:%String,TUnit:%String,TUnitDR:%String,TPrjName:%String,TBuyRequestListDR:%String,TEquipCat:%String,TEquipCatDR:%String")
{
}

ClassMethod GetBPSourceExecute(ByRef qHandle As %Binary, SourceType As %String = "", SourceTypeDesc As %String = "", BPRowID As %String = "", EquipType As %String = "", BPLRowID As %String = "", ListFlag As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	if SourceType=0
	{
		;0设备项
		s Hospital=##Class(web.DHCEQCommon).GetHospital()
		i Hospital'=""
		{
			s TEquipTypeDR=0
			f  s TEquipTypeDR=$o(^DHCEQCCode("DHCEQCMasterItem",0,"Hospital",Hospital,TEquipTypeDR)) quit:TEquipTypeDR=""  d
			.q:(EquipType'="")&&(EquipType'=TEquipTypeDR)	//add by csj 20190530
			.q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)'=0
			.s rowid=0
			.f  s rowid=$o(^DHCEQCCode("DHCEQCMasterItem",0,"Hospital",Hospital,TEquipTypeDR,rowid)) quit:rowid=""  d
			..d BuildDataGetItem
		}
		else
		{
			s TEquipTypeDR=0
			f  s TEquipTypeDR=$o(^DHCEQCCode("DHCEQCMasterItem",0,"EquipType",TEquipTypeDR)) quit:TEquipTypeDR=""  d
			.q:(EquipType'="")&&(EquipType'=TEquipTypeDR)	//add by csj 20190530
			.q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)'=0
			.s rowid=0
			.f  s rowid=$o(^DHCEQCCode("DHCEQCMasterItem",0,"EquipType",TEquipTypeDR,rowid)) quit:rowid=""  d
			..d BuildDataGetItem
		}
		}
	elseif SourceType=1
	{
		;1:采购申请
		s rowid=0
		f  s rowid=$Order(^DHCEQBuyRequestList(rowid))  q:rowid=""  d
		.d ResetGetBPSource
		.s TSourceID = rowid
		.s TBuyRequestListDR=TSourceID
		.s TBuyRequestDR=$Piece($Get(^DHCEQBuyRequestList(rowid)),"^",1)
		.Set TQuantityNum=..CheckBuyRequestList(rowid,BPRowID,BPLRowID,ListFlag)	//modified by csj 2020-04-20
		.Quit:TQuantityNum<1	//add by csj 20190419
		.s Status=$Piece($Get(^DHCEQBuyRequest(TBuyRequestDR)),"^",16)
		.q:Status'=2  
		.s TPrjName=$Piece($Get(^DHCEQBuyRequest(TBuyRequestDR)),"^",1)
		.s TCommonName=$Piece($Get(^DHCEQBuyRequestList(rowid)),"^",2) 
		.q:(SourceTypeDesc'="")&&(TCommonName'[SourceTypeDesc) 
		.s TModelDR=$Piece($Get(^DHCEQBuyRequestList(rowid)),"^",3)
	.///modified by ZY 20220913  修改取值 和推荐产品型号信息的显示规则
        .Set TModel=##class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
        .s TManuFacDR=$Piece($Get(^DHCEQBuyRequestList(rowid)),"^",4)
        .Set TManuFac=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFacDR)
        .
        .s FisrtRowID=$Order(^DHCEQIFBList(0,"Source",1,TSourceID,0))
        .i ((TModel="")&&(FisrtRowID'=""))  d
        ..s TManuFac=$Piece($Get(^DHCEQIFBList(FisrtRowID)),"^",5)
        ..s TManuFacDR=$Piece($Get(^DHCEQIFBList(FisrtRowID)),"^",6)
        ..s TModelDR=$Piece($Get(^DHCEQIFBList(FisrtRowID)),"^",8)
        ..s TModel=$Piece($Get(^DHCEQIFBList(FisrtRowID)),"^",7)
        .
		.s TPriceFee=$Piece($Get(^DHCEQBuyRequestList(rowid)),"^",6)
		.;s TQuantityNum=$Piece($Get(^DHCEQBuyRequestList(rowid)),"^",7)
		.s TTotalFee=TQuantityNum*TPriceFee
		.s TItemDR=$Piece($Get(^DHCEQBuyRequestList(rowid)),"^",17)
		.i TItemDR'="" Set TUnitDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",7)
		.i TUnitDR'="" Set TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
		.s TName=$Piece($Get(^DHCEQBuyRequestList(rowid)),"^",2) //yh add 1158917 现采购申请不一定有设备项 20200302
		.i TItemDR'="" s TName=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1) //2013-06-24 DJ0118			
		.s TEquipTypeDR=$Piece($Get(^DHCEQBuyRequest(TBuyRequestDR)),"^",25)		//modify by yh 1158917 现采购申请不一定有设备项 20200302
		.i TItemDR'="" d
		..s TEquipTypeDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",3) //add by csj 20190530 
		..s TEquipCatDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",4) //add by csj 20190531
		..s TEquipCat=##class(web.DHCEQCommon).GetTrakNameByID("equipcat",TEquipCatDR)	//add by csj 20190531
		.q:(EquipType'="")&&(EquipType'=TEquipTypeDR)	//add by csj 20190530
		.s TRequestLoc=$p($g(^DHCEQBuyRequest(TBuyRequestDR)),"^",2)
		.s TUseLoc=$p($g(^DHCEQBuyRequest(TBuyRequestDR)),"^",4)
		.i TRequestLoc'="" s TRequestLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TRequestLoc)
		.i TUseLoc'="" s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLoc)
		.d OutputRowGetBPSource
	}
	Quit $$$OK
OutputRowGetBPSource
	s TPriceFee=##Class(web.DHCEQCommon).FormatNumber(TPriceFee,"")
	s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"")
	s Data=$lb(TSourceID,TItemDR,TName,TModelDR,TModel,TManuFacDR,TManuFac,TPriceFee,TQuantityNum,TTotalFee,TNo,TUnit,TUnitDR,TPrjName,TBuyRequestListDR,TEquipCat,TEquipCatDR)	//modified by csj 20190531
 	s ^CacheTemp(repid,index)=Data
	s index=index+1
	quit
ResetGetBPSource
	s (TSourceID,TItemDR,TName,TModelDR,TModel,TManuFacDR,TManuFac,TPriceFee,TQuantityNum,TTotalFee,TNo,TUnit,TUnitDR,TPrjName,TBuyRequestListDR,TEquipCatDR,TEquipCat)=""	//modified by csj 20190531
	Quit
BuildDataGetItem
	d ResetGetBPSource
	s TSourceID = rowid
	s TItemDR = rowid
	s TFlag = $p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",8)
	q:TFlag="Y"
	s TName = $p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",1)
	s TPrjName=TName	//add by csj 20190906
	s TNo=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",2)
	q:(SourceTypeDesc'="")&&($ZCONVERT(TName ,"U")'[$ZCONVERT(SourceTypeDesc,"U"))
	
	s TUnitDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",7)
	s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	
	;Quit:(##Class(web.DHCEQCommon).CheckManageLimit("","","",TEquipTypeDR,TStatCatDR,TCatDR,"","",rowid)) 
	q:($p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",12)="Y")
	s TEquipCatDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",4) //add by csj 20190531
	s TEquipCat=##class(web.DHCEQCommon).GetTrakNameByID("equipcat",TEquipCatDR)	//add by csj 20190531
	;s THold2=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",11)
	;i THold2'="" s THold2Desc=$P($g(^CT("HOSP",THold2)),"^",2)
	d OutputRowGetBPSource
	
	Quit
}

ClassMethod GetBPSourceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBPSourceExecute ]
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

ClassMethod GetBPSourceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBPSourceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by csj 20191127 回写主表数量金额触发器
/// 入参：BPRowID 计划单ID
/// w ##class(web.DHCEQ.EM.BUSBuyPlan).AfterUpdateBPList(16)
ClassMethod AfterUpdateBPList(BPRowID)
{
	&SQL(Select sum(BPL_QuantityNum) into:TotalNum  from SQLUSER.DHC_EQBuyPlanList where BPL_BuyPlanDR = :BPRowID)
	&SQL(Select sum(BPL_PriceFee) into:TotalFee from SQLUSER.DHC_EQBuyPlanList where BPL_BuyPlanDR = :BPRowID)
	&SQL(Update SQLUSER.DHC_EQBuyPlan Set BP_QuantityNum=:TotalNum,BP_TotalFee =:TotalFee where BP_RowID = :BPRowID)
}

}
