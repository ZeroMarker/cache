Class web.PAPersonOrganDonor Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 35;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ORG_RowId";

Parameter SQLDESCRIPTION = "ORG_RowId";

Parameter SQLROWID = "ORG_RowId";

Property dummy As %String(TRUNCATE = 1);

/// ab 27.11.03 40139
/// hidden broker populates PAPersonOrganDonor.Edit with donor details
ClassMethod FillClientDetails(itmjs As %String, itmjsex As %String, PatientID As %String = "") As %Boolean
{
}

Query FindOrgans(PatientID As %String = "") As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,Remarks,DonorID,DonorSurname,DonorFirstName,VIPStatus")
{
SELECT ORG_RowId,ORG_Remarks,ORG_PAPER_DR->PAPER_RowId,ORG_PAPER_DR->PAPER_Name,ORG_PAPER_DR->PAPER_Name2,ORG_PAPER_DR->PAPER_PAPMI_DR->PAPMI_VIPFlag
FROM SQLUser.PA_PersonOrganDonor
WHERE ORG_ParRef->PAPER_RowId = :PatientID
}

}
