Class web.PACWaitingListGroups Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 56;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property Dummy As %Library.String(TRUNCATE = 1);

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "WLG_Code";

Parameter SQLDESCRIPTION = "WLG_Desc";

Parameter SQLROWID = "WLG_RowId";

}
