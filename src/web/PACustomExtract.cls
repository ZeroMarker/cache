Class web.PACustomExtract Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 90;

Property dummy As %Library.String(TRUNCATE = 1);

/// Default implementation of LookUp Query.
ClassMethod Find2Close(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = Find2Fetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod Find2Execute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String, TSRTORD As %Library.String, ExtractType1 As %Library.String) As %Library.Status
{
}

/// Default implementation of LookUp Query.
ClassMethod Find2Fetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = Find2Execute ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindExecute(ByRef QHandle As %Library.Binary, ExtractType1 As %Library.String, DateFrom1 As %Library.Date, DateTo1 As %Library.Date) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindExecute ]
{
}

ClassMethod websysDeleteExtract(id As %Library.String)
{
}

ClassMethod websysSaveExtract(compref As %String, id As %String)
{
}

Parameter SQLCODE = "EX_RowId";

Parameter SQLDATEFROM = "EX_DateFrom";

Parameter SQLDATETO = "EX_DateTo";

Parameter SQLDESCRIPTION = "EX_RowId";

Parameter SQLROWID = "EX_RowId";

Query Find(ExtractType1 As %Library.String, DateFrom1 As %Library.Date, DateTo1 As %Library.Date) As %Library.Query(CONTAINID = 0, ROWSPEC = "ExtractType,DateFrom,DateTo,DateRun,ExtractNumber,Status,RowId,UserName")
{
}

Query Find1(ExtractType As %Library.String, DateFrom As %Library.String, DateTo As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ExtractType,DateFrom,DateTo,DateRun,ExtractNumber,Status,RowId")
{
SELECT EX_CustomExtract_DR->CUSTEXT_Desc, EX_DateFrom, EX_DateTo, EX_DateRun, EX_Number, EX_Status, EX_RowId
FROM SQLUser.PA_CustomExtract
WHERE ((%ALPHAUP EX_CustomExtract_DR->CUSTEXT_Desc %STARTSWITH %ALPHAUP 'IP') OR (%ALPHAUP EX_CustomExtract_DR->CUSTEXT_Code %STARTSWITH %ALPHAUP 'IP'))
}

Query Find2(TSRTITM As %Library.String, TSRTORD As %Library.String, ExtractType1 As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ExtractType,DateFrom,DateTo,DateRun,ExtractNumber,Status,RowId")
{
}

}
