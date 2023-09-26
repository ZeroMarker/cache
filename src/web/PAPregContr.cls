Class web.PAPregContr Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 8;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "CONTR_RowId";

Parameter SQLDESCRIPTION = "CONTR_RowId";

Parameter SQLROWID = "CONTR_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod LookUpContrClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpContrFetch ]
{
}

ClassMethod LookUpContrExecute(ByRef QHandle As %Library.Binary, PregId As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

ClassMethod LookUpContrFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpContrExecute ]
{
}

ClassMethod websysSaveAll(PregId As %Library.String, Items As %Library.String)
{
}

Query Find(PregId As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,CONMET_Desc,CONTR_ContraceptMethod_DR")
{
SELECT 
CONTR_RowId, 
CONTR_ContraceptMethod_DR->CONMET_Desc,
CONTR_ContraceptMethod_DR
FROM SQLUser.PA_PregContr
WHERE CONTR_ParRef = :PregId
}

Query LookUpContr(PregId As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "values:%String,desc:%String")
{
}

}
