Class web.PACWLReasonNotAvail Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 195;

Parameter SQLDATEFROM = "REA_DateFrom";

Parameter SQLDATETO = "REA_DateTo";

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "REA_Code";

Parameter SQLDESCRIPTION = "REA_Desc";

Parameter SQLROWID = "REA_RowId";

Property Dummy As %Library.String(TRUNCATE = 1);

/// rqg,Log24214: This method is created to return the cancellation reason description if code is known.
ClassMethod GetReasonDescFromCode(code As %Library.String) As %Library.String
{
}

/// done for log 29112. 
ClassMethod GetWLDeceaseRemoveReason(Param As %Library.String = "", rev As %Library.String = "") As %Library.String
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpActiveBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
/// RQG 29.08.03 L38361: To restrict lookup to waitinglist
ClassMethod LookUpByAdmRGroupBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", group As %Library.String = "", activedate As %Library.String = "") As %Library.Boolean
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
/// RQG 29.08.03 L38361: To restrict lookup to waitinglist
ClassMethod LookUpByAdmRGroupBrokerDNA(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", group As %Library.String = "", activedate As %Library.String = "") As %Library.Boolean
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpByGroupBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", group As %Library.String = "") As %Library.Boolean
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpByRRGroupBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", group As %Library.String = "", remove As %Library.String = "", activedate As %Library.Date = "", type As %Library.String = "") As %Library.Boolean
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpByRRRGroupClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpByRRRGroupFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpByRRRGroupExecute(ByRef QHandle As %Library.Binary, val As %String, group As %Library.String, remove As %Library.String, activedate As %Library.Date = "", type As %String) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpByRRRGroupFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpByRRRGroupExecute ]
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod NotAvailableLookUpByRGBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", group As %Library.String = "", activedate As %Library.Date = "", restrtype As %Library.String = "") As %Library.Boolean
{
}

ClassMethod ReturnReasonGroupID(ID As %Library.String) As %Library.String
{
}

/// used in pawaitinglistadm.edit GR
/// RQG 27.08.03 L38361: To restrict query to "WLO - Waiting List Only" 
Query DNALookUp(val As %Library.String, group As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "REA_Desc:%Library.String,REA_Code:%Library.String,Hidden")
{
SELECT REA_Desc,REA_Code,REA_ReasonGroup_DR->WLRG_Desc
FROM SQLUser.PAC_WLReasonNotAvail
WHERE ((REA_ReasonGroup_DR->WLRG_Desc = :group) OR (:group IS NULL)) AND ((REA_Desc %STARTSWITH :val) OR (REA_Code %STARTSWITH :val)) AND (REA_DNAReason='Y') AND ((REA_Restriction = 'WLO') OR (REA_Restriction IS NULL) OR (REA_Restriction = ''))
ORDER BY REA_Desc
}

Query LookUpByAdmRGroup(val As %Library.String, group As %Library.String, activedate As %Library.Date) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "REA_Desc,REA_Code,hidden")
{
SELECT REA_Desc,REA_Code,REA_ReasonGroup_DR->WLRG_Desc
FROM SQLUser.PAC_WLReasonNotAvail
WHERE ((REA_ReasonGroup_DR->WLRG_Desc = :group) OR (:group IS NULL)) 
AND ((REA_Desc %STARTSWITH :val) OR (REA_Code %STARTSWITH :val)) 
AND (REA_CancelOnPreAdmission= 'Y')
AND ((REA_DateFrom <= :activedate) OR (REA_DateFrom IS NULL) OR (:activedate IS NULL))
AND ((REA_DateTo >= :activedate) OR (REA_DateTo IS NULL) OR (:activedate IS NULL))
AND ((REA_Restriction = 'WLO') OR (REA_Restriction IS NULL) OR (REA_Restriction = ''))
}

Query LookUpByRRRGroup(val As %Library.String, group As %Library.String, remove As %String, activedate As %Library.Date, type As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "REA_Desc:%Library.String,REA_Code:%Library.String,Hidden:%String")
{
}

Query LookUpByReasonGroup(val As %Library.String, group As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "REA_Desc:%Library.String,REA_Code:%Library.String,Hidden")
{
SELECT REA_Desc, REA_Code, REA_ReasonGroup_DR->WLRG_Desc
FROM SQLUser.PAC_WLReasonNotAvail
WHERE ((REA_ReasonGroup_DR->WLRG_Desc = :group) OR (:group IS NULL))
AND ((REA_Desc %STARTSWITH :val) OR (REA_Code %STARTSWITH :val))
ORDER BY REA_Desc
}

/// RQG 29.08.03 L38361
Query NotAvailableLookUpByReasonGroup(val As %Library.String, group As %Library.String, activedate As %Library.Date, restrtype As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "REA_Desc:%Library.String,REA_Code:%Library.String,Hidden")
{
SELECT REA_Desc, REA_Code, REA_ReasonGroup_DR->WLRG_Desc
FROM SQLUser.PAC_WLReasonNotAvail
WHERE (((REA_ReasonGroup_DR->WLRG_Desc = :group) OR (:group IS NULL)) 
AND ((REA_Desc %STARTSWITH :val) OR (REA_Code %STARTSWITH :val))) 
AND (REA_UnavailableReason='Y')
AND ((REA_DateFrom <= :activedate) OR (REA_DateFrom IS NULL) OR (:activedate IS NULL))
AND ((REA_DateTo >= :activedate) OR (REA_DateTo IS NULL) OR (:activedate IS NULL))
AND ((REA_Restriction = :restrtype) OR (REA_Restriction IS NULL)  OR (REA_Restriction = '') OR (:restrtype='') OR (:restrtype IS NULL))
ORDER BY REA_Desc
}

/// Gr 11/09/03 38332
Query PriorityLookUpByReasonGroup(val As %Library.String, group As %Library.String, activedate As %Library.Date) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "REA_Desc:%Library.String,REA_Code:%Library.String,Hidden")
{
SELECT REA_Desc, REA_Code, REA_ReasonGroup_DR->WLRG_Desc
FROM SQLUser.PAC_WLReasonNotAvail
WHERE (((REA_ReasonGroup_DR->WLRG_Desc = :group) OR (:group IS NULL)) 
AND ((REA_Desc %STARTSWITH :val) OR (REA_Code %STARTSWITH :val))) 
AND (REA_PriorityChange='Y')
AND ((REA_DateFrom <= :activedate) OR (REA_DateFrom IS NULL) OR (:activedate IS NULL))
AND ((REA_DateTo >= :activedate) OR (REA_DateTo IS NULL) OR (:activedate IS NULL))
ORDER BY REA_Desc
}

ClassMethod PriorityBrokerByReasonGroup(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", group As %Library.String = "", activedate As %Library.Date = "") As %Library.Boolean
{
}

}
