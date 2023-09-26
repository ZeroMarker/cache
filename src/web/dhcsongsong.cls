Class web.dhcsongsong Extends %RegisteredObject
{

ClassMethod GetPatientName(RegonNo As %String) As %String
{
   quit:RegonNo="" 
   set patmasid=""
  	
   set patmasid= $o(^PAPERi("PAPMI_PatNo",RegonNo,patmasid))
   
   quit:patmasid="" 										;没有病人的基本信息的rowid退出
   
   quit:($d(^PAPER(patmasid))=0) 							; 病人的基本信息是空的时候退出
   	
   														
    set PatName=$p(^PAPER(patmasid,"ALL"),"^",1)				;获取病人的姓名
  
	quit PatName
}

/// 根据就诊rowid找到账单总表明细
Query GetPaBillQuery(patmasinf As %String) As %Query(ROWSPEC = "PbRowid:%String,PbTotalAmount:%String")
{
}

ClassMethod GetPaBillQueryExecute(ByRef qHandle As %Binary, patmasinf As %String) As %Status
{
	
	
	
	Set repid=$I(^CacheTemp)
	
	set ind=1
	
	set paadrowid=patmasinf
	
	if paadrowid="" {
		Set qHandle=$lb(0,repid,0)
	     Quit $$$OK
		}     
	
	set PbRowid=""
	for{
		set PbRowid=$O(^DHCPB(0,"ADM",paadrowid,PbRowid) )
		quit:PbRowid=""
		set PbTotalAmount=$P(^DHCPB(PbRowid),"^","8")
		
		set Data=$lb(PbRowid,PbTotalAmount)
		Set ^CacheTemp(repid,ind)=Data 
		set ind=ind+1 
	
	
	}
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod GetPaBillQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPaBillQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPaBillQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPaBillQueryExecute ]
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

Query PatBillDetailQuery(PBRowId As %String) As %Query(ROWSPEC = "pbdtariname:%String,pbdunitprice:%String,pbdbillqty:%String,pbdtotalamount:%String")
{
}

ClassMethod PatBillDetailQueryExecute(ByRef qHandle As %Binary, PBRowId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	
	set ind=1	
	
	if PBRowId="" {
		Set qHandle=$lb(0,repid,0)
	     Quit $$$OK
		} 
	set PatBillOrderId=""

	for {
	     set PatBillOrderId=$o(^DHCPB(PBRowId,"O",PatBillOrderId))
	    
	 
	    
	     quit:PatBillOrderId=""
	     set patbilldetailid=""
	     
	    
	     for{
		     
		    if (($D(^DHCPB(PBRowId,"O",PatBillOrderId))=10)||($D(^DHCPB(PBRowId,"O",PatBillOrderId))=11))
		     {

		   set patbilldetailid=$O(^DHCPB(PBRowId,"O",PatBillOrderId,"D",patbilldetailid))
		   
	
		  
		   quit:patbilldetailid=""
			   
		   		   
		  
		   set pbdtariid=$P(^DHCPB(PBRowId,"O",PatBillOrderId,"D",patbilldetailid),"^",3)
		   
		
		   IF pbdtariid="" {CONTINUE } ;收费项目id为空时退出本层循环
		    
		    set pbdtariname=$p(^DHCTARI(pbdtariid),"^",2)
		
		   set pbdunitprice=$P(^DHCPB(PBRowId,"O",PatBillOrderId,"D",patbilldetailid),"^",4)
		   set pbdbillqty=$P(^DHCPB(PBRowId,"O",PatBillOrderId,"D",patbilldetailid),"^",5)
		   set pbdtotalamount=$P(^DHCPB(PBRowId,"O",PatBillOrderId,"D",patbilldetailid),"^",7)
		   set Data=$lb(pbdtariname,pbdunitprice,pbdbillqty,pbdtotalamount)
		   Set ^CacheTemp(repid,ind)=Data
		   set ind=ind+1 
		   	  
		     }else{
			     quit 
			     }
		     
		     
		  }
	     
	}	
		
		
		
	Set qHandle=$lb(0,repid,0)    
	Quit $$$OK
}

ClassMethod PatBillDetailQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PatBillDetailQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod PatBillDetailQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PatBillDetailQueryExecute ]
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

}
