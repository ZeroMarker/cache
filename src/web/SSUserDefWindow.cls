Include (webimport, TRAK)

IncludeGenerator (webimport, TRAK)

Class web.SSUserDefWindow Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1470;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "WIN_Code";

Parameter SQLDESCRIPTION = "WIN_Desc";

Parameter SQLROWID = "WIN_RowId";

/// increment this if questionnaire classes need to be auto generated before viewing.
/// ssuserdefwindow.questionnaire.csp calls method that checks this and auto generates accordingly
Parameter GENERATIONBUILD = 21;

Property dummy As %String(TRUNCATE = 1);

ClassMethod CopyQuest(ID As %String = "", Code As %String = "", Desc As %String = "")
{
}

ClassMethod TotalControls(ID As %String = "") As %String
{
}

/// ab 6.11.06 61465 - not used
ClassMethod Disauthorise(ID As %String = "", QuestionnaireID As %String = "")
{
}

/// Create a questionnaire class from the User.SSUserDefWindow
ClassMethod CreateClass(id As %Library.String)
{
}

ClassMethod CreateClassXML(udwin As %Library.String, classname As %Library.String)
{
}

ClassMethod CreateClassCDL(udwin As %Library.String, classname As %Library.String)
{
}

/// ab 9.05.06 52166
ClassMethod QuestAnswered(code As %String = "") As %Library.String
{
}

/// Derive the class name from the code.
/// Add the package name
/// Add a prefix in case the code is numeric only
/// Remove punctuation
/// Keep the whole thing less than 25 characters
/// This needs to be valid for a classname and a global name
/// [Previously private]
ClassMethod CreateClassClassname(code As %Library.String) As %Library.String [ CodeMode = expression ]
{
///by wuqk 2011-06-16 未实现
	quit
}

/// Turn a database string like ABC, DEF, HIJ to the object definition like:  ,ABC,DEF,HIJ
/// [Previously private]
ClassMethod CreateClassParameterList(val As %Library.String) As %Library.String
{
}

/// Create a valid property description from the control text.
/// TN:20-Feb-03 : removes the "
/// [Previously private]
ClassMethod CreateClassPropertydescription(desc As %Library.String = "") As %Library.String [ CodeMode = expression ]
{
///by wuqk 2011-06-16 未实现
	quit
}

/// Create a valid property name from the code.
/// If it does not start with alpha then prefix with Q.
/// Remove punctuation.
/// Truncate to 25 chars.
/// [Previously private]
ClassMethod CreateClassPropertyname(code As %Library.String, oldcode As %String = "") As %Library.String [ CodeMode = expression ]
{
}

/// strip leading space
/// 
/// [Previously private]
ClassMethod CreateClassStrip(val As %Library.String) As %Library.String
{
}

/// 	Turn a database string like ABC, DEF, HIJ to the object definition like:  ,ABC,DEF,HIJ
/// 	remove double quotes
/// [Previously private]
ClassMethod CreateClassValueList(val As %Library.String) As %Library.String
{
}

ClassMethod CreateComponent(id As %Library.String)
{
}

ClassMethod RegenLUScript()
{
}

ClassMethod CreateComponentLayout(id As %Library.String)
{
}

ClassMethod CreateComponentLUScript(id As %Library.String, cmpid As %Library.String)
{
}

/// Create the DSSView items for the questionnaire class from the User.SSUserDefWindow
ClassMethod CreateDSSView(id As %Library.String)
{
}

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
}

/// Create a valid property name from the code.
/// If it does not start with alpha then prefix with Q.
/// Remove punctuation.
/// Truncate to 25 chars.
/// [Previously private]
ClassMethod CreateDSSViewItemDescription(desc As %Library.String = "") As %Library.String
{
}

ClassMethod websysSaveAudit() As %Library.String
{
}

Query FindAuditing() As %Query(ROWSPEC = "QID:%String,Classname:%String,ClassDesc:%String,DoInsert:%String,DoUpdate:%String,DoDelete:%String")
{
}

ClassMethod FindAuditingExecute(ByRef QHandle As %Binary) As %Status
{
	;QID:%String,Classname:%String,ClassDesc:%String,DoInsert:%String,DoUpdate:%String,DoDelete
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	Set QID=""
	For {
		Set QID = $O(^CT("AUDR",QID)) ;SSAuditRules
		Quit:QID=""
		Set (Classname,ClassDesc,DoInsert,DoUpdate,DoDelete)=""
		Set Classname = $p(^CT("AUDR",QID),"^",1)
		Set ClassDesc = $p(^CT("AUDR",QID),"^",5)
		Set DoInsert = $p(^CT("AUDR",QID),"^",2)
		Set DoUpdate = $p(^CT("AUDR",QID),"^",3)
		Set DoDelete = $p(^CT("AUDR",QID),"^",4)
		Set Data= $lb(QID,Classname,ClassDesc,DoInsert,DoUpdate,DoDelete)
		Set ^CacheTemp(repid,ind)=Data
	}
	
	quit $$$OK
}

ClassMethod FindAuditingFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAuditingExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAuditingClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindAuditingExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindComponentClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindComponentFetch ]
{
}

ClassMethod FindComponentExecute(ByRef QHandle As %Library.Binary, code As %Library.String = "", description As %Library.String = "", groups As %Library.String = "", HideInactive As %String = "") As %Library.Status
{
}

ClassMethod FindComponentFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindComponentExecute ]
{
}

ClassMethod GetClassNameFromId(QuestionnaireID As %Library.String) As %Library.String
{
}

/// checks that a SSUserDefWindow definition has been generated into a class and has an associated edit component to it.
/// doGenId is the SSUserDefWindow rowid to check that the generated class is the latest version, and if not, generates it.
/// Do not pass doGenId if this method is called in a loop.
ClassMethod IsGeneratedQuestionnaire(classname As %Library.String, doGenId As %Integer = 0) As %Library.Boolean
{
}

ClassMethod IsRecentVersion(classname As %String = "") As %Boolean
{
}

ClassMethod VBDeleteControls(ParRef As %Library.String)
{
}

ClassMethod VBFindLEClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = VBFindLEFetch ]
{
}

ClassMethod VBFindLEExecute(ByRef QHandle As %Library.Binary, desc As %Library.String) As %Library.Status
{
}

ClassMethod VBFindLEFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = VBFindLEExecute ]
{
}

ClassMethod webGenerate(allIDs As %Library.String = "", LastGenUser As %String = "", LastGenHosp As %String = "")
{
}

ClassMethod webGenerateJob()
{
}

ClassMethod websysDeleteQuestionnaire(id As %Library.String = "", class As %Library.String = "")
{
}

ClassMethod LookUpAllClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpAllFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// by wuqk 2011-06-16 未实现
ClassMethod LookUpAllExecute(ByRef QHandle As %Library.Binary, code As %Library.String) As %Library.Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	
	quit $$$OK
}

ClassMethod LookUpAllFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpAllExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// used to return code, desc for ExtendedListBoxes
Query LookupListResponses(ParRef As %String = "", Desc As %String = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "Desc")
{

SELECT RESP_Desc
FROM SQLUser.SS_UserDefWinContResp
WHERE (RESP_ParRef=:ParRef)
AND ((%ALPHAUP RESP_Desc %STARTSWITH %ALPHAUP :Desc) OR (:Desc Is NULL))
}

ClassMethod LookupResponsesForLBDateExecute(ByRef QHandle As %Library.Binary, ParRef As %Library.String) As %Library.Status
{
}

ClassMethod LookupResponsesForLBDateFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookupResponsesForLBDateExecute ]
{
}

ClassMethod LookupResponsesForLBDateClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookupResponsesForLBDateFetch ]
{
}

/// ExtendedListBoxes for drawing to SELECT listboxes
Query LookupResponsesForLBDate(ParRef As %String = "") As %Library.Query(CONTAINID = 1, ROWSPEC = "Code,Desc")
{
}

Query LookupResponsesForLB(ParRef As %String = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "Code,Desc")
{
 SELECT RESP_Code,RESP_Desc
 FROM SQLUser.SS_UserDefWinContResp
 WHERE (RESP_ParRef=:ParRef)
}

ClassMethod LookupResponsesDateExecute(ByRef QHandle As %Library.Binary, ParRef As %String = "", Desc As %String = "") As %Library.Status
{
}

ClassMethod LookupResponsesDateFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookupResponsesDateExecute ]
{
}

ClassMethod LookupResponsesDateClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookupResponsesDateFetch ]
{
}

/// ExtendedListBoxes for drawing to SELECT listboxes
Query LookupResponsesDate(ParRef As %String = "", Desc As %String = "") As %Library.Query(CONTAINID = 1, ROWSPEC = "Desc,Code,Score")
{
}

ClassMethod LookupResponsesDateBroker(itmjs As %Library.String, itmjsex As %Library.String, parref As %String = "", code As %Library.String = "")
{
}

Query LookupResponses(ParRef As %String = "", Desc As %String = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "Desc,Code,Score")
{
SELECT RESP_Desc, RESP_Code, RESP_Score
FROM SQLUser.SS_UserDefWinContResp
WHERE (RESP_ParRef=:ParRef)
AND ((%ALPHAUP RESP_Desc %STARTSWITH %ALPHAUP :Desc) OR (:Desc Is NULL))
}

ClassMethod LookupResponsesBroker(itmjs As %Library.String, itmjsex As %Library.String, parref As %String = "", code As %Library.String = "")
{
}

ClassMethod LookUpAllBroker(itmjs As %Library.String, itmjsex As %Library.String, code As %Library.String = "")
{
}

ClassMethod LookupListBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", list As %Library.String = "") As %Library.Boolean
{
}

/// general broker for LookupList query.
/// accepts same parameters as LookupList and returns the same data
/// differs from LookupListBroker which is used by LookupUserDefined items
ClassMethod LookupBrokerList(itmjs As %Library.String = "", itmjsex As %Library.String = "", list As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookupListClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookupListFetch ]
{
}

ClassMethod LookupListExecute(ByRef QHandle As %Library.Binary, DescList As %Library.String, val As %Library.String = "", CompName As %String = "", EnableList As %Library.String, DisableList As %Library.String) As %Library.Status
{
}

ClassMethod LookupListFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookupListExecute ]
{
}

ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

/// Query to wrap a comma separated list. This is to simplify the logic in lookups.
Query LookupList(DescList As %Library.String, val As %Library.String = "", CompName As %String, EnableList As %Library.String, DisableList) As %Library.Query(CONTAINID = 0, ROWSPEC = "Desc:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
}

Query Find(qno As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,WINCode:%String,WINDesc:%String,WINDocument:%String,WINScore:%String,WINUsedFlag:%String")
{
SELECT WIN_Rowid, WIN_Code, WIN_Desc, WIN_Document, WIN_Score, WIN_UsedFlag
FROM SS_UserDefWindow
WHERE (WIN_Rowid = :qno)
}

Query FindAll() As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,WINCode,WINDesc,WINUsedFlag,WINDocument,WINScore")
{
SELECT WIN_RowID,WIN_Code,WIN_Desc,WIN_UsedFlag,WIN_Document,WIN_Score
FROM SQLUser.SS_UserDefWindow
}

/// Log 30206 - AI - 06-12-2002 : Created this query to perform the Find By Code or Description. Called by the FindByDesc Execute/Fetch/Close.
/// Log 32797 - AI - 26-03-2003 : Also get the new field WIN_WindowGroup_DR.
/// ab 11.05.06 52166 - only return q'nares with 'web flag'
Query FindByCodeOrDesc(code As %String, description As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,WINCode:%String,WINDesc:%String,WINDocument:%String,WINScore:%String,WINUsedFlag:%String,WINWindowGroupDR:%String,WINGenerateError:%String,WINGRPDesc:%String,WINLastGenDate:%Date,WINLastGenTime:%Time,SSUSRDesc:%String,HOSPDesc:%String,WINInactive:%String")
{
SELECT WIN_RowId, WIN_Code, WIN_Desc, WIN_Document, WIN_Score, WIN_UsedFlag, WIN_WindowGroup_DR, WIN_GenerateError, WIN_WindowGroup_DR->WINGRP_Desc, WIN_LastGenDate, WIN_LastGenTime, WIN_LastGenUser_DR->SSUSR_Name, WIN_LastGenHospital_DR->HOSP_Desc, WIN_Inactive
FROM SS_UserDefWindow
WHERE ( ((%ALPHAUP WIN_Code %STARTSWITH %ALPHAUP :code) OR (:code IS NULL))
  AND   ((%ALPHAUP WIN_Desc %STARTSWITH %ALPHAUP :description) OR (:description IS NULL))
  AND (WIN_WebFlag = 'Y')
  )
ORDER BY WIN_Desc
}

Query FindComponent(code As %String, description As %String, groups As %String, HideInactive As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,WINCode:%String,WINDesc:%String,WINUsedFlag:%String,WINDocument:%Library.String,WINScore:%Library.String,HasComponent:%String,IsRecentVersion:%String,Status:%String,WINGenerateError:%Library.String,WINGRPDesc:%String,WINLastGenDate:%Date,WINLastGenTime:%Time,WINLastGenUser:%String,WINLastGenHosp:%String,WINInactive:%String")
{
}

Query LookUpAll(code As %String = "") As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,WINCode:%String,WINDesc:%String")
{
}

/// Log 32797 - AI - 26-03-2003 : Created this query to Find all SSGroupUDWGroups
///   that have a SSGroup that matches the passed-in SSUser.SSGroup.
/// Called by the FindComponent Execute method.
Query FindUDWGroupByUserGroup(usergroup As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "WINGRPRowId,WINGRPCode:%String,WINGRPDesc:%String")
{
SELECT RESRR_UDWGroup_DR->WINGRP_RowId,
 RESRR_UDWGroup_DR->WINGRP_Code,
 RESRR_UDWGroup_DR->WINGRP_Desc
FROM SS_GroupUDWGroup
WHERE (RESRR_ParRef = :usergroup) OR (RESRR_ParRef IS NULL)
ORDER BY   RESRR_UDWGroup_DR->WINGRP_Desc
}

/// Log 32797 - AI - 26-03-2003 : Created this query to Find all SSGroupUDWGroups
///   that have a SSGroup that matches the passed-in SSUser.SSGroup.
/// Called by the FindComponent Execute method.
Query FindUDWGroups(desc As %String) As %SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT WINGRP_Desc,WINGRP_RowId,WINGRP_Code
FROM SS_UserDefWinGroup
WHERE (%ALPHAUP WINGRP_Desc %STARTSWITH %ALPHAUP :desc)
}

Query VBFindLE(desc As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,WINDesc:%Library.String")
{
SELECT WIN_RowId, WIN_Desc
FROM SS_UserDefWindow
WHERE (WIN_Desc %STARTSWITH :desc)
ORDER BY WIN_Desc
}

Query VBFindLESimple(desc As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,WINDesc:%Library.String")
{
SELECT WIN_RowId, WIN_Desc
FROM SS_UserDefWindow
WHERE (WIN_Desc %STARTSWITH :desc)
ORDER BY WIN_Desc
}

}
