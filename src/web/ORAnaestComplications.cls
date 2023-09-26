Class web.ORAnaestComplications Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 32;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "COMP_RowId";

Parameter SQLDESCRIPTION = "COMP_RowId";

Parameter SQLROWID = "COMP_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod LookUpAnaeComplClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpAnaeComplFetch ]
{
}

ClassMethod LookUpAnaeComplExecute(ByRef QHandle As %Library.Binary, AnaeId As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

ClassMethod LookUpAnaeComplFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpAnaeComplExecute ]
{
}

ClassMethod websysSaveAll(AnaeId As %Library.String, Items As %Library.String)
{
}

Query Find(AnaeId As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,ANACOM_Desc,COMP_Complic_DR")
{
SELECT 
COMP_RowId, 
COMP_Complic_DR->ANACOM_Desc, 
COMP_Complic_DR
FROM SQLUser.OR_AnaestComplications
WHERE COMP_ParRef = :AnaeId
}

Query LookUpAnaeCompl(ID As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "values:%String,desc:%String")
{
}

}
