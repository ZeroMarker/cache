Class web.PAPrDelLabDelCompl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 49;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpLabDelComplClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpLabDelComplFetch ]
{
}

ClassMethod LookUpLabDelComplExecute(ByRef QHandle As %Library.Binary, DelId As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

ClassMethod LookUpLabDelComplFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpLabDelComplExecute ]
{
}

ClassMethod websysSaveAll(DelId As %Library.String, LabDelCompls As %Library.String)
{
}

Parameter SQLCODE = "PDLDC_RowId";

Parameter SQLDESCRIPTION = "PDLDC_RowId";

Parameter SQLROWID = "PDLDC_RowId";

Query Find(DelId As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,LDCOMPL_Desc,PDLDC_Complication_DR")
{
SELECT 
PDLDC_RowId, 
PDLDC_Complication_DR->LDCOMPL_Desc, 
PDLDC_Complication_DR 
FROM SQLUser.PA_PrDelLabDelCompl 
WHERE PDLDC_ParRef = :DelId
}

Query LookUpLabDelCompl(DelId As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "values:%String,desc:%String")
{
SELECT 
FROM PAPrDelLabDelCompl
}

}
