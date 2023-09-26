Class web.PAExtract Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 142;

Parameter SQLCODE = "EXTR_RowId";

Parameter SQLDATEFROM = "EXTR_ESISDateFrom";

Parameter SQLDATETO = "EXTR_ESISDateTo";

Parameter SQLDESCRIPTION = "EXTR_RowId";

Parameter SQLROWID = "EXTR_RowId";

/// SA 7.3.03: Method developed for log 33505. Have made these methods in standard code rather than UDFs
/// because we expect this to be called for all Victorian hospitals.
ClassMethod RunESIS(compref As %Library.String, Hospital As %Library.String = "", Month As %Library.String = "", Year As %Library.String = "")
{
}

ClassMethod RunESISNew(compref As %Library.String, Hospital As %Library.String = "", DateFrom As %Library.String = "", DateTo As %Library.String = "", Final As %Library.String = "")
{
}

/// SA 7.3.03: Method developed for log 33508. Have made these methods in standard code rather than UDFs
/// because we expect this to be called for all Victorian hospitals.
ClassMethod RunPRS2(compref As %Library.String)
{
}

ClassMethod RollbackPRS2(compref As %Library.String)
{
}

/// Default implementation of LookUp Query.
ClassMethod FindPAExtractDetailsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindPAExtractDetailsFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindPAExtractDetailsExecute(ByRef QHandle As %Library.Binary, BatchNumber As %String, UniqueKey As %Library.String = "", PatientNumber As %Library.String = "", RecordType As %Library.String = "") As %Library.Status
{
}

/// Default implementation of LookUp Query.
ClassMethod FindPAExtractDetailsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindPAExtractDetailsExecute ]
{
}

Query FindPAExtractDetails(BatchNumber As %String, UniqueKey As %Library.String = "", PatientNumber As %Library.String = "", RecordType As %Library.String = "") As %Library.Query(CONTAINID = 0, ROWSPEC = "DETRowId,EXTRBatchNumber,PAPMINo,DETRecordType,DETRecordData,DETStatus,DETRemoveDate")
{
}

// cjb 22/02/2005 49594 - rewritten in cache

/*
Query FindPAExtractDetails(BatchNumber As %String, UniqueKey As %Library.String = "", PatientNumber As %Library.String = "", RecordType As %Library.String = "") As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "DETRowId,EXTRBatchNumber,PAPMINo,DETRecordType,DETRecordData,DETStatus,DETRemoveDate")
{
	SELECT DET_RowId, DET_ParRef->EXTR_BatchNumber, DET_PAPMI_DR->PAPMI_No, DET_RecordType, DET_RecordData, DET_Status, DET_RemoveDate
	FROM SQLUser.PA_ExtractDetails
	WHERE ((DET_ParRef->EXTR_BatchNumber=:BatchNumber) OR (:BatchNumber IS NULL))
	AND ((DET_WaitList_DR->WL_NO=:UniqueKey) OR (:UniqueKey is NULL))
	AND ((DET_PAPMI_DR->PAPMI_No=:PatientNumber) OR (:PatientNumber IS NULL))
	AND ((DET_RecordType=:RecordType) OR (:RecordType IS NULL))
}
*/
}
