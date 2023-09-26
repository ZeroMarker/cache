Class web.PAAdmReasonDelayDisch Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 52;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod websysInsert(id As %Library.String, desc As %Library.String)
{
}

Parameter SQLCODE = "READEL_RowId";

Parameter SQLDESCRIPTION = "READEL_RowId";

Parameter SQLROWID = "READEL_RowId";

}
