Class web.PACExemptionReason Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 45;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "EXR_Code";

Parameter SQLDESCRIPTION = "EXR_Desc";

Parameter SQLROWID = "EXR_RowId";

ClassMethod LookUpReasonBroker(itmjs As %String = "", itmjsex As %String = "", val As %String = "") As %Library.Boolean
{
}

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query LookUp(desc As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Description:%String,Code:%String,Prefix:%String,HIDDEN:%String")
{
Select EXR_Desc, EXR_Code, EXR_Prefix, EXR_RowId
from SQLUser.PAC_ExemptionReason
WHERE (%ALPHAUP EXR_Desc %STARTSWITH %ALPHAUP :desc)
ORDER BY EXR_Desc
}

Query LookUpReason(desc As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Description:%String,Code:%String,Prefix:%String,HIDDEN:%String")
{
Select EXR_Desc, EXR_Code, EXR_Prefix, EXR_RowId
from SQLUser.PAC_ExemptionReason
WHERE (%ALPHAUP EXR_Desc %STARTSWITH %ALPHAUP :desc)
ORDER BY EXR_Desc
}

}
