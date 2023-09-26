Class web.PACAlertExpiryReason Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 34;

Parameter SQLDATEFROM = "ALEXP_DateFrom";

Parameter SQLDATETO = "ALEXP_DateTo";

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "ALEXP_Code";

Parameter SQLDESCRIPTION = "ALEXP_Desc";

Parameter SQLROWID = "ALEXP_RowId";

Parameter SQLFILTER = "((ALEXP_DateFrom <= CURRENT_DATE OR ALEXP_DateFrom IS NULL) AND (ALEXP_DateTo >= CURRENT_DATE OR ALEXP_DateTo IS NULL))";

Property Dummy As %Library.String(TRUNCATE = 1);

}
