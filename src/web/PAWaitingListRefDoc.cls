Class web.PAWaitingListRefDoc Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 52;

Parameter SQLCODE = "REFD_RowId";

Parameter SQLDATEFROM = "REFD_DateFrom";

Parameter SQLDATETO = "REFD_DateTo";

Parameter SQLDESCRIPTION = "REFD_RowId";

Parameter SQLROWID = "REFD_RowId";

/// rg:Log24512: To return details in PAWaitingListRefDoc list
Query GetByWaitingListID(WaitingListID As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,REFDDesc:%String,CLNCode:%String,CLNAddress1:%String,CLNAddress2:%String,CTCITDesc:%String,REFDDateFrom:%Library.Date,REFDDateTo:%Library.Date,REFDConsent,REFDType")
{
SELECT REFD_RowId, REFD_RefDoc_DR->REFD_Desc, REFD_RefDocClinic_DR->CLN_Code,
 REFD_RefDocClinic_DR->CLN_Address1, REFD_RefDocClinic_DR->CLN_Address2,
 REFD_RefDocClinic_DR->CLN_City_DR->CTCIT_Desc, REFD_DateFrom, REFD_DateTo,
 REFD_Consent, REFD_RefDoc_DR->REFD_Type
FROM SQLUser.PA_WaitingListRefDoc
WHERE (REFD_ParRef = :WaitingListID)
ORDER BY REFD_DateFrom DESC
}

}
