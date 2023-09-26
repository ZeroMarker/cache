Class web.DHCZhangTao Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

Query deposit(stDate, endDate, adduser) As %Query(ROWSPEC = "patName:%String,payAmount:%String,payModeCT:%String,patDate:%String,patTime:%String,addUserName:%String")
{
}

ClassMethod depositExecute(ByRef qHandle As %Binary, stDate, endDate, adduser) As %Status
{
 s repid=$I(^CacheTemp)	
 s ind=1
 ;w !,stDate_"^"_endDate
 //s stDate=$zdh(stDate,3),endDate=$zdh(endDate,3)
 f date=stDate:1:endDate d
 .s sfRowID=""
 .f  s sfRowID=$o(^DHCSFPRINTDETAIL(0,"PrtDate",date,sfRowID)) q:sfRowID=""  d
 ..s adm=$p(^DHCSFPRINTDETAIL(sfRowID),"^",4)
 ..q:adm=""
 ..i $d(^PAADM(adm)) s patDate=$zd($p(^PAADM(adm),"^",6),3)
 ..i $d(^PAADM(adm)) s patTime=$zt($p(^PAADM(adm),"^",7),3)
 ..s papmi=""
 ..i $d(^PAADM(adm)) s papmi=$p(^PAADM(adm),"^",1)
 ..q:papmi=""
 ..i $d(^PAPER(papmi,"ALL")) s patName=$p(^PAPER(papmi,"ALL"),"^",1)
 ..s payAmount=$p(^DHCSFPRINTDETAIL(sfRowID),"^",6)
 ..s payCT=$p(^DHCSFPRINTDETAIL(sfRowID),"^",9)
 ..i $d(^CT("CTPM",payCT)) s payModeCT=$P(^CT("CTPM",payCT),"^",2)
 ..s addUser=$p(^DHCSFPRINTDETAIL(sfRowID),"^",14)
 ..i $d(^SSU("SSUSR",addUser)) s addUserName=$p(^SSU("SSUSR",addUser),"^",2)
 ..q:(adduser'="")&(adduser'=addUserName)
 ..;w !,patName_"^"_payAmount_"^"_payModeCT_"^"_$g(addUserName)
 ..d OutputRow
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
    
OutputRow
	set Data=$lb(patName,payAmount,payModeCT,patDate,patTime,addUserName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod depositClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = depositExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod depositFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = depositExecute ]
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

Query FindAddUser(adduser) As %Query(ROWSPEC = "userName:%String,userRowID:%String")
{
}

ClassMethod FindAddUserExecute(ByRef qHandle As %Binary, adduser) As %Status
{
	
 s repid=$I(^CacheTemp)	
 s ind=1
 s RowID=""
 f  s RowID=$o(^SSU("SSUSR",RowID)) q:RowID=""  d
 .s userName=$p(^SSU("SSUSR",RowID),"^",2)
 .q:(adduser'="")&(adduser'=userName)
 .d OutputRow
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
    
OutputRow
	set Data=$lb(userName,RowID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindAddUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAddUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAddUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAddUserExecute ]
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

ClassMethod GetBillDetail(PatNo)
{
 if PatNo="" q
 
 s rowID=""
 f  s rowID=$o(^PAPERi("PAPMI_PatNo",PatNo,rowID)) q:rowID=""  d
 .s SexID=$p(^PAPER(rowID,"ALL"),"^",7)
 .i $d(^CT("SEX",SexID)) s Sex=$p(^CT("SEX",SexID),"^",2) 
 .s patName=$p(^PAPER(rowID,"ALL"),"^",1)
 .s admRowID=""
 .f  s amdRowID=$o(^PAADM(admRowID)) q:admRowID=""  d
 ..s papmi=$p(^PAADM(admRowID),"^",1)
 ..q:papmi'=rowID
 q patName_"^"_Sex
}

Query GetAdmRowID(PatNo) As %Query(ROWSPEC = "admRowID:%String")
{
}

ClassMethod GetAdmRowIDExecute(ByRef qHandle As %Binary, PatNo) As %Status
{
 s repid=$I(^CacheTemp)	
 s ind=1
 s rowID=""
 f  s rowID=$o(^PAPERi("PAPMI_PatNo",PatNo,rowID)) q:rowID=""  d
 .s typeRowID=""
 .f  s typeRowID=$o(^PAPERdr(rowID,"ADM",typeRowID))  q:typeRowID=""  d
 ..s admRowID=""
 ..f  s admRowID=$o(^PAPERdr(rowID,"ADM",typeRowID,admRowID)) q:admRowID=""  d
 ...d OutputRow
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
    
OutputRow
	set Data=$lb(admRowID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAdmRowIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdmRowIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAdmRowIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdmRowIDExecute ]
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

Query GetPatBillRowID(admRowID) As %Query(ROWSPEC = "billRowID:%String,totalamount:%String")
{
}

ClassMethod GetPatBillRowIDExecute(ByRef qHandle As %Binary, admRowID) As %Status
{
 s repid=$I(^CacheTemp)	
 s ind=1
 if admRowID=""  Set qHandle=$lb(0,repid,0)  Quit $$$OK
 s billRowID=""
 f  s billRowID=$o(^DHCPB(0,"ADM",admRowID,billRowID)) q:billRowID=""  d
 .s totalamount=$p(^DHCPB(billRowID),"^",8)
 .d OutputRow
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
    
OutputRow
	set Data=$lb(billRowID,totalamount)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPatBillRowIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatBillRowIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPatBillRowIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatBillRowIDExecute ]
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

Query GetBillDetailss(aarowid) As %Query(ROWSPEC = "item:%String,unitPrice:%String,billQty:%String,totalAmout:%String")
{
}

ClassMethod GetBillDetailssExecute(ByRef qHandle As %Binary, aarowid) As %Status
{
 s repid=$I(^CacheTemp)	
 s ind=1
 if aarowid=""  Set qHandle=$lb(0,repid,0)  Quit $$$OK
 s sunRowID=""
 f  s sunRowID=$o(^DHCPB(aarowid,"O",sunRowID)) q:sunRowID=""  d
 .s grandSunRowID="0"
 .f  s grandSunRowID=$o(^DHCPB(aarowid,"O",sunRowID,"D",grandSunRowID)) q:grandSunRowID=""  d
 ..i $d(^DHCPB(aarowid,"O",sunRowID,"D",grandSunRowID)) s tari=$P(^DHCPB(aarowid,"O",sunRowID,"D",grandSunRowID),"^",3) 
 ..i $d(^DHCTARI(tari)) s item=$p(^DHCTARI(tari),"^",2)
 ..s unitPrice=$p(^DHCPB(aarowid,"O",sunRowID,"D",grandSunRowID),"^",4)
 ..s billQty=$p(^DHCPB(aarowid,"O",sunRowID,"D",grandSunRowID),"^",5)
 ..s totalAmout=$p(^DHCPB(aarowid,"O",sunRowID,"D",grandSunRowID),"^",7)
 ..s billDate=$p(^DHCPB(aarowid,"O",sunRowID,"D",grandSunRowID),"^",11)
 ..s billTime=$p(^DHCPB(aarowid,"O",sunRowID,"D",grandSunRowID),"^",12)
 ..d OutputRow
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
    
OutputRow
	set Data=$lb(item,unitPrice,billQty,totalAmout)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetBillDetailssClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBillDetailssExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetBillDetailssFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBillDetailssExecute ]
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

Storage Default
{
<Data name="DHCZhangTaoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCZhangTaoD</DataLocation>
<DefaultData>DHCZhangTaoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCZhangTaoD</IdLocation>
<IndexLocation>^web.DHCZhangTaoI</IndexLocation>
<StreamLocation>^web.DHCZhangTaoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
