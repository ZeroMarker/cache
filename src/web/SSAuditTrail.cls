Include TRAK

/// webimport
Class web.SSAuditTrail Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 437;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "AUD_RowId";

Parameter SQLDESCRIPTION = "AUD_RowId";

Parameter SQLROWID = "AUD_RowId";

ClassMethod CheckHasAuditFields(ID As %Library.String) As %Library.Boolean
{
}

/// Log 39402 - AI - 10-10-2003 : Add new field User Role (SSUSR_StaffType_DR->STAFF_Desc).
/// wqr 2011.10.19
/// do ##Class(%ResultSet).RunQuery("web.SSAuditTrail","Find","","","PA_Allergy","1000||2","","","1000","","")
Query Find(DateFrom As %Library.Date, DateTo As %Library.Date, table As %Library.String, tablerowid, TimeFrom As %Library.Time, TimeRoundDown As %Library.Boolean, PatientID As %Library.String, UserCode As %Library.String, restrict As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,AUDTable,AUDUserDRSSUSRName,AUDDate:%Date,AUDTime:%Time,AUDTableRowId,tablerowiddesc,AUDAction,gotchangedfields,SSUSRInitials:%Library.String,SSUSRSurname:%Library.String,SSUSRGivenName:%Library.String,SSUSROtherName:%Library.String,HOSPDesc:%Library.String,AUDPAPMIID:%String,UserRole:%String")
{
}

ClassMethod FindExecute(ByRef qHandle As %Library.Binary, DateFrom As %Library.Date = "", DateTo As %Library.Date = "", table As %Library.String = "", tablerowid As %Library.String = "", TimeFrom As %Library.String = "", TimeRoundDown As %Library.Boolean = 0, PatientID As %Library.String = "", UserCode As %Library.String = "", restrict As %String = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	Quit:DateFrom="" $$$OK
	if DateTo="" Set DateTo=DateFrom
	If DateFrom'=""{
		For i=DateFrom:1:DateTo{
			Set ID = ""
			For {
				Set ID = $O(^AUD(0,"Date",i,ID)) Quit:ID=""  Do OutputRow
			}
		}
	}
	If table'=""{
		Set tableUp = $$ALPHAUP^SSUTIL4(table)
		For i=DateFrom:1:DateTo{
			Set ID = ""
			For {
				Set ID = $O(^AUD(0,"TableDate",tableUp,i,ID)) Quit:ID=""  Do OutputRow
			}
		}
		
	}
	if UserCode'=""{
		set UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserCode),""))
		Set Date=""
		For i=DateFrom:1:DateTo{
			Set ID = ""
			for {
				Set ID = $O(^AUD(0,"UserDate",UserId,i,ID)) Quit:ID=""  Do OutputRow 
			}
		}
	}
	Quit $$$OK
OutputRow
 Set str = ^AUD(ID)
 Set TAUDTable = $p(str,"^",1)
 Set TAUDTableRowId=$p(str,"^",2),Ttablerowiddesc=""
 Set TAUDAction=$p(str,"^",3)
 Set UserDR = $p(str,"^",7)
 if UserDR>0 {
	 Set TAUDUserDRSSUSRName = $p(^SSU("SSUSR",UserDR),"^",2)
	 Set TSSUSRInitials= $p(^SSU("SSUSR",UserDR),"^",1)
	 set TSSUSRSurname = $p(^SSU("SSUSR",UserDR),"^",69)
	 set TSSUSRGivenName = $p(^SSU("SSUSR",UserDR),"^",70)
	 set TSSUSROtherName = $p(^SSU("SSUSR",UserDR),"^",71)
 }
 Set TAUDDate = $p(str,"^",4)
 Set TAUDTime = $p(str,"^",5)
 set hospDr = $p(^SSU("SSUSR",UserDR),"^",98)
 if $g(hospDr) '= "" set THOSPDesc = $p(^CT("HOSP",hospDr),"^",2)
 set TLocationDR = $p(str,"^",9)
 Set TAUDPAPMIID = $p(str,"^",10)
 Set TAUDGroupDR = $p(str,"^",11)
 
 Set Tgotchangedfields=""
 set output = $lb(ID,TAUDTable,TAUDUserDRSSUSRName,TAUDDate,TAUDTime,TAUDTableRowId,Ttablerowiddesc,TAUDAction,
 Tgotchangedfields,TSSUSRInitials,TSSUSRSurname,TSSUSRGivenName,TSSUSROtherName,THOSPDesc,TAUDPAPMIID,TAUDGroupDR)
 set ^CacheTemp(repid,ind) = output
 set ind = ind + 1
}

ClassMethod FindFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindFetch ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindFetchDetails(ID As %Library.String) As %Library.List
{
}

/// Log 39402 - AI - 10-10-2003 : Add new field User Role (SSUSR_StaffType_DR->STAFF_Desc).
Query FindPatient(PatientID, DateFrom As %Library.Date, TimeFrom As %Library.Time, TimeRoundDown As %Library.Boolean) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,AUDTable,AUDUserDRSSUSRName,AUDDate:%Date,AUDTime:%Time,AUDTableRowId,tablerowiddesc,AUDAction,gotchangedfields,SSUSRInitials:%Library.String,SSUSRSurname:%Library.String,SSUSRGivenName:%Library.String,SSUSROtherName:%Library.String,HOSPDesc:%Library.String,AUDPAPMIID:%String,UserRole:%String")
{
}

ClassMethod FindPatientExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String = "", DateFrom As %Library.Date = "", TimeFrom As %Library.Time = "", TimeRoundDown As %Library.Boolean = 0) As %Library.Status
{
}

ClassMethod FindPatientFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindPatientExecute ]
{
}

ClassMethod FindPatientClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindPatientFetch ]
{
}

ClassMethod GetDisplayDetails(table As %Library.String, tablerowid As %Library.String, ByRef DisplayDesc As %Library.String) As %Library.String
{
}

/// below are defunct methods and queries... do not use
Query XFind(DateFrom As %Library.Date, DateTo As %Library.Date, table As %Library.String, tablerowid, TimeFrom As %Library.Time, TimeRoundDown As %Library.Boolean, PatientID As %Library.String, UserCode As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,AUDTable,AUDUserDRSSUSRName,AUDDate:%Date,AUDTime:%Time,AUDTableRowId,tablerowiddesc,AUDAction,gotchangedfields,SSUSRInitials:%Library.String,SSUSRSurname:%Library.String,SSUSRGivenName:%Library.String,SSUSROtherName:%Library.String,HOSPDesc:%Library.String")
{
}

ClassMethod XFindExecute(ByRef QHandle As %Library.Binary, DateFrom As %Library.Date = "", DateTo As %Library.Date = "", table As %Library.String = "", tablerowid As %Library.String = "", TimeFrom As %Library.String = "", TimeRoundDown As %Library.Boolean = 0, PatientID As %Library.String = "", UserCode As %Library.String = "") As %Library.Status
{
}

ClassMethod XFindFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = XFindExecute ]
{
}

ClassMethod XFindClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = XFindFetch ]
{
}

/// KK 30-Jan-2002 Log No:22047 : Query to retrieve table, user, date and time passing table 
/// TN: 30-May-2002: changed the order by clause from ORDER BY AUD_Date DESC, AUD_Time DESC to ORDER	BY AUD_RowID DESC
Query XFindAllTableForPatient(PatientID As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,AUDTable,AUDUserDR,AUDDate:%Date,AUDTime:%Time,AUDTableRowId,AUDAction,AUDCacheUser,AUDLogonLocationDR")
{
SELECT AUD_RowId,AUD_Table,AUD_User_DR,AUD_Date,AUD_Time,AUD_TableRowId,AUD_Action,AUD_CacheUser,AUD_LogonLocation_DR
FROM SQLUser.SS_AuditTrail
WHERE (AUD_PAPMI_DR = :PatientID)
ORDER BY AUD_Date DESC, AUD_RowID DESC
}

/// KK 30-Jan-2002 Log No:22047 : Query to retrieve table, user, date and time passing date
/// TN: 30-May-2002: changed the order by clause from ORDER BY AUD_Date DESC, AUD_Time DESC to ORDER	BY AUD_RowID DESC
Query XFindDate(DateFrom As %Library.Date, DateTo As %Library.Date) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,AUDTable,AUDUserDR,AUDDate:%Date,AUDTime:%Time,AUDTableRowId,AUDAction,AUDCacheUser,AUDLogonLocationDR")
{
SELECT AUD_RowId,AUD_Table,AUD_User_DR,AUD_Date,AUD_Time,AUD_TableRowId,AUD_Action,AUD_CacheUser,AUD_LogonLocation_DR
FROM SQLUser.SS_AuditTrail
WHERE (AUD_Date >= :DateFrom)
AND (AUD_Date <= :DateTo)
ORDER BY AUD_RowID DESC
}

/// KK 30-Jan-2002 Log No:22047 : Query to retrieve table, user, date and time passing table 
/// TN: 30-May-2002: changed the order by clause from ORDER BY AUD_Date DESC, AUD_Time DESC to ORDER	BY AUD_RowID DESC
Query XFindTable(table As %Library.String, DateFrom As %Date, DateTo As %Date, tablerowid As %Library.String, UserID As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,AUDTable,AUDUserDR,AUDDate:%Date,AUDTime:%Time,AUDTableRowId,AUDAction,AUDCacheUser,AUDLogonLocationDR")
{
SELECT AUD_RowId,AUD_Table,AUD_User_DR,AUD_Date,AUD_Time,AUD_TableRowId,AUD_Action,AUD_CacheUser,AUD_LogonLocation_DR
FROM SQLUser.SS_AuditTrail
WHERE (AUD_Table = :table)
AND ((AUD_TableRowId = :tablerowid) OR (:tablerowid IS NULL))
AND ((AUD_User_DR = :UserID) OR (:UserID IS NULL))
AND (AUD_Date >= :DateFrom)
AND (AUD_Date <= :DateTo)
ORDER BY AUD_Date DESC, AUD_RowID DESC
}

/// KK 30-Jan-2002 Log No:22047 : Query to retrieve table, user, date and time passing table 
/// TN: 30-May-2002: changed the order by clause from ORDER BY AUD_Date DESC, AUD_Time DESC to ORDER	BY AUD_RowID DESC
Query XFindTableRowFromDateTime(table As %Library.String, tablerowid, DateFrom As %Date, TimeFrom As %Time) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,AUDTable,AUDUserDR,AUDDate:%Date,AUDTime:%Time,AUDTableRowId,AUDAction,AUDCacheUser,AUDLogonLocationDR")
{
SELECT AUD_RowId,AUD_Table,AUD_User_DR,AUD_Date,AUD_Time,AUD_TableRowId,AUD_Action,AUD_CacheUser,AUD_LogonLocation_DR
FROM SQLUser.SS_AuditTrail
WHERE (AUD_Table = :table)
AND (AUD_TableRowId = :tablerowid)
AND (AUD_Date >= :DateFrom)
AND ( ((AUD_Date = :DateFrom)AND(AUD_Time >= :TimeFrom)) OR (AUD_Date > :DateFrom))
ORDER BY AUD_Date DESC, AUD_RowID DESC
}

/// KK 30-Jan-2002 Log No:22047 : Query to retrieve table, user, date and time passing date
/// TN: 30-May-2002: changed the order by clause from ORDER BY AUD_Date DESC, AUD_Time DESC to ORDER	BY AUD_RowID DESC
Query XFindUserDate(User As %Library.String, DateFrom As %Library.Date, DateTo As %Library.Date) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,AUDTable,AUDUserDR,AUDDate:%Date,AUDTime:%Time,AUDTableRowId,AUDAction,AUDCacheUser,AUDLogonLocationDR")
{
SELECT AUD_RowId,AUD_Table,AUD_User_DR,AUD_Date,AUD_Time,AUD_TableRowId,AUD_Action,AUD_CacheUser,AUD_LogonLocation_DR
FROM SQLUser.SS_AuditTrail
WHERE (AUD_User_DR = :User)
AND (AUD_Date >= :DateFrom)
AND (AUD_Date <= :DateTo)
ORDER BY AUD_Date DESC, AUD_RowID DESC
}

Query FindEpisode(EpisodeID, DateFrom As %Library.Date, TimeFrom As %Library.Time, TimeRoundDown As %Library.Boolean) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,AUDTable,AUDUserDRSSUSRName,AUDDate:%Date,AUDTime:%Time,AUDTableRowId,tablerowiddesc,AUDAction,gotchangedfields,SSUSRInitials:%Library.String,SSUSRSurname:%Library.String,SSUSRGivenName:%Library.String,SSUSROtherName:%Library.String,HOSPDesc:%Library.String,AUDPAADMID:%String,UserRole:%String")
{
}

ClassMethod FindEpisodeExecute(ByRef QHandle As %Library.Binary, EpisodeID As %Library.String = "", DateFrom As %Library.Date = "", TimeFrom As %Library.Time = "", TimeRoundDown As %Library.Boolean = 0) As %Library.Status
{
}

ClassMethod FindEpisodeFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindEpisodeExecute ]
{
}

ClassMethod FindEpisodeClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindEpisodeFetch ]
{
}

}
