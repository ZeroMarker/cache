Class web.PACDocumentType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 54;

Parameter SQLDATEFROM = "DOCTYPE_DateFrom";

Parameter SQLDATETO = "DOCTYPE_DateTo";

Parameter SQLCODE = "DOCTYPE_RowId";

Parameter SQLDESCRIPTION = "DOCTYPE_Desc";

Parameter SQLROWID = "DOCTYPE_RowId";

ClassMethod LookUpBrokerPACDocType(itmjs As %Library.String = "", itmjsex As %Library.String = "", desc As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpPACDocTypeExecute(ByRef qHandle As %Binary, desc As %Library.String = "", frombroker As %Library.Boolean = 0) As %Status
{
}

ClassMethod LookUpPACDocTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpPACDocTypeExecute ]
{
}

ClassMethod LookUpPACDocTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpPACDocTypeFetch ]
{
}

Query LookUpPACDocType(desc As %Library.String, frombroker As %Library.Boolean = 0) As %Query(ROWSPEC = "Description")
{
}

ClassMethod GetDefault() As %Library.String
{
}

}
