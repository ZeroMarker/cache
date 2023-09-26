Include webimport

IncludeGenerator webimport

/// Aji 29/8/03 - Log Number: 36539
Class web.BLCAccountingPeriod Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 242;

Parameter SQLDATEFROM = "PER_DateFrom";

Parameter SQLDATETO = "PER_DateTo";

Parameter SQLCODE = "PER_Code";

Parameter SQLDESCRIPTION = "PER_Desc";

Parameter SQLROWID = "PER_RowId";

ClassMethod GetAcctPeriod(date As %String)
{
}

ClassMethod IsAcctPeriodClosed(PeriodID As %Library.String) As %Boolean
{
}

ClassMethod IsAcctPeriodOpen(PeriodID As %Library.String) As %Boolean
{
}

ClassMethod CloseAccPeriod(PeriodID2Close As %Library.String, compref As %Library.String)
{
}

ClassMethod FindAccPeriodExecute(ByRef QHandle As %Binary, AcctPeriod As %String = "", SelectedStatus As %String = "", DateFrom As %Date = "", DateTo As %Date = "") As %Status
{
}

ClassMethod FindAccPeriodFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAccPeriodExecute ]
{
}

ClassMethod FindAccPeriodClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindAccPeriodExecute ]
{
}

ClassMethod LookUpBrokerAccPeriod(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookupAccPeriodExecute(ByRef QHandle As %Binary, val As %String) As %Status
{
}

ClassMethod LookupAccPeriodFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookupAccPeriodExecute ]
{
}

ClassMethod LookupAccPeriodClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = LookupAccPeriodExecute ]
{
}

Query LookupAccPeriod(val As %String) As %Query(ROWSPEC = "Code:%String,Description:%String,HIDDEN:%String,HIDDEN:%String")
{
}

Query FindAccPeriod(AcctPeriod As %String, SelectedStatus As %String, DateFrom As %Date, DateTo As %Date) As %Query(ROWSPEC = "ID:%String,Code:%String,Description:%String,DateFrom:%Date,DateTo:%Date,Status:%String")
{
}

}
