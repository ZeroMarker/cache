Class web.CTCityHCA Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 26;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "CITHCA_RowId";

Parameter SQLDESCRIPTION = "CITHCA_RowId";

Parameter SQLROWID = "CITHCA_RowId";

Property dummy As %String(TRUNCATE = 1);

Query LookUpByCity(city As %String, hca As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "Description,ID,Code")
{
SELECT	CITHCA_HCA_DR->HCA_Desc,CITHCA_HCA_DR->HCA_RowID,CITHCA_HCA_DR->HCA_Code
FROM	SQLUser.CT_City_HCA
WHERE	CITHCA_City_DR->CTCIT_Desc=:city
AND	CITHCA_HCA_DR->HCA_Desc %STARTSWITH:hca
AND	(CITHCA_HCA_DR->HCA_DateFrom <= CURRENT_DATE OR CITHCA_HCA_DR->HCA_DateFrom IS NULL) 
AND	(CITHCA_HCA_DR->HCA_DateTo >= CURRENT_DATE OR CITHCA_HCA_DR->HCA_DateTo IS NULL)
AND	(CITHCA_HCA_DR->HCA_HCR_DR->HCR_DateFrom <= CURRENT_DATE OR CITHCA_HCA_DR->HCA_HCR_DR->HCR_DateFrom IS NULL) 
AND	(CITHCA_HCA_DR->HCA_HCR_DR->HCR_DateTo >= CURRENT_DATE OR CITHCA_HCA_DR->HCA_HCR_DR->HCR_DateTo IS NULL)
}

}
