Class web.DHCChenXR Extends %RegisteredObject
{

Query PatDetail(StartDate, EndDate, AcceptorName) As %Query(ROWSPEC = "papname:%String,pdate:%String,ptime:%String,payAmount:%String,paymodel:%String,username:%String")
{
}

ClassMethod PatDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PatDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod PatDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PatDetailExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod PatDetailExecute(ByRef qHandle As %Binary, StartDate, EndDate, AcceptorName) As %Status
{
   Set repid=$I(^CacheTemp)
   If $g(ind)="" Set ind=0
 	S ^PatDetail=StartDate_"^"_EndDate_"^"_AcceptorName
   I (StartDate="")!(EndDate="") Set qHandle=$lb(0,repid,0) Quit $$$OK
   ;s start = $zdh(StartDate,3)
   ;s end = $zdh(EndDate,3)
   f prtdate = StartDate:1:EndDate  do
   .s prtrowid=""
   .f  s prtrowid = $O(^DHCSFPRINTDETAIL(0,"PrtDate",prtdate,prtrowid)) q:prtrowid=""  do 
   ..s pdate=$zd($p(^DHCSFPRINTDETAIL(prtrowid),"^",2),3)
   ..s ptime=$zt($p(^DHCSFPRINTDETAIL(prtrowid),"^",3),3)

   ..s admIndex=$p(^DHCSFPRINTDETAIL(prtrowid),"^",4)
   ..q:admIndex=""
   
   ..s papmi=""
   ..i $d(^PAADM(admIndex)) s papmi=$p(^PAADM(admIndex),"^",1)  
   ..q:papmi=""
   ..i $d(^PAPER(papmi)) s papname=$p(^PAPER(papmi,"ALL"),"^",1)
   
   ..s payAmount = $p(^DHCSFPRINTDETAIL(prtrowid),"^",6)
   
  
   ..s pmrowid=$p(^DHCSFPRINTDETAIL(prtrowid),"^",9)
   ..s paymodel=""
   ..i $d(^CT("CTPM",pmrowid)) s paymodel=$p(^CT("CTPM",pmrowid),"^",2)

   ..s userrowid=$p(^DHCSFPRINTDETAIL(prtrowid),"^",14)
   ..s username=""
   ..i $d(^SSU("SSUSER",userrowid)) s username=$p(^SSU("SSUSER",userrowid),"^",2)
   ..q:(username'=AcceptorName)&(AcceptorName'="")
   

   ..d OutputRow
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
    
OutputRow
	set Data=$lb(papname,pdate,ptime,payAmount,paymodel,userName)
 	Set ^CacheTemp(repid,ind)=Data 
 	Set ind=ind+1
	quit
}

/// 查询收费员姓名的Query,返回姓名和rowid
Query Acceptor() As %Query(ROWSPEC = "AcceptorName:%String,rowid:%String")
{
}

ClassMethod AcceptorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AcceptorExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod AcceptorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AcceptorExecute ]
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

ClassMethod AcceptorExecute(ByRef qHandle As %Binary) As %Status
{
   Set repid=$I(^CacheTemp)
   If $g(ind)="" Set ind=0
   s index=""
   f  s index=$O(^SSU("SSUSR",index)) q:index=""  d
   .s AcceptorName=$p(^SSU("SSUSR",index),"^",2)
   .d OutputRow
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
    
OutputRow
	set Data=$lb(AcceptorName,index)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

/// ////练习9///////////////////////////////////////////
ClassMethod GetPatInfo(patno As %String) As %String
{
 
  //注意要加上必要的数据检查 为空等
  //^PAPERi("PAPMI_PatNo",$$ALPHAUP({PAPMI_No}),{PAPMI_RowId}) 
  //通过索引得到ROWID
  set len=$Length(patno)
  s i=0
  if len<10 do
  .for i=1:1:(10-len) do
  ..set patno="0"_patno
  
  set rowid=""
  for  set rowid=$o(^PAPERi("PAPMI_PatNo",patno,rowid)) q:rowid=""  do 
  .//w "no="_rowid
  .s papname=$p(^PAPER(rowid,"ALL"),"^",1) 
  .s admid=$p(^PAPER(rowid,"ALL"),"^",6)
  .q
  
  q papname_"^"_admid_"^"_patno
}

ClassMethod GetADM(patno As %String) As %String
{
 
   //注意要加上必要的数据检查 为空等
  //^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})  
  //通过索引得到ROWID
  set rowid=""
  set rowid=$o(^PAPERi("PAPMI_PatNo",patno,rowid)) q:rowid=""  do 
  w !,patno
  w !,rowid
  
  set ADMrowid=""
  for  set ADMrowid=$o(^PAPERdr(rowid,"ADM","I",ADMrowid)) q:ADMrowid=""  do 
  .w !,ADMrowid
  .//s papname=$p(^PAADM(rowid),"^",1) 
  .//w "no="_papname
  .q
  
  q
}

/// ////////////////////////////////////////////////////
Query GetADMList(patno As %String) As %Query(ROWSPEC = "ADMid:%String")
{
}

ClassMethod GetADMListExecute(ByRef qHandle As %Binary, patno As %String) As %Status
{
  Set repid=$I(^CacheTemp)
  If $g(ind)="" Set ind=0
   
  //空
  if patno="" s patno="0000000001"
   //长度
  set len=$Length(patno)
  s i=0
  if len<10 do
  .for i=1:1:(10-len) do
  ..set patno="0"_patno
  
  
  set rowid=""
  set rowid=$o(^PAPERi("PAPMI_PatNo",patno,rowid)) q:rowid=""  do 
  set ADMrowid=""
  for  set ADMrowid=$o(^PAPERdr(rowid,"ADM","I",ADMrowid)) q:ADMrowid=""  do 
  
   
   
   .d OutputRow
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
    
OutputRow
	set Data=$lb(ADMrowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetADMListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetADMListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetADMListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetADMListExecute ]
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

/// ////////////////////////////////////////////////////////
Query GetBillList(patadmno As %String) As %Query(ROWSPEC = "Billid:%String,BillSum:%String")
{
}

ClassMethod GetBillListExecute(ByRef qHandle As %Binary, patadmno As %String) As %Status
{
  Set repid=$I(^CacheTemp)
  If $g(ind)="" Set ind=0
  
  //^DHCPB(0,"ADM",{PB_Adm_Dr},{PB_RowId})    
  if patadmno="" set patadmno="13"
  set ADMid=patadmno
  set rowid=""
  for  set rowid=$o(^DHCPB(0,"ADM",ADMid,rowid)) q:rowid=""  do 
  .//w ^DHCPB(0,"ADM",ADMid,rowid)
  .s billsum=$p(^DHCPB(rowid),"^",8) 
   
   
  .d OutputRow
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
    
OutputRow
	set Data=$lb(rowid,billsum)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetBillListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetADMListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetBillListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetADMListExecute ]
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

/// ////////////////////////////////////////////////////////
Query GetBillDetail(Billid As %String) As %Query(ROWSPEC = "Billid:%String,pbdtaridr:%String,pbdunitprice:%String,pbdbillqty:%String,pbdtotalamount:%String")
{
}

ClassMethod GetBillDetailExecute(ByRef qHandle As %Binary, Billid As %String) As %Status
{
  Set repid=$I(^CacheTemp)
  If $g(ind)="" Set ind=0
  
  //^DHCPB({DHC_PatientBill.PB_RowId},"O",{DHC_PatBillOrder.PBO_ChildSub},"D",{PBD_ChildSub}) 
  // ^DHCTARI(0,"Code",$$ALPHAUP({TARI_Code}),{TARI_RowId}) 
  //Billid,pbd_tari_dr ,pbd_unitprice,pbd_billqty,pbd_totalamount   
  
 //if Billid="" quit
  if Billid="" set Billid="3225"
 // set temp=^DHCPB(rowid,"O","","D","")
  
  //for  set Billid=$O(^DHCPB(Billid)) q:Billid=""  do 
  //w Billid
  set subid=""
  for  set subid=$O(^DHCPB(Billid,"O",subid)) q:subid=""  do 
  .set detsub=""
  .for  set detsub=$O(^DHCPB(Billid,"O",subid,"D",detsub)) q:detsub=""  do
  ..if $d(^DHCPB(Billid,"O",subid,"D",detsub)) set temp=^DHCPB(Billid,"O",subid,"D",detsub)
  ..//w !,temp
  ..set temp1=$p(temp,"^",3) 
  
  ..if temp1'="" if $d(^DHCTARI(temp1)) set pbdtaridr=$p(^DHCTARI(temp1),"^",2)
  ..set pbdunitprice=$p(temp,"^",4) 
  ..set pbdbillqty=$p(temp,"^",5) 
  ..set pbdtotalamount=$p(temp,"^",7) 
   
   
  ..d OutputRow
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
    
OutputRow
	set Data=$lb(Billid,pbdtaridr,pbdunitprice,pbdbillqty,pbdtotalamount)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetBillDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetADMListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetBillDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetADMListExecute ]
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
<Data name="DHCChenXRDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCChenXRD</DataLocation>
<DefaultData>DHCChenXRDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCChenXRD</IdLocation>
<IndexLocation>^web.DHCChenXRI</IndexLocation>
<StreamLocation>^web.DHCChenXRS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
