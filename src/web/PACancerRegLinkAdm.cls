Class web.PACancerRegLinkAdm Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 173;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ADM_RowId";

Parameter SQLDESCRIPTION = "ADM_RowId";

Parameter SQLROWID = "ADM_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// Default implementation of LookUp Query.
ClassMethod FindCancerAdmClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindCancerAdmFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindCancerAdmExecute(ByRef QHandle As %Library.Binary, CancerReg As %Library.String) As %Library.Status
{
}

/// Default implementation of LookUp Query.
ClassMethod FindCancerAdmFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindCancerAdmExecute ]
{
}

ClassMethod LookUpAdmBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", PatientID As %Library.String = "", Hospital As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

/// KK 13/01/05 L:48704 - replaced LookUpAdmission with LookUpAdmissionOnHosp
ClassMethod LookUpAdmissionOnHospClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = LookUpAdmissionOnHospFetch ]
{
}

ClassMethod LookUpAdmissionOnHospExecute(ByRef QHandle As %Binary, PatientID As %String, Hospital As %String) As %Status
{
}

ClassMethod LookUpAdmissionOnHospFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpAdmissionOnHospExecute ]
{
}

ClassMethod websysSaveCancerRegLinkAdm(compref As %Library.String, rowid As %Library.String, PARREF As %Library.String)
{
}

Query FindCancerAdm(CancerReg As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "adm,hosp,rowid,childsub,admdate,disdate,disdoc,icdcode,icddesc,DisType,EpisodeID,mradm")
{
}

Query LookUpAdmission(PatientID As %Library.String, Hospital As %Library.String, val As %Library.String, SiteFlag As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "EpisodeNo,CTLOC_Desc:%String:Location,CTPCP_Desc:%String:Care Provider,WARDDesc:%String:Ward,hosp:%String:Hospital,HIDDEN:%String")
{
	SELECT PAADM_ADMNo, PAADM_DepCode_DR->CTLOC_Desc,PAADM_AdmDocCodeDR->CTPCP_Desc, PAADM_CurrentWard_DR->WARD_Desc, PAADM_CurrentWard_DR->WARD_LocationDR->CTLOC_Hospital_DR->HOSP_Desc, PAADM_RowId
	FROM SQLUser.PA_Adm
	WHERE (PAADM_PAPMI_DR = :PatientID) AND ('A P D' [PAADM_VisitStatus)
	AND (PAADM_DischgDate IS NOT NULL)
	AND (PAADM_CurrentWard_DR->WARD_LocationDR->CTLOC_Hospital_DR=:Hospital)
	AND (PAADM_Type='I')
	ORDER BY PAADM_AdmDate desc, PAADM_AdmTime desc
}

/// KK 13/01/05 L:48704 - replaced LookUpAdmission with LookUpAdmissionOnHosp
Query LookUpAdmissionOnHosp(PatientID As %String, Hospital As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "EpisodeNo,CTLOC_Desc:%String:Location,CTPCP_Desc:%String:Care Provider,WARDDesc:%String:Ward,hosp:%String:Hospital,HIDDEN:%String")
{
}

}
