Class web.MRCVarianceReason Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 161;

Parameter SQLDATEFROM = "VR_DateFrom";

Parameter SQLDATETO = "VR_DateTo";

Parameter SQLCODE = "VR_Code";

Parameter SQLDESCRIPTION = "VR_Desc";

Parameter SQLROWID = "VR_RowId";

/// Log 40992 - AI - 08-12-2003 : Added filter to incorporate DateFrom and DateTo fields stored on the MedTrak VB Codetable.
/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
/// Log 52427 YC - Added filtering for Variance CATEGORY DateFrom and DateTo fields.
Parameter SQLFILTER = "((VR_DateFrom <= CURRENT_DATE OR VR_DateFrom IS NULL) AND (VR_DateTo >= CURRENT_DATE OR VR_DateTo IS NULL) AND (VR_VarCateg_DR->VC_DateFrom <= CURRENT_DATE OR VR_VarCateg_DR->VC_DateFrom IS NULL ) AND (VR_VarCateg_DR->VC_DateTo >= CURRENT_DATE OR VR_VarCateg_DR->VC_DateTo IS NULL))";

Property dummy As %Library.String(TRUNCATE = 1);

Query FindVarReason(VarReasonDesc As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "VRRowId:%String,VRDesc:%String")
{
SELECT VR_RowId, VR_Desc 
FROM SQLUser.MRC_VarianceReason
WHERE VR_Desc  %STARTSWITH  :VarReasonDesc
ORDER BY VR_Desc
}

Query LookUpByBillingReason(VarReasonDesc As %Library.String, IsBill As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "VRDesc:%String,HIDDEN:%String,VRCode:%String")
{
SELECT	VR_Desc,VR_RowID,VR_Code
FROM    SQLUser.MRC_VarianceReason
WHERE   (((%ALPHAUP VR_Desc %STARTSWITH %ALPHAUP :VarReasonDesc) OR (%ALPHAUP VR_Code = %ALPHAUP :VarReasonDesc))
AND    	((VR_DateFrom <= CURRENT_DATE OR VR_DateFrom IS NULL) AND (VR_DateTo >= CURRENT_DATE OR VR_DateTo IS NULL) AND (VR_VarCateg_DR->VC_DateFrom <= CURRENT_DATE OR VR_VarCateg_DR->VC_DateFrom IS NULL ) AND (VR_VarCateg_DR->VC_DateTo >= CURRENT_DATE OR VR_VarCateg_DR->VC_DateTo IS NULL))
AND    	((VR_BillingReason=:IsBill) OR ((:IsBill IS NULL) AND ((VR_BillingReason !='Y')OR(VR_BillingReason IS NULL)))))
ORDER BY VR_Desc
}

ClassMethod LookUpBrokerByBillingReason(itmjs As %String = "", itmjsex As %String = "", VarReasonDesc As %String = "", IsBill As %String = "") As %Boolean
{
}

}
