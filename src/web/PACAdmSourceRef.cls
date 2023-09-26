Include webimport

IncludeGenerator webimport

Class web.PACAdmSourceRef Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 92;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "ADSRF_Code";

Parameter SQLDESCRIPTION = "ADSRF_Desc";

Parameter SQLROWID = "ADSRF_RowId";

}
