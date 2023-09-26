Class web.OETextResultHistory Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 103;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "HIS_RowId";

Parameter SQLDESCRIPTION = "HIS_RowId";

Parameter SQLROWID = "HIS_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

Query Find(ParRef As %Library.String = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,ChildSub,Date,Time,User,HISClinicallySignificant")
{
 SELECT HIS_RowId, HIS_ChildSub,HIS_Date,HIS_Time,HIS_User_DR->SSUSR_Name,HIS_ClinicallySignificant
 FROM SQLUser.OE_TextResultHistory
 WHERE HIS_ParRef=:ParRef
 ORDER BY HIS_Date DESC, HIS_Time DESC
}

/// Log 42683 - AI - 12-03-2004 : Find to return the current details as well as all history entries.
ClassMethod FindAllHistoryClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindAllHistoryFetch ]
{
}

/// Log 42683 - AI - 12-03-2004 : Find to return the current details as well as all history entries.
ClassMethod FindAllHistoryExecute(ByRef QHandle As %Library.Binary, ParRef As %String = "") As %Library.Status
{
}

/// Log 42683 - AI - 12-03-2004 : Find to return the current details as well as all history entries.
ClassMethod FindAllHistoryFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindAllHistoryExecute ]
{
}

/// Log 42683 - AI - 12-03-2004 : Find to return the current details as well as all history entries.
Query FindAllHistory(ParRef As %String = "") As %Library.Query(CONTAINID = "", ROWSPEC = "ID,ChildSub,Date,Time,User,HISClinicallySignificant")
{
}

ClassMethod GetTextResultHist(ID As %String = "") As %Library.String
{
}

ClassMethod FindHistoryClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindHistoryFetch ]
{
}

ClassMethod FindHistoryExecute(ByRef QHandle As %Library.Binary, ParRef As %String = "") As %Library.Status
{
}

ClassMethod FindHistoryFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindHistoryExecute ]
{
}

Query FindHistory(ParRef As %String = "") As %Library.Query(CONTAINID = "", ROWSPEC = "ID,ParRef,ChildSub,HISDate,HISTime,HISUserDR,HISClinicallySignificant,HISResStatDR,HISCTCPDR,HISTextResultTypeDR,HISDateVerified,HISTimeVerified,HISUserVerifiedDR,HISName,HISDateRead,HISTimeRead,HISUserReadDR,HISSuppressPrint,HISImpressionDR,HISDateUpdated,HISTimeUpdated,HISActionDR,HISExternalResultStatus,HISUserUnreadDR,HISDateUnread,HISTimeUnread,HISLastUpdateHospitalDR,HISResultFlags,HISCareProviderReportedDR,HISUserTranscribedDR,HISQuestionnaire,HISUserUpdatedDR,HISCPVerifiedDR,HISReasonSuppResultDR,NSRstr")
{
}

}
