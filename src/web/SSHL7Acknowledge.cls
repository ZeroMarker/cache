Class web.SSHL7Acknowledge Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 43;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "HL7ACK_RowId";

Parameter SQLDESCRIPTION = "HL7ACK_RowId";

Parameter SQLROWID = "HL7ACK_RowId";

ClassMethod getAcknowledgements(code As %Library.String = "") As %Library.String
{
}

ClassMethod LookUpForListBoxClose(ByRef QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpForListBoxExecute ]
{
}

ClassMethod LookUpForListBoxExecute(ByRef QHandle As %Library.Binary, ParRef As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpForListBoxFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpForListBoxExecute ]
{
}

ClassMethod websysSave(compref As %String, code As %String, strArray As %Library.String = "")
{
}

Query LookUpForListBox(ParRef) As %Library.Query(ROWSPEC = "seg:%Library.String,segdesc:%Library.String")
{
}

}
