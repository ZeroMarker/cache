Class web.RTCPostDischargeStatus Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 564;

Parameter SQLDATEFROM = "MRSTAT_DateFrom";

Parameter SQLDATETO = "MRSTAT_DateTo";

Method FindLatestVolAssignedToEpis(EpisodeID As %Library.String = "")
{
}

Parameter SQLCODE = "MRSTAT_Code";

Parameter SQLDESCRIPTION = "MRSTAT_Desc";

Parameter SQLROWID = "MRSTAT_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod CheckRegGetPatID(EnteredRegNo As %Library.String = "")
{
}

ClassMethod FindIncompleteEpisClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindIncompleteEpisFetch ]
{
}

ClassMethod FindIncompleteEpisExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String, RegistrationNo As %Library.String = "") As %Library.Status
{
}

ClassMethod FindIncompleteEpisFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindIncompleteEpisExecute ]
{
}

ClassMethod GetDescFromRowId(rowid As %Library.String) As %Library.String
{
}

ClassMethod GetOldestInpEpis(pat As %Library.String) As %Library.String
{
}

ClassMethod GetOldestInpEpisOnly(PatientID As %Library.String) As %Library.String
{
}

ClassMethod GetPostDiscStatusDesc(code As %Library.String) As %Library.String
{
}

ClassMethod IncompleteEpNOBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", PAADMADMNo As %Library.String = "") As %Library.Boolean
{
}

ClassMethod IncompleteRegNoBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", RegistrationNo As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpBrokerPostDisc(itmjs As %Library.String = "", itmjsex As %Library.String = "", EpisodeNo As %Library.String = "") As %Library.Boolean
{
}

ClassMethod websysSavePostDischarge()
{
}

ClassMethod zzzxGetRegistration(PatientID As %Library.String) As %Library.String
{
}

Query FindIncompleteEpis(PatientID As %Library.String, RegistrationNo As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,EpisodeNo,PAADMAdmDate,PAADMAdmTime,CTLOCDesc,CTPCPDesc,PAADMDischargeDate,GPConsent,Ward,RESDesc,PAADMPostDischStatusDR,VolumeNo,RegistrationNo,PatientID,VolumeId")
{
}

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query LookUp(desc As %String) As %Library.Query(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
}

Query LookUpStatus(desc As %Library.String, disdate As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
	SELECT MRSTAT_Desc,MRSTAT_RowId,MRSTAT_Code
	FROM SQLUser.RTC_PostDischargeStatus
	WHERE ((%ALPHAUP MRSTAT_Code = %ALPHAUP :desc OR %ALPHAUP MRSTAT_Desc %STARTSWITH %ALPHAUP :desc)
		AND ((MRSTAT_DateFrom <= :disdate AND MRSTAT_DateTo >= :disdate)
			OR (MRSTAT_DateFrom <= :disdate AND MRSTAT_DateTo IS NULL)
			OR (MRSTAT_DateFrom IS NULL AND MRSTAT_DateTo IS NULL))
		)	
	ORDER BY MRSTAT_Desc
}

ClassMethod LookUpStatusBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", Desc As %Library.String, disdate As %Library.String) As %Library.Boolean
{
}

}
