Class web.PAAdm2FreqAttendActions Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 8;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "FRA_RowId";

Parameter SQLDESCRIPTION = "FRA_RowId";

Parameter SQLROWID = "FRA_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpActionsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpActionsFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpActionsExecute(ByRef QHandle As %Library.Binary, PAADM2ID As %String) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpActionsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpActionsExecute ]
{
}

ClassMethod websysSaveAll(paadm2id As %String, Items As %String)
{
}

Query Find(PAADM2ID As %String = "") As %SQLQuery(CONTAINID = 0, ROWSPEC = "ID,FAA_Desc,FRA_FreqAttendAction_DR")
{
SELECT	FRA_RowId,FRA_FreqAttendAction_DR ->FAA_Desc,FRA_FreqAttendAction_DR 
FROM	SQLUser.PA_Adm2FreqAttendActions
WHERE	FRA_ParRef = :PAADM2ID
}

Query LookUpActions(PAAAdm2ID As %String) As %Library.Query(CONTAINID = 2, ROWSPEC = "values:%String,desc:%String")
{
}

}
