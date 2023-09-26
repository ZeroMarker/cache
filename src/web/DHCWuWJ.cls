/// Description:该类主要实现一些作业上的方法
/// creator:    wuwenjie
/// creatdate:  2010-3-24
Class web.DHCWuWJ Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

ClassMethod QryDepositDetByDNClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDepositDetByDNExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDepositDetByDNExecute(ByRef qHandle As %Binary, StartDate, EndDate, UserName) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1 
    ;s StatrDate=$zdh(StartDate,3)
    ;s EndDate=$zdh(EndDate,3)
    i StartDate>EndDate s EndDate=StartDate
    s RowId=""
    s UserName1=""
    f PrtDate=StartDate:1:EndDate  do
    .s RowId=$o(^DHCSFPRINTDETAIL(0,"PrtDate",PrtDate,RowId)) q:RowId=""  d
    .S PrtDate=$p(^DHCSFPRINTDETAIL(RowId),"^",2)
    .S PrtTime=$p(^DHCSFPRINTDETAIL(RowId),"^",3)
    .S AdmId=$p(^DHCSFPRINTDETAIL(RowId),"^",4)
    .s Userid=$p(^DHCSFPRINTDETAIL(RowId),"^",14)
    .i $d(^SSU("SSUSR",Userid)) d
    ..s UserName1=$p(^SSU("SSUSR",Userid),"^",2) //UserName1为收款人的姓名 
    .q:(UserName1'[UserName)&(UserName'="")  
    .I $d(^PAADM(AdmId)) d
    ..S paperid=$p(^PAADM(AdmId),"^",1) 
    ..S PatName=$p(^PAPER(paperid,"ALL"),"^",1)
    ..S Regno=$p(^PAPER(paperid,"PAT",1),"^",1)
    .S PayAmt=$p(^DHCSFPRINTDETAIL(RowId),"^",6)
    .S PayMode=$p(^DHCSFPRINTDETAIL(RowId),"^",9)
    .Do OutputRow
       Set qHandle=$lb(0,repid,0)
       Quit $$$OK
OutputRow
       set Data=$lb(PatName,PayAmt,PayMode,$zd(PrtDate,3),$zt(PrtTime),UserName1)
       Set ^CacheTemp(repid,ind)=Data
       Set ind=ind+1
	   quit
}

ClassMethod QryDepositDetByDNFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDepositDetByDNExecute ]
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

//通过时间和收费员，来查询收费信息

//D ##class(%ResultSet).RunQuery("web.DHCWuWJ","QryDepositDetByDN", 60631,61362,"齐")

Query QryDepositDetByDN(StartDate, EndDate, UserName) As %Query(ROWSPEC = "PatName:%String,PayAmt:%String,PayMode:%String,PrtDate:%String,PrtTime:%String,UserName1:%String")
{
}

ClassMethod QryUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryUserExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryUserExecute(ByRef qHandle As %Binary, UserName) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1 	
    s rowid=""
    f  s rowid=$o(^SSU("SSUSR",rowid)) q:rowid=""  d
    .s UserName1=$p(^SSU("SSUSR",rowid),"^",2)
    .q:(UserName1'[UserName)&(UserName'="") 
    .s UserRowId=rowid
    .Do OutputRow
       Set qHandle=$lb(0,repid,0)
       Quit $$$OK
OutputRow
       set Data=$lb(UserName1,UserRowId)
       Set ^CacheTemp(repid,ind)=Data
       Set ind=ind+1
	   quit
}

ClassMethod QryUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryUserExecute ]
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

//查询收费员的信息

//D ##class(%ResultSet).RunQuery("web.DHCWuWJ","QryUser")

Query QryUser(UserName) As %Query(ROWSPEC = "UserName:%String,UserRowId:%String")
{
}

ClassMethod ShowNameSex(Regno) As %String
{
   
    s PatName=""
    s Sex=""
	s Regno=$g(Regno)
	q:+Regno<1 PatName_"^"_Sex
	s length1=$Length(Regno)
	s num=0
	i length1<10 d
	.f num=1:1:(10-length1) d
	..s Regno="0"_Regno
	s:length1>10 Regno=$e(Regno,(length1-9),length1)
	q:'$d(^PAPERi("PAPMI_PatNo",Regno)) PatName_"^"_Sex
	s RowId=""
	s RowId=$o(^PAPERi("PAPMI_PatNo",Regno,RowId))
	s PatName=$p(^PAPER(RowId,"ALL"),"^",1)
	s SexId=$p(^PAPER(RowId,"ALL"),"^",7)
	s Sex=$p(^CT("SEX",SexId),"^",2)
	;w PatName_"^"_Sex
	q PatName_"^"_Sex
}

ClassMethod FindName(Regno) As %String
{
   
    s PatName=""
	s Regno=$g(Regno)
	q:+Regno<1 PatName
	s length1=$Length(Regno)
	s num=0
	i length1<10 d
	.f num=1:1:(10-length1) d
	..s Regno="0"_Regno
	s:length1>10 Regno=$e(Regno,(length1-9),length1)
	q:'$d(^PAPERi("PAPMI_PatNo",Regno)) PatName
	s RowId=""
	s RowId=$o(^PAPERi("PAPMI_PatNo",Regno,RowId))
	s PatName=$p(^PAPER(RowId,"ALL"),"^",1)
	q PatName
}

ClassMethod QryAdmIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAdmIdExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryAdmIdExecute(ByRef qHandle As %Binary, Regno) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1 	
	s Regno=$g(Regno)
	 if Regno=""  s qHandle=$lb(0,repid,0) Quit $$$OK
	q:+Regno<1 
	s length1=$Length(Regno)
	s num=0
	i length1<10 d
	.f num=1:1:(10-length1) d
	..s Regno="0"_Regno
	s:length1>10 Regno=$e(Regno,(length1-9),length1)
	q:'$d(^PAPERi("PAPMI_PatNo",Regno)) 
	s PatRowId=""
	s PatRowId=$o(^PAPERi("PAPMI_PatNo",Regno,PatRowId))
	s AdmType=""
	f  s AdmType=$o(^PAPERdr(PatRowId,"ADM",AdmType)) q:AdmType=""  d
	.s AdmRowId=""
	.f  s AdmRowId=$o(^PAPERdr(PatRowId,"ADM",AdmType,AdmRowId)) q:AdmRowId=""  d
    ..Do OutputRow
       Set qHandle=$lb(0,repid,0)
       Quit $$$OK
OutputRow
       set Data=$lb(AdmRowId)
       Set ^CacheTemp(repid,ind)=Data
       Set ind=ind+1
	   quit
}

ClassMethod QryAdmIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAdmIdExecute ]
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

//D ##class(%ResultSet).RunQuery("web.DHCWuWJ","QryAdmId","1")

Query QryAdmId(Regno) As %Query(ROWSPEC = "AdmRowId:%String")
{
}

ClassMethod FindBill(AdmId) As %String
{
   
    s TotalAmount=0
    s AdmId=$g(AdmId)
    s PbRowId=""
    q:'$d(^DHCPB(0,"ADM",AdmId)) TotalAmount
    f  s PbRowId=$o(^DHCPB(0,"ADM",AdmId,PbRowId)) q:PbRowId=""  d   
	.s TotalAmount1=$p(^DHCPB(PbRowId),"^",8) 
	.s TotalAmount=TotalAmount+TotalAmount1
	;w !,TotalAmount
	q TotalAmount
}

ClassMethod QryBillIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBillIdExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryBillIdExecute(ByRef qHandle As %Binary, AdmId) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1 	
     s AdmId=$g(AdmId)
   if AdmId=""  s qHandle=$lb(0,repid,0) Quit $$$OK
    s PbRowId=""
 
    f  s PbRowId=$o(^DHCPB(0,"ADM",AdmId,PbRowId)) q:PbRowId=""  d   
    .Do OutputRow
       Set qHandle=$lb(0,repid,0)
       Quit $$$OK
OutputRow
       set Data=$lb(PbRowId)
       Set ^CacheTemp(repid,ind)=Data
       Set ind=ind+1
	   quit
}

ClassMethod QryBillIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBillIdExecute ]
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

//D ##class(%ResultSet).RunQuery("web.DHCWuWJ","QryBillId","13")

Query QryBillId(AdmId) As %Query(ROWSPEC = "PbRowId:%String")
{
}

ClassMethod QryDetailByRowIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDetailByRowIDExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDetailByRowIDExecute(ByRef qHandle As %Binary, BillId) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1 	
    s RowId=BillId
    s TARIDesc=""
    s Pbdunitprice=""
    s Pbdbillqty=""
    s Pbdtotalamount=""
    if RowId="" d  
    .set Data=$lb(TARIDesc,Pbdunitprice,Pbdbillqty,Pbdtotalamount)
    .Set ^CacheTemp(repid,ind)=Data
    .Set ind=ind+1
	.quit
	e  d
    .s OrdSub=""
    .f  s OrdSub=$o(^DHCPB(RowId,"O",OrdSub)) q:OrdSub=""  d 
   ..s DetSub=""
   ..f  s DetSub =$o(^DHCPB(RowId,"O",OrdSub,"D",DetSub)) q:DetSub=""  d
   ...s Pbdtaridr=$p(^DHCPB(RowId,"O",OrdSub,"D",DetSub),"^",3)
   ...q:Pbdtaridr=""  d
   ...s TARIDesc=$p(^DHCTARI(Pbdtaridr),"^",2) 
   ...s Pbdunitprice=$p(^DHCPB(RowId,"O",OrdSub,"D",DetSub),"^",4)
   ...s Pbdbillqty=$p(^DHCPB(RowId,"O",OrdSub,"D",DetSub),"^",5)
   ...s Pbdtotalamount=$p(^DHCPB(RowId,"O",OrdSub,"D",DetSub),"^",7)
   ...;w !,TARIDesc_"^"_Pbdunitprice_"^"_Pbdbillqty_"^"_Pbdtotalamount
   ...Do OutputRow
       Set qHandle=$lb(0,repid,0)
       Quit $$$OK
OutputRow
       set Data=$lb(TARIDesc,Pbdunitprice,Pbdbillqty,Pbdtotalamount)
       Set ^CacheTemp(repid,ind)=Data
       Set ind=ind+1
	   quit
}

ClassMethod QryDetailByRowIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDetailByRowIDExecute ]
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

//D ##class(%ResultSet).RunQuery("web.DHCWuWJ","QryDetailByRowID","3226")

Query QryDetailByRowID(BillId) As %Query(ROWSPEC = "TARIDesc:%String,Pbdunitprice:%String,Pbdbillqty:%String,Pbdtotalamount:%String")
{
}

}
