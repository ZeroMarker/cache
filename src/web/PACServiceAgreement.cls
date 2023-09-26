Class web.PACServiceAgreement Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 58;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "SLA_RowId";

Parameter SQLDATEFROM = "SLA_DateFrom";

Parameter SQLDATETO = "SLA_DateTo";

Parameter SQLDESCRIPTION = "SLA_Desc";

Parameter SQLROWID = "SLA_RowId";

Query LookUpByName(Said As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Said,Commissioner,Trust,SerialNo")
{
SELECT SLA_Desc, SLA_Commissioner_DR->HCA_Code, SLA_Trust_DR->TRUST_Code, SLA_SerialNumber
 FROM	SQLUser.PAC_ServiceAgreement 
 ORDER	BY SLA_Desc
}

Query LookUpCommissionerWithTrust(Commissioner As %Library.String, Trust As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Commissioner,Trust")
{
SELECT  DISTINCT SLA_Commissioner_DR->HCA_Code, SLA_Trust_DR->TRUST_Code
FROM SQLUser.PAC_ServiceAgreement
WHERE (SLA_Commissioner_DR->HCA_Code %STARTSWITH :Commissioner)
AND (SLA_Trust_DR->TRUST_Code %STARTSWITH :Trust)
ORDER BY SLA_Desc
}

Query LookUpSerial(Serial As %Library.String, Commissioner As %Library.String, Trust As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Serial,Commissioner,Trust")
{
SELECT  DISTINCT SLA_SerialNumber, SLA_Commissioner_DR->HCA_Code, SLA_Trust_DR->TRUST_Code
FROM SQLUser.PAC_ServiceAgreement
WHERE (SLA_SerialNumber %STARTSWITH :Serial)
AND (SLA_Commissioner_DR->HCA_Code %STARTSWITH :Commissioner)
AND (SLA_Trust_DR->TRUST_Code %STARTSWITH :Trust)
ORDER BY SLA_Desc
}

}
