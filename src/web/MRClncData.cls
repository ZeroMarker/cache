Class web.MRClncData Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 96;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "MRCLN_RowId";

Parameter SQLDESCRIPTION = "MRCLN_RowId";

Parameter SQLROWID = "MRCLN_RowId";

Query List(mradm As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,MRCLNBldPressDias,MRCLNBldPressSyst,MRCLNBodyTemp,MRCLNDate,MRCLNPRCrit,MRCLNPressCrit,MRCLNPulseRate,MRCLNTempCrit,MRCLNTime")
{
SELECT MRCLN_RowId, MRCLN_BldPressDias, MRCLN_BldPressSyst, MRCLN_BodyTemp, MRCLN_Date, MRCLN_PRCrit, MRCLN_PressCrit, MRCLN_PulseRate, MRCLN_TempCrit, MRCLN_Time
FROM SQLUser.MR_ClncData
WHERE MRCLN_MRADM_ParRef=:mradm
}

}
