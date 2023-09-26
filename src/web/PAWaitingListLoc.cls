Class web.PAWaitingListLoc Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 63;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

ClassMethod LookUpDeptsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpDeptsFetch ]
{
}

/// KK 30/Apr/2002 Log 24008
ClassMethod LookUpDeptsExecute(ByRef QHandle As %Library.Binary, WaitingListID As %Library.String) As %Library.Status
{
}

/// KK 30/Apr/2002 Log 24008
ClassMethod LookUpDeptsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpDeptsExecute ]
{
}

/// KK 30/Apr/2002 Log 24008
ClassMethod websysSaveAll(WaitingListID As %Library.String, Departments As %Library.String)
{
}

Parameter SQLCODE = "LOC_RowId";

Parameter SQLDESCRIPTION = "LOC_RowId";

Parameter SQLROWID = "LOC_RowId";

/// KK 30/Apr/2002 Log 24008
Query Find(WaitingListID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,LocDesc:%String")
{
SELECT LOC_RowId, 
 LOC_CTLOC_DR->CTLOC_Desc
FROM SQLUser.PA_WaitingListLoc
WHERE (LOC_ParRef = :WaitingListID)
}

/// KK 30/Apr/2002 Log 24008
Query LookUpDepts(WaitingListID As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "values:%String,desc:%String")
{
}

}
