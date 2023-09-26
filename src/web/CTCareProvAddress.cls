Class web.CTCareProvAddress Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 82;

Parameter SQLCODE = "ADDR_Postcode_DR";

Parameter SQLDATEFROM = "ADDR_DateFrom";

Parameter SQLDESCRIPTION = "ADDR_Address2";

Parameter SQLDATETO = "ADDR_DateTo";

Parameter SQLROWID = "ADDR_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// ab 16.07.04 - 44313 - added several fields
Query ListAll(CareProvID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ADDRAddress1,ADDRAddress2,ADDREmail,ADDRFax,ADDRMobile,ADDRPager,ADDRPhone,CTZIPDesc,ADDRRowId,PROVDesc,CTCITDesc,ADDRType,ADDRPrefMethod,HOSPDesc,ADDRDateFrom,ADDRDateTo,ADDRContactFirstOn,ADDRBestContactTime,ADDRPrefConMethod,ADDRProvNumber,CTCPT_Desc")
{
SELECT ADDR_Address1,ADDR_Address2,ADDR_Email,ADDR_Fax,
ADDR_Mobile,ADDR_Pager,ADDR_Phone,ADDR_Postcode_DR->CTZIP_Code,
ADDR_RowId,ADDR_State_DR->PROV_Desc,ADDR_Suburb_DR->CTCIT_Desc,ADDR_Type,ADDR_PrefMethod,
ADDR_Hospital_DR->HOSP_Desc,ADDR_DateFrom,ADDR_DateTo,ADDR_ContactFirstOn,ADDR_BestContactTime,ADDR_PrefConMethod,
ADDR_ProvNumber,ADDR_ParRef->CTPCP_CarPrvTp_DR->CTCPT_Desc
FROM SQLUser.CT_CareProvAddress
WHERE ADDR_ParRef=:CareProvID
ORDER BY ADDR_DateFrom DESC
}

/// ab 16.07.04 - returns CTCareProv address details, or if none exist, CTCareProvAddress based on hospital
ClassMethod GetAddress(id As %String = "", hosp As %String = "") As %String
{
}

}
