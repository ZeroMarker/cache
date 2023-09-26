Class web.RBEventPatient Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 75;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "PAT_RowId";

Parameter SQLDESCRIPTION = "PAT_RowId";

Parameter SQLROWID = "PAT_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// Delete an instance - this is provided as a wrapper for %DeleteId functionality.
ClassMethod websysDelete(id As %Library.String = "", parref As %Library.String = "")
{
}

ClassMethod websysSave(compref As %String, id As %Library.String = "", parref As %String = "", rsvp As %Library.String = "", arrived As %Library.String = "", waiver As %Library.String = "")
{
}

ClassMethod FindPatientsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindPatientsFetch ]
{
}

ClassMethod FindPatientsExecute(ByRef QHandle As %Library.Binary, PARREF As %Library.String = "") As %Library.Status
{
}

ClassMethod FindPatientsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindPatientsExecute ]
{
}

/// cjb 01/02/2006 55848
/// moved the following query out of RBEventPatient.List, so can filter out the VIPs if needed:
/// SELECT PAT_RowId,PAT_PatMas_DR,PAT_PatMas_DR->PAPMI_Name,PAT_PatMas_DR->PAPMI_Name2,PAT_PatMas_DR->PAPMI_Name3,PAT_RSVP,PAT_Arrived,PAT_PatMas_DR->PAPMI_Sex_DR->CTSEX_Desc,PAT_PatMas_DR->PAPMI_Dob,PAT_WaiverFee,PAT_PatMas_DR->PAPMI_VIPFlag
/// FROM SQLUser.RB_EventPatient
/// WHERE PAT_ParRef=:PARREF
Query FindPatients(PARREF As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "PAT_RowId:%String,PAT_PatMas_DR:%String,PAPMI_Name:%String,PAPMI_Name2:%String,PAPMI_Name3:%String,PAT_RSVP:%String,PAT_Arrived:%String,CTSEX_Desc:%String,PAPMI_Dob:%String,PAT_WaiverFee:%String,PAPMI_VIPFlag:%String")
{
}

}
