Class web.SSHL7MasterFile Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 26;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "HL7MFD_RowId";

Parameter SQLDESCRIPTION = "HL7MFD_RowId";

Parameter SQLROWID = "HL7MFD_RowId";

ClassMethod getMasterFile(code As %String = "") As %Library.String
{
}

ClassMethod websysSave(compref As %String, code As %String, UpdateDetails As %String = "")
{
}

ClassMethod LookUpForMsgTypeListBoxClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpForMsgTypeListBoxFetch ]
{
}

ClassMethod LookUpForMsgTypeListBoxExecute(ByRef QHandle As %Library.Binary, ParRef As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpForMsgTypeListBoxFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpForMsgTypeListBoxExecute ]
{
}

Query LookUpForMsgTypeListBox(ParRef) As %Library.Query(CONTAINID = 0, ROWSPEC = "extsys,extsysdesc")
{
}

}
