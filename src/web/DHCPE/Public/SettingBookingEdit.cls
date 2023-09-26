Class web.DHCPE.Public.SettingBookingEdit Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod Save(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{

	s ^zhouli("1101")=InString
	s ^DHCPESetting("DHCPE","ClassName of CRMGateWay")="web.DHCPE.CRM.GatewayDHC"	
    s ^DHCPESetting("DHCPE","IAdmStatuses_Resultable")="^ARRIVED^CHARGED^COMPLETED^"
    
    
	s ^DHCPESetting("DHCPE","PhyExamLocId")=$p(InString,"^",1)
    s ^DHCPESetting("DHCPE","PhyExamDrId")=$p(InString,"^",2)
    s ^DHCPESetting("DHCPE","PAPMINo_GenModel")=$p(InString,"^",3)
    s ^DHCPESetting("DHCPE","BookDateLimit")=$p(InString,"^",4)
    s $p(^DHCPESetting("DHCPE","DefPatientType"),"^",1)=$p(InString,"^",5) 
    s $p(^DHCPESetting("DHCPE","DefPatientType"),"^",2)=$p(InString,"^",6)
    q
}

ClassMethod GetInfo(itmjs As %Library.String = "", itmjsex As %Library.String = "") As %String
{
                       
   s locid=$g(^DHCPESetting("DHCPE","PhyExamLocId"))                          
   s locdesc=""
   i locid'=""  d
   .s locdesc=$p(^CTLOC(locid),"^",2)                                         
   else  d
   .s locid=""                                      
   
   s drid=$g(^DHCPESetting("DHCPE","PhyExamDrId"))
   s docName=""
   i drid'=""  d
   .s docName=$p($g(^CTPCP(drid,1)),"^",2)                                    
    else  d
   .s drid=""
  
  
   s GenModel=$g(^DHCPESetting("DHCPE","PAPMINo_GenModel"))                     
   s DateLimit=$g(^DHCPESetting("DHCPE","BookDateLimit"))                      
   s feename=$p(^DHCPESetting("DHCPE","DefPatientType"),"^",1)                      
   s sexname=$p(^DHCPESetting("DHCPE","DefPatientType"),"^",2)                  
   s str=locid_"^"_locdesc_"^"_drid_"^"_docName_"^"_GenModel_"^"_DateLimit_"^"_feename_"^"_sexname
   q str
}

ClassMethod SearchTPhyExamExecute(ByRef qHandle As %Binary) As %Status
{
   Set repid=$I(^CacheTemp)
   s ind=1
   
   s locid=$g(^DHCPESetting("DHCPE","PhyExamLocId"))                          
   s locdesc=""
   i locid'=""  d
   .s locdesc=$p(^CTLOC(locid),"^",2)                                         
   else  d
   .s locid=""                                      
   
   s drid=$g(^DHCPESetting("DHCPE","PhyExamDrId"))
   s docName=""
   i drid'=""  d
   .s docName=$p($g(^CTPCP(drid,1)),"^",2)                                    
    else  d
   .s drid=""
   
  d SearchOut
   
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
SearchOut      
	set Data=$lb(locdesc,docName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchTPhyExamFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchTPhyExamExecute ]
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

Query SearchTPhyExam() As %Query(ROWSPEC = "TPhyExamLocId:%String,TPhyExamDrId:%String")
{
}

ClassMethod SearchTPhyExamClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchTPhyExamExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
