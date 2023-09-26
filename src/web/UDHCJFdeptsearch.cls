Import sqluser

/// 名称:     web.DHCIPBillInvDetailSearch
/// 描述:     实现对票据的查询 
/// 编写者：  王刚
/// 编写日期: 2008.9.25
Class web.UDHCJFdeptsearch Extends %RegisteredObject
{

Query FindInvDetail(startDate, endDate, admUserTo As %String, balance As %String, invNoType As %String, PayMode As %String, InvNo As %String) As %Query(ROWSPEC = "addUser:%String,invType:%String,invNo:%String,name:%String,ipNo:%String,invDate:%String,amount:%String,user:%String,backDate:%String,invStatus:%String,oldInvNo:%String,TPayMode:%String")
{
}

ClassMethod FindInvDetailExecute(ByRef qHandle As %Binary, startDate, endDate, admUserTo As %String, balance As %String, invNoType As %String, PayMode As %String, InvNo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s admUser=$g(admUserTo)
 	s invNoType=$g(invNoType)
 	s balanceConvert=""
 	i balance="N"  d  s balanceConvert=1
 	i balance="A"  d  s balanceConvert=2
 	i balance="S"  d  s balanceConvert=3
 	i ($g(InvNo)'="")&(invNoType'="") d
 	.i invNoType="Y" d
 	..s PrtRowId=$o(^DHCSFPRINTDETAIL(0,"RcptNo",InvNo,""))
 	..d GetDepositInfo(PrtRowId,"")
 	.e  d
 	..s PrtRowID=$o(^DHCINVPRTZY(0,"INV",InvNo,""))
 	..d GetInvInfo(PrtRowID,"")
 	e  d
 	.f prtPrintDate=startDate:1:endDate d
 	..s prtRowId=0
 	..f  s prtRowId=$o(^DHCSFPRINTDETAIL(0,"PrtDate",prtPrintDate,prtRowId)) q:prtRowId=""  d
 	...d GetDepositInfo(prtRowId,PayMode)
 	..s prtTRowid=0
 	..f  s prtTRowid=$o(^DHCINVPRTZY(0,"DATE",prtPrintDate,prtTRowid)) q:prtTRowid=""  d
 	...d GetInvInfo(prtTRowid,PayMode)
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(addUser,invType,invNo,name,ipNo,invDate,amount,user,backDate,invStatus,oldInvNo,PrtPayModeDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
GetDepositInfo(prtRowId,PayMode)
	s oldInvNo="",user="",backDate=""
 	i invNoType'="" d  q:invNoType="N"
 	i admUser'="" d  q:$p(^DHCSFPRINTDETAIL(prtRowId),"^",14)'=admUser
 	i balance'="" d  q:$p(^DHCSFPRINTDETAIL(prtRowId),"^",8)'=balanceConvert
 	q:$p(^DHCSFPRINTDETAIL(prtRowId),"^",13)'=1     //押金类型为住院
 	s addUserId=$p(^DHCSFPRINTDETAIL(prtRowId),"^",14)
 	s addUser=$p(^SSU("SSUSR",addUserId),"^",2)   //操作员
 	s invType="押金收据"                          //票据类型
 	s invNo=$p(^DHCSFPRINTDETAIL(prtRowId),"^",1)  //票号
 	s rowIdPaadm=$p(^DHCSFPRINTDETAIL(prtRowId),"^",4)
 	s rowIdPapmi=$p(^PAADM(rowIdPaadm),"^",1)
 	s name=$p(^PAPER(rowIdPapmi,"ALL"),"^",1)     //病人
 	s ipNo=$p(^PAPER(rowIdPapmi,"PAT",1),"^",1)   //登记号
 	s invDate=$zd($p(^DHCSFPRINTDETAIL(prtRowId),"^",2),3)  //票据日期
 	s amount=$p(^DHCSFPRINTDETAIL(prtRowId),"^",6)         //金额
 	s invStatusID=$p(^DHCSFPRINTDETAIL(prtRowId),"^",8)      //状态
 	i invStatusID=1  d  s invStatus="正常"
 	i invStatusID=2  d  s invStatus="作废"
 	i invStatusID=3  d  s invStatus="冲红"
 	i invStatusID=4  d  s invStatus="已冲红"
 	s PrtPayMode=$p(^DHCSFPRINTDETAIL(prtRowId),"^",9)
 	s PrtPayModeDesc=$p(^CT("CTPM",PrtPayMode),"^",2)
 	q:(PrtPayModeDesc'=PayMode)&(PayMode'="")
 	;i amount<0  d 
 	.;s rowId=""
 	.;s user=addUser   //人员
 	.;s oldInvNo=$p(^DHCSFPRINTDETAIL(prtRowId),"^",7)            //原发票号
 	.;&sql(select prt_rowid into:rowId from dhc_sfprintdetail where prt_rcptno=:oldInvNo)
 	.;s backDate=$zd($p(^DHCSFPRINTDETAIL(rowId),"^",2),3)   //退费日期
 	Do OutputRow
GetInvInfo(prtTRowid,PayMode)
	s invStatus="",user="",backDate="",oldInvNo=""
 	i invNoType'="" d  q:invNoType="Y"
 	i admUser'="" d  q:$p(^DHCINVPRTZY(prtTRowid),"^",7)'=admUser
 	i balance'="" d  q:$p(^DHCINVPRTZY(prtTRowid),"^",8)'=balance
 	;q:$p(^DHCINVPRTZY(prtTRowid),"^",9)'="I"     //病人为住院病人
 	s addUserId=$p(^DHCINVPRTZY(prtTRowid),"^",7)
 	s addUser=$p(^SSU("SSUSR",addUserId),"^",2)   //操作员
 	s invType="住院发票"                          //票据类型
 	s invNo=$p(^DHCINVPRTZY(prtTRowid),"^",1)  //票号
 	s rowIdPaadm=$p(^DHCINVPRTZY(prtTRowid),"^",4)
 	s rowIdPapmi=$p(^PAADM(rowIdPaadm),"^",1)
 	s name=$p(^PAPER(rowIdPapmi,"ALL"),"^",1)     //病人
 	s ipNo=$p(^PAPER(rowIdPapmi,"PAT",1),"^",1)   //登记号
 	s invDate=$zd($p(^DHCINVPRTZY(prtTRowid),"^",2),3)  //票据日期
 	s amount=$p(^DHCINVPRTZY(prtTRowid),"^",6)         //金额
 	s invStatusID=$p(^DHCINVPRTZY(prtTRowid),"^",8)      //状态
 	q:(invStatusID="A")&(amount<0)
 	i invStatusID="N"  d  s invStatus="正常"
 	i invStatusID="A"  d  s invStatus="作废"
 	i invStatusID="S"  d  s invStatus="冲红"
 	i invStatusID="I"  d  s invStatus="中途结算"
    
 	i amount<0  d 
 	.s oldInvNoRowId=$p(^DHCINVPRTZY(prtTRowid),"^",19)            //原发票号
 	.i oldInvNoRowId'="" d
 	..s oldInvNo=$p(^DHCINVPRTZY(oldInvNoRowId),"^",1) 
 	..s backDate=$zd($p(^DHCINVPRTZY(oldInvNoRowId),"^",2),3)   //退费日期
 	..s user=addUser   //人员
 	s ARRcpRowID=$p(^DHCINVPRTZY(prtTRowid),"^",17)
 	s ChildSub=0,PayInfo="",PayNum=0
 	f  s ChildSub=$o(^ARRCP(ARRcpRowID,"PAYM",ChildSub)) q:ChildSub=""  d
 	.s ARRCPPayMode=$p(^ARRCP(ARRcpRowID,"PAYM",ChildSub),"^",1)
 	.s PrtPayModeDesc=$p(^CT("CTPM",ARRCPPayMode),"^",2)
 	.s amount=$p(^ARRCP(ARRcpRowID,"PAYM",ChildSub),"^",3)
 	.q:(PrtPayModeDesc'=PayMode)&(PayMode'="")
 	.s PayNum=PayNum+1
 	.i PayInfo'="" d
 	..s PayInfo=PayInfo_";"_PrtPayModeDesc_":"_amount
 	.e  d
 	..s PayInfo=PrtPayModeDesc_":"_amount
 	i PayNum>1 d
 	.s PrtPayModeDesc=PayInfo
    i PayNum>=1 d OutputRow
}

ClassMethod FindInvDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRcptExecute ]
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

ClassMethod FindInvDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRcptExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
