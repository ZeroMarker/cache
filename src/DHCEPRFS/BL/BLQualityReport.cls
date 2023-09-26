Class DHCEPRFS.BL.BLQualityReport Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc: 按科室统计逾期时间内医生提交、护士提交情况
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLQualityReport","GetReceiptListByDept","2017-1-1","2017-12-31","6,9,10","7")
Query GetReceiptListByDept(AStartDate As %String, AEndDate As %String, ACTLocIDS As %String, AOverdueTimeSpan As %String) As %Query(ROWSPEC = "AdmDepID:%String,AdmDepDesc:%String,ExpireMRCount:%String,DocPromptCount:%String,DocPromptRatio:%String,DocOverdueCount:%String,NurPromptCount:%String,NurPromptRatio:%String,NurOverdueCount:%String,CompletePromptCount:%String,CompletePromptRatio:%String,CompleteOverdueCount:%String")
{
}

ClassMethod GetReceiptListByDeptExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, ACTLocIDS As %String, AOverdueTimeSpan As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	
	s:(AStartDate '= "") startDate = $zdh(AStartDate,3)
	s:(AEndDate '= "") endDate = $zdh(AEndDate,3)
	s dateNow = $p($h,",",1)
	
	if (ACTLocIDS '= "A")
	{
		f i=1:1:$l(ACTLocIDS,",")
		{
			s admDepID = $p(ACTLocIDS,",",i)
			s expireMRCount = 0, docPromptCount = 0, nurPromptCount = 0, completePromptCount = 0
			s date = startDate - 1
			f {
				s date = $o(^DHCEPRFS.INST.CheckedPatListI("IdxDepIDCreateDate"," I"," "_admDepID,date))
				q:((date = "")||(date > endDate))
				s deadline = date + AOverdueTimeSpan
				q:(deadline >= dateNow)
				s rowID = ""
				f {
					s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxDepIDCreateDate"," I"," "_admDepID,date,rowID))
					q:(rowID = "")
					s objPat = ##class(DHCEPRFS.INST.CheckedPatList).%OpenId(rowID)
					s episodeID = objPat.EpisodeID
					d objPat.%Close()
					
					s admStatus=$p($g(^PAADM(episodeID)),"^",20)
					continue:(admStatus '= "D")
					s expireMRCount = expireMRCount + 1
					
					s docSubmitLogID = "", docPromptFlag = "0"
					s docSubmitLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxAction"," DHC"," "_episodeID," DOCTOR"," COMPLETE",docSubmitLogID))
					if (docSubmitLogID '= "")
					{
						s objDocSubmitLog = ##class(DHCEPRFS.INST.AdmMRStatusLog).%OpenId(docSubmitLogID)
						s docSubmitDate = objDocSubmitLog.ChangeDate
						d objDocSubmitLog.%Close()
						if (docSubmitDate <= deadline)
						{
							s docPromptFlag = "1"
						}
					}
					s nurSubmitLogID = "", nurPromptFlag = "0"
					s nurSubmitLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxAction"," DHC"," "_episodeID," NURSE"," COMPLETE",nurSubmitLogID))
					if (nurSubmitLogID '= "")
					{
						s objNurSubmitLog = ##class(DHCEPRFS.INST.AdmMRStatusLog).%OpenId(nurSubmitLogID)
						s nurSubmitDate = objNurSubmitLog.ChangeDate
						d objNurSubmitLog.%Close()
						if (nurSubmitDate <= deadline)
						{
							s nurPromptFlag = "1"
						}
					}
					s:(docPromptFlag = "1") docPromptCount = docPromptCount +1
					s:(nurPromptFlag = "1") nurPromptCount = nurPromptCount +1
					s:((docPromptFlag = "1")&&(nurPromptFlag = "1")) completePromptCount = completePromptCount +1
				}
			}
			s docPromptRatio = 0, nurPromptRatio = 0, completePromptRatio = 0
			if (expireMRCount '= 0)
			{
				s docPromptRatio = docPromptCount / expireMRCount
				s docPromptRatio = $e(docPromptRatio,1,5)*100
				s nurPromptRatio = nurPromptCount / expireMRCount
				s nurPromptRatio = $e(nurPromptRatio,1,5)*100
				s completePromptRatio = completePromptCount / expireMRCount
				s completePromptRatio = $e(completePromptRatio,1,5)*100
			}
			s docOverdueCount = expireMRCount - docPromptCount
			s nurOverdueCount = expireMRCount - nurPromptCount
			s completeOverdueCount = expireMRCount - completePromptCount
			
			s admDepDesc = $p($g(^CTLOC(admDepID)),"^",2)
			if ($l(admDepDesc,"-")>1)
			{
				s admDepDesc =$p(admDepDesc,"-",2)
			}
			s ^CacheTemp(repid,ind) = $lb(admDepID,admDepDesc,expireMRCount,docPromptCount,docPromptRatio_"%",docOverdueCount,nurPromptCount,nurPromptRatio_"%",nurOverdueCount,completePromptCount,completePromptRatio_"%",completeOverdueCount)
			s ind = ind + 1	
		}
	}
	else
	{
		s admDepID = ""
		f {
			s admDepID = $o(^CTLOC(admDepID))
			q:(admDepID = "")
			s ret = ##class(DHCEPRFS.BL.HISInfo.BLHISInfo).CheckCTLocType(admDepID)
			continue:(ret = "0")
			s expireMRCount = 0, docPromptCount = 0, nurPromptCount = 0, completePromptCount = 0
			s date = startDate - 1
			f {
				s date = $o(^DHCEPRFS.INST.CheckedPatListI("IdxDepIDCreateDate"," I"," "_admDepID,date))
				q:((date = "")||(date > endDate))
				s deadline = date + AOverdueTimeSpan
				q:(deadline >= dateNow)
				s rowID = ""
				f {
					s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxDepIDCreateDate"," I"," "_admDepID,date,rowID))
					q:(rowID = "")
					s objPat = ##class(DHCEPRFS.INST.CheckedPatList).%OpenId(rowID)
					s episodeID = objPat.EpisodeID
					d objPat.%Close()
					
					s admStatus=$p($g(^PAADM(episodeID)),"^",20)
					continue:(admStatus '= "D")
					s expireMRCount = expireMRCount + 1
					
					s docSubmitLogID = "", docPromptFlag = "0"
					s docSubmitLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxAction"," DHC"," "_episodeID," DOCTOR"," COMPLETE",docSubmitLogID))
					if (docSubmitLogID '= "")
					{
						s objDocSubmitLog = ##class(DHCEPRFS.INST.AdmMRStatusLog).%OpenId(docSubmitLogID)
						s docSubmitDate = objDocSubmitLog.ChangeDate
						d objDocSubmitLog.%Close()
						if (docSubmitDate <= deadline)
						{
							s docPromptFlag = "1"
						}
					}
					s nurSubmitLogID = "", nurPromptFlag = "0"
					s nurSubmitLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxAction"," DHC"," "_episodeID," NURSE"," COMPLETE",nurSubmitLogID))
					if (nurSubmitLogID '= "")
					{
						s objNurSubmitLog = ##class(DHCEPRFS.INST.AdmMRStatusLog).%OpenId(nurSubmitLogID)
						s nurSubmitDate = objNurSubmitLog.ChangeDate
						d objNurSubmitLog.%Close()
						if (nurSubmitDate <= deadline)
						{
							s nurPromptFlag = "1"
						}
					}
					s:(docPromptFlag = "1") docPromptCount = docPromptCount +1
					s:(nurPromptFlag = "1") nurPromptCount = nurPromptCount +1
					s:((docPromptFlag = "1")&&(nurPromptFlag = "1")) completePromptCount = completePromptCount +1
				}
			}
			s docPromptRatio = 0, nurPromptRatio = 0, completePromptRatio = 0
			if (expireMRCount '= 0)
			{
				s docPromptRatio = docPromptCount / expireMRCount
				s docPromptRatio = $e(docPromptRatio,1,5)*100
				s nurPromptRatio = nurPromptCount / expireMRCount
				s nurPromptRatio = $e(nurPromptRatio,1,5)*100
				s completePromptRatio = completePromptCount / expireMRCount
				s completePromptRatio = $e(completePromptRatio,1,5)*100
			}
			s docOverdueCount = expireMRCount - docPromptCount
			s nurOverdueCount = expireMRCount - nurPromptCount
			s completeOverdueCount = expireMRCount - completePromptCount
			
			s admDepDesc = $p($g(^CTLOC(admDepID)),"^",2)
			if ($l(admDepDesc,"-")>1)
			{
				s admDepDesc =$p(admDepDesc,"-",2)
			}
			s ^CacheTemp(repid,ind) = $lb(admDepID,admDepDesc,expireMRCount,docPromptCount,docPromptRatio_"%",docOverdueCount,nurPromptCount,nurPromptRatio_"%",nurOverdueCount,completePromptCount,completePromptRatio_"%",completeOverdueCount)
			s ind = ind + 1	
		}
	}
	q $$$OK
}

ClassMethod GetReceiptListByDeptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReceiptListByDeptExecute ]
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

ClassMethod GetReceiptListByDeptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReceiptListByDeptExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 逾期时间内科室提交详细信息
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLQualityReport","GetReceiptDtlByDept","2017-1-1","2017-12-31","6","7","","")
Query GetReceiptDtlByDept(AStartDate As %String, AEndDate As %String, ACTLocIDS As %String, AOverdueTimeSpan As %String, ADocPromptFlag As %String = "", ANurPromptFlag As %String = "") As %Query(ROWSPEC = "AdmDepID:%String,AdmDepDesc:%String,EpisodeID:%String,MedRecordNo:%String,RegNo:%String,Name:%String,DisDate:%String,PAAdmDocCodeDR:%String,CTMedUnitDesc:%String,CTNurUnitDesc:%String,DocPromptFlag:%String,NurPromptFlag:%String,CompletePromptFlag:%String,DocFirstSubmitDate:%String,DocLastSubmitDate:%String,DocOverdueDays:%String,NurFirstSubmitDate:%String,NurLastSubmitDate:%String,NurOverdueDays:%String,AdmNecDate:%String")
{
}

ClassMethod GetReceiptDtlByDeptExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, ACTLocIDS As %String, AOverdueTimeSpan As %String, ADocPromptFlag As %String = "", ANurPromptFlag As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	
	s:(AStartDate '= "") startDate = $zdh(AStartDate,3)
	s:(AEndDate '= "") endDate = $zdh(AEndDate,3)
	s:(ADocPromptFlag = $c(0)) ADocPromptFlag = ""
	s:(ANurPromptFlag = $c(0)) ANurPromptFlag = ""
	s dateNow = $p($h,",",1)
	
	f i=1:1:$l(ACTLocIDS,",")
	{
		s admDepID = $p(ACTLocIDS,",",i)
		s date = startDate - 1
		f {
			s date = $o(^DHCEPRFS.INST.CheckedPatListI("IdxDepIDCreateDate"," I"," "_admDepID,date))
			q:((date = "")||(date > endDate))
			s deadline = date + AOverdueTimeSpan
			q:(deadline >= dateNow)
			s rowID = ""
			f {
				s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxDepIDCreateDate"," I"," "_admDepID,date,rowID))
				q:(rowID = "")
				s objPat = ##class(DHCEPRFS.INST.CheckedPatList).%OpenId(rowID)
				s episodeID = objPat.EpisodeID
				s medRecordNo = objPat.MedRecordNo
				s regNo = objPat.RegNo
				s name = objPat.Name
				s ctMedUnitID = objPat.CTMedUnitID
				d objPat.%Close()
				
				s admStatus=$p($g(^PAADM(episodeID)),"^",20)
				continue:(admStatus '= "D")
				
				//判断医生、护士是否及时提交
				s docSubmitLogID = "", docPromptFlag = "0"
				s docSubmitLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxAction"," DHC"," "_episodeID," DOCTOR"," COMPLETE",docSubmitLogID))
				if (docSubmitLogID '= "")
				{
					s objDocSubmitLog = ##class(DHCEPRFS.INST.AdmMRStatusLog).%OpenId(docSubmitLogID)
					s docSubmitDate = objDocSubmitLog.ChangeDate
					d objDocSubmitLog.%Close()
					if (docSubmitDate <= deadline)
					{
						s docPromptFlag = "1"
					}
				}
				s nurSubmitLogID = "", nurPromptFlag = "0"
				s nurSubmitLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxAction"," DHC"," "_episodeID," NURSE"," COMPLETE",nurSubmitLogID))
				if (nurSubmitLogID '= "")
				{
					s objNurSubmitLog = ##class(DHCEPRFS.INST.AdmMRStatusLog).%OpenId(nurSubmitLogID)
					s nurSubmitDate = objNurSubmitLog.ChangeDate
					d objNurSubmitLog.%Close()
					if (nurSubmitDate <= deadline)
					{
						s nurPromptFlag = "1"
					}
				}
				s completePromptFlag = "0"
				s:((docPromptFlag = "1")&&(nurPromptFlag = "1")) completePromptFlag = "1"
				
				//筛选医生、护士是否及时提交
				if ((ADocPromptFlag '= "")&&(ANurPromptFlag '= ""))
				{
					if ((ADocPromptFlag = "1")&&(ANurPromptFlag = "1"))
					{
						continue:(completePromptFlag = "0")
					}
					else
					{
						continue:(completePromptFlag = "1")
					}
				}
				elseif (ADocPromptFlag '= "")
				{
					continue:(docPromptFlag '= ADocPromptFlag)
				}
				elseif (ANurPromptFlag '= "")
				{
					continue:(nurPromptFlag '= ANurPromptFlag)
				}
				
				//患者就诊信息
				s admDepDesc = $p($g(^CTLOC(admDepID)),"^",2)
				if ($l(admDepDesc,"-")>1)
				{
					s admDepDesc =$p(admDepDesc,"-",2)
				}
				s paDisDate = $p($g(^PAADM(episodeID)),"^",17)
				s:(paDisDate '= "") disDate = $zd(paDisDate,3)
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
				
				//病历提交信息
				s docFirstSubmitDate = ""
				s docFirstLogID = ""
				s docFirstLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxAction"," DHC"," "_episodeID," DOCTOR"," COMPLETE",docFirstLogID))
				if (docFirstLogID '= "")
				{
					s objDocFirstLog = ##class(DHCEPRFS.INST.AdmMRStatusLog).%OpenId(docFirstLogID)
					s docFirstSubmitDate = objDocFirstLog.ChangeDate
					d objDocFirstLog.%Close()
				}
				s docOverdueDays = ""
				if (docPromptFlag = "0")
				{
					if (docFirstSubmitDate '= "")
					{
						s docOverdueDays = docFirstSubmitDate - deadline
					}
					else
					{
						s docOverdueDays = dateNow - deadline
					}
				}
				s:(docFirstSubmitDate '= "") docFirstSubmitDate = $zd(docFirstSubmitDate,3)
				s docLastSubmitDate = ""
				s docLastLogID = ""
				s docLastLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxAction"," DHC"," "_episodeID," DOCTOR"," COMPLETE",docLastLogID),-1)
				if (docLastLogID '= "")
				{
					s objDocLastLog = ##class(DHCEPRFS.INST.AdmMRStatusLog).%OpenId(docLastLogID)
					s docLastSubmitDate = objDocLastLog.ChangeDate
					d objDocLastLog.%Close()
				}
				s:(docLastSubmitDate '= "") docLastSubmitDate = $zd(docLastSubmitDate,3)
				s nurFirstSubmitDate = ""
				s nurFirstLogID = ""
				s nurFirstLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxAction"," DHC"," "_episodeID," NURSE"," COMPLETE",nurFirstLogID))
				if (nurFirstLogID '= "")
				{
					s objNurFirstLog = ##class(DHCEPRFS.INST.AdmMRStatusLog).%OpenId(nurFirstLogID)
					s nurFirstSubmitDate = objNurFirstLog.ChangeDate
					d objNurFirstLog.%Close()
				}
				s nurOverdueDays = ""
				if (nurPromptFlag = "0")
				{
					if (nurFirstSubmitDate '= "")
					{
						s nurOverdueDays = nurFirstSubmitDate - deadline
					}
					else
					{
						s nurOverdueDays = dateNow - deadline
					}
				}
				s:(nurFirstSubmitDate '= "") nurFirstSubmitDate = $zd(nurFirstSubmitDate,3)
				s nurLastSubmitDate = ""
				s nurLastLogID = ""
				s nurLastLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxAction"," DHC"," "_episodeID," NURSE"," COMPLETE",nurLastLogID),-1)
				if (nurLastLogID '= "")
				{
					s objNurLastLog = ##class(DHCEPRFS.INST.AdmMRStatusLog).%OpenId(nurLastLogID)
					s nurLastSubmitDate = objNurLastLog.ChangeDate
					d objNurLastLog.%Close()
				}
				s:(nurLastSubmitDate '= "") nurLastSubmitDate = $zd(nurLastSubmitDate,3)
				s admNecDate = ""
				s admMRStatusID = ""
				s admMRStatusID = $o(^DHCEPRFS.INST.AdmMRStatusI("IdxEpisodeID"," DHC"," "_episodeID,admMRStatusID))
				if (admMRStatusID '= "")
				{
					s objAdmMRStatus = ##class(DHCEPRFS.INST.AdmMRStatus).%OpenId(admMRStatusID)
					s admNecDate = objAdmMRStatus.NecessaryConditionDate
					d objAdmMRStatus.%Close()
				}
				s:(admNecDate '= "") admNecDate = $zd(admNecDate,3)
				
				s ^CacheTemp(repid,ind) = $lb(admDepID,admDepDesc,episodeID,medRecordNo,regNo,name,disDate,paAdmDocCodeDR,ctMUDesc,ctNUDesc,docPromptFlag,nurPromptFlag,completePromptFlag,docFirstSubmitDate,docLastSubmitDate,docOverdueDays,nurFirstSubmitDate,nurLastSubmitDate,nurOverdueDays,admNecDate)
				s ind = ind + 1
			}
		}
	}
	q $$$OK
}

ClassMethod GetReceiptDtlByDeptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReceiptDtlByDeptExecute ]
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

ClassMethod GetReceiptDtlByDeptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReceiptDtlByDeptExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 医疗单元逾期提交详细信息
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLQualityReport","GetOverdueDtlByCTMU","2017-1-1","2017-12-31","6","A","7")
Query GetOverdueDtlByCTMU(AStartDate As %String, AEndDate As %String, ACTLocID As %String, ACTMUID As %String, AOverdueTimeSpan As %String) As %Query(ROWSPEC = "AdmDepDesc:%String,EpisodeID:%String,MedRecordNo:%String,RegNo:%String,Name:%String,DisDate:%String,PAAdmDocCodeDR:%String,CTMedUnitDesc:%String,CTNurUnitDesc:%String,DocFirstSubmitDate:%String,DocLastSubmitDate:%String,DocOverdueDays:%String,NurFirstSubmitDate:%String,NurLastSubmitDate:%String,NurOverdueDays:%String,AdmNecDate:%String")
{
}

ClassMethod GetOverdueDtlByCTMUExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, ACTLocID As %String, ACTMUID As %String, AOverdueTimeSpan As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	
	s:(AStartDate '= "") startDate = $zdh(AStartDate,3)
	s:(AEndDate '= "") endDate = $zdh(AEndDate,3)
	s dateNow = $p($h,",",1)
	
	s date = startDate - 1
	f {
		s date = $o(^DHCEPRFS.INST.CheckedPatListI("IdxDepIDCreateDate"," I"," "_ACTLocID,date))
		q:((date = "")||(date > endDate))
		s deadline = date + AOverdueTimeSpan
		q:(deadline >= dateNow)
		s rowID = ""
		f {
			s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxDepIDCreateDate"," I"," "_ACTLocID,date,rowID))
			q:(rowID = "")
			s objPat = ##class(DHCEPRFS.INST.CheckedPatList).%OpenId(rowID)
			s episodeID = objPat.EpisodeID
			s medRecordNo = objPat.MedRecordNo
			s regNo = objPat.RegNo
			s name = objPat.Name
			s ctMedUnitID = objPat.CTMedUnitID
			d objPat.%Close()
			
			s admStatus=$p($g(^PAADM(episodeID)),"^",20)
			continue:(admStatus '= "D")
			//筛选医疗组
			if (ACTMUID '= "A")
			{
				continue:(ctMedUnitID '= ACTMUID)
			}
			
			//判断医生、护士是否及时提交
			s docSubmitLogID = "", docPromptFlag = "0"
			s docSubmitLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxAction"," DHC"," "_episodeID," DOCTOR"," COMPLETE",docSubmitLogID))
			if (docSubmitLogID '= "")
			{
				s objDocSubmitLog = ##class(DHCEPRFS.INST.AdmMRStatusLog).%OpenId(docSubmitLogID)
				s docSubmitDate = objDocSubmitLog.ChangeDate
				d objDocSubmitLog.%Close()
				if (docSubmitDate <= deadline)
				{
					s docPromptFlag = "1"
				}
			}
			s nurSubmitLogID = "", nurPromptFlag = "0"
			s nurSubmitLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxAction"," DHC"," "_episodeID," NURSE"," COMPLETE",nurSubmitLogID))
			if (nurSubmitLogID '= "")
			{
				s objNurSubmitLog = ##class(DHCEPRFS.INST.AdmMRStatusLog).%OpenId(nurSubmitLogID)
				s nurSubmitDate = objNurSubmitLog.ChangeDate
				d objNurSubmitLog.%Close()
				if (nurSubmitDate <= deadline)
				{
					s nurPromptFlag = "1"
				}
			}
			continue:((docPromptFlag = "1")&&(nurPromptFlag = "1"))
			
			//患者就诊信息
			s paDisDate = $p($g(^PAADM(episodeID)),"^",17)
			s:(paDisDate '= "") disDate = $zd(paDisDate,3)
			s admDepDesc = $p($g(^CTLOC(ACTLocID)),"^",2)
			if ($l(admDepDesc,"-")>1)
			{
				s admDepDesc =$p(admDepDesc,"-",2)
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
			
			//病历提交信息
			s docFirstSubmitDate = ""
			s docFirstLogID = ""
			s docFirstLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxAction"," DHC"," "_episodeID," DOCTOR"," COMPLETE",docFirstLogID))
			if (docFirstLogID '= "")
			{
				s objDocFirstLog = ##class(DHCEPRFS.INST.AdmMRStatusLog).%OpenId(docFirstLogID)
				s docFirstSubmitDate = objDocFirstLog.ChangeDate
				d objDocFirstLog.%Close()
			}
			s docOverdueDays = ""
			if (docPromptFlag = "0")
			{
				if (docFirstSubmitDate '= "")
				{
					s docOverdueDays = docFirstSubmitDate - deadline
				}
				else
				{
					s docOverdueDays = dateNow - deadline
				}
			}
			s:(docFirstSubmitDate '= "") docFirstSubmitDate = $zd(docFirstSubmitDate,3)
			s docLastSubmitDate = ""
			s docLastLogID = ""
			s docLastLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxAction"," DHC"," "_episodeID," DOCTOR"," COMPLETE",docLastLogID),-1)
			if (docLastLogID '= "")
			{
				s objDocLastLog = ##class(DHCEPRFS.INST.AdmMRStatusLog).%OpenId(docLastLogID)
				s docLastSubmitDate = objDocLastLog.ChangeDate
				d objDocLastLog.%Close()
			}
			s:(docLastSubmitDate '= "") docLastSubmitDate = $zd(docLastSubmitDate,3)
			s nurFirstSubmitDate = ""
			s nurFirstLogID = ""
			s nurFirstLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxAction"," DHC"," "_episodeID," NURSE"," COMPLETE",nurFirstLogID))
			if (nurFirstLogID '= "")
			{
				s objNurFirstLog = ##class(DHCEPRFS.INST.AdmMRStatusLog).%OpenId(nurFirstLogID)
				s nurFirstSubmitDate = objNurFirstLog.ChangeDate
				d objNurFirstLog.%Close()
			}
			s nurOverdueDays = ""
			if (nurPromptFlag = "0")
			{
				if (nurFirstSubmitDate '= "")
				{
					s nurOverdueDays = nurFirstSubmitDate - deadline
				}
				else
				{
					s nurOverdueDays = dateNow - deadline
				}
			}
			s:(nurFirstSubmitDate '= "") nurFirstSubmitDate = $zd(nurFirstSubmitDate,3)
			s nurLastSubmitDate = ""
			s nurLastLogID = ""
			s nurLastLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxAction"," DHC"," "_episodeID," NURSE"," COMPLETE",nurLastLogID),-1)
			if (nurLastLogID '= "")
			{
				s objNurLastLog = ##class(DHCEPRFS.INST.AdmMRStatusLog).%OpenId(nurLastLogID)
				s nurLastSubmitDate = objNurLastLog.ChangeDate
				d objNurLastLog.%Close()
			}
			s:(nurLastSubmitDate '= "") nurLastSubmitDate = $zd(nurLastSubmitDate,3)
			s admNecDate = ""
			s admMRStatusID = ""
			s admMRStatusID = $o(^DHCEPRFS.INST.AdmMRStatusI("IdxEpisodeID"," DHC"," "_episodeID,admMRStatusID))
			if (admMRStatusID '= "")
			{
				s objAdmMRStatus = ##class(DHCEPRFS.INST.AdmMRStatus).%OpenId(admMRStatusID)
				s admNecDate = objAdmMRStatus.NecessaryConditionDate
				d objAdmMRStatus.%Close()
			}
			s:(admNecDate '= "") admNecDate = $zd(admNecDate,3)
			
			s ^CacheTemp(repid,ind) = $lb(admDepDesc,episodeID,medRecordNo,regNo,name,disDate,paAdmDocCodeDR,ctMUDesc,ctNUDesc,docFirstSubmitDate,docLastSubmitDate,docOverdueDays,nurFirstSubmitDate,nurLastSubmitDate,nurOverdueDays,admNecDate)
			s ind = ind + 1
		}
	}
	q $$$OK
}

ClassMethod GetOverdueDtlByCTMUFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOverdueDtlByCTMUExecute ]
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

ClassMethod GetOverdueDtlByCTMUClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOverdueDtlByCTMUExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 按科室统计逾期时间内病历退回情况
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLQualityReport","GetQCBackListByDept","2017-1-1","2017-12-31","6,9,10","7")
Query GetQCBackListByDept(AStartDate As %String, AEndDate As %String, ACTLocIDS As %String, AOverdueTimeSpan As %String) As %Query(ROWSPEC = "AdmDepID:%String,AdmDepDesc:%String,CompleteCount:%String,DeptBackCount:%String,DeptBackRatio:%String,QCBackCount:%String,QCBackRatio:%String,MRBackCount:%String,MRBackRatio:%String,TotalBackCount:%String,TotalBackRatio:%String")
{
}

ClassMethod GetQCBackListByDeptExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, ACTLocIDS As %String, AOverdueTimeSpan As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	
	s:(AStartDate '= "") startDate = $zdh(AStartDate,3)
	s:(AEndDate '= "") endDate = $zdh(AEndDate,3)
	s dateNow = $p($h,",",1)
	
	if (ACTLocIDS '= "A")
	{
		f i=1:1:$l(ACTLocIDS,",")
		{
			s admDepID = $p(ACTLocIDS,",",i)
			s completeCount = 0, deptBackCount = 0, qcBackCount = 0, mrBackCount = 0, totalBackCount = 0
			s date = startDate - 1
			f {
				s date = $o(^DHCEPRFS.INST.CheckedPatListI("IdxDepIDCreateDate"," I"," "_admDepID,date))
				q:((date = "")||(date > endDate))
				s deadline = date + AOverdueTimeSpan
				q:(deadline >= dateNow)
				s rowID = ""
				f {
					s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxDepIDCreateDate"," I"," "_admDepID,date,rowID))
					q:(rowID = "")
					s objPat = ##class(DHCEPRFS.INST.CheckedPatList).%OpenId(rowID)
					s episodeID = objPat.EpisodeID
					d objPat.%Close()
					
					s admStatus=$p($g(^PAADM(episodeID)),"^",20)
					continue:(admStatus '= "D")
					//s expireMRCount = expireMRCount + 1
					
					s docSubmitLogID = "", docSubmitFlag = "0"
					s docSubmitLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxAction"," DHC"," "_episodeID," DOCTOR"," COMPLETE",docSubmitLogID))
					s:(docSubmitLogID '= "") docSubmitFlag = "1"
					s nurSubmitLogID = "", nurSubmitFlag = "0"
					s nurSubmitLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxAction"," DHC"," "_episodeID," NURSE"," COMPLETE",nurSubmitLogID))
					s:(nurSubmitLogID '= "") nurSubmitFlag = "1"
					continue:((docSubmitFlag = "0")||(nurSubmitFlag = "0"))
					s completeCount = completeCount + 1
					s admMRStatusID = ""
					s admMRStatusID = $o(^DHCEPRFS.INST.AdmMRStatusI("IdxEpisodeID"," DHC"," "_episodeID,admMRStatusID))
					continue:(admMRStatusID = "")
					s deptBackLogID = ""
					s deptBackLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxStatusAct"," "_admMRStatusID," DEPTBACK",deptBackLogID))
					s:(deptBackLogID '= "") deptBackCount = deptBackCount + 1
					s qcBackLogID = ""
					s qcBackLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxStatusAct"," "_admMRStatusID," QCBACK",qcBackLogID))
					s:(qcBackLogID '= "") qcBackCount = qcBackCount + 1
					s mrBackLogID = ""
					s mrBackLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxStatusAct"," "_admMRStatusID," BACK",mrBackLogID))
					s:(mrBackLogID '= "") mrBackCount = mrBackCount + 1
					s:((deptBackLogID '= "")||(qcBackLogID '= "")||(mrBackLogID '= "")) totalBackCount = totalBackCount + 1
				}
			}
			s deptBackRatio = 0, qcBackRatio = 0, mrBackRatio = 0, totalBackRatio = 0
			if (completeCount '= 0)
			{
				s deptBackRatio = deptBackCount / completeCount
				s deptBackRatio = $e(deptBackRatio,1,5)*100
				s qcBackRatio = qcBackCount / completeCount
				s qcBackRatio = $e(qcBackRatio,1,5)*100
				s mrBackRatio = mrBackCount / completeCount
				s mrBackRatio = $e(mrBackRatio,1,5)*100
				s totalBackRatio = totalBackCount / completeCount
				s totalBackRatio = $e(totalBackRatio,1,5)*100
			}
			
			s admDepDesc = $p($g(^CTLOC(admDepID)),"^",2)
			if ($l(admDepDesc,"-")>1)
			{
				s admDepDesc =$p(admDepDesc,"-",2)
			}
			s ^CacheTemp(repid,ind) = $lb(admDepID,admDepDesc,completeCount,deptBackCount,deptBackRatio_"%",qcBackCount,qcBackRatio_"%",mrBackCount,mrBackRatio_"%",totalBackCount,totalBackRatio_"%")
			s ind = ind + 1	
		}
	}
	else
	{
		s admDepID = ""
		f {
			s admDepID = $o(^CTLOC(admDepID))
			q:(admDepID = "")
			s ret = ##class(DHCEPRFS.BL.HISInfo.BLHISInfo).CheckCTLocType(admDepID)
			continue:(ret = "0")
			s completeCount = 0, deptBackCount = 0, qcBackCount = 0, mrBackCount = 0, totalBackCount = 0
			s date = startDate - 1
			f {
				s date = $o(^DHCEPRFS.INST.CheckedPatListI("IdxDepIDCreateDate"," I"," "_admDepID,date))
				q:((date = "")||(date > endDate))
				s deadline = date + AOverdueTimeSpan
				q:(deadline >= dateNow)
				s rowID = ""
				f {
					s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxDepIDCreateDate"," I"," "_admDepID,date,rowID))
					q:(rowID = "")
					s objPat = ##class(DHCEPRFS.INST.CheckedPatList).%OpenId(rowID)
					s episodeID = objPat.EpisodeID
					d objPat.%Close()
					
					s admStatus=$p($g(^PAADM(episodeID)),"^",20)
					continue:(admStatus '= "D")
					//s expireMRCount = expireMRCount + 1
					
					s docSubmitLogID = "", docSubmitFlag = "0"
					s docSubmitLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxAction"," DHC"," "_episodeID," DOCTOR"," COMPLETE",docSubmitLogID))
					s:(docSubmitLogID '= "") docSubmitFlag = "1"
					s nurSubmitLogID = "", nurSubmitFlag = "0"
					s nurSubmitLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxAction"," DHC"," "_episodeID," NURSE"," COMPLETE",nurSubmitLogID))
					s:(nurSubmitLogID '= "") nurSubmitFlag = "1"
					continue:((docSubmitFlag = "0")||(nurSubmitFlag = "0"))
					s completeCount = completeCount + 1
					s admMRStatusID = ""
					s admMRStatusID = $o(^DHCEPRFS.INST.AdmMRStatusI("IdxEpisodeID"," DHC"," "_episodeID,admMRStatusID))
					continue:(admMRStatusID = "")
					s deptBackLogID = ""
					s deptBackLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxStatusAct"," "_admMRStatusID," DEPTBACK",deptBackLogID))
					s:(deptBackLogID '= "") deptBackCount = deptBackCount + 1
					s qcBackLogID = ""
					s qcBackLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxStatusAct"," "_admMRStatusID," QCBACK",qcBackLogID))
					s:(qcBackLogID '= "") qcBackCount = qcBackCount + 1
					s mrBackLogID = ""
					s mrBackLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxStatusAct"," "_admMRStatusID," BACK",mrBackLogID))
					s:(mrBackLogID '= "") mrBackCount = mrBackCount + 1
					s:((deptBackLogID '= "")||(qcBackLogID '= "")||(mrBackLogID '= "")) totalBackCount = totalBackCount + 1
				}
			}
			s deptBackRatio = 0, qcBackRatio = 0, mrBackRatio = 0, totalBackRatio = 0
			if (completeCount '= 0)
			{
				s deptBackRatio = deptBackCount / completeCount
				s deptBackRatio = $e(deptBackRatio,1,5)*100
				s qcBackRatio = qcBackCount / completeCount
				s qcBackRatio = $e(qcBackRatio,1,5)*100
				s mrBackRatio = mrBackCount / completeCount
				s mrBackRatio = $e(mrBackRatio,1,5)*100
				s totalBackRatio = totalBackCount / completeCount
				s totalBackRatio = $e(totalBackRatio,1,5)*100
			}
			
			s admDepDesc = $p($g(^CTLOC(admDepID)),"^",2)
			if ($l(admDepDesc,"-")>1)
			{
				s admDepDesc =$p(admDepDesc,"-",2)
			}
			s ^CacheTemp(repid,ind) = $lb(admDepID,admDepDesc,completeCount,deptBackCount,deptBackRatio_"%",qcBackCount,qcBackRatio_"%",mrBackCount,mrBackRatio_"%",totalBackCount,totalBackRatio_"%")
			s ind = ind + 1	
		}
	}
	q $$$OK
}

ClassMethod GetQCBackListByDeptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetQCBackListByDeptExecute ]
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

ClassMethod GetQCBackListByDeptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetQCBackListByDeptExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 逾期时间内科室病历退回详细信息
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLQualityReport","GetQCBackDtlByDept","2017-1-1","2017-12-31","6","7","0","0","0")
Query GetQCBackDtlByDept(AStartDate As %String, AEndDate As %String, ACTLocIDS As %String, AOverdueTimeSpan As %String, ADeptBackFlag As %String = "0", AQCBackFlag As %String = "0", AMRBackFlag As %String = "0") As %Query(ROWSPEC = "AdmDepID:%String,AdmDepDesc:%String,EpisodeID:%String,MedRecordNo:%String,RegNo:%String,Name:%String,DisDate:%String,PAAdmDocCodeDR:%String,CTMedUnitDesc:%String,CTNurUnitDesc:%String,DeptBackFlag:%String,QCBackFlag:%String,MRBackFlag:%String,DeptReviewDate:%String,QCReviewDate:%String,MRReviewDate:%String")
{
}

ClassMethod GetQCBackDtlByDeptExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, ACTLocIDS As %String, AOverdueTimeSpan As %String, ADeptBackFlag As %String = "0", AQCBackFlag As %String = "0", AMRBackFlag As %String = "0") As %Status
{
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	
	s:(AStartDate '= "") startDate = $zdh(AStartDate,3)
	s:(AEndDate '= "") endDate = $zdh(AEndDate,3)
	s dateNow = $p($h,",",1)
	
	f i=1:1:$l(ACTLocIDS,",")
	{
		s admDepID = $p(ACTLocIDS,",",i)
		s date = startDate - 1
		f {
			s date = $o(^DHCEPRFS.INST.CheckedPatListI("IdxDepIDCreateDate"," I"," "_admDepID,date))
			q:((date = "")||(date > endDate))
			s deadline = date + AOverdueTimeSpan
			q:(deadline >= dateNow)
			s rowID = ""
			f {
				s rowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxDepIDCreateDate"," I"," "_admDepID,date,rowID))
				q:(rowID = "")
				s objPat = ##class(DHCEPRFS.INST.CheckedPatList).%OpenId(rowID)
				s episodeID = objPat.EpisodeID
				s medRecordNo = objPat.MedRecordNo
				s regNo = objPat.RegNo
				s name = objPat.Name
				s ctMedUnitID = objPat.CTMedUnitID
				d objPat.%Close()
				
				s admStatus=$p($g(^PAADM(episodeID)),"^",20)
				continue:(admStatus '= "D")
				
				s docSubmitLogID = "", docSubmitFlag = "0"
				s docSubmitLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxAction"," DHC"," "_episodeID," DOCTOR"," COMPLETE",docSubmitLogID))
				s:(docSubmitLogID '= "") docSubmitFlag = "1"
				s nurSubmitLogID = "", nurSubmitFlag = "0"
				s nurSubmitLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxAction"," DHC"," "_episodeID," NURSE"," COMPLETE",nurSubmitLogID))
				s:(nurSubmitLogID '= "") nurSubmitFlag = "1"
				continue:((docSubmitFlag = "0")||(nurSubmitFlag = "0"))
				
				s admMRStatusID = ""
				s admMRStatusID = $o(^DHCEPRFS.INST.AdmMRStatusI("IdxEpisodeID"," DHC"," "_episodeID,admMRStatusID))
				continue:(admMRStatusID = "")
				s deptBackLogID = "", deptBackFlag = "0"
				s deptBackLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxStatusAct"," "_admMRStatusID," DEPTBACK",deptBackLogID))
				s:(deptBackLogID '= "") deptBackFlag = "1"
				s qcBackLogID = "", qcBackFlag = "0"
				s qcBackLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxStatusAct"," "_admMRStatusID," QCBACK",qcBackLogID))
				s:(qcBackLogID '= "") qcBackFlag = "1"
				s mrBackLogID = "", mrBackFlag = "0"
				s mrBackLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxStatusAct"," "_admMRStatusID," BACK",mrBackLogID))
				s:(mrBackLogID '= "") mrBackFlag = "1"
				
				//筛选科室、质控科、病案室是否退回
				if ((ADeptBackFlag = "1")&&(AQCBackFlag = "1")&&(AMRBackFlag = "1"))
				{
					continue:((deptBackFlag = "0")&&(qcBackFlag = "0")&&(mrBackFlag = "0"))
				}
				elseif (ADeptBackFlag = "1")
				{
					continue:(deptBackFlag '= ADeptBackFlag)
				}
				elseif (AQCBackFlag = "1")
				{
					continue:(qcBackFlag '= AQCBackFlag)
				}
				elseif (AMRBackFlag = "1")
				{
					continue:(mrBackFlag '= AMRBackFlag)
				}
				
				//患者就诊信息
				s admDepDesc = $p($g(^CTLOC(admDepID)),"^",2)
				if ($l(admDepDesc,"-")>1)
				{
					s admDepDesc =$p(admDepDesc,"-",2)
				}
				s paDisDate = $p($g(^PAADM(episodeID)),"^",17)
				s:(paDisDate '= "") disDate = $zd(paDisDate,3)
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
				
				//病案复核信息
				s deptReviewDate = ""
				s deptReviewLogID = ""
				s deptReviewLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxStatusAct"," "_admMRStatusID," DEPTREVIEWED",deptReviewLogID),-1)
				if (deptReviewLogID '= "")
				{
					s objDeptReviewLog = ##class(DHCEPRFS.INST.AdmMRStatusLog).%OpenId(deptReviewLogID)
					s deptReviewDate = objDeptReviewLog.ChangeDate
					d objDeptReviewLog.%Close()
				}
				s:(deptReviewDate '= "") deptReviewDate = $zd(deptReviewDate,3)
				s qcReviewDate = ""
				s qcReviewLogID = ""
				s qcReviewLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxStatusAct"," "_admMRStatusID," QCREVIEWED",qcReviewLogID),-1)
				if (qcReviewLogID '= "")
				{
					s objQCReviewLog = ##class(DHCEPRFS.INST.AdmMRStatusLog).%OpenId(qcReviewLogID)
					s qcReviewDate = objQCReviewLog.ChangeDate
					d objQCReviewLog.%Close()
				}
				s:(qcReviewDate '= "") qcReviewDate = $zd(qcReviewDate,3)
				s mrReviewDate = ""
				s mrReviewLogID = ""
				s mrReviewLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxStatusAct"," "_admMRStatusID," REVIEWED",qcReviewLogID),-1)
				if (mrReviewLogID '= "")
				{
					s objMRReviewLog = ##class(DHCEPRFS.INST.AdmMRStatusLog).%OpenId(mrReviewLogID)
					s mrReviewDate = objMRReviewLog.ChangeDate
					d objMRReviewLog.%Close()
				}
				s:(mrReviewDate '= "") mrReviewDate = $zd(mrReviewDate,3)
				
				s ^CacheTemp(repid,ind) = $lb(admDepID,admDepDesc,episodeID,medRecordNo,regNo,name,disDate,paAdmDocCodeDR,ctMUDesc,ctNUDesc,deptBackFlag,qcBackFlag,mrBackFlag,deptReviewDate,qcReviewDate,mrReviewDate)
				s ind = ind + 1
			}
		}
	}
	q $$$OK
}

ClassMethod GetQCBackDtlByDeptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetQCBackDtlByDeptExecute ]
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

ClassMethod GetQCBackDtlByDeptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetQCBackDtlByDeptExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Debug: w ##class(DHCEPRFS.BL.BLQualityReport).GetWorkDays(64465,64495)
ClassMethod GetWorkDays(AStartDate As %String, AEndDate As %String) As %String
{
	s count = 0
	s holidayCount = ##class(DHCWMR.SSService.HolidaysSrv).CountWorkDays(AStartDate,AEndDate)  //假日数
	s count = AEndDate - AStartDate - holidayCount
	q count
}

/// Desc: 按就诊表出院日期统计归档迟交信息
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLQualityReport","GetMRArchiveLateByAdm","2017-1-1","2017-12-31","6")
Query GetMRArchiveLateByAdm(AStartDate As %String, AEndDate As %String, ALocID As %String) As %Query(ROWSPEC = "DisLocDepDR:%String,DisLocDepDesc:%String,DischLocID:%String,DischLocDesc:%String,DischCount:%String,DeathCount:%String,Doc2DPromptCount:%String,Doc3DPromptCount:%String,Doc7DPromptCount:%String,Doc2DPromptRatio:%String,Doc3DPromptRatio:%String,Doc7DPromptRatio:%String,Nur5DPromptCount:%String,Nur7DPromptCount:%String,Nur5DPromptRatio:%String,Nur7DPromptRatio:%String")
{
}

ClassMethod GetMRArchiveLateByAdmExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, ALocID As %String) As %Status
{
	set repid = $I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	
	s:(AStartDate = $c(0)) AStartDate = ""
	s:(AEndDate = $c(0)) AEndDate = ""
	q:(AStartDate = "")||(AEndDate = "") $$$OK
	s startDate = $zdh(AStartDate,3)
	s endDate = $zdh(AEndDate,3)
	s dateNow = $p($h,",",1)
	
	k ^CacheTemp(repid,"DHCEPRFS","MRArchiveLateByAdm")
	
	if (ALocID '= "A")
	{
		s date = startDate - 1
		f {
			s date = $o(^PAADMi("DisDateDep",ALocID,date))
			q:(date = "")||(date > endDate)
			s episodeID = ""
			f {
				s episodeID = $o(^PAADMi("DisDateDep",ALocID,date,episodeID))
				q:(episodeID = "")
				d OutPutStatData
			}
		}
	}
	else
	{
		s date = startDate - 1
		f {
			s date = $o(^PAADMi("DischDate",date))
			q:(date = "")||(date > endDate)
			s episodeID = ""
			f {
				s episodeID = $o(^PAADMi("DischDate",date,episodeID))
				q:(episodeID = "")
				d OutPutStatData
			}
		}
	}
	
	s dischCount = 0, deathCount = 0
	s doc2DPromptCount = 0, doc3DPromptCount = 0, doc7DPromptCount = 0
	s doc3DPromptRatio = 0, doc3DPromptRatio = 0, doc7DPromptRatio = 0
	s nur5DPromptCount = 0, nur7DPromptCount = 0
	s nur5DPromptRatio = 0, nur7DPromptRatio = 0
	s dischTotal = 0, deathTotal = 0
	s doc2DTotalCount = 0, doc3DTotalCount = 0, doc7DTotalCount = 0
	s doc2DTotalRatio = 0, doc3DTotalRatio = 0, doc7DTotalRatio = 0
	s nur5DTotalCount = 0, nur7DTotalCount = 0
	s nur5DTotalRadio = 0, nur7DTotalRadio = 0
	s xLocID = ""
	f {
		s xLocID = $o(^CacheTemp(repid,"DHCEPRFS","MRArchiveLateByAdm",xLocID))
		q:(xLocID = "")
		s disLocDesc = $p($g(^CTLOC(xLocID)),"^",2)
		s:(disLocDesc["-") disLocDesc = $p(disLocDesc,"-",2)
		s disLocDepDR = $p($g(^CTLOC(xLocID)),"^",19)
		s disLocDepDesc = ""
		s:(disLocDepDR'="") disLocDepDesc = $p($g(^RBC("DEP",disLocDepDR)),"^",2)
		s dischCount = +$g(^CacheTemp(repid,"DHCEPRFS","MRArchiveLateByAdm",xLocID,"DischCount"))
		s doc2DPromptCount = +$g(^CacheTemp(repid,"DHCEPRFS","MRArchiveLateByAdm",xLocID,"Doc2DPromptCount"))
		s doc3DPromptCount = +$g(^CacheTemp(repid,"DHCEPRFS","MRArchiveLateByAdm",xLocID,"Doc3DPromptCount"))
		s doc7DPromptCount = +$g(^CacheTemp(repid,"DHCEPRFS","MRArchiveLateByAdm",xLocID,"Doc7DPromptCount"))
		s nur5DPromptCount = +$g(^CacheTemp(repid,"DHCEPRFS","MRArchiveLateByAdm",xLocID,"Nur5DPromptCount"))
		s nur7DPromptCount = +$g(^CacheTemp(repid,"DHCEPRFS","MRArchiveLateByAdm",xLocID,"Nur7DPromptCount"))
		s dischTotal = dischTotal + dischCount
		s doc2DTotalCount = doc2DTotalCount + doc2DPromptCount
		s doc3DTotalCount = doc3DTotalCount + doc3DPromptCount
		s doc7DTotalCount = doc7DTotalCount + doc7DPromptCount
		s nur5DTotalCount = nur5DTotalCount + nur5DPromptCount
		s nur7DTotalCount = nur7DTotalCount + nur7DPromptCount
		if (+dischCount > 0)
		{
			s doc2DPromptRatio = $fn((doc2DPromptCount/dischCount)*100,"",2)_"%"
			s doc3DPromptRatio = $fn((doc3DPromptCount/dischCount)*100,"",2)_"%"
			s doc7DPromptRatio = $fn((doc7DPromptCount/dischCount)*100,"",2)_"%"
			s nur5DPromptRatio = $fn((nur5DPromptCount/dischCount)*100,"",2)_"%"
			s nur7DPromptRatio = $fn((nur7DPromptCount/dischCount)*100,"",2)_"%"
		}
		else {
			s doc2DPromptRatio = "-"
			s doc3DPromptRatio = "-"
			s doc7DPromptRatio = "-"
			s nur5DPromptRatio = "-"
			s nur7DPromptRatio = "-"
		}
		s ^CacheTemp(repid,ind) = $lb(disLocDepDR,disLocDepDesc,xLocID,disLocDesc,dischCount,deathCount,doc2DPromptCount,doc3DPromptCount,doc7DPromptCount,doc2DPromptRatio,doc3DPromptRatio,doc7DPromptRatio,nur5DPromptCount,nur7DPromptCount,nur5DPromptRatio,nur7DPromptRatio)
		s ind = ind + 1
	}
	if (+dischTotal > 0)
	{
		s doc2DTotalRatio = $fn((doc2DTotalCount/dischTotal)*100,"",2)_"%"
		s doc3DTotalRatio = $fn((doc3DTotalCount/dischTotal)*100,"",2)_"%"
		s doc7DTotalRatio = $fn((doc7DTotalCount/dischTotal)*100,"",2)_"%"
		s nur5DTotalRadio = $fn((nur5DTotalCount/dischTotal)*100,"",2)_"%"
		s nur7DTotalRadio = $fn((nur7DTotalCount/dischTotal)*100,"",2)_"%"
	}
	else {
		s doc2DTotalRatio = "-"
		s doc3DTotalRatio = "-"
		s doc7DTotalRatio = "-"
		s nur5DTotalRadio = "-"
		s nur7DTotalRadio = "-"
	}
	s ^CacheTemp(repid,ind) = $lb("A","合计","A","合计",dischTotal,deathTotal,doc2DTotalCount,doc3DTotalCount,doc7DTotalCount,doc2DTotalRatio,doc3DTotalRatio,doc7DTotalRatio,nur5DTotalCount,nur7DTotalCount,nur5DTotalRadio,nur7DTotalRadio)
	s ind = ind + 1
	
	k ^CacheTemp(repid,"DHCEPRFS","MRArchiveLateByAdm")
	q $$$OK
OutPutStatData
	s paAdmStatus = $p($g(^PAADM(episodeID)),"^",20)
	q:(paAdmStatus '= "D")
	s paAdmLoc = $p($g(^PAADM(episodeID)),"^",4)
	s disNum = $i(^CacheTemp(repid,"DHCEPRFS","MRArchiveLateByAdm",paAdmLoc,"DischCount"))
	
	s docSubmitLogID = ""
	s docSubmitLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxAction"," DHC"," "_episodeID," DOCTOR"," COMPLETE",docSubmitLogID))
	if (docSubmitLogID '= "")
	{
		s objDocSubmitLog = ##class(DHCEPRFS.INST.AdmMRStatusLog).%OpenId(docSubmitLogID)
		s docSubmitDate = objDocSubmitLog.ChangeDate
		d objDocSubmitLog.%Close()
		s docSubmitSpan = ..GetWorkDays(date,docSubmitDate)
		s:docSubmitSpan<3 docNum = $i(^CacheTemp(repid,"DHCEPRFS","MRArchiveLateByAdm",paAdmLoc,"Doc2DPromptCount"))
		s:docSubmitSpan<4 docNum = $i(^CacheTemp(repid,"DHCEPRFS","MRArchiveLateByAdm",paAdmLoc,"Doc3DPromptCount"))
		s:docSubmitSpan<8 docNum = $i(^CacheTemp(repid,"DHCEPRFS","MRArchiveLateByAdm",paAdmLoc,"Doc7DPromptCount"))
	}
	s nurSubmitLogID = ""
	s nurSubmitLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxAction"," DHC"," "_episodeID," NURSE"," COMPLETE",nurSubmitLogID))
	if (nurSubmitLogID '= "")
	{
		s objNurSubmitLog = ##class(DHCEPRFS.INST.AdmMRStatusLog).%OpenId(nurSubmitLogID)
		s nurSubmitDate = objNurSubmitLog.ChangeDate
		d objNurSubmitLog.%Close()
		s nurSubmitSpan = ..GetWorkDays(date,nurSubmitDate)
		s:nurSubmitSpan<6 nurNum = $i(^CacheTemp(repid,"DHCEPRFS","MRArchiveLateByAdm",paAdmLoc,"Nur5DPromptCount"))
		s:nurSubmitSpan<8 nurNum = $i(^CacheTemp(repid,"DHCEPRFS","MRArchiveLateByAdm",paAdmLoc,"Nur7DPromptCount"))
	}
	q
}

ClassMethod GetMRArchiveLateByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMRArchiveLateByAdmExecute ]
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

ClassMethod GetMRArchiveLateByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMRArchiveLateByAdmExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 按就诊表出院日期统计中心科室、二级科室归档迟交详细信息
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLQualityReport","GetMRArchiveLateDetail","2017-1-1","2017-12-31","2","6")
Query GetMRArchiveLateDetail(AStartDate As %String, AEndDate As %String, ALocDepDR As %String, ALocID As %String) As %Query(ROWSPEC = "EpisodeID:%String,PatName:%String,MedRecordNo:%String,DisLocDesc:%String,DischDate:%String,PAAdmDoctor:%String,DeathFlag:%String,DocSubmitDate:%String,NurSubmitDate:%String,DocSubmitLateDays:%String,NurSubmitLateDays:%String")
{
}

ClassMethod GetMRArchiveLateDetailExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, ALocDepDR As %String, ALocID As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	
	s:(AStartDate = $c(0)) AStartDate = ""
	s:(AEndDate = $c(0)) AEndDate = ""
	q:(AStartDate = "")||(AEndDate = "") $$$OK
	s startDate = $zdh(AStartDate,3)
	s endDate = $zdh(AEndDate,3)
	s dateNow = $p($h,",",1)
	
	if (ALocID '= "A")
	{
		s date = startDate - 1
		f {
			s date = $o(^PAADMi("DisDateDep",ALocID,date))
			q:(date = "")||(date > endDate)
			s episodeID = ""
			f {
				s episodeID = $o(^PAADMi("DisDateDep",ALocID,date,episodeID))
				q:(episodeID = "")
				d OutPutDtlData
			}
		}
	}
	else
	{
		s xLocID = ""
		f {
			s xLocID  = $o(^CTLOC(0,"DepGrp",ALocDepDR,xLocID))
			q:(xLocID = "")
			s date = startDate - 1
			f {
				s date = $o(^PAADMi("DisDateDep",xLocID,date))
				q:(date = "")||(date > endDate)
				s episodeID = ""
				f {
					s episodeID = $o(^PAADMi("DisDateDep",xLocID,date,episodeID))
					q:(episodeID = "")
					d OutPutDtlData
				}
			}
		}
	}
	
	q $$$OK
OutPutDtlData
	s paAdmData = $g(^PAADM(episodeID))
	s paAdmStatus = $p(paAdmData,"^",20)
	q:(paAdmStatus '= "D")
	
	s patientID = $p(paAdmData,"^",1)
	s patName = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetName(patientID)
	s medRecordNo = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetMedRecordNo(patientID,"",episodeID)
	s paAdmLoc = $p(paAdmData,"^",4)
	s disLocDesc = $p($g(^CTLOC(paAdmLoc)),"^",2)
	s:(disLocDesc["-") disLocDesc = $p(disLocDesc,"-",2)
	s dischDate = "", dischTime = ""
	s paDisDate = $p(paAdmData,"^",17)
	s:(paDisDate '= "") dischDate = $zd(paDisDate,3)
	s paDisTime = $p(paAdmData,"^",18)
	s:(paDisTime '= "") dischTime = $zt(paDisTime)
	s paAdmDoctor = ""
	s paAdmDocCodeDR=$p(paAdmData,"^",9)
	s:(paAdmDocCodeDR '= "") paAdmDoctor = $p($g(^CTPCP(paAdmDocCodeDR,1)),"^",2)
	
	s docSubmitLogID = "", docSubmitDate = ""
	s docSubmitLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxAction"," DHC"," "_episodeID," DOCTOR"," COMPLETE",docSubmitLogID))
	if (docSubmitLogID '= "")
	{
		s objDocSubmitLog = ##class(DHCEPRFS.INST.AdmMRStatusLog).%OpenId(docSubmitLogID)
		s docSubmitDate = objDocSubmitLog.ChangeDate
		d objDocSubmitLog.%Close()
		s docSubmitSpan = "0"
		s docSubmitSpan = ..GetWorkDays(date,docSubmitDate)
	}
	else
	{
		s docSubmitSpan = ..GetWorkDays(date,dateNow)
	}
	s:(docSubmitDate '= "") docSubmitDate = $zd(docSubmitDate,3)
	s docSubmitLimit = 2, docSubmitLateDays = 0
	if (+docSubmitSpan > docSubmitLimit) {
		s docSubmitLateDays = +(docSubmitSpan - docSubmitLimit)
	}
	s nurSubmitLogID = "", nurSubmitDate = ""
	s nurSubmitLogID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxAction"," DHC"," "_episodeID," NURSE"," COMPLETE",nurSubmitLogID))
	if (nurSubmitLogID '= "")
	{
		s objNurSubmitLog = ##class(DHCEPRFS.INST.AdmMRStatusLog).%OpenId(nurSubmitLogID)
		s nurSubmitDate = objNurSubmitLog.ChangeDate
		d objNurSubmitLog.%Close()
		s nurSubmitSpan = "0"
		s nurSubmitSpan = ..GetWorkDays(date,nurSubmitDate)
	}
	else
	{
		s nurSubmitSpan = ..GetWorkDays(date,dateNow)
	}
	s:(nurSubmitDate '= "") nurSubmitDate = $zd(nurSubmitDate,3)
	s nurSubmitLimit = 5, nurSubmitLateDays = 0
	if (+nurSubmitSpan > nurSubmitLimit) {
		s nurSubmitLateDays = +(nurSubmitSpan - nurSubmitLimit)
	}
	
	s mrEpisodeID = $O(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID", " DHC", " "_episodeID, ""))
	if (mrEpisodeID="")
	{
		s deathDate = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DeathDateTime(patientID)
	}
	else
	{
		s deathDate = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetDeathDate(mrEpisodeID)
	}
	s deathFlag = "否"
	s:(deathDate'="") deathFlag="是"
	
	
	s ^CacheTemp(repid,ind) = $lb(episodeID,patName,medRecordNo,disLocDesc,dischDate,paAdmDoctor,deathFlag,docSubmitDate,nurSubmitDate,docSubmitLateDays,nurSubmitLateDays)
	s ind = ind + 1
	q
}

ClassMethod GetMRArchiveLateDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMRArchiveLateDetailExecute ]
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

ClassMethod GetMRArchiveLateDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMRArchiveLateDetailExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
