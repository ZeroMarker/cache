Include (webimport, TRAK)

IncludeGenerator (webimport, TRAK)

Class web.MRAdm Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 5322;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "MRADM_RowId";

Parameter SQLDESCRIPTION = "MRADM_RowId";

Parameter SQLROWID = "MRADM_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod CheckAbnormalResult(EpisodeID As %Library.String, Desc As %Library.String = "") As %Library.String
{
}

ClassMethod CheckAllResultRestrictions(OrderID As %String = "", StatusCode As %String = "") As %String
{
}

ClassMethod GetCPDates(MRAdm As %Library.String = "") As %Library.String
{
}

ClassMethod DisplayReadUnreadIcon(ResultStatus As %String = "", OrderID As %String = "", RESDateRead As %String = "", Status As %String = "") As %String
{
}

/// Log 56658 YC - Formats Logical data to html
/// Created for questionnaires
/// otherparams is used currently for code tables -> codetable name
ClassMethod TypeLogicalToHtml(data As %String = "", type As %String = "", otherparams As %String = "", winconID As %String = "") As %String
{
}

ClassMethod QuestionnaireClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QuestionnaireExecute ]
{
	Set repid = $LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QuestionnaireExecute(ByRef QHandle As %Binary, EpisodeID As %String) As %Status
{
	Set repid = $I(^CacheTemp)
	s ind = 1
	
	Quit $$$OK
}

ClassMethod QuestionnaireFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuestionnaireExecute ]
{
	Set AtEnd = $LIST(QHandle,1)
 	Set repid = $LIST(QHandle,2)
 	Set ind = $LIST(QHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {			
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query Questionnaire(EpisodeID As %String) As %Query(CONTAINID = 2, ROWSPEC = "QuestionnaireCode:%String,ID:%String,QuestionnaireID:%String,QuestionnaireDesc:%String,Date:%String,Time:%String,User:%String,CreateDate:%String,CreateTime:%String,CreateUser:%String,Score:%String,PatientID:%String,EpisodeID:%String,mradm:%String,QuesAndAns:%String,EpisodeNo:%String,Status:%String,SigCol1:%String,SigCol2:%String,SigCol3:%String,SigCol4:%String,SigCol5:%String,SigCol6:%String,SigCol7:%Date,SigCol8:%Date")
{
}

/// CJB 02/09/2002 - 26379
/// Purpose - To return a string of 0 and 1 respresenting if there is information behind the links.  The pieces 
/// are as follows - 
/// 1 -PsychDetails (link on PAAdm.Edit)
/// by wuqk 2011-06-21 未实现??
ClassMethod BoldLinks(mradm As %Library.String)
{
	quit "0^"
}

ClassMethod FindCommentActionClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindCommentActionFetch ]
{
}

ClassMethod FindCommentActionExecute(ByRef QHandle As %Library.Binary, table As %Library.String = "", tablerowid As %Library.String = "", fieldno As %Library.String = "") As %Library.Status
{
}

ClassMethod FindCommentActionFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindCommentActionExecute ]
{
}

ClassMethod FindViewedByClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindViewedByFetch ]
{
	n repid
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindViewedByExecute(ByRef QHandle As %Library.Binary, RequestID As %Library.String = "", ComponentID As %Library.String = "") As %Library.Status
{
	n repid
	
	Set RequestID=$Get(RequestID),ComponentID=$Get(ComponentID)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1

	s id="" f  s id=$o(^websys.LogI("ReferenceId",$c(32)_ComponentID,$c(32)_RequestID,id)) q:id=""  d
	.s str=$g(^websys.LogD(id))
	.s UserDr=$li(str,5)
	.s AudDate=$li(str,1)
	.//i $l(AudDate) s AudDate=$zd(AudDate,3)
	.s AudTime=$li(str,2)
	.//i $l(AudTime) s AudTime=$zt(AudTime)
	.s loc=$li(str,22)
	.s (CPTDr,CPTType,CPTTypeDesc)=""
	.i $l(UserDr),$d(^SSU("SSUSR",UserDr)) s CPTDr=$p(^SSU("SSUSR",UserDr),"^",14)
	.i $l(CPTDr),$d(^CTPCP(CPTDr)) s CPTType=$p(^CTPCP(CPTDr,1),"^",4)
	.i $l(CPTType),$d(^CT("CPT",CPTType)) s CPTTypeDesc=$p(^CT("CPT",CPTType),"^",2)
	.d OutputRow
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(UserDr,AudDate,AudTime,CPTTypeDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit $$$OK
}

ClassMethod FindViewedByFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindViewedByExecute ]
{
	n repid
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

/// This program gets ALL Episode (PAAdm) details required for floorplan.
/// These variables are all put into an array called ARY().
ClassMethod GetArrayDetails(mradm As %Library.String, ByRef ARY As %Library.String)
{
}

/// Return the episode/admission id given the mradmid
ClassMethod GetEpisodeId(mradm As %String) As %String
{
}

ClassMethod GetGPConsent(EpisodeID As %Library.String = "") As %Library.String
{
}

/// Get the order id from rm adm id.
/// For now direct global access !
/// by wuqk 2011-06-08
ClassMethod GetOrderId(mradmid As %String) As %String
{
	n EpisodeID,oeordID
	set EpisodeID=$p($g(^MR(mradmid,"PRO",1)),"^",9)
	quit:EpisodeID="" ""
	set oeordID=$o(^OEORD(0,"Adm",EpisodeID,0))
	quit oeordID
}

/// Return the patient ID based on the MRAdm ID
ClassMethod GetPatientId(mradmid As %String) As %String
{
}

/// Log 27725 - AI - 04-09-2002 : Method overhauled to return the Result Types to the epr.CTIconAssociation.Edit
/// 			setup of GotAnyResults (Results Read) icon.
/// 
/// 	***** The UNREAD version is web.OEOrdItem.getUnReadResultCat *****
/// 
/// Method was as follows before the overhaul:
/// 
/// 	//Called From condition expression in epr.CTIconAssociation.
/// 	;
/// 	;check associated file results, eg word,dicom
/// 	&SQL( SELECT RES_RowID FROM SQLUser.OE_OrdResult
/// 		WHERE (RES_ParRef->OEORI_OEORD_ParRef->OEORD_Adm_DR=:EpisodeID)
/// 		AND ((RES_ResStat_DR->RESST_Code="V") OR (RES_ResStat_DR->RESST_Code="P") OR (RES_ResStat_DR->RESST_Code="C"))
/// 		AND (RES_Type IS NOT NULL)
/// 	)
/// 	i 'SQLCODE q 1
/// 	;
/// 	;check lab results
/// 	&SQL( SELECT OEORI_RowID FROM SQLUser.OE_OrdItem 
/// 		WHERE (OEORI_OEORD_ParRef->OEORD_Adm_DR = :EpisodeID) 
/// 		AND (OEORI_LabTestSetRow IS NOT NULL)
/// 		AND	(OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_ExecCateg_DR->EXEC_Code="LAB")
/// 	)
/// 	i 'SQLCODE q 1
/// 	;
/// 	;check text results
/// 	&SQL( SELECT TRES_RowID FROM SQLUser.OE_OrdTextResult
/// 		WHERE (TRES_ParRef->OEORI_OEORD_ParRef->OEORD_Adm_DR = :EpisodeID)
/// 		AND ((TRES_OETR_DR->TR_RESStat_DR->RESST_Code="V") OR (TRES_OETR_DR->TR_RESStat_DR->RESST_Code="P") OR (TRES_OETR_DR->TR_RESStat_DR->RESST_Code="C"))	
/// 	)
/// 	i 'SQLCODE q 1
/// 	;
/// 	q 0
/// 
ClassMethod GotUnReadResults(EpisodeID As %Library.String, ByRef descr As %Library.String = "") As %Library.Boolean
{
}

/// Log 50515 YC - Method to display icon definition with code: "AbnormalUnsignedResult". 
/// This icon will display if there are abnormal results that have not been read.
ClassMethod GotAbnormalUnReadResults(EpisodeID As %Library.String, ByRef descr As %Library.String = "") As %Library.Boolean
{
}

ClassMethod GotReadResults(EpisodeID As %Library.String, ByRef descr As %Library.String = "") As %Library.Boolean
{
}

ClassMethod GotAnyResults(EpisodeID As %Library.String, ByRef descr As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpOrderItemBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", catgID As %Library.String = "", EpisodeID As %Library.String = "", PatientID As %Library.String = "", EpisodesAll As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpOrderItemClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpOrderItemFetch ]
{
}

ClassMethod LookUpOrderItemExecute(ByRef QHandle As %Library.Binary, val As %Library.String = "", catgID As %Library.String = "", EpisodeID As %Library.String = "", PatientID As %Library.String = "", EpisodesAll As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpOrderItemFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpOrderItemExecute ]
{
}

ClassMethod ResultsExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String = "", EpisodeID As %String = "", catgsID As %Library.String = "", dfrom As %Library.String = "", dto As %Library.String = "", EpisodesAll As %Library.String = "", ResultDisplayFlags As %Library.String = "", userid As %Library.String = "", SearchCriteria As %Library.String = "", noCats As %Library.String = "N", ResultStatusList As %Library.String = "") As %Library.Status
{
	n repid
	Set repid = $I(^CacheTemp)
	s ind = 1
	
	Quit $$$OK
}

ClassMethod ResultsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ResultsExecute ]
{
	Set AtEnd = $LIST(QHandle,1)
 	Set repid = $LIST(QHandle,2)
 	Set ind = $LIST(QHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {			
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetRow(rowid, EpisodeID, catgsID, CanViewSensitiveResults, DisplayTagResultsOnly = "", DisplayUnreadResultsOnly = "", DisplayAtomicResults, DisplayDicomResults, DisplayImageResults, DisplayTextResults, DisplayWordResults, DisplayWordFormat, DisplayUnverifiedResultsOnly = "", dfrom = "", dto = "", EpisodesAll = "", SearchStatusID = "", selsubcatids = "", noCats = "N", ResultStatusList = "", ResultsLinkCaption = "Results", PreviousResultCaption = "Previous Results")
{
}

ClassMethod ResultsClose(QHandle As %Library.Binary) As %Library.Status
{
	n repid
	Set repid = $LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Author - John Hart
/// Purpose - To fetch the Results for a certain Tabular Profile
/// Used by - EPR
ClassMethod ResultsTabularListClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ResultsTabularListFetch ]
{
}

ClassMethod ResultTabularComment(OrderID As %Library.String, EpisodeID As %Library.String, ResultStatusList As %Library.String) As %Library.Status
{
}

ClassMethod GetTestList(arcim As %Library.String, OrderID As %Library.String, EpisodeID As %Library.String, ReturnComments As %Library.String, ReturnOrderIDs As %String, OrderIDs As %String, OnlyThisOrderID, ReturnFULLTestRowID, ResultStatusList As %String = "") As %Library.String
{
}

ClassMethod GetTests(EpisodeID As %String, OrderID As %String, TestCode As %String, ResultStatusList As %String) As %String
{
}

/// Author - John Hart
/// Purpose - To fetch the Results for a certain Tabular Profile
/// Used by - EPR
/// ResultDetails and ResultType are NOT used by this query.  
/// They are added to the query parameter list so generated code can use these 
/// to pass a query string to the hidden print field used by OEORDItem.TabularResultsEMR
ClassMethod ResultsTabularListExecute(ByRef QHandle As %Library.Binary, LabEpisodeID As %Library.String, ID As %Library.String, markasread As %Library.String = "", userid As %Library.String = "", ResultDetails As %Library.String, ResultType As %Library.String, EpisodeID As %Library.String, ResultStatusList As %Library.String) As %Library.Status
{
}

/// Author - John Hart
/// Purpose - To fetch the lab orders for a certain Lab Order Profile
/// Used by - EPR
ClassMethod ResultsTabularListFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ResultsTabularListExecute ]
{
}

/// Author - John Hart
/// Purpose - To fetch the lab orders for a certain Lab Order Profile
/// Used by - EPR
ClassMethod SortTestItemsInSequence(TestItemList As %Library.String = "", OrderID As %Library.String = "") As %Library.String
{
}

ClassMethod OutPutResultLists(MaxRes As %String, CONTEXT As %String)
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeReadResults(compref As %String, ByRef id As %String, type As %String) As %Boolean
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

/// Log 50701 Yvonne
/// Method no longer used - replaced by websysSaveReadResults
ClassMethod websysReadAllResults(compref As %Library.String, ttype As %Library.String)
{
}

/// Log 50701 Yvonne - Rewriting Save for OEOrdItemTabular*
/// Saves details on the page into a temporary global
/// Called from Next/Prev/UpdateAndNext buttons from OEOrdItem.Tabular* Components
ClassMethod websysSaveNextPrev(compref As %String, id As %Library.String = "", cc As %String)
{
}

/// Log 50701 Yvonne - Rewriting Save for Cumulative
/// Saves details on the page into a temporary global
/// Called from OEOrdItem.ListCumulativePopup
ClassMethod websysSaveNextPrevCumm(compref As %String, id As %Library.String = "", cc As %String)
{
}

ClassMethod GetOIDsFromTestSet(TestSetRowIDs As %Library.String) As %String
{
}

/// Log 50514 - AI - 08-03-2005 : Almost a copy of the GetOIDsFromTestSet method above.
///   Differs from above in that ANY CAN be viewed instead of ALL MUST be viewed.
ClassMethod GetAnyOIDsFromTestSet(TestSetRowIDs As %Library.String) As %String
{
}

/// Log 50701 Yvonne
/// Method no longer used - replaced by websysSaveReadResults
ClassMethod websysReadResults(compref As %Library.String, id As %Library.String, type As %Library.String, PatientID As %Library.String, mradm As %Library.String, catgsID As %Library.String, datefrom As %Library.String, dateto As %Library.String, EpisodesAll As %Library.String, EpisodeID As %Library.String, TaggedOnly As %Library.String)
{
}

/// NEW ROUTINE
/// MADE BY PIPPY 8/7/05
/// TO TRY AND RE-WRITE THE HIDEOUS LOGIC FOR READING/UNREADING RESULTS...
ClassMethod NEWReadResult(SessionId, counter, ttype, ByRef zmessage, ByRef scnt)
{
}

/// Log 50701 Yvonne - Rewrite OEOrdItem.Tabular* Save
/// Saves reading information, used for update, update all, unreading 
/// for OEOrdItem.ListCumulativePopup and OEOrdItem.Tabular* components.
ClassMethod websysSaveReadResults(compref As %Library.String, ttype As %Library.String)
{
}

/// 撤消最终结算
ClassMethod websysReverseDischarge(compref As %Library.String, id As %Library.String)
{
	s EpisodeID=%request.Get("EpisodeID")
	s userId = %session.Get("LOGON.USERID")
	s reverseDesc = %request.Get("RFDDesc")
	S reverseReasonId = ##class(web.PACReasonForReverseFinDisch).GetIdFromCodeOrDescription(reverseDesc)
	;P5的wanghcAdd
	d ##class(web.DHCADTDischarge).PAAdmReverseFinalDischarge(EpisodeID, userId, reverseReasonId)
	q $$$OK
}

ClassMethod websysSaveFollowUpReason(id As %Library.String)
{
}

ClassMethod websysSavePatientEnq(compref As %Library.String, id As %Library.String)
{
}

ClassMethod GetTaggedOIDs(TestSetRowIDs As %String, ByRef OrdArr As %String, UnTagged As %String, SelectedID)
{
}

///  Called from EpVisitNumber.GetOrderItemDetails
ClassMethod GetTaggedUnTagged(LabEpisodeID, OrderID As %String, EpisodeID As %String, ByRef TaggedRowIDs As %String, ByRef UnTaggedRowIDs As %String, ResultStatusList As %String)
{
}

ClassMethod websysUnreadResults(compref As %Library.String, id As %Library.String, type As %Library.String)
{
}

ClassMethod UnreadResults(compref As %Library.String, id As %Library.String, type As %Library.String, tagged, untagged, ResultFormat = "", counter)
{
}

/// Log 55973 - PC - 19-12-2005 : Save the selected rows as either "Include in DS Report" or "Exclude From DS Report".
ClassMethod IncludeExcludeDSReport(action As %Library.String = "E", RowIDs As %Library.String = "")
{
}

Query FindAllFieldChanges(table As %String, tablerowid As %String, userfield As %String, datefield As %String, timefield As %String, actionfield As %String, commentfield As %String, unreaduserfield As %String, unreaddatefield As %String, unreadtimefield As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID:%String,FLDOldValue:%String,FLDValue:%String,FLDFieldNo")
{
SELECT FLD_RowId,FLD_OldValue,FLD_Value,FLD_FieldNo
FROM SQLUser.SS_AuditTrailFields
WHERE (FLD_ParRef->AUD_Table = :table) 
AND (FLD_ParRef->AUD_TableRowId = :tablerowid)
AND ((FLD_FieldNo = :userfield) 
 OR (FLD_FieldNo = :datefield) 
 OR (FLD_FieldNo = :timefield)
 OR (FLD_FieldNo = :unreaduserfield) 
 OR (FLD_FieldNo = :unreaddatefield) 
 OR (FLD_FieldNo = :unreadtimefield)
 OR (FLD_FieldNo = :actionfield) 
 OR (FLD_FieldNo = :commentfield))
AND (FLD_ParRef->AUD_Date IS NOT NULL) 
ORDER BY FLD_ParRef->AUD_Date ASC, FLD_ParRef->AUD_Time ASC
}

Query FindByPAADM(EpisodeID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,MRADMDate:%Date")
{
SELECT MRADM_Rowid, MRADM_Date
FROM MR_Adm
WHERE (MRADM_ADM_DR = :EpisodeID)
}

Query FindCommentAction(table As %String, tablerowid As %String, fieldno As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ID,SSUSRName,AUDDate,AUDTime,FLDOldValue,FLDValue,Action,Comment,CTCPTDesc")
{
}

Query FindFieldChanges(table As %String, tablerowid As %String, fieldno As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID:%String,SSUSRName:%String,AUDDate:%String,AUDTime:%String,FLDOldValue:%String,FLDValue:%String")
{
SELECT FLD_RowId,
 FLD_ParRef->AUD_User_DR->SSUSR_Name,
 FLD_ParRef->AUD_Date,
 FLD_ParRef->AUD_Time,
 FLD_OldValue,FLD_Value
FROM SQLUser.SS_AuditTrailFields
WHERE (FLD_ParRef->AUD_Table = :table) 
AND (FLD_ParRef->AUD_TableRowId = :tablerowid)
AND (FLD_FieldNo = :fieldno)
AND (FLD_ParRef->AUD_Date IS NOT NULL)
ORDER BY FLD_ParRef->AUD_Date ASC, FLD_ParRef->AUD_Time ASC
}

/// Author - John Hart
/// Purpose - To return all results and unread results for a careprovider
Query FindResultsForCareProv(CareProvID As %String, NotViewedBy As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,Description,DateCreated:%Date,TimeCreated:%Time,ResName,Status,ResType,RESDateRead,OtherRowid")
{
}

/// Author - John Hart
/// Purpose - To return all results and unread results for a location
Query FindResultsInLoc(LocID As %String, NotViewedBy As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,Description,DateCreated:%Date,TimeCreated:%Time,ResName,Status,ResType,RESDateRead,OtherRowid")
{
}

/// Author - John Hart
/// Purpose - To return all results and unread results for a ward
Query FindResultsInWard(WardID As %String, NotViewedBy As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,Description,DateCreated:%Date,TimeCreated:%Time,ResName,Status,ResType,RESDateRead,OtherRowid")
{
}

Query FindViewedBy(RequestID As %String, ComponentID As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "UserDR,AuditDate,AuditTime,CTCPTDesc")
{
}

Query LookUpOrderItem(val As %String, catgID As %String, EpisodeID As %String, PatientID As %String, EpisodesAll As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Description:%String,Code:%String")
{
}

Query PhysMeasureEdit(ID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,MRADMWeight:%String,MRADMHeight:%String,MRADMWaistCircumference:%String,MRADMHeadCircumference:%String,MRADMVisionScoreLeft:%String,MRADMVisionScoreRight:%String,MRADMBloodSugarTestResult:%String,MRADMUrineSugarTestResult:%String,MRADMTemp:%String,MRADMPulseRate:%String,MRADMResp:%String,MRADMBPSystolic:%String,MRADMBPDiastolic:%String,MRADMKidneyTransplant:%String,MRADMKidneyTranspDes:%String")
{
SELECT MRADM_RowID, MRADM_Weight, MRADM_Height, MRADM_WaistCircumference, MRADM_HeadCircumference, MRADM_VisionScoreLeft, MRADM_VisionScoreRight, MRADM_BloodSugarTestResult, MRADM_UrineSugarTestResult, MRADM_Temp, MRADM_PulseRate, MRADM_Resp, MRADM_BPSystolic, MRADM_BPDiastolic, MRADM_KidneyTransplant, MRADM_KidneyTranspDes
FROM MR_Adm
WHERE (MRADM_RowID = :ID)
}

/// Query to retrieve data from multiple tables:
/// OEOrdResult,OEOrdTextResult,OEOrdItem
Query Results(PatientID As %String, EpisodeID As %String, catgsID As %String, dfrom As %String, dto As %String, EpisodesAll As %String, ResultDisplayFlags As %String, userid As %String, SearchCriteria As %String, noCats As %String, ResultStatusList As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,Description,DateCreated:%Date,TimeCreated:%Time,ResName,StatusCode,Status,ResType,RESDateRead,OtherRowid,FileName,EpisodeNo,OEORIDateExecuted,CareProv,OEORILabEpisodeNo:%String,audittable:%String,auditfieldno:%String,auditid:%String,orderid:%String,componentid:%String,ARCICHL7ResultType:%String,CollectionDate,CollectionTime,OEORIEpisArriveDate,OEORIEpisArriveTime,OEORISttDat,OEORISttTim,ResultDate,ResultTime,FillerNo,LabStatusCode:%String,ExternalSystemCode:%String,Dicom,OEORILabAction,OSTATDesc,RESUserVerified,Abnormal,PreviousResult,UserCreated,RESAction,RESComment,OrderCategory:%String,DisplayWordFormat:%String,OEORICode:%String,ARCIMRowid:%String,OEORISeriesNo,REFDDesc,RESCPReported,RESCPVerified,TaggedRowIDs,UnTaggedRowIDs,MarkedAsSignificant,ResultAvailableDate:%Date,EVlink,RepCareProv:%String,Nata,RadStatus,OEORIResultDSReportFlag,ResultsLink")
{
}

/// Author - John Hart
/// Purpose - To fetch the Results for a certain Tabular Profile
/// Used by - EPR
Query ResultsTabularList(LabEpisodeNo As %String, OrderID As %String, markasread As %String, userid As %String, ResultDetails As %String, ResultType As %String, EpisodeID As %Library.String, ResultStatusList As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID:%String,OrderCode:%String,OrderName:%String,TestItem:%String,Flag:%String,Value:%String,Units:%String,RefRange:%String,Comments:%String,OrderTime:%Time,OrderDate:%Date,Status:%String,LabEpisodeID:%String,LabOrderCode:%String,TestItemCode:%String,Sensitive:%String,FillerNo:%String,audittable:%String,auditfieldno:%String,DoNotDisplay:%String,AllowStatus:%String,Tag:%String,DataRowID:%String,TestItemStatus:%String,OtherFlags:%String,FlagValue")
{
}

}
