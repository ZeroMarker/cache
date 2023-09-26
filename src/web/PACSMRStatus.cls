Class web.PACSMRStatus Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 45;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property Dummy As %Library.String(TRUNCATE = 1);

Method GetDescFromRowId(rowid As %Library.String) As %Library.String
{
}

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "SMRSTAT_Code";

Parameter SQLDESCRIPTION = "SMRSTAT_Desc";

Parameter SQLROWID = "SMRSTAT_RowId";

}
