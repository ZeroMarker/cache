Class web.PACustomExtractReport Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 119;

Property dummy As %Library.String(TRUNCATE = 1);

/// Default implementation of LookUp Query.
ClassMethod Find2Close(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = Find2Fetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod Find2Execute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String, TSRTORD As %Library.String, ParRef As %Library.String) As %Library.Status
{
}

/// Default implementation of LookUp Query.
ClassMethod Find2Fetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = Find2Execute ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpSpcClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpSpcFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpSpcExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String, TSRTORD As %Library.String, id As %Library.String) As %Library.Status
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpSpcFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpSpcExecute ]
{
}

ClassMethod Print(id As %Library.String)
{
}

ClassMethod websysDeleteExtractReport(id As %Library.String)
{
}

ClassMethod websysSaveExtractReport(compref As %String, id As %String)
{
}

Parameter SQLCODE = "REP_RowId";

Parameter SQLDATEFROM = "REP_DateFrom";

Parameter SQLDATETO = "REP_DateTo";

Parameter SQLDESCRIPTION = "REP_RowId";

Parameter SQLROWID = "REP_RowId";

Query Find2(TSRTITM As %Library.String, TSRTORD As %Library.String, ParRef As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ReportCode,DateFrom,DateTo,DateRun,Hospital,Purchaser,Provider,RowId,SpecialtyString,SpecialtyExclude")
{
}

Query LookUpByExtract(ParRef As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ReportCode,DateFrom,DateTo,DateRun,Hospital,Purchaser,Provider,RowId")
{
SELECT REP_CustomExtractRep_DR->REP_Code, REP_DateFrom, REP_DateTo, REP_DateRun, REP_Hospital_DR->HOSP_Desc, REP_HCA_DR->HCA_Desc, REP_Trust_DR->TRUST_Desc, REP_RowId
FROM SQLUser.PA_CustomExtractReport
WHERE REP_ParRef=:ParRef
}

Query LookUpSpc(TSRTITM As %Library.String, TSRTORD As %Library.String, id As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "spc:%String,desc:%String")
{
}

}
