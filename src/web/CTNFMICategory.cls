Class web.CTNFMICategory Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 72;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
/// val - NFMI_Desc or NFMI_Code
/// TP 30/11/2001: created broker for lookup on partial description
ClassMethod LookUpBrokerPartialDesc(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

Parameter SQLCODE = "NFMI_Code";

Parameter SQLDESCRIPTION = "NFMI_Desc";

Parameter SQLROWID = "NFMI_RowId";

/// Basic query returning description from a partial description, ordered by description.
/// 

Query LookUpPartialDesc(desc As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT NFMI_Desc, NFMI_RowId, NFMI_Code
FROM SQLUser.CT_NFMI_Category
WHERE (%ALPHAUP NFMI_Desc [%ALPHAUP :desc)
ORDER BY NFMI_Desc
}

}
