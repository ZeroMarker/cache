Include webimport

IncludeGenerator webimport

Class web.PACPatientClassification Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 46;

Parameter SQLDATEFROM = "PCLASS_DateFrom";

Parameter SQLDATETO = "PCLASS_DateTo";

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "PCLASS_Code";

Parameter SQLDESCRIPTION = "PCLASS_Desc";

Parameter SQLROWID = "PCLASS_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

}
