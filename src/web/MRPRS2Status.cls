Include webimport

IncludeGenerator webimport

Class web.MRPRS2Status Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 35;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "PRS2_RowId";

Parameter SQLDESCRIPTION = "PRS2_RowId";

Parameter SQLROWID = "PRS2_RowId";

/// cjb 24/06/2005 53259 - save MR_Adm->MRADMPRS2Status and insert new row in MR_PRS2Status
ClassMethod websysSavePRS2(compref As %Library.String = "", mradm As %Library.String = "", Status As %Library.String = "")
{
}

Query FindStatus(mradm As %String = "") As %SQLQuery(CONTAINID = 1, ROWSPEC = "HIDDEN:%String,PRS2Status:%String,PRS2UpdateDate:%String,PRS2UpdateTime:%String,BatchNumber:%String,FileName:%String,PRS2PreviousStatus:%String,PRS2RecordTypes:%String")
{
	SELECT PRS2_RowId, PRS2_Status, PRS2_UpdateDate, PRS2_UpdateTime,PRS2_Extract_DR->EXTR_BatchNumber,PRS2_Extract_DR->EXTR_FileName, PRS2_PreviousStatus, PRS2_RecordTypes
	FROM SQLUser.MR_PRS2Status
	WHERE (PRS2_ParRef=:mradm)
}

}
