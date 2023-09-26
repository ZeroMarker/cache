Class web.PACPatientAlert Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 338;

Parameter SQLDATEFROM = "ALERT_DateFrom";

Parameter SQLDATETO = "ALERT_DateTo";

Parameter SQLCODE = "ALERT_Code";

Parameter SQLDESCRIPTION = "ALERT_Desc";

Parameter SQLROWID = "ALERT_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// Log 37186 - AI - 31-07-2003 : Created method to calculate the Duration Of Alert field.
/// Will return a string built from the number of Years, Months and Days.
ClassMethod CalculateAlertDuration(StartDate As %String = "", EndDate As %String = "") As %String
{
}

ClassMethod GetAlertsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = GetAlertsFetch ]
{
}

ClassMethod GetAlertsExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String) As %Library.Status
{
}

ClassMethod GetAlertsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = GetAlertsExecute ]
{
}

/// KM 4-Feb-2002: Broker to match new lookup query web.PACPatientAlert.LookUpRestrictByCat
/// Log 42270 - AI - 12-02-2004 : Modified method to incorporate DateFrom and DateTo fields stored on MedTrak VB Codetable.
/// LookUpBrokerRestrictByCat
ClassMethod LookUpBrokerRestrictByCat(itmjs As %Library.String = "", itmjsex As %Library.String = "", desc As %Library.String = "", alertcat As %Library.String = "", date As %Library.String = "") As %Library.Boolean
{
}

/// MD 10/01/2003: Broker to match new lookup query web.PACPatientAlert.LookUpRestrictByCat
/// Log 42270 - AI - 12-02-2004 : Modified method to incorporate DateFrom and DateTo fields stored on MedTrak VB Codetable.
/// LookUpBrokerRestrictByCatC
ClassMethod LookUpBrokerRestrictByCatC(itmjs As %Library.String = "", itmjsex As %Library.String = "", desc As %Library.String = "", alert As %Library.String = "", date As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpRestrictByCatCClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpRestrictByCatCFetch ]
{
}

/// Log 42270 - AI - 12-02-2004 : Modified method to incorporate DateFrom and DateTo fields stored on MedTrak VB Codetable.
ClassMethod LookUpRestrictByCatCExecute(ByRef QHandle As %Library.Binary, desc As %Library.String, alert As %Library.String, date As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpRestrictByCatCFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpRestrictByCatCExecute ]
{
}

ClassMethod LookUpRestrictByCatClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpRestrictByCatFetch ]
{
}

/// Log 42270 - AI - 12-02-2004 : Modified method to incorporate DateFrom and DateTo fields stored on MedTrak VB Codetable.
ClassMethod LookUpRestrictByCatExecute(ByRef QHandle As %Library.Binary, desc As %Library.String, alertcat As %Library.String, date As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpRestrictByCatFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpRestrictByCatExecute ]
{
}

ClassMethod RestrictByCat() As %Library.String
{
}

/// KM 5-Feb-2002: For general use but created specifically for use with the 
/// Log 42270 - AI - 12-02-2004 : Modified query to incorporate DateFrom and DateTo fields stored on MedTrak VB Codetable.
/// PAAlertMsg.LookUpRestrictByCat query.
Query Find(desc As %Library.String, Categs As %Library.String, date As %Library.String = "") As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,Code,Desc,Category")
{
 SELECT  ALERT_Rowid, ALERT_Code,ALERT_Desc,ALERT_AlertCategory_DR->ALERTCAT_Desc
 FROM SQLUser.PAC_PatientAlert
 WHERE ((ALERT_Desc %STARTSWITH :desc)
 OR (ALERT_Code = :desc))
 AND (((:Categs[ALERT_AlertCategory_DR)
 OR (:Categs IS NULL))
 AND ((ALERT_DateFrom <= :date OR ALERT_DateFrom IS NULL) AND (ALERT_DateTo >= :date OR ALERT_DateTo IS NULL)))
 ORDER BY ALERT_AlertCategory_DR->ALERTCAT_Desc,ALERT_Desc
}

/// KM 5-Feb-2002: For general use but created specifically for use with the PAAlertMsg.LookUpRestrictByCat query.
/// Log 42270 - AI - 12-02-2004 : Modified query to incorporate DateFrom and DateTo fields stored on MedTrak VB Codetable.
Query FindC(desc As %Library.String, Categs As %Library.String, date As %Library.String = "") As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,Code,Desc,Category")
{
 SELECT  ALERT_Rowid, ALERT_Code,ALERT_Desc,ALERT_AlertCategory_DR->ALERTCAT_Desc
 FROM SQLUser.PAC_PatientAlert
 WHERE (((ALERT_Desc %STARTSWITH :desc)
 OR (ALERT_Code = :desc))
 AND (ALERT_AlertCategory_DR= :Categs)
 AND ((ALERT_DateFrom <= :date OR ALERT_DateFrom IS NULL) AND (ALERT_DateTo >= :date OR ALERT_DateTo IS NULL)))
 ORDER BY ALERT_AlertCategory_DR->ALERTCAT_Desc,ALERT_Desc
}

/// KM 5-Feb-2002: For general use but created specifically for use with the 
/// Log 42270 - AI - 12-02-2004 : Modified query to incorporate DateFrom and DateTo fields stored on MedTrak VB Codetable.
/// PAAlertMsg.LookUpRestrictByCat query.
Query FindF(desc As %Library.String, Categs As %Library.String, date As %Library.String = "") As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,Code,Desc,Category")
{
 SELECT  ALERT_Rowid, ALERT_Code,ALERT_Desc,ALERT_AlertCategory_DR->ALERTCAT_Desc
 FROM SQLUser.PAC_PatientAlert
 WHERE (((ALERT_Desc %STARTSWITH :desc)
 OR (ALERT_Code = :desc))
 AND (:Categs[ALERT_AlertCategory_DR)
 AND ((ALERT_DateFrom <= :date OR ALERT_DateFrom IS NULL) AND (ALERT_DateTo >= :date OR ALERT_DateTo IS NULL)))
 ORDER BY ALERT_AlertCategory_DR->ALERTCAT_Desc,ALERT_Desc
}

/// KM 5-Feb-2002: Restrict patient alerts to those assigned to present users group.
/// Log 39749 - AI - 09-10-2003 : Replaced "CTCPTDesc" with "UpdateUserRole".
Query GetAlerts(PatientID As %Library.String) As %Library.Query(CONTAINID = 2, ROWSPEC = "RowId,ClosedFlag,CreateDate,CreateTime,ExpiryDate,Message,PAPMIParRef,ViewDate,ViewTime,CreateUserName,ViewUserName,ALERTDesc,ReviewDate,AlertCategoryDR,ALERTCATDesc,UpdateUserRole,HOSPDesc,OnsetDate,ClosedDate,ClosedTime,CreateUserRole,LastUpdateHosp,AlertDuration:%String,AlertStatus,ExternalID:%String,LastUpdateUserID:%String,AuditTrail:%String,ALMDSReportFlag:%String,HiddenFields:%String")
{
}

/// KM 5-Feb-2002: Restrict patient alerts to those assigned to present users group.
/// Log 42270 - AI - 12-02-2004 : Modified method to incorporate DateFrom and DateTo fields stored on MedTrak VB Codetable.
Query LookUpRestrictByCat(desc As %Library.String, alertcat As %Library.String, date As %Library.String = "") As %Library.Query(CONTAINID = 2, ROWSPEC = "Message:%String,HIDDEN:%String,Code:%String,Category:%String")
{
}

/// KM 5-Feb-2002: Restrict patient alerts to those assigned to present users group.
/// Log 42270 - AI - 12-02-2004 : Modified query to incorporate DateFrom and DateTo fields stored on MedTrak VB Codetable.
Query LookUpRestrictByCatC(desc As %Library.String, alert As %Library.String, date As %Library.String = "") As %Library.Query(CONTAINID = 0, ROWSPEC = "MessageDesc:%String,Message:%String")
{
}

Query LookupCategSecGroup(Desc As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Message::%Library.String")
{
}

}
