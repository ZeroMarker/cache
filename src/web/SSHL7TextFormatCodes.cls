/// Log 45778 - AI - 27-08-2004 : Class created.
Class web.SSHL7TextFormatCodes Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 38;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "HL7TF_RowId";

Parameter SQLDESCRIPTION = "HL7TF_RowId";

Parameter SQLROWID = "HL7TF_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod getTextFormatCodes(code As %String = "") As %Library.String
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

ClassMethod websysSave(compref As %String, HL7TFParRef As %String, UpdateDetails As %String = "")
{
}

Query LookUpForExtSysListBox(ParRef) As %Library.Query(CONTAINID = 0, ROWSPEC = "extsys,extsysdesc")
{
}

}
