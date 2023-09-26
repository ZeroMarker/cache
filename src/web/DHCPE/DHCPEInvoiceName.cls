Class web.DHCPE.DHCPEInvoiceName Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 作者：汪福建
/// 创建时间：2009-02-23
/// 功能描述：查询打印发票名称，
/// 传入参数：RegNo：登记号，PIBIName，姓名
/// 输出参数：tPIBI_PAPMINo：登记号，tPIBI_Name:姓名，tInvoiceName:别名，tPIBI_Company:公司，tPIBI_IDCard:身份证
Query FindInvoiceName(RegNo As %String = "", PIBIName As %String = "", allPat As %String = "") As %Query(ROWSPEC = "tPIBI_PAPMINo:%String,tPIBI_Name:%String,tInvoiceName:%String,tPIBI_Company:%String,tPIBI_IDCard:%String")
{
}

/// 													登记号				姓名						显示已审核的单位					显示已结算
ClassMethod FindInvoiceNameExecute(ByRef qHandle As %Binary, RegNo As %String = "", PIBIName As %String = "", allPat As %String = "") As %Status
{
	s ^wangfujian("dhcpeInvoiceName","id","name")=RegNo_"^"_PIBIName
	Set repid=$I(^CacheTemp)
 	s ind=1
    if (""=RegNo)&&(""=PIBIName)&&(allPat="") {
   	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
    }
    if (allPat="Y")  d
    .s RegNo=""
    .f  s RegNo=$o(^DHCPEDataEX("DHCPEInvoice","InvoiceName",RegNo)) quit:RegNo=""  d
    ..Set PAPMIRowId=0
	..For  Set PAPMIRowId=$O(^PAPERi("PAPMI_PatNo",RegNo,PAPMIRowId)) Quit:PAPMIRowId=""  Do
	...do putData(PAPMIRowId)
	...quit:(""=Data)
    ...do FindInvoiceNameBuild
    e  if (""'=RegNo) d
    .s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
    .Set PAPMIRowId=0
	.For  Set PAPMIRowId=$O(^PAPERi("PAPMI_PatNo",RegNo,PAPMIRowId)) Quit:PAPMIRowId=""  Do
	..do putData(PAPMIRowId)
	..quit:(""=Data)
    ..do FindInvoiceNameBuild
    e  if (""'=PIBIName)&&(""=RegNo) d
    .Set PAPMIRowId=0
    .s PIBIName=$ZCVT(PIBIName,"U")
	.For  Set PAPMIRowId=$O(^PAPERi("PAPER_PatName",PIBIName,PAPMIRowId)) Quit:PAPMIRowId=""  Do
	..do putData(PAPMIRowId)
	..quit:(""=Data)
    ..do FindInvoiceNameBuild
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
putData(PAPMIRowId)
	set Data=""
	Set id=PAPMIRowId
	Quit:$g(id)=""
	s currData=$g(^PAPER(PAPMIRowId,"ALL"))
	s tPAPMINo=$p(^PAPER(PAPMIRowId,"PAT",1),"^",1)
	s tPIBIName=$p(currData,"^",1)
	quit:(""'=PIBIName)&&('(tPIBIName[PIBIName))
	s tPIBICompany=$p(currData,"^",12)
	s tPIBIIDCard=$p(currData,"^",9)
	i $d(^DHCPEDataEX("DHCPEInvoice","InvoiceName",tPAPMINo)) d
	.s tInvoiceName=^DHCPEDataEX("DHCPEInvoice","InvoiceName",tPAPMINo)
	else  d
	.s tInvoiceName=""
	//			登记号		姓名		发票别名	   公司          身份证        
	//			  tPAPMINo  tPIBIName tInvoiceName  tPIBICompany tPIBIIDCard 
	set Data=$lb( tPAPMINo, tPIBIName,tInvoiceName, tPIBICompany, tPIBIIDCard)
	q
FindInvoiceNameBuild
	
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindInvoiceNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInvoiceNameExecute ]
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

ClassMethod FindInvoiceNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInvoiceNameExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod UpdateInvoiceName(ActionType As %String = "", RegNo As %String = "", InvoiceName As %String = "")
{
	s $zt="error"
	tstart
	i "U"=ActionType d
	.s ^DHCPEDataEX("DHCPEInvoice","InvoiceName",RegNo)=InvoiceName
	e  i (^DHCPEDataEX("DHCPEInvoice","InvoiceName",RegNo)=InvoiceName)  d
	.k ^DHCPEDataEX("DHCPEInvoice","InvoiceName",RegNo)
	tcommit
	q 1
error
	trollback
	q 0
}

}
