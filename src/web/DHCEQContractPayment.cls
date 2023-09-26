Import SQLUser

Include webimport

IncludeGenerator webimport

Class web.DHCEQContractPayment Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 29;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "CTP_RowID";

Parameter SQLDESCRIPTION = "CTP_RowID";

Parameter SQLROWID = "CTP_RowID";

ClassMethod UpdateData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val, AppType, User)
{
	;+AppType=0 新增
	;+AppType=1 更新
	;+AppType=2 删除
	s PLIST(1) = $p(val,"^",1)	;RowID
	s RowID=PLIST(1)
 	s PLIST(2) = $p(val,"^",2)	;Remark
 	s PLIST(3) = $p(val,"^",3)	;PayNo
 	s PLIST(4) = $p(val,"^",4)	;PayFee
 	s PLIST(5) = $p(val,"^",5)	;PayDate
 	i $p(val,"^",5)'=""  s PLIST(5) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",5),"date")	;PayDate
 	s PLIST(6) = $p(val,"^",6)	;ContractDR
 	s PLIST(7) = $p(val,"^",7)	;InvoiceNo
 	s PLIST(8) = $p(val,"^",8)	;InvoiceFee
 	s PLIST(9) = $p(val,"^",9)	;InvoiceDate
 	i $p(val,"^",9)'=""  s PLIST(9) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",9),"date")	;InvoiceDate
 	s PLIST(10) = "N" //$p(val,"^",10)	;InvalidFlag
 	i $p(val,"^",10)'=""  s PLIST(10) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",10),"bool")	;InvalidFlag
 	s PLIST(11) = User //$p(val,"^",11)	;UpdateUserDR
 	s PLIST(12) = +$H //$p(val,"^",12)	;UpdateDate
 	//i $p(val,"^",12)'=""  s PLIST(12) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",12),"date")	;UpdateDate
 	s PLIST(13) =$p($h,",",2) // $p(val,"^",13)	;UpdateTime
 	s PLIST(14) = $p(val,"^",14)	;PayedFee
 	k PLIST(1)
 	TSTART
 	if +AppType=0
 	{
	 	&sql(insert into sqluser.DHC_EQContractPayment values :PLIST())
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
	 	s SQlCODE=..UpdateContract("","",PLIST(6),1)
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
 	}
 	if +AppType=1
 	{
	 	&sql(update sqluser.DHC_EQContractPayment values :PLIST() where CTP_RowID=:RowID)
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
	 	s SQlCODE=..UpdateContract("","",PLIST(6),1)
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
 	}
 	if +AppType=2
 	{
	 	s UPDate=+$H
	 	s UPTime=$P($H,",",2)
	 	&sql(update sqluser.DHC_EQContractPayment set CTP_InvalidFlag='Y',CTP_UpdateUserDR=:User,CTP_UpdateDate=:UPDate,CTP_UpdateTime=:UPTime where CTP_RowID=:RowID)
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
	 	s SQlCODE=..UpdateContract("","",PLIST(6),1)
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
 	}
 	TCOMMIT
 	q SQLCODE
}

ClassMethod UpdateContract(itms As %Library.String = "", itmsex As %Library.String = "", ContractDR, Type)
{
	s TotalFee=0
	s QuantityNum=0
	&sql(select sum(CTP_PayFee) into :TotalFee from sqluser.DHC_EQContractPayment where CTP_ContractDR=:ContractDR and CTP_InvalidFlag='N')
	if Type=1
	{&sql(update sqluser.DHC_EQContract set CT_PayedTotalFee=CT_PreFeeFee+:TotalFee where CT_RowID=:ContractDR)
	q SQLCODE
	}
	if Type=2 q TotalFee
}

ClassMethod GetOnePayment(itms As %Library.String = "", itmsex As %Library.String = "", rowid)
{
	new result,resultex
	s (result,resultex)=""
	s result= $G(^DHCEQContractPayment(rowid))
	s $p(result,"^",4)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",4),"date")	;PayDate
	s resultex=resultex_"^"	;ContractDR
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_$p($g(^DHCEQContract($p(result,"^",5))),"^",1)
	s $p(result,"^",8)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",8),"date")	;InvoiceDate
	s $p(result,"^",9)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",9),"bool")	;InvalidFlag
	s resultex=resultex_"^"	;UpdateUserDR
	i $p(result,"^",10)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",10))
	s $p(result,"^",11)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",11),"date")	;UpdateDate
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex
}

Query GetPayment(ContractDR) As %Query(ROWSPEC = "TRowID:%String,TRemark:%String,TPayNo:%String,TPayFee:%String,TPayDate:%String,TContractDR:%String,TInvoiceNo:%String,TInvoiceFee:%String,TInvoiceDate:%String,TInvalidFlag:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TPayedFee:%String,TContract:%String,TUpdateUser:%String")
{
}

ClassMethod GetPaymentExecute(ByRef qHandle As %Binary, ContractDR) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetPayment
	Quit $$$OK
BuildDataGetPayment
	f  s rowid=$o(^DHCEQContractPayment(rowid))  quit:rowid=""  d
	.d ResetVariablesGetPayment
	.s TRowID = rowid
	.s TRemark = $p($g(^DHCEQContractPayment(rowid)),"^",1)
	.s TPayNo = $p($g(^DHCEQContractPayment(rowid)),"^",2)
	.s TPayFee = $p($g(^DHCEQContractPayment(rowid)),"^",3)
	.s TPayDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContractPayment(rowid)),"^",4),"date")
	.s TContractDR = $p($g(^DHCEQContractPayment(rowid)),"^",5)
	.q:TContractDR'=ContractDR
	.i TContractDR '=""  d
	..s TContract = $p($g(^DHCEQContract(TContractDR)),"^",1)
	.s TInvoiceNo = $p($g(^DHCEQContractPayment(rowid)),"^",6)
	.s TInvoiceFee = $p($g(^DHCEQContractPayment(rowid)),"^",7)
	.s TInvoiceDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContractPayment(rowid)),"^",8),"date")
	.s TInvalidFlag = $p($g(^DHCEQContractPayment(rowid)),"^",9)
	.q:TInvalidFlag="Y"
	.s TUpdateUserDR = $p($g(^DHCEQContractPayment(rowid)),"^",10)
	.i TUpdateUserDR '=""  d
	..s TUpdateUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	.s TUpdateDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContractPayment(rowid)),"^",11),"date")
	.s TUpdateTime = $p($g(^DHCEQContractPayment(rowid)),"^",12)
	.s TPayedFee = $p($g(^DHCEQContractPayment(rowid)),"^",13)
	.d OutputRowGetPayment
	quit
OutputRowGetPayment
	s Data=$lb(TRowID,TRemark,TPayNo,TPayFee,TPayDate,TContractDR,TInvoiceNo,TInvoiceFee,TInvoiceDate,TInvalidFlag,TUpdateUserDR,TUpdateDate,TUpdateTime,TPayedFee,TContract,TUpdateUser)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetPayment
	s (TRowID,TRemark,TPayNo,TPayFee,TPayDate,TContractDR,TInvoiceNo,TInvoiceFee,TInvoiceDate,TInvalidFlag,TUpdateUserDR,TUpdateDate,TUpdateTime,TPayedFee,TContract,TUpdateUser)=""
	quit
}

ClassMethod GetPaymentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPaymentExecute ]
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

ClassMethod GetPaymentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPaymentExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
