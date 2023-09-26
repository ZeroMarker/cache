Class web.PAPrDelIndMethods Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 32;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "PDIM_RowId";

Parameter SQLDESCRIPTION = "PDIM_RowId";

Parameter SQLROWID = "PDIM_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpIndMethodsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpIndMethodsFetch ]
{
}

ClassMethod LookUpIndMethodsExecute(ByRef QHandle As %Library.Binary, DelId As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

ClassMethod LookUpIndMethodsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpIndMethodsExecute ]
{
}

ClassMethod websysSaveAll(DelId As %Library.String, IndMths As %Library.String)
{
}

Query Find(DelId As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,INDMTH_Desc,PDIM_IndMth_DR")
{
SELECT 
PDIM_RowId, 
PDIM_IndMth_DR->IndMth_Desc, 
PDIM_IndMth_DR 
FROM SQLUser.PA_PrDelIndMethods 
WHERE PDIM_ParRef = :DelId
}

Query LookUpIndMethods(DelId As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "values:%String,desc:%String")
{
}

}
