/// DHCNurse.PdaClsInterface1
Class DHCNurse.PdaClsInterface1 Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
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
	q ret
}

ClassMethod GetQueryData(QueryName, Loc) As %String [ WebMethod ]
{
	;w ##Class(DHCNurse.PdaClsInterface1).GetQueryData("web.DHCNurCom:FindPatMeasure","135")
	s ward=""
    s ward=$O(^PAWARD(0,"WARD_LocationDR",Loc,ward))
    s ^liulei=QueryName_"^"_ward_"^"_Loc
    s ret=##class(web.DHCNURPDAQUEXCUTE).GetQueryData(QueryName,ward)
 	q ret
}

}
