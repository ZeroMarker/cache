Import SQLUser

Class web.UDHCJFOPCashier Extends %RegisteredObject
{

Query OPLoclookup(desc As %String, rinid As %String) As websys.Query(ROWSPEC = "OPLocdesc:%String,rowid:%String")
{
}

ClassMethod OPLoclookupExecute(ByRef qHandle As %Binary, desc As %String, rinid As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
    set desc=$$ALPHAUP^SSUTIL4(desc)
	
	set OPLocdesc=""
	set rowid=0
	for  set rowid=$o(^PAC("ADMLOC",0,"AdmType","O",rowid))  quit:(rowid="")  do
	.set OPLocdesc=$p(^CTLOC(rowid),"^",2)
	.if desc'=""  do
	..if OPLocdesc[desc  do
	...do OutputRow1
 	.e  do
 	..do OutputRow1
	quit $$$OK
OutputRow1
	set Data=$lb(OPLocdesc,rowid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

Query OPDoclookup(AdmLocID As %String) As websys.Query(ROWSPEC = "OPLocdesc:%String,rowid:%String")
{
}

ClassMethod OPDoclookupExecute(ByRef qHandle As %Binary, AdmLocID As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if (AdmLocID="") quit $$$OK
	set OPDocdesc=""
	set RowId=0
	for  set RowId=$o(^RB("RES",0,"CTLOC",AdmLocID,RowId)) quit:(RowId="")  do
	.set DocDr=""
	.if ($d(^RB("RES",RowId))) do 
	..set DocDr=$p(^RB("RES",RowId),"^",2)
	.if (DocDr="") quit
	.set OPDocdesc=$p(^CTPCP(DocDr,1),"^",2)
	.set rowid=DocDr
 	.do OutputRow2
	quit $$$OK
OutputRow2
	set Data=$lb(OPDocdesc,rowid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

Query OPSocialStatus(PatType As %String) As websys.Query(ROWSPEC = "Socialdesc:%String,SocialId:%String")
{
}

ClassMethod OPSocialStatusExecute(ByRef qHandle As %Binary, PatType As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set rowid=0
	for  set rowid=$o(^CT("SS",rowid)) quit:(rowid="")  do
	.set socialcode=$p(^CT("SS",rowid),"^",1)
	.quit:(socialcode'=PatType)&(PatType'="")
	.set socialdesc=$p(^CT("SS",rowid),"^",2)
 	.do OutputRow3
	quit $$$OK
OutputRow3
	set Data=$lb(socialdesc,rowid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// w ##class(web.UDHCJFOPCashier).UpdateInvNO("5","21","0013050","0013100","")
ClassMethod UpdateInvNO(Guser, RowId, CurNo, EndNo, flag)
{
    set ^TMP("UpdateInvNO")=$lb(Guser, RowId, CurNo, EndNo, flag)
    quit:(Guser="") "GuserNull"
    quit:(RowId="") "RowIdNull"
    quit:(CurNo="") "CurNoNull"
    
	set rtn=0

    set OldCurNo="", OldEndNo="", OldFinalFlag="", OldStartInv=""
    
    &SQL(
    	SELECT INV_StartInv, inv_lastnum, inv_endinv, inv_finalflag INTO :OldStartInv, :OldCurNo, :OldEndNo,:OldFinalFlag
    	FROM DHC_INVOICE
    	WHERE %ID = :RowId
    )
    set rtn=SQLCODE
    quit:(+rtn) rtn
    
    quit:(OldFinalFlag="N") "AlreadyUseUp" 
    quit:((+OldStartInv)>(+CurNo)) "StarLess"
    quit:((+OldEndNo)<(+CurNo)) "EndLess"
    quit:((+OldCurNo)>(+CurNo)) "CurLess"
    
    if (RowId'="") {
		&SQL(
			UPDATE DHC_INVOICE
			SET inv_lastnum = :CurNo, inv_finalflag = :flag
			WHERE %ID = :RowId
		)
    }else {
		set curdate=+$h, curtime=$p($h,",",2)
		&SQL(
			INSERT INTO DHC_INVOICE (
				inv_date, inv_time, inv_type, INV_StartInv, inv_lastnum, inv_endinv, inv_finalflag, inv_usr
			)
		 	VALUES(
		 		:curdate, :curtime, 'O', :CurNo, :CurNo, :EndNo, 'Y', :Guser
		 	)
		 )
    }
    set rtn=SQLCODE
    
	quit rtn
}

Query FindInvNoByUser(userid, HospId, UserFlagS, LangId As %String = "") As websys.Query(ROWSPEC = "TRowId:%String,TDate:%String,TTime:%String,TStNo:%String,TEndNo:%String,TCurNo:%String,TFlag:%String,Tuserid:%String,TInvType:%String")
{
}

ClassMethod FindInvNoByUserExecute(ByRef qHandle As %Binary, userid, HospId, UserFlagS, LangId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if (userid="") quit $$$OK
	
	if ((LangId="")&&($d(%session))) {
		set LangId=%session.Get("LOGON.LANGID")
	}
	
	set rowid=0
	while($o(^DHCINVOICE(0,"USER",userid,rowid))) {
		set rowid=$o(^DHCINVOICE(0,"USER",userid,rowid))
		set invoiceData=$g(^DHCINVOICE(rowid))
		set hospDR=$p(invoiceData,"^",26)
		continue:(hospDR'=HospId)
		set lquser=$p(invoiceData,"^",3)
		set flag=$p(invoiceData,"^",7)
		//continue:(flag="N")
		continue:(UserFlagS'=flag)
		set userFlagDisplay=$case(flag,"Y":"可用","N":"已用完",:"待用")
		set userFlagDisplay=##class(websys.Translation).Get("", userFlagDisplay, LangId)
		set date=$p(invoiceData,"^",4)
		set date=##class(websys.Conversions).DateLogicalToHtml(date)
		set time=$p(invoiceData,"^",5)
		set time=##class(websys.Conversions).TimeLogicalToHtml(time)
		set stno=$p(invoiceData,"^",1)
		set endno=$p(invoiceData,"^",2)
		set curno=$p(invoiceData,"^",6)
		set invType=$p(invoiceData,"^",8)
		set invTypeDisplay=$case(invType,"O":"门诊","E":"急诊","I":"住院","R":"挂号",:"")
		set invTypeDisplay=##class(websys.Translation).Get("", invTypeDisplay, LangId)
		do OutputInvNo	
	}
	
	quit $$$OK
OutputInvNo
	set Data=$lb(rowid,date,time,stno,endno,curno,userFlagDisplay,lquser,invTypeDisplay)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

}
