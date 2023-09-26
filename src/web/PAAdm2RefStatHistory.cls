Include webimport

IncludeGenerator webimport

Class web.PAAdm2RefStatHistory Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 90;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "REFHIS_RowId";

Parameter SQLDESCRIPTION = "REFHIS_RowId";

Parameter SQLROWID = "REFHIS_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// SB 05/09/03 36813: Transation History for Referral Status, Called from PAAdm websysSave
/// d ##Class(web.PAAdm2RefStatHistory).AddNew(EpisodeID,$p(admParam6,"^",11),$p(admParam5,"^",2))
ClassMethod AddNew(EpisodeID As %Library.String, RefStat As %Library.String, RefPriority As %Library.Time)
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod DateExistsForAdmDate(EpisodeID As %String, RefStatHisId As %String, RefDate As %String) As %Boolean
{
}

ClassMethod ValidateDate(compid As %String, EpisodeID As %String, ID As %String, PAADMAdmDate As %String) As %Boolean
{
}

ClassMethod ValidateTime(compid As %String, EpisodeID As %String, ID As %String) As %Boolean
{
}

ClassMethod IsCurrentTrans(EpisodeID As %String, chl As %String) As %Boolean
{
}

ClassMethod DateExistsForAdmDate2(ID As %String) As %Boolean
{
}

}
