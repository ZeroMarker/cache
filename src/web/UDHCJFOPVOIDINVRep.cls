Import SQLUser

Class web.UDHCJFOPVOIDINVRep Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 17;

/// shikelong 2012-6-30
/// 门诊作废发票查询，
/// 入参：开始日期和结束日期；
ClassMethod FindVoidInvExecute(ByRef qHandle As %Binary, StartDate As %Date, EndDate As %Date, ChargeUser, Handin, guser) As %Status
{
 	s repid=$I(^CacheTemp)
 	s ChargeUser=$g(ChargeUser)
 	s guser=$g(guser)
 	s Handin=$g(Handin)
 	i (StartDate>EndDate) s qHandle=$lb(0,repid,0) Quit $$$OK
 	i guser="" s qHandle=$lb(0,repid,0) Quit $$$OK
	s job=$j
 	s ind=1
 	s ino=1
 	k ^TMP("UDHCJFOP","VoidInv",guser,job)
 	f Date=EndDate:-1:StartDate  d
	.s VOIRowid="0"
	.f  s VOIRowid=$o(^DHCVoidInv(0,"Date",Date,VOIRowid)) q:(VOIRowid="")  d
	..s usr=$p(^DHCVoidInv(VOIRowid),"^",5)
	..s PrtUsr=$p($g(^SSU("SSUSR",usr)),"^",1)
	..s usrName=$p($g(^SSU("SSUSR",usr)),"^",2)
	..q:usrName'=ChargeUser
	..s invNo=$p(^DHCVoidInv(VOIRowid),"^",3)
	..s handinFlag=$p(^DHCVoidInv(VOIRowid),"^",10)
	..s voidReason=$p(^DHCVoidInv(VOIRowid),"^",7)
 	..d OutputRow
 Set qHandle=$lb(0,repid,0) //
 Quit $$$OK
 
OutputRow
 s ^TMP("UDHCJFOP","VoidInv",guser,job,ind)=usrName_"^"_invNo_"^"_voidReason_"^"_handinFlag
 set Data=$lb(usrName,invNo,voidReason,handinFlag)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod FindVoidInvClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindVoidInvExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindVoidInvFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindVoidInvExecute ]
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

Query FindVoidInv(StartDate As %Date, EndDate As %Date, ChargeUser, Handin, guser) As %Query(ROWSPEC = "TusrName:%String,TinvNo:%String,TvoidReason:%String,ThandinFlag:%String")
{
}

/// skl 2012-6-28
/// 	Lid 2012-07-19 修改
/// 门诊作废发票(注：只能从当前可用发票号开始，往后作废,不能现在任意号段作废.)
/// 类名 UDHCJFOPVoidInv
/// slq table name :DHC_VoidInv
/// global:^DHCVoidInv
/// 
/// w ##class(web.UDHCJFCOMMON).VoidOPINV("3881^93^0659^水^0659^0668^10")
ClassMethod VoidOPINV(ExpStr As %Library.String = "") As %String
{
	New (ExpStr)	
	Set ExpStr=$g(ExpStr)
	Set guser=$p(ExpStr,"^",1)
	Set group=$p(ExpStr,"^",2)
	Set InvNo=$p(ExpStr,"^",3)
	Set VoidReason=$p(ExpStr,"^",4)
	Set StartInvNO=$p(ExpStr,"^",5)
	Set EndInvNO=$p(ExpStr,"^",6)
	Set AbortNum=$p(ExpStr,"^",7)
	Set rtn="0"
	Quit:guser="" -1
	Quit:group="" -1
	Set invRowid=""
	TSTART
	For i=1:1:AbortNum Quit:(+rtn'=0)  Do  
    .Set err=..UpdateInvoice(guser,group,invRowid)
    .Set rtn=$p(err,"^",1)
    .Set ReceipNO=$p(err,"^",2)
    .Quit:+rtn'=0
    .KILL PLIST
 	.Set PLIST(2)=+$h
 	.Set PLIST(3)=$p($h,",",2)
 	.Set PLIST(4)=ReceipNO
 	.Set PLIST(6)=guser
 	.Set PLIST(7)=VoidReason
 	.&SQL(INSERT INTO DHC_VoidInv VALUES :PLIST()) 
    .Set rtn=SQLCODE
    If +rtn'=0 Do 
	.TROLLBACK
	Else  Do
	.tc
	;
	Quit rtn
}

/// Lid 
/// 2010-02-25
/// 东方医院发票明细打印时走发票号
/// ^DHCINVPRTSub(invRowid):用于存放明细发票的发票号，如果有多个以$c(2)分割
ClassMethod UpdateInvoice(guser, group, invRowid)
{
	New (group,guser,invRowid)
	;w ##class(web.UDHCJFCOMMON).UpdateInvoice(8711,93,175892)
	;取当前可用发票发票号
	&sql(select inv_lastnum,inv_rowid,inv_EndInv into:ReceipNO,:myINVRowID, :endno from dhc_invoice 
	     where inv_rowid=(select min(inv_rowid)  from dhc_invoice 
	     where inv_usr= :guser and INV_Finalflag='Y' and INV_type='O'))
	s rtn=SQLCODE
	q:rtn'=0 +rtn
	;更新发票表(dhc_invoice)
	s lenOld=$LENGTH(ReceipNO)
	s ReceipNew=+ReceipNO+1
	s lenNew=$LENGTH(ReceipNew)
	i (lenOld-lenNew)>0  d
	.f i=1:1:(lenOld-lenNew) s ReceipNew="0"_ReceipNew
	s rtn=+##class(web.udhcOPBill).UpdateReceipNO(guser,ReceipNew, group,"F")	
	q:rtn +rtn
	/*
	;更新主发票记录，记录附发票号
	i $d(^DHCINVPRTSub(invRowid)) d
	.s ^DHCINVPRTSub(invRowid)=^DHCINVPRTSub(invRowid)_$c(2)_ReceipNO
	e  s ^DHCINVPRTSub(invRowid)=ReceipNO
	*/
	q 0_"^"_ReceipNO
}

ClassMethod GetNum(guser, job)
{
	s num=$o(^TMP("UDHCJFOP","VoidInv",guser,job,""),-1)
	q num
}

ClassMethod GetData(guser, job, i)
{
	s str=""
	s str=^TMP("UDHCJFOP","VoidInv",guser,job,i)
	q str
}

}
