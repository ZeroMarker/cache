/// Log 40498 - AI - 19-11-2003 : Class created.
Class web.SSHL7OrdNumbers Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 39;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "HL7ON_RowId";

Parameter SQLDESCRIPTION = "HL7ON_RowId";

Parameter SQLROWID = "HL7ON_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod getOrdNumbers(code As %String = "") As %Library.String
{
}

ClassMethod LookUpForSegListBoxClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpForSegListBoxFetch ]
{
}

ClassMethod LookUpForSegListBoxExecute(ByRef QHandle As %Library.Binary, ParRef As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpForSegListBoxFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpForSegListBoxExecute ]
{
}

ClassMethod websysSave(compref As %String, HL7ONParRef As %String, UpdateDetails As %String = "")
{
}

Query LookUpForSegListBox(ParRef) As %Library.Query(CONTAINID = 0, ROWSPEC = "segtype,segdesc")
{
}

}
