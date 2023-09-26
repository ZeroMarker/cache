Class web.SSHL7OutboundTables Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 27;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "HL7OUT_RowId";

Parameter SQLDESCRIPTION = "HL7OUT_RowId";

Parameter SQLROWID = "HL7OUT_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod getOutboundTables(code As %String = "") As %Library.String
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

ClassMethod websysSave(compref As %String, HL7OUTParRef As %String, UpdateDetails As %String = "")
{
}

Query LookUpForListBox(ParRef) As %Library.Query(CONTAINID = 0, ROWSPEC = "type,typedesc")
{
}

}
