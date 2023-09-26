Include TRAK

Class web.SSAuditTrailFields Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 168;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "FLD_RowId";

Parameter SQLDESCRIPTION = "FLD_RowId";

Parameter SQLROWID = "FLD_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod FindClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindFetch ]
{
}

ClassMethod FindExecute(ByRef QHandle As %Library.Binary, PARREF As %Library.String = "") As %Library.Status
{
}

ClassMethod FindFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindExecute ]
{
}

Query Find(PARREF As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,FLDFieldNo,FLDOldValue,FLDValue")
{
}

Query FindFieldChanges(table As %String, tablerowid As %String, fieldno As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID:%String,SSUSRName:%String,AUDDate:%String,AUDTime:%String,FLDOldValue:%String,FLDValue:%String,CTCPTDesc:%String")
{
SELECT FLD_RowId,
 FLD_ParRef->AUD_User_DR->SSUSR_Name,
 FLD_ParRef->AUD_Date,
 FLD_ParRef->AUD_Time,
 FLD_OldValue,FLD_Value,
 FLD_ParRef->AUD_User_DR->SSUSR_CareProv_DR->CTPCP_CarPrvTp_DR->CTCPT_Desc
FROM SQLUser.SS_AuditTrailFields
WHERE (FLD_ParRef->AUD_Table = :table) 
AND (FLD_ParRef->AUD_TableRowId = :tablerowid)
AND (FLD_FieldNo = :fieldno)
ORDER BY FLD_ParRef->AUD_Date DESC, FLD_ParRef->AUD_Time DESC
}

}
