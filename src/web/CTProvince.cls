Include webimport

IncludeGenerator webimport

Class web.CTProvince Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 48;

Parameter SQLDATEFROM = "PROV_DateFrom";

Parameter SQLDATETO = "PROV_DateTo";

Parameter SQLCODE = "PROV_Code";

Parameter SQLDESCRIPTION = "PROV_Desc";

Parameter SQLROWID = "PROV_RowId";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((PROV_DateFrom <= CURRENT_DATE OR PROV_DateFrom IS NULL) AND (PROV_DateTo >= CURRENT_DATE OR PROV_DateTo IS NULL))";

Property dummy As %String(TRUNCATE = 1);

ClassMethod LookUpBrokerWithDate(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", date As %String = "", city As %String = "", zip As %String = "") As %Boolean
{
}

Query LookUpWithDate(desc As %String = "", date As %String = "", city As %String = "", zip As %String = "") As %Query(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
}

ClassMethod LookUpWithDateExecute(ByRef QHandle As %Library.Binary, desc As %String = "", date As %String = "", city As %String = "", zip As %String = "") As %Library.Status
{
}

ClassMethod LookUpWithDateFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpWithDateExecute ]
{
}

ClassMethod LookUpWithDateClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpWithDateFetch ]
{
}

}
