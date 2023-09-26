Class web.PASLADetailsAllocatedMulti Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 47;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "MULT_RowId";

Parameter SQLDESCRIPTION = "MULT_RowId";

Parameter SQLROWID = "MULT_RowId";

Query FindMulti(RowId As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ParRef,RowId,Childsub,ServAgreementDR,SLADesc,ComDesc,ComCode,TrustCode,TrustDesc,SerialNo")
{
select MULT_ParRef,MULT_RowId,MULT_Childsub,MULT_ServAgreement_DR,MULT_ServAgreement_DR->SLA_Desc,MULT_ServAgreement_DR->SLA_Commissioner_DR->HCA_Code,MULT_ServAgreement_DR->SLA_Commissioner_DR->HCA_Desc,MULT_ServAgreement_DR->SLA_Trust_DR->TRUST_Code,MULT_ServAgreement_DR->SLA_Trust_DR->TRUST_Desc,MULT_ServAgreement_DR->SLA_SerialNumber
from SQLUser.PA_SLADetailsAllocatedMulti
where MULT_ParRef = :RowId
}

}
