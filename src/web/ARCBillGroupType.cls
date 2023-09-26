Class web.ARCBillGroupType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 37;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "BILLGT_Code";

Parameter SQLDESCRIPTION = "BILLGT_Desc";

Parameter SQLROWID = "BILLGT_RowId";

ClassMethod BILLGTLookupBroker(itmjs As %String = "", itmjsex As %String = "", val As %String = "", BILLGTType As %Library.String = "")
{
}

ClassMethod BILLGTLookupClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = BILLGTLookupFetch ]
{
}

ClassMethod BILLGTLookupExecute(ByRef QHandle As %Library.Binary, val As %String = "", BILLGTType As %Library.String = "") As %Library.Status
{
}

ClassMethod BILLGTLookupFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = BILLGTLookupExecute ]
{
}

Query BILLGTLookup(val As %String, BILLGTType As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "BILLGTDesc:%Library.String,HIDDEN:%Library.String,BILLGTCode:%Library.String")
{
}

}
