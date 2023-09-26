Class web.UDHCJFDocPatientFee Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 46;

ClassMethod FindDocPatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDocPatExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindDocPatExecute(ByRef qHandle As %Binary, guser As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	if $G(guser)="" Set qHandle=$lb(0,repid,0) quit $$$OK	
    s doc=$P(^SSU("SSUSR",guser),"^",14)
 	s ind=1
 	s paadmrowid=""
 	f  s paadmrowid=$o(^PAADMi("AdmTypeCurr","I",paadmrowid)) q:paadmrowid=""  d
 	.s docrowid=$p(^PAADM(paadmrowid),"^",9)
 	.q:(doc'=docrowid)
 	.s papmi=$p(^PAADM(paadmrowid),"^",1)
	.s patname=$p(^PAPER(papmi,"ALL"),"^",1)
	.s patno=$p(^PAPER(papmi,"PAT",1),"^",1)
 	.;押金
 	.s deposit=##class(web.UDHCJFCKD).deposit(paadmrowid) 
  	.;费用
 	.s patfee=##class(web.UDHCJFCKD).totalamount(paadmrowid) 
 	.;余额
 	.s remain=deposit-patfee
	.Do OutputRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(patno,patname,deposit,patfee,remain)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindDocPatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDocPatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FindDocPat(guser As %String) As %Query(ROWSPEC = "Tpatno:%String,Tpatname:%String,Tdeposit:%String,Tpatfee:%String,Tremain:%String")
{
}

}
