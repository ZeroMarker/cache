Class web.RBCEventSubType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 27;

Parameter SQLCODE = "SUB_Code";

Parameter SQLDATEFROM = "SUB_DateFrom";

Parameter SQLDATETO = "SUB_DateTo";

Parameter SQLDESCRIPTION = "SUB_Desc";

Parameter SQLROWID = "SUB_RowId";

Query LookUpByEventType(val As %String, EventTypeDesc As %String) As %SQLQuery(CONTAINID = 0, ROWSPEC = "Desc:%String,Code:%String")
{
SELECT  SUB_Desc, SUB_Code
FROM SQLUser.RBC_EventSubType
WHERE ((%ALPHAUP SUB_Code = %ALPHAUP :val) OR (%ALPHAUP SUB_Desc %STARTSWITH %ALPHAUP :val)) 
 AND (SUB_ParRef->EVT_Desc %STARTSWITH :EventTypeDesc)
 AND ((SUB_DateFrom IS NULL OR SUB_DateFrom <= CURRENT_DATE) AND (SUB_DateTo IS NULL OR SUB_DateTo >= CURRENT_DATE))
}

ClassMethod LookUpByEventTypeBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", EventTypeDesc As %Library.String = "") As %Library.Boolean
{
}

/// Find the object id given either a code or a description.<br>
/// Log 59566 - 22.06.2006: Had to override because the generic doesn't work for this
ClassMethod GetIdFromCodeOrDescription(val As %Library.String) As %Library.String
{
}

}
