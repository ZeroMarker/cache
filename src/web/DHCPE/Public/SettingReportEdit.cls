Class web.DHCPE.Public.SettingReportEdit Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod Save(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{

	s ^zhouli("1101")=InString
	s ^DHCPESetting("DHCPE","ClassName of CRMGateWay")="web.DHCPE.CRM.GatewayDHC"	
    s ^DHCPESetting("DHCPE","IAdmStatuses_Resultable")="^ARRIVED^CHARGED^COMPLETED^"

    s ^DHCPESetting("DHCPE","ReportTitle")=$p(InString,"^",1)
    q
}

ClassMethod GetInfo(itmjs As %Library.String = "", itmjsex As %Library.String = "") As %String
{
  
  s report=$g(^DHCPESetting("DHCPE","ReportTitle"))                        
  q report
}

}
