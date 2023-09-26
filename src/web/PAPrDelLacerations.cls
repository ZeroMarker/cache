Class web.PAPrDelLacerations Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 35;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpTearLocClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpTearLocFetch ]
{
}

ClassMethod LookUpTearLocExecute(ByRef QHandle As %Library.Binary, DelId As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

ClassMethod LookUpTearLocFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpTearLocExecute ]
{
}

ClassMethod websysSaveAll(DelId As %Library.String, TearLocs As %Library.String)
{
}

Parameter SQLCODE = "PDLACER_RowId";

Parameter SQLDESCRIPTION = "PDLACER_RowId";

Parameter SQLROWID = "PDLACER_RowId";

Query Find(DelId As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,LOCLAC_Desc,PDLACER_Loc_DR")
{
SELECT 
PDLACER_RowId, 
PDLACER_Loc_DR->LOCLAC_Desc, 
PDLACER_Loc_DR 
FROM SQLUser.PA_PrDelLacerations 
WHERE PDLACER_ParRef = :DelId
}

Query LookUpTearLoc(DelId As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "values:%String,desc:%String")
{
SELECT 
FROM PAPrDelLacerations
}

}
