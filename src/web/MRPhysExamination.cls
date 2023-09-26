Include webimport

IncludeGenerator webimport

Class web.MRPhysExamination Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 159;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

ClassMethod GetFirstRecord(mradm As %Library.String)
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

Parameter SQLCODE = "PHYS_RowId";

Parameter SQLDESCRIPTION = "PHYS_Desc";

Parameter SQLROWID = "PHYS_RowId";

Parameter dummy = "%String";

ClassMethod ListEPRExecute(ByRef QHandle As %Library.Binary, mradm As %Library.String, GrpSetCarPrv As %Library.String = "", mradmlist As %Library.String = "") As %Library.Status
{
}

ClassMethod ListEPRFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status
{
}

ClassMethod GetRow(rowid)
{
}

ClassMethod ListEPRClose(QHandle As %Library.Binary) As %Library.Status
{
}

Query ListEPR(mradm As %Library.String, GrpSetCarPrv As %Library.String, mradmlist As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,PROB_Desc,BODAR_Desc,SUBP_Desc,STAT_Desc,PHYS_Date:%Library.Date,PHYS_Time:%Library.Time,PHYS_Desc,UpdateDate,UpdateTime,UpdateUserName,UpdateHospitalDesc")
{
}

}
