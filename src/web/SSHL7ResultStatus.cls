Class web.SSHL7ResultStatus Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 18;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

Parameter SQLCODE = "HL7RS_RowId";

Parameter SQLDESCRIPTION = "HL7RS_RowId";

Parameter SQLROWID = "HL7RS_RowId";

ClassMethod getResultStatus(code As %String = "") As %Library.String
{
}

ClassMethod websysSave(compref As %String, code As %String, UpdateDetails As %String = "")
{
}

ClassMethod LookUpForExtSysListBoxClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpForExtSysListBoxFetch ]
{
}

ClassMethod LookUpForExtSysListBoxExecute(ByRef QHandle As %Library.Binary, ParRef As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpForExtSysListBoxFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpForExtSysListBoxExecute ]
{
}

Query LookUpForExtSysListBox(ParRef) As %Library.Query(CONTAINID = 0, ROWSPEC = "extsys,extsysdesc")
{
}

}
