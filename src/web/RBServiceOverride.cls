Class web.RBServiceOverride Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 760;

Parameter SQLDATEFROM;

Parameter SQLDATETO = "SOV_DateTo";

ClassMethod websysSaveMessage(compref As %String = "", id As %String = "") As %Library.Boolean
{
}

/// From a resource id date and time we find if a slot is closed
ClassMethod IsSlotClosed(res As %String = "", date As %String = "", time As %String = "") As %Boolean
{
}

Parameter SQLCODE = "SOV_RowId";

Parameter SQLDESCRIPTION = "SOV_RowId";

Parameter SQLROWID = "SOV_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod CheckDate(compref As %Library.String, SessionID As %Library.String, Date As %Library.String, id As %Library.String) As %Library.Boolean
{
}

ClassMethod FindMultiSlotOverrideClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindMultiSlotOverrideFetch ]
{
}

ClassMethod FindMultiSlotOverrideExecute(ByRef QHandle As %Library.Binary, resource As %Library.String = "", date As %Library.String = "", sessionId As %Library.String = "") As %Library.Status
{
}

ClassMethod FindMultiSlotOverrideFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindMultiSlotOverrideExecute ]
{
}

ClassMethod InsertMultiSlotOverride(compref As %String, ByRef id As %String)
{
}

ClassMethod ListOverridesClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ListOverridesFetch ]
{
}

/// 	n obj
/// 	s work=$lb("")
/// 	s user=$lb(Date,Resource)
/// 	k ^TMP("WEB",$J)
/// 	;
/// 	s mcnt=1
/// 	i $$open^MVBRBSO1("",Date,Resource,"")
/// 	f  q:$$fetch^MVBRBSO1("",Date,Resource,"")  d
/// 	. s str = PLIST(3)
/// 	. s cnt=1
/// 	. s end=1
/// 	. i PLIST(1)=Time  d
/// 	. . f  d  q:end=0
/// 	. . . s tmp=$p(str,"&",cnt)
/// 	. . . i tmp'="" d
/// 	. . . . s SOVRowId=$p($p(tmp,"|",1),$c(1),1)
/// 	. . . . m ^zkath("a"_SOVRowId)=tmp
/// 	. . . . s SGDesc=$p(tmp,"|",2)
/// 	. . . . s SOVNumberOfServices=$p(tmp,"|",3)
/// 	. . . . //s SOVMessage=$p(tmp,"|",4)
/// 	. . . . //s SOVMessage=$p(tmp,$c(1),2)
/// 	. . . . //s ^zkath("e"_mcnt)=SOVMessage
/// 	. . . . s obj=##Class(User.RBServiceOverride).%OpenId(SOVRowId,0)
/// 	. . . . i obj d
/// 	. . . . . s SOVMessage=##Class(websys.Conversions).LongTextLogicalToHtml(obj.SOVMessage,$c(13,10))
/// 	. . . . . s ^zkath("f"_mcnt)=SOVMessage
/// 	. . . . . d obj.%Close()
/// 	. . . . s ^TMP("WEB",$J,mcnt)=$lb(SOVRowId,SGDesc,SOVNumberOfServices,SOVMessage)
/// 	. . . . //m ^zkath("f"_mcnt)=^TMP("WEB",$J,mcnt)
/// 	. . . . s mcnt=mcnt+1
/// 	. . . . s cnt=cnt+1
/// 	. . . i tmp="" s end=0
/// 	;
/// 	i AtEnd=1 s Row="" q $$$OK
/// 	s QHandle=$lb(0,user,work)
/// 	;
/// 	Quit $$$OK
/// 
ClassMethod ListOverridesExecute(ByRef QHandle As %Library.Binary, Resource As %Library.String, Date As %Library.String, Time As %Library.String, SessID As %Library.String) As %Library.Status
{
}

ClassMethod ListOverridesFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ListOverridesExecute ]
{
}

ClassMethod ResetOverridesToSess(compref As %Library.String, tdate As %Library.String, resource As %Library.String, sessionId As %Library.String)
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

/// KM 6-Dec-2001: Called From component RBAppointment.SlotOverride
/// (So dramatically altered that consider it re-written on 6th Dec)
ClassMethod websysSaveSlotOverride(compref As %Library.String)
{
}

Query Find(SessionID As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,Date,Message")
{
SELECT  SOV_Rowid, SOV_Date, SOV_Message
FROM SQLUser.RB_ServiceOverride
WHERE SOV_RBSession_DR = :SessionID
}

Query FindByDate(SessionID As %Library.String, Date As %Library.Date) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,Date,Message")
{
SELECT  SOV_Rowid, SOV_Date, SOV_Message
FROM SQLUser.RB_ServiceOverride
WHERE SOV_RBSession_DR = :SessionID
AND SOV_Date=:Date
}

Query FindByDay(ResID As %Library.String, Date As %Library.Date) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "")
{
SELECT  SOV_ServiceGroup_DR, SOV_Date, SOV_Message
FROM SQLUser.RB_ServiceOverride
WHERE (SOV_Resource_DR=:ResID) AND (SOV_Date=:Date) AND (SOV_StartTime=:Time)
}

Query FindMessagesForSession(RBSessID As %Library.String, LogicalDate As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "SOVRowId:%String,SOVDate:%Date,SOVMessage:%String,SSUSRName:%String,SOVUpdateDate:%Date,SOVUpdateTime:%Time,HOSP_Desc:%String,UserID:%String,SOVRBSessionDR:%String")
{
 SELECT SOV_RowId,SOV_Date,SOV_Message,SOV_UpdateUser_DR->SSUSR_Name,SOV_UpdateDate,SOV_UpdateTime,SOV_LastUpdateHospital_DR->HOSP_Desc,SOV_UpdateUser_DR->SSUSR_Initials,SOV_RBSession_DR
 FROM SQLUser.RB_ServiceOverride
 Where SOV_RBSession_DR=:RBSessID
 Order By SOV_Date DESC
}

ClassMethod FindMessagesForSessionExecute(ByRef QHandle As %Library.Binary, RBSessID As %Library.String = "", LogicalDate As %Library.String = "") As %Library.Status
{
}

ClassMethod FindMessagesForSessionFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindMessagesForSessionExecute ]
{
}

ClassMethod FindMessagesForSessionClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindMessagesForSessionFetch ]
{
}

Query FindMultiSlotOverride(resource As %String, date As %Date, sessionId As %String) As %Query(CONTAINID = 1, ROWSPEC = "SchedID,Time:%Time,load:%String,message:%String,slotover:%String,mrowid:%String,sesstype:%String,sessionID:%String")
{
}

Query ListOverrides(Resource As %String, Date As %Date, Time As %Time, SessID As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "SOVRowId:%String,SGDesc:%String,SOVNumberOfServices:%String,SOVMessage:%String,DayOverride:%String")
{
}

ClassMethod BuildKey(service As %String) As %String
{
}

ClassMethod GetLastUpdateData(sessId As %String, sdate As %String)
{
}

}
