Class web.DHCPE.OtherStation Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod Save(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
   s ^zhouli("1101")=InString
   s ^DHCPESetting("DHCPE","ClassName of CRMGateWay")="web.DHCPE.CRM.GatewayDHC"	
   s ^DHCPESetting("DHCPE","IAdmStatuses_Resultable")="^ARRIVED^CHARGED^COMPLETED^"
    
   s OtherID=$p($g(InString),"^",1)
   s OtherStation=$p($g(InString),"^",2)
   s ^DHCPESetting("DHCPE","StationId_Ris",OtherID)=OtherStation
   q
}

ClassMethod SearchOtherExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	s OtherID=0
    f  s OtherID=$o(^DHCPESetting("DHCPE","StationId_Ris",OtherID))  q:OtherID=""  d
   .s OtherStation=$g(^DHCPESetting("DHCPE","StationId_Ris",OtherID))
   .d SearchOut

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
SearchOut      
	set Data=$lb(OtherID,OtherStation)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchOtherFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchOtherExecute ]
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

Query SearchOther() As %Query(ROWSPEC = "TOtherID:%String,TOtherStation:%String")
{
}

ClassMethod SearchOtherClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchOtherExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod Delete(string)
{
    s OtherID=$p(string,"^",1)
  
	K ^DHCPESetting("DHCPE","StationId_Ris",OtherID)

	q
}

}
