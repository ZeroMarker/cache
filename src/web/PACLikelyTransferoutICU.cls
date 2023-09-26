Class web.PACLikelyTransferoutICU Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 50;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

ClassMethod GetImage(ID As %Library.String, PARAMS As %Library.String, ByRef ARY As %Library.String)
{
}

ClassMethod GetImageOnly(ID As %Library.String, PARAMS As %Library.String, ByRef ARY As %Library.String)
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpActiveBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

Parameter SQLCODE = "LTICU_Code";

Parameter SQLDESCRIPTION = "LTICU_Desc";

Parameter SQLROWID = "LTICU_RowId";

}
