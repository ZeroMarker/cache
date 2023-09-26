Class web.ORAnOperPosition Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 28;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "OPPOS_RowId";

Parameter SQLDESCRIPTION = "OPPOS_RowId";

Parameter SQLROWID = "OPPOS_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod LookUpPosClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpPosFetch ]
{
}

ClassMethod LookUpPosExecute(ByRef QHandle As %Library.Binary, OpId As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

ClassMethod LookUpPosFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpPosExecute ]
{
}

Query Find(OpId As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,OPPOS_Desc,OPPOS_Position_DR,OPPOS_StartTime,OPPOS_EndTime")
{
SELECT 
OPPOS_RowId, 
OPPOS_Position_DR->OPPOS_Desc, 
OPPOS_Position_DR,
OPPOS_StartTime,
OPPOS_EndTime
FROM SQLUser.OR_An_Oper_Position
WHERE OPPOS_ParRef = :OpId
}

Query LookUpPos(ID As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "values:%String,desc:%String")
{
}

}
