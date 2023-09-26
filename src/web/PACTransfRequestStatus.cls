Class web.PACTransfRequestStatus Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 55;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "REQST_Code";

Parameter SQLDESCRIPTION = "REQST_Desc";

Parameter SQLROWID = "REQST_RowId";

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBrokerRestricted(itmjs As %Library.String = "", itmjsex As %Library.String = "", Status As %Library.String = "", Restriction As %Library.String = "") As %Library.Boolean
{
}

Query LookUpRestricted(Status, Restriction) As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "Description,Code,HIDDEN")
{
SELECT REQST_Desc,REQST_Code,REQST_Rowid
FROM SQLUser.PAC_TransfRequestStatus
WHERE (:Restriction[(REQST_Code))
AND (REQST_Desc %STARTSWITH :Status)
}

}
