Class web.PAPregMenst Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 7;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "MHP_RowId";

Parameter SQLDESCRIPTION = "MHP_RowId";

Parameter SQLROWID = "MHP_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod LookUpMenstClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpMenstFetch ]
{
}

ClassMethod LookUpMenstExecute(ByRef QHandle As %Library.Binary, PregId As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

ClassMethod LookUpMenstFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpMenstExecute ]
{
}

ClassMethod websysSaveAll(PregId As %Library.String, Items As %Library.String)
{
}

Query Find(PregId As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,MENHP_Desc,MHP_MenstHistProb_DR")
{
SELECT 
MHP_RowId, 
MHP_MenstHistProb_DR->MENHP_Desc,
MHP_MenstHistProb_DR
FROM SQLUser.PA_PregMenst
WHERE MHP_ParRef = :PregId
}

Query LookUpMenst(PregId As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "values:%String,desc:%String")
{
}

}
