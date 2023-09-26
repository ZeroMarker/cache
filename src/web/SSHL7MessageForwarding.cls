Class web.SSHL7MessageForwarding Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 49;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "HL7MF_RowId";

Parameter SQLDESCRIPTION = "HL7MF_RowId";

Parameter SQLROWID = "HL7MF_RowId";

Property dummy As %String(TRUNCATE = 1);

/// Log 37038 - AI - 07-07-2003 : Created method to return all Message Forwarding records in the one string.
ClassMethod getMessageForwarding(parref As %Library.String = "") As %Library.String
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

ClassMethod websysSave(compref As %String, parref As %String, strArray As %Library.String = "")
{
}

Query LookUpForListBox(ParRef) As %Library.Query(ROWSPEC = "type:%Library.String,typedesc:%Library.String")
{
}

}
