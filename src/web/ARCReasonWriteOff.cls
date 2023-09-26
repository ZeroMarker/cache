Class web.ARCReasonWriteOff Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 83;

Parameter SQLDATEFROM = "RW_DateFrom";

Parameter SQLDATETO = "RW_DateTo";

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "RW_Code";

Parameter SQLDESCRIPTION = "RW_Desc";

Parameter SQLROWID = "RW_RowId";

ClassMethod LookUpReasonBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", writeOffDate As %Library.Date = "") As %Library.Boolean
{
}

ClassMethod LookUpReasonClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = LookUpReasonExecute ]
{
}

ClassMethod LookUpReasonExecute(ByRef QHandle As %Binary, val As %String, writeOffDate As %Date) As %Status
{
}

ClassMethod LookUpReasonFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpReasonExecute ]
{
}

Query LookUpReason(val As %String, writeOffDate As %Date) As %Query(ROWSPEC = "desc:%String,code:%String")
{
}

}
