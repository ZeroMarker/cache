Class web.CTDisposit Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 62;

Parameter SQLCODE = "CTDSP_Code";

Parameter SQLDATEFROM = "CTDSP_DateFrom";

Parameter SQLDESCRIPTION = "CTDSP_Desc";

Parameter SQLDATETO = "CTDSP_DateTo";

Parameter SQLFILTER = "((CTDSP_DateFrom <= CURRENT_DATE OR CTDSP_DateFrom IS NULL) AND (CTDSP_DateTo >= CURRENT_DATE OR CTDSP_DateTo IS NULL))";

Parameter SQLROWID = "CTDSP_RowID";

/// KM 27-Sept-2001: Called from RBAppointment.websysSaveApptStatus
/// Once the LookUpBroker method works for this class then should only need method GetCodeFromDescription
ClassMethod GetCodeFromCodeOrDescription(val As %Library.String) As %Library.String
{
}

ClassMethod LookUpBrokerWithNatCode(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", OrganProcurement As %String = "", date As %String = "") As %Library.Boolean
{
}

Query LookUpWithNatCode(desc As %String, OrganProcurement As %String, date As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,hidden:%String")
{
SELECT CTDSP_Desc, CTDSP_RowID, CTDSP_Code, CTDSP_NationalCode
FROM SQLUser.CT_Disposit
WHERE (%ALPHAUP CTDSP_Desc %STARTSWITH %ALPHAUP :desc) 
 AND ((CTDSP_DateFrom <= :date) OR (CTDSP_DateFrom IS NULL)) 
AND ((CTDSP_DateTo >= :date) OR (CTDSP_DateTo IS NULL))
ORDER BY CTDSP_Desc
}

}
