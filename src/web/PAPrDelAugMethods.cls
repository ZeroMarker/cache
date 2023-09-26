Class web.PAPrDelAugMethods Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 39;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "PDAM_RowId";

Parameter SQLDESCRIPTION = "PDAM_RowId";

Parameter SQLROWID = "PDAM_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpAugMethodsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpAugMethodsFetch ]
{
}

ClassMethod LookUpAugMethodsExecute(ByRef QHandle As %Library.Binary, DelId As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

ClassMethod LookUpAugMethodsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpAugMethodsExecute ]
{
}

ClassMethod websysSaveAll(DelId As %Library.String, AugMths As %Library.String)
{
}

Query Find(DelId As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,AUGMTH_Desc,PDAM_AugMth_DR")
{
SELECT 
PDAM_RowId, 
PDAM_AugMth_DR->AUGMTH_Desc, 
PDAM_AugMth_DR 
FROM SQLUser.PA_PrDelAugMethods
WHERE PDAM_ParRef = :DelId
}

Query LookUpAugMethods(DelId As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "values:%String,desc:%String")
{
}

}
