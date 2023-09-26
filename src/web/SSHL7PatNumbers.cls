Class web.SSHL7PatNumbers Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 93;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "HL7PN_RowId";

Parameter SQLDESCRIPTION = "HL7PN_RowId";

Parameter SQLROWID = "HL7PN_RowId";

Property dummy As %String(TRUNCATE = 1);

/// Log 36472 - AI - 18-06-2003 : Copied from SSHL7Segments, getSegments method.
ClassMethod getPatNumbers(code As %String = "") As %Library.String
{
}

ClassMethod LookUpForListBoxClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpForListBoxFetch ]
{
}

ClassMethod LookUpForListBoxExecute(ByRef QHandle As %Library.Binary, ParRef As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpForListBoxFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpForListBoxExecute ]
{
}

ClassMethod websysSave(compref As %String, HL7PNParRef As %String, UpdateDetails As %String = "")
{
}

Query LookUpForListBox(ParRef) As %Library.Query(CONTAINID = 0, ROWSPEC = "type,typedesc")
{
}

}
