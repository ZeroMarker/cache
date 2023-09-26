Class web.DHCTangTao Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

ClassMethod GetBillDataExecute(ByRef qHandle As %Binary, strdate, enddate, username) As %Status
{
	   Set repid=$I(^CacheTemp)
       s ind=1
       f PrtDate=strdate:1:enddate  d
       .s PrtRowId=""
       .f  s PrtRowId=$o(^DHCSFPRINTDETAIL(0,"PrtDate",PrtDate,PrtRowId)) q:PrtRowId=""  d       
       ..s userid=$p(^DHCSFPRINTDETAIL(PrtRowId),"^",14)
       ..i $d(^SSU("SSUSR",userid)) s UserName=$p(^SSU("SSUSR",userid),"^",2)
       ..q:(username'=UserName)&(username'="") 
       ..s PrtPayment=$p(^DHCSFPRINTDETAIL(PrtRowId),"^",6)
       ..s adm=$p(^DHCSFPRINTDETAIL(PrtRowId),"^",4)
       ..q:adm=""
       ..s papmi=""
       ..i $d(^PAADM(adm)) s papmi=$p(^PAADM(adm),"^",1)
       ..q:papmi=""
       ..i $d(^PAPER(papmi,"ALL")) s PatName=$p(^PAPER(papmi,"ALL"),"^",1)
       ..s StartDate=$zd($p(^DHCSFPRINTDETAIL(PrtRowId),"^",2),3)
       ..s StartTime=$zt($p(^DHCSFPRINTDETAIL(PrtRowId),"^",3),3)
       ..s paymode=$p(^DHCSFPRINTDETAIL(PrtRowId),"^",9)
       ..q:paymode=""
       ..i $d(^CT("CTPM",paymode)) s PrtPayMode=$p(^CT("CTPM",paymode),"^",2)
       ..;w !,PatName_"^"_PrtPayment_"^"_PrtPayMode_"^"_%g(PerAddUser)
       ..Do OutputRow
       Set qHandle=$lb(0,repid,0)
       Quit $$$OK
OutputRow
       set Data=$lb(PatName,PrtPayment,PrtPayMode,StartDate,StartTime,username)
       Set ^CacheTemp(repid,ind)=Data
       Set ind=ind+1
	   quit
}

ClassMethod GetBillDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBillDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetBillDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBillDataExecute ]
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

Query GetBillData(strdate, enddate, username) As %Query(ROWSPEC = "PatName:%String,PrtPayment:%String,PrtPayMode:%String,StartDate:%String,StartTime:%String,username:%String")
{
}

Query GetUserName() As %Query(ROWSPEC = "UserName:%String,UserRowId:%String")
{
}

ClassMethod GetUserNameExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    s rowid=""
    f  s rowid=$o(^SSU("SSUSR",rowid)) q:rowid=""  d
    .s UserName=$p(^SSU("SSUSR",rowid),"^",2)
    .s UserRowId=rowid
    .;w UserName
    .Do OutputRow
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(UserName,UserRowId)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
	quit
}

ClassMethod GetUserNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserNameExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetUserNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserNameExecute ]
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

ClassMethod GetPatInfo(PatNo)
{
	s rowid=""
    s rowid=$o(^PAPERi("PAPMI_PatNo",PatNo,rowid)) 
    s PatName=$p(^PAPER(rowid,"ALL"),"^",1)
    s PatSexDr=$p(^PAPER(rowid,"ALL"),"^",7)
    i $d(^CT("SEX",PatSexDr)) s PatSex=$p(^CT("SEX",PatSexDr),"^",2)

    q PatName_"^"_PatSex
}

//根据登记号查询住院就诊信息及就诊号

Query GetPatInfoByPatNo(PatNo) As %Query(ROWSPEC = "AdmRowId:%String,Admmo:%String")
{
}

ClassMethod GetPatInfoByPatNoExecute(ByRef qHandle As %Binary, PatNo) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    i PatNo="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s PapmiRowId=""
    s PapmiRowId=$o(^PAPERi("PAPMI_PatNo",PatNo,PapmiRowId))
    q:PapmiRowId=""
    s AdmRowId=""
    f  s AdmRowId=$o(^PAPERdr(PapmiRowId,"ADM","I",AdmRowId)) q:AdmRowId=""  d
    .s Admmo=$p(^PAADM(AdmRowId),"^",81)
    .Do OutputRow
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(AdmRowId,Admmo)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
	quit
}

ClassMethod GetPatInfoByPatNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatInfoByPatNoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPatInfoByPatNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatInfoByPatNoExecute ]
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

//根据就诊号查询总金额及账单号

Query GetPaymentByAdmRowId(AdmRowId) As %Query(ROWSPEC = "TotalPayment:%String,BillId:%String")
{
}

ClassMethod GetPaymentByAdmRowIdExecute(ByRef qHandle As %Binary, AdmRowId) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    i AdmRowId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s BillId=""
    f  s BillId=$o(^DHCPB(0,"ADM",AdmRowId,BillId)) q:BillId=""  d
    .s TotalPayment=$p(^DHCPB(BillId),"^",8)
    .Do OutputRow
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(TotalPayment,BillId)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
	quit
}

ClassMethod GetPaymentByAdmRowIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPaymentByAdmRowIdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPaymentByAdmRowIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPaymentByAdmRowIdExecute ]
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

//根据账单号查询收费项目名称、单价、数量、金额

Query GetProInfo(BillId) As %Query(ROWSPEC = "ProName:%String,UnitPrice:%String,BillQty:%String,Totalmount:%String")
{
}

ClassMethod GetProInfoExecute(ByRef qHandle As %Binary, BillId) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    i BillId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    
    s PrtRowIdf="0",PrtRowIds="0"
    f  s PrtRowIdf=$o(^DHCPB(BillId,"O",PrtRowIdf)) q:PrtRowIdf=""  d
    .f  s PrtRowIds=$o(^DHCPB(BillId,"O",PrtRowIdf,"D",PrtRowIds)) q:PrtRowIds=""  d
    ..s UnitPrice=$p(^DHCPB(BillId,"O",PrtRowIdf,"D",PrtRowIds),"^",4)
    ..s BillQty=$p(^DHCPB(BillId,"O",PrtRowIdf,"D",PrtRowIds),"^",5)
    ..s Totalmount=$p(^DHCPB(BillId,"O",PrtRowIdf,"D",PrtRowIds),"^",7)
    ..s TaRi=$p(^DHCPB(BillId,"O",PrtRowIdf,"D",PrtRowIds),"^",3)
    ..q:TaRi=""
    ..i $d(^DHCTARI(TaRi)) s ProName=$p(^DHCTARI(TaRi),"^",2)
    ..Do OutputRow
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(ProName,UnitPrice,BillQty,Totalmount)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
	quit
}

ClassMethod GetProInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetProInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetProInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetProInfoExecute ]
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

Storage Default
{
<Data name="DHCTangTaoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCTangTaoD</DataLocation>
<DefaultData>DHCTangTaoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCTangTaoD</IdLocation>
<IndexLocation>^web.DHCTangTaoI</IndexLocation>
<StreamLocation>^web.DHCTangTaoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
