/// Creator:czf 2014955
/// CreateDate:2021-07-28
/// Description:设备拆分
Class web.DHCEQ.EM.BUSSplit Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:	Add by CZF 2021-07-05
/// Description:拆分单查询
/// Input:		QXType:权限类型(0或空：全部 1：安全组 2：本科)
/// 			CurRole:当前角色ID
/// 			WaitAD:是否待办单据(checked:是 其他:否)
/// 			RequestNo:拆分单号
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSSplit","GetSplit","","","","","0","","","","","0","","")
Query GetSplit(QXType As %Library.String = "", CurRole As %Library.String = "", WaitAD As %Library.String = "", RequestNo As %Library.String = "", Type As %Library.String = "", EquipName As %String = "", EquipNo As %Library.String = "", StartDate As %Library.String = "", EndDate As %Library.String = "", StatusDR As %Library.String = "", EquipTypeDR As %Library.String = "", LocDR As %String = "") As %Query(ROWSPEC = "TRow:%String,TRowID:%String,TRequestNo:%String,TEquipName:%String,TEquipNo:%String,TEquipType:%String,TLoc:%String,TOriginalFee:%String,TDepreTotalFee:%String,TSplitOriginalFee:%String,TSplitDepreTotalFee:%String,TStatus:%String,TReason:%String,TRequestDate:%String,TRequestUser:%String,TSJob:%String")
{
}

ClassMethod GetSplitExecute(ByRef qHandle As %Binary, QXType As %Library.String = "", CurRole As %Library.String = "", WaitAD As %Library.String = "", RequestNo As %Library.String = "", Type As %Library.String = "", EquipName As %String = "", EquipNo As %Library.String = "", StartDate As %Library.String = "", EndDate As %Library.String = "", StatusDR As %Library.String = "", EquipTypeDR As %Library.String = "", LocDR As %String = "") As %Status
{
	new repid, index,rowid,CurRole
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set index=1
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("36")
	If StartDate="" Set StartDate=0
	Else  Set StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	If EndDate="" Set EndDate=+$h
	Else  Set EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	
	i RequestNo'="" d
	.s rowid=0
    .f  s rowid=$Order(^DHCEQSplit(0,"RequestNo",RequestNo,rowid))  Quit:rowid=""  Do
	..d BuildDataGetSplit
	e  d
	.s rowid=0
	.f  s rowid=$Order(^DHCEQSplit(rowid))  Quit:rowid=""  Do
	..d BuildDataGetSplit
	Quit $$$OK
	
BuildDataGetSplit	
	Do ResetVariablesGetSplit
	s TRowID = rowid
	s SplitInfo = $g(^DHCEQSplit(TRowID))
	q:$p(SplitInfo,"^",27)="Y"
	Set TRequestNo = $Piece(SplitInfo,"^",1)
	Quit:(RequestNo'="")&&(RequestNo'=TRequestNo)
	Set TEquipDR = $Piece(SplitInfo,"^",2)
	i TEquipDR'="" d
	.Set TEquipName = $Piece($g(^DHCEQEquip(TEquipDR)),"^",1)
	.Set TEquipNo = $Piece($g(^DHCEQEquip(TEquipDR)),"^",71)
	q:(EquipName'="")&&(TEquipName'[EquipName)
	q:(EquipNo'="")&&(TEquipNo'[EquipNo)
	Set TOriginalFee = ##Class(web.DHCEQCommon).FormatNumber($Piece(SplitInfo,"^",3),"")
	Set TDepreTotalFee = ##Class(web.DHCEQCommon).FormatNumber($Piece(SplitInfo,"^",4),"")
	Set TNetFee = ##Class(web.DHCEQCommon).FormatNumber($Piece(SplitInfo,"^",5),"")
	Set TEquipTypeDR = $Piece(SplitInfo,"^",8)
	q:(TEquipTypeDR'="")&&("1"=##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR))
	q:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR)
	Set TEquipType = ##class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)
	Set TStatCat = ##class(web.DHCEQCommon).GetTrakNameByID("statcat",$Piece(SplitInfo,"^",9))
	Set TEquipCat = ##class(web.DHCEQCommon).GetTrakNameByID("equipcat",$Piece(SplitInfo,"^",10))
	Set TLocDR = $Piece(SplitInfo,"^",11)
	Quit:(LocDR'="")&&(LocDR'=TLocDR)
	Set TLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
	Set TOriginDR = $Piece(SplitInfo,"^",12)
	Set TOrigin = ##class(web.DHCEQCommon).GetTrakNameByID("origin",TOriginDR)
	Set TEquipStatus = ##Class(web.DHCEQEquip).GetEquipStatusDisplay($Piece(SplitInfo,"^",13))
	Set TTranAssetDate = ##Class(web.DHCEQCommon).TransValueToPage($Piece(SplitInfo,"^",14),"date")
	Set TStartDate = ##Class(web.DHCEQCommon).TransValueToPage($Piece(SplitInfo,"^",15),"date")
	Set TProviderDR = $Piece(SplitInfo,"^",16)
	Set TProvider = ##class(web.DHCEQCommon).GetTrakNameByID("vendor",TProviderDR)
	Set TManuFactoryDR = $Piece(SplitInfo,"^",17)
	Set TManuFactory = ##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)
	Set TModelDR = $Piece(SplitInfo,"^",18)
	Set TModel = ##class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
	Set TReason = $Piece(SplitInfo,"^",20)
	Set TRemark = $Piece(SplitInfo,"^",21)
	Set TStatus = $Piece(SplitInfo,"^",22)
	Quit:(StatusDR'="")&&(StatusDR'=TStatus)
	Set TStatus = ##Class(web.DHCEQCommon).GetEditStatusDisplay(TStatus)
	Set TRequestUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",$Piece(SplitInfo,"^",23))
	Set TRequestDate=$Piece(SplitInfo,"^",24)
	Quit:(TRequestDate>EndDate)||(TRequestDate<StartDate)
	Set TRequestDate=##Class(web.DHCEQCommon).TransValueToPage(TRequestDate,"date")
	Set TAuditUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",$Piece(SplitInfo,"^",25))
	Set TAuditDate = ##Class(web.DHCEQCommon).TransValueToPage($Piece(SplitInfo,"^",26),"date")
	Set TSplitOriginalFee = ##Class(web.DHCEQCommon).FormatNumber($Piece(SplitInfo,"^",28),"")
	Set TSplitDepreTotalFee = ##Class(web.DHCEQCommon).FormatNumber($Piece(SplitInfo,"^",29),"")
	Set TSplitNetFee = ##Class(web.DHCEQCommon).FormatNumber($Piece(SplitInfo,"^",30),"")
	Set TSJob = $Piece(SplitInfo,"^",31)
	Set THold2 = $Piece(SplitInfo,"^",32)
	Set THold3 = $Piece(SplitInfo,"^",33)
	Set THold4 = $Piece(SplitInfo,"^",34)
	Set THold5 = $Piece(SplitInfo,"^",35)
	Set TApproveRole=""
	Set AIRowID=$Order(^DHCEQApproveInfo(0,"SourceID",ApproveType,rowid,0))
	If AIRowID'="" Do
	.Set CurRole=$Piece(^DHCEQApproveInfo(AIRowID),"^",4)
	.Set TApproveRole=$Piece(^DHCEQApproveInfo(AIRowID),"^",7)
	If TApproveRole'="" Set TApproveRole=##class(web.DHCEQCommon).GetTrakNameByID("role",TApproveRole)
	Quit:((WaitAD="checked")&&(CurRole'=ApproveRole))
	Do OutputRowGetSplit
	
	Quit 
OutputRowGetSplit
	Set TRow=index
	Set Data=$lb(TRow,TRowID,TRequestNo,TEquipName,TEquipNo,TEquipType,TLoc,TOriginalFee,TDepreTotalFee,TSplitOriginalFee,TSplitDepreTotalFee,TStatus,TReason,TRequestDate,TRequestUser,TSJob)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetSplit
	s (TRowID,TRequestNo,TEquipDR,TEquipName,TEquipNo,TOriginalFee,TDepreTotalFee,TNetFee,TEquipTypeDR,TEquipType,TStatCat,TEquipCat,TLocDR,TLoc,TOriginDR,TOrigin)=""
	s (TEquipStatus,TTranAssetDate,TStartDate,TProviderDR,TProvider,TManuFactoryDR,TManuFactory,TModelDR,TModel,TReason,TRemark,TStatus,TRequestUser,TRequestDate,TAuditUser,TAuditDate,TSplitOriginalFee,TSplitDepreTotalFee,TSplitNetFee,TSJob,THold2,THold3,THold4,THold5)=""

	Quit
}

ClassMethod GetSplitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSplitExecute ]
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

ClassMethod GetSplitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSplitExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:	Add by CZF 2021-07-05
/// Description:拆分明细单
/// Input:		RowID 拆分主表RowID
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSSplit","GetSplitList","1")
Query GetSplitList(RowID As %String = "") As %Query(ROWSPEC = "SLRow:%String,SLRowID:%String,SLSplitDR:%String,SLEquipDR:%String,SLEquipNo:%String,SLEquipName:%String,SLOriginalFee:%String,SLDepreTotalFee:%String,SLNetFee:%String,SLLeaveFactoryNo:%String,SLFileNo:%String,SLItemDR:%String,SLItemDR_MIDesc:%String,SLEquipCatDR:%String,SLLimitYearsNum:%String,SLDepreMethodDR:%String,SLDepreMethodDR_DMDesc:%String,SLManuFactoryDR:%String,SLManuFactoryDR_VName:%String,SLModelDR:%String,SLModelDR_MDesc:%String,SLLocationDR:%String,SLLocationDR_LDesc:%String,SLRemark:%String,SLQuantityNum:%String")
{
}

ClassMethod GetSplitListExecute(ByRef qHandle As %Binary, RowID As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set TRow=0
	Set TotalNum=0
 	Set TotalFee=0
 	Set TotalDepreFee=0
 	
	If RowID'=""
	{
		Set rowid=0
		For  Set rowid=$Order(^DHCEQSplitList(0,"Split",RowID,rowid))  Quit:rowid=""  Do
		.Do ResetVariablesGetSplitList
		.Set SLRowID = rowid
		.Set SplitListInfo = $Get(^DHCEQSplitList(SLRowID))
		.Set SLSplitDR = $Piece(SplitListInfo,"^",1)
		.Set SLEquipDR = $Piece(SplitListInfo,"^",2)
		.Set SLEquipNo = $Piece(SplitListInfo,"^",3)
		.Set SLEquipName = $Piece(SplitListInfo,"^",4)
		.Set SLOriginalFee = ##Class(web.DHCEQCommon).FormatNumber($Piece(SplitListInfo,"^",5),"")
		.Set SLDepreTotalFee = ##Class(web.DHCEQCommon).FormatNumber($Piece(SplitListInfo,"^",6),"")
		.Set SLNetFee = ##Class(web.DHCEQCommon).FormatNumber($Piece(SplitListInfo,"^",7),"")
		.Set TotalNum = TotalNum + 1
		.Set TotalFee = TotalFee + SLOriginalFee
		.Set TotalDepreFee = TotalDepreFee + SLDepreTotalFee
		.Set SLLeaveFactoryNo = $Piece(SplitListInfo,"^",8)
		.Set SLFileNo = $Piece(SplitListInfo,"^",9)
		.Set SLItemDR = $Piece(SplitListInfo,"^",10)
		.Set SLItem = ##class(web.DHCEQCommon).GetTrakNameByID("masteritem",SLItemDR)
		.Set SLEquipTypeDR = $Piece(SplitListInfo,"^",11)
		.Set SLEquipType = ##class(web.DHCEQCommon).GetTrakNameByID("equiptype",SLEquipTypeDR)
		.Set SLStatCatDR = $Piece(SplitListInfo,"^",12)
		.Set SLStatCat = ##class(web.DHCEQCommon).GetTrakNameByID("statcat",SLStatCatDR)
		.Set SLEquipCatDR = $Piece(SplitListInfo,"^",13)
		.Set SLEquipCat = ##class(web.DHCEQCommon).GetTrakNameByID("equipcat",SLEquipCatDR)
		.Set SLLocDR = $Piece(SplitListInfo,"^",14)
		.Set SLLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",SLLocDR)
		.Set SLLimitYearsNum = $Piece(SplitListInfo,"^",15)
		.Set SLDepreMethodDR = $Piece(SplitListInfo,"^",16)
		.Set SLDepreMethod = ##class(web.DHCEQCommon).GetTrakNameByID("depremethod",SLDepreMethodDR)
		.Set SLManuFactoryDR = $Piece(SplitListInfo,"^",17)
		.Set SLManuFactory = ##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",SLManuFactoryDR)
		.Set SLModelDR = $Piece(SplitListInfo,"^",18)
		.Set SLModel = ##class(web.DHCEQCommon).GetTrakNameByID("model",SLModelDR)
		.Set SLLocationDR = $Piece(SplitListInfo,"^",19)
		.Set SLLocation = ##class(web.DHCEQCommon).GetTrakNameByID("location",SLLocationDR)
		.Set SLRemark = $Piece(SplitListInfo,"^",20)
		.Set SLQuantityNum = $Piece(SplitListInfo,"^",21)
		.Set SLHold2 = $Piece(SplitListInfo,"^",22)
		.Set SLHold3 = $Piece(SplitListInfo,"^",23)
		.Set SLHold4 = $Piece(SplitListInfo,"^",24)
		.Set SLHold5 = $Piece(SplitListInfo,"^",25)
		.Set TRow=TRow+1
		.Do OutputRowGetSplitList
	}
	If TRow=0
	{
		Do ResetVariablesGetSplitList
		Set TRow=1
		Do OutputRowGetSplitList
	}	
	Quit $$$OK
OutputRowGetSplitList
	Set Data=$lb(TRow,SLRowID,SLSplitDR,SLEquipDR,SLEquipNo,SLEquipName,SLOriginalFee,SLDepreTotalFee,SLNetFee,SLLeaveFactoryNo,SLFileNo,SLItemDR,SLItem,SLEquipCatDR,SLLimitYearsNum,SLDepreMethodDR,SLDepreMethod,SLManuFactoryDR,SLManuFactory,SLModelDR,SLModel,SLLocationDR,SLLocation,SLRemark,SLQuantityNum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetSplitList
	Set (SLRowID,SplitListInfo,SLSplitDR,SLEquipDR,SLEquipNo,SLEquipName,SLOriginalFee,SLDepreTotalFee,SLNetFee,SLLeaveFactoryNo,SLFileNo,SLItemDR,SLItem,SLEquipTypeDR,SLEquipType,SLStatCatDR,SLStatCat,SLEquipCatDR,SLEquipCat,SLLocDR,SLLoc,SLLimitYearsNum,SLDepreMethodDR,SLDepreMethod,SLManuFactoryDR,SLManuFactory,SLModelDR,SLModel,SLLocationDR,SLLocation,SLRemark,SLQuantityNum,SLHold2,SLHold3,SLHold4,SLHold5)=""
	Quit
}

ClassMethod GetSplitListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSplitListExecute ]
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

ClassMethod GetSplitListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSplitListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:	Add by CZF 2020-11-29
/// Description:设备拆分明细查询
/// Input:		RowID 拆分主表RowID
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSSplit","GetSplitDetail","")
Query GetSplitDetail(Params As %String) As %Query(ROWSPEC = "TRow:%String,TSRowID:%String,TSLRowID:%String,TRequestNo:%String,TEquipDR:%String,TEquipName:%String,TEquipNo:%String,TLeaveFactoryNo:%String,TEquipType:%String,TLoc:%String,TOriginalFee:%String,TDepreTotalFee:%String,TSplitOriginalFee:%String,TSplitDepreTotalFee:%String,TStatus:%String,TMainEquip:%String,TRequestDate:%String,TRequestUser:%String,TModel:%String,TProvider:%String")
{
}

ClassMethod GetSplitDetailExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set TRow=0
	
 	s JsonObj=##class(web.DHCEQ.Plat.JsonObject).FromJSON(Params)
	s RequestNo=JsonObj.%Get("RequestNo")
	s Status=JsonObj.%Get("Status")
	s EquipName=JsonObj.%Get("EquipName")
	s EquipNo=JsonObj.%Get("EquipNo")
	s StartDate=JsonObj.%Get("StartDate")
	s EndDate=JsonObj.%Get("EndDate")
	s EquipTypeDR=JsonObj.%Get("EquipTypeDR")
	s LocDR=JsonObj.%Get("LocDR")
	s MainFlag=JsonObj.%Get("MainFlag")
	i StartDate="" s StartDate=0
	e  s StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	i EndDate="" s EndDate=+$h
	e  s EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	
	s TSRowID=0
	f  s TSRowID=$o(^DHCEQSplit(TSRowID)) q:TSRowID=""  d
	.d ResetVariablesGetSplitDetail
	.d GetSplit
	.d OutputRowGetSplitDetail
	.s:MainFlag="Y" TRow=TRow+1
	.q:MainFlag="Y"		//只输出主设备
	.s TSLRowID=0
	.f  s TSLRowID=$Order(^DHCEQSplitList(0,"Split",TSRowID,TSLRowID))  q:TSLRowID=""  d
	..d GetSplit
	..d GetSplitList
	..s TRow=TRow+1
	..d OutputRowGetSplitDetail
	Quit $$$OK
	
GetSplit
	s SplitInfo = $g(^DHCEQSplit(TSRowID))
	q:$p(SplitInfo,"^",27)="Y"
	Set TRequestNo = $Piece(SplitInfo,"^",1)
	Quit:(RequestNo'="")&&(RequestNo'=TRequestNo)
	Set TEquipDR = $Piece(SplitInfo,"^",2)
	i TEquipDR'="" d
	.Set TEquipName = $Piece($g(^DHCEQEquip(TEquipDR)),"^",1)
	.Set TEquipNo = $Piece($g(^DHCEQEquip(TEquipDR)),"^",71)
	Set SLMainEquip = TEquipNo
	q:(EquipName'="")&&(TEquipName'[EquipName)
	q:(EquipNo'="")&&(TEquipNo'[EquipNo)
	Set TOriginalFee = ##Class(web.DHCEQCommon).FormatNumber($Piece(SplitInfo,"^",3),"")
	Set TDepreTotalFee = ##Class(web.DHCEQCommon).FormatNumber($Piece(SplitInfo,"^",4),"")
	Set TNetFee = ##Class(web.DHCEQCommon).FormatNumber($Piece(SplitInfo,"^",5),"")
	Set TEquipTypeDR = $Piece(SplitInfo,"^",8)
	q:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR)
	Set TEquipType = ##class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)
	Set TStatCat = ##class(web.DHCEQCommon).GetTrakNameByID("statcat",$Piece(SplitInfo,"^",9))
	Set TEquipCat = ##class(web.DHCEQCommon).GetTrakNameByID("equipcat",$Piece(SplitInfo,"^",10))
	Set TLocDR = $Piece(SplitInfo,"^",11)
	Quit:(LocDR'="")&&(LocDR'=TLocDR)
	Set TLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
	Set TOriginDR = $Piece(SplitInfo,"^",12)
	Set TOrigin = ##class(web.DHCEQCommon).GetTrakNameByID("origin",TOriginDR)
	Set TEquipStatus = ##Class(web.DHCEQEquip).GetEquipStatusDisplay($Piece(SplitInfo,"^",13))
	Set TTranAssetDate = ##Class(web.DHCEQCommon).TransValueToPage($Piece(SplitInfo,"^",14),"date")
	Set TStartDate = ##Class(web.DHCEQCommon).TransValueToPage($Piece(SplitInfo,"^",15),"date")
	Set TProviderDR = $Piece(SplitInfo,"^",16)
	Set TProvider = ##class(web.DHCEQCommon).GetTrakNameByID("vendor",TProviderDR)
	Set TManuFactoryDR = $Piece(SplitInfo,"^",17)
	Set TManuFactory = ##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)
	Set TModelDR = $Piece(SplitInfo,"^",18)
	Set TModel = ##class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
	Set TReason = $Piece(SplitInfo,"^",20)
	Set TRemark = $Piece(SplitInfo,"^",21)
	Set TStatus = $Piece(SplitInfo,"^",22)
	Quit:(Status'="")&&(Status'=TStatus)
	Set TStatus = ##Class(web.DHCEQCommon).GetEditStatusDisplay(TStatus)
	Set TRequestUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",$Piece(SplitInfo,"^",23))
	Set TRequestDate=$Piece(SplitInfo,"^",24)
	Quit:(TRequestDate>EndDate)||(TRequestDate<StartDate)
	Set TRequestDate=##Class(web.DHCEQCommon).TransValueToPage(TRequestDate,"date")
	Set TAuditUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",$Piece(SplitInfo,"^",25))
	Set TAuditDate = ##Class(web.DHCEQCommon).TransValueToPage($Piece(SplitInfo,"^",26),"date")
	Set TSplitOriginalFee = ##Class(web.DHCEQCommon).FormatNumber($Piece(SplitInfo,"^",28),"")
	Set TSplitDepreTotalFee = ##Class(web.DHCEQCommon).FormatNumber($Piece(SplitInfo,"^",29),"")
	Set TSplitNetFee = ##Class(web.DHCEQCommon).FormatNumber($Piece(SplitInfo,"^",30),"")
	Set THold1 = $Piece(SplitInfo,"^",31)
	Set THold2 = $Piece(SplitInfo,"^",32)
	Set THold3 = $Piece(SplitInfo,"^",33)
	Set THold4 = $Piece(SplitInfo,"^",34)
	Set THold5 = $Piece(SplitInfo,"^",35)
	s TMainEquip=""
	
	quit
GetSplitList
	Set (SplitListInfo,TOriginalFee,TDepreTotalFee,TNetFee,TEquipDR,TEquipNo,TEquipName,TSplitOriginalFee,TSplitDepreTotalFee,TSplitNetFee,TLeaveFactoryNo,TFileNo,TEquipTypeDR,TEquipType,TStatCatDR,TStatCatDR,TEquipCatDR,TEquipCat)= ""
	Set (TLocDR,TLoc,TLimitYearsNum,TDepreMethodDR,TDepreMethod,TManuFactoryDR,TManuFactory,TModelDR,TModel,TLocationDR,TLocation,TRemark,THold1,THold2,THold3,THold4,THold5)=""
	Set SplitListInfo = $Get(^DHCEQSplitList(TSLRowID))
	Set TEquipDR = $Piece(SplitListInfo,"^",2)
	Set TEquipNo = $Piece(SplitListInfo,"^",3)
	Set TEquipName = $Piece(SplitListInfo,"^",4)
	Set TSplitOriginalFee = ##Class(web.DHCEQCommon).FormatNumber($Piece(SplitListInfo,"^",5),"")
	Set TSplitDepreTotalFee = ##Class(web.DHCEQCommon).FormatNumber($Piece(SplitListInfo,"^",6),"")
	Set TSplitNetFee = ##Class(web.DHCEQCommon).FormatNumber($Piece(SplitListInfo,"^",7),"")
	Set TLeaveFactoryNo = $Piece(SplitListInfo,"^",8)
	Set TFileNo = $Piece(SplitListInfo,"^",9)
	Set TEquipTypeDR = $Piece(SplitListInfo,"^",11)
	Set TEquipType = ##class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)
	Set TStatCatDR = $Piece(SplitListInfo,"^",12)
	Set TStatCat = ##class(web.DHCEQCommon).GetTrakNameByID("statcat",TStatCatDR)
	Set TEquipCatDR = $Piece(SplitListInfo,"^",13)
	Set TEquipCat = ##class(web.DHCEQCommon).GetTrakNameByID("equipcat",TEquipCatDR)
	Set TLocDR = $Piece(SplitListInfo,"^",14)
	Set TLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
	Set TLimitYearsNum = $Piece(SplitListInfo,"^",15)
	Set TDepreMethodDR = $Piece(SplitListInfo,"^",16)
	Set TDepreMethod = ##class(web.DHCEQCommon).GetTrakNameByID("depremethod",TDepreMethodDR)
	Set TManuFactoryDR = $Piece(SplitListInfo,"^",17)
	Set TManuFactory = ##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)
	Set TModelDR = $Piece(SplitListInfo,"^",18)
	Set TModel = ##class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
	Set TLocationDR = $Piece(SplitListInfo,"^",19)
	Set TLocation = ##class(web.DHCEQCommon).GetTrakNameByID("location",TLocationDR)
	Set TRemark = $Piece(SplitListInfo,"^",20)
	Set THold1 = $Piece(SplitListInfo,"^",21)
	Set THold2 = $Piece(SplitListInfo,"^",22)
	Set THold3 = $Piece(SplitListInfo,"^",23)
	Set THold4 = $Piece(SplitListInfo,"^",24)
	Set THold5 = $Piece(SplitListInfo,"^",25)
	Set TMainEquip=SLMainEquip
	quit
OutputRowGetSplitDetail
	Set Data=$lb(TRow,TSRowID,TSLRowID,TRequestNo,TEquipDR,TEquipName,TEquipNo,TLeaveFactoryNo,TEquipType,TLoc,TOriginalFee,TDepreTotalFee,TSplitOriginalFee,TSplitDepreTotalFee,TStatus,TMainEquip,TRequestDate,TRequestUser,TModel,TProvider)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetSplitDetail
	s (TSLRowID,TRequestNo,TEquipDR,TEquipName,TEquipNo,TOriginalFee,TDepreTotalFee,TNetFee,TEquipTypeDR,TEquipType,TStatCat,TEquipCat,TLocDR,TLoc,TOriginDR,TOrigin)=""
	s (TEquipStatus,TTranAssetDate,TStartDate,TProviderDR,TProvider,TManuFactoryDR,TManuFactory,TModelDR,TModel,TReason,TRemark,TStatus,TRequestUser,TRequestDate,TAuditUser,TAuditDate,TSplitOriginalFee,TSplitDepreTotalFee,TSplitNetFee,THold1,THold2,THold3,THold4,THold5)=""
	
	Quit
}

ClassMethod GetSplitDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSplitDetailExecute ]
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

ClassMethod GetSplitDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSplitDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:	Add by CZF 2021-07-05 
/// Description:拆分单详细
/// Input：		rowid：拆分表rowid
/// 			ApproveRoleDR:角色ID
/// 			Action:动作代码
/// 			Step:步骤
/// Output:		拆分单详细Json串
/// w ##class(web.DHCEQ.EM.BUSSplit).GetOneSplit(3)
ClassMethod GetOneSplit(rowid As %Library.String = "", ApproveRoleDR As %Library.String, Action As %Library.String = "", Step As %Library.String = "")
{
	s $ZT="ERRORGetOneSplit"
	s ObjSplit=##Class(User.DHCEQSplit).%OpenId(rowid)
	s SplitInfo=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjSplit)
	d SplitInfo.%Set("SEquipDR_EQName",ObjSplit.SEquipDR.EQName)
	d SplitInfo.%Set("EquipNo",ObjSplit.SEquipDR.EQNo)
	d SplitInfo.%Set("SLocDR_DeptDesc",ObjSplit.SLocDR.DeptDesc)
	d SplitInfo.%Set("SEquipTypeDR_ETDesc",ObjSplit.SEquipTypeDR.ETDesc)
	d SplitInfo.%Set("SStatCatDR_SCDesc",ObjSplit.SStatCatDR.SCDesc)
	d SplitInfo.%Set("SEquipCatDR_ECDesc",ObjSplit.SEquipCatDR.ECDesc)
	d SplitInfo.%Set("SOriginDR_ODesc",ObjSplit.SOriginDR.ODesc)
	d SplitInfo.%Set("SProviderDR_VName",ObjSplit.SProviderDR.VName)
	d SplitInfo.%Set("SManuFactoryDR_VName",ObjSplit.SManuFactoryDR.VName)
	d SplitInfo.%Set("SModelDR_MDesc",ObjSplit.SModelDR.MDesc)
	d SplitInfo.%Set("SDepreMethodDR_DMDesc",ObjSplit.SDepreMethodDR.DMDesc)
	d SplitInfo.%Set("LeaveFactoryNo",ObjSplit.SEquipDR.EQLeaveFactoryNo)
	d SplitInfo.%Set("SIsKeep",##class(web.DHCEQCommon).TransValueToPage(ObjSplit.SIsKeep,"bool"))
	s (TotalOriginalFee,TotalDepreFee)=0
	&SQL(Select sum(SL_OriginalFee*SL_QuantityNum) into:TotalOriginalFee  from SQLUSER.DHC_EQSplitList where SL_SplitDR = :rowid)
	&SQL(Select sum(SL_DepreTotalFee*SL_QuantityNum) into:TotalDepreFee from SQLUSER.DHC_EQSplitList where SL_SplitDR = :rowid)
	d SplitInfo.%Set("SLListTotalFee",##class(web.DHCEQCommon).FormatNumber(TotalOriginalFee,"",2))
	d SplitInfo.%Set("SLListTotalDepreFee",##class(web.DHCEQCommon).FormatNumber(TotalDepreFee,"",2))

	Set AppInfo=##class(web.DHCEQApprove).GetApproveInfoBySourceID("36",rowid,ApproveRoleDR)
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("36")
	d SplitInfo.%Set("AIRowID",$p(AppInfo,"^",1))
	d SplitInfo.%Set("ApproveSetDR",$p(AppInfo,"^",2))
	d SplitInfo.%Set("NextRoleDR",$p(AppInfo,"^",3))
	d SplitInfo.%Set("NextFlowStep",$p(AppInfo,"^",4))
	d SplitInfo.%Set("ApproveStatus",$p(AppInfo,"^",5))
	d SplitInfo.%Set("ApproveRoleDR",$p(AppInfo,"^",6))
	d SplitInfo.%Set("CancelFlag",$p(AppInfo,"^",7))
	d SplitInfo.%Set("CancelToFlowDR",$p(AppInfo,"^",8))
	d SplitInfo.%Set("ApproveRole",$p(AppInfo,"^",9))
	d SplitInfo.%Set("NextRole",$p(AppInfo,"^",10))
	s CanChangeValue=""
	i Action'="" s CanChangeValue=##Class(web.DHCEQCApproveFlow).CheckApproveFlagAbove("36",Action,rowid,2,$p(AppInfo,"^",2))
	s MultipleRoleFlag=0
	i ($p(CanChangeValue,"^",3)'="")&&((","_$p(CanChangeValue,"^",3))[(","_Step_",")) d
	.s MultipleRoleFlag=1
	
	d SplitInfo.%Set("MultipleRoleFlag",MultipleRoleFlag)
	
	q ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,SplitInfo)
ERRORGetOneSplit
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-9000",ErrorMsg)
}

/// Creator:	add by czf 2021-07-05
/// Description:新增、更新、删除数据记录
/// Input:		val:拆分主单Json串
/// 			list:拆分明细Json串
/// 			DelRowid:删除的拆分明细id串，逗号分隔
/// 			User:用户ID
/// Output:		操作成功或失败Json串
/// w ##class(web.DHCEQ.EM.BUSSplit).SaveData("{""SRequestNo"":"""",""SRequestDate"":"""",""SEquipDR_EQName"":""生物组织摊烤片机"",""EquipNo"":""3221709000001"",""SLocDR_DeptDesc"":""CT室"",""SOriginalFee"":""23000"",""SDepreTotalFee"":"""",""SNetFee"":""23000"",""SEquipTypeDR_ETDesc"":""专用设备"",""SStatCatDR_SCDesc"":""临床检验分析仪器"",""SEquipCatDR_ECDesc"":""实验室辅助器具,设施及设备"",""SOriginDR_ODesc"":""1"",""STransAssetDate"":""2021-02-19"",""SStartDate"":""2021-02-24"",""SProviderDR_VName"":""合江县金屹电脑有限公司"",""SManuFactoryDR_VName"":"""",""SModelDR_MDesc"":"""",""SLimitYearsNum"":""5"",""SDepreMethodDR_DMDesc"":""平均年限法"",""LeaveFactoryNo"":"""",""SSplitOriginalFee"":""20000"",""SSplitDepreTotalFee"":""0"",""SSplitNetFee"":""20000"",""SIsKeep"":true,""SRowID"":"""",""SStatus"":"""",""SEquipDR"":""6"",""SDepreMethodDR"":""1"",""SEquipTypeDR"":""3"",""SStatCatDR"":""30"",""SEquipCatDR"":""2659"",""SLocDR"":""1"",""SOriginDR"":""自购"",""SEquipStatus"":"""",""SProviderDR"":""1"",""SManuFactoryDR"":"""",""SModelDR"":"""",""QXType"":"""",""ReadOnly"":""0"",""CurRole"":"""",""ApproveTypeCode"":""36"",""ApproveSetDR"":"""",""ApproveRoleDR"":"""",""WaitAD"":""off"",""CancelOper"":"""",""RoleStep"":""0"",""CurDate"":""2021-07-12"",""Action"":"""",""ActionID"":"""",""NextFlowStep"":"""",""NextRoleDR"":"""",""CancelFlag"":"""",""CancelToFlowDR"":"""",""ApproveStatus"":"""",""Type"":""0"",""SplitNumCode"":""$CHAR(4)"",""SplitRowCode"":""$CHAR(3)"",""HospitalDesc"":""东华标准版数字化医院[总院]"",""GetComponentID"":""1006"",""PreviewRptFlag"":""0"",""SLListTotalFee"":"""",""SLListTotalDepreFee"":"""",""Job"":""53872"",""SReason"":""111"",""SRemark"":"""",""EditOpinion"":"""",""RejectReason"":""""}","{""SLRow"":""1"",""SLRowID"":"""",""SLSplitDR"":"""",""SLEquipDR"":"""",""SLEquipNo"":"""",""SLEquipName"":""生物组织摊烤片机1"",""SLOriginalFee"":""1000"",""SLDepreTotalFee"":""0"",""SLNetFee"":1000,""SLLeaveFactoryNo"":"""",""SLFileNo"":"""",""SLItemDR"":""1067"",""SLItemDR_MIDesc"":""听诊器"",""SLEquipCatDR"":""2569"",""SLLimitYearsNum"":"""",""SLDepreMethodDR"":"""",""SLDepreMethodDR_DMDesc"":"""",""SLManuFactoryDR"":"""",""SLManuFactoryDR_VName"":"""",""SLModelDR"":"""",""SLModelDR_MDesc"":"""",""SLLocationDR"":"""",""SLLocationDR_LDesc"":"""",""SLRemark"":"""",""SLQuantityNum"":""2""}$CHAR(3){""SLLeaveFactoryNo"":"""",""SLFileNo"":"""",""SLEquipName"":""生物组织摊烤片机2"",""SLQuantityNum"":""3"",""SLOriginalFee"":""2000"",""SLDepreTotalFee"":"""",""SLItemDR_MIDesc"":""听诊器"",""SLManuFactoryDR_VName"":"""",""SLModelDR_MDesc"":"""",""SLLocationDR_LDesc"":"""",""SLLimitYearsNum"":"""",""SLDepreMethodDR_DMDesc"":"""",""SLRemark"":"""",""SLNetFee"":2000,""SLItemDR"":""1067"",""SLEquipCatDR"":""2569"",""SLModelDR"":""""}","","77")
ClassMethod SaveData(val As %Library.String = "", list As %Library.String = "", DelRowid As %Library.String = "", User As %String = "")
{
	Kill PLIST,LIST,rowid,Rowid
	Set $ZT="ERRORUpdateData"
	Set updDate=+$H
 	Set updTime=$Piece($H,",",2)
 	i User="" Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(val)
 	s Job=JsonData.SJob
	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQSplit",JsonData,.PLIST)
	s PLIST(20)=##class(web.DHCEQCommon).TransValueFromPage(JsonData.SIsKeep,"bool")
	s PLIST(14)=$p($g(^DHCEQEquip(JsonData.SEquipDR)),"^",38)
	i +PLIST(14)>2 q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000","设备已停用或报废,不能拆分!")
	s rowid = JsonData.SRowID
	Set SRowID=rowid
	Set EquipDR=JsonData.SEquipDR
	Set PLIST(28)="N"
	
	i rowid'=""
	{
		s InvalidFlag=$p($g(^DHCEQSplit(rowid)),"^",28)
		i InvalidFlag="Y" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000","无效单据")
	}
	i EquipDR=""
	{
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000","主设备不能为空")
	}
	
	s SplitOriginalFee=JsonData.SSplitOriginalFee
	s SplitNetFee=JsonData.SSplitNetFee
	s RemainFeeRate=##class(web.DHCEQCommon).GetSysInfo("990029")
	s RemainFee=##Class(web.DHCEQCommon).FormatNumber(SplitOriginalFee*RemainFeeRate/100,"",2)
	i ##Class(web.DHCEQCommon).FormatNumber(SplitNetFee,"",2)<RemainFee
	{
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-3002","主设备拆分后净值:"_SplitNetFee_"不能小于净残值:"_RemainFee)
	}
	
	TStart
	If (rowid="")
	{
	 	Set PLIST(23)=0		;S_Status
	 	Set PLIST(24)=User	;S_RequestUserDR
		Set PLIST(25)=updDate	;S_RequestDate
	 	Set PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQSplit",$h,"",JsonData.SEquipTypeDR)
	 	&SQL(Insert SQLUSER.DHC_EQSplit Values :PLIST())
	}
	Else
	{
	 	Set PLIST(24)=User
		Set PLIST(25)=updDate
		&SQL(Update SQLUSER.DHC_EQSplit Values :PLIST() where S_RowID = :SRowID)
	}
	If SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,%msg)
	}
	
	s rowid=$Get(%ROWID)
	s OperateInfo="^55^"_rowid_"^"_User_"^^0"
 	s RtnCode=##Class(web.DHCEQ.Plat.BUSOperateLog).SaveData(OperateInfo,"3")
	i $p(RtnCode,"^",1)'=0
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"操作信息保存失败!")
	}
	s SQLCODE=0,ErrMsg=""
	Set SEquipDR=$p($g(^DHCEQSplit(rowid)),"^",2)
	Set MainEquipNo=$p($g(^DHCEQEquip(SEquipDR)),"^",71)
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")
	Set Length=$Length(list,SplitRowCode)
	For i=1:1:Length  q:SQLCODE'=0  d
	.K LIST
	.s valList= $Piece(list,SplitRowCode,i)
	.s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
	.s LIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQSplitList",JsonData,.LIST)
	.s SLOriginalFee=JsonData.SLOriginalFee
	.s SLNetFee=JsonData.SLNetFee
	.s RemainFee=##Class(web.DHCEQCommon).FormatNumber(SplitOriginalFee*RemainFeeRate/100,"",2)
	.i SLNetFee<RemainFee s SQLCODE=-9003,ErrMsg=LIST(5)_"净值:"_SLNetFee_"不能小于净残值:"_RemainFee_"！"
	.q:SQLCODE'=0
	.s SLRowid = JsonData.SLRowID
	.s LIST(2)=rowid	;SL_SplitDR
	.s SLQuantityNum=JsonData.SLQuantityNum
	.i SLQuantityNum="" s SQLCODE=-9001
	.q:SQLCODE'=0
	.s LIST(22)=SLQuantityNum
	.s SLEquipNo=JsonData.SLEquipNo
	.s LIST(4)=SLEquipNo
    .///modified by ZY 20221107     2712083
    .;s LIST(12)=$p($g(^DHCEQSplit(rowid)),"^",8)    ;SL_EquipTypeDR
    .;s LIST(13)=$p($g(^DHCEQSplit(rowid)),"^",9)    ;SL_StatCatDR
    .s LIST(12)=$p(^DHCEQCCode("DHCEQCMasterItem",LIST(11)),"^",3)    ;SL_EquipTypeDR
    .s LIST(13)=$p(^DHCEQCCode("DHCEQCMasterItem",LIST(11)),"^",5)    ;SL_StatCatDR
	.s LIST(15)=$p($g(^DHCEQSplit(rowid)),"^",11)	;SL_LocDR
	.i LIST(15)="" s LIST(15)=$p($g(^DHCEQEquip(SEquipDR)),"^",67)	;SL_LocDR
	.s LIST(14)=JsonData.SLEquipCatDR
	.;i LIST(14)="" s LIST(14)=$p($g(^DHCEQSplit(rowid)),"^",10)	;SL_EquipCatDR
	.s LIST(16)=JsonData.SLLimitYearsNum
	.;i LIST(16)="" s LIST(16)=$p($g(^DHCEQSplit(rowid)),"^",6)	;SL_LimitYearsNum
	.s LIST(17)=JsonData.SLDepreMethodDR
	.;i LIST(17)="" s LIST(17)=$p($g(^DHCEQSplit(rowid)),"^",7)	;SL_DepreMethodDR
	.s LIST(20)=JsonData.SLLocationDR
	.;i LIST(20)="" s LIST(20)=$p($g(^DHCEQEquip(SEquipDR)),"^",72)	;SLLocationDR
	.s SLEquipCatDR=LIST(14)
	.i SLEquipCatDR="" s SLEquipCatDR=$p(^DHCEQCCode("DHCEQCMasterItem",LIST(11)),"^",4)
	.s equipecatno=$p(^DHCEQCCode("DHCEQCEquipeCat",SLEquipCatDR),"^",1)
	.s index=i-1		//JsonData.SLIndex
	.s SLEquipDR=JsonData.SLEquipDR
	.s SLLeaveFactoryNo=JsonData.SLLeaveFactoryNo
	.s SLFileNo=JsonData.SLFileNo
	.i (SLRowid="")  d
	..&SQL(Insert Into SQLUSER.DHC_EQSplitList Values :LIST())
	..Set SLRowid=$Get(%ROWID)
	..q:SQLCODE'=0
	.e  d
	..&SQL(Update SQLUSER.DHC_EQSplitList Values :LIST() where SL_RowID = :SLRowid)
	..If SQLCODE=100 Set SQLCODE=0
	.q:SQLCODE'=0
	.;保存明细编号、出厂编号、档案号信息
	.k ^DHCEQSplitList(SLRowid,"EX","EQNosInfo")	//删除明细编号信息	czf 2021-08-02
	.f j=1:1:SLQuantityNum d
	..q:SQLCODE'=0
	..i $g(^DHCEQTempSplitList(0,"EQNosInfo","EX",Job,User,MainEquipNo,SLRowid,(j-1)))="" d
	...s SLEquipNo=$p($g(^DHCEQTempSplitList(0,"EQNosInfo",Job,User,MainEquipNo,index,(j-1))),"^",2)		//czf 2021-08-04
	...i SLEquipNo'="" d
	....s ^DHCEQTempSplitList(0,"EQNosInfo","EX",Job,User,MainEquipNo,SLRowid,(j-1))=$g(^DHCEQTempSplitList(0,"EQNosInfo",Job,User,MainEquipNo,index,(j-1)))
	...e  d
	....s MXInfo=Job_"^"_index_"^"_(j-1)_"^"_SLRowid_"^^"_MainEquipNo
	....;i SLEquipNo="" s SLEquipNo=MainEquipNo_##class(web.DHCEQCCounter).LPAD(i,"0",2)_##class(web.DHCEQCCounter).LPAD(j,"0",2)	;SL_EquipNo
	....i SLEquipNo="" s SLEquipNo=##class(web.DHCEQCCounter).GetNextNo("DHC_EQSplitEquip",+$h,LIST(15),LIST(12),LIST(13),equipecatno,"","",MainEquipNo)
	....s val=SLEquipDR_"^"_SLEquipNo_"^"_SLLeaveFactoryNo_"^"_SLFileNo
	....s SQLCODE=..UpdateEquipsByList(val,MXInfo,User)
	....q:SQLCODE'=0
	..q:SQLCODE'=0
	..s SLEquipNoInfo=$g(^DHCEQTempSplitList(0,"EQNosInfo","EX",Job,User,MainEquipNo,SLRowid,(j-1)))
	..s SLEquipListNo=$p(SLEquipNoInfo,"^",2)
	..s TempEquipID=""
	..&SQL(Select EQ_RowID into :TempEquipID From SQLUSER.DHC_EQEquip Where EQ_No=:SLEquipListNo)
	..i SQLCODE=100 s SQLCODE=0
	..i TempEquipID'="" s SQLCODE=-9002,ErrMsg=LIST(5)_"资产编号:"_SLEquipListNo_"重复！"
	..q:SQLCODE'=0
	..s ^DHCEQSplitList(SLRowid,"EX","EQNosInfo",(j-1))=SLEquipNoInfo	//czf 2021-08-02
	.q:SQLCODE'=0
	
	If SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,ErrMsg_"保存拆分明细失败！")
	}
	
	Set SQLCODE=..DeleteSplitList(DelRowid)
	If SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,rowid)
	}
	
	;更新主设备原值、累计折旧、净值
	s RtnObj=..AfterUpdateSList(rowid)
	s SQLCODE=RtnObj.SQLCODE
	If SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RtnObj.Data)
	}
	
	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,rowid)

ERRORUpdateData 
	TRollBack	
	Set ErrorMsg=$ZE	     			//得到系统返回的错误消息
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// Creator:	Add by czf 2020-11-29
/// Description:删除拆分单
/// Input:		rowid:拆分单rowid
/// 			User:用户ID
/// Output:		操作成功或失败Json串
/// w ##Class(web.DHCEQ.EM.BUSSplit).DeleteData("2")
ClassMethod DeleteData(rowid, User As %String = "")
{
	TStart
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	&SQL(Update SQLUSER.DHC_EQSplit Set S_InvalidFlag='Y' Where S_RowID=:rowid)
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
}

/// Creator:	Add by czf 2020-11-29
/// Description:删除拆分单明细记录
/// Input:		DelRowIDs:拆分明细单rowid串，逗号分隔
/// Output:		操作成功或失败标志 0：成功，其他：失败
/// w ##Class(web.DHCEQIFB).DeleteBPList(",0,0,0")
ClassMethod DeleteSplitList(DelRowIDs)
{
	new Length,SLRowID,Flag,i
	If DelRowIDs="" Quit 0
	
	Set Flag=0
	Set Length=$Length(DelRowIDs,",")
	for i=1:1:Length
	{
		Quit:Flag'=0
		Set SLRowID=$Piece(DelRowIDs,",",i)
		If (SLRowID>0)
		{
			&SQL(delete from sqluser.DHC_EQSplitList where SL_RowID=:SLRowID)
			If SQLCODE Set Flag=SQLCODE
		}
	}
	Quit Flag
}

/// Creator:	Add by czf 2021-07-11
/// Description:提交
/// Input:		val:审批信息串(拆分单ID^用户ID^CancelToFlowDR^审批意见^意见备注^拒绝原因^RoleStep^ActionID)
/// Output:		操作成功或失败Json串
/// w ##Class(web.DHCEQ.EM.BUSSplit).SubmitData(1^78^^^")
ClassMethod SubmitData(val)
{
	New BrlDR,PriceFee,MaxPrice
	Kill PLIST
	Set RowID=$Piece(val,"^",1)
	i RowID="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-2015,"单据ID不能为空!")
	
	s InvalidFlag=$p($g(^DHCEQSplit(RowID)),"^",27)
	i InvalidFlag="Y" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-2015,"该记录状态不符合,不能执行操作!")
	s SplitOriginalFee=+$p($g(^DHCEQSplit(RowID)),"^",28)
	s SISKeepFlag=$p($g(^DHCEQSplit(RowID)),"^",19)
	;不保留主设备
	i (SISKeepFlag="N")&&(SplitOriginalFee>0)
	{
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1008,"主设备原值大于0,不能无效!")
	}
	
	s Status=$Piece($G(^DHCEQSplit(RowID)),"^",22)
	if Status'="0" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-2015,"该记录状态不符合,不能执行操作!")
	
	Set $ZT="ERRORSubmitData"
	Set User=$Piece(val,"^",2)
	i User="" Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set Date=+$H
 	Set Time=$Piece($H,",",2)
 	
 	Set EquipType=$Piece($Get(^DHCEQSplit(RowID)),"^",8)
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("36")
	Set ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipType, "", "", "", "N", "")
	If ApproveSet="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-2015,"审批设置不存在!")
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
		Set PLIST(26)=	User	// S_AuditUserDR
		Set PLIST(27)=	Date	// S_AuditDate
	}
	Set ApproveInfoID=$Order(^DHCEQApproveInfo(0,"SourceID",ApproveType,RowID,0))
	
	TSTART
	Set SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,RowID,"36",User)
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
	Set PLIST(23)=AppInfoStatus		;S_Status
	&SQL(Update SQLUSER.DHC_EQSplit Values :PLIST() where S_RowID=:RowID)
	if SQLCODE
	{
	 	TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	;保存操作日志
	s OperateInfo="^55^"_RowID_"^"_User_"^^1"
 	s RtnCode=##Class(web.DHCEQ.Plat.BUSOperateLog).SaveData(OperateInfo,"3")
	i $p(RtnCode,"^",1)'=0
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"操作信息保存失败!")
	}
	;最后一步,需要调用审核方法
	If AuditFlag=1
	{
		Set RtnMsg=##Class(web.DHCEQ.EM.BUSSplit).LastAuditAction(RowID,User)
		Set RtnMsgObj=##class(web.DHCEQ.Plat.JsonObject).FromJSON(RtnMsg)
		If RtnMsgObj.SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(RtnMsgObj.SQLCODE,RtnMsgObj.Data)
		}		
	}
	Set SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("55", RowID, User, ApproveFlow_"^"_ApproveSet, "N", "", AuditFlag)
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

/// Creator:	add by czf 2021-07-11
/// Description:取消提交
/// Input:		val:审批信息串(拆分单ID^用户ID^CancelToFlowDR^审批意见^意见备注^拒绝原因^RoleStep^ActionID)
/// 			CurRole:当前审批角色ID
/// Output:		操作成功或失败Json串
/// w ##Class(web.DHCEQIFB).CancelSubmitData("8^1^")
ClassMethod CancelSubmitData(val As %Library.String = "", CurRole As %Library.String = "")
{
	Set RowID=$Piece(val,"^",1)
	Quit:RowID="" ""
	
	Set $ZT="ERRORCancelSubmitData"
	Set User=$Piece(val,"^",2)
	i User="" Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set Date=+$H
 	Set Time=$Piece($H,",",2)
	Set CancelToFlowDR=$Piece(val,"^",3)
	Set RejectReason=$Piece(val,"^",6)
	
	;获取取消到上一步的信息
	Set Status="0"
	Set ApproveRoleDR=""
	Set Step=""
	Set ApproveFlow=""
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("36")
	Set ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("36", RowID)
	If ApproveSet="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-2015,"审批设置不存在!")
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
		s ApproveFlow="^^^^^^^^"_ApproveSet
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
	Set PLIST(23)=	Status	// S_Status

	&sql(Update SQLUSER.DHC_EQSplit Values :PLIST() where S_RowID=:RowID)
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	;保存操作日志
	s OperateInfo="^55^"_RowID_"^"_User_"^^5"
 	s RtnCode=##Class(web.DHCEQ.Plat.BUSOperateLog).SaveData(OperateInfo,"3")
	i $p(RtnCode,"^",1)'=0
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"操作信息保存失败!")
	}
	Set SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("55", RowID, User, ApproveFlow_"^"_ApproveSet, "Y", CurRole)
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

/// Creator:	add by czf 2021-07-11
/// Description:审核操作
/// Input:		val:审批信息串(拆分单ID^用户ID^CancelToFlowDR^审批意见^意见备注^拒绝原因^RoleStep^ActionID)
/// 			CurRole:当前审批角色ID
/// 			RoleStep：当前角色审批步骤
/// 			editFieldsInfo:可编辑字段
/// Output:		操作成功或失败Json串
/// w ##Class(web.DHCEQ.EM.BUSSplit).AuditData("12^78^^同意^^^1^","14","1","")
ClassMethod AuditData(val As %Library.String = "", CurRole As %Library.String = "", RoleStep As %Library.String = "", editFieldsInfo As %Library.String = "")
{
	n SRowID,Status,ApproveType,ApproveSet,ApproveFlow,AuditFlag
	Set SRowID=$Piece(val,"^",1)
	i SRowID="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-2015,"单据ID不能为空!")
	
	s Status=$Piece($G(^DHCEQSplit(SRowID)),"^",22)
	if Status'="1" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-2015,"该记录状态不符合,不能执行操作!")
	
	;校验主设备是否存在未完成转移，调账，报废，退货，减少单
	
	Set $ZT="ERRORAuditData"
	Set User=$Piece(val,"^",2)
	Set updDate=+$H
 	Set updTime=$Piece($H,",",2)
 	Set Opinion=$Piece(val,"^",4)
	Set Remark=$Piece(val,"^",5)
	
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("36")
	Set ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("36", SRowID)	
	If ApproveSet="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-2015,"审批设置不存在!")
	Set ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, SRowID, RoleStep, CurRole)
	
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
		Set PLIST(23)=	2		// S_Status
		Set PLIST(26)=	User	// S_AuditUserDR
		Set PLIST(27)=	updDate	// S_AuditDate
		&sql(Update SQLUSER.DHC_EQSplit Values :PLIST() where S_RowID=:SRowID)
		If SQLCODE
		{
		 	TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		;保存操作日志
		s OperateInfo="^55^"_SRowID_"^"_User_"^^2"
	 	s RtnCode=##Class(web.DHCEQ.Plat.BUSOperateLog).SaveData(OperateInfo,"3")
		i $p(RtnCode,"^",1)'=0
		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"操作信息保存失败!")
		}
		
		Set AppInfoStatus="2"	;Status
	}
	;生成审批记录
	Set SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,SRowID,Opinion,"",CurRole,RoleStep,User)
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	;记录单据当前审批状态
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,SRowID,NextRole,NextStep,RoleStep,CurRole,AppInfoStatus)
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
		Set SQLCODE=##Class(web.DHCEQCApproveAction).DoActions(SRowID,User,Actions)
		If SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	
	;最后一步,需要调用审核方法
	If AuditFlag=1
	{
		Set RtnMsg=##Class(web.DHCEQ.EM.BUSSplit).LastAuditAction(SRowID,User)
		Set RtnMsgObj=##class(web.DHCEQ.Plat.JsonObject).FromJSON(RtnMsg)
		If RtnMsgObj.SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(RtnMsgObj.SQLCODE,RtnMsgObj.Data)
		}		
	}
	
	Set SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("55", SRowID, User, ApproveFlow_"^"_ApproveSet, "N", CurRole, AuditFlag)
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	TCOMMIT
	
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,SRowID)
ERRORAuditData 
	TRollBack	
	Set ErrorMsg=$ZE	     			//得到系统返回的错误消息
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)	//返回错误消息
}

/// Creator:	add by czf 2021-07-11
/// Description:最终审核时需调用此方法
/// Input:		SRowID:拆分主单ID
/// 				User:用户ID
/// Output:		操作成功或失败Json串
/// w ##Class(web.DHCEQ.EM.BUSSplit).LastAuditAction(5)
ClassMethod LastAuditAction(SRowID, User)
{
	n SLRowID
	s Date=+$h
	s Time=$p($h,",",2)
	i User="" Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	
	;检测拆分单主设备原值、累计折旧与台账是否相等,防止跨月审核
	s SEquipDR=$p($g(^DHCEQSplit(SRowID)),"^",2)
	s SOriginalFee=$p($g(^DHCEQSplit(SRowID)),"^",3)
	s SDepreTotalFee=$p($g(^DHCEQSplit(SRowID)),"^",4)
	s SNetFee=$p($g(^DHCEQSplit(SRowID)),"^",5)
	s SplitOriginalFee=$p($g(^DHCEQSplit(SRowID)),"^",28)
	s SplitDepreTotalFee=$p($g(^DHCEQSplit(SRowID)),"^",29)
	s SplitNetFee=$p($g(^DHCEQSplit(SRowID)),"^",30)
	s SEquipTypeDR=$p($g(^DHCEQSplit(SRowID)),"^",8)
	s SStatCatDR=$p($g(^DHCEQSplit(SRowID)),"^",9)
	s SISKeepFlag=$p($g(^DHCEQSplit(SRowID)),"^",19)	//czf 2021-08-19
	s SLocDR=$p($g(^DHCEQSplit(SRowID)),"^",11)
	s SJob=$p($g(^DHCEQSplit(SRowID)),"^",31)
	s EQNo=$p($g(^DHCEQEquip(SEquipDR)),"^",71)
	s EQOriginalFee=$p($g(^DHCEQEquip(SEquipDR)),"^",27)
	s EQDepreTotalFee=$p($g(^DHCEQEquip(SEquipDR)),"^",35)
	s EQNetFee=$p($g(^DHCEQEquip(SEquipDR)),"^",28)
	s EQNetRemainFee=$p($g(^DHCEQEquip(SEquipDR)),"^",29)
	s EQStoreLocDR=$p($g(^DHCEQEquip(SEquipDR)),"^",67)
	s EQEquipTypeDR=$p($g(^DHCEQEquip(SEquipDR)),"^",63)
	s EQStatCatDR=$p($g(^DHCEQEquip(SEquipDR)),"^",75)
	s EQOriginDR=$p($g(^DHCEQEquip(SEquipDR)),"^",20)
	s RemainFeeRate=##class(web.DHCEQCommon).GetSysInfo("990029")
	s EQManageLocDR=$p($g(^DHCEQEquip(SEquipDR)),"^",17)  //Modefied by zc0131 2023-03-08 管理部门取值
	i $fn(SOriginalFee,"",2)'=$fn(EQOriginalFee,"",2) q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1003,"主设备原值已变动，无法审核!")
	i $fn(SDepreTotalFee,"",2)'=$fn(EQDepreTotalFee,"",2) q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1003,"主设备累计折旧已变动，无法审核!")
	i $fn(SNetFee,"",2)'=$fn(EQNetFee,"",2) q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1003,"主设备净值已变动，无法审核!")
	i SEquipTypeDR'=EQEquipTypeDR q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1003,"设备类组已变动，无法审核!")
	i SStatCatDR'=EQStatCatDR q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1003,"设备类型已变动，无法审核!")
	i SLocDR'=EQStoreLocDR q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1003,"设备科室已变动，无法审核!")
	
	;拆后设备插入台账，并生成新增数据调整记录
	s SQLCODE=0
	k ^TEMPDHCEQ("DHCEQAdjustDataList")
	s AdjustData="2^true^无^无^"_EQNo_"设备拆分^"_##class(web.DHCEQCommon).GetTrakNameByID("user",User)_"^^true^1"
	s ADRowID=##class(web.DHCEQAdjustData).SaveAdjustData("",AdjustData,User)
	i ADRowID<0
	{
		s SQLCODE=ADRowID
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"调整单保存失败!")
	}
	s NetRemainRate=##class(web.DHCEQCommon).GetSysInfo("990029")
	s Flag=0
	s ErrMsg=""
	s EQObject = ##class(User.DHCEQEquip).%OpenId(SEquipDR)
	s EQObj = ##class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(EQObject)
	k EQPLIST
	s EQPLIST=##class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQEquip",EQObj,.EQPLIST)
	s RowCount=0
	s SLRowID = 0
	f  s SLRowID = $o(^DHCEQSplitList(0,"Split",SRowID,SLRowID)) q:(SLRowID="")||(Flag'=0)  d
	.s EquipIDs=""
	.s SLEquipNo = $p($g(^DHCEQSplitList(SLRowID)),"^",3)
	.s SLEquipName = $p($g(^DHCEQSplitList(SLRowID)),"^",4)
	.s SLOriginalFee = $p($g(^DHCEQSplitList(SLRowID)),"^",5)
	.s SLDepreTotalFee = $p($g(^DHCEQSplitList(SLRowID)),"^",6)
	.s SLNetFee = $p($g(^DHCEQSplitList(SLRowID)),"^",7)
	.s SLLeaveFactoryNo = $p($g(^DHCEQSplitList(SLRowID)),"^",8)
	.s SLFileNo = $p($g(^DHCEQSplitList(SLRowID)),"^",9)
	.s SLItemDR = $p($g(^DHCEQSplitList(SLRowID)),"^",10)
	.s SLEquipTypeDR = $p($g(^DHCEQSplitList(SLRowID)),"^",11)
	.s SLStatCatDR = $p($g(^DHCEQSplitList(SLRowID)),"^",12)
	.s SLEquipCatDR = $p($g(^DHCEQSplitList(SLRowID)),"^",13)
	.s SLLocDR = $p($g(^DHCEQSplitList(SLRowID)),"^",14)
	.s SLLimitYearsNum = $p($g(^DHCEQSplitList(SLRowID)),"^",15)
	.s SLDepreMethodDR = $p($g(^DHCEQSplitList(SLRowID)),"^",16)
	.s SLManuFactoryDR = $p($g(^DHCEQSplitList(SLRowID)),"^",17)
	.s SLModelDR = $p($g(^DHCEQSplitList(SLRowID)),"^",18)
	.s SLLocationDR = $p($g(^DHCEQSplitList(SLRowID)),"^",19)
	.s SLQuantityNum = $p($g(^DHCEQSplitList(SLRowID)),"^",21)
	.;s EQPLIST(72)=SLEquipNo
	.s EQPLIST(2)=SLEquipName
	.s EQPLIST(28)=SLOriginalFee
	.s EQPLIST(36)=SLDepreTotalFee
	.s EQPLIST(29)=SLNetFee
	.;s EQPLIST(11)=SLLeaveFactoryNo
	.;s EQPLIST(86)=SLFileNo
	.s EQPLIST(8)=SLItemDR
	.s EQPLIST(64)=SLEquipTypeDR
	.s EQPLIST(76)=SLStatCatDR
	.s EQPLIST(5)=SLEquipCatDR
	.s EQPLIST(68)=SLLocDR
	.s EQPLIST(20)=SLLocDR
	.s EQPLIST(30)=##Class(web.DHCEQCommon).FormatNumber(SLOriginalFee*RemainFeeRate/100,"",2)	;NetRemainFee
	.s EQPLIST(32)=SLLimitYearsNum
	.s EQPLIST(33)=""
	.s EQPLIST(34)=SLDepreMethodDR
	.s EQPLIST(27)=SLManuFactoryDR
	.s EQPLIST(4)=SLModelDR
	.s EQPLIST(73)=SLLocationDR
	.s EQPLIST(48)="Y"		;EQInputFlag
	.s EQPLIST(53)=User		;EQAddUser
	.s EQPLIST(54)=Date		;EQAddDate
	.s EQPLIST(55)=Time		;EQAddTime
	.s EQPLIST(56)=User		;EQUpdateUser
	.s EQPLIST(57)=Date		;EQUpdateDate
	.s EQPLIST(58)=Time		;EQUpdateTime
	.s EQPLIST(71)=""		;EQInStockListDR
	.s EQPLIST(78)=""		;EQOpenCheckListDR
	.s EQPLIST(33)=""		;EQContractListDR
	.s EQPLIST(18)=EQManageLocDR   //Modefied by zc0131 2023-03-08  管理部门保存
	.f ii=1:1:SLQuantityNum d
	..s SLEquipInfo=$g(^DHCEQSplitList(SLRowID,"EX","EQNosInfo",(ii-1))) 	//czf 2021-08-02
	..i $p(SLEquipInfo,"^",2)="" s Flag=-1006,ErrMsg="拆分设备:"_SLEquipNo_"明细编号未生成!"
	..q:Flag'=0
	..s EQPLIST(72)=$p(SLEquipInfo,"^",2)
	..s EQPLIST(11)=$p(SLEquipInfo,"^",3)
	..s EQPLIST(86)=$p(SLEquipInfo,"^",4)
	..&SQL(Insert Into SQLUSER.DHC_EQEquip Values :EQPLIST())
	..i SQLCODE s Flag=-1005,ErrMsg="拆分设备:"_SLEquipNo_"插入台账失败,错误原因:"_%msg
	..q:Flag'=0
	..s EQRowID=$g(%ROWID)
	..i EquipIDs'="" s EquipIDs=EquipIDs_","
	..s EquipIDs=EquipIDs_EQRowID
	..;生成设备资金来源
	..s RtnJson=..CreateSplitEquipFunds(SEquipDR,EQRowID,User)
	..s SQLCODE=RtnJson.SQLCODE
	..i SQLCODE s Flag=-1006,ErrMsg="拆分设备:"_SLEquipNo_RtnJson.Data
	..q:Flag'=0
	..;初始化折旧
	..i $o(^DHCEQDepreSet(0,"Source",1,0,EQRowID,0))'="" d
	...s LastMonth=##Class(web.DHCEQCommon).MonthStrAdd("M",-1,$p($zd(+$h,3),"-",1,2))
	...s LasMonthDay=##class(web.DHCEQCommon).GetMonthEndDate(LastMonth)
	...s SQLCODE=##Class(web.DHCEQMonthDepre).InitEquipDepre($zdh(LastMonth_"-"_LasMonthDay,3),"","","1","1",EQRowID)
	...i SQLCODE s Flag=-1007,ErrMsg="拆分设备:"_SLEquipNo_"初始化折旧失败!"
	..q:Flag'=0
	..;保存调整明细
	..s ADjustListInfo=ADRowID_"^"_EQRowID_"^^"_SLLocDR_"^"_SLEquipTypeDR_"^"_SLStatCatDR_"^"_EQOriginDR_"^^^^^^^^"
	..s SQLCODE=##class(web.DHCEQAdjustData).SaveAdjustDataList("",ADjustListInfo,0)
	..i SQLCODE s Flag=-1004,ErrMsg="拆分设备:"_SLEquipNo_"生成调整明细失败！"
	..q:Flag'=0
	.q:Flag'=0
	.s ^DHCEQSplitList(SLRowID,"EX","RowIDs")=EquipIDs
	
	i Flag q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(Flag,ErrMsg)
	
	;执行调整单
	s SQLCODE=##class(web.DHCEQAdjustData).ExecuteAdjustData(ADRowID,User)
	i SQLCODE q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"拆分设备:"_SLEquipNo_"执行调整单失败!")
	
	;生成主设备生命周期记录
	s SQLCODE=0
	k LIPLIST
	s LIPLIST(2)=SEquipDR  //设备
	s LIPLIST(4)=$p($g(^DHCEQEquip(SEquipDR)),"^",19)  //原使用科室
	s LIPLIST(5)=$p($g(^DHCEQEquip(SEquipDR)),"^",17)  //原管理科室
	s LIPLIST(6)=$p($g(^DHCEQEquip(SEquipDR)),"^",67)  //原库房
	s LIPLIST(7)=SOriginalFee  	//原值
	s LIPLIST(8)=SNetFee  		//原净值
	s LIPLIST(14)="设备拆分"  	//变动原因
	;s LIPLIST(15)=""	//变动描述
	s LIPLIST(16)=Date	//变动日期
	s LIPLIST(17)=Time	//变动时间
	s LIPLIST(19)="C"	//生命周期类型
	s LIPLIST(20)=55	//来源类型
	s LIPLIST(21)=SRowID	//来源ID
	s LIPLIST(23)=""  	//备注
	s LIPLIST(27)=User	//更新人
	s LIPLIST(28)=Date	//更新日期
	s LIPLIST(29)=Time	//更新时间
	s LIPLIST(9)=$p($g(^DHCEQEquip(SEquipDR)),"^",19)   //变动后使用科室
	s LIPLIST(10)=$p($g(^DHCEQEquip(SEquipDR)),"^",17) //变动后管理科室
	s LIPLIST(11)=$p($g(^DHCEQEquip(SEquipDR)),"^",67)  //变动后库房
	s LIPLIST(12)=SplitOriginalFee  //变动后原值
	s LIPLIST(13)=SplitNetFee  		//变动后净值
	&sql(Insert Into SQLUSER.DHC_EQLifeInfo Values :LIPLIST())
	i SQLCODE q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,EQNo_"生成主设备生命周期失败!错误信息:"_%msg)
	
	;生成主设备调账记录
	&SQL(Select CA_RowID from SQLUSER.DHC_EQChangeAccount Where CA_EquipDR=:SEquipDR and CA_Status<2)
	if (%ROWCOUNT>0)  q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1003,"主设备存在未完成调账记录，需删除未完成调账单!")
	k CAPLIST
	s SChangeFee = SplitOriginalFee-SOriginalFee	//变动金额
	s SChangeDepreFee = SplitDepreTotalFee-SDepreTotalFee	//变动累计折旧
	s CAPLIST(2) = SEquipDR	;EquipDR
	s CAPLIST(3) = SChangeFee	;ChangeFee
	s CAPLIST(4) = SplitOriginalFee	;ChangedOriginalFee
	s CAPLIST(5) = SplitNetFee		;ChangedNetFee
	s CAPLIST(6) = SplitDepreTotalFee	;TotalDepreFee
	s CAPLIST(9) = "拆分设备调账"		;ChangeReason
	s CAPLIST(10) = Date				;ChangeDate
	s CAPLIST(11) = "拆分设备调账"		;Remark
	s CAPLIST(12) = 0					;Status
	s CAPLIST(13) = User				;AddUser
	s CAPLIST(14) = Date				;AddDate
	s CAPLIST(15) = Time				;AddTime
	s CAPLIST(16) = User				;UpdateUser
	s CAPLIST(17) = Date				;UpdateDate
	s CAPLIST(18) = Time				;UpdateTime
	s CAPLIST(25) = SOriginalFee		;OriginalFee
	s CAPLIST(26) = SNetFee			;NetFee
	s CAPLIST(27) = EQNetRemainFee	;NetRemainFee
	//s CAPLIST(28) = ""				;ChangedNetRemainFee
	s CAPLIST(29) = SLocDR			;StoreLocDR
	s CAPLIST(30) = SLocDR			;UseLocDR
	s CAPLIST(31) = SEquipTypeDR		;EquipTypeDR
	s CAPLIST(32) = SStatCatDR		;StatCatDR
	//s CAPLIST(33) = ""	;Hold1		;EQStatus
	s CAPLIST(34) = SChangeDepreFee		;Hold2 调整的累计折旧
	//s CAPLIST(35) = ""				;Hold3	调整月份数

	&SQL(Insert Into SQLUSER.DHC_EQChangeAccount Values :CAPLIST())
	if SQLCODE q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,EQNo_"调账记录生成失败!错误信息:"_%msg)
	Set CAID=$g(%ROWID)
	
	;生成主设备调账资金来源记录
	s RemainChangeFee=SChangeFee
	s RemainChangeDepreFee=SChangeDepreFee
	s SFRowID=0
	f  s SFRowID=$o(^DHCEQFunds("0","Equip",SEquipDR,SFRowID)) q:((SFRowID="")||(SQLCODE'=0))  d
	.q:$p($g(^DHCEQFunds(SFRowID)),"^",10)="Y"
 	.s SEQFundsFee=+$p($g(^DHCEQFunds(SFRowID)),"^",3)
	.s SEQFDepreTotalFee=+$p($g(^DHCEQFunds(SFRowID)),"^",13)
	.s SFundsType=$p($g(^DHCEQFunds(SFRowID)),"^",2)
	.s SFinaceItemDR=$Piece($Get(^DHCEQFunds(SFRowID)),"^",20)	//核算项目
	.s SFunctionCatDR=$Piece($Get(^DHCEQFunds(SFRowID)),"^",21)	//功能分类
	.s SCAFundsFee=SEQFundsFee*SChangeFee/SOriginalFee		//按原资金来源比例计算调整的金额
	.s SCAFundsFee=##Class(web.DHCEQCommon).FormatNumber(SCAFundsFee,"",2)
	.s SCADepreFee=SEQFundsFee*SChangeDepreFee/SOriginalFee
	.s SCADepreFee=##Class(web.DHCEQCommon).FormatNumber(SCADepreFee,"",2)
	.s SCurFundFee=SCAFundsFee+SEQFundsFee
	.s SCurDepreFee=SCADepreFee+SEQFDepreTotalFee
	.i SCurFundFee<0 s SCAFundsFee=-SEQFundsFee		//若调后金额小于0，则调整金额为负的调前金额
	.i SCurDepreFee<0 s SCADepreFee=-SEQFDepreTotalFee	//调后累计折旧小于0，则调整金额为负的调前累计折旧
	.i SCurDepreFee>SCurFundFee s SCADepreFee=SCurFundFee-SEQFDepreTotalFee	 //调后累计折旧大于调后金额
	.i $ZABS(RemainChangeFee)<$ZABS(SCAFundsFee) s SCAFundsFee=RemainChangeFee	//取绝对值
	.i $ZABS(RemainChangeDepreFee)<$ZABS(SCADepreFee) s SCADepreFee=RemainChangeDepreFee	//取绝对值
	.s RemainChangeFee=RemainChangeFee-SCAFundsFee
	.s RemainChangeDepreFee=RemainChangeDepreFee-SCADepreFee
	.q:SCAFundsFee=0
	.k FPLIST
	.s FPLIST(3)=SFundsType
	.s FPLIST(4)=SCAFundsFee
	.s FPLIST(7)=0
	.s FPLIST(8)=User
	.s FPLIST(9)=Date
	.s FPLIST(10)=Time
	.s FPLIST(11)="N"
	.s FPLIST(14)=SCADepreFee
	.s FPLIST(15)=7
	.s FPLIST(16)=CAID
	.s FPLIST(19)=SEQFundsFee
	.s FPLIST(20)=SEQFDepreTotalFee
	.s FPLIST(21)=SFinaceItemDR
	.s FPLIST(22)=SFunctionCatDR
	.&SQL(Insert Into SQLUSER.DHC_EQFunds Values :FPLIST())
	.q:SQLCODE
	i SQLCODE q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,EQNo_"调账记录资金来源生成失败!")
	
	;审核主设备调账记录
	s RtnCode=##class(web.DHCEQChangeAccount).AuditData("","",CAID,User,5)
	i RtnCode<0 q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(RtnCode,EQNo_"调账记录审核失败!")
	
	;不保留主设备，主设备无效 czf 2021-08-19
	i SISKeepFlag="N"
	{
		i +SplitOriginalFee>0 q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1008,EQNo_"原值大于0,不能无效!")
		&SQL(Update SQLUSER.DHC_EQEquip Set EQ_InvalidFlag='Y',EQ_Remark='拆分不保留原设备' where EQ_RowID=:SEquipDR)
		i SQLCODE q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,EQNo_"无效失败!")
	}
	k ^DHCEQTempSplitList(0,"EQNosInfo","EX",SJob,User,EQNo)	//czf 2021-08-04
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
}

/// Creator:	add by czf 2021-07-28
/// Description:根据主设备资金来源比例生成拆分设备资金来源信息
/// Input:		MainEquipID：主设备ID
/// 			SLEquipID：明细设备ID
/// Ouput:		操作信息Json对象
/// Command:w ##class(web.DHCEQ.EM.BUSSplit).CreateSplitEquipFunds(16)
ClassMethod CreateSplitEquipFunds(MainEquipID, SLEquipID, User)
{
	n (MainEquipID,SLEquipID,User,FundsRowID)
	s SQLCODE=0
	i (MainEquipID="")||(SLEquipID="") q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000","主设备ID或明细设备ID不能为空!",1)
	s Date=+$h
	s Time=$p($h,",",2)
	i User="" Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	
	s MainOriginalFee=+$p($g(^DHCEQEquip(MainEquipID)),"^",27)
	s MainDepreTotalFee=+$p($g(^DHCEQEquip(MainEquipID)),"^",35)
	s MainNetFee=+$p($g(^DHCEQEquip(MainEquipID)),"^",28)
	s SLEQOriginalFee=+$p($g(^DHCEQEquip(SLEquipID)),"^",27)
	s SLEQDepreTotalFee=+$p($g(^DHCEQEquip(SLEquipID)),"^",35)
	s SLEQNetFee=$p($g(^DHCEQEquip(SLEquipID)),"^",28)
	s RemainFee=SLEQOriginalFee
	s RemainDepreFee=SLEQDepreTotalFee
	
	s FundsRowID=0
	f  s FundsRowID=$o(^DHCEQFunds("0","Equip",MainEquipID,FundsRowID)) q:((FundsRowID="")||(SQLCODE'=0))  d
	.q:$p($g(^DHCEQFunds(FundsRowID)),"^",10)="Y"
 	.s MainEQFundsFee=+$p($g(^DHCEQFunds(FundsRowID)),"^",3)
	.s MainEQFDepreTotalFee=+$p($g(^DHCEQFunds(FundsRowID)),"^",13)
	.s MainFundsType=$p($g(^DHCEQFunds(FundsRowID)),"^",2)
	.s MainFinaceItemDR=$Piece($Get(^DHCEQFunds(FundsRowID)),"^",20)	//核算项目
	.s MainFunctionCatDR=$Piece($Get(^DHCEQFunds(FundsRowID)),"^",21)	//功能分类
	.s SLEQFundsFee=MainEQFundsFee*SLEQOriginalFee/MainOriginalFee
	.s SLEQFundsFee=##Class(web.DHCEQCommon).FormatNumber(SLEQFundsFee,"",2)
	.i RemainFee<SLEQFundsFee s SLEQFundsFee=RemainFee	//防止金额溢出
	.q:SLEQFundsFee=0
	.i SLEQOriginalFee'=0 d	//按拆分设备资金来源金额比例计算资金来源累计折旧
	..s SLEQFDepreTotalFee=SLEQFundsFee*SLEQDepreTotalFee/SLEQOriginalFee
	..s SLEQFDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber(SLEQFDepreTotalFee,"",2)
	.e  s SLEQFDepreTotalFee=0
	.i RemainDepreFee<SLEQFDepreTotalFee s SLEQFDepreTotalFee=RemainDepreFee
	.k FPLIST
	.s FPLIST(2)=SLEquipID
	.s FPLIST(3)=MainFundsType
	.s FPLIST(4)=SLEQFundsFee
	.s FPLIST(7)=0
	.s FPLIST(8)=User
	.s FPLIST(9)=Date
	.s FPLIST(10)=Time
	.s FPLIST(11)="N"
	.s FPLIST(14)=SLEQFDepreTotalFee
	.s FPLIST(15)=1
	.s FPLIST(16)=SLEquipID
	.s FPLIST(21)=MainFinaceItemDR
	.s FPLIST(22)=MainFunctionCatDR
	.s SLFRowID=""
	.&SQL(Insert Into SQLUSER.DHC_EQFunds Values :FPLIST())
	.q:SQLCODE'=0
	.s RemainFee=RemainFee-SLEQFundsFee
	.s RemainDepreFee=RemainDepreFee-SLEQFDepreTotalFee
	
	i SQLCODE q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"资金来源生成错误!",1)
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"",1)
}

/// Creator:	add by czf 2021-07-28
/// Description:回写主表拆分后原值，拆后累计折旧，拆后净值
/// Input:		SRowID 拆分单RowID
/// Ouput:		操作信息Json对象
/// Command:w ##class(web.DHCEQ.EM.BUSSplit).AfterUpdateSList(16)
ClassMethod AfterUpdateSList(SRowID)
{
	s (TotalOriginalFee,TotalDepreFee)=0
	&SQL(Select sum(SL_OriginalFee*SL_QuantityNum) into:TotalOriginalFee  from SQLUSER.DHC_EQSplitList where SL_SplitDR = :SRowID)
	&SQL(Select sum(SL_DepreTotalFee*SL_QuantityNum) into:TotalDepreFee from SQLUSER.DHC_EQSplitList where SL_SplitDR = :SRowID)
	s SSplitOriginalFee=$p($g(^DHCEQSplit(SRowID)),"^",3)-TotalOriginalFee
	i SSplitOriginalFee<0 q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9000,"主设备调后原值不能小于0!")
	s SSplitDepreTotalFee=$p($g(^DHCEQSplit(SRowID)),"^",4)-TotalDepreFee
	i SSplitDepreTotalFee<0 q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9000,"主设备调后累计折旧不能小于0!")
	s SSplitNetFee=SSplitOriginalFee-SSplitDepreTotalFee
	&SQL(Update SQLUSER.DHC_EQSplit Set S_SplitOriginalFee=:SSplitOriginalFee,S_SplitDepreTotalFee =:SSplitDepreTotalFee,S_SplitNetFee=:SSplitNetFee where S_RowID = :SRowID)
	
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"",1)
}

/// Creator：add by czf 2021-07-05
/// CreateDate：拆分明细设备信息
/// Input： MainEquipNo:主设备编码
/// 		SourceID:拆分单RowID
/// 		QuantityNum:拆分明细数量，必填
/// 		Job:拆分单Job，必填
/// 		index:拆分明细行号，必填
/// Output：
/// Command：d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSSplit","GetEquipsBySplit","3222206000005","12","","33252","0")
Query GetEquipsBySplit(MainEquipNo, SourceID As %String, QuantityNum As %String, Job As %String, Index As %String) As %Query(ROWSPEC = "TRowID:%String,TEquipNo:%String,TLeavefactoryNo:%String,TRow:%String,TJob:%String,TFileNo:%String")
{
}

ClassMethod GetEquipsBySplitExecute(ByRef qHandle As %Binary, MainEquipNo, SourceID As %String, QuantityNum As %String, Job As %String, Index As %String) As %Status
{
	new repid, index, rowid
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	i (QuantityNum="")||(Index="")||(MainEquipNo="") Quit $$$OK
	s TRow=0
 	s TJob=Job
 	i TJob="" Quit $$$OK
 	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	
 	if (SourceID'="")&&($g(^DHCEQSplitList(SourceID,"EX","RowIDs"))'="")
 	{
	 	s TEquipIDs=$g(^DHCEQSplitList(SourceID,"EX","RowIDs"))
	 	f i=1:1:$l(TEquipIDs,",") d
	 	.d ResetGetEquipsBySplit
	 	.s TEquipDR=$p(TEquipIDs,",",i)
	 	.q:TEquipDR=""
		.s TEquipNo=$p($g(^DHCEQEquip(TEquipDR)),"^",71)
		.s TLeavefactoryNo=$p($g(^DHCEQEquip(TEquipDR)),"^",10)
		.s TFileNo=$p($g(^DHCEQEquip(TEquipDR)),"^",85)
		.d OutputRowGetEquipsBySplit
	}
	else
	{
	 	f i=1:1:QuantityNum
	 	{
		 	i SourceID=""
		 	{
			 	if $d(^DHCEQTempSplitList(0,"EQNosInfo",Job,User,MainEquipNo,Index))		//czf 2021-08-04
			 	{
				 	d ResetGetEquipsBySplit
				 	s EQNosInfo=$g(^DHCEQTempSplitList(0,"EQNosInfo",Job,User,MainEquipNo,Index,i-1))
					s TEquipDR=$p(EQNosInfo,"^",1)
					s TEquipNo=$p(EQNosInfo,"^",2)
					i TEquipNo="" s TEquipNo=MainEquipNo_##class(web.DHCEQCCounter).LPAD(Index+1,"0",2)_##class(web.DHCEQCCounter).LPAD(i,"0",2)	;SL_EquipNo
					s TLeavefactoryNo=$p(EQNosInfo,"^",3)
					s TFileNo=$p(EQNosInfo,"^",4)
					d OutputRowGetEquipsBySplit
				}
				else
				{
				 	d ResetGetEquipsBySplit
				 	s TEquipNo=##class(web.DHCEQCCounter).GetNextNo("DHC_EQSplitEquip",+$h,"","","","","","",MainEquipNo)	//MainEquipNo_##class(web.DHCEQCCounter).LPAD(Index+1,"0",2)_##class(web.DHCEQCCounter).LPAD(i,"0",2)	;SL_EquipNo
				 	d OutputRowGetEquipsBySplit
				}
			}
			else{
				d ResetGetEquipsBySplit
				s EQNosInfo=$g(^DHCEQTempSplitList(0,"EQNosInfo","EX",Job,User,MainEquipNo,SourceID,i-1))
				s TEquipDR=$p(EQNosInfo,"^",1)
				s TEquipNo=$p(EQNosInfo,"^",2)
				i TEquipNo="" s TEquipNo=##class(web.DHCEQCCounter).GetNextNo("DHC_EQSplitEquip",+$h,"","","","","","",MainEquipNo)	;SL_EquipNo
				s TLeavefactoryNo=$p(EQNosInfo,"^",3)
				s TFileNo=$p(EQNosInfo,"^",4)
				d OutputRowGetEquipsBySplit
			}
		}
	}
	
	Quit $$$OK
	
ResetGetEquipsBySplit
	set (TEquipDR,TEquipNo,TLeavefactoryNo,TFileNo,EQNosInfo)=""
	quit
OutputRowGetEquipsBySplit
	s TRow=TRow+1
	set Data=$lb(TEquipDR,TEquipNo,TLeavefactoryNo,TRow,TJob,TFileNo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetEquipsBySplitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipsByMoveExecute ]
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

ClassMethod GetEquipsByMoveGetEquipsBySplitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipsBySplitExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:	add by czf 2021-07-11
/// Description:修改设备出厂编号
/// Input:		"设备ID1^出厂编号1$CHAR(3)设备ID2^出厂编号2"
/// Ouput:		操作成功或失败标志 成功:0 失败:其他
/// Command:w ##class(web.DHCEQ.EM.BUSSplit).UpdateLeaveFactoryNo(16)
ClassMethod UpdateLeaveFactoryNo(val)
{
	new (val,EquipDR)
	q:val=""
	s SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")
	s Length=$L(val,SplitRowCode)
	s Flag=0
	TStart
	for i=1:1:Length
 	{
	 	q:Flag'=0
		s Info=$P(val,",",i)
		s EquipDR=$P(Info,"^",1)
		s LeaveFactoryNo=$P(Info,"^",2)
		&SQL(Update SQLUSER.DHC_EQEquip set EQ_LeaveFactoryNo=:LeaveFactoryNo where EQ_RowID=:EquipDR)
		if SQLCODE s Flag=SQLCODE
 	}
 	if Flag'=0 TROLLBACK
	TCommit
	q Flag
}

/// Creator:	add by czf 2021-07-11
/// Description:根据列表操作，拆分设备信息存到临时global
/// Input:		val:TRowID+"^"+TEquipNo+"^"+TLeaveFactoryNo+"^"+TFileNo;
/// 	  		MXInfo:Job+"^"+Index+"^"+Num+"^"+SourceID+"^"+Type
/// Ouput:		操作成功或失败标志 成功:0 失败:其他
/// ommand:	w ##class(web.DHCEQ.EM.BUSSplit).UpdateEquipsByList("^20102000000110301^lc032^fileno002","32868^2^0^^1","77")
ClassMethod UpdateEquipsByList(val, MXInfo, User As %String = "")
{
	new Job,Index,Num,SourceID,EquipNo
	q:MXInfo="" 0
	i User="" Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Job=$p(MXInfo,"^",1)
	s Index=$p(MXInfo,"^",2)
	s Num=$p(MXInfo,"^",3)
	s SourceID=$p(MXInfo,"^",4)
	s EquipNo=$p(MXInfo,"^",6)
	i SourceID=""
	{
		s ^DHCEQTempSplitList(0,"EQNosInfo",Job,User,EquipNo,Index,Num)=val		//czf 2021-08-04
	}
	else
	{
		s ^DHCEQTempSplitList(0,"EQNosInfo","EX",Job,User,EquipNo,SourceID,Num)=val
	}
	q 0
}

}
