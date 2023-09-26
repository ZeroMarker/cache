Class web.PAPersonInsurance Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 49;

Parameter SQLDATEFROM = "INS_DateFrom";

Parameter SQLDATETO = "INS_DateTo";

Parameter SQLCODE = "INS_RowId";

Parameter SQLDESCRIPTION = "INS_RowId";

Parameter SQLROWID = "INS_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod UpdateLatest(PatientID As %String = "", InsurID As %String = "", compref As %String = "", auxins As %String = "")
{
}

Query FindInsur(PARREF As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,DateFrom,DateTo,INSTDesc,ParRef,AUXITDesc,HealthFundNo")
{
SELECT	INS_RowID,INS_DateFrom,INS_DateTo,INS_InsType_DR->INST_Desc,INS_ParRef,INS_AuxInsType_DR->AUXIT_Desc,
INS_HealthFundNo
FROM	SQLUser.PA_PersonInsurance
WHERE	INS_ParRef= :PARREF
ORDER BY INS_DateFrom DESC, INS_DateTo
}

}
