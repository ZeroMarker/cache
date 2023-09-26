Class web.DHCBillQuery Extends %RegisteredObject
{

ClassMethod GetAdmNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdmNoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetAdmNoExecute(ByRef qHandle As %Binary, PatNo) As %Status
{

 k ^TESTTMP
 s No=""
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=0
	;i PatNo="" q ""
	f  s No=$o(^PAPERi("PAPMI_PatNo",No)) q:No=""  d
	.q:(No'=PatNo)&(PatNo'="")
	.;s RowId=""
	.s RowId=$o(^PAPERi("PAPMI_PatNo",No,""))
	
    .s PaType=""
    .s PaType=$o(^PAPERdr(RowId,"ADM",PaType))  q:PaType=""  d
    
    ..s AdmRowId=""
    
    ..f  s AdmRowId=$o(^PAPERdr(RowId,"ADM",PaType,AdmRowId)) q:AdmRowId=""  d
    
    ...s AdmNo=$p(^PAADM(AdmRowId),"^",81)
    
 
 ...Set ind=ind+1
 
 ...d OutputRow2
 Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow2
	set Data=$lb(AdmRowId,AdmNo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAdmNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdmNoExecute ]
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

Query GetAdmNo(PatNo) As %Query(ROWSPEC = "AdmRowId:%String,就诊号:%String")
{
}

ClassMethod GetPatInfoByNo(PatNo)
{
	//根据病人登记号返回病人姓名和性别
	;i PatNo="" q ""
	s PatName="",PatSex="",RowId=""
	s RowId=$o(^PAPERi("PAPMI_PatNo",PatNo,""))
	s data=^PAPER(RowId,"ALL")
	q:data=""
    s PatName=$p(data,"^",1)
    s PatSexDr=$p(data,"^",7)
    s PatSex=$p(^CT("SEX",PatSexDr),"^",2)
    //s PatAdmNo=$p(data,"^",81)
    s PaType=""
    s PaType=$o(^PAPERdr(RowId,"ADM",PaType))  q:PaType=""  d
    .s AdmRowId=""
    .s AdmRowId=$o(^PAPERdr(RowId,"ADM",PaType,AdmRowId)) q:AdmRowId=""  d
    ..s AdmNo=$p(^PAADM(AdmRowId),"^",81)
    q PatName_"^"_PatSex
}

ClassMethod GetPatBillByNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatBillByNoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetPatBillByNoExecute(ByRef qHandle As %Binary, AdmRowId) As %Status
{

 ;k ^TESTTMP
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=0
 s PatBillRowId=""
 
 
 i AdmRowId'="" d 
 .f  s PatBillRowId=$o(^DHCPB(0,"ADM",AdmRowId,PatBillRowId)) q:PatBillRowId=""  d
 ..i $d(^DHCPB(PatBillRowId)) s TotalAmount=$p(^DHCPB(PatBillRowId),"^",8)   
 
 ..Set ind=ind+1
 
 ..d OutputRow2
 
 Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow2
	set Data=$lb(PatBillRowId,TotalAmount)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPatBillByNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatBillByNoExecute ]
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

Query GetPatBillByNo(AdmRowId) As %Query(ROWSPEC = "PatBillRowId:%String,TotalAmount:%String")
{
}

ClassMethod GetPatBillDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatBillDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetPatBillDetailExecute(ByRef qHandle As %Binary, pbrowid) As %Status
{

 ;k ^TESTTMP
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=0
 s pbochild=0,pbdchild=0,taridr=""
 f  s pbochild=$o(^DHCPB(pbrowid,"O",pbochild)) q:pbochild=""  d
 .s pbdchild=0
 .f  s pbdchild=$o(^DHCPB(pbrowid,"O",pbochild,"D",pbdchild)) q:pbdchild=""  d
 ..;w !,pbdchild
 ..s taridr="",taridesc=""
 ..i $d(^DHCPB(pbrowid,"O",pbochild,"D",pbdchild)) s tartdr=$p(^DHCPB(pbrowid,"O",pbochild,"D",pbdchild),"^",3)
 ..;s tartdr=^DHCTARI(0,"Desc",desc,tartdr)
 ..;w ^DHCPB(pbrowid,"O",pbochild,"D",pbdchild),!
 ..;w $g(tartdr),! 
 ..;i $l(tartdr)>1 s taridesc=$p(^DHCTARI(tartdr),"^",2)
 ..s taridesc=$p(^DHCTARI(tartdr),"^",2)
 ..s taridr=$p(^DHCTARI(tartdr),"^",3)
 ..;w taridesc
 ..s pbdprice=$p(^DHCPB(pbrowid,"O",pbochild,"D",pbdchild),"^",4)
 ..s pbdqty=$p(^DHCPB(pbrowid,"O",pbochild,"D",pbdchild),"^",5)
 ..s pbdamount=$p(^DHCPB(pbrowid,"O",pbochild,"D",pbdchild),"^",7)
 ..s pbddate=$p(^DHCPB(pbrowid,"O",pbochild,"D",pbdchild),"^",11)
 ..s date=$zd(pbddate,3)
 ..s pbdtime=$p(^DHCPB(pbrowid,"O",pbochild,"D",pbdchild),"^",12)
 ..s time=$zt(pbdtime,3)
 ..;w !,taridesc_"^"_taridr_"^"_pbdprice_"^"_pbdqty_"^"_pbdamount_"^"_date_"^"_time  
 
 ..Set ind=ind+1
 
 ..d OutputRow2
 Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow2
	set Data=$lb(taridesc,pbdprice,pbdqty,pbdamount)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPatBillDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatBillDetailExecute ]
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

Query GetPatBillDetail(pbrowid) As %Query(ROWSPEC = "taridesc:%String,pbdprice:%String,pbdqty:%String,pbdamount:%String")
{
}

}
