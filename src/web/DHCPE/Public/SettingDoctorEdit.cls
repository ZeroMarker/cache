Class web.DHCPE.Public.SettingDoctorEdit Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod Save(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{

	s ^zhouli("1101")=InString
	s ^DHCPESetting("DHCPE","ClassName of CRMGateWay")="web.DHCPE.CRM.GatewayDHC"	
    s ^DHCPESetting("DHCPE","IAdmStatuses_Resultable")="^ARRIVED^CHARGED^COMPLETED^"
   
    s ^DHCPESetting("DHCPE","StationId_Lab")=$p(InString,"^",1)
    q
}

ClassMethod GetInfo(itmjs As %Library.String = "", itmjsex As %Library.String = "") As %String
{
                       
   s labid=$g(^DHCPESetting("DHCPE","StationId_Lab"))
   s labdesc=""
   i labid'="" d
   .s labdesc=$p(^DHCPEST(labid),"^",2)                                         
   else  d                                 
   .s labid="" 
   
   s risid=0
   s risid=$o(^DHCPESetting("DHCPE","StationId_Ris",risid))
   s abc=$g(^DHCPESetting("DHCPE","StationId_Ris",risid))
   f  s risid=$o(^DHCPESetting("DHCPE","StationId_Ris",risid))  q:risid=""  d
   .s risdesc=$g(^DHCPESetting("DHCPE","StationId_Ris",risid))
   .s abc=abc_","_risdesc
   
   s ssgid=0
   s ssgid=$o(^DHCPESetting("DHCPE","SSGroup_SummarizeAudit",ssgid))
   s def=$g(^DHCPESetting("DHCPE","SSGroup_SummarizeAudit",ssgid))
   f  s ssgid=$o(^DHCPESetting("DHCPE","SSGroup_SummarizeAudit",ssgid))  q:ssgid=""  d
   .s ssgdesc=$g(^DHCPESetting("DHCPE","SSGroup_SummarizeAudit",ssgid))
   .s def=def_","_ssgdesc
   
   s str=labid_"^"_labdesc_"^"_abc_"^"_def
   q str
}

}
