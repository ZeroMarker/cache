Class DHCEPRFS.BL.BLReview Extends %RegisteredObject [ ProcedureBlock ]
{

/// Debug:	d ##Class(DHCEPRFS.web.eprajax.AjaxReview).SaveReasonCategory("1")
ClassMethod SaveReasonCategory(ACategoryID As %String, AReason As %String)
{
	q:(ACategoryID = "") "-1"
	
	s obj = ##class(DHCEPRFS.INST.ReviewReasonCategory).%OpenId(ACategoryID)
	s obj.Reason = AReason
	s sc = obj.%Save()
	if (sc)
	{
		q "1"	
	}
	else
	{
		q "0"	
	}
}

ClassMethod RemoveReasonCategory(ACategoryID As %String)
{
	q:(ACategoryID = "") "-1"
	
	s obj = ##class(DHCEPRFS.INST.ReviewReasonCategory).%OpenId(ACategoryID)
	s obj.Available = "N"
	s sc = obj.%Save()
	if (sc)
	{
		q "1"	
	}
	else
	{
		q "0"	
	}
}

ClassMethod AddReasonCategory(AUserID As %String, ACategory As %String, AReason As %String)
{
	s nowDate = $p($h,",",1)
	s nowTime = $p($h,",",2)
	s CategoryCode = AUserID_"_"_nowDate_"_"_nowTime
	
	s obj = ##class(DHCEPRFS.INST.ReviewReasonCategory).%New()
	s obj.Available = "Y"
	s obj.CategoryCode = CategoryCode
	s obj.CategoryDesc = ACategory
	s obj.CreateDate = nowDate
	s obj.CreateTime = nowTime
	s obj.Reason = AReason
	s obj.UserID = AUserID
	s sc = obj.%Save()
	if (sc)
	{
		q "1"	
	}
	else
	{
		q "0"	
	}
}

/// Debug:	d ##Class(DHCEPRFS.BL.BLReview).LoadReasonCategory("1")
Query LoadReasonCategory(AUserID As %String) As %Query(ROWSPEC = "CategoryID:%String,CategoryCode:%String,CategoryDesc:%String,Reason:%String")
{
}

ClassMethod LoadReasonCategoryExecute(ByRef qHandle As %Binary, AUserID As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	
	s date = ""
	for {
		s date = $o(^DHCEPRFS.INST.ReviewReasonCI("IdxMain"," Y"," "_AUserID,date))
		q:(date = "")
		
		s time = ""
		for {
			s time = $o(^DHCEPRFS.INST.ReviewReasonCI("IdxMain"," Y"," "_AUserID,date,time))
			q:(time = "")	
			
			s reviewReasonCategoryID = ""
			for {
				s reviewReasonCategoryID = $o(^DHCEPRFS.INST.ReviewReasonCI("IdxMain"," Y"," "_AUserID,date,time,reviewReasonCategoryID))
				q:(reviewReasonCategoryID = "")		
				
				s obj = ##class(DHCEPRFS.INST.ReviewReasonCategory).%OpenId(reviewReasonCategoryID)
				s categoryCode = obj.CategoryCode
				s categoryDesc = obj.CategoryDesc
				s reason = obj.Reason
				
				set ^CacheTemp(repid,ind) = $LB(reviewReasonCategoryID,categoryCode,categoryDesc,reason)
				set ind = ind + 1
			}	
		}	
	}
	
	Quit $$$OK
}

ClassMethod LoadReasonCategoryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LoadReasonCategoryExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod LoadReasonCategoryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LoadReasonCategoryExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// debug: w ##class(DHCEPRFS.BL.BLReview).TrakInfo(436)
ClassMethod TrakInfo(AEpisodeID As %String) As %String
{
	s ret = ""
	s admMRStatusID = $O(^DHCEPRFS.INST.AdmMRStatusI("IdxEpisodeID"," DHC"," "_AEpisodeID,""))
	q:(admMRStatusID = "") ""
	
	s date = ""
	for {
		s date = $O(^DHCEPRFS.INST.AdmMRStatusLogI("IdxStatusChangeDateTime"," "_admMRStatusID,date))
		q:(date = "")

		s time = ""
		for {
			s time = $O(^DHCEPRFS.INST.AdmMRStatusLogI("IdxStatusChangeDateTime"," "_admMRStatusID,date,time))
			q:(time = "")
			
			s admMRStatusLogID = ""
			for {
				s admMRStatusLogID = $O(^DHCEPRFS.INST.AdmMRStatusLogI("IdxStatusChangeDateTime"," "_admMRStatusID,date,time,admMRStatusLogID))
				q:(admMRStatusLogID = "")
				
				s objLog = ##class(DHCEPRFS.INST.AdmMRStatusLog).%OpenId(admMRStatusLogID)	
				s actDate = objLog.ChangeDate
				s actTime = objLog.ChangeTime
				s actUserID = objLog.ChangeUserID
				s actType = objLog.Type
				s actAct = objLog.ChangeAct
				s actMessage = objLog.Message
				
				s actUserName = ""
				s:(actUserID '= "") actUserName = $p($g(^SSU("SSUSR",actUserID)),"^",2)
				s:(actDate '= "") actDate = $zd(actDate,3)
				s:(actTime '= "") actTime = $zt(actTime,1)
				
				s oneRet = actDate_"^"_actTime_"^"_actUserName
				if (actAct = "COMPLETE")
				{
					if (actType = "DOCTOR")
					{
						s oneRet = oneRet_"^black^完成(医生)^"_actMessage
					}
					else
					{
						s oneRet = oneRet_"^black^完成(护士)^"_actMessage
					}
				}
				elseif (actAct = "BACK")
				{
					if (actType = "DOCTOR")
					{
						s oneRet = oneRet_"^red^退回(医生)^"_actMessage
					}
					else
					{
						s oneRet = oneRet_"^red^退回(护士)^"_actMessage
					}		
				}
				elseif (actAct = "DEPTBACK")
				{
					if (actType = "DOCTOR")
					{
						s oneRet = oneRet_"^red^科室退回(医生)^"_actMessage
					}
					else
					{
						s oneRet = oneRet_"^red^科室退回(护士)^"_actMessage
					}		
				}
				elseif (actAct = "QCBACK")
				{
					if (actType = "DOCTOR")
					{
						s oneRet = oneRet_"^red^质控科退回(医生)^"_actMessage
					}
					else
					{
						s oneRet = oneRet_"^red^质控科退回(护士)^"_actMessage
					}		
				}
				elseif (actAct = "DEPTREVIEWED")
				{
					s oneRet = oneRet_"^green^科室复核通过^"_actMessage	
				}
				elseif (actAct = "QCREVIEWED")
				{
					s oneRet = oneRet_"^green^质控科复核通过^"_actMessage	
				}
				else
				{
					s oneRet = oneRet_"^green^复核通过^"_actMessage
				}
				
				if (ret = "")
				{
					s ret = oneRet	
				}
				else
				{
					s ret = ret_"|"_oneRet	
				}
			}	
		}	
	}
	q ret
}

/// Desc: 病案室、质控科查询住院患者就诊列表
///       ACTLocID：可选参数，若不为空，则表示仅显示本科室的患者
///       AType：MR||U - 病案室未审核，MR||F - 病案室已审核，MR||B - 病案室已退回，QC||U - 质控科未审核，QC||F - 质控科已审核，QC||B - 质控科已退回，A - 全部
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLReview","GetEpisodeList","MR||U","2017-3-1","2017-6-30","","","","")
Query GetEpisodeList(AType As %String, AStartDate As %String, AEndDate As %String, AMedRecordNo As %String, ARegNo As %String, AName As %String, ACTLocIDS As %String = "", ADocCommit As %String = "a", ANurCommit As %String = "a", APDFCreated As %String = "a") As %Query(ROWSPEC = "EpisodeID:%String,PatientID:%String,MedRecordNo:%String,RegNo:%String,PAPMIName:%String,PAPMIDOB:%String,PAPMISex:%String,AdmDateTime:%String,DisDateTime:%String,PAAdmDepCodeDR:%String,PAAdmDocCodeDR:%String,PAADMReason:%String,Warddesc:%String,EprDocStatus:%String,EprDocStatusDesc:%String,EprNurStatus:%String,EprNurStatusDesc:%String,EprPdfStatus:%String,EprPdfStatusDesc:%String,ReviewStatus:%String,QCDeptStatus:%String,DeptStatus:%String,CheckStatus:%String,CheckRule:%String,CheckDateTime:%String,CheckUser:%String,BackMessage:%String,Remarks:%String,SubmitMessage:%String,ScanStatus:%String,CodeStatus:%String,MRRemarks:%String,BackCount:%String,QCDeptBackCount:%String,DeptBackCount:%String")
{
}

ClassMethod GetEpisodeListExecute(ByRef qHandle As %Binary, AType As %String, AStartDate As %String, AEndDate As %String, AMedRecordNo As %String, ARegNo As %String, AName As %String, ACTLocIDS As %String = "", ADocCommit As %String = "a", ANurCommit As %String = "a", APDFCreated As %String = "a") As %Status
{
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	
	s:(ACTLocIDS = $c(0)) ACTLocIDS = ""
	s:(AStartDate '= "") startDate = $zdh(AStartDate,3)
	s:(AEndDate '= "") endDate = $zdh(AEndDate,3)
	s:(AMedRecordNo = $c(0)) AMedRecordNo = ""
	s:(ARegNo = $c(0)) ARegNo = ""
	s:(AName = $c(0)) AName = ""
	
	if (AMedRecordNo '= "")
	{
		s AMedRecordNo = $zcvt(AMedRecordNo,"U")
		if (ACTLocIDS '= "")
		{
			f i=1:1:$l(ACTLocIDS,",")
			{
				s admDepID = $p(ACTLocIDS,",",i)
				s rowID = ""
				f {
					s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxMedRecordNo"," I"," "_AMedRecordNo," "_admDepID,rowID))
					q:(rowID = "")
					d GetEpisodeList
				}
			}
		}
		else
		{
			s admDepID = ""
			f {
				s admDepID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxMedRecordNo"," I"," "_AMedRecordNo,admDepID))
				q:(admDepID = "")
				s rowID = ""
				f {
					s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxMedRecordNo"," I"," "_AMedRecordNo,admDepID,rowID))
					q:(rowID = "")
					d GetEpisodeList
				}
			}
		}
	}
	elseif (ARegNo '= "")
	{
		s ARegNo = ..AddZero(ARegNo)
		if (ACTLocIDS '= "")
		{
			f i=1:1:$l(ACTLocIDS,",")
			{
				s admDepID = $p(ACTLocIDS,",",i)
				s rowID = ""
				f {
					s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxRegNo"," I"," "_ARegNo," "_admDepID,rowID))
					q:(rowID = "")
					d GetEpisodeList
				}
			}
		}
		else
		{
			s admDepID = ""
			f {
				s admDepID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxRegNo"," I"," "_ARegNo,admDepID))
				q:(admDepID = "")
				s rowID = ""
				f {
					s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxRegNo"," I"," "_ARegNo,admDepID,rowID))
					q:(rowID = "")
					d GetEpisodeList
				}
			}
		}
	}
	elseif (AName '= "")
	{
		s AName = $zcvt(AName,"U")
		if (ACTLocIDS '= "")
		{
			f i=1:1:$l(ACTLocIDS,",")
			{
				s admDepID = $p(ACTLocIDS,",",i)
				s rowID = ""
				f {
					s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxName"," I"," "_AName," "_admDepID,rowID))
					q:(rowID = "")
					d GetEpisodeList
				}
			}
		}
		else
		{
			s admDepID = ""
			f {
				s admDepID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxName"," I"," "_AName,admDepID))
				q:(admDepID = "")
				s rowID = ""
				f {
					s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxName"," I"," "_AName,admDepID,rowID))
					q:(rowID = "")
					d GetEpisodeList
				}
			}
		}
	}
	elseif (AType '= "A")
	{
		s groupType = $p(AType,"||",1)
		s filterType = $p(AType,"||",2)
		if (ACTLocIDS '= "")
		{
			f i=1:1:$l(ACTLocIDS,",")
			{
				s admDepID = $p(ACTLocIDS,",",i)
				s date = startDate - 1
				f {
					s date = $o(^DHCEPRFS.INST.CheckedPatListI("Idx"_groupType_"ReviewStatus"," I"," "_filterType," "_admDepID,date))
					q:((date = "")||(date > endDate))
					s rowID = ""
					f {
						s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("Idx"_groupType_"ReviewStatus"," I"," "_filterType," "_admDepID,date,rowID))
						q:(rowID = "")
						d GetEpisodeList
					}
				}
			}
		}
		else
		{
			s admDepID = ""
			f {
				s admDepID = $o(^DHCEPRFS.INST.CheckedPatListI("Idx"_groupType_"ReviewStatus"," I"," "_filterType,admDepID))
				q:(admDepID = "")
				s date = startDate - 1
				f {
					s date = $o(^DHCEPRFS.INST.CheckedPatListI("Idx"_groupType_"ReviewStatus"," I"," "_filterType,admDepID,date))
					q:((date = "")||(date > endDate))
					s rowID = ""
					f {
						s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("Idx"_groupType_"ReviewStatus"," I"," "_filterType,admDepID,date,rowID))
						q:(rowID = "")
						d GetEpisodeList
					}
				}
			}
		}
	}
	elseif ((startDate '= "") && (endDate '= ""))
	{
		if (ACTLocIDS '= "")
		{
			f i=1:1:$l(ACTLocIDS,",")
			{
				s admDepID = $p(ACTLocIDS,",",i)
				s date = startDate - 1
				f {
					s date = $o(^DHCEPRFS.INST.CheckedPatListI("IdxDepIDCreateDate"," I"," "_admDepID,date))
					q:((date = "")||(date > endDate))
					s rowID = ""
					f {
						s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxDepIDCreateDate"," I"," "_admDepID,date,rowID))
						q:(rowID = "")
						d GetEpisodeList
					}
				}
			}
		}
		else
		{
			s admDepID = ""
			f {
				s admDepID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxDepIDCreateDate"," I",admDepID))
				q:(admDepID = "")
				s date = startDate - 1
				f {
					s date = $o(^DHCEPRFS.INST.CheckedPatListI("IdxDepIDCreateDate"," I",admDepID,date))
					q:((date = "")||(date > endDate))
					s rowID = ""
					f {
						s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxDepIDCreateDate"," I",admDepID,date,rowID))
						q:(rowID = "")
						d GetEpisodeList
					}
				}
			}
		}
	}
	
	q $$$OK
GetEpisodeList
	s objPat = ##class(DHCEPRFS.INST.CheckedPatList).%OpenId(rowID)
	s episodeID = objPat.EpisodeID
	s medRecordNo = objPat.MedRecordNo
	s regNo = objPat.RegNo
	s name = objPat.Name
	s paAdmDepID = objPat.PAAdmDepID
	s createDate = objPat.CreateDate
	s ruleCode = objPat.RuleCode
	s checkDate = objPat.CheckDate
	s checkTime = objPat.CheckTime
	s checkUserID = objPat.CheckUserID
	s type = objPat.ReviewStatus
	s qcType = objPat.QCReviewStatus
	s deptType = objPat.DeptReviewStatus
	s remarks = objPat.Remarks
	s mrRemarks = objPat.MRRemarks
	d objPat.%Close()
	
	//过滤出院病人
	s admStatus = $p($g(^PAADM(episodeID)),"^",20)
	q:(admStatus '= "D")
	
	//使用病案号、登记号、姓名进行查询时，过滤类型和出院日期
	if ((AMedRecordNo '= "")||(ARegNo '= "")||(AName '= ""))
	{
		if (AType '= "A")
		{
			q:((createDate < startDate)||(createDate > endDate))
			s groupType = $p(AType,"||",1)
			s filterType = $p(AType,"||",2)
			q:((groupType = "MR")&&(type '= filterType))
			q:((groupType = "QC")&&(qcType '= filterType))
			q:((groupType = "Dept")&&(deptType '= filterType))
		}
	}
	
	s patientID = $p($g(^PAADM(episodeID)),"^",1)
	s patDob = $p($g(^PAPER(patientID,"ALL")),"^",6)
	s:(patDob '= "") patDob = $zd(patDob,3)
	s patSexDR = $p($g(^PAPER(patientID,"ALL")),"^",7)
	s patSex = $p($g(^CT("SEX",patSexDR)),"^",2)
	
	s admDate = "", admTime = "", admDateTime = ""
	s paAdmDateTime = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetAdmDateTime(episodeID)
	s paAdmDate = $p(paAdmDateTime,",",1)
	s:(paAdmDate '= "") admDate = $zd(paAdmDate,3)
	s paAdmTime = $p(paAdmDateTime,",",2)
	s:(paAdmTime '= "") admTime = $zt(paAdmTime)
	s:(admDate '= "")&&(admTime '= "") admDateTime = admDate_" "_admTime
	s disDate = "", disTime = "", disDateTime = ""
	s paDisDateTime = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DisDateTime(episodeID)
	s paDisDate = $p(paDisDateTime,",",1)
	s:(paDisDate '= "") disDate = $zd(paDisDate,3)
	s paDisTime = $p(paDisDateTime,",",2)
	s:(paDisTime '= "") disTime = $zt(paDisTime)
	s:(disDate '= "")&&(disTime '= "") disDateTime = disDate_" "_disTime
	s paAdmDepCodeDR = ""
	if (paAdmDepID '= "")
	{
		s paAdmDepCodeDR = $p($g(^CTLOC(paAdmDepID)),"^",2)
		if ($l(paAdmDepCodeDR,"-")>1)
		{
			s paAdmDepCodeDR = $p(paAdmDepCodeDR,"-",2)
		}
	}
	s paAdmDocCodeDR = ""
	s paAdmDocCode = $p($g(^PAADM(episodeID)),"^",9)
	if (paAdmDocCode '= "")
	{
		s paAdmDocCodeDR = $p($g(^CTPCP(paAdmDocCode,1)),"^",2)
	}
	s paAdmReason = ""
	s paAdmReasonDR = $p($g(^PAADM(episodeID,1)),"^",7)
	if (paAdmReasonDR '= "")
	{
		s paAdmReason = $p($g(^PAC("ADMREA",paAdmReasonDR)),"^",2)
	}
	s wardDesc = ""
	s disWardDR = $p($g(^PAADM(episodeID)),"^",70)
	if (disWardDR '= "")
	{
		s wardDesc = $p($g(^PAWARD(disWardDR)),"^",2)
		if ($l(wardDesc,"-")>1)
		{
			s wardDesc = $p(wardDesc,"-",2)
		}
	}
	
	s eprStatus = ##Class(DHCEPRFS.BI.BIToWMR).GetMedRecordStatus(episodeID)
	s eprDocStatus = +$p(eprStatus,"^",2)
	s eprDocStatusDesc = $s(eprDocStatus=1:"是",1:"否")
	s eprNurStatus = +$p(eprStatus,"^",1)
	s eprNurStatusDesc = $s(eprNurStatus=1:"是",1:"否")
	s eprPdfStatus = +$p(eprStatus,"^",3)
	
	//过滤医生提交，护士提交，PDF生成
	q:((ADocCommit = "y") && (eprDocStatus '= 1))
	q:((ADocCommit = "n") && (eprDocStatus '= 0))
	q:((ANurCommit = "y") && (eprNurStatus '= 1))
	q:((ANurCommit = "n") && (eprNurStatus '= 0))
	q:((APDFCreated = "y") && (eprPdfStatus '= 1))
	q:((APDFCreated = "n") && (eprPdfStatus '= 0))
	
	if ((eprDocStatus = 1) && (eprNurStatus = 1) && (eprPdfStatus '= 1))
	{
		s eprPdfStatus=2
		s eprPdfStatusDesc="正在生成"
	}
	else
	{
		s eprPdfStatusDesc=$s(eprPdfStatus=1:"是",1:"否")
		if (eprDocStatus= "0")
		{
			s eprPdfStatus=0
			s eprPdfStatusDesc = "否"
		}
	}
	
	s reviewStatus = $s(type="U":"否",type="F":"是",type="B":"已退回",1:"")
	s qcReviewStatus = $s(qcType="U":"否",qcType="F":"是",qcType="B":"已退回",1:"")
	s deptReviewStatus = $s(deptType="U":"否",deptType="F":"是",deptType="B":"已退回",1:"")
	
	if ((ruleCode '= "")&&(ruleCode '= "0"))
	{
		s checkStatus = ..GetCheckStatus(episodeID)
		s:(checkStatus = "0") checkStatus = "否"
		s:(checkStatus = "1") checkStatus = "是"
		s checkRule = ##class(DHCEPRFS.BL.BLIntegrityCheck).GetRuleNameByCode(ruleCode)
		s checkDate = $zd(checkDate,3)
		s checkTime = $zt(checkTime)
		s checkDateTime = checkDate_" "_checkTime
		s checkUser = $p(^SSU("SSUSR",checkUserID),"^",2)
	}
	else
	{
		s checkStatus = "否"
		s checkRule = ""
		s checkDateTime = ""
		s checkUser = ""
	}
	
	s backCount = ..GetBackCount(episodeID)
	s backMessage = ..GetBackMessage(episodeID)
	s remarksInfo = ""
	if (remarks '= "")
	{
		s remarksInfo = ..FormatRemarks(remarks)
	}
	s submitMessage = ..GetSubmitMessage(episodeID)
	s scanStatus = ""
	
	s ^CacheTemp(repid,ind) = $lb(episodeID,patientID,medRecordNo,regNo,name,patDob,patSex,admDateTime,disDateTime,paAdmDepCodeDR,paAdmDocCodeDR,paAdmReason,wardDesc,eprDocStatus,eprDocStatusDesc,eprNurStatus,eprNurStatusDesc,eprPdfStatus,eprPdfStatusDesc,reviewStatus,qcReviewStatus,deptReviewStatus,checkStatus,checkRule,checkDateTime,checkUser,backMessage,remarksInfo,submitMessage,scanStatus,codeStatus,mrRemarks)_backCount
	s ind = ind + 1
	q
}

ClassMethod GetEpisodeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEpisodeListExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If ind = "" {				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
	}
	Else      {				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetEpisodeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEpisodeListExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 科室查询患者就诊列表
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLReview","GetDeptEpisodeList","U","2017-3-1","2017-6-30","","","","9")
Query GetDeptEpisodeList(AType As %String, AStartDate As %String, AEndDate As %String, AMedRecordNo As %String, ARegNo As %String, AName As %String, ACTLocIDS As %String = "", ADocCommit As %String = "a", ANurCommit As %String = "a", APDFCreated As %String = "a") As %Query(ROWSPEC = "EpisodeID:%String,PatientID:%String,MedRecordNo:%String,RegNo:%String,PAPMIName:%String,PAPMIDOB:%String,PAPMISex:%String,AdmDate:%String,AdmTime:%String,DisDate:%String,DisTime:%String,PAAdmDepCodeDR:%String,PAAdmDocCodeDR:%String,PAADMReason:%String,Warddesc:%String,EprDocStatus:%String,EprDocStatusDesc:%String,EprNurStatus:%String,EprNurStatusDesc:%String,EprPdfStatus:%String,EprPdfStatusDesc:%String,QCSignStatus:%String,QCSignStatusDesc:%String,ReviewStatus:%String,QCDeptStatus:%String,DeptStatus:%String,Remarks:%String,SubmitMessage:%String,SubmitCount:%String,BackMessage:%String,SubmitDocID:%String,SubmitNurID:%String")
{
}

ClassMethod GetDeptEpisodeListExecute(ByRef qHandle As %Binary, AType As %String, AStartDate As %String, AEndDate As %String, AMedRecordNo As %String, ARegNo As %String, AName As %String, ACTLocIDS As %String = "", ADocCommit As %String = "a", ANurCommit As %String = "a", APDFCreated As %String = "a") As %Status
{
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	
	Set langid=20  //登录语言
	If ($d(%session)){
		Set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	Set EnableTranslation=0  //翻译功能启用标识
	If (##class(%Dictionary.CompiledMethod).%ExistsId("User.Abstract||GetTranByDesc"))
	{
		Set EnableTranslation=1
	}
	
	s:(ACTLocIDS = $c(0)) ACTLocIDS = ""
	s:(AStartDate '= "") startDate = ##class(DHCEPRFS.Util.StringHelper).FormatLogicalDate(AStartDate)
	s:(AEndDate '= "") endDate = ##class(DHCEPRFS.Util.StringHelper).FormatLogicalDate(AEndDate)
	s:(AMedRecordNo = $c(0)) AMedRecordNo = ""
	s:(ARegNo = $c(0)) ARegNo = ""
	s:(AName = $c(0)) AName = ""
	s ctLocIDS = ACTLocIDS
	s linkLocIDS = ##class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetLinkLocID(ACTLocIDS)
	s:(linkLocIDS '= "") ctLocIDS = ctLocIDS_"^"_linkLocIDS
	
	if (AMedRecordNo '= "")
	{
		s AMedRecordNo = $zcvt(AMedRecordNo,"U")
		f i=1:1:$l(ctLocIDS,"^")
		{
			s admDepID = $p(ctLocIDS,"^",i)
			s rowID = ""
			f {
				s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxMedRecordNo"," I"," "_AMedRecordNo," "_admDepID,rowID))
				q:(rowID = "")
				d GetEpisodeList
			}
		}
	}
	elseif (ARegNo '= "")
	{
		s ARegNo = ..AddZero(ARegNo)
		f i=1:1:$l(ctLocIDS,"^")
		{
			s admDepID = $p(ctLocIDS,"^",i)
			s rowID = ""
			f {
				s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxRegNo"," I"," "_ARegNo," "_admDepID,rowID))
				q:(rowID = "")
				d GetEpisodeList
			}
		}
	}
	elseif (AName '= "")
	{
		s AName = $zcvt(AName,"U")
		f i=1:1:$l(ctLocIDS,"^")
		{
			s admDepID = $p(ctLocIDS,"^",i)
			s rowID = ""
			f {
				s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxName"," I"," "_AName," "_admDepID,rowID))
				q:(rowID = "")
				d GetEpisodeList
			}
		}
	}
	elseif (AType '= "A")
	{
		f i=1:1:$l(ctLocIDS,"^")
		{
			s admDepID = $p(ctLocIDS,"^",i)
			s date = startDate - 1
			f {
				s date = $o(^DHCEPRFS.INST.CheckedPatListI("IdxDeptReviewStatus"," I"," "_AType," "_admDepID,date))
				q:((date = "")||(date > endDate))
				s rowID = ""
				f {
					s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxDeptReviewStatus"," I"," "_AType," "_admDepID,date,rowID))
					q:(rowID = "")
					d GetEpisodeList
				}
			}
		}
	}
	elseif ((startDate '= "") && (endDate '= ""))
	{
		f i=1:1:$l(ctLocIDS,"^")
		{
			s admDepID = $p(ctLocIDS,"^",i)
			s date = startDate - 1
			f {
				s date = $o(^DHCEPRFS.INST.CheckedPatListI("IdxDepIDCreateDate"," I"," "_admDepID,date))
				q:((date = "")||(date > endDate))
				s rowID = ""
				f {
					s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxDepIDCreateDate"," I"," "_admDepID,date,rowID))
					q:(rowID = "")
					d GetEpisodeList
				}
			}
		}
	}
	
	q $$$OK
GetEpisodeList
	s objPat = ##class(DHCEPRFS.INST.CheckedPatList).%OpenId(rowID)
	s episodeID = objPat.EpisodeID
	s medRecordNo = objPat.MedRecordNo
	s regNo = objPat.RegNo
	s name = objPat.Name
	s paAdmDepID = objPat.PAAdmDepID
	s createDate = objPat.CreateDate
	s type = objPat.ReviewStatus
	s qcType = objPat.QCReviewStatus
	s deptType = objPat.DeptReviewStatus
	s remarks = objPat.Remarks
	d objPat.%Close()
	
	//过滤出院病人
	s admStatus = $p($g(^PAADM(episodeID)),"^",20)
	q:(admStatus '= "D")
	
	//使用病案号、登记号、姓名进行查询时，过滤类型和出院日期
	if ((AMedRecordNo '= "")||(ARegNo '= "")||(AName '= ""))
	{
		if (AType '= "A")
		{
			q:((createDate < startDate)||(createDate > endDate))
			q:(deptType '= AType)
		}
	}
	
	s patientID = $p($g(^PAADM(episodeID)),"^",1)
	s patDob = $p($g(^PAPER(patientID,"ALL")),"^",6)
	s:(patDob '= "") patDob = ##class(DHCEPRFS.Util.StringHelper).FormatDisplayDate(patDob)
	s patSexDR = $p($g(^PAPER(patientID,"ALL")),"^",7)
	s patSex = $p($g(^CT("SEX",patSexDR)),"^",2)
	
	s admDate = "", admTime = ""
	s paAdmDateTime = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetAdmDateTime(episodeID)
	s paAdmDate = $p(paAdmDateTime,",",1)
	s:(paAdmDate '= "") admDate = ##class(DHCEPRFS.Util.StringHelper).FormatDisplayDate(paAdmDate)
	s paAdmTime = $p(paAdmDateTime,",",2)
	s:(paAdmTime '= "") admTime = $zt(paAdmTime)
	s disDate = "", disTime = ""
	s paDisDateTime = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DisDateTime(episodeID)
	s paDisDate = $p(paDisDateTime,",",1)
	s:(paDisDate '= "") disDate = ##class(DHCEPRFS.Util.StringHelper).FormatDisplayDate(paDisDate)
	s paDisTime = $p(paDisDateTime,",",2)
	s:(paDisTime '= "") disTime = $zt(paDisTime)
	s paAdmDepCodeDR = ""
	if (paAdmDepID '= "")
	{
		s paAdmDepCodeDR = $p($g(^CTLOC(paAdmDepID)),"^",2)
		if ($l(paAdmDepCodeDR,"-")>1)
		{
			s paAdmDepCodeDR = $p(paAdmDepCodeDR,"-",2)
		}
	}
	s paAdmDocCodeDR = ""
	s paAdmDocCode = $p($g(^PAADM(episodeID)),"^",9)
	if (paAdmDocCode '= "")
	{
		s paAdmDocCodeDR = $p($g(^CTPCP(paAdmDocCode,1)),"^",2)
	}
	s paAdmReason = ""
	s paAdmReasonDR = $p($g(^PAADM(episodeID,1)),"^",7)
	if (paAdmReasonDR '= "")
	{
		s paAdmReason = $p($g(^PAC("ADMREA",paAdmReasonDR)),"^",2)
	}
	s wardDesc = ""
	s disWardDR = $p($g(^PAADM(episodeID)),"^",70)
	if (disWardDR '= "")
	{
		s wardDesc = $p($g(^PAWARD(disWardDR)),"^",2)
		if ($l(wardDesc,"-")>1)
		{
			s wardDesc = $p(wardDesc,"-",2)
		}
	}
	
	s eprStatus=##Class(DHCEPRFS.BI.BIToWMR).GetMedRecordStatus(episodeID)
	s eprDocStatus = +$p(eprStatus,"^",2)
	s eprDocStatusDesc = $s(eprDocStatus=1:"是",1:"否")
	s eprNurStatus = +$p(eprStatus,"^",1)
	s eprNurStatusDesc = $s(eprNurStatus=1:"是",1:"否")
	s eprPdfStatus = +$p(eprStatus,"^",3)
	
	//过滤医生提交，护士提交，PDF生成
	q:((ADocCommit = "y") && (eprDocStatus '= 1))
	q:((ADocCommit = "n") && (eprDocStatus '= 0))
	q:((ANurCommit = "y") && (eprNurStatus '= 1))
	q:((ANurCommit = "n") && (eprNurStatus '= 0))
	q:((APDFCreated = "y") && (eprPdfStatus '= 1))
	q:((APDFCreated = "n") && (eprPdfStatus '= 0))
	
	if ((eprDocStatus = 1) && (eprNurStatus = 1) && (eprPdfStatus '= 1))
	{
		s eprPdfStatus=2
		s eprPdfStatusDesc="正在生成"
	}
	else
	{
		s eprPdfStatusDesc=$s(eprPdfStatus=1:"是",1:"否")
		if (eprDocStatus= "0")
		{
			s eprPdfStatus=0
			s eprPdfStatusDesc = "否"
		}
	}
	
	s reviewStatus = $s(type="U":"否",type="F":"是",type="B":"已退回",1:"")
	s qcReviewStatus = $s(qcType="U":"否",qcType="F":"是",qcType="B":"已退回",1:"")
	s deptReviewStatus = $s(deptType="U":"否",deptType="F":"是",deptType="B":"已退回",1:"")
	
	s qcSignStatus = "", qcSignStatusDesc = ""
	s remarksInfo = ""
	if (remarks '= "")
	{
		s remarksInfo = ..FormatRemarks(remarks)
	}
	s submitMessage = ..GetSubmitMessage(episodeID)
	s submitCount = ..GetSubmitCount(episodeID)
	s backMessage = ..GetBackMessage(episodeID)
	
	s submitInfo = ##Class(DHCEPRFS.BL.BLAdmMRStatus).GetAdmMRStatusEntity(episodeID,"DHC")
	s submitDocID= submitInfo.FlagMRCompletionUserID
	s submitNurID = submitInfo.FlagFinalAccountUserID
	
	if (EnableTranslation = 1)
	{
		s:(patSex'="") patSex = ##class(User.CTSex).GetTranByDesc("CTSEXDesc",patSex,langid)
		s:(paAdmDepCodeDR'="") paAdmDepCodeDR = ##class(User.CTLoc).GetTranByDesc("CTLOCDesc",paAdmDepCodeDR,langid)
		s:(paAdmDocCodeDR'="") paAdmDocCodeDR = ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",paAdmDocCodeDR,langid)
		s:(paAdmReason'="") paAdmReason = ##class(User.PACAdmReason).GetTranByDesc("READesc",paAdmReason,langid)
		s:(wardDesc'="") wardDesc = ##class(User.PACWard).GetTranByDesc("WARDDesc",wardDesc,langid)
	}
	
	s ^CacheTemp(repid,ind) = $lb(episodeID,patientID,medRecordNo,regNo,name,patDob,patSex,admDate,admTime,disDate,disTime,paAdmDepCodeDR,paAdmDocCodeDR,paAdmReason,wardDesc,eprDocStatus,eprDocStatusDesc,eprNurStatus,eprNurStatusDesc,eprPdfStatus,eprPdfStatusDesc,qcSignStatus,qcSignStatusDesc,reviewStatus,qcReviewStatus,deptReviewStatus,remarksInfo,submitMessage,submitCount,backMessage,submitDocID,submitNurID)
	s ind = ind + 1
	q
}

ClassMethod GetDeptEpisodeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDeptEpisodeListExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If ind = "" {				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
	}
	Else      {				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDeptEpisodeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDeptEpisodeListExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 检查是否通过完整性校验，返回校验状态————"1":通过，"0":未通过
/// Debug: w ##class(DHCEPRFS.BL.BLReview).GetCheckStatus("597")
ClassMethod GetCheckStatus(AEpisodeID As %String) As %String
{
	s checkStatus = "1"
	s checkDate = ""
	s checkDate = $o(^DHCEPRFS.INST.CheckedPatListI("IdxEpisodeID"," "_AEpisodeID,checkDate))
	q:((checkDate = "")||(checkDate = "0")) "0"
	s checkTime = ""
	s checkTime = $o(^DHCEPRFS.INST.CheckedPatListI("IdxEpisodeID"," "_AEpisodeID,checkDate,checkTime))
 	s rowID = ""
 	f {
	 	s rowID = $o(^DHCEPRFS.INST.CheckedRetListI("IdxEpisodeID"," "_AEpisodeID,checkDate,checkTime,rowID))
	 	q:(rowID = "")
	 	s obj = ##class(DHCEPRFS.INST.CheckedRetList).%OpenId(rowID)
	 	s checkResult = obj.CheckResult
	 	s isNeeded = obj.IsNeeded
	 	
	 	d obj.%Close()
	 	if (checkResult = "0")
	 	{
		 	if (isNeeded = "Y")
		 	{
			 	s checkStatus = "0"
		 	}
	 	}
 	}
 	q checkStatus
}

ClassMethod AddZero(ARegNo As %String) As %String
{
	s regNo = ""
	s regNo = $o(^PAPERi("PAPMI_PatNo",regNo))
	s regNo = $tr(regNo, " ")
	s regNo = $tr(regNo,$c(10),"")
	s regNo = $tr(regNo,$c(13),"")
	s length = $l(regNo)
	q:(length = $l(ARegNo)) ARegNo
	
	for index=1:1:(length - $l(ARegNo)) 
	{
		s ARegNo = "0"_ARegNo
	}
	q ARegNo
}

/// Desc: 科室查询患者复核状态
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLReview","GetStatus","B","2017-3-1","2017-9-30","","","159","9","A")
Query GetStatus(AType As %String, AStartDate As %String, AEndDate As %String, AMedRecordNo As %String, ARegNo As %String, AUserID As %String, ACTLocID As %String, ACTMUID As %String) As %Query(ROWSPEC = "EpisodeID:%String,MedRecordNo:%String,RegNo:%String,PAPMIName:%String,DisDateTime:%String,PAAdmDocCodeDR:%String,CTMedUnitDesc:%String,Warddesc:%String,EprDocStatus:%String,EprDocStatusDesc:%String,EprNurStatus:%String,EprNurStatusDesc:%String,EprPdfStatus:%String,EprPdfStatusDesc:%String,ReviewStatus:%String,QCDeptStatus:%String,DeptStatus:%String,Message:%String,Remarks:%String,SubmitMessage:%String,BackMessage:%String")
{
}

ClassMethod GetStatusExecute(ByRef qHandle As %Binary, AType As %String, AStartDate As %String, AEndDate As %String, AMedRecordNo As %String, ARegNo As %String, AUserID As %String, ACTLocID As %String, ACTMUID As %String) As %Status
{
    set repid=$I(^CacheTemp)
    set ind = 1
    set qHandle = $lb(0,repid,0)
    
    s:(AStartDate '= "") startDate = $zdh(AStartDate,3)
    s:(AEndDate '= "") endDate = $zdh(AEndDate,3)
    s:(AMedRecordNo = $c(0)) AMedRecordNo = ""
    s:(ARegNo = $c(0)) ARegNo = ""
    
    //取关联科室
    s ctLocIDS = ACTLocID
    s linkLocIDS = ##class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetLinkLocID(ACTLocID)
    s:(linkLocIDS '= "") ctLocIDS = ctLocIDS_"^"_linkLocIDS
    //取用户所在医疗单元信息
    s muInfo = ##class(DHCEPRFS.BL.HISInfo.BLBasicPlatform).GetMedUnitData(AUserID)
    s userMUID = $p(muInfo,"^",1)
    q:((ACTMUID = "M")&&(userMUID = "")) $$$OK
    
    if (AMedRecordNo '= "")
	{
		s AMedRecordNo = $zcvt(AMedRecordNo,"U")
		f i=1:1:$l(ctLocIDS,"^")
		{
			s admDepID = $p(ctLocIDS,"^",i)
			s rowID = ""
			f {
				s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxMedRecordNo"," I"," "_AMedRecordNo," "_admDepID,rowID))
				q:(rowID = "")
				d GetReviewInfo
			}
		}
	}
	elseif (ARegNo '= "")
	{
		s ARegNo = ..AddZero(ARegNo)
		f i=1:1:$l(ctLocIDS,"^")
		{
			s admDepID = $p(ctLocIDS,"^",i)
			s rowID = ""
			f {
				s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxRegNo"," I"," "_ARegNo," "_admDepID,rowID))
				q:(rowID = "")
				d GetReviewInfo
			}
		}
	}
	elseif ((startDate '= "") && (endDate '= ""))
    {
		if (AType '= "B")
		{
			s groupType = $p(AType,"||",1)
			s filterType = $p(AType,"||",2)
			f i=1:1:$l(ctLocIDS,"^")
			{
				s admDepID = $p(ctLocIDS,"^",i)
				s date = startDate - 1
				f {
					s date = $o(^DHCEPRFS.INST.CheckedPatListI("Idx"_groupType_"ReviewStatus"," I"," "_filterType," "_admDepID,date))
					q:((date = "")||(date > endDate))
					s rowID = ""
					f {
						s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("Idx"_groupType_"ReviewStatus"," I"," "_filterType," "_admDepID,date,rowID))
						q:(rowID = "")
						d GetReviewInfo
					}
				}
			}
		}
		else
		{
			f i=1:1:$l(ctLocIDS,"^")
			{
				s admDepID = $p(ctLocIDS,"^",i)
				s date = startDate - 1
				f {
					s date = $o(^DHCEPRFS.INST.CheckedPatListI("IdxDepIDCreateDate"," I"," "_admDepID,date))
					q:((date = "")||(date > endDate))
					s rowID = ""
					f {
						s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxDepIDCreateDate"," I"," "_admDepID,date,rowID))
						q:(rowID = "")
						d GetReviewInfo
					}
				}
			}
		}
    }
    
    q $$$OK
GetReviewInfo
	s objPat = ##class(DHCEPRFS.INST.CheckedPatList).%OpenId(rowID)
	s episodeID = objPat.EpisodeID
	s medRecordNo = objPat.MedRecordNo
	s regNo = objPat.RegNo
	s name = objPat.Name
	s paAdmDepID = objPat.PAAdmDepID
	s createDate = objPat.CreateDate
	s reviewStatus = objPat.ReviewStatus
	s qcreviewStatus = objPat.QCReviewStatus
	s deptReviewStatus = objPat.DeptReviewStatus
	s ctMedUnitID = objPat.CTMedUnitID
	s remarks = objPat.Remarks
	d objPat.%Close()
	
	//过滤出院病人
	s admStatus=$p($g(^PAADM(episodeID)),"^",20)
	q:(admStatus '= "D")
	
	//过滤用户所在诊疗组
	if (ACTMUID = "M")
	{
		q:(ctMedUnitID '= userMUID)
	}
	
	//使用病案号或登记号查询时，过滤类型和出院日期
	if ((AMedRecordNo '= "")||(ARegNo '= ""))
	{
		q:((createDate < startDate)||(createDate > endDate))
		if (AType '= "B")
		{
			s groupType = $p(AType,"||",1)
			s filterType = $p(AType,"||",2)
			q:((groupType = "MR")&&(reviewStatus '= filterType))
			q:((groupType = "QC")&&(qcreviewStatus '= filterType))
			q:((groupType = "Dept")&&(deptReviewStatus '= filterType))
		}
		else
		{
			q:((reviewStatus '= "B")&&(qcreviewStatus '= "B")&&(deptReviewStatus '= "B"))
		}
	}
	else
	{
		if (AType = "B")
		{
			q:((reviewStatus '= "B")&&(qcreviewStatus '= "B")&&(deptReviewStatus '= "B"))
		}
	}
	
	s disDate = "", disTime = "", disDateTime = ""
	s paDisDateTime = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DisDateTime(episodeID)
	s paDisDate = $p(paDisDateTime,",",1)
	s:(paDisDate '= "") disDate = $zd(paDisDate,3)
	s paDisTime = $p(paDisDateTime,",",2)
	s:(paDisTime '= "") disTime = $zt(paDisTime)
	s:(disDate '= "")&&(disTime '= "") disDateTime = disDate_" "_disTime
	
	s paAdmDocCode=$p($g(^PAADM(episodeID)),"^",9)
	if (paAdmDocCode '= "")
	{
		s paAdmDocCodeDR = $p($g(^CTPCP(paAdmDocCode,1)),"^",2)
	}
	else
	{
		s paAdmDocCodeDR = "无"
	}
	
	if (ctMedUnitID '= "")
	{
		s ctLocID = $p(ctMedUnitID,"||",1)
		s muCTChildSub = $p(ctMedUnitID,"||",2)
		s ctMUDesc = $p($g(^CTLOC(ctLocID,"MU",muCTChildSub)),"^",2)
	}
	else
	{
		s ctMUDesc = "无"
	}
	
	s disWardDR = $p($g(^PAADM(episodeID)),"^",70)
	if (disWardDR '= "")
	{
		s wardDesc =$p($g(^PAWARD(disWardDR)),"^",2)
		if ($l(wardDesc,"-")>1)
		{
			s wardDesc =$p(wardDesc,"-",2)
		}
	}
	else
	{
		s wardDesc = "无"
	}
	
	s eprStatus=##Class(DHCEPRFS.BI.BIToWMR).GetMedRecordStatus(episodeID)
	
	s eprDocStatus = +$p(eprStatus,"^",2)
	s eprDocStatusDesc = $s(eprDocStatus=1:"是",1:"否")
	s eprNurStatus = +$p(eprStatus,"^",1)
	s eprNurStatusDesc = $s(eprNurStatus=1:"是",1:"否")
	s eprPdfStatus = +$p(eprStatus,"^",3)
	
	if ((eprDocStatus = 1) && (eprNurStatus = 1) && (eprPdfStatus '= 1))
	{
		s eprPdfStatus=2
		s eprPdfStatusDesc="正在生成"
	}
	else
	{
		s eprPdfStatusDesc=$s(eprPdfStatus=1:"是",1:"否")
		if (eprDocStatus= "0")
		{
			s eprPdfStatus=0
			s eprPdfStatusDesc = "否"
		}
	}
	
	s reviewStatusDesc = ""
	s:(reviewStatus = "U") reviewStatusDesc = "否"
	s:(reviewStatus = "F") reviewStatusDesc = "是"
	s:(reviewStatus = "B") reviewStatusDesc = "已退回"
	s qcStatusDesc = ""
	s:(qcreviewStatus = "U") qcStatusDesc = "否"
	s:(qcreviewStatus = "F") qcStatusDesc = "是"
	s:(qcreviewStatus = "B") qcStatusDesc = "已退回"
	s deptStatusDesc = ""
	s:(deptReviewStatus = "U") deptStatusDesc = "否"
	s:(deptReviewStatus = "F") deptStatusDesc = "是"
	s:(deptReviewStatus = "B") deptStatusDesc = "已退回"
	
	s statusRowID = ""
	s statusRowID = $o(^DHCEPRFS.INST.AdmMRStatusI("IdxEpisodeID"," DHC"," "_episodeID,statusRowID))
	//复核操作信息
	s message = ..GetReviewMessage(episodeID)
	
	s remarksInfo = ""
	if (remarks '= "")
	{
		s remarksInfo = ..FormatRemarks(remarks)
	}
	s submitMessage = ..GetSubmitMessage(episodeID)
	s backMessage = ..GetBackMessage(episodeID)
	
	s ^CacheTemp(repid,ind) = $lb(episodeID,medRecordNo,regNo,name,disDateTime,paAdmDocCodeDR,ctMUDesc,wardDesc,eprDocStatus,eprDocStatusDesc,eprNurStatus,eprNurStatusDesc,eprPdfStatus,eprPdfStatusDesc,reviewStatusDesc,qcStatusDesc,deptStatusDesc,message,remarksInfo,submitMessage,backMessage)
	s ind = ind + 1
	q
}

ClassMethod GetStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStatusExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStatusExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 根据就诊ID获取退回次数
/// Debug: w ##class(DHCEPRFS.BL.BLReview).GetBackCount("577")
ClassMethod GetBackCount(AEpisodeID As %String) As %List
{
	s nullResult = $lb(0,0,0)
	s admMRStatusID = ""
	s admMRStatusID = $o(^DHCEPRFS.INST.AdmMRStatusI("IdxEpisodeID"," DHC"," "_AEpisodeID,admMRStatusID))
	q:(admMRStatusID = "") nullResult
	s mrBackCount = 0, qcBackCount = 0, deptBackCount = 0
	s changeDate = ""
	f {
		s changeDate = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxStatusChangeDateTime"," "_admMRStatusID,changeDate))
		q:(changeDate = "")
		s changeTime = ""
		f {
			s changeTime = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxStatusChangeDateTime"," "_admMRStatusID,changeDate,changeTime))
			q:(changeTime = "")
			s mrFlag = "0", qcFlag = "0", deptFlag = "0"
			s logID = ""
			f {
				s logID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxStatusChangeDateTime"," "_admMRStatusID,changeDate,changeTime,logID))
				q:(logID = "")
				s objLog = ##class(DHCEPRFS.INST.AdmMRStatusLog).%OpenId(logID)
				s changeAct = objLog.ChangeAct
				d objLog.%Close()
				s:(changeAct = "BACK") mrFlag = "1"
				s:(changeAct = "QCBACK") qcFlag = "1"
				s:(changeAct = "DEPTBACK") deptFlag = "1"
			}
			s:(mrFlag = "1") mrBackCount = mrBackCount + 1
			s:(qcFlag = "1") qcBackCount = qcBackCount + 1
			s:(deptFlag = "1") deptBackCount = deptBackCount + 1
		}
	}
	s ret = $lb(mrBackCount,qcBackCount,deptBackCount)
	q ret
}

/// Desc: 根据就诊ID获取历次退回原因
/// Debug: w ##class(DHCEPRFS.BL.BLReview).GetBackMessage("577")
ClassMethod GetBackMessage(AEpisodeID As %String) As %String
{
	s ret = ""
	s admMRStatusID = ""
	s admMRStatusID = $o(^DHCEPRFS.INST.AdmMRStatusI("IdxEpisodeID"," DHC"," "_AEpisodeID,admMRStatusID))
	q:(admMRStatusID = "") ret
	s count = 1
	s changeDate = ""
	f {
		s changeDate = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxStatusChangeDateTime"," "_admMRStatusID,changeDate))
		q:(changeDate = "")
		s changeTime = ""
		f {
			s changeTime = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxStatusChangeDateTime"," "_admMRStatusID,changeDate,changeTime))
			q:(changeTime = "")
			s backMessage = ""
			s logID = ""
			f {
				s logID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxStatusChangeDateTime"," "_admMRStatusID,changeDate,changeTime,logID))
				q:(logID = "")
				s objLog = ##class(DHCEPRFS.INST.AdmMRStatusLog).%OpenId(logID)
				s changeAct = objLog.ChangeAct
				s message = objLog.Message
				d objLog.%Close()
				if ((changeAct = "BACK")||(changeAct = "QCBACK")||(changeAct = "DEPTBACK"))
				{
					s backMessage = message
				}
			}
			if (backMessage '= "")
			{
				if (ret = "")
				{
					s ret = count_"."_backMessage
				}
				else
				{
					s ret = ret_"; "_count_"."_backMessage
				}
				s count = count + 1
			}
		}
	}
	q ret
}

/// Desc: 病案室查询门急诊患者就诊列表
///       ACTLocID：可选参数，若不为空，则表示仅显示指定科室的患者，AType：U - 未审核，F - 已审核，B - 已退回
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLReview","GetOEEpisodeList","U","2017-3-1","2017-6-30","","","")
Query GetOEEpisodeList(AType As %String, AStartDate As %String, AEndDate As %String, AMedRecordNo As %String, ARegNo As %String, ACTLocIDS As %String = "") As %Query(ROWSPEC = "EpisodeID:%String,PatientID:%String,MedRecordNo:%String,RegNo:%String,PAPMIName:%String,PAPMIDOB:%String,PAPMISex:%String,AdmDateTime:%String,PAAdmDepCodeDR:%String,PAAdmDocCodeDR:%String,EprDocStatus:%String,EprDocStatusDesc:%String,EprPdfStatus:%String,EprPdfStatusDesc:%String,ReviewStatus:%String")
{
}

ClassMethod GetOEEpisodeListExecute(ByRef qHandle As %Binary, AType As %String, AStartDate As %String, AEndDate As %String, AMedRecordNo As %String, ARegNo As %String, ACTLocIDS As %String = "") As %Status
{
    set repid=$I(^CacheTemp)
    set ind = 1
    set qHandle = $lb(0,repid,0)
    
	s:(ACTLocIDS = $c(0)) ACTLocIDS = ""
    s:(AStartDate '= "") startDate = $zdh(AStartDate,3)
    s:(AEndDate '= "") endDate = $zdh(AEndDate,3)
    s:(AMedRecordNo = $c(0)) AMedRecordNo = ""
    s:(ARegNo = $c(0)) ARegNo = ""
    
    if (AMedRecordNo '= "")
    {
	    s AMedRecordNo = $zcvt(AMedRecordNo,"U")
	    if (ACTLocIDS '= "")
	    {
			s admType = ""
		    f {
			    s admType = $o(^DHCEPRFS.INST.CheckedPatListI("IdxMedRecordNo",admType))
			    q:(admType = "")
			    continue:(admType = " I")
				f i=1:1:$l(ACTLocIDS,",")
				{
					s admDepID = $p(ACTLocIDS,",",i)
					s rowID = ""
					f {
						s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxMedRecordNo",admType," "_AMedRecordNo," "_admDepID,rowID))
						q:(rowID = "")
						d GetEpisodeList
					}
				}
			}
	    }
	    else
	    {
		    s admType = ""
		    f {
			    s admType = $o(^DHCEPRFS.INST.CheckedPatListI("IdxMedRecordNo",admType))
			    q:(admType = "")
			    continue:(admType = " I")
				s admDepID = ""
		    	f {
			    	s admDepID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxMedRecordNo",admType," "_AMedRecordNo,admDepID))
			    	q:(admDepID = "")
			    	s rowID = ""
			    	f {
				    	s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxMedRecordNo",admType," "_AMedRecordNo,admDepID,rowID))
				    	q:(rowID = "")
				    	d GetEpisodeList
			    	}
		    	}
			}
	    }
    }
    elseif (ARegNo '= "")
    {
	    s ARegNo = ..AddZero(ARegNo)
	    if (ACTLocIDS '= "")
	    {
		    s admType = ""
		    f {
			    s admType = $o(^DHCEPRFS.INST.CheckedPatListI("IdxRegNo",admType))
			    q:(admType = "")
			    continue:(admType = " I")
				f i=1:1:$l(ACTLocIDS,",")
				{
					s admDepID = $p(ACTLocIDS,",",i)
					s rowID = ""
					f {
						s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxRegNo",admType," "_ARegNo," "_admDepID,rowID))
						q:(rowID = "")
						d GetEpisodeList
					}
				}
			}
	    }
	    else
	    {
		    s admType = ""
		    f {
			    s admType = $o(^DHCEPRFS.INST.CheckedPatListI("IdxRegNo",admType))
			    q:(admType = "")
			    continue:(admType = " I")
				s admDepID = ""
		    	f {
			    	s admDepID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxRegNo",admType," "_ARegNo,admDepID))
			    	q:(admDepID = "")
			    	s rowID = ""
			    	f {
				    	s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxRegNo",admType," "_ARegNo,admDepID,rowID))
				    	q:(rowID = "")
				    	d GetEpisodeList
			    	}
		    	}
			}
	    }
    }
    elseif (AType '= "A")
    {
	    if (ACTLocIDS '= "")
	    {
		    s admType = ""
		    f {
			    s admType = $o(^DHCEPRFS.INST.CheckedPatListI("IdxMRReviewStatus",admType))
			    q:(admType = "")
			    continue:(admType = " I")
				f i=1:1:$l(ACTLocIDS,",")
				{
					s admDepID = $p(ACTLocIDS,",",i)
					s date = startDate - 1
					f {
						s date = $o(^DHCEPRFS.INST.CheckedPatListI("IdxMRReviewStatus",admType," "_AType," "_admDepID,date))
						q:((date = "")||(date > endDate))
						s rowID = ""
						f {
							s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxMRReviewStatus",admType," "_AType," "_admDepID,date,rowID))
							q:(rowID = "")
							d GetEpisodeList
						}
					}
				}
			}
	    }
	    else
	    {
		    s admType = ""
		    f {
			    s admType = $o(^DHCEPRFS.INST.CheckedPatListI("IdxMRReviewStatus",admType))
			    q:(admType = "")
			    continue:(admType = " I")
				s admDepID = ""
				f {
					s admDepID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxMRReviewStatus",admType," "_AType,admDepID))
					q:(admDepID = "")
					s date = startDate - 1
					f {
						s date = $o(^DHCEPRFS.INST.CheckedPatListI("IdxMRReviewStatus",admType," "_AType,admDepID,date))
						q:((date = "")||(date > endDate))
						s rowID = ""
						f {
							s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxMRReviewStatus",admType," "_AType,admDepID,date,rowID))
							q:(rowID = "")
							d GetEpisodeList
						}
					}
				}
			}
	    }
    }
    elseif ((startDate '= "") && (endDate '= ""))
    {
	    if (ACTLocIDS '= "")
	    {
			s admType = ""
		    f {
			    s admType = $o(^DHCEPRFS.INST.CheckedPatListI("IdxDepIDCreateDate",admType))
			    q:(admType = "")
			    continue:(admType = " I")
				f i=1:1:$l(ACTLocIDS,",")
				{
					s admDepID = $p(ACTLocIDS,",",i)
					s date = startDate - 1
					f {
						s date = $o(^DHCEPRFS.INST.CheckedPatListI("IdxDepIDCreateDate",admType," "_admDepID,date))
						q:((date = "")||(date > endDate))
						s rowID = ""
						f {
							s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxDepIDCreateDate",admType," "_admDepID,date,rowID))
							q:(rowID = "")
							d GetEpisodeList
						}
					}
				}
			}
	    }
	    else
	    {
		    s admType = ""
		    f {
			    s admType = $o(^DHCEPRFS.INST.CheckedPatListI("IdxDepIDCreateDate",admType))
			    q:(admType = "")
			    continue:(admType = " I")
				s admDepID = ""
		    	f {
			    	s admDepID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxDepIDCreateDate",admType,admDepID))
			    	q:(admDepID = "")
					s date = startDate - 1
					f {
						s date = $o(^DHCEPRFS.INST.CheckedPatListI("IdxDepIDCreateDate",admType,admDepID,date))
						q:((date = "")||(date > endDate))
						s rowID = ""
						f {
							s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxDepIDCreateDate",admType,admDepID,date,rowID))
							q:(rowID = "")
							d GetEpisodeList
						}
					}
				}
			}
	    }
    }
    
    q $$$OK
GetEpisodeList
	s objPat = ##class(DHCEPRFS.INST.CheckedPatList).%OpenId(rowID)
	s episodeID = objPat.EpisodeID
	s medRecordNo = objPat.MedRecordNo
	s regNo = objPat.RegNo
	s name = objPat.Name
	s paAdmDepID = objPat.PAAdmDepID
	s createDate = objPat.CreateDate
	s type = objPat.ReviewStatus
	s paAdmType = objPat.PAAdmType
	d objPat.%Close()
	
	//使用病案号、登记号进行查询时，过滤类型和提交日期
	if ((AMedRecordNo '= "")||(ARegNo '= ""))
	{
		if (AType '= "A")
		{
			q:((createDate < startDate)||(createDate > endDate))
			q:(type '= AType)
		}
	}
	
	s patientID = $p($g(^PAADM(episodeID)),"^",1)
	s patDob = $p($g(^PAPER(patientID,"ALL")),"^",6)
	s:(patDob '= "") patDob = $zd(patDob,3)
	s patSexDR = $p($g(^PAPER(patientID,"ALL")),"^",7)
	s patSex = $p($g(^CT("SEX",patSexDR)),"^",2)
	
	s admDate = "", admTime = "", admDateTime = ""
	s paAdmDateTime = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetAdmDateTime(episodeID)
	s paAdmDate = $p(paAdmDateTime,",",1)
	s:(paAdmDate '= "") admDate = $zd(paAdmDate,3)
	s paAdmTime = $p(paAdmDateTime,",",2)
	s:(paAdmTime '= "") admTime = $zt(paAdmTime)
	s:(admDate '= "")&&(admTime '= "") admDateTime = admDate_" "_admTime
	if (paAdmDepID '= "")
	{
		s paAdmDepCodeDR = $p($g(^CTLOC(paAdmDepID)),"^",2)
		if ($l(paAdmDepCodeDR,"-")>1)
		{
			s paAdmDepCodeDR =$p(paAdmDepCodeDR,"-",2)
		}
	}
	else
	{
		s paAdmDepCodeDR = "无"
	}
	s paAdmDocCode=$p($g(^PAADM(episodeID)),"^",9)
	if (paAdmDocCode '= "")
	{
		s paAdmDocCodeDR = $p($g(^CTPCP(paAdmDocCode,1)),"^",2)
	}
	else
	{
		s paAdmDocCodeDR = "无"
	}
	s eprStatus=##Class(DHCEPRFS.BI.BIToWMR).GetMedRecordStatus(episodeID)
	
	s eprDocStatus = +$p(eprStatus,"^",2)
	s eprDocStatusDesc = $s(eprDocStatus=1:"是",1:"否")
	s eprPdfStatus = +$p(eprStatus,"^",3)
	
	if ((eprDocStatus = 1) && (eprPdfStatus '= 1))
	{
		s eprPdfStatus=2
		s eprPdfStatusDesc="正在生成"
	}
	else
	{
		s eprPdfStatusDesc=$s(eprPdfStatus=1:"是",1:"否")
		if (eprDocStatus= "0")
		{
			s eprPdfStatus=0
			s eprPdfStatusDesc = "否"
		}
	}
	
	s reviewStatus = ""
	s:(type = "U") reviewStatus = "否"
	s:(type = "F") reviewStatus = "是"
	s:(type = "B") reviewStatus = "已退回"
	
	s ^CacheTemp(repid,ind) = $lb(episodeID,patientID,medRecordNo,regNo,name,patDob,patSex,admDateTime,paAdmDepCodeDR,paAdmDocCodeDR,eprDocStatus,eprDocStatusDesc,eprPdfStatus,eprPdfStatusDesc,reviewStatus)
	s ind = ind + 1
	q
}

ClassMethod GetOEEpisodeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOEEpisodeListExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetOEEpisodeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOEEpisodeListExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 是否扫描病历(通过MRVerItem条目判断)
/// Debug: w ##class(DHCEPRFS.BL.BLReview).GetScanStatus("583")
ClassMethod GetScanStatus(AEpisodeID As %String) As %String
{
	s ret = "N"
	s mrEpisodeID = ""
	s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID"," DHC"," "_AEpisodeID,mrEpisodeID))
	q:(mrEpisodeID = "") ret
	s version = ""
	s version=$o(^DHCEPRFS.INST.MRVersionI("IdxMain"," "_mrEpisodeID,version),-1) //newest
	q:(version = "") ret
	s mrVersionID = ""
	s mrVersionID = $o(^DHCEPRFS.INST.MRVersionI("IdxMain"," "_mrEpisodeID,version,mrVersionID))
	q:(mrVersionID = "") ret
	
	s verMRItemID = ""
	for {
		s verMRItemID = $o(^DHCEPRFS.INST.MRVerItemI("IdxMain"," "_mrVersionID,verMRItemID))
		q:(verMRItemID = "")
		s mrItemID = $tr(verMRItemID," ","")
		s objMRItem = ##class(DHCEPRFS.META.MRItem).%OpenId(mrItemID)
		if (objMRItem '= "")
		{
			if (objMRItem.Type = "PS")	//为非“PS”的类型
			{
				s ret = "Y"
				q
			}
		}
	}
	q ret
}

/// Desc: 获取医生提交次数
/// Debug: w ##class(DHCEPRFS.BL.BLReview).GetSubmitCount("601")
ClassMethod GetSubmitCount(AEpisodeID As %String) As %String
{
	s submitCount = 0
	s rowID = ""
	f {
		s rowID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxAction"," DHC"," "_AEpisodeID," DOCTOR"," COMPLETE",rowID))
		q:(rowID = "")
		s submitCount = submitCount + 1
	}
	q submitCount
}

/// Desc: 备注格式化
/// Debug: w ##class(DHCEPRFS.BL.BLReview).FormatRemarks("#")
ClassMethod FormatRemarks(ARemarks As %String) As %String
{
	s remarksInfo = ""
	s remarksDesc = $p(ARemarks,"@",1)
	if (remarksDesc '= "")
	{
		s remarksInfo = "备注: "_remarksDesc
	}
	s scanItems = $p(ARemarks,"@",2)
	if (scanItems '= "")
	{
		s scanDesc = "扫描项: "
		f i=1:1:$l(scanItems,"^")
		{
			s itemInfo = $p(scanItems,"^",i)
			s itemID = $p(itemInfo,"||",1)
			s itemPages = $p(itemInfo,"||",2)
			s objItem = ##class(DHCEPRFS.META.MRItem).%OpenId(itemID)
			s itemName = objItem.Name
			d objItem.%Close()
			s scanDesc = scanDesc_itemName_itemPages_"页, "
		}
		if (remarksInfo '= "")
		{
			s remarksInfo = remarksInfo_", "_$e(scanDesc,1,*-2)
		}
		else
		{
			s remarksInfo = $e(scanDesc,1,*-2)
		}
	}
	q remarksInfo
}

/// Desc: 根据就诊ID获取历次医生提交备注
/// Debug: w ##class(DHCEPRFS.BL.BLReview).GetSubmitMessage("601")
ClassMethod GetSubmitMessage(AEpisodeID As %String) As %String
{
	s ret = ""
	s count = 1
	s logID = ""
	f {
		s logID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxAction"," DHC"," "_AEpisodeID," DOCTOR"," COMPLETE",logID))
		q:(logID = "")
		s objLog = ##class(DHCEPRFS.INST.AdmMRStatusLog).%OpenId(logID)
		s message = objLog.Message
		d objLog.%Close()
		if (message '= "")
		{
			s message = ..FormatRemarks(message)
			if (ret = "")
			{
				s ret = count_"."_message
			}
			else
			{
				s ret = ret_"; "_count_"."_message
			}
			//s count = count + 1
		}
		s count = count + 1
	}
	q ret
}

/// Desc: 更新病案室备注
/// Debug: w ##class(DHCEPRFS.BL.BLReview).UpdateMRRemarks("病案备注测试","601","159")
ClassMethod UpdateMRRemarks(AMRRemarks As %String, AEpisodeID As %String, AUserID As %String = "") As %String
{
	s rowID = ""
	s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxEpisode"," "_AEpisodeID,rowID))
	q:(rowID = "") "0"
	s objPat = ##Class(DHCEPRFS.INST.CheckedPatList).%OpenId(rowID)
	
	s objPat.MRRemarks = AMRRemarks
	
	s status = objPat.%Save()
	d objPat.%Close()
	if ($$$ISOK(status))
	{
		q "1"
	}
	else
	{
		q "0"
	}
}

/// Desc: 获取上次提交的备注信息
/// Debug: w ##class(DHCEPRFS.BL.BLReview).GetLastMRRemarks("601")
ClassMethod GetLastMRRemarks(AEpisodeID As %String) As %String
{
	s patRowID = ""
	s patRowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxEpisode"," "_AEpisodeID,patRowID))
	q:(patRowID = "") ""
	s objPat = ##class(DHCEPRFS.INST.CheckedPatList).%OpenId(patRowID)
	s mrRemarks = objPat.MRRemarks
	d objPat.%Close()
	s ret = $zcvt(mrRemarks,"I","JS")
	q ret
}

/// Desc: 获取复核操作信息
/// Debug: w ##class(DHCEPRFS.BL.BLReview).GetReviewMessage("550")
ClassMethod GetReviewMessage(AEpisodeID As %String) As %String
{
	s ret = ""
	s patRowID = ""
	s patRowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxEpisode"," "_AEpisodeID,patRowID))
	q:(patRowID = "") ret
	s objPat = ##class(DHCEPRFS.INST.CheckedPatList).%OpenId(patRowID)
	s reviewStatus = objPat.ReviewStatus
	s qcreviewStatus = objPat.QCReviewStatus
	s deptReviewStatus = objPat.DeptReviewStatus
	d objPat.%Close()
	q:((reviewStatus '= "B")&&(qcreviewStatus '= "B")&&(deptReviewStatus '= "B")) ret
	s admMRStatusID = ""
	s admMRStatusID = $o(^DHCEPRFS.INST.AdmMRStatusI("IdxEpisodeID"," DHC"," "_AEpisodeID,admMRStatusID))
	q:(admMRStatusID = "") ret
	s changeAct = ""
	if (reviewStatus = "B")
	{
		s changeAct = "BACK"
	}
	elseif (qcreviewStatus = "B")
	{
		s changeAct = "QCBACK"
	}
	elseif (deptReviewStatus = "B")
	{
		s changeAct = "DEPTBACK"
	}
	s logID = ""
	s logID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxStatusAct"," "_admMRStatusID," "_changeAct,logID),-1)
	s objLog = ##class(DHCEPRFS.INST.AdmMRStatusLog).%OpenId(logID)
	s ret = objLog.Message
	d objLog.%Close()
	q ret
}

}
