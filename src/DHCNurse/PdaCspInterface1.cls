Class DHCNurse.PdaCspInterface1 Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "PdaClsInterface1";

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
Parameter LOCATION = "http://172.26.201.3/trakcarelive/trak/web";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn";

/// TODO: add arguments and implementation.
/// Test
ClassMethod SaveAuditFlag(oeoriIdStr, userId, AuditFlag) As %String [ WebMethod ]
{
	s ret=##class(web.DHCLCNUREXCUTE).SaveAuditFlag(oeoriIdStr,userId,AuditFlag,"","")
	w ret
	q 0
}

ClassMethod GetPdaHead() As %String [ WebMethod ]
{
	s ret=##class(web.DHCNURPDAQUEXCUTE).Get90PdaHead()
	w ret
	q 0
}

ClassMethod GetlabOritem(LabEpisode As %String, Adm As %String, messageFlag As %String = "0") As %String [ WebMethod ]
{
	//s messageFlag=0
	s ret=##class(web.DHCPdaNurComm).GetlabOritem1(LabEpisode,Adm,messageFlag)
	w ret
	q 0
}

ClassMethod GetQueryData(QueryName, Loc) As %String [ WebMethod ]
{
	;w ##Class(DHCNurse.PdaClsInterface1).GetQueryData("web.DHCNurCom:FindPatMeasure","135")
	s ward=""
    s ward=$O(^PAWARD(0,"WARD_LocationDR",Loc,ward))
    s ^liulei=QueryName_"^"_ward_"^"_Loc
    s ret=##class(web.DHCNURPDAQUEXCUTE).GetQueryData(QueryName,ward)
 	w ret
 	q 0
}

}
