Import SQLUser

/// 创建人:Mozy 2023-2-14
/// 凭证
Class web.DHCEQ.EM.BUSAccountNo Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetStatus(Status)
{
	Quit $CASE(Status,"0":"新增","1":"提交","2":"审核","3":"作废",:"没有定义")
}

/// Description:   凭证明细来源类型
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSAccountNo","GetAccountNoSourceType")
Query GetAccountNoSourceType() As %Query(ROWSPEC = "TDesc:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod GetAccountNoSourceTypeExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
 	s index=1
	;CustomValue="1^入库单&2^转移单&3^减少单";
	s rowid=1
	s Code="01"
	s Desc="入库单"
	d OutputRowGetAccountNoSourceType
	s rowid=2
	s Code="02"
	s Desc="转移单"
	;d OutputRowGetAccountNoSourceType
	s rowid=3
	s Code="03"
	s Desc="减少单"
	d OutputRowGetAccountNoSourceType
	Quit $$$OK
OutputRowGetAccountNoSourceType
	Set Data=$lb(Desc,rowid,Code)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetAccountNoSourceTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAccountNoSourceTypeExecute ]
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

ClassMethod GetAccountNoSourceTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAccountNoSourceTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Description:   凭证明细来源
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSAccountNo","GetAccountNoSource",1,"","","",23)
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSAccountNo","GetAccountNoSource",3,"","","",157)
Query GetAccountNoSource(SourceType As %String = "", SourceDesc As %String = "", SourceID As %String = "", ANLRowID As %String = "", ProviderDR As %String = "") As %Query(ROWSPEC = "TSourceID:%String,TNo:%String,TDate:%String,TEquipName:%String,TManuFactory:%String,TTotalNum:%String,TTotalFee:%String,TBuyLoc:%String,TRemark:%String")
{
}

ClassMethod GetAccountNoSourceExecute(ByRef qHandle As %Binary, SourceType As %String = "", SourceDesc As %String = "", SourceID As %String = "", CTLRowID As %String = "", ProviderDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set SourceID=""
 	;Set ^DHCEQMozy("GetAccountNoSource")=SourceType_","_SourceDesc_","_SourceID_","_CTLRowID_","_ProviderDR
	Set index=1
	i SourceType=1
	{
		;1^入库单
		Set rowid=0
		For  Set rowid=$Order(^DHCEQInStock(0,"Provider",ProviderDR,rowid)) Quit:rowid=""  Do
		.Do ResetAccountNoSource
		.Quit:$Piece($Get(^DHCEQInStock(rowid)),"^",25)="Y"
		.Set TEquipTypeDR=$Piece($Get(^DHCEQInStock(rowid)),"^",20)
		.Quit:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
		.Set TEquipType=##class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)
		.Quit:($Piece($Get(^DHCEQInStock(rowid)),"^",10)'=2)
		.Quit:##Class(web.DHCEQ.EM.BUSAccountNo).CheckSourceIDIsInValid(1,rowid,SourceID)
		.
		.Set TNo=$Piece($Get(^DHCEQInStock(rowid)),"^",14)
		.Quit:(SourceDesc'="")&($ZCONVERT(TNo,"U")'[SourceDesc)
		.Set TDate=$Piece($Get(^DHCEQInStock(rowid)),"^",1)
		.Set TDate=##class(web.DHCEQCommon).TransValueToPage(TDate,"date")
		.
		.Set TTotalNum=0
		.Set TTotalFee=0
		.Set ISLRowid=0
		.For  Set ISLRowid=$Order(^DHCEQInStockList(0,"InStock",rowid,ISLRowid)) Quit:ISLRowid=""  Do
		..If TEquipName'="" Set TEquipName=TEquipName_","
		..Set TEquipName=TEquipName_$Piece($Get(^DHCEQInStockList(ISLRowid)),"^",5)
		..Set TManuFactoryDR=$Piece($Get(^DHCEQInStockList(ISLRowid)),"^",6)
		..If TManuFactoryDR'="" Do
		...If TManuFactory'="" Set TManuFactory=TManuFactory_","
		...Set TManuFactory=TManuFactory_##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)
		..Set TOriginalFee=+$Piece($Get(^DHCEQInStockList(ISLRowid)),"^",7)
		..Set TQuantityNum=+$Piece($Get(^DHCEQInStockList(ISLRowid)),"^",8)
		..Set TTotalNum=TTotalNum+TQuantityNum
		..Set TTotalFee=TTotalFee+(TOriginalFee*TQuantityNum)
		.
		.Set TRemark=$Piece($Get(^DHCEQInStock(rowid)),"^",11)
		.Set TBuyLocDR=$Piece($Get(^DHCEQInStock(rowid)),"^",18)
		.If TBuyLocDR'="" Set TBuyLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept", TBuyLocDR)
		.If TBuyLoc'="" Set TBuyLoc=##class(web.DHCEQCommon).GetSplitDataByFlag(TBuyLoc,"-")
		.
		.Do OutputRowAccountNoSource
	}
	elseif SourceType=2
	{
		;2^转移单

	}
	elseif SourceType=3
	{
		;3^减少单
		Set rowid=0
		For  Set rowid=$Order(^DHCEQReturn(0,"Provider",ProviderDR,rowid)) Quit:rowid=""  Do
		.Do ResetAccountNoSource
		.Quit:$Piece($Get(^DHCEQReturn(rowid)),"^",28)="Y"
		.Set TEquipTypeDR=$Piece($Get(^DHCEQReturn(rowid)),"^",15)
		.Quit:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
		.Set TEquipType=##class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)
		.Quit:($Piece($Get(^DHCEQReturn(rowid)),"^",13)'=2)
		.Quit:($Piece($Get(^DHCEQReturn(rowid)),"^",17)'=1)
		.Quit:##Class(web.DHCEQ.EM.BUSAccountNo).CheckSourceIDIsInValid(3,rowid,SourceID)
		.Set TNo=$Piece($Get(^DHCEQReturn(rowid)),"^",1)
		.Quit:(SourceDesc'="")&($ZCONVERT(TNo,"U")'[SourceDesc)
		.Set TDate=$Piece($Get(^DHCEQReturn(rowid)),"^",4)
		.Set TDate=##class(web.DHCEQCommon).TransValueToPage(TDate,"date")
		.
		.Set TTotalNum=0
		.Set TTotalFee=0
		.Set RLRowid=0
		.For  Set RLRowid=$Order(^DHCEQReturnList(0,"Return",rowid,RLRowid)) Quit:RLRowid=""  Do
		..Set EQDR=$Piece($Get(^DHCEQReturnList(RLRowid,"EX","RowIDs")),"^",1)
		..If EQDR'="" Do
		...If TEquipName'="" Set TEquipName=TEquipName_","
		...Set TEquipName=TEquipName_$Piece($Get(^DHCEQEquip(EQDR)),"^",1)
		...Set TManuFactoryDR = $Piece($Get(^DHCEQEquip(EQDR)),"^",26)
		...If TManuFactoryDR'="" Do
		....If TManuFactory'="" Set TManuFactory=TManuFactory_","
		....Set TManuFactory=TManuFactory_##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)
		..Set TOriginalFee=+$Piece($Get(^DHCEQReturnList(RLRowid)),"^",6)
		..Set TQuantityNum=+$Piece($Get(^DHCEQReturnList(RLRowid)),"^",5)
		..Set TTotalNum=TTotalNum+TQuantityNum
		..Set TTotalFee=TTotalFee-TOriginalFee*TQuantityNum
		.
		.Set TRemark=$Piece($Get(^DHCEQReturn(rowid)),"^",14)
		.Do OutputRowAccountNoSource
	}
	Quit $$$OK
OutputRowAccountNoSource
	Set TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"")
 	Set Data=$lb(rowid, TNo, TDate, TEquipName, TManuFactory, TTotalNum, TTotalFee, TBuyLoc, TRemark)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetAccountNoSource
	Set (TNo, TDate, TEquipName, TManuFactory, TTotalNum, TTotalFee, TBuyLoc, TRemark)=""
	Quit
}

ClassMethod GetAccountNoSourceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAccountNoSourceExecute ]
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

ClassMethod GetAccountNoSourceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAccountNoSourceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 返回:0	有效,1	无效
/// w ##Class(web.DHCEQ.EM.BUSAccountNo).CheckSourceIDIsInValid(1,3,"")
ClassMethod CheckSourceIDIsInValid(SourceType As %String = "", SourceID As %String = "", ID As %String = "")
{
	Quit:(SourceType="")||(SourceID="") 1
	new Flag,Rowid,AccountNoDR
	
	Set Flag=0
	Set Rowid=0
	For  Set Rowid=$Order(^DHCEQAccountNoList(0,"Source",SourceType,SourceID,Rowid)) Quit:Rowid=""  Do
	.Set AccountNoDR=$Piece($Get(^DHCEQAccountNoList(Rowid)),"^",1)
	.If ($Piece($Get(^DHCEQAccountNo(AccountNoDR)),"^",23)="N")&&($Piece($Get(^DHCEQAccountNo(AccountNoDR)),"^",9)'=3)&&(ID'=Rowid) Set Flag=1
	
	Quit Flag
}

/// 设备凭单查找
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSAccountNo","GetAccountNo")
Query GetAccountNo(AccountNo As %String = "", LocDR As %String = "", Status As %String = "", ProviderDR As %String = "", StartDate As %String = "", EndDate As %String = "", InvalidFlag As %String = "N") As %Query(ROWSPEC = "TJob:%String,TRowID:%String,TAccountNo:%String,TAccountDate:%String,TLoc:%String,TProvider:%String,TEquipType:%String,TCheckDate:%String,TTotalFee:%String,TStatus:%String,TRemark:%String")
{
}

ClassMethod GetAccountNoExecute(ByRef qHandle As %Binary, AccountNo As %String = "", LocDR As %String = "", Status As %String = "", ProviderDR As %String = "", StartDate As %String = "", EndDate As %String = "", InvalidFlag As %String = "N") As %Status
{
 	new repid, index, rowid, id, TJob, PNum
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set index=1
 	Set TJob=$Job
 	Kill ^DHCEQTemp("GetAccountNo",TJob)
 	Set PNum=1
	i StartDate="" d
	.s StartDate=0
	e  d
	.s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	i EndDate="" d
	.s EndDate=+$h
	e  d
	.s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	
	Set rowid=0
	For  Set rowid=$Order(^DHCEQAccountNo(rowid)) Quit:rowid=""  Do
	.Do ResetVariablesGetAccountNo
	.Set TRowID = rowid
	.Set TInvalidFlag = $Piece($Get(^DHCEQAccountNo(rowid)),"^",23)
	.Quit:TInvalidFlag'="N"
	.Set TAccountNo = $Piece($Get(^DHCEQAccountNo(rowid)),"^",1)
	.Quit:(AccountNo'="")&(TAccountNo'[AccountNo)
	.Set TAccountDate = $Piece($Get(^DHCEQAccountNo(rowid)),"^",2)
	.Quit:(TAccountDate>EndDate)||(TAccountDate<StartDate)
	.If TAccountDate'="" Set TAccountDate = ##class(web.DHCEQCommon).TransValueToPage(TAccountDate,"date")
	.Set TLocDR = $Piece($Get(^DHCEQAccountNo(rowid)),"^",3)
	.Quit:(LocDR'="")&(TLocDR'=LocDR)
	.Set TLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept", TLocDR)
	.Set TProviderDR = $Piece($Get(^DHCEQAccountNo(rowid)),"^",4)
	.Quit:(ProviderDR'="")&(TProviderDR'=ProviderDR)
	.If TProviderDR '="" Set TProvider = ##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	.Set TEquipTypeDR = $Piece($Get(^DHCEQAccountNo(rowid)),"^",5)
	.Quit:##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	.Set TEquipType = ##class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)
	.Set TCheckDate = $Piece($Get(^DHCEQAccountNo(rowid)),"^",6)
	.If TCheckDate'="" Set TCheckDate = ##class(web.DHCEQCommon).TransValueToPage(TCheckDate,"date")
	.Set TTotalFee = $Piece($Get(^DHCEQAccountNo(rowid)),"^",8)
	.If TTotalFee'="" Set TTotalFee=$FN(TTotalFee,"",2)
	.Set TStatus = $Piece($Get(^DHCEQAccountNo(rowid)),"^",9)
	.Quit:(Status'="")&&(Status'="4")&&(Status'=TStatus)
	.Set TStatus=##class(web.DHCEQ.EM.BUSAccountNo).GetStatus(TStatus)
	.Set TRemark = $Piece($Get(^DHCEQAccountNo(rowid)),"^",10)
	.
	.Do OutputRowGetAccountNo
	
	Quit $$$OK
OutputRowGetAccountNo
	Set Data=$lb(TJob,TRowID,TAccountNo,TAccountDate,TLoc,TProvider,TEquipType,TCheckDate,TTotalFee,TStatus,TRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set ^DHCEQTemp("GetAccountNo",TJob,PNum)=TRowID_"^"_TAccountNo_"^"_TAccountDate_"^"_TLoc_"^"_TProvider_"^"_TEquipType_"^"_TCheckDate_"^"_TTotalFee_"^"_TStatus_"^"_TRemark
	Set PNum=PNum+1
	
	Quit
ResetVariablesGetAccountNo
	Set (TRowID,TAccountNo,TAccountDate,TLocDR,TLoc,TProviderDR,TProvider,TEquipTypeDR,TEquipType,TCheckDate,TTotalFee,TStatus,TRemark)=""
	Quit
}

ClassMethod GetAccountNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAccountNoExecute ]
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

ClassMethod GetAccountNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAccountNoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQ.EM.BUSAccountNo).GetOneAccountNoDetail(0,3824)
ClassMethod GetOneAccountNoDetail(PNum As %Library.String = "", job As %Library.String = "")
{
	Quit:(PNum="")||(job="") ""
	;^DHCEQTemp("LocUsedMonthReport",3824,3) = "专用设备^设备仓^放射科^4^40000.00" 
	Quit:PNum=0 $Order(^DHCEQTemp("GetAccountNo",job,""),-1)
	Quit $Get(^DHCEQTemp("GetAccountNo",job,PNum))
}

/// 描述:凭单业务明细查询
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSAccountNo","GetAccountNoList",2)
Query GetAccountNoList(AccountNoDR As %String = "") As %Query(ROWSPEC = "TRow:%String,ANLRowID:%String,ANLAccountNoDR:%String,ANLSourceType:%String,ANLSourceID:%String,ANLEquipTypeDR:%String,ANLProviderDR:%String,ANLSourceType_Desc:%String,ANLSourceID_Desc:%String,ANLEquipTypeDR_ETDesc:%String,MakeDate:%String,ANLEquipName:%String,ANLManuFactory:%String,ANLQuantityNum:%String,ANLAmount:%String,ToLoc:%String,ANLRemark:%String,ANLHold1:%String,ANLHold2:%String,ANLHold3:%String,ANLHold4:%String,ANLHold5:%String")
{
}

ClassMethod GetAccountNoListExecute(ByRef qHandle As %Binary, AccountNoDR As %String = "") As %Status
{
 	new repid, index, TotalQty, Total, TotalFlag, SourceInfo
	Set (TotalQty,Total)=0
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
	s index=1
	s TotalFlag=##class(web.DHCEQCommon).GetSysInfo("301006")
	i TotalFlag="1" s index=2
	s TRow=0
	
	i AccountNoDR'=""
	{
		Set TAccountNoDR=AccountNoDR
		Set rowid=0 
		For  Set rowid=$Order(^DHCEQAccountNoList(0,"AccountNoDR",AccountNoDR,rowid)) Quit:rowid=""  Do
		.Do ResetVariablesGetAccountNoList
		.Set TRowID = rowid
		.Set TSourceType=$Piece($Get(^DHCEQAccountNoList(rowid)),"^",2)
		.Set TSourceTypeDesc=##Class(web.DHCEQ.EM.BUSAccountNo).GetSourceType(TSourceType)
		.Set TSourceID=$Piece($Get(^DHCEQAccountNoList(rowid)),"^",3)
		.Set SourceInfo=##Class(web.DHCEQ.EM.BUSAccountNo).GetSourceInfo(TSourceType,TSourceID)
		.Set TSourceNo=$Piece(SourceInfo,"^",1)
		.Set TMakeDate=$Piece(SourceInfo,"^",2)
		.Set TLoc=$Piece(SourceInfo,"^",3)
		.Set TEquipTypeDR=$Piece($Get(^DHCEQAccountNoList(rowid)),"^",4)
		.Set TEquipType=##class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)
		.Set TProviderDR=$Piece($Get(^DHCEQAccountNoList(rowid)),"^",5)
		.Set TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
		.Set TManuFactory=$Piece($Get(^DHCEQAccountNoList(rowid)),"^",6)
		.Set TEquipName=$Piece($Get(^DHCEQAccountNoList(rowid)),"^",7)
		.Set TTotalNum=$Piece($Get(^DHCEQAccountNoList(rowid)),"^",8)
		.Set TTotalFee=$Piece($Get(^DHCEQAccountNoList(rowid)),"^",9)
		.Set TRemark=$Piece($Get(^DHCEQAccountNoList(rowid)),"^",10)
		.Set THold1=$Piece($Get(^DHCEQAccountNoList(rowid)),"^",14)
		.Set THold2=$Piece($Get(^DHCEQAccountNoList(rowid)),"^",15)
		.Set THold3=$Piece($Get(^DHCEQAccountNoList(rowid)),"^",16)
		.Set THold4=$Piece($Get(^DHCEQAccountNoList(rowid)),"^",17)
		.Set THold5=$Piece($Get(^DHCEQAccountNoList(rowid)),"^",18)
		.Set TRow=TRow+1
		.Set TotalQty=TotalQty+TTotalNum
		.Set Total=Total+TTotalFee
		.Do OutputRowGetAccountNoList
	}
	i TRow=0 d
	.d ResetVariablesGetAccountNoList
	.s TRow=1
	.d OutputRowGetAccountNoList
	Quit $$$OK
OutputRowGetAccountNoList
	Set Data=$lb(TRow,TRowID,TAccountNoDR,TSourceType,TSourceID,TEquipTypeDR,TProviderDR,TSourceTypeDesc,TSourceNo,TEquipType,TMakeDate,TEquipName,TManuFactory,TTotalNum,TTotalFee,TLoc,TRemark,THold1,THold2,THold3,THold4,THold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetAccountNoList
	Set (TRowID,TSourceType,TSourceID,TEquipTypeDR,TProviderDR,TSourceTypeDesc,TSourceNo,TEquipType,TMakeDate,TEquipName,TManuFactory,TTotalNum,TTotalFee,TLoc,TRemark,THold1,THold2,THold3,THold4,THold5)=""
	quit
}

ClassMethod GetAccountNoListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAccountNoListExecute ]
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

ClassMethod GetAccountNoListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAccountNoListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQ.EM.BUSAccountNo).GetSourceType(1)
ClassMethod GetSourceType(Type As %String = "")
{
	Quit:Type=1 "入库单"
	Quit:Type=2 "转移单"
	Quit:Type=3 "退货单"
	Quit ""
}

/// 描述:凭单明细来源类型
/// w ##Class(web.DHCEQ.EM.BUSAccountNo).GetSourceInfo(1,2)
ClassMethod GetSourceInfo(Type As %String = "", ID As %String = "")
{
	Quit:(Type="")||(ID="") ""
	new No,Date,Loc
	Set (No,Date,Loc)=""
	If Type=1
	{
		;"入库单"
		Set No=$Piece($Get(^DHCEQInStock(ID)),"^",14)
		Set Date=$Piece($Get(^DHCEQInStock(ID)),"^",1)
		If Date'="" Set Date=##class(web.DHCEQCommon).TransValueToPage(Date,"date")
		Set Loc=$Piece($Get(^DHCEQInStock(ID)),"^",18)
		Set Loc=##class(web.DHCEQCommon).GetTrakNameByID("dept", Loc)
	}
	If Type=2
	{
		;"转移单"
		Set No=$Piece($Get(^DHCEQStoreMove(ID)),"^",1)
		Set Date=$Piece($Get(^DHCEQInStock(ID)),"^",1)
		If Date'="" Set Date=##class(web.DHCEQCommon).TransValueToPage(Date,"date")
	}
	If Type=3
	{
		;"减少单"
		Set No=$Piece($Get(^DHCEQReturn(ID)),"^",1)
		Set Date=$Piece($Get(^DHCEQInStock(ID)),"^",1)
		If Date'="" Set Date=##class(web.DHCEQCommon).TransValueToPage(Date,"date")
	}
	
	Quit No_"^"_Date_"^"_Loc
}

/// w ##Class(web.DHCEQ.EM.BUSAccountNo).GetOneAccountNo(2)
ClassMethod GetOneAccountNo(RowID As %Library.String = "")
{
	s $ZT="ERRORGetOneAccountNo"
	
	s ObjAccountNo=##Class(User.DHCEQAccountNo).%OpenId(RowID)
	s AccountNoInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(ObjAccountNo)
	d AccountNoInfo.%Set("ANEquipTypeDR_ETDesc",ObjAccountNo.ANEquipTypeDR.ETDesc)
	d AccountNoInfo.%Set("ANLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjAccountNo.ANLocDR))
	d AccountNoInfo.%Set("ANProviderDR_VDesc",ObjAccountNo.ANProviderDR.VName)
	
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0, AccountNoInfo)
ERRORGetOneAccountNo
	TROLLBACK
	Set ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000", ErrorMsg)
}

/// w ##Class(web.DHCEQ.EM.BUSAccountNo).SaveData("","","")
ClassMethod SaveData(data, dataList, DelRowid)
{
	s $ZT="ERRORAccountNo"
	k PLIST,RowID
	
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQAccountNo",JsonData,.PLIST)
	s RowID = JsonData.%Get("ANRowID")
	
	Set PLIST(10) = 0		;AN_Status
 	Set PLIST(12) = User	;AN_UpdateUserDR
 	Set PLIST(13) = Date	;AN_UpdateDate 
 	Set PLIST(14) = Time	;AN_UpdateTime
 	Set PLIST(24) = "N"		;AN_InvalidFlag
	
 	TSTART
	if RowID'=""
	{
		&SQL(update sqluser.DHC_EQAccountNo values :PLIST() where AN_RowID=:RowID)
	}
	else
	{
		;DHC_EQPayRecord
		Set PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQAccountNo",Date,JsonData.ANEquipTypeDR)
		&SQL(insert into sqluser.DHC_EQAccountNo values :PLIST())
		s RowID=$g(%ROWID)
	}
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}	
	Set SQLCODE=##Class(web.DHCEQ.EM.BUSAccountNo).DeleteAccountNoList(DelRowid)
 	i SQLCODE
 	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
 	}
 	Set SQLCODE=##Class(web.DHCEQ.EM.BUSAccountNo).SaveAccountNoList(RowID,dataList,User)
 	i SQLCODE
 	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
 	}
	
	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
	
ERRORAccountNo
	TROLLBACK
	Set ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// w ##Class(web.DHCEQ.EM.BUSAccountNo).DeleteAccountNoList(",2,0,-1")
ClassMethod DeleteAccountNoList(DelRowIDs As %String = "")
{
	Quit:DelRowIDs="" 0
	new Length,ANLRowID,i
	
	Set SQLCODE=0
	Set Length=$l(DelRowIDs,",")
	For i=1:1:Length
	{
		Set ANLRowID=+$Piece(DelRowIDs,",",i)
		If (ANLRowID>0)
		{
			&SQL(Delete from sqluser.DHC_EQAccountNoList where ANL_RowID=:ANLRowID)
		}
		Quit:SQLCODE
	}
	Quit SQLCODE
}

/// w ##Class(web.DHCEQ.EM.BUSAccountNo).SaveAccountNoList(2,"1^1^1^3^2^^^C-臂系统升级套件(DSA),净化装置^6^81000^123")
ClassMethod SaveAccountNoList(ANRowID As %String = "", dataList As %String = "", User As %String = "")
{
	Quit:ANRowID="" -1
	Quit:dataList="" 0
	
	s SQLCODE=0
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025") 
	s Length=$L(dataList,SplitRowCode)
	for i=1:1:Length
	{
		q:SQLCODE'=0
		s valList=$p(dataList,SplitRowCode,i)
		q:valList=""
		k PLIST,ANLRowID
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
		s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQAccountNoList",JsonData,.PLIST)
		s PLIST(2)=ANRowID
		s ANLRowID = JsonData.ANLRowID
	    if ANLRowID'=""
	    {
			&SQL(Update SQLUSER.DHC_EQAccountNoList Values :PLIST() where ANL_RowID = :ANLRowID)
		}
		else
		{
			&SQL(insert into SQLUSER.DHC_EQAccountNoList Values :PLIST())
		}
	}
	i SQLCODE'=0 q SQLCODE
	;汇总明细总金额,更新总单的总金额
	Set TotalFee=0
	Set id=0
	For  Set id=$Order(^DHCEQAccountNoList(0,"AccountNoDR",ANRowID,id)) Quit:id=""  Do
	.Set TotalFee = TotalFee+$Piece($Get(^DHCEQAccountNoList(id)),"^",9)
	&SQL(Update SQLUSER.DHC_EQAccountNo Set AN_TotalFee=:TotalFee where AN_RowID=:ANRowID)
	
	q SQLCODE
}

/// 描述:删除
/// w ##Class(web.DHCEQ.EM.BUSAccountNo).DeleteData()
ClassMethod DeleteData(RowID As %String = "")
{
	i RowID="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
	Set $ZT="ERRORDelete"
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	&SQL(Update SQLUSER.DHC_EQAccountNo Set AN_InvalidFlag='Y',AN_UpdateUserDR=:User,AN_UpdateDate=:Date,AN_UpdateTime=:Time where AN_RowID=:RowID)
 	i SQLCODE=100 s SQLCODE=0
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	
ERRORDelete
	Set ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// 描述:审核
/// w ##Class(web.DHCEQ.EM.BUSAccountNo).Audit("4")
ClassMethod Audit(RowID As %String = "")
{
	If RowID="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
	Set $ZT="ERRORAudit"
	Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set Date=+$H
	Set Time=$Piece($H,",",2)
	
	TSTART
	&SQL(Update SQLUSER.DHC_EQAccountNo Set AN_Status=2,AN_AuditUserDR=:User,AN_AuditDate=:Date,AN_AuditTime=:Time where AN_RowID=:RowID)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	TCOMMIT
	
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
ERRORAudit 
	TRollBack
	Set ErrorMsg=$ZE	     		//得到系统返回的错误消息
 	Quit "ERRORAudit"_ErrorMsg     	//返回错误消息
}

/// 描述:作废
/// w ##Class(web.DHCEQ.EM.BUSAccountNo).Cancel("4")
ClassMethod Cancel(RowID As %String = "")
{
	If RowID="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
	Set $ZT="ERRORCancel"
	Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set Date=+$H
	Set Time=$Piece($H,",",2)
	
	TSTART
	&SQL(Update SQLUSER.DHC_EQAccountNo Set AN_Status=3,AN_DisUseUserDR=:User,AN_DisUseDate=:Date,AN_DisUseTime=:Time where AN_RowID=:RowID)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	TCOMMIT
	
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
ERRORCancel
	TRollBack
	Set ErrorMsg=$ZE	     		//得到系统返回的错误消息
 	Quit "ERRORCancel"_ErrorMsg		//返回错误消息
}

/// 描述:打印
/// w ##Class(web.DHCEQ.EM.BUSAccountNo).GetList(4)
ClassMethod GetList(AccountNoDR As %Library.String = "")
{
	Quit:AccountNoDR="" ""
	new (AccountNoDR)
	Set Data=""
	Set Num=0
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")
	Set SplitNumCode=##class(web.DHCEQCommon).GetSysInfo("990026")
	
	Set (sumQty,sumFee)=0
	Set Rowid=0
	For  Set Rowid=$Order(^DHCEQAccountNoList(0,"AccountNoDR",AccountNoDR,Rowid)) Quit:Rowid=""  Do
	.Set SourceType=$Piece($Get(^DHCEQAccountNoList(Rowid)),"^",2)
	.Set SourceID=$Piece($Get(^DHCEQAccountNoList(Rowid)),"^",3)
	.Set SourceInfo=##Class(web.DHCEQ.EM.BUSAccountNo).GetSourceInfo(SourceType,SourceID)
	.Set TSourceNo=$Piece(SourceInfo,"^",1)
	.;Set TMakeDate=$Piece(SourceInfo,"^",2)
	.;Set TLoc=$Piece(SourceInfo,"^",3)
	.Set SourceType=##Class(web.DHCEQ.EM.BUSAccountNo).GetSourceType(SourceType)
	.Set EquipType=$Piece($Get(^DHCEQAccountNoList(Rowid)),"^",4)
	.Set EquipType=##class(web.DHCEQCommon).GetTrakNameByID("equiptype",EquipType)
	.Set Provider=$Piece($Get(^DHCEQAccountNoList(Rowid)),"^",5)
	.Set Provider=##class(web.DHCEQCommon).GetTrakNameByID("prov",Provider)
	.Set ManuFactory=$Piece($Get(^DHCEQAccountNoList(Rowid)),"^",6)
	.Set EquipName=$Piece($Get(^DHCEQAccountNoList(Rowid)),"^",7)
	.Set QuantityNum=$Piece($Get(^DHCEQAccountNoList(Rowid)),"^",8)
	.Set Amount=$Piece($Get(^DHCEQAccountNoList(Rowid)),"^",9)
	.Set Remark=$Piece($Get(^DHCEQAccountNoList(Rowid)),"^",10)
	.Set sumFee=sumFee+Amount
	.Set sumQty=sumQty+QuantityNum
	.
	.Set Data=Data_SplitRowCode_SourceType_"^"_TSourceNo_"^"_EquipType_"^"_Provider_"^"_ManuFactory_"^"_EquipName_"^"_QuantityNum_"^"_Amount_"^"_Remark
	.Set Num=Num+1
	
	If Data'="" Do
	.Set Data=Data_SplitRowCode_"合计^^^^^^"_sumQty_"^"_sumFee_"^"
	.Set Num=Num+1
	Quit Data_SplitNumCode_Num
}

/// 描述:润乾打印
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSAccountNo","AccountNoList","1")
Query AccountNoList(RowID As %String = "") As %Query(ROWSPEC = "AccountNo:%String,AccountDate:%String,TRowid:%String,SourceType:%String,SourceNo:%String,EquipType:%String,Provider:%String,ManuFactory:%String,EquipName:%String,QuantityNum:%String,Amount:%String,Remark:%String") [ SqlProc ]
{
}

ClassMethod AccountNoListExecute(ByRef qHandle As %Binary, RowID As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	
	i RowID="" Quit $$$OK
	Set AccountNo = $Piece($Get(^DHCEQAccountNo(RowID)),"^",1)
	Set AccountDate = $Piece($Get(^DHCEQAccountNo(RowID)),"^",2)
	Set AccountDate=##Class(web.DHCEQCommon).TransValueToPage(AccountDate,"CHNDate")
	Set Provider=$Piece($Get(^DHCEQAccountNo(RowID)),"^",4)
	Set Provider=##class(web.DHCEQCommon).GetTrakNameByID("prov",Provider)
	Set Rowid=0
	For  Set Rowid=$Order(^DHCEQAccountNoList(0,"AccountNoDR",RowID,Rowid)) Quit:Rowid=""  Do
	.Set SourceType=$Piece($Get(^DHCEQAccountNoList(Rowid)),"^",2)
	.Set SourceID=$Piece($Get(^DHCEQAccountNoList(Rowid)),"^",3)
	.Set SourceInfo=##Class(web.DHCEQ.EM.BUSAccountNo).GetSourceInfo(SourceType,SourceID)
	.Set SourceNo=$Piece(SourceInfo,"^",1)
	.;Set TMakeDate=$Piece(SourceInfo,"^",2)
	.;Set TLoc=$Piece(SourceInfo,"^",3)
	.Set SourceType=##Class(web.DHCEQ.EM.BUSAccountNo).GetSourceType(SourceType)
	.Set EquipType=$Piece($Get(^DHCEQAccountNoList(Rowid)),"^",4)
	.Set EquipType=##class(web.DHCEQCommon).GetTrakNameByID("equiptype",EquipType)
	.Set ManuFactory=$Piece($Get(^DHCEQAccountNoList(Rowid)),"^",6)
	.Set EquipName=$Piece($Get(^DHCEQAccountNoList(Rowid)),"^",7)
	.Set QuantityNum=$Piece($Get(^DHCEQAccountNoList(Rowid)),"^",8)
	.Set Amount=$Piece($Get(^DHCEQAccountNoList(Rowid)),"^",9)
	.Set Remark=$Piece($Get(^DHCEQAccountNoList(Rowid)),"^",10)
	.d OutputRowAccountNoList
	Quit $$$OK
OutputRowAccountNoList
	Set Data=$lb(AccountNo,AccountDate,Rowid,SourceType,SourceNo,EquipType,Provider,ManuFactory,EquipName,QuantityNum,Amount,Remark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesAccountNoList
	s (SourceType,SourceNo,EquipType,ManuFactory,EquipName,QuantityNum,Amount,Remark)=""
	quit
}

ClassMethod AccountNoListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AccountNoListExecute ]
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

ClassMethod AccountNoListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AccountNoListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
