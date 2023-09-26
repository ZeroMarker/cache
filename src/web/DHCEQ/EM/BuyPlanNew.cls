Class web.DHCEQ.EM.BuyPlanNew Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Mozy	2011-3-13
/// 采购计划查询
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BuyPlanNew","BuyPlanList","1")
Query BuyPlanList(RowID As %String = "") As %Query(ROWSPEC = "TRow:%String,TRowID:%String,TSourceTypeDR:%String,TSourceType:%String,TSourceID:%String,TModelDR:%String,TModel:%String,TManuFactoryDR:%String,TManuFactory:%String,TPriceFee:%String,TQuantityNum:%String,TTotalFee:%String,TRemark:%String,TBuyRequestListDR:%String,TExecNum:%String,TCurrencyDR:%String,TCurrency:%String,TEquipCatDR:%String,TEquipCat:%String,TArriveNum:%String,TItemDR:%String,TItem:%String,TArriveDate:%String,THold3:%String,TRefuseFlag:%String,TRefuseReason:%String,TContractNum:%String,THold1:%String,THold2:%String,THold4:%String,THold5:%String,TCommonName:%String")
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
		.If TManuFactoryDR '="" Set TManuFactory = $Piece($Get(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1)
		.Set TPriceFee = ##Class(web.DHCEQCommon).FormatNumber($Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",6),"")
		.Set TQuantityNum = $Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",7)
		.Set TotalNum = TotalNum + TQuantityNum
		.Set TTotalFee = ##Class(web.DHCEQCommon).FormatNumber($Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",8),"")
		.Set TotalFee = TotalFee + TTotalFee
		.Set TRemark = $Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",9)
		.Set TBuyRequestListDR = $Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",10)
		.Set TSourceTypeDR=0
		.If TBuyRequestListDR'="" Do
		..Set TSourceTypeDR=1
		..Set BRDR = $Piece($Get(^DHCEQBuyRequestList(TBuyRequestListDR)),"^",1)
		..;Set TSourceID = $Piece($Get(^DHCEQBuyRequest(BRDR)),"^",1)  //add by zx 2019-09-11
		.Set TSourceType=##class(web.DHCEQ.EM.BuyPlanNew).GetSourceType(TSourceTypeDR)
		.Set TExecNum = $Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",11)
		.Set TCurrencyDR = $Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",15)
		.If TCurrencyDR'="" Set TCurrency=$Piece($Get(^DHCEQCCode("DHCEQCCurrency",TCurrencyDR)),"^",2)
		.Set TEquipCatDR = $Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",16)
		.If TEquipCatDR'="" Set TEquipCat = $Piece($Get(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)
		.Set TArriveNum = $Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",17)
		.Set TItemDR = $Piece($Get(^DHCEQBuyPlanList(TRowID)),"^",18)
		.If TItemDR '="" Set TItem = ##class(web.DHCEQCommon).GetTrakNameByID("masteritem",TItemDR)
		.Set TSourceID = TCommonName //add by zx 2019-09-11
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
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BuyPlanNew","GetBuyPlan","","","","","0","0","","","2019-04-25","0","","N")
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

/// w ##class(web.DHCEQ.EM.BuyPlanNew).GetOneBuyPlan(3)
ClassMethod GetOneBuyPlan(rowid As %Library.String = "")
{
	new result,resultex
	Set (result,resultex)=""
	Set result= ^DHCEQBuyPlan(rowid)
	Set $Piece(result,"^",3)=##Class(web.DHCEQCommon).FormatNumber($Piece(result,"^",3),"")
	Set $Piece(result,"^",5)=##Class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",5),"date")	;PlanDate
	Set $Piece(result,"^",11)=##Class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",11),"date")	;BuyAuditDate
	Set resultex=resultex_"^"	;EquipTypeDR
	If $Piece(result,"^",12)'=""  Do
	.Set resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQCEquipType",$Piece(result,"^",12))),"^",2)
	Set resultex=resultex_"^"	;SubmitUserDR
	If $Piece(result,"^",13)'=""  Do
	.Set resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$Piece(result,"^",13))
	Set $Piece(result,"^",14)=##Class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",14),"date")	;SubmitDate
	Set resultex=resultex_"^"	;AuditUserDR
	If $Piece(result,"^",16)'=""  Do
	.Set resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$Piece(result,"^",16))
	Set $Piece(result,"^",17)=##Class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",17),"date")	;AuditDate
	Set resultex=resultex_"^"	;AddUserDR
	If $Piece(result,"^",19)'=""  Do
	.Set resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$Piece(result,"^",19))
	Set $Piece(result,"^",20)=##Class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",20),"date")	;AddDate
	Set resultex=resultex_"^"	;UpdateUserDR
	If $Piece(result,"^",22)'=""  Do
	.Set resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$Piece(result,"^",22))
	Set $Piece(result,"^",23)=##Class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",23),"date")	;UpdateDate
	Set resultex=resultex_"^"	;PurchaseTypeDR
	If $Piece(result,"^",28)'=""  Do
	.Set resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQCPurchaseType",$Piece(result,"^",28))),"^",2)
	Set resultex=resultex_"^"	;RejectUserDR
	If $Piece(result,"^",30)'=""  Do
	.Set resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$Piece(result,"^",30))
	Set $Piece(result,"^",31)=##Class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",31),"date")	;RejectDate
	Set $Piece(result,"^",33)=##Class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",33),"bool")	;UrgencyFlag
	Set resultex=resultex_"^"	;BuyAuditUserDR
	If $Piece(result,"^",34)'=""  Do
	.Set resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$Piece(result,"^",34))
	Set $Piece(result,"^",35)=##Class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",35),"date")	;BuyAuditDate
	Set resultex=resultex_"^"	;PurposeTypeDR
	If $Piece(result,"^",42)'=""  Do
	.Set resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQCPurposeType",$Piece(result,"^",42))),"^",2)
	
	Set AppInfo=##class(web.DHCEQApprove).GetApproveInfoBySourceID("2",rowid)
	Set resultex=resultex_"^"_AppInfo
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("2")
	Set Opinion=##Class(web.DHCEQApproveList).GetApproveListOpinion(ApproveType, rowid)
	Set resultex=resultex_"^"_Opinion
	
	//add by zx 2019-09-11
	Set resultex=resultex_"^"	;BuyUserDR
	If $Piece(result,"^",7)'=""  Do
	.Set resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$Piece(result,"^",7))
	
	Set result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	
	Quit rowid_"^"_result_resultex
}

/// 创建:Mozy 2011-3-14
/// 描述:新增、更新、删除数据记录
/// w ##class(web.DHCEQ.EM.BuyPlanNew).UpdateData("","","机构名称1^代理资质1^地址1^电话1^传真1^联系人1^^","1^2^3^4^5","2")
/// w ##class(web.DHCEQ.EM.BuyPlanNew).UpdateData("2^^^","","3","")
ClassMethod UpdateData(val As %Library.String = "", list As %Library.String = "", DelRowid As %Library.String = "")
{
	Kill PLIST,LIST,rowid,Rowid
	Set $ZT="ERRORUpdateData"
	Set updDate=+$H
 	Set updTime=$Piece($H,",",2)
 	Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set rowid=$Piece(val,"^",1)
	Set BPRowID=rowid
	Set PLIST(2)=$Piece(val,"^",2)	//	BP_PlanName	2
	Set PLIST(3)=$Piece(val,"^",3)	//	BP_QuantityNum	3
	Set PLIST(4)=$Piece(val,"^",4)	//	BP_TotalFee	4
	Set PLIST(5)=$Piece(val,"^",5)	//	BP_Remark	5
	Set PLIST(6)=$Piece(val,"^",6)	//	BP_PlanDate	6
	If PLIST(6)'="" Set PLIST(6)= ##Class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",6),"date")
	Set PLIST(8)=$Piece(val,"^",7)	//	BP_Hold1	8
	Set PLIST(9)=$Piece(val,"^",8)	//	BP_Hold2	9
	Set PLIST(10)=$Piece(val,"^",9)	//	BP_Hold3	10
	If PLIST(10)'="" Set PLIST(10)= ##Class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",9),"date")
	Set PLIST(11)=$Piece(val,"^",10)	//	BP_Hold4	11
	Set PLIST(12)=$Piece(val,"^",11)	//	BP_Hold5	12
	If PLIST(12)'="" Set PLIST(12)= ##Class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",11),"date")
	Set PLIST(13)=$Piece(val,"^",12)	//	BP_EquipTypeDR	13
	Set PLIST(27)=$Piece(val,"^",13)	//	BP_PlanType	27
	Set PLIST(28)=$Piece(val,"^",14)	//	BP_PlanYear	28
	Set PLIST(29)=$Piece(val,"^",15)	//	BP_PurchaseTypeDR	29
	Set PLIST(34)=$Piece(val,"^",16)	//	BP_UrgencyFlag	34
	If PLIST(34)'="" Set PLIST(34) = ##Class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",16),"bool")
	Set PLIST(38)=$Piece(val,"^",17)	//	BP_BuyRemark	38
	Set PLIST(39)=$Piece(val,"^",18)	//	BP_BuyStatus	39
	Set PLIST(40)=$Piece(val,"^",19)	//	BP_Hold6	40
	Set PLIST(41)=$Piece(val,"^",20)	//	BP_Hold7	41
	Set PLIST(42)=$Piece(val,"^",21)	//	BP_Hold8	42
	Set PLIST(43)=$Piece(val,"^",22)	//	BP_PurposeTypeDR	43
	Set PLIST(47)="N" //InvalidFlag //2011-10-31 DJ DJ0098
	i rowid'="" //2011-10-31 DJ DJ0098
	{
		s InvalidFlag=$p($g(^DHCEQBuyPlan(rowid)),"^",46)
		i InvalidFlag="Y" q "^无效单据"
	}
	TStart
	If (rowid="")  //新增按钮操作
	{
	 	Set PLIST(7)=	0		// BP_Status	7
	 	Set PLIST(20)=	User	// BP_AddUserDR	20
		Set PLIST(21)=	updDate	// BP_AddDate	21
		Set PLIST(22)=	updTime	// BP_AddTime	22
	 	Set PLIST(26)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQBuyPlan",$h,"",$Piece(val,"^",12))	// Mozy	2016-10-21
	 	
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
		Quit rowid_"^"_SQLCODE
	}
	Set rowid=$Get(%ROWID)
		
	Set Length=$Length(list,"&")
	For i=1:1:Length  q:SQLCODE'=0  d
	.Set valList= $Piece(list,"&",i)
	.	
	.// 设备采购计划明细表
	.Set BPLRowid=$Piece(valList,"^",1)
	.Set LIST(2)=rowid						//	BPL_BuyPlanDR
	.Set LIST(3)=$Piece(valList,"^",22)		//	BPL_Name  2013-06-24 DJ0118
	.Set LIST(4)=$Piece(valList,"^",3)		//	BPL_ModelDR
	.Set LIST(5)=$Piece(valList,"^",4)		//	BPL_ManuFacDR
	.Set LIST(6)="N"							//	BPL_TestFlag
	.Set LIST(7)=$Piece(valList,"^",6)		//	BPL_PriceFee
	.Set LIST(8)=$Piece(valList,"^",7)		//	BPL_QuantityNum
	.Set LIST(9)=$Piece(valList,"^",8)		//	BPL_TotalFee
	.Set LIST(10)=$Piece(valList,"^",9)		//	BPL_Remark
	.Set LIST(11)=$Piece(valList,"^",10)		//	BPL_BuyRequestListDR
	.Set LIST(12)=$Piece(valList,"^",11)		//	BPL_ExecNum
	.Set LIST(13)=	User					//	BPL_UpdateUserDR
	.Set LIST(14)=	updDate					//	BPL_UpdateDate
	.Set LIST(15)=	updTime					//	BPL_UpdateTime
	.Set LIST(16)=$Piece(valList,"^",12)		//	BPL_CurrencyDR
	.Set LIST(17)=$Piece(valList,"^",13)		//	BPL_EquipCatDR
	.Set LIST(18)=$Piece(valList,"^",14)		//	BPL_ArriveNum
	.Set LIST(19)=$Piece(valList,"^",15)		//	BPL_ItemDR
	.Set LIST(20)=$Piece(valList,"^",16)		//	BPL_ArriveDate
	.If LIST(20)'="" Set LIST(20) = ##Class(web.DHCEQCommon).TransValueFromPage($Piece(valList,"^",16),"date")
	.Set LIST(21)=$Piece(valList,"^",17)		//	BPL_Hold3
	.Set LIST(22)="N"						//  BPL_RefuseFlag
	.;Set LIST(23)=							//	BPL_RefuseReason
	.;Set LIST(24)=							//	BPL_ContractNum
	.Set LIST(25)=$Piece(valList,"^",18)		//	BPL_Hold1
	.Set LIST(26)=$Piece(valList,"^",19)		//	BPL_Hold2
	.Set LIST(27)=$Piece(valList,"^",20)		//	BPL_Hold4
	.Set LIST(28)=$Piece(valList,"^",21)		//	BPL_Hold5
	.
	.
	.s BuyRequestListID=$Piece(valList,"^",10)
	.i BuyRequestListID'=""  d
	..s IdleQty=..CheckBuyRequestList(BuyRequestListID, rowid)
	..s QuantityNum=$Piece(valList,"^",7)
	..;该采购申请明细已经被其它计划单使用!
	..i IdleQty<QuantityNum d
	...s SQLCODE=-1001
	.q:SQLCODE'=0
	.If (BPLRowid="")  d
	..&SQL(Insert Into SQLUSER.DHC_EQBuyPlanList Values :LIST())
	.Else  d
	..&SQL(Update SQLUSER.DHC_EQBuyPlanList Values :LIST() where BPL_RowID = :BPLRowid)
	
	If SQLCODE
	{
		TROLLBACK
		Quit rowid_"^"_SQLCODE
	}
	Set SQLCODE=##Class(web.DHCEQ.EM.BuyPlanNew).DeleteBPList(DelRowid)		;删除明细
	If SQLCODE
	{
		TROLLBACK
		Quit rowid_"^"_SQLCODE
	}
	 	
	TCOMMIT
	Quit rowid_"^"_SQLCODE

ERRORUpdateData 
	TRollBack	
	Set ErrorMsg=$ZE	     			//得到系统返回的错误消息
 	Quit "ERRORUpdateData"_ErrorMsg     //返回错误消息
}

/// 创建:Mozy 2011-3-17
/// 描述:删除
/// w ##Class(web.DHCEQ.EM.BuyPlanNew).SubmitData("2")
ClassMethod DeleteData(rowid)
{
	TStart
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID")) //2011-10-31 DJ DJ0098 begin
	s Date=+$H
	s Time=$P($H,",",2)
	&SQL(Update SQLUSER.DHC_EQBuyPlan Set BP_CancelUser=:User,BP_CancelDate=:Date,BP_CancelTime=:Time,BP_InvalidFlag='Y' Where BP_RowID=:rowid)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	} //2011-10-31 DJ DJ0098 end
	TCOMMIT
	Quit SQLCODE
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

/// 创建:Mozy 2011-3-16
/// 描述:提交
/// w ##Class(web.DHCEQ.EM.BuyPlanNew).SubmitData("2^1^")
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
	//modified by ZY0197 增加管理科室的条件限制
	s ApproveCondition="ManageLocDR,DHCEQBuyPlan,"_$Piece(^DHCEQBuyPlan(RowID),"^",39)
	Set ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipType, PurchaseType, "", MaxPrice, "N", ApproveCondition)
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
	 	Quit SQLCODE
	}
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,"","",AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	Set PLIST(7)=	AppInfoStatus		// BP_Status
 	Set PLIST(14)=	User	// BP_SubmitUserDR
	Set PLIST(15)=	updDate	// BP_SubmitDate
	Set PLIST(16)=	updTime	// BP_SubmitTime
	&SQL(Update SQLUSER.DHC_EQBuyPlan Values :PLIST() where BP_RowID=:RowID)
	if SQLCODE
	{
	 	TROLLBACK
		Quit SQLCODE
	}
	;最后一步,需要调用审核方法
	If AuditFlag=1
	{
		Set SQLCODE=##Class(web.DHCEQ.EM.BuyPlanNew).LastAuditAction(RowID)
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}		
	}
	Set SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("92", RowID, User, ApproveFlow_"^"_ApproveSet, "N", "", AuditFlag)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	TCOMMIT
	Quit RowID
	
ERRORSubmitData 
	TRollBack	
	Set ErrorMsg=$ZE	     			//得到系统返回的错误消息
 	Quit "ERRORSubmitData"_ErrorMsg     //返回错误消息
}

/// 创建:Mozy 2011-3-18
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
		Quit SQLCODE
	}
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,ApproveRoleDR,Step,"","",Status,"Y")
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
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
		Quit SQLCODE
	}
	Set SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("92", RowID, User, ApproveFlow_"^"_ApproveSet, "Y", CurRole)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	TCOMMIT
	Quit RowID
ERRORCancelSubmitData 
	TRollBack	
	Set ErrorMsg=$ZE	     				//得到系统返回的错误消息
 	Quit "ERRORCancelSubmitData"_ErrorMsg   //返回错误消息
}

/// 创建:Mozy 2011-3-18
/// 描述:审核
/// w ##Class(web.DHCEQ.EM.BuyPlanNew).AuditData("1^1^126","10","3","")
ClassMethod AuditData(val As %Library.String = "", CurRole As %Library.String = "", RoleStep As %Library.String = "", editFieldsInfo As %Library.String = "")
{
	Set RowID=$Piece(val,"^",1)
	Quit:RowID="" ""
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
			Quit SQLCODE
		}
		Set AppInfoStatus="2"	;Status
	}
	
	;生成审批记录
	Set SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,Opinion,Remark,CurRole,RoleStep)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	
	;记录单据当前审批状态
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,RoleStep,CurRole,AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	
	;编辑要修改的字段
	If editFieldsInfo'=""
	{
		Set SQLCODE=##Class(web.DHCEQApprove).EditRoleReqFields(editFieldsInfo)
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
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
			Quit SQLCODE
		}
	}
	
	;最后一步,需要调用审核方法
	If AuditFlag=1
	{
		Set SQLCODE=##Class(web.DHCEQ.EM.BuyPlanNew).LastAuditAction(RowID)
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
	}
	Set SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("92", RowID, User, ApproveFlow_"^"_ApproveSet, "N", CurRole, AuditFlag)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	TCOMMIT
	
	Quit RowID
ERRORAuditData 
	TRollBack	
	Set ErrorMsg=$ZE	     			//得到系统返回的错误消息
 	Quit "ERRORAuditData"_ErrorMsg		//返回错误消息
}

/// 描述：最终审核时需调用此方法,执行审核中需要处理的数据在此处,需调用
/// w ##Class(web.DHCEQ.EM.BuyPlanNew).LastAuditAction(5)
ClassMethod LastAuditAction(RowID)
{
	/*/ 采购申请审核后是否自动生成计划
	Set CreatePlanFlag=##class(web.DHCEQCommon).GetSysInfo("101002")
	If (CreatePlanFlag="1")		;&&(PLIST(17)="2")&&(YearFlag="N")
	{
		Set SQLCODE=##Class(web.DHCEQ.EM.BuyPlanNew).CreatePlan(RowID_"^"_User,"N")
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
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BuyPlanNew","GetBuyRequestListByItem","","")
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
	..If TManuFacDR'="" Set TManuFac=$Piece($Get(^DHCEQCCode("DHCEQCManufacturer",TManuFacDR)),"^",1)
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
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BuyPlanNew","GetBuyPlanList","","")
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
	.If TManuFacDR'="" Set TManuFac=$Piece($Get(^DHCEQCCode("DHCEQCManufacturer",TManuFacDR)),"^",1)
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
/// 检测该申请明细在指定的计划单中 是否 可以使用
/// 入参：BuyRequestListID:采购申请明细ID
/// 		 BuyPlanID：采购计划单的ID
/// 返回：其他计划单占用该采购申请明细申请数量后，剩余的申请数量，
ClassMethod CheckBuyRequestList(BuyRequestListID, BuyPlanID)
{
	n BuyPlanListID,IdleQty
	
	i BuyRequestListID="" q 0
	s IdleQty=$p($g(^DHCEQBuyRequestList(BuyRequestListID)),"^",7)
	i IdleQty<1 q 0
	
	s BuyPlanListID=0
	f  s BuyPlanListID=$o(^DHCEQBuyPlanList(0,"BuyRequestList",BuyRequestListID,BuyPlanListID)) q:BuyPlanListID=""  d
	.;自身计划单上的不计入
	.s BPRowID=$p($g(^DHCEQBuyPlanList(BuyPlanListID)),"^",1)	//2013-07-02 DJ0119 begin
	.q:BuyPlanID=BPRowID
	.q:($p($g(^DHCEQBuyPlan(BPRowID)),"^",46)="Y")	//2013-07-02 DJ0119 end
	.s IdleQty=IdleQty-$p($g(^DHCEQBuyPlanList(BuyPlanListID)),"^",7)
	i IdleQty<1 q 0
	q IdleQty
}

/// add by csj 20190419
/// Description:采购计划明细来源类型
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BuyPlanNew","GetBPSourceType")
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

/// add by csj 20190419 采购计划明细来源
/// modified by csj 20190531 添加类组过滤、设备分类输出列
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BuyPlanNew","GetBPSourceID",1,"","","3")
Query GetBPSourceID(SourceType As %String = "", SourceTypeDesc As %String = "", SourceID As %String = "", EquipType As %String = "") As %Query(ROWSPEC = "TSourceID:%String,TItemDR:%String,TName:%String,TModelDR:%String,TModel:%String,TManuFcDR:%String,TManuFac:%String,TPriceFee:%String,TQuantityNum:%String,TTotalFee:%String,TNo:%String,TUnit:%String,TUnitDR:%String,TPrjName:%String,TBuyRequestListDR:%String,TEquipCat:%String,TEquipCatDR:%String")
{
}

ClassMethod GetBPSourceIDExecute(ByRef qHandle As %Binary, SourceType As %String = "", SourceTypeDesc As %String = "", SourceID As %String = "", EquipType As %String = "") As %Status
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
		.q:(SourceID'="")&&(SourceID'=rowid)
		.d ResetGetBPSourceID
		.s TSourceID = rowid
		.s TBuyRequestListDR=TSourceID
		.s TBuyRequestDR=$Piece($Get(^DHCEQBuyRequestList(rowid)),"^",1)
		.Set TQuantityNum=..CheckBuyRequestList(rowid,SourceID)	//add by csj 20190419
		.Quit:TQuantityNum<1	//add by csj 20190419
		.s Status=$Piece($Get(^DHCEQBuyRequest(TBuyRequestDR)),"^",16)
		.q:Status'=2  
		.s TPrjName=$Piece($Get(^DHCEQBuyRequest(TBuyRequestDR)),"^",1)
		.s TCommonName=$Piece($Get(^DHCEQBuyRequestList(rowid)),"^",2) 
		.q:(SourceTypeDesc'="")&&(TCommonName'[SourceTypeDesc) 
		.s TModelDR=$Piece($Get(^DHCEQBuyRequestList(rowid)),"^",3)
		.i TModelDR'="" Set TModel=$Piece($Get(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
		.s TManuFacDR=$Piece($Get(^DHCEQBuyRequestList(rowid)),"^",4)
		.i TManuFacDR'="" Set TManuFac=$Piece($Get(^DHCEQCCode("DHCEQCManufacturer",TManuFacDR)),"^",1)
		.s TPriceFee=$Piece($Get(^DHCEQBuyRequestList(rowid)),"^",6)
		.s TQuantityNum=$Piece($Get(^DHCEQBuyRequestList(rowid)),"^",7)
		.s TTotalFee=TQuantityNum*TPriceFee
		.s TItemDR=$Piece($Get(^DHCEQBuyRequestList(rowid)),"^",17)
		.i TItemDR'="" Set TUnitDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",7)
		.i TUnitDR'="" Set TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
		.i TItemDR'="" s TName=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1) //2013-06-24 DJ0118
		.s TEquipTypeDR=""	//add by csj 20190530 
		.i TItemDR'="" d
		..s TEquipTypeDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",3) //add by csj 20190530 
		..s TEquipCatDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",4) //add by csj 20190531
		..s TEquipCat=##class(web.DHCEQCommon).GetTrakNameByID("equipcat",TEquipCatDR)	//add by csj 20190531
		.q:(EquipType'="")&&(EquipType'=TEquipTypeDR)	//add by csj 20190530
		.s TRequestLoc=$p($g(^DHCEQBuyRequest(TBuyRequestDR)),"^",2)
		.s TUseLoc=$p($g(^DHCEQBuyRequest(TBuyRequestDR)),"^",4)
		.i TRequestLoc'="" s TRequestLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TRequestLoc)
		.i TUseLoc'="" s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLoc)
		.d OutputRowGetBPSourceID
	}
	Quit $$$OK
OutputRowGetBPSourceID
	s TPriceFee=##Class(web.DHCEQCommon).FormatNumber(TPriceFee,"")
	s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"")
	s Data=$lb(TSourceID,TItemDR,TName,TModelDR,TModel,TManuFacDR,TManuFac,TPriceFee,TQuantityNum,TTotalFee,TNo,TUnit,TUnitDR,TPrjName,TBuyRequestListDR,TEquipCat,TEquipCatDR)	//modified by csj 20190531
 	s ^CacheTemp(repid,index)=Data
	s index=index+1
	quit
ResetGetBPSourceID
	s (TSourceID,TItemDR,TName,TModelDR,TModel,TManuFacDR,TManuFac,TPriceFee,TQuantityNum,TTotalFee,TNo,TUnit,TUnitDR,TPrjName,TBuyRequestListDR,TEquipCatDR,TEquipCat)=""	//modified by csj 20190531
	Quit
BuildDataGetItem
	d ResetGetBPSourceID
	Quit:(SourceID'="")&&(SourceID'=rowid)
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
	d OutputRowGetBPSourceID
	
	Quit
}

ClassMethod GetBPSourceIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBPSourceIDExecute ]
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

ClassMethod GetBPSourceIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBPSourceIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
