Class web.UDHCOPInvFRepAccFoot Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 35;

ClassMethod QueryAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetPrePaySum(AccMId)
{
	;预交金
	;DHC_AccPreDeposit
	s AccPDSub="0"
	s myPreSum=0
	s myRefPreSum=0
	f  s AccPDSub=$o(^DHCACD("AccM",AccMId,"AccPD",AccPDSub)) q:AccPDSub=""  d
	.q:($d(^DHCACD("AccM",AccMId,"AccPD",AccPDSub))=10)
	.s myTmpSum=$p($g(^DHCACD("AccM",AccMId,"AccPD",AccPDSub)),"^",2)	;AccPD_PreSum
	.i myTmpSum>0  s myPreSum=myPreSum+myTmpSum
	.e  s myRefPreSum=myRefPreSum+myTmpSum
	
	s myPreSum=$fn(myPreSum,"",2)
	s myRefPreSum=$fn(myRefPreSum,"",2)
	
	q myPreSum_"^"_myRefPreSum
}

ClassMethod GetCardPaySum(AccMId)
{
	;DHC_AccPayList	
	;
	s AccPLSub="0"
	s myPaySum=0
	f  s AccPLSub=$o(^DHCACD("AccM",AccMId,"AccPL",AccPLSub)) q:AccPLSub=""  d
	.q:($d(^DHCACD("AccM",AccMId,"AccPL",AccPLSub))=10)
	.s myPaySum=myPaySum++$p($g(^DHCACD("AccM",AccMId,"AccPL",AccPLSub)),"^",8) 		;AccPL_PayNum
	s myPaySum=$fn(myPaySum,"",2)
	
	q myPaySum
}

ClassMethod QueryAllExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, PatNo As %String, PatName As %String, CardNo As %String, TMPJID As %String) As %Status
{
	New repid, index
	Set repid=$I(^CacheTemp)
	s index=1
 	Set qHandle=$lb(0,repid,0)
 	s ^ww=CardNo_"^"_PatName_"^"_stDate
 
	 //	i TMPJID'="" d
	//.k ^TMPOPPrintOut(TMPJID)
	//s myTMPJID=$I(^TMPOPPrintOut)
	
	;w ##class(%ResultSet).RunQuery("web.UDHCOPInvFRepAccFoot","QueryAll",+$h-20,+$h,"","")

 	
 	i PatNo'=""  d
 	.s len=$l(PatNo)
 	.s PatNo=$e("00000000",1,8-len)_PatNo
 	.s PatNo=$zcvt(PatNo,"U")
 	;;ROWSPEC = "No,TPatNo,TPatName,TPatSex,Hidden,TAccountNo,TPreSum,TParkSum,TCardPaySum,TAccountLeftSum,TCardNo,TTMPJID")
 	
 	s AccMId=""
 	s Idx=0
 	b  ;forr
 	f pdate=endDate:-1:stDate  d
 	.f  s AccMId=$o(^DHCACDi("AccM",0,"WOffDate",pdate,AccMId)) q:AccMId=""  d
 	..q:($d(^DHCACD("AccM",AccMId))=10) 
 	..s TMPData=$g(^DHCACD("AccM",AccMId))
 	..s flag=""
 	..s flag=$P(TMPData,"^",13)	;AccM_AccStatus
 	..q:flag'="F"
 	..s iTPatNo=$P(TMPData,"^",3)	;AccM_PAPMINo
 	..q:(iTPatNo'=PatNo)&(PatNo'="")
 	..s iTCardNo=$P(TMPData,"^",4)	;AccM_CardNo
 	..q:(iTCardNo'=CardNo)&(CardNo'="")
 	..s PMasId=$P(TMPData,"^",2)	;AccM_PAPMI_DR
 	..s iTPatName=$p($g(^PAPER(PMasId,"ALL")),"^",1) 	;PAPMI_Name
 	..q:(iTPatName'=PatName)&(PatName'="")
 	..s iTPatSex=$p($g(^PAPER(PMasId,"ALL")),"^",7)  	;PAPMI_Sex_DR
 	..s iTPatSex=$p($g(^CT("SEX",iTPatSex)),"^",2)      ;ct_sex
 	..
 	..s iTAccountNo=$P(TMPData,"^",1)	;AccM_AccountNo
 	..s iTPreSum=$p(..GetPrePaySum(AccMId),"^",1)
 	..s iTParkSum=$p(..GetPrePaySum(AccMId),"^",2)
 	..s iTCardPaySum=..GetCardPaySum(AccMId)
 	..s iTAccountLeftSum=$fn($P(TMPData,"^",8),"",2)	;AccM_Balance
 	..
 	..s Idx=Idx+1
 	..d OutRowBuild
	
	Set qHandle=$lb(0,repid,0)
	
	Quit $$$OK
	
OutRowBuild
	set Data=$lb(Idx,iTPatNo,iTPatName,iTPatSex,iTAccountNo,iTPreSum,iTParkSum,iTCardPaySum,iTAccountLeftSum,iTCardNo,myTMPJID,AccMId)
	Set ^CacheTemp(repid,index)=Data
 	;s ^TMPOPPrintOut(TMPJID,index)=Idx_"^"_iTPatNo_"^"_iTPatName_"^"_iTPatSex_"^"_iTAccountNo_"^"_iTPreSum_"^"_iTParkSum_"^"_iTCardPaySum_"^"_iTAccountLeftSum_"^"_iTCardNo_"^"_myTMPJID
 	s index=index+1	

	q
}

ClassMethod QueryAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAllExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query QueryAll(stDate As %String, endDate As %String, PatNo As %String, PatName As %String, CardNo As %String, TMPJID As %String) As %Query(ROWSPEC = "No:%String,TPatNo:%String,TPatName:%String,TPatSex:%String,TAccountNo:%String,TPreSum:%String,TParkSum:%String,TCardPaySum:%String,TAccountLeftSum:%String,TCardNo:%String,TTMPJID:%String,TAccMId:%String")
{
}

}
