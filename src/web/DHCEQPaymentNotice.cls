/// 作废，采用付款申请单处理。 20150813 JDL
/// ---------------------------
/// Mozy	2013-9-13 
/// 付款通知单
Class web.DHCEQPaymentNotice Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(web.DHCEQPaymentNotice).StatusList("Status",155,%request.Get("Type"))
ClassMethod StatusList(name, width, Type) As %String
{
	;;下拉列表
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")
	w "<option value=></option>"
	i (Type="")||(Type="0")||(Type="4") w "<option value=0>新增</option>"
	i Type'="2" w "<option value=1>提交</option>"      //modified by czf 2016-11-07 需求号：279415
	w "<option value=2>审核</option>"
	w "<option value=3>作废</option>"	
	w "</select>",!
}

ClassMethod GetStatus(Status)
{
	Quit $CASE(Status,"0":"新增","1":"提交","2":"审核","3":"作废",:"没有定义")
}

/// 描述:凭单明细来源类型
/// w ##Class(web.DHCEQPaymentNotice).GetSourceType(1)
ClassMethod GetSourceType(Type As %String = "")
{
	Quit:Type=1 "发票号"
	Quit ""
}

/// 创建:Mozy 2013-9-13
/// 设备付款通知单查找
/// d ##class(%ResultSet).RunQuery("web.DHCEQPaymentNotice","GetPaymentNotice","","0078453")
Query GetPaymentNotice(PaymentNoticeNo As %String = "", InvoiceNo As %String = "", LocDR As %String = "", Status As %String = "", ProviderDR As %String = "", StartDate As %String = "", EndDate As %String = "", InvalidFlag As %String = "N") As %Query(ROWSPEC = "TJob:%String,TRowID:%String,TPaymentNoticeNo:%String,TPaymentNoticeDate:%String,TLoc:%String,TProvider:%String,TBank:%String,TBankAccount:%String,TAccountDate:%String,TTotalFee:%String,TPurposeType:%String,TType:%String,TAgent:%String,TStatus:%String,TRemark:%String")
{
}

ClassMethod GetPaymentNoticeExecute(ByRef qHandle As %Binary, PaymentNoticeNo As %String = "", InvoiceNo As %String = "", LocDR As %String = "", Status As %String = "", ProviderDR As %String = "", StartDate As %String = "", EndDate As %String = "", InvalidFlag As %String = "N") As %Status
{
 	new repid, index, rowid, flag, id, no, TJob, PNum
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set index=1
 	Set TJob=$Job
 	Kill ^DHCEQTemp("GetPaymentNotice",TJob)
 	Set PNum=1
	If StartDate="" Set StartDate=0
	If EndDate="" Set EndDate=+$h
	
	Set rowid=0
	For  Set rowid=$Order(^DHCEQPaymentNotice(rowid)) Quit:rowid=""  Do
	.Do ResetVariablesGetPaymentNotice
	.Set TRowID = rowid
	.Set TInvalidFlag = $Piece($Get(^DHCEQPaymentNotice(rowid)),"^",26)
	.Quit:TInvalidFlag'="N"
	.Set TPaymentNoticeNo = $Piece($Get(^DHCEQPaymentNotice(rowid)),"^",1)
	.Quit:(PaymentNoticeNo'="")&(TPaymentNoticeNo'[PaymentNoticeNo)
	.Set TPaymentNoticeDate = $Piece($Get(^DHCEQPaymentNotice(rowid)),"^",2)
	.Quit:(TPaymentNoticeDate>EndDate)||(TPaymentNoticeDate<StartDate)
	.Set TPaymentNoticeDate = ##class(web.DHCEQCommon).TransValueToPage(TPaymentNoticeDate,"date")
	.Set TLocDR = $Piece($Get(^DHCEQPaymentNotice(rowid)),"^",3)
	.Quit:(LocDR'="")&(TLocDR'=LocDR)
	.;If TLocDR'="" Set TLoc = $Piece($Get(^CTLOC(TLocDR)),"^",2)   //modify by jyp 2019-10-18 CTLOC调整
	.If TLocDR'="" Set TLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)   //modify by jyp 2019-10-18 CTLOC调整
	.Set TProviderDR = $Piece($Get(^DHCEQPaymentNotice(rowid)),"^",4)
	.Quit:(ProviderDR'="")&(TProviderDR'=ProviderDR)
	.If TProviderDR '="" Set TProvider = ##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	.;Set TEquipTypeDR = $Piece($Get(^DHCEQPaymentNotice(rowid)),"^",5)
	.;Quit:##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	.;If TEquipTypeDR '="" Set TEquipType = $Piece($Get(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	.Set TBank = $Piece($Get(^DHCEQPaymentNotice(rowid)),"^",5)
	.Set TBankAccount = $Piece($Get(^DHCEQPaymentNotice(rowid)),"^",6)
	.Set TAccountDate = $Piece($Get(^DHCEQPaymentNotice(rowid)),"^",7)
	.Set TAccountDate = ##class(web.DHCEQCommon).TransValueToPage(TAccountDate,"date")
	.Set TTotalFee = $Piece($Get(^DHCEQPaymentNotice(rowid)),"^",8)
	.If TTotalFee'="" Set TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"",2)
	.Set TPurposeType = $Piece($Get(^DHCEQPaymentNotice(rowid)),"^",9)
	.Set TType = $Piece($Get(^DHCEQPaymentNotice(rowid)),"^",10)
	.Set TAgent = $Piece($Get(^DHCEQPaymentNotice(rowid)),"^",11)
	.Set TStatus = $Piece($Get(^DHCEQPaymentNotice(rowid)),"^",12)
	.Quit:(Status'="")&&(Status'=TStatus)
	.Set TStatus=##class(web.DHCEQPaymentNotice).GetStatus(TStatus)
	.Set TRemark = $Piece($Get(^DHCEQPaymentNotice(rowid)),"^",13)
	.
	.If InvoiceNo'="" Do
	..Set flag=1
	..Set id=0
	..For  Set id=$order(^DHCEQPaymentNoticeList(0,"PaymentNoticeDR",rowid,id)) Quit:(id="")||(flag'=1)  Do
	...Quit:($Piece($Get(^DHCEQPaymentNoticeList(id)),"^",2))'=1
	...Set no = $Piece($Get(^DHCEQPaymentNoticeList(id)),"^",3)
	...Set no = $Piece($Get(^DHCEQInvoice(no)),"^",2)
	...If no[InvoiceNo Set flag=""
	.Quit:flag'=""
	.Do OutputRowGetPaymentNotice
	
	Quit $$$OK
OutputRowGetPaymentNotice
	Set Data=$lb(TJob,TRowID,TPaymentNoticeNo,TPaymentNoticeDate,TLoc,TProvider,TBank,TBankAccount,TAccountDate,TTotalFee,TPurposeType,TType,TAgent,TStatus,TRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set ^DHCEQTemp("GetPaymentNotice",TJob,PNum)=TRowID_"^"_TPaymentNotice_"^"_TAccountDate_"^"_TLoc_"^"_TProvider_"^"_TEquipType_"^"_TCheckDate_"^"_TTotalFee_"^"_TStatus_"^"_TRemark
	Set PNum=PNum+1
	
	Quit
ResetVariablesGetPaymentNotice
	Set (TRowID,TPaymentNotice,TAccountDate,TLocDR,TLoc,TProviderDR,TProvider,TEquipTypeDR,TEquipType,TCheckDate,TTotalFee,TStatus,TRemark,flag)=""
	Quit
}

ClassMethod GetPaymentNoticeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPaymentNoticeExecute ]
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

ClassMethod GetPaymentNoticeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPaymentNoticeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQPaymentNotice).GetOnePaymentNoticeDetail(0,3824)
ClassMethod GetOnePaymentNoticeDetail(PNum As %Library.String = "", job As %Library.String = "")
{
	Quit:(PNum="")||(job="") ""
	Quit:PNum=0 $Order(^DHCEQTemp("GetPaymentNotice",job,""),-1)
	Quit $Get(^DHCEQTemp("GetPaymentNotice",job,PNum))
}

/// w ##Class(web.DHCEQPaymentNotice).GetOnePaymentNotice(1)
ClassMethod GetOnePaymentNotice(rowid)
{
	new result,resultex,tmp
	Set (result,resultex)=""
	Set result=^DHCEQPaymentNotice(rowid)
	Set $Piece(result,"^",2)=##class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",2),"date")	;PN_MakeDate
	Set resultex=resultex_"^"	;AN_LocDR
	If $Piece(result,"^",3)'=""  Do
	.Set resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$Piece(result,"^",3))
	Set resultex=resultex_"^"	;AN_ProviderDR
	If $Piece(result,"^",4)'=""  Do
	.Set resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("prov",$Piece(result,"^",4))
	Set $Piece(result,"^",7)=##class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",7),"date")	;PN_AccountDate
	Set resultex=resultex_"^"	;PN_TotalFee
	If $Piece(result,"^",8)'="" Do
	.Set tmp=##Class(web.DHCEQCommon).RMBDXXZH("","",$Piece(result,"^",8))	;大写金额
	.Set resultex=resultex_##Class(web.DHCEQCommon).Trim(tmp)
	.Set $Piece(result,"^",8)=##Class(web.DHCEQCommon).FormatNumber($Piece(result,"^",8),",",2)
	Set resultex=resultex_"^"	;PN_AuditUserDR
	If $Piece(result,"^",20)'="" Do
	.Set resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user", $Piece(result,"^",20))
	
	Set result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	Quit result_resultex
}

/*
/// w ##Class(web.DHCEQPaymentNotice).GetList(3)
ClassMethod GetList(PaymentNoticeDR As %Library.String = "")
{
	Quit:PaymentNoticeDR="" ""
	new (PaymentNoticeDR)
	Set Data=""
	Set Num=0
	
	Set (sumFee,sumQty)=0
	Set Rowid=0
	For  Set Rowid=$Order(^DHCEQPaymentNoticeList(0,"PaymentNoticeDR",PaymentNoticeDR,Rowid)) Quit:Rowid=""  Do
	.Set SourceType=$Piece($Get(^DHCEQPaymentNoticeList(Rowid)),"^",2)
	.Set SourceID=$Piece($Get(^DHCEQPaymentNoticeList(Rowid)),"^",3)
	.Set SourceInfo=##Class(web.DHCEQPaymentNotice).GetSourceInfo(SourceType,SourceID)
	.Set TSourceNo=$Piece(SourceInfo,"^",1)
	.;Set TMakeDate=$Piece(SourceInfo,"^",2)
	.;Set TLoc=$Piece(SourceInfo,"^",3)
	.If SourceType'="" Set SourceType=##Class(web.DHCEQPaymentNotice).GetSourceType(SourceType)
	.Set EquipType=$Piece($Get(^DHCEQPaymentNoticeList(Rowid)),"^",4)
	.If EquipType'="" Set EquipType=$Piece($Get(^DHCEQCCode("DHCEQCEquipType",EquipType)),"^",2)
	.Set Provider=$Piece($Get(^DHCEQPaymentNoticeList(Rowid)),"^",5)
	.If Provider'="" Set Provider=##class(web.DHCEQCommon).GetTrakNameByID("prov",Provider)
	.Set ManuFactory=$Piece($Get(^DHCEQPaymentNoticeList(Rowid)),"^",6)
	.Set EquipName=$Piece($Get(^DHCEQPaymentNoticeList(Rowid)),"^",7)
	.Set QuantityNum=$Piece($Get(^DHCEQPaymentNoticeList(Rowid)),"^",8)
	.Set Amount=$Piece($Get(^DHCEQPaymentNoticeList(Rowid)),"^",9)
	.Set Remark=$Piece($Get(^DHCEQPaymentNoticeList(Rowid)),"^",10)
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
*/
/// w ##Class(web.DHCEQPaymentNotice).SaveData("6^22613080006^29/08/2013^226^5^2^01/08/2013^^^^^1116^2227^3338^4449^5550","1^1^1^3^^^^C-臂系统升级套件(DSA),净化装置^6^81000^123^^^^^","")
ClassMethod SaveData(val, valList, DelRowid)
{
	Set $ZT="ERRORSave"
	Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	new (val, valList, DelRowid, User)
	;s ^DHCEQMozy("DHCEQPaymentNotice")=val
	Set Date=+$H
	Set Time=$Piece($H,",",2)
	Set RowID=$Piece(val,"^",1)
	
	Set PLIST(2) = $Piece(val,"^",2)	;PN_NoticeNo
	Set PLIST(3) = $Piece(val,"^",3)	;PN_MakeDate
	Set PLIST(3) = ##class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",3),"date")
	Set PLIST(4) = $Piece(val,"^",4)	;PN_LocDR
	Set PLIST(5) = $Piece(val,"^",5)	;PN_ProviderDR
	Set PLIST(6) = $Piece(val,"^",6)	;PN_Bank
	Set PLIST(7) = $Piece(val,"^",7)	;PN_BankAccount
 	Set PLIST(8) = $Piece(val,"^",8)	;PN_AccountDate
 	Set PLIST(8) = ##class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",8),"date")
 	//Set PLIST(9) = $Piece(val,"^",9)	;AN_TotalFee
 	Set PLIST(10) = $Piece(val,"^",10)	;PN_PurposeType
 	Set PLIST(11) = $Piece(val,"^",11)	;PN_Type
 	Set PLIST(12) = $Piece(val,"^",12)	;PN_Agent
 	Set PLIST(13) = 0					;PN_Status
 	Set PLIST(14) = $Piece(val,"^",13)	;PN_Remark
 	Set PLIST(15) = User
 	Set PLIST(16) = Date
 	Set PLIST(17) = Time
 	Set PLIST(27) = "N"					;PN_InvalidFlag
 	Set PLIST(28) = $Piece(val,"^",14)	;Hold1
 	Set PLIST(29) = $Piece(val,"^",15)	;Hold2
 	Set PLIST(30) = $Piece(val,"^",16)	;Hold3
 	Set PLIST(31) = $Piece(val,"^",17)	;Hold4
 	Set PLIST(32) = $Piece(val,"^",18)	;Hold5
	TSTART	
 	if RowID=""
 	{
		If PLIST(2)="" Set PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQPaymentNotice",Date,$Piece(val,"^",4))
		&SQL(insert into sqluser.DHC_EQPaymentNotice values :PLIST())
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		Set RowID=$Get(%ROWID)
 	}
 	else
 	{
		&SQL(update sqluser.DHC_EQPaymentNotice values :PLIST() where PN_RowID=:RowID)
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
 	}
 	
 	Set SQLCODE=##Class(web.DHCEQPaymentNotice).DeletePaymentNoticeList(DelRowid)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	
 	Set SQLCODE=##Class(web.DHCEQPaymentNotice).SavePaymentNoticeList(RowID,valList,User)
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

/// 一张发票只能做一张付款通知单
/// 返回:0	有效,1	无效
/// w ##Class(web.DHCEQPaymentNotice).CheckSourceIDIsInValid(1,5,2)
ClassMethod CheckSourceIDIsInValid(SourceType As %String = "", SourceID As %String = "", ID As %String = "")
{
	Quit:(SourceType="")||(SourceID="") 1
	new (SourceType,SourceID,ID)
	
	Set Flag=0
	Set Rowid=0
	For  Set Rowid=$Order(^DHCEQPaymentNoticeList(0,"Source",SourceType,SourceID,Rowid)) Quit:Rowid=""  Do
	.Set PaymentNoticeDR=$Piece($Get(^DHCEQPaymentNoticeList(Rowid)),"^",1)
	.Set Status=$Piece($Get(^DHCEQPaymentNotice(PaymentNoticeDR)),"^",12)
	.If (Status'=3)&(ID'=Rowid) Set Flag=1
	
	Quit Flag
}

/// w ##Class(web.DHCEQPaymentNotice).SavePaymentNoticeList(1,"1^^1^3^4^100000^^^^^^",1)
ClassMethod SavePaymentNoticeList(PNRowID As %String = "", val As %String = "", User As %String = "")
{
	Quit:PNRowID="" -1
	Quit:val="" 0
	
	new Length,PNLRowID,Flag,i
	new valList,TSourceType,TSourceID,TotalFee,id
	Kill PLIST
	
	Set Length=$l(val,"&")
	Set PLIST(2)=PNRowID
	Set Flag=0
	For i=1:1:Length
	{
		Quit:Flag'=0
		Set valList=$Piece(val,"&",i)
		Set PNLRowID=$Piece(valList,"^",2)
		Set PLIST(3)=$Piece(valList,"^",3)  	;PNL_SourceType
		Set PLIST(4)=$Piece(valList,"^",4)		;PNL_SourceID
		Set PLIST(5)=$Piece(valList,"^",5)  	;PNL_ExtendType
		Set PLIST(6)=$Piece(valList,"^",6)		;PNL_ExtendID
		Set PLIST(7)=$Piece(valList,"^",7)		;PNL_ProviderDR
		Set PLIST(8)=$Piece(valList,"^",8)  	;PNL_AmountFee
		Set PLIST(9)=$Piece(valList,"^",9)  	;PNL_Remark
		Set PLIST(10)=User						;PNL_UpdateUserDR
		Set PLIST(11)=+$H  						;PNL_UpdateDate
		Set PLIST(12)=$Piece($H,",",2)  		;PNL_UpdateTime
		Set PLIST(13)=$Piece(valList,"^",10)	;Hold1
 		Set PLIST(14)=$Piece(valList,"^",11)	;Hold2
 		Set PLIST(15)=$Piece(valList,"^",12)	;Hold3
 		Set PLIST(16)=$Piece(valList,"^",13)	;Hold4
 		Set PLIST(17)=$Piece(valList,"^",14)	;Hold5
		if (PNLRowID="")
		{
			&SQL(Insert Into SQLUSER.DHC_EQPaymentNoticeList Values :PLIST())
			;Set PNLRowID=$Get(%ROWID)
		}
		else
		{
			&SQL(update sqluser.DHC_EQPaymentNoticeList Values :PLIST() where PNL_RowID=:PNLRowID)
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
	For  Set id=$Order(^DHCEQPaymentNoticeList(0,"PaymentNoticeDR",PNRowID,id)) Quit:id=""  Do
	.Set TotalFee = TotalFee+$Piece($Get(^DHCEQPaymentNoticeList(id)),"^",7)
	&SQL(Update SQLUSER.DHC_EQPaymentNotice Set PN_TotalFee=:TotalFee where PN_RowID=:PNRowID)
	
	Quit Flag
}

/// w ##Class(web.DHCEQPaymentNotice).DeletePaymentNoticeList(",2,0,-1")
ClassMethod DeletePaymentNoticeList(DelRowIDs As %String = "")
{
	Quit:DelRowIDs="" 0
	new Length,PNLRowID,i
	
	Set SQLCODE=0
	Set Length=$l(DelRowIDs,",")
	For i=1:1:Length
	{
		Set PNLRowID=+$Piece(DelRowIDs,",",i)
		If (PNLRowID>0)
		{
			&SQL(Delete from sqluser.DHC_EQPaymentNoticeList where PNL_RowID=:PNLRowID)
		}
		Quit:SQLCODE
	}
	Quit SQLCODE
}

/// w ##Class(web.DHCEQPaymentNotice).DeleteData("6")
ClassMethod DeleteData(RowID As %String = "")
{
	If RowID="" Quit ""
	Set $ZT="ERRORDelete"
	Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set Date=+$H
	Set Time=$Piece($H,",",2)
	
	TSTART
	&SQL(Update SQLUSER.DHC_EQPaymentNotice Set PN_InvalidFlag='Y',PN_UpdateUserDR=:User,PN_UpdateDate=:Date,PN_UpdateTime=:Time where PN_RowID=:RowID)
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

/// w ##Class(web.DHCEQPaymentNotice).GetAudit("4")
ClassMethod GetAudit(RowID As %String = "")
{
	If RowID="" Quit ""
	Set $ZT="ERRORGetAudit"
	Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set Date=+$H
	Set Time=$Piece($H,",",2)
	
	TSTART
	
	&SQL(Update SQLUSER.DHC_EQPaymentNotice Set PN_Status=2,PN_AuditUserDR=:User,PN_AuditDate=:Date,PN_AuditTime=:Time where PN_RowID=:RowID)
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

/// w ##Class(web.DHCEQPaymentNotice).SubmitData("4")
ClassMethod SubmitData(RowID As %String = "")
{
	If RowID="" Quit ""
	Set $ZT="ERRORSubmitData"
	Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set Date=+$H
	Set Time=$Piece($H,",",2)
	
	TSTART
	&SQL(Update SQLUSER.DHC_EQPaymentNotice Set PN_Status=1,PN_SubmitUserDR=:User,PN_SubmitDate=:Date,PN_SubmitTime=:Time where PN_RowID=:RowID)
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

/// w ##Class(web.DHCEQPaymentNotice).CancelSubmitData("4")
ClassMethod CancelSubmitData(RowID As %String = "")
{
	If RowID="" Quit ""
	Set $ZT="ERRORCancelSubmitData"
	Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set Date=+$H
	Set Time=$Piece($H,",",2)
	
	TSTART
	&SQL(Update SQLUSER.DHC_EQPaymentNotice Set PN_Status=3,PN_DisUseUserDR=:User,PN_DisUseDate=:Date,PN_DisUseTime=:Time where PN_RowID=:RowID)
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

/// 创建:Mozy 2013-9-16
/// 描述:付款通知单业务明细查询
/// d ##class(%ResultSet).RunQuery("web.DHCEQPaymentNotice","GetPaymentNoticeList",4)
Query GetPaymentNoticeList(RowID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TRow:%String,TSourceType:%String,TSourceID:%String,TSourceNo:%String,TExtendType:%String,TExtendID:%String,TExtendNo:%String,TExtendDate:%String,TEquipName:%String,TManuFactory:%String,TOriginalFee:%String,TQuantityNum:%String,TAmountFee:%String,TRemark:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String")
{
}

ClassMethod GetPaymentNoticeListExecute(ByRef qHandle As %Binary, RowID As %String = "") As %Status
{
 	new repid, index, TotalQty, Total, TotalFlag, SourceInfo
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	
	Set (TotalQty,Total)=0
	Set index=1
	Set TotalFlag=##class(web.DHCEQCommon).GetSysInfo("301006")
	If TotalFlag="1" Set index=2
	
	Set TRow=0
	Set PaymentNoticeDR=RowID
	If PaymentNoticeDR'=""
	{
		Set rowid=0 
		For  Set rowid=$Order(^DHCEQPaymentNoticeList(0,"PaymentNoticeDR",RowID,rowid)) Quit:rowid=""  Do
		.Do ResetVariablesGetPaymentNoticeList
		.Set TRowID = rowid
		.Set TSourceType=$Piece($Get(^DHCEQPaymentNoticeList(rowid)),"^",2)
		.Set TSourceID=$Piece($Get(^DHCEQPaymentNoticeList(rowid)),"^",3)
		.Set TSourceNo=$Piece($Get(^DHCEQInvoice(TSourceID)),"^",2)
		.Set TExtendType=$Piece($Get(^DHCEQPaymentNoticeList(rowid)),"^",4)
		.Set TExtendID=$Piece($Get(^DHCEQPaymentNoticeList(rowid)),"^",5)
		.If TExtendType=0 Do
		..;来源类型是验收明细
		..;Set ISRowID=$Piece($Get(^DHCEQInStockList(TExtendID)),"^",1)
		..;Set TExtendNo=$Piece($Get(^DHCEQInStock(ISRowID)),"^",14)
		..;Set TInDate=$Piece($Get(^DHCEQInStock(ISRowID)),"^",1)
		..;If TInDate'="" Set TInDate = ##class(web.DHCEQCommon).TransValueToPage(TInDate,"date")
		..;Set TEquipTypeDR=$Piece($Get(^DHCEQInStock(ISRowID)),"^",20)
		..;Set TEquipName=$Piece($Get(^DHCEQInStockList(TExtendID)),"^",5)
		..;Set TManuFactoryDR=$Piece($Get(^DHCEQInStockList(TExtendID)),"^",6)
		..;If TManuFactoryDR'="" Set TManuFactory=$Piece($Get(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1)
		..;Set TOriginalFee=+$Piece($Get(^DHCEQInStockList(TExtendID)),"^",7)
		..;Set TQuantityNum=+$Piece($Get(^DHCEQInStockList(TExtendID)),"^",8)
		.If TExtendType=1 Do
		..;来源类型是入库明细
		..Set ISRowID=$Piece($Get(^DHCEQInStockList(TExtendID)),"^",1)
		..Set TExtendNo=$Piece($Get(^DHCEQInStock(ISRowID)),"^",14)
		..Set TExtendDate=$Piece($Get(^DHCEQInStock(ISRowID)),"^",1)
		..Set TExtendDate = ##class(web.DHCEQCommon).TransValueToPage(TExtendDate,"date")
		..Set TEquipTypeDR=$Piece($Get(^DHCEQInStock(ISRowID)),"^",20)
		..Set TEquipName=$Piece($Get(^DHCEQInStockList(TExtendID)),"^",5)
		..Set TManuFactoryDR=$Piece($Get(^DHCEQInStockList(TExtendID)),"^",6)
		..If TManuFactoryDR'="" Set TManuFactory=$Piece($Get(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1)
		..Set TOriginalFee=$Piece($Get(^DHCEQInStockList(TExtendID)),"^",7)
		..Set TQuantityNum=$Piece($Get(^DHCEQInStockList(TExtendID)),"^",8)
		.Quit:##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
		.;Set TProviderDR=$Piece($Get(^DHCEQPaymentNoticeList(rowid)),"^",6)
		.;If TProviderDR'="" Set TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
		.Set TAmountFee=$Piece($Get(^DHCEQPaymentNoticeList(rowid)),"^",7)
		.Set TRemark=$Piece($Get(^DHCEQPaymentNoticeList(rowid)),"^",8)
		.Set THold1=$Piece($Get(^DHCEQPaymentNoticeList(rowid)),"^",12)
		.Set THold2=$Piece($Get(^DHCEQPaymentNoticeList(rowid)),"^",13)
		.Set THold3=$Piece($Get(^DHCEQPaymentNoticeList(rowid)),"^",14)
		.Set THold4=$Piece($Get(^DHCEQPaymentNoticeList(rowid)),"^",15)
		.Set THold5=$Piece($Get(^DHCEQPaymentNoticeList(rowid)),"^",16)
		.Set TRow=TRow+1
		.Set Total=Total+TAmountFee
		.Do OutputRowGetPaymentNoticeList
	}
	;没有数据时,也返回一个空行,用于编辑
	If TRow=0 Do
	.Do ResetVariablesGetPaymentNoticeList
	.Set TRow=1
	.Do OutputRowGetPaymentNoticeList
	
	;处理合计行
	If TotalFlag>0 Do
	.Do ResetVariablesGetPaymentNoticeList
	.Set TRowID=-1
	.Set TTotalNum=TotalQty
	.Set TAmountFee=##Class(web.DHCEQCommon).FormatNumber(Total,"",2)
	.If TotalFlag="1" Do
	..Set index=1
	.Else  Do
	..Set index=index+1
	.Do OutputRowGetPaymentNoticeList
	Quit $$$OK
	
OutputRowGetPaymentNoticeList
	Set Data=$lb(TRowID,TRow,TSourceType,TSourceID,TSourceNo,TExtendType,TExtendID,TExtendNo,TExtendDate,TEquipName,TManuFactory,TOriginalFee,TQuantityNum,TAmountFee,TRemark,THold1,THold2,THold3,THold4,THold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetPaymentNoticeList
	Set (TRowID,TSourceType,TSourceID,TSourceNo,TExtendType,TExtendID,TExtendNo,TExtendDate,TEquipName,TManuFactory,TOriginalFee,TQuantityNum,TAmountFee,TRemark,THold1,THold2,THold3,THold4,THold5)=""
	Quit
}

ClassMethod GetPaymentNoticeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPaymentNoticeListExecute ]
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

ClassMethod GetPaymentNoticeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPaymentNoticeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQPaymentNotice","GetInvoice","",15)
Query GetInvoice(EquipTypeDR As %String = "", ProviderDR As %String = "", SourceNo As %String = "", id As %String = "") As %Query(ROWSPEC = "Hidden:%String,Hidden:%String,Hidden:%String,TNo:%String,TInStockNo:%String,TInDate:%String,TEquipName:%String,TManuFactory:%String,TOriginalFee:%String,TQuantityNum:%String,TBuyLoc:%String,TRemark:%String")
{
}

ClassMethod GetInvoiceExecute(ByRef qHandle As %Binary, EquipTypeDR As %String = "", ProviderDR As %String = "", SourceNo As %String = "", id As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set SourceNo=$ZCONVERT(SourceNo,"U")
	;//^DHCEQInvoice(0,"StatusProvider",0,15,2)
	Set IVStatus=""
	For  Set IVStatus=$Order(^DHCEQInvoice(0,"StatusProvider",IVStatus)) Quit:IVStatus=""  Do
	.Set rowid=0
	.For  Set rowid=$Order(^DHCEQInvoice(0,"StatusProvider",IVStatus,ProviderDR,rowid)) Quit:rowid=""  Do
	..Set TNo=$Piece($Get(^DHCEQInvoice(rowid)),"^",2)
	..Quit:(SourceNo'="")&($ZCONVERT(TNo,"U")'[SourceNo)
	..Set IUMRowID=0
	..For  Set IUMRowID=$Order(^DHCEQInvoiceUseMap(0,"Invoice",rowid,IUMRowID)) Quit:IUMRowID=""  Do
	...Do ResetVariablesGetInvoice
	...Set Type=$Piece($Get(^DHCEQInvoiceUseMap(IUMRowID)),"^",3)
	...Quit:Type'=1		;过滤非入库单的发票
	...Set TExtendType=1
	...Set ISLRowid=$Piece($Get(^DHCEQInvoiceUseMap(IUMRowID)),"^",1)	;SourceID
	...Set TExtendID=ISLRowid
	...Set ISRowID=$Piece($Get(^DHCEQInStockList(ISLRowid)),"^",1)
	...Set TInvalidFlag=$Piece($Get(^DHCEQInStock(ISRowID)),"^",25)
	...Quit:TInvalidFlag="Y"
	...Set TEquipTypeDR=$Piece($Get(^DHCEQInStock(ISRowID)),"^",20)
	...Quit:(EquipTypeDR'="")&(TEquipTypeDR'=EquipTypeDR)
	...Quit:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	...Set TEquipType=$Piece($Get(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	...Set Status=$Piece($Get(^DHCEQInStock(ISRowID)),"^",10)
	...Quit:(Status'=2)
	...Quit:##Class(web.DHCEQPaymentNotice).CheckSourceIDIsInValid(1,rowid,id)
	...Set TInStockNo=$Piece($Get(^DHCEQInStock(ISRowID)),"^",14)
	...Set TInDate=$Piece($Get(^DHCEQInStock(ISRowID)),"^",1)
	...Set TInDate=##class(web.DHCEQCommon).TransValueToPage(TInDate,"date")
	...Set TEquipName=$Piece($Get(^DHCEQInStockList(ISLRowid)),"^",5)
	...Set TManuFactoryDR=$Piece($Get(^DHCEQInStockList(ISLRowid)),"^",6)
	...If TManuFactoryDR'="" Set TManuFactory=$Piece($Get(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1)
	...Set TOriginalFee=+$Piece($Get(^DHCEQInStockList(ISLRowid)),"^",7)
	...Set TQuantityNum=+$Piece($Get(^DHCEQInStockList(ISLRowid)),"^",8)
	...Set TRemark=$Piece($Get(^DHCEQInStock(ISRowID)),"^",11)
	...Set TBuyLocDR=$Piece($Get(^DHCEQInStock(ISRowID)),"^",18)
	...If TBuyLocDR'="" Set TBuyLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept", TBuyLocDR)
	...If TBuyLoc'="" Set TBuyLoc=##class(web.DHCEQCommon).GetSplitDataByFlag(TBuyLoc,"-")
	...Do OutputRowGetInvoice
	
	Quit $$$OK
OutputRowGetInvoice
	Set Data=$lb(rowid,TExtendType,TExtendID,TNo,TInStockNo,TInDate,TEquipName,TManuFactory,TOriginalFee,TQuantityNum,TBuyLoc,TRemark)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetInvoice
	Set (TExtendType,TExtendID,TInStockNo,TInDate,TEquipName,TManuFactory,TOriginalFee,TQuantityNum,TBuyLoc,TRemark)=""
	Quit
}

ClassMethod GetInvoiceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInvoiceExecute ]
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

ClassMethod GetInvoiceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInvoiceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
