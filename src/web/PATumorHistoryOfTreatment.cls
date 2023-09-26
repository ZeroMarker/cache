Class web.PATumorHistoryOfTreatment Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 50;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "HIS_RowId";

Parameter SQLDESCRIPTION = "HIS_RowId";

Parameter SQLROWID = "HIS_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod websysSaveTumorHistory(compref As %Library.String, rowid As %Library.String, PARREF As %Library.String)
{
}

ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod ValidateCodeTableDates(compid As %String) As %String
{
}

Query FindByTumor(Tumor As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "hot,startdate,enddate,rowid,parref")
{
SELECT HIS_HistoryOfTreatment_DR->HOT_Desc,HIS_StartDate,HIS_EndDate,HIS_RowId,HIS_ParRef
FROM SQLUser.PA_TumorHistoryOfTreatment
WHERE HIS_ParRef=:Tumor
}

}
