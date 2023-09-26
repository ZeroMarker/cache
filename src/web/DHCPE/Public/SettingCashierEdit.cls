Class web.DHCPE.Public.SettingCashierEdit Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod Save(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{


	s ^DHCPESetting("DHCPE","ClassName of CRMGateWay")="web.DHCPE.CRM.GatewayDHC"	
    s ^DHCPESetting("DHCPE","IAdmStatuses_Resultable")="^ARRIVED^CHARGED^COMPLETED^"
    
    s ^DHCPESetting("DHCPE","BilledMode")=$p(InString,"^",1)
    s ^DHCPESetting("DHCPE","Group'sOEArcItemId")=$p(InString,"^",2)
    s ^DHCPESetting("DHCPE","InvCol")=$p(InString,"^",3)
    s ^DHCPESetting("DHCPE","InvMaxListCount")=$p(InString,"^",4)
    s ^DHCPESetting("DHCPE","InvListFlag")=$p(InString,"^",5)
   	s ^DHCPESetting("DHCPE","InvColSortType")=$p(InString,"^",6)	
    s ^DHCPESetting("DHCPE","InvDefaulltFee")=$p(InString,"^",7)
    s ^DHCPESetting("DHCPE","InvDefaultPayMode")=$p(InString,"^",8)
    s ^DHCPESetting("DHCPE","InvFlag")=$p(InString,"^",9)		
	s ^DHCPESetting("DHCPE","RoundingFee")=$p(InString,"^",10)	
	s ^DHCPESetting("DHCPE","RoundingFeeMode")=$p(InString,"^",11)  
	s ^DHCPESetting("DHCPE","CashierMin")=$p(InString,"^",12)
	q
}

ClassMethod GetInfo(itmjs As %Library.String = "", itmjsex As %Library.String = "") As %String
{
                       
   s billedmode=$g(^DHCPESetting("DHCPE","BilledMode"))                       
  
  
   s itemid=$g(^DHCPESetting("DHCPE","Group'sOEArcItemId"))
   s SUB="",VER="",item=""
   i itemid'=""  d
   .s SUB=$P(itemid,"||",1)
   .s VER=$P(itemid,"||",2)
   .s item=$p(^ARCIM(SUB,VER,1),"^",2)                                         
   else  d
   .s itemid=""
   

   s Col=$g(^DHCPESetting("DHCPE","InvCol"))                                   
   s Count=$g(^DHCPESetting("DHCPE", "InvMaxListCount"))                        
   s Type=$g(^DHCPESetting("DHCPE","InvColSortType"))                           
   s InvListFlag=$g(^DHCPESetting("DHCPE","InvListFlag"))                       
   s PayMode=$g(^DHCPESetting("DHCPE","InvDefaultPayMode"))                     
   s InvFlag=$g(^DHCPESetting("DHCPE","InvFlag"))                               
   s FeeMode=$g(^DHCPESetting("DHCPE","RoundingFeeMode"))                      
   s CashierMin=$g(^DHCPESetting("DHCPE","CashierMin"))                        
  
   s DefaulltFeeID=$g(^DHCPESetting("DHCPE","InvDefaulltFee"))                   
   s ARCSUB1="",ARCVER1="", DefaulltFee=""
   i DefaulltFeeID'=""  d
   .s ARCSUB1=$P(DefaulltFeeID,"||",1)
   .s ARCVER1=$P(DefaulltFeeID,"||",2)
   .s DefaulltFee=$p(^ARCIM(ARCSUB1,ARCVER1,1),"^",2) 
   else  d
   .s DefaulltFeeID=""
   
   
  s RoundingFeeID=$g(^DHCPESetting("DHCPE","RoundingFee"))                       
  s arcsub="",arcver="",RoundingFee=""
  i RoundingFeeID'=""  d
  .s arcsub=$P(RoundingFeeID,"||",1)
  .s arcver=$P(RoundingFeeID,"||",2)
  .s RoundingFee=$p(^ARCIM(arcsub,arcver,1),"^",2)
  else  d
  .s RoundingFeeID="" 
    
  s str=billedmode_"^"_itemid_"^"_item_"^"_Col_"^"_Count_"^"_InvListFlag_"^"_Type_"^"_DefaulltFeeID_"^"_DefaulltFee_"^"_PayMode_"^"_InvFlag_"^"_RoundingFeeID_"^"_RoundingFee_"^"_FeeMode_"^"_CashierMin  
  q str
}

ClassMethod SearchCashierExecute(ByRef qHandle As %Binary) As %Status
{
   Set repid=$I(^CacheTemp)
   s ind=1
   
   s billedmode=$g(^DHCPESetting("DHCPE","BilledMode"))                       
  
  
   s itemid=$g(^DHCPESetting("DHCPE","Group'sOEArcItemId"))
   s SUB="",VER="",item=""
   i itemid'=""  d
   .s SUB=$P(itemid,"||",1)
   .s VER=$P(itemid,"||",2)
   .s item=$p(^ARCIM(SUB,VER,1),"^",2)                                         
   else  d
   .s itemid=""
                                  
   
   d SearchOut
   
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
SearchOut      
	set Data=$lb(billedmode,itemid,item)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchCashierFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchCashierExecute ]
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

Query SearchCashier() As %Query(ROWSPEC = "TBilledMode:%String,TFeeRowID:%String,TGroupsOEArcItemId:%String")
{
}

ClassMethod SearchCashierClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchCashierExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPayModeData()
{
    s ModeDescStr=""
	s PayModeID=0
	f  s PayModeID=$o(^DHCPESetting("DHCPE","CashierMode",PayModeID))  q:PayModeID=""  d
	.Q:$g(^DHCPESetting("DHCPE","CashierMode",PayModeID))="N"
	.s ModeDesc=$p(^CT("CTPM",PayModeID),"^",2)
	.i ModeDescStr=""  s ModeDescStr=ModeDesc
	.else  s ModeDescStr=ModeDescStr_","_ModeDesc
	q ModeDescStr
}

ClassMethod SearchPayModeExecute(ByRef qHandle As %Binary) As %Status
{
   Set repid=$I(^CacheTemp)
   s ind=1
   s CTPMRowId=0
   f  s CTPMRowId=$o(^CT("CTPM",CTPMRowId))  q:CTPMRowId=""  d
   .s CTPMCode=$p(^CT("CTPM",CTPMRowId),"^",1)
   .s CTPMDesc=$p(^CT("CTPM",CTPMRowId),"^",2)
   .d OutPut
   
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
OutPut      
	set Data=$lb(CTPMDesc,CTPMRowId,CTPMCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchPayModeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchPayModeExecute ]
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

Query SearchPayMode() As %Query(ROWSPEC = "TPayMode:%String,TPayModeID:%String,TPayModeCode:%String")
{
}

ClassMethod SearchPayModeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchPayModeExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SavePayMode(PayModeID, String)
{
 s flag=$p(String,"^",1)
 s Cardflag=$p(String,"^",2)
 s Refundflag=$p(String,"^",3)
 S ^DHCPESetting("DHCPE","CashierMode",PayModeID)=flag
 s ^DHCPESetting("DHCPE","CardMode",PayModeID)=Cardflag
 s ^DHCPESetting("DHCPE","RefundMode",PayModeID)=Refundflag
 q
}

ClassMethod InfoPayMode(PayModeID)
{
 q:PayModeID=""
 s Flag="",CardFlag="",RefundFlag=""
 S Flag=$g(^DHCPESetting("DHCPE","CashierMode",PayModeID))
 S CardFlag=$g(^DHCPESetting("DHCPE","CardMode",PayModeID))
 s RefundFlag=$g(^DHCPESetting("DHCPE","RefundMode",PayModeID))
 q Flag_"^"_CardFlag_"^"_RefundFlag
}

}
