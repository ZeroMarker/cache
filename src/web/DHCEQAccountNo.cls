/// Mozy	2013-8-28
/// 凭证号管理
Class web.DHCEQAccountNo Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(web.DHCEQAccountNo).StatusList("Status",155,%request.Get("Type"))
ClassMethod StatusList(name, width, Type) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=0>新增</option>"
	;w "<option value=1>提交</option>"
	w "<option value=2>审核</option>"
	w "<option value=3>作废</option>"	
	w "</select>",!
}

ClassMethod GetStatus(Status)
{
	Quit $CASE(Status,"0":"新增","1":"提交","2":"审核","3":"作废",:"没有定义")
}

/// 描述:凭单明细来源类型
/// w ##Class(web.DHCEQAccountNo).GetSourceType(1)
ClassMethod GetSourceType(Type As %String = "")
{
	;Quit $CASE(Type,"1":"入库单","2":"转移单","3":"减少单","":"")
	Quit:Type=1 "入库单"
	;Quit:Type=2 "转移单"
	Quit:Type=3 "减少单"
	Quit ""
}

/// 创建:Mozy 2013-9-1
/// 设备凭单查找
/// d ##class(%ResultSet).RunQuery("web.DHCEQAccountNo","GetAccountNo")
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
	If StartDate="" Set StartDate=0
	If EndDate="" Set EndDate=+$h
	
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
	.;If TLocDR'="" Set TLoc = $Piece($Get(^CTLOC(TLocDR)),"^",2)    //modify by jyp 2019-10-18 CTLOC调整
	.If TLocDR'="" Set TLoc =##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)   //modify by jyp 2019-10-18 CTLOC调整
	.Set TProviderDR = $Piece($Get(^DHCEQAccountNo(rowid)),"^",4)
	.Quit:(ProviderDR'="")&(TProviderDR'=ProviderDR)
	.If TProviderDR '="" Set TProvider = ##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	.Set TEquipTypeDR = $Piece($Get(^DHCEQAccountNo(rowid)),"^",5)
	.Quit:##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	.If TEquipTypeDR '="" Set TEquipType = $Piece($Get(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	.Set TCheckDate = $Piece($Get(^DHCEQAccountNo(rowid)),"^",6)
	.If TCheckDate'="" Set TCheckDate = ##class(web.DHCEQCommon).TransValueToPage(TCheckDate,"date")
	.Set TTotalFee = $Piece($Get(^DHCEQAccountNo(rowid)),"^",8)
	.If TTotalFee'="" Set TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"",2)
	.Set TStatus = $Piece($Get(^DHCEQAccountNo(rowid)),"^",9)
	.Quit:(Status'="")&&(Status'=TStatus)
	.Set TStatus=##class(web.DHCEQAccountNo).GetStatus(TStatus)
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

/// w ##Class(web.DHCEQAccountNo).GetOneAccountNoDetail(0,3824)
ClassMethod GetOneAccountNoDetail(PNum As %Library.String = "", job As %Library.String = "")
{
	Quit:(PNum="")||(job="") ""
	;^DHCEQTemp("LocUsedMonthReport",3824,3) = "专用设备^设备仓^放射科^4^40000.00" 
	Quit:PNum=0 $Order(^DHCEQTemp("GetAccountNo",job,""),-1)
	Quit $Get(^DHCEQTemp("GetAccountNo",job,PNum))
}

/// w ##Class(web.DHCEQAccountNo).SaveData("6^22613080006^29/08/2013^226^5^2^01/08/2013^^^^^1116^2227^3338^4449^5550","1^1^1^3^^^^C-臂系统升级套件(DSA),净化装置^6^81000^123^^^^^","")
ClassMethod SaveData(val, valList, DelRowid)
{
	Set $ZT="ERRORSave"
	Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	new (val, valList, DelRowid, User)
	
	Set Date=+$H
	Set Time=$Piece($H,",",2)
	Set RowID=$Piece(val,"^",1)
	
	Set PLIST(2) = $Piece(val,"^",2)	;AN_AccountNo
	Set PLIST(3) = $Piece(val,"^",3)	;AN_AccountDate
	If $Piece(val,"^",3)'=""  Set PLIST(3) = ##class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",3),"date")
	Set PLIST(4) = $Piece(val,"^",4)	;AN_LocDR
	Set PLIST(5) = $Piece(val,"^",5)	;AN_ProviderDR
	Set PLIST(6) = $Piece(val,"^",6)	;AN_EquipTypeDR
	Set PLIST(7) = $Piece(val,"^",7)	;AN_CheckDate
 	If $Piece(val,"^",7)'=""  Set PLIST(7) = ##class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",7),"date")
 	Set PLIST(8) = $Piece(val,"^",8)	;AN_CheckUser
 	Set PLIST(9) = $Piece(val,"^",9)	;AN_TotalFee
 	Set PLIST(10) = 0	;AN_Status
 	Set PLIST(11) = $Piece(val,"^",10)	;AN_Remark
 	Set PLIST(12) = User	;AN_UpdateUserDR
 	Set PLIST(13) = Date	;AN_UpdateDate 
 	Set PLIST(14) = Time	;AN_UpdateTime
 	Set PLIST(24) = "N"		;AN_InvalidFlag
 	Set PLIST(25) = $Piece(val,"^",11)	;Hold1
 	Set PLIST(26) = $Piece(val,"^",12)	;Hold2
 	Set PLIST(27) = $Piece(val,"^",13)	;Hold3
 	Set PLIST(28) = $Piece(val,"^",14)	;Hold4
 	Set PLIST(29) = $Piece(val,"^",15)	;Hold5
	TSTART	
 	if RowID=""
 	{
		If PLIST(2)="" Set PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQAccountNo",Date,$Piece(val,"^",4),$Piece(val,"^",6))	// Mozy	2016-10-21
		&SQL(insert into sqluser.DHC_EQAccountNo values :PLIST())
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		Set RowID=$Get(%ROWID)
 	}
 	else
 	{
		&SQL(update sqluser.DHC_EQAccountNo values :PLIST() where AN_RowID=:RowID)
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
 	}
 	
 	Set SQLCODE=##Class(web.DHCEQAccountNo).DeleteAccountNoList(DelRowid)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	
 	Set SQLCODE=##Class(web.DHCEQAccountNo).SaveAccountNoList(RowID,valList,User)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	
	TCOMMIT
 	Set ID=RowID
 	Quit ID
ERRORSave 
	TRollBack
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "<ERRORSave>"_ErrorMsg     //返回错误消息
}

/// w ##Class(web.DHCEQAccountNo).GetOneAccountNo(3)
ClassMethod GetOneAccountNo(rowid)
{
	new result,resultex
	Set (result,resultex)=""
	Set result=^DHCEQAccountNo(rowid)
	Set $Piece(result,"^",2)=##class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",2),"date")	;AN_AccountDate
	Set resultex=resultex_"^"	;AN_LocDR
	If $Piece(result,"^",3)'=""  Do
	.Set resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$Piece(result,"^",3))
	Set resultex=resultex_"^"	;AN_ProviderDR
	If $Piece(result,"^",4)'=""  Do
	.Set resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("prov",$Piece(result,"^",4))
	Set resultex=resultex_"^"	;AN_EquipTypeDR
	If $Piece(result,"^",5)'=""  Do
	.Set resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQCEquipType",$Piece(result,"^",5))),"^",2)
	Set $Piece(result,"^",6)=##class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",6),"date")	;AN_CheckDate
	Set resultex=resultex_"^"	;AN_CheckUser
	If $Piece(result,"^",7)'=""  Do
	.Set resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$Piece(result,"^",7))
	
	Set result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	Quit result_resultex
}

/// w ##Class(web.DHCEQAccountNo).DeleteData("6")
ClassMethod DeleteData(RowID As %String = "")
{
	If RowID="" Quit ""
	Set $ZT="ERRORDelete"
	Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set Date=+$H
	Set Time=$Piece($H,",",2)
	
	TSTART
	&SQL(Update SQLUSER.DHC_EQAccountNo Set AN_InvalidFlag='Y',AN_UpdateUserDR=:User,AN_UpdateDate=:Date,AN_UpdateTime=:Time where AN_RowID=:RowID)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	TCOMMIT
	
 	Quit SQLCODE
ERRORDelete 
	TRollBack
	Set ErrorMsg=$ZE	     		//得到系统返回的错误消息
 	Quit "ERRORDelete"_ErrorMsg     //返回错误消息
}

/// w ##Class(web.DHCEQAccountNo).GetAudit("4")
ClassMethod GetAudit(RowID As %String = "")
{
	If RowID="" Quit ""
	Set $ZT="ERRORGetAudit"
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
	
 	Quit RowID
ERRORGetAudit 
	TRollBack
	Set ErrorMsg=$ZE	     			//得到系统返回的错误消息
 	Quit "ERRORGetAudit"_ErrorMsg     	//返回错误消息
}

/// w ##Class(web.DHCEQAccountNo).SubmitData("4")
ClassMethod SubmitData(RowID As %String = "")
{
	If RowID="" Quit ""
	Set $ZT="ERRORSubmitData"
	Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set Date=+$H
	Set Time=$Piece($H,",",2)
	
	TSTART
	&SQL(Update SQLUSER.DHC_EQAccountNo Set AN_Status=1,AN_SubmitUserDR=:User,AN_SubmitDate=:Date,AN_SubmitTime=:Time where AN_RowID=:RowID)
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

/// w ##Class(web.DHCEQAccountNo).CancelSubmitData("4")
ClassMethod CancelSubmitData(RowID As %String = "")
{
	If RowID="" Quit ""
	Set $ZT="ERRORCancelSubmitData"
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
	
 	Quit RowID
ERRORCancelSubmitData 
	TRollBack
	Set ErrorMsg=$ZE	     				//得到系统返回的错误消息
 	Quit "ERRORCancelSubmitData"_ErrorMsg   //返回错误消息
}

/// 创建:Mozy 2013-9-2
/// 描述:凭单业务明细查询
/// d ##class(%ResultSet).RunQuery("web.DHCEQAccountNo","GetAccountNoList",3)
Query GetAccountNoList(RowID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TRow:%String,TSourceType:%String,TSourceID:%String,TSourceNo:%String,TMakeDate:%String,TEquipName:%String,TEquipTypeDR:%String,TEquipType:%String,TProviderDR:%String,TProvider:%String,TManuFactory:%String,TTotalNum:%String,TTotalFee:%String,TLoc:%String,TRemark:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String")
{
}

ClassMethod GetAccountNoListExecute(ByRef qHandle As %Binary, RowID As %String = "") As %Status
{
 	new repid, index, TotalQty, Total, TotalFlag, SourceInfo
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	
	Set (TotalQty,Total)=0
	Set index=1
	Set TotalFlag=##class(web.DHCEQCommon).GetSysInfo("301006")
	If TotalFlag="1" Set index=2
	
	Set TRow=0
	Set AccountNoDR=RowID
	If AccountNoDR'=""
	{
		Set rowid=0 
		For  Set rowid=$Order(^DHCEQAccountNoList(0,"AccountNoDR",AccountNoDR,rowid)) Quit:rowid=""  Do
		.Do ResetVariablesGetAccountNoList
		.Set TRowID = rowid
		.Set TSourceType=$Piece($Get(^DHCEQAccountNoList(rowid)),"^",2)
		.Set TSourceID=$Piece($Get(^DHCEQAccountNoList(rowid)),"^",3)
		.Set SourceInfo=##Class(web.DHCEQAccountNo).GetSourceInfo(TSourceType,TSourceID)
		.Set TSourceNo=$Piece(SourceInfo,"^",1)
		.Set TMakeDate=$Piece(SourceInfo,"^",2)
		.Set TLoc=$Piece(SourceInfo,"^",3)
		.Set TEquipTypeDR=$Piece($Get(^DHCEQAccountNoList(rowid)),"^",4)
		.If TEquipTypeDR'="" Set TEquipType=$Piece($Get(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
		.Set TProviderDR=$Piece($Get(^DHCEQAccountNoList(rowid)),"^",5)
		.If TProviderDR'="" Set TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
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
	;没有数据时,也返回一个空行,用于编辑
	If TRow=0 Do
	.Do ResetVariablesGetAccountNoList
	.Set TRow=1
	.Do OutputRowGetAccountNoList
	
	;处理合计行
	If TotalFlag>0 Do
	.Do ResetVariablesGetAccountNoList
	.Set TRowID=-1
	.Set TTotalNum=TotalQty
	.Set TTotalFee=##Class(web.DHCEQCommon).FormatNumber(Total,"",2)
	.If TotalFlag="1" Do
	..Set index=1
	.Else  Do
	..Set index=index+1
	.Do OutputRowGetAccountNoList
	Quit $$$OK
	
OutputRowGetAccountNoList
	Set Data=$lb(TRowID,TRow,TSourceType,TSourceID,TSourceNo,TMakeDate,TEquipName,TEquipTypeDR,TEquipType,TProviderDR,TProvider,TManuFactory,TTotalNum,TTotalFee,TLoc,TRemark,THold1,THold2,THold3,THold4,THold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetAccountNoList
	Set (TRowID,TSourceType,TSourceID,TSourceNo,TMakeDate,TEquipName,TEquipTypeDR,TEquipType,TProviderDR,TProvider,TManuFactory,TTotalNum,TTotalFee,TLoc,TRemark,THold1,THold2,THold3,THold4,THold5)=""
	Quit
}

ClassMethod GetAccountNoListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAccountNoListExecute ]
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

ClassMethod GetAccountNoListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAccountNoListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 描述:凭单明细来源类型
/// w ##Class(web.DHCEQAccountNo).GetSourceInfo(1,3)
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
		If Loc'="" Set Loc=##class(web.DHCEQCommon).GetTrakNameByID("dept", Loc)
		If Loc'="" Set Loc=##class(web.DHCEQCommon).GetSplitDataByFlag(Loc,"-")
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

///  d ##class(%ResultSet).RunQuery("web.DHCEQAccountNo","GetInStock","",15)
Query GetInStock(EquipTypeDR As %String = "", ProviderDR As %String = "", SourceNo As %String = "", id As %String = "") As %Query(ROWSPEC = "Hidden:%String,TInStockNo:%String,TInDate:%String,TEquipName:%String,TManuFactory:%String,TTotalNum:%String,TTotalFee:%String,TBuyLoc:%String,TRemark:%String")
{
}

ClassMethod GetInStockExecute(ByRef qHandle As %Binary, EquipTypeDR As %String = "", ProviderDR As %String = "", SourceNo As %String = "", id As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set SourceNo=$ZCONVERT(SourceNo,"U")
	
	Set rowid=0
	For  Set rowid=$Order(^DHCEQInStock(0,"Provider",ProviderDR,rowid)) Quit:rowid=""  Do
	.Do ResetVariablesGetInStock
	.Set TInvalidFlag=$Piece($Get(^DHCEQInStock(rowid)),"^",25)
	.Quit:TInvalidFlag="Y"
	.Set TEquipTypeDR=$Piece($Get(^DHCEQInStock(rowid)),"^",20)
	.Quit:(EquipTypeDR'="")&(TEquipTypeDR'=EquipTypeDR)
	.Quit:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	.Set TEquipType=$Piece($Get(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	.Set Status=$Piece($Get(^DHCEQInStock(rowid)),"^",10)
	.Quit:(Status'=2)
	.Quit:##Class(web.DHCEQAccountNo).CheckSourceIDIsInValid(1,rowid,id)
	.Set TInStockNo=$Piece($Get(^DHCEQInStock(rowid)),"^",14)
	.Quit:(SourceNo'="")&($ZCONVERT(TInStockNo,"U")'[SourceNo)
	.Set TInDate=$Piece($Get(^DHCEQInStock(rowid)),"^",1)
	.Set TInDate=##class(web.DHCEQCommon).TransValueToPage(TInDate,"date")
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
	...Set TManuFactory=TManuFactory_$Piece($Get(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1)
	..Set TOriginalFee=+$Piece($Get(^DHCEQInStockList(ISLRowid)),"^",7)
	..Set TQuantityNum=+$Piece($Get(^DHCEQInStockList(ISLRowid)),"^",8)
	..Set TTotalNum=TTotalNum+TQuantityNum
	..Set TTotalFee=TTotalFee+TOriginalFee*TQuantityNum
	.
	.Set TRemark=$Piece($Get(^DHCEQInStock(rowid)),"^",11)
	.Set TBuyLocDR=$Piece($Get(^DHCEQInStock(rowid)),"^",18)
	.If TBuyLocDR'="" Set TBuyLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept", TBuyLocDR)
	.If TBuyLoc'="" Set TBuyLoc=##class(web.DHCEQCommon).GetSplitDataByFlag(TBuyLoc,"-")
	.Do OutputRowGetInStock
	Quit $$$OK
OutputRowGetInStock
	Set Data=$lb(rowid, TInStockNo, TInDate, TEquipName, TManuFactory, TTotalNum, TTotalFee, TBuyLoc, TRemark)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetInStock
	Set (TInStockNo, TInDate, TEquipName, TManuFactory, TBuyLoc, TRemark)=""
	Quit
}

ClassMethod GetInStockFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInStockExecute ]
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

ClassMethod GetInStockClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInStockExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##Class(web.DHCEQAccountNo).GetList(3)
ClassMethod GetList(AccountNoDR As %Library.String = "")
{
	Quit:AccountNoDR="" ""
	new (AccountNoDR)
	Set Data=""
	Set Num=0
	
	Set (sumFee,sumQty)=0
	Set Rowid=0
	For  Set Rowid=$Order(^DHCEQAccountNoList(0,"AccountNoDR",AccountNoDR,Rowid)) Quit:Rowid=""  Do
	.Set SourceType=$Piece($Get(^DHCEQAccountNoList(Rowid)),"^",2)
	.Set SourceID=$Piece($Get(^DHCEQAccountNoList(Rowid)),"^",3)
	.Set SourceInfo=##Class(web.DHCEQAccountNo).GetSourceInfo(SourceType,SourceID)
	.Set TSourceNo=$Piece(SourceInfo,"^",1)
	.;Set TMakeDate=$Piece(SourceInfo,"^",2)
	.;Set TLoc=$Piece(SourceInfo,"^",3)
	.If SourceType'="" Set SourceType=##Class(web.DHCEQAccountNo).GetSourceType(SourceType)
	.Set EquipType=$Piece($Get(^DHCEQAccountNoList(Rowid)),"^",4)
	.If EquipType'="" Set EquipType=$Piece($Get(^DHCEQCCode("DHCEQCEquipType",EquipType)),"^",2)
	.Set Provider=$Piece($Get(^DHCEQAccountNoList(Rowid)),"^",5)
	.If Provider'="" Set Provider=##class(web.DHCEQCommon).GetTrakNameByID("prov",Provider)
	.Set ManuFactory=$Piece($Get(^DHCEQAccountNoList(Rowid)),"^",6)
	.Set EquipName=$Piece($Get(^DHCEQAccountNoList(Rowid)),"^",7)
	.Set QuantityNum=$Piece($Get(^DHCEQAccountNoList(Rowid)),"^",8)
	.Set Amount=$Piece($Get(^DHCEQAccountNoList(Rowid)),"^",9)
	.Set Remark=$Piece($Get(^DHCEQAccountNoList(Rowid)),"^",10)
	.Set sumFee=sumFee+Amount
	.Set sumQty=sumQty+QuantityNum
	.
	.Set Data=Data_":"_SourceType_"^"_TSourceNo_"^"_EquipType_"^"_Provider_"^"_ManuFactory_"^"_EquipName_"^"_QuantityNum_"^"_Amount_"^"_Remark
	.Set Num=Num+1
	
	If Data'="" Do
	.Set Data=Data_":"_"合计^^^^^^"_sumQty_"^"_sumFee_"^"
	.Set Num=Num+1
	Quit Data_"_"_Num
}

/// 返回:0	有效,1	无效
/// w ##Class(web.DHCEQAccountNo).CheckSourceIDIsInValid(1,5,2)
ClassMethod CheckSourceIDIsInValid(SourceType As %String = "", SourceID As %String = "", ID As %String = "")
{
	Quit:(SourceType="")||(SourceID="") 1
	new (SourceType,SourceID,ID)
	
	Set Flag=0
	Set Rowid=0
	For  Set Rowid=$Order(^DHCEQAccountNoList(0,"Source",SourceType,SourceID,Rowid)) Quit:Rowid=""  Do
	.Set AccountNoDR=$Piece($Get(^DHCEQAccountNoList(Rowid)),"^",1)
	.Set Status=$Piece($Get(^DHCEQAccountNo(AccountNoDR)),"^",9)
	.If (Status'=3)&(ID'=Rowid) Set Flag=1
	
	Quit Flag
}

/// w ##Class(web.DHCEQAccountNo).SaveAccountNoList(2,"1^1^1^3^2^^^C-臂系统升级套件(DSA),净化装置^6^81000^123")
ClassMethod SaveAccountNoList(ANRowID As %String = "", val As %String = "", User As %String = "")
{
	Quit:ANRowID="" -1
	Quit:val="" 0
	
	new Length,ANLRowID,Flag,i
	new valList,TSourceType,TSourceID,TotalFee,id
	Kill PLIST
	
	Set Length=$l(val,"&")
	Set PLIST(2)=ANRowID
	Set Flag=0
	For i=1:1:Length
	{
		Quit:Flag'=0
		;TRow+"^"+TRowID+"^"+TSourceType+"^"+TSourceID+"^"+TEquipTypeDR+"^"+TProviderDR+"^"+TManuFactory+"^"+TEquipName+"^"+TTotalNum+"^"+TTotalFee+"^"+TRemark;
		Set valList=$Piece(val,"&",i)
		Set ANLRowID=$Piece(valList,"^",2)
		Set PLIST(3)=$Piece(valList,"^",3)  	;ANL_SourceType
		Set PLIST(4)=$Piece(valList,"^",4)		;ANL_SourceID
		Set PLIST(5)=$Piece(valList,"^",5)		;ANL_EquipTypeDR
		Set PLIST(6)=$Piece(valList,"^",6)  	;ANL_ProviderDR
		Set PLIST(7)=$Piece(valList,"^",7)  	;ANL_ManuFactory
		Set PLIST(8)=$Piece(valList,"^",8)  	;ANL_EquipName
		Set PLIST(9)=$Piece(valList,"^",9)  	;ANL_QuantityNum
		Set PLIST(10)=$Piece(valList,"^",10)  	;ANL_Amount
		Set PLIST(11)=$Piece(valList,"^",11)  	;ANL_Remark
		Set PLIST(12)=User  					;ANL_UpdateUserDR
		Set PLIST(13)=+$H  						;ANL_UpdateDate
		Set PLIST(14)=$Piece($H,",",2)  		;ANL_UpdateTime
		Set PLIST(15)=$Piece(valList,"^",12)	;Hold1
 		Set PLIST(16)=$Piece(valList,"^",13)	;Hold2
 		Set PLIST(17)=$Piece(valList,"^",14)	;Hold3
 		Set PLIST(18)=$Piece(valList,"^",15)	;Hold4
 		Set PLIST(19)=$Piece(valList,"^",16)	;Hold5
 		
		if (ANLRowID="")
		{
			&SQL(Insert Into SQLUSER.DHC_EQAccountNoList Values :PLIST())
			;Set ANLRowID=$Get(%ROWID)
		}
		else
		{
			&SQL(update sqluser.DHC_EQAccountNoList Values :PLIST() where ANL_RowID=:ANLRowID)
		}
		i SQLCODE
 		{
			Set Flag=SQLCODE
 		}
 		Quit:Flag'=0
	}
	;汇总明细总金额,更新总单的总金额
	Set TotalFee=0
	Set id=0
	For  Set id=$Order(^DHCEQAccountNoList(0,"AccountNoDR",ANRowID,id)) Quit:id=""  Do
	.Set TotalFee = TotalFee+$Piece($Get(^DHCEQAccountNoList(id)),"^",9)
	&SQL(Update SQLUSER.DHC_EQAccountNo Set AN_TotalFee=:TotalFee where AN_RowID=:ANRowID)
	
	Quit Flag
}

/// w ##Class(web.DHCEQAccountNo).DeleteAccountNoList(",2,0,-1")
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

}
