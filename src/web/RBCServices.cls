Include webimport

IncludeGenerator webimport

Class web.RBCServices Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 272;

Property dummy As %String(TRUNCATE = 1);

/// log 62743 TedT check if service is new way
ClassMethod IsNewWay(serviceId As %String) As %Boolean
{
}

/// log59618 TedT Get service id from arcim id or order set id
ClassMethod GetIdFromArcimId(arcim As %String = "") As %String
{
}

/// LOG 28361:  We are using "Default Service" from SSUser as the default service inRBAppointment.FindResDaySched
/// however, this may not match the selected resource.  This function makes sure that the correct service is selected or 
/// no service is set.  The correct service is the one that has the same SER_ARCM_DR as the one defined in SSUser
/// but the correct SER_CTCP_DR
ClassMethod GetUserDefaultServ(ResourceID As %Library.String = "", UserID As %Library.String = "") As %Library.String
{
}

ClassMethod ServicesForServSet(SSServId As %Library.String = "") As %Library.String
{
}

Parameter SQLCODE = "SER_RowId";

Parameter SQLDATEFROM = "SER_DateFrom";

Parameter SQLDATETO = "SER_DateTo";

Parameter SQLDESCRIPTION = "SER_Desc";

Parameter SQLROWID = "SER_RowId";

Query LookUpByDoctor(serv As %String, doc As %String) As %SQLQuery(CONTAINID = 0, ROWSPEC = "SERDesc:%String,CTPCPDesc:%String")
{
SELECT SER_Desc, SER_CTCP_DR->CTPCP_Desc
FROM RBC_Services
WHERE (SER_Desc %STARTSWITH :serv) AND (SER_CTCP_DR->CTPCP_Desc = :doc)
ORDER BY SER_Desc
}

ClassMethod GetSlotServices1(SchedID) As %Library.String
{
}

ClassMethod GetSlotServices(SchedID) As %Library.String
{
}

Query LookUpByE(desc As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Desc:%String,HIDDEN:%String")
{
	SELECT DISTINCT BY (SER_Desc) SER_Desc,SER_RowId
FROM RBC_Services
WHERE (SER_Desc %STARTSWITH :desc) 
ORDER BY SER_Desc
}

}
