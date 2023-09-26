Class web.CTCurrency Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 42;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "CTCUR_Code";

Parameter SQLDESCRIPTION = "CTCUR_Desc";

Parameter SQLROWID = "CTCUR_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpCurrencyBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", PayAmt As %String = "") As %Library.Boolean
{
}

ClassMethod LookUpCurrencyExecute(ByRef QHandle As %Library.Binary, val As %String, PAYMAmt As %Library.String) As %Library.Status
{
}

ClassMethod LookUpCurrencyFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpCurrencyExecute ]
{
}

ClassMethod LookUpCurrencyClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpCurrencyFetch ]
{
}

Query LookUpCurrency(val As %String, PAYMAmt As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "CTCUR_Desc:%Library.String,CTCUR_Code:%Library.String,hidden,hidden")
{
}

Query CurLookUp(val As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Description:%String,Code:%String,HIDDEN:%String")
{
	SELECT CTCUR_Desc,CTCUR_Code,CTCUR_RowId
 	INTO :Desc,:Code,:CurID
 	FROM SQLUser.CT_Currency
	WHERE ((%UPPER CTCUR_Desc %STARTSWITH %UPPER :val) OR (%UPPER CTCUR_Code %STARTSWITH %UPPER :val))
}

ClassMethod PayAmtChange(val As %String, PAYMAmt As %String) As %Library.Status
{
}

Storage Default
{
<Data name="CTCurrencyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>dummy</Value>
</Value>
</Data>
<DataLocation>^web.CTCurrencyD</DataLocation>
<DefaultData>CTCurrencyDefaultData</DefaultData>
<IdLocation>^web.CTCurrencyD</IdLocation>
<IndexLocation>^web.CTCurrencyI</IndexLocation>
<StreamLocation>^web.CTCurrencyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
