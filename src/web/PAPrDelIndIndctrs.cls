Class web.PAPrDelIndIndctrs Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 37;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpIndIndctrsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpIndIndctrsFetch ]
{
}

ClassMethod LookUpIndIndctrsExecute(ByRef QHandle As %Library.Binary, DelId As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

ClassMethod LookUpIndIndctrsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpIndIndctrsExecute ]
{
}

ClassMethod websysSaveAll(DelId As %Library.String, IndIndctrs As %Library.String)
{
}

Parameter SQLCODE = "PDII_RowId";

Parameter SQLDESCRIPTION = "PDII_RowId";

Parameter SQLROWID = "PDII_RowId";

Query Find(DelId As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,INDINDCTR_Desc,PDII_IndIndctr_DR")
{
SELECT 
PDII_RowId, 
PDII_IndIndctr_DR->INDINDCTR_Desc, 
PDII_IndIndctr_DR 
FROM SQLUser.PA_PrDelIndIndctrs 
WHERE PDII_ParRef = :DelId
}

Query LookUpIndIndctrs(DelId As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "values:%String,desc:%String")
{
SELECT 
FROM PAPrDelIndIndctrs
}

}
