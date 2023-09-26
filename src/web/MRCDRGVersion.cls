Class web.MRCDRGVersion Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 27;

ClassMethod GetCurrentVersion() As %Library.String
{
}

ClassMethod LookUpVersionBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", currday As %Library.Date = "") As %Library.Boolean
{
}

ClassMethod LookUpVersionClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpVersionFetch ]
{
}

ClassMethod LookUpVersionExecute(ByRef QHandle As %Library.Binary, val As %Library.String = "", currday As %Library.Date = "") As %Library.Status
{
}

ClassMethod LookUpVersionFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpVersionExecute ]
{
}

Parameter SQLCODE = "DRGVER_Code";

Parameter SQLDATEFROM = "DRGVER_DateFrom";

Parameter SQLDATETO = "DRGVER_DateTo";

Parameter SQLDESCRIPTION = "DRGVER_Desc";

Parameter SQLROWID = "DRGVER_RowId";

Query LookUpVersion(val As %String, currday As %Date) As %Library.Query(CONTAINID = 0, ROWSPEC = "desc:%String,hidden,code:%String,hidden,hidden")
{
}

}
