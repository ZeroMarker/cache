Import SQLUser

Class web.DHCEQAppendFee Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 58;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "AF_RowID";

Parameter SQLDESCRIPTION = "AF_RowID";

Parameter SQLROWID = "AF_RowID";

Parameter GlobalLen = 16;

ClassMethod GetAppendFeeByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQAppendFee(rowid)
	set count=..#GlobalLen-$l(result,"^")
	for i=count:-1:1 { s result=result_"^"}	
	s resultex=resultex_"^"	;EquipDR
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",1))),"^",1)
	s resultex=resultex_"^"	;AppendFeeTypeDR
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCAppendFeeType",$p(result,"^",2))),"^",2)
	s $p(result,"^",4)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",4),"date")	;OccDate
	s resultex=resultex_"^"	;PayUserDR
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",5))
	s $p(result,"^",7)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",7),"date")	;InvoiceDate
	s resultex=resultex_"^"	;AddUserDR
	i $p(result,"^",9)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",9))
	s $p(result,"^",10)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",10),"date")	;AddDate
	s resultex=resultex_"^"	;UpdateUserDR
	i $p(result,"^",12)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",12))
	s $p(result,"^",13)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",13),"date")	;UpdateDate
	s resultex=resultex_"^"	;CurrencyDR
	i $p(result,"^",15)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("cur",$p(result,"^",15))
	q result_resultex
}

ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", user As %Library.String = "", isDel As %Library.String = "")
{
 k PLIST,rowid
 s rowid=$p(val,"^",1)
 s result=0,equipdr=""
 TStart
 i (+isDel=1)
 {
	s upddate=+$H
	s updtime=$P($H,",",2)
 	&SQL(Update SQLUSER.DHC_EQAppendFee 
 		set AF_InvalidFlag='Y',AF_UpdateUserDR=:user,AF_UpdateDate=:upddate,AF_UpdateTime=:updtime
 		 where AF_RowID = :rowid)
 	if SQLCODE 
 		{TRollBack
 	 	q SQLCODE}
 	s equipdr=$p($g(^DHCEQAppendFee(rowid)),"^",1)
 	
 	///add 2007-1-24 修改设备原值
 	s ChangeFee=$p($g(^DHCEQAppendFee(rowid)),"^",3)
 	i ChangeFee="" s ChangeFee=0
 	s ChangeFee=-ChangeFee
 	s result=..UpdateEquipOriginalFee(equipdr,ChangeFee)
 	if (result'=0)
 		{TRollBack 	
 		 q -1}
 	///end
 		 
 	s result=..AppendFeeChanged(equipdr,rowid,2)
 	if (result'=0)
 		{TRollBack 	
 		 q -1}
 	TCommit
 	q rowid
 }
 s PLIST(1) = $p(val,"^",1)	;RowID
 s PLIST(2) = $p(val,"^",2)	;EquipDR
 s PLIST(3) = $p(val,"^",3)	;AppendFeeTypeDR
 s PLIST(4) = $p(val,"^",4)	;AppendFee
 s PLIST(5) = $p(val,"^",5)	;OccDate
 i $p(val,"^",5)'=""  s PLIST(5) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",5),"date")	;OccDate
 s PLIST(6) = $p(val,"^",6)	;PayUserDR
 s PLIST(7) = $p(val,"^",7)	;InvoiceNo
 s PLIST(8) = $p(val,"^",8)	;InvoiceDate
 i $p(val,"^",8)'=""  s PLIST(8) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",8),"date")	;InvoiceDate
 s PLIST(9) = $p(val,"^",9)	;Remark
 s PLIST(16) = $p(val,"^",16)	;CurrencyDR
 
 ////add  2007-1-24 修改设备原值
 s ChangeFee=PLIST(4)
 i ChangeFee="" s ChangeFee=0
 i rowid=""
 {
	 s OldFee=0
 }
 else
 {
	 s OldFee=$p($g(^DHCEQAppendFee(rowid)),"^",3)
	 i OldFee="" s OldFee=0
 }
 s ChangeFee=ChangeFee-OldFee
 s result=..UpdateEquipOriginalFee(PLIST(2),ChangeFee)
 if (result'=0)
 	{TRollBack 	
 	 q -1}
 ///end
 
 k PLIST(1)
 if (rowid'="") 
 {
	 s opertype=1
	 s PLIST(13) = user
	 s PLIST(14) = +$H
	 s PLIST(15) = $P($H,",",2)
	 &SQL(Update SQLUSER.DHC_EQAppendFee Values :PLIST() where AF_RowID = :rowid) 	 
 }
 else
 {	 
 	 s opertype=0
 	 s PLIST(10) = user
	 s PLIST(11) = +$H
	 s PLIST(12) = $P($H,",",2)
	 s PLIST(17) ="N"
	 &SQL(Insert Into SQLUSER.DHC_EQAppendFee Values :PLIST())
 }
 if SQLCODE  
 	{TRollBack
 	q SQLCODE} 	
 Set ID=$g(%ROWID)
 s equipdr=$p($g(^DHCEQAppendFee(ID)),"^",1)
 s result=..AppendFeeChanged(equipdr,ID,opertype)
 if (result'=0)
 	{TRollBack
 	q -1
 	}
 TCommit
 q ID
}

Query GetAppendFee(EquipDR As %String) As %Query(ROWSPEC = "TRowID:%String,TEquipDR:%String,TAppendFeeTypeDR:%String,TAppendFee:%String,TOccDate:%String,TPayUserDR:%String,TInvoiceNo:%String,TInvoiceDate:%String,TRemark:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TCurrencyDR:%String,TEquip:%String,TAppendFeeType:%String,TPayUser:%String,TAddUser:%String,TUpdateUser:%String,TCurrency:%String")
{
}

ClassMethod GetAppendFeeExecute(ByRef qHandle As %Binary, EquipDR As %String) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	i EquipDR'="" d
	.d BuildDataGetAppendFee
	Quit $$$OK
BuildDataGetAppendFee
	f  s rowid=$o(^DHCEQAppendFee(0,"Equip",EquipDR,rowid))  quit:rowid=""  d
	.d ResetVariablesGetAppendFee
	.s TRowID = rowid
	.s TEquipDR=EquipDR
	.//s TEquipDR = $p($g(^DHCEQAppendFee(rowid)),"^",1)
	.//q:(TEquipDR'=EquipDR)||(EquipDR="")
	.q:($p($g(^DHCEQAppendFee(rowid)),"^",16)="Y")
	.i TEquipDR '=""  d
	..s TEquip = $p($g(^DHCEQEquip(TEquipDR)),"^",1)
	.s TAppendFeeTypeDR = $p($g(^DHCEQAppendFee(rowid)),"^",2)
	.i TAppendFeeTypeDR '=""  d
	..s TAppendFeeType = $p($g(^DHCEQCCode("DHCEQCAppendFeeType",TAppendFeeTypeDR)),"^",2)
	.s TAppendFee = $p($g(^DHCEQAppendFee(rowid)),"^",3)
	.s TOccDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAppendFee(rowid)),"^",4),"date")
	.s TPayUserDR = $p($g(^DHCEQAppendFee(rowid)),"^",5)
	.i TPayUserDR '=""  d
	..s TPayUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user",TPayUserDR)
	.s TInvoiceNo = $p($g(^DHCEQAppendFee(rowid)),"^",6)
	.s TInvoiceDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAppendFee(rowid)),"^",7),"date")
	.s TRemark = $p($g(^DHCEQAppendFee(rowid)),"^",8)
	.s TAddUserDR = $p($g(^DHCEQAppendFee(rowid)),"^",9)
	.i TAddUserDR '=""  d
	..s TAddUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR)
	.s TAddDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAppendFee(rowid)),"^",10),"date")
	.s TAddTime = $p($g(^DHCEQAppendFee(rowid)),"^",11)
	.s TUpdateUserDR = $p($g(^DHCEQAppendFee(rowid)),"^",12)
	.i TUpdateUserDR '=""  d
	..s TUpdateUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	.s TUpdateDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAppendFee(rowid)),"^",13),"date")
	.s TUpdateTime = $p($g(^DHCEQAppendFee(rowid)),"^",14)
	.s TCurrencyDR = $p($g(^DHCEQAppendFee(rowid)),"^",15)
	.i TCurrencyDR '=""  d
	..s TCurrency = ##Class(web.DHCEQCommon).GetTrakNameByID("cur",TCurrencyDR)
	.q:$p($g(^DHCEQAppendFee(rowid)),"^",16)'="N"
	.d OutputRowGetAppendFee
	quit
OutputRowGetAppendFee
	s Data=$lb(TRowID,TEquipDR,TAppendFeeTypeDR,TAppendFee,TOccDate,TPayUserDR,TInvoiceNo,TInvoiceDate,TRemark,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TCurrencyDR,TEquip,TAppendFeeType,TPayUser,TAddUser,TUpdateUser,TCurrency)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetAppendFee
	s (TRowID,TEquipDR,TAppendFeeTypeDR,TAppendFee,TOccDate,TPayUserDR,TInvoiceNo,TInvoiceDate,TRemark,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TCurrencyDR,TEquip,TAppendFeeType,TPayUser,TAddUser,TUpdateUser,TCurrency)=""
	quit
}

ClassMethod GetAppendFeeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAppendFeeExecute ]
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

ClassMethod GetAppendFeeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAppendFeeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// opertype  操作类型 0：新增  1：修改  2：删除
ClassMethod AppendFeeChanged(equip, id, opertype)
{
	new rowid,fee,totalfee,feemode
	if equip=""  q -1
	set feemode=$o(^DHCEQCCode("DHCEQCFeeMode",0,"FMType",2,0))	
	if (opertype=2)
	{
		&sql(Delete from Sqluser.DHC_EQLifeFee
				Where LF_SourceDR=:id and LF_FeeTypeDR=:feemode)
		if SQLCODE  q SQLCODE
	}
	s rowid=0,fee=0,totalfee=0
	
	f  s rowid=$o(^DHCEQAppendFee(0,"Equip",equip,rowid)) q:rowid=""  d
	.i $p($g(^DHCEQAppendFee(rowid)),"^",16)="N"  d
	..s totalfee=totalfee+$p($g(^DHCEQAppendFee(rowid)),"^",3)
	.i rowid=id  d
	..s fee=$p($g(^DHCEQAppendFee(rowid)),"^",3)
	..s feedate=$p($g(^DHCEQAppendFee(rowid)),"^",4)
	i (fee="") q -1
	if (opertype=0)
	{	&SQL(Insert into Sqluser.DHC_EQLifeFee
		(LF_EquipDR,LF_SourceDR,LF_FeeTypeDR,LF_UseFee,LF_FeeDate,LF_IsInputFlag)
		values (:equip,:id,:feemode,:fee,:feedate,'N'))
		if SQLCODE   q SQLCODE
	}
	elseif(opertype=1)
	{	&sql(Update Sqluser.DHC_EQLifeFee
			set LF_UseFee=:fee,LF_FeeDate=:feedate
			Where LF_SourceDR=:id and LF_FeeTypeDR=:feemode)
		if SQLCODE   q SQLCODE
	}
	
	&SQL(Update sqluser.DHC_EQEquip Set EQ_AppendFeeTotalFee=:totalfee where EQ_RowID = :equip)
	q SQLCODE
}

/// 修改设备原值、净值  ChangeFee为修改金额
ClassMethod UpdateEquipOriginalFee(EquipID, ChangeFee)
{
	new OriginalFee,NetFee
	if EquipID=""  q -1
	s OriginalFee=$p(^DHCEQEquip(EquipID),"^",27)
	i OriginalFee="" s OriginalFee=0
	s OriginalFee=OriginalFee+ChangeFee
	s NetFee=$p(^DHCEQEquip(EquipID),"^",28)
	i NetFee="" s NetFee=0
	s NetFee=NetFee+ChangeFee
	&SQL(Update sqluser.DHC_EQEquip Set EQ_OriginalFee=:OriginalFee,EQ_NetFee=:NetFee where EQ_RowID = :EquipID)
	q SQLCODE
}

/*
ClassMethod AfterDelete(id, equipdr)
{
	set feemode=$o(^DHCEQCCode("DHCEQCFeeMode",0,"FMType",2,0))	
	&sql(Delete from Sqluser.DHC_EQLifeFee
				Where LF_SourceDR=:id and LF_FeeTypeDR=:feemode)
}

ClassMethod AfterInsert(id, equipdr, fee, feedate, user, adddate, addtime)
{
	
	set feemode=$o(^DHCEQCCode("DHCEQCFeeMode",0,"FMType",2,0))
	&sql(Insert into Sqluser.DHC_EQLifeFee
			(LF_EquipDR,LF_SourceDR,LF_FeeTypeDR,LF_UseFee,LF_FeeDate,LF_IsInputFlag)
			values (:equipdr,:id,:feemode,:fee,:feedate,'N'))
}

ClassMethod AfterUpdate(id, equipdr, fee, feedate, user, adddate, addtime)
{
	set feemode=$o(^DHCEQCCode("DHCEQCFeeMode",0,"FMType",2,0))
	set rowid="",oldfee=0	
	&sql(Select LF_RowID,LF_UseFee into :rowid,:oldfee from Sqluser.DHC_EQLifeFee Where LF_SourceDR=:id and LF_FeeTypeDR=:feemode)	
	if (rowid="")
	{
	&sql(Insert into Sqluser.DHC_EQLifeFee
			(LF_EquipDR,LF_SourceDR,LF_FeeTypeDR,LF_UseFee,LF_FeeDate,LF_IsInputFlag)
			values (:equipdr,:id,:feemode,:fee,:feedate,'N'))
	}
	else
	{
		if (oldfee'=fee)
		{
			&sql(Update Sqluser.DHC_EQLifeFee
				set LF_UseFee=:fee
				Where LF_SourceDR=:id and LF_FeeTypeDR=:feemode)
		}
	}
}
*/
}
