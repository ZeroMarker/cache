Class DHCCPM.WebTest Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

Parameter NewParameter1 As STRING [ Flags = LIST ] = 123456789;

Parameter SERVICENAME = "WebTest";

Query ReadCTLoc() As %SQLQuery(CONTAINID = 1) [ WebMethod ]
{
	select * from SQLUser.CT_Loc
}

}
