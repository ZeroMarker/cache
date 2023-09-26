Class web.RBApptScheduleCP Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 402;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ASCP_RowId";

Parameter SQLDESCRIPTION = "ASCP_RowId";

Parameter SQLROWID = "ASCP_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod GetDiarySurgeonAnaesthetist(SchedID As %Library.String = "") As %Library.String
{
}

ClassMethod GetSessionDetails(SessID As %Library.String = "") As %Library.String
{
}

ClassMethod FindCPForResDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCPForResDateFetch ]
{
}

ClassMethod FindCPForResDateExecute(ByRef qHandle As %Binary, RescID As %String = "", Date As %Date = {+$h}, Location As %String = "") As %Status
{
}

ClassMethod GetSurgeon(asid As %String = "", sessid As %String = "") As %String
{
}

ClassMethod GetAnaesthetist(asid As %String = "", sessid As %String = "") As %String
{
}

ClassMethod FindCPForResDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCPForResDateExecute ]
{
}

ClassMethod websysSaveOverride(compref As %String)
{
}

Query FindCPForResDate(RescID As %String = "", Date As %Date = {+$h}, Location As %String = "") As %Query(ROWSPEC = "SessDesc:%String,SessType:%String,StartTime:%Time,EndTime:%Time,ASId:%String,ASDate:%Date,ASStartTime:%Time,ASEndTime:%Time,SessId:%String,AcDate:%Date,AcSTime:%Time,AcETime:%Time,Delay:%String,Overtime:%String,CareProvider:%String,CPId:%String,CPArrivalTime:%Time,CPType:%String,CPRole:%String,ASSessType:%String,ASSessDesc:%String")
{
}

Query FindCPForApptSchedule(ID As %String = "") As %SQLQuery(CONTAINID = 1, ROWSPEC = "ASCPId:%String,CPId:%String,ArrTime:%Time")
{
	SELECT ASCP_RowId,ASCP_CareProv_DR, ASCP_ActualArrivalTime
	FROM SQLUser.RB_ApptScheduleCP
	WHERE ASCP_ParRef=:ID
}

ClassMethod FindCPForSchedClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCPForResDateFetch ]
{
}

ClassMethod FindCPForSchedExecute(ByRef qHandle As %Binary, SchedID As %String = "") As %Status
{
}

ClassMethod FindCPForSchedFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCPForResDateExecute ]
{
}

Query FindCPForSched(SchedID As %String) As %Query(ROWSPEC = "SessDesc:%String,SessType:%String,StartTime:%Time,EndTime:%Time,ASId:%String,ASDate:%Date,ASStartTime:%Time,ASEndTime:%Time,SessId:%String,AcDate:%Date,AcSTime:%Time,AcETime:%Time,Delay:%String,Overtime:%String,CareProvider:%String,CPId:%String,CPArrivalTime:%Time,CPType:%String,CPRole:%String")
{
}

}
