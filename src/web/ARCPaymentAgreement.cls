Include webimport

IncludeGenerator webimport

Class web.ARCPaymentAgreement Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 139;

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod FindInsuranceCardNo(PatientID As %Library.String, Payor As %Library.String, Plan As %Library.String) As %Library.String
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBrokerByActiveTo(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", payor As %Library.String = "") As %Library.Boolean
{
}

Parameter SQLCODE = "PAY_AccountCode";

Parameter SQLDATEFROM = "PAY_DateFrom";

Parameter SQLDATETO = "PAY_DateTo";

Parameter SQLDESCRIPTION = "PAY_RowId";

Parameter SQLROWID = "PAY_RowId";

/// KM 3-Aug-2001: Changed Query From Below so that LookUp takes into account 
/// that the payor may be the payor code rather than the payor description.
/// SELECT	PAY_AuxInsType_DR->AUXIT_Desc, 
/// PAY_AuxInsType_DR->AUXIT_InsType_DR->INST_Desc, PAY_DateTo
/// FROM	ARC_PaymentAgreement
/// WHERE	(PAY_AuxInsType_DR->AUXIT_Desc %STARTSWITH :desc) 
/// AND (PAY_AuxInsType_DR->AUXIT_InsType_DR->INST_Desc %STARTSWITH :payor)
/// AND ((PAY_DateTo < :date) OR (PAY_DateTo IS NULL))
/// 
Query LookUpByActiveTo(desc As %String, payor As %String, date As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "desc:%String,code:%String,payor:%String,date:%Library.String")
{
SELECT PAY_AuxInsType_DR->AUXIT_Desc, 
 PAY_AuxInsType_DR->AUXIT_Code,
 PAY_AuxInsType_DR->AUXIT_InsType_DR->INST_Desc, 
 PAY_DateTo
FROM ARC_PaymentAgreement
WHERE (PAY_AuxInsType_DR->AUXIT_Desc %STARTSWITH :desc)
 AND ((PAY_AuxInsType_DR->AUXIT_InsType_DR->INST_Desc %STARTSWITH :payor)
 OR (PAY_AuxInsType_DR->AUXIT_InsType_DR->INST_Code %STARTSWITH :payor)) 
 AND ((PAY_DateTo < :date) OR (PAY_DateTo IS NULL))
}

}
