Class web.MRProcedures Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 301;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "PROC_RowId";

Parameter SQLDESCRIPTION = "PROC_RowId";

Parameter SQLROWID = "PROC_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod AddOperation(mradm As %Library.String = "", id As %Library.String = "", oper As %Library.String = "", idtrans As %Library.String = "", userid As %Library.String = "", DRGRank As %Library.String = "", procdate As %Library.Date = "", contractflag As %Library.String = "", StartTime As %Library.Time = "", EndTime As %Library.Time = "", AliasText As %Library.String = "")
{
}

/// SA 5.7.02: Method implemented for log 24580/24627
/// This method is called from web.PAAdmCoding.CopyDiagProcsAcrossEpisodes
ClassMethod CopyProcsAcrossEpisodes(compref As %Library.String, mradmFrom As %Library.String = "", mradmsTo As %Library.String = "")
{
}

ClassMethod FindDRGClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindDRGFetch ]
{
}

/// KK 17/jun/02 Log 24569 Added OPERBlockNumber to the selection list
/// KK 07/jan/04 Log 41240 Check for PROC_DRGRank included
ClassMethod FindDRGExecute(ByRef QHandle As %Library.Binary, mradm As %String = "", paadmtransid As %Library.String = "", minrows As %Library.String = "") As %Library.Status
{
}

ClassMethod FindDRGFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindDRGExecute ]
{
}

ClassMethod GetFirstProcForAppt(ApptId As %Library.String) As %Library.String
{
}

ClassMethod GetFirstProcForApptRow(ApptId As %Library.String) As %Library.String
{
}

ClassMethod GetRow(rowid, parent, code)
{
}

ClassMethod ListEPRExecute(ByRef QHandle As %Library.Binary, mradm As %Library.String = "", PAAdmTransactionID As %Library.String = "", DischEpisodes As %String = "") As %Library.Status
{
}

ClassMethod ListEPRFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status
{
}

ClassMethod ListEPRClose(QHandle As %Library.Binary) As %Library.Status
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod websysSaveDRG(compref As %Library.String = "", id As %Library.String = "", idtrans As %Library.String = "")
{
}

/// Log 55973 - PC - 06-12-2005 : Save the selected rows as either "Include in DS Report" or "Exclude From DS Report".
ClassMethod IncludeExcludeDSReport(action As %Library.String = "E", RowIDs As %Library.String = "")
{
}

Query ListEPR(mradm, PAAdmTransactionID, DischEpisodes) As %Library.Query(CONTAINID = 1, ROWSPEC = "PROC_RowId,PROC_DRGRank,PROC_Date,PROC_ParRef,PROC_ProcDate,PROC_Time,CTPCP_Desc,OPER_Code,OPER_Desc,CATEG_Desc,SSUSR_Name,PROC_PrimSecond,HRGDesc,HRGCode,UpdateHospital:%String,EpisodeID:%String,PROCDSReportFlag:%String")
{
}

Query FindByAppt(ApptID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "RowId:%String,DRGRank:%String,Date:%Date,ParRef:%String,ProcDate:%Date,Time:%Time,CTPCP:%String,OPERCode:%String,OPERDesc:%String,CATEGDesc:%String,SSUSRName:%String,PROCPrimSecond:%String")
{
SELECT PROC_RowId,PROC_DRGRank,PROC_Date,PROC_ParRef,PROC_ProcDate,PROC_Time,PROC_CTCP_DR->CTPCP_Desc,PROC_Operation_DR->OPER_Code,PROC_Operation_DR->OPER_Desc,PROC_OperCategory_DR->CATEG_Desc,PROC_User_DR->SSUSR_Name,PROC_PrimSecond
FROM SQLUser.MR_Procedures
WHERE PROC_Appoint_DR=:ApptID
}

Query FindDRG(mradm, paadmtransid, minrows) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,PROCOperationDR,PROCOperationDRDesc,PROCOperationDRCode,PROCDRGRank,OPERMechVentilCode,OPERBlockNumber,PROCOperMappedDRCode,PROCProcDate,PROCContractFlag,ProcDateMandatory,AddProcCodeRqmt,SexRestrict,PROCTimeStart,PROCTimeEnd,PROCAliasText")
{
}

/// cjb 11/04/2005 51584 - moved here from PAAdmCoding
Query GetProcedureByMRAdm(mradm As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "PROCRowId,OPERCode,CTPCPCode,CTPCPDesc,PROCDate,PROCPrimSecond,PROCFirstInset,PROCProcDate,OPERCodeId")
{
SELECT PROC_RowId, PROC_Operation_DR->OPER_Code, PROC_CTCP_DR->CTPCP_Code, PROC_CTCP_DR->CTPCP_Desc, PROC_Date, PROC_PrimSecond, PROC_FirstInset, PROC_ProcDate, PROC_Operation_DR
FROM SQLUser.MR_Procedures
WHERE   (PROC_ParRef = :mradm)
}

/// cjb 11/04/2005 51584 - moved here from PAAdmCoding
Query GetProcedureByTransaction(AdmTransID As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "PROCRowId,OPERCode,CTPCPCode,CTPCPDesc,PROCDate,PROCPrimSecond,PROCFirstInset,PROCProcDate")
{
SELECT PROC_RowId, PROC_Operation_DR->OPER_Code, PROC_CTCP_DR->CTPCP_Code, PROC_CTCP_DR->CTPCP_Desc, PROC_Date, PROC_PrimSecond, PROC_FirstInset, PROC_ProcDate
FROM SQLUser.MR_Procedures
WHERE (PROC_Transact_DR = :AdmTransID)
}

/// Aji 7/10/2003
/// cjb 12/04/2005 51584 - moved here from PAAdmCoding
Query GetProcCode(mradm As %Library.String, proccode As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID")
{
 SELECT PROC_RowID
 FROM SQLUser.MR_Procedures 
 WHERE PROC_ParRef=:mradm
 AND PROC_Operation_DR = :proccode
}

}
