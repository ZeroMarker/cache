Class web.PACAdmTypeLocation Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 93;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

ClassMethod ValidateDeptIsActive(row As %String, admtype As %String) As %Boolean
{
}

Parameter SQLCODE = "ADMLOC_RowId";

Parameter SQLDESCRIPTION = "ADMLOC_RowId";

Parameter SQLROWID = "ADMLOC_RowId";

}
