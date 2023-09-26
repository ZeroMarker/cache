Class web.PACInPatAdmTypeSNAPCare Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 26;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "SNAP_RowId";

Parameter SQLDESCRIPTION = "SNAP_RowId";

Parameter SQLROWID = "SNAP_RowId";

ClassMethod LookUpBrokerWithDate(itmjs As %String = "", itmjsex As %String = "", val As %String = "", inpatadm As %String = "", rdate As %Date) As %Boolean
{
}

Query FindSNAPCareWithDate(desc As %String, inpatadm As %String, rdate As %Date) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "SNAPCTDesc,HIDDEN,SNAPCTCode")
{
SELECT SNAP_SNAPCareType_DR->SNAPCT_Desc,SNAP_SNAPCareType_DR->SNAPCT_RowId,SNAP_SNAPCareType_DR->SNAPCT_Code
FROM SQLUser.PAC_InpatAdmTypeSNAPCare
WHERE  SNAP_ParRef->IPAT_Code= :inpatadm
AND ((SNAP_SNAPCareType_DR->SNAPCT_Desc %STARTSWITH :desc)
OR	 (SNAP_SNAPCareType_DR->SNAPCT_Code=:desc))
AND	((SNAP_SNAPCareType_DR->SNAPCT_DateFrom IS NULL) OR (SNAP_SNAPCareType_DR->SNAPCT_DateFrom<= :rdate))
AND	((SNAP_SNAPCareType_DR->SNAPCT_DateTo IS NULL) OR (SNAP_SNAPCareType_DR->SNAPCT_DateTo>= :rdate))
AND	((SNAP_ParRef->IPAT_DateFrom IS NULL) OR (SNAP_ParRef->IPAT_DateFrom<= :rdate))
AND	((SNAP_ParRef->IPAT_DateTo IS NULL) OR (SNAP_ParRef->IPAT_DateTo>= :rdate))
}

}
