Include webimport

IncludeGenerator webimport

Class web.PACPatientType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 8;

Parameter SQLCODE = "PTYPE_Code";

Parameter SQLDATEFROM = "PTYPE_DateFrom";

Parameter SQLDATETO = "PTYPE_DateTo";

Parameter SQLDESCRIPTION = "PTYPE_Desc";

Parameter SQLROWID = "PTYPE_RowId";

/// Default implementation of LookUp Query.
ClassMethod LookUpRestrictClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpRestrictFetch ]
{
}

ClassMethod LookUpRestrictExecute(ByRef QHandle As %Library.Binary, desc As %Library.String) As %Library.Status
{
}

ClassMethod LookUpRestrictFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpRestrictExecute ]
{
}

ClassMethod LookUpBrokerRestrict(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
}

Query LookUpRestrict(desc As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Desc:%String,HIDDEN:%String,Code:%String")
{
}

}
