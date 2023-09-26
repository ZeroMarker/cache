Class web.DHCPacJsClass Extends %RegisteredObject
{

/// Function   :根据登记号，得到病人的姓名和性别
/// Input      :PatNo,病人登记号
/// Return     :返回姓名和性别，以"^"分隔
ClassMethod GetPatInforByPatNo(PatNo)
{
	  if PatNo="" q ""
	  s patRowid = $O(^PAPERi("PAPMI_PatNo",PatNo,""))
	  q:patRowid=""
	  s data = ^PAPER(patRowid,"ALL")
	  q:data=""
	  s patName=$P(data,"^",1)
	  s patSexDr = $p(data,"^",7)
	  s sex = $P(^CT("SEX",patSexDr),"^",2)
	  q patName_"^"_sex
}

/// Function   :根据登记号，得到病人的姓名
/// Input      :PatNo,病人登记号
/// Return     :返回姓名
ClassMethod GetPatNameByPatNo(PatNo)
{
	if PatNo="" q
	s patRowid = $O(^PAPERi("PAPMI_PatNo",PatNo,""))
	q:patRowid=""
	
	s patName = $P(^PAPER(patRowid,"ALL"),"^",1)  //区的病人姓名
	
	q patName
}

/// Query定义：根据登记号,查找就诊登记号和rowid
Query GetAdmInfo(PatNo) As %Query(ROWSPEC = "admRowid:%String,admNo:%String")
{
}

ClassMethod GetAdmInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdmInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetAdmInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdmInfoExecute ]
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

/// Function     :根据病人登记号，查询就诊号和rowid
/// Input        :PatNo,病人登记号
/// Return       :
ClassMethod GetAdmInfoExecute(ByRef qHandle As %Binary, PatNo) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=0
    if PatNo=""  Set qHandle=$lb(0,repid,0)  Quit $$$OK 
    	
    s patRowid = $O(^PAPERi("PAPMI_PatNo",PatNo,""))
	q:patRowid=""

   s admRowid=""
   f  s admRowid = $O(^PAPERdr(patRowid,"ADM","I",admRowid))  q:admRowid=""  d
   .s admNo = $P(^PAADM(admRowid),"^",81)
   .d OutputRow
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
    
OutputRow
	set Data=$lb(admRowid,admNo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

/// Query   :GetAmount,根据admRowid,查询显示付费总金额和帐单rowid
Query GetAmount(AdmRowid) As %Query(ROWSPEC = "amount:%String,pbRowid:%String")
{
}

ClassMethod GetAmountClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAmountExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetAmountFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAmountExecute ]
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

/// Function    :根据病人rowid,查询账单总额和账单rowid
/// Input       :AdmRowid,就从信息rowid
/// Return      :帐单总金额和rowid
ClassMethod GetAmountExecute(ByRef qHandle As %Binary, AdmRowid) As %Status
{
	
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=0
    if AdmRowid=""  Set qHandle=$lb(0,repid,0)  Quit $$$OK
	  	
    s pbRowid=""
    f  s pbRowid=$O(^DHCPB(0,"ADM",AdmRowid,pbRowid))  q:pbRowid=""  d
    . s totalAmount = $P(^DHCPB(pbRowid),"^",8)
    
    
   .d OutputRow
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
    
OutputRow
	set Data=$lb(totalAmount,pbRowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

}
