Class web.PAPrDelPuerpCompl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 34;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpPuerpClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpPuerpFetch ]
{
}

ClassMethod LookUpPuerpExecute(ByRef QHandle As %Library.Binary, DelId As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

ClassMethod LookUpPuerpFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpPuerpExecute ]
{
}

ClassMethod websysSaveAll(DelId As %Library.String, PuerpCompls As %Library.String)
{
}

Parameter SQLCODE = "PDPC_RowId";

Parameter SQLDESCRIPTION = "PDPC_RowId";

Parameter SQLROWID = "PDPC_RowId";

Query Find(DelId As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,PUER_Desc,PDPC_Complication_DR")
{
SELECT 
PDPC_RowId, 
PDPC_Complication_DR->PUER_Desc, 
PDPC_Complication_DR 
FROM SQLUser.PA_PrDelPuerpCompl 
WHERE PDPC_ParRef = :DelId
}

Query LookUpPuerp(DelId As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "values:%String,desc:%String")
{
SELECT 
FROM PAPrDelPuerpCompl
}

}
