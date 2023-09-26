Class web.PATreatmentProgress Extends (%Library.RegisteredObject, websys.Abstract) [ Inheritance = right ]
{

Parameter BUILD = 17;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "TRPR_RowId";

Parameter SQLDESCRIPTION = "TRPR_RowId";

Parameter SQLROWID = "TRPR_RowId";

Query List(TSRTITM, TSRTORD, PatientID As %Date) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,DateRefer,DateTreat,Text1,Text2,Reason")
{
 SELECT TRPR_RowId, TRPR_RefDate, TRPR_TreatmentDate,
 		TRPR_Text1, TRPR_Text2, TRPR_TreatReason_DR
 FROM	SQLUser.PA_TreatmentProgress
 WHERE	(TRPR_ParRef=:PatientID)
}

/// log 62167
ClassMethod SaveTreatmentProgress(compref As %String, id As %String) As %Boolean
{
}

}
