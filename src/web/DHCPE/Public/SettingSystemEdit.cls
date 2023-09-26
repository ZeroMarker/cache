Class web.DHCPE.Public.SettingSystemEdit Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod Save(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{

	s ^zhouli("1101")=InString
	s ^DHCPESetting("DHCPE","ClassName of CRMGateWay")="web.DHCPE.CRM.GatewayDHC"	
    s ^DHCPESetting("DHCPE","IAdmStatuses_Resultable")="^ARRIVED^CHARGED^COMPLETED^"
    
    
	s ^DHCPESetting("DHCPE","HospitalName")=$p(InString,"^",1)
	s ^DHCPESetting("DHCPE","HospitalCode")=$p(InString,"^",2)
	s ^DHCPESetting("DHCPE","TrakVerison")=$p(InString,"^",3)
	s ^DHCPESetting("NAMESPACE","MEDDATA")=$p(InString,"^",4)
	s ^DHCPESetting("NAMESPACE","LABDATA")=$p(InString,"^",5)
    q
}

ClassMethod GetInfo(itmjs As %Library.String = "", itmjsex As %Library.String = "") As %String
{
                       
    s hos=$g(^DHCPESetting("DHCPE","HospitalName"))                            
    s hoscode=$g(^DHCPESetting("DHCPE","HospitalCode"))                      
    s itr=$g(^DHCPESetting("DHCPE","TrakVerison"))                             
    s med=$g(^DHCPESetting("NAMESPACE","MEDDATA"))
    s lab=$g(^DHCPESetting("NAMESPACE","LABDATA"))
    s str=hos_"^"_hoscode_"^"_itr_"^"_med_"^"_lab
    q str
}

ClassMethod SearchSystemExecute(ByRef qHandle As %Binary) As %Status
{
   Set repid=$I(^CacheTemp)
   s ind=1
   s hos=$g(^DHCPESetting("DHCPE","HospitalName"))                                
   s hoscode=$g(^DHCPESetting("DHCPE","HospitalCode"))
   d SearchOut
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
SearchOut      
	set Data=$lb(hos,hoscode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchSystemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchSystemExecute ]
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

Query SearchSystem() As %Query(ROWSPEC = "THospitalName:%String,THospitalCode:%String")
{
}

ClassMethod SearchSystemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchSystemExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
