/// Class Name:		EPRservice.Quality.BOQualityJob
/// Description:	Automation task and JIT monitor
/// Author:			Zuoxiang Xie
/// Create Date:	2010-07-26
/// Version:	
Class EPRservice.Quality.BOQualityJob Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	后台自动任务入口方法
/// Input:	AAdmitRuleCode为在院质控标准代码;
/// 		ADischRuleCode为出院质控标准代码;
///         AManualRuleCode 为手工评分质控标准代码;
/// 		AJobDate为自动任务日期,若未指定,则默认为系统当前日期;  
/// Result:	ret=1成功; ret=0参数错误; ret=-1失败
/// Debug:	w ##Class(EPRservice.Quality.BOQualityJob).RunQualityJob("F","G","A","2010-09-26 01:00:00")
ClassMethod RunQualityJob(AAdmitRuleCode As %String, ADischRuleCode As %String, AManualRuleCode As %String, AJobDate As %String = "") As %String
{
	s ret = 0
	q:(AAdmitRuleCode = "")||(ADischRuleCode = "") ret
	
	s JobDate = $g(AJobDate)
	s:(JobDate = "") JobDate = $zd($p($h,",",1),3)_" "_$zt($p($h,",",2),1)	
	s IsBSQualityEnable=##Class(EPRservice.Quality.CommonHelper).IsBSQualityEnable()  //BS版本质控维护程序是否启用
	s:(IsBSQualityEnable="Y") AdmitRuleID = $o(^CT.MA.QC.QualityRuleI("IdxCode",AAdmitRuleCode,""))
	s:(IsBSQualityEnable'="Y") AdmitRuleID = $o(^DHCEPRM.QualityRuleI("IdxCode",AAdmitRuleCode,""))
	q:(AdmitRuleID = "") ret
	
	s:(IsBSQualityEnable="Y") AManualRuleID =$o(^CT.MA.QC.QualityRuleI("IdxCode",AManualRuleCode,""))
	s:(IsBSQualityEnable'="Y") AManualRuleID = $o(^DHCEPRM.QualityRuleI("IdxCode",AManualRuleCode,""))
	q:(AManualRuleID = "") ret
	
	s:(IsBSQualityEnable="Y") AdmitRuleDesc = $list($g(^CT.MA.QC.QualityRuleD(+AdmitRuleID)),3)
	s:(IsBSQualityEnable'="Y") AdmitRuleDesc = $list($g(^DHCEPRM.QualityRuleD(+AdmitRuleID)),2)
	s AdmitFlag = ..AutoJobByAdmit(AdmitRuleID,JobDate,AManualRuleID)
	s Status = $s(AdmitFlag > 0:"Succeed", 1:"Failure")
	s ^DHCEPRQERSTLog("AutoJob_Admit",AdmitRuleID,JobDate) = $lb(Status)
	
	s:(IsBSQualityEnable="Y") DischRuleID = $o(^CT.MA.QC.QualityRuleI("IdxCode",ADischRuleCode,""))
	s:(IsBSQualityEnable'="Y") DischRuleID = $o(^DHCEPRM.QualityRuleI("IdxCode",ADischRuleCode,""))
	q:(DischRuleID = "") ret
	
	s:(IsBSQualityEnable="Y") DischRuleDesc = $list($g(^CT.MA.QC.QualityRuleD(+DischRuleID)),3)
	s:(IsBSQualityEnable'="Y") DischRuleDesc = $list($g(^DHCEPRM.QualityRuleD(+DischRuleID)),2)
	s Days = 5
	if (IsBSQualityEnable="Y")
	{
		s ParamID = $o(^CT.MA.QC.QualityParamsI("IdxCode","AutoDischDays",""))
		s:(ParamID '= "") Days = +$list($g(^CT.MA.QC.QualityParamsD(+ParamID)),4)
		
	}
	else
	{
		s ParamID = $o(^DHCEPRM.QualityParamsI("IdxCode","AutoDischDays",""))
		s:(ParamID '= "") Days = +$list($g(^DHCEPRM.QualityParamsD(+ParamID)),2)
	}
	s DischFlag = ..AutoJobByDisch(DischRuleID,JobDate,Days,AdmitRuleID,AManualRuleID)
	s Status = $s(DischFlag > 0:"Succeed", 1:"Failure")
	s ^DHCEPRQERSTLog("AutoJob_Disch",DischRuleID,JobDate,Days) = $lb(Status)
	
	d ..CopyResultDataToDailyResult(JobDate)
	s ret = 1
	q ret
}

/// d ##class(EPRservice.Quality.BOQualityJob).CopyResultDataToDailyResult("2018-05-03")
ClassMethod CopyResultDataToDailyResult(JobDate)
{
	s ExamineDate=$p(JobDate," ",1)
	s tmpRetID=""
	for
	{
		s tmpRetID=$o(^DHCEPRQ.QualityResultI("IdxExamineDate"," "_ExamineDate,tmpRetID))
		q:(tmpRetID="")
		
		s objRet=##class(EPRinstance.Quality.QualityResult).%OpenId(tmpRetID)
		
		s tmpAction=objRet.Action
		s tmpActualDeScore=objRet.ActualDeScore
		
		s tmpActualGrade=objRet.ActualGrade
		s tmpActualScore=objRet.ActualScore
		
		s tmpEpisodeID=objRet.EpisodeID
		s tmpExamineDate=objRet.ExamineDate
		
		s tmpExamineTime=objRet.ExamineTime
		s tmpExecuteDate=objRet.ExecuteDate
		s tmpExecuteTime=objRet.ExecuteTime
		s tmpGradeDR=objRet.GradeDR
		s tmpIsActive=objRet.IsActive
		s tmpResumeText=objRet.ResumeText
		s tmpRuleDR=objRet.RuleDR
		
		s tmpSignUserDR=objRet.SignUserDR
		
		s tmpDetails=objRet.Details
		s key=""
		For  
	    {
	        Set detailData=tmpDetails.GetNext(.key) 
	        Quit:key=""  
			s (tmpEntryDR,tmpEntryScore,tmpEntryGrade,tmpInstanceId,tmpEmrDocId,tmpTriggerDate,tmpResumeTextDet,tmpExamCount)=""
			s tmpEntryDR = detailData.EntryDR
			s tmpEntryScore = detailData.EntryScore
			s tmpEntryGrade = detailData.EntryGrade
			s tmpInstanceId = detailData.InstanceId 
			s tmpEmrDocId = detailData.EmrDocId
			s tmpTriggerDate = detailData.TriggerDate
			s tmpResumeTextDet = detailData.ResumeText
			s tmpExamCount = detailData.ExamCount
			
			s objRetDailyDet=##class(EPRinstance.Quality.QualityResultDailyDetail).%New()
			s objRetDailyDet.Action=tmpAction
			s objRetDailyDet.ActualDeScore=tmpActualDeScore
			s objRetDailyDet.ActualGrade=tmpActualGrade
			s objRetDailyDet.ActualScore=tmpActualScore
			s objRetDailyDet.EmrDocId = tmpEmrDocId
			s objRetDailyDet.EntryDR=tmpEntryDR
			s objRetDailyDet.EntryGrade = tmpEntryGrade
			s objRetDailyDet.EntryScore = tmpEntryScore
			s objRetDailyDet.EpisodeID = tmpEpisodeID
			s objRetDailyDet.ExamCount = tmpExamCount
			s objRetDailyDet.ExamineDate = tmpExamineDate
			s objRetDailyDet.ExamineTime = tmpExamineTime
			s objRetDailyDet.ExecuteDate = tmpExecuteDate
			s objRetDailyDet.ExecuteTime = tmpExecuteTime
			s objRetDailyDet.GradeDR = tmpGradeDR
			s objRetDailyDet.InstanceId = tmpInstanceId
			s objRetDailyDet.IsActive = tmpIsActive
			
			s objRetDailyDet.ResumeText = tmpResumeText_"^"_tmpResumeTextDet
			s objRetDailyDet.RuleDR = tmpRuleDR
			s objRetDailyDet.SignUserDR = tmpSignUserDR
			s objRetDailyDet.TriggerDate = tmpTriggerDate
			
			d objRetDailyDet.%Save()
			d objRetDailyDet.%Close()	
		}
		
	}
}

/// Desc:	自动任务检查在院患者病历质量
/// Input:	ARuleID为在院质控标准RowID;
/// 		AJobDate为自动任务检查日期;
///         AManualRuleID为手工评分质控标准RowID
/// Output:	ret<=0失败; ret>0成功;
/// Debug:	w ##Class(EPRservice.Quality.BOQualityJob).AutoJobByAdmit(6,"2023-05-22","1")
ClassMethod AutoJobByAdmit(ARuleID As %String, AJobDate As %String, AManualRuleID As %String) As %String
{
	s ret = 0
	q:(ARuleID = "")||(AJobDate = "") ret
	s UniqueKey = $i(^CacheTemp)
	s Action="A"
	s IsBSQualityEnable=##Class(EPRservice.Quality.CommonHelper).IsBSQualityEnable()  //BS版本质控维护程序是否启用
	// 清除所有之前的在院质控数据
	s flag = ##Class(EPRservice.Quality.DataAccess.BOQualityResult).ClearDataByRuleID(ARuleID)
	q:(flag < 1) ret
	s WardID = 0
	for {
		s WardID = $o(^PAWARD(WardID))
		q:(WardID = "")||('$ISVALIDNUM(WardID))
		s objWard = $g(^PAWARD(+WardID))
		continue:(objWard = "")
		s IsWardActive = $p(objWard,"^",6)
		continue:(IsWardActive '= "Y")
		continue:'$d(^PAADMi("CurrWard",WardID))
		s RoomID = 0
		for {
			s RoomID = $o(^PAADMi("CurrWard",WardID,RoomID))
			q:(RoomID = "")
			s EpisodeID = ""
			for {
				s EpisodeID = $o(^PAADMi("CurrWard",WardID,RoomID,EpisodeID))
				q:(EpisodeID = "")
				
				//检查就诊是否有效
				s Flag = ##Class(EPRservice.Quality.CommonHelper).CheckAdmUserful(+EpisodeID)
				continue:(Flag < 1)
				
				s objPaAdm = $g(^PAADM(+EpisodeID))
				continue:(objPaAdm = "")
				
				s VisitStatus = $p(objPaAdm,"^",20)
				continue:(VisitStatus '= "A")
				
				s AdmType = $p(objPaAdm,"^",2)
				continue:(AdmType '= "I")
				
				s AdmLocID = $p(objPaAdm,"^",4)
				continue:(AdmLocID = "")
				
				s AdmDocID = $p(objPaAdm,"^",9)
				if (AdmDocID '= "")
				{
					s AdmDoctor = $p($g(^CTPCP(AdmDocID,1)),"^",2)
				}
				else
				{
					s AdmDocID = -1
					s AdmDoctor = "未指定"	
				}
				s Employee = AdmDocID_"||"_AdmDoctor
				
				//起始质控结构
				s StructId = ##Class(EPRservice.Quality.DataAccess.BOQualitySetting).GetRootStructID(AdmLocID,ARuleID)
				continue:(StructId = "")
				
				//创建质控结果
				s RString = EpisodeID_"^"_ARuleID_"^"_AJobDate_"^"_"-1"
				s ResultID = ##Class(EPRservice.Quality.DataAccess.BOQualityResult).CreateQualityResult(RString)
				continue:(ResultID < 0)
				
				s arryParam = ##Class(%ArrayOfDataTypes).%New()
				d arryParam.SetAt(ResultID,"ResultID")
				d arryParam.SetAt(Employee,"Employee")
				d arryParam.SetAt(AdmLocID,"LocID")
				d arryParam.SetAt(AJobDate,"JobDate")
				
				//根据质控结构检查质控条目
				s:(IsBSQualityEnable'="Y") count = ##Class(EPRservice.Quality.DataAccess.BOQualityStruct).CheckStruct(StructId,ARuleID,EpisodeID,UniqueKey,"AutoJob",arryParam)
				s:(IsBSQualityEnable="Y") count = ##Class(EPRservice.Quality.DataAccess.BOQualityStruct).CheckStructNew(StructId,ARuleID,EpisodeID,UniqueKey,"AutoJob",arryParam)
				//计算分数级别
				s TempObj = ##Class(EPRservice.Quality.OperationLogic.EvaluationResult).CreateInstance()
				s ActualScore = TempObj.GetEvaluationResult(EpisodeID,ARuleID)
				d ##Class(EPRservice.Quality.DataAccess.BOQualityResult).SetActualScore(ActualScore,ResultID)
				
				//计算终末分数级别(加入手工评分)
				s RuleIDs = ARuleID_"^"_AManualRuleID 
				s ActualScore = TempObj.GetEvaluationResult(EpisodeID,RuleIDs,Action)
				s LastScore =  ##Class(EPRservice.Quality.DataAccess.BOQualityResult).SetLastScore(ActualScore,ARuleID,EpisodeID,AJobDate)
				d TempObj.%Close()
				s TempObj = ""		
			}
		}	
	}
	s ret = 1
	q ret
}

/// Desc:	归档病历质控自动任务;
/// Input:	ret<=0为失败; ret>0为成功;
/// Output:	只查询就诊状态为'Discharge'的就诊记录
/// Debug:	w ##Class(EPRservice.Quality.BOQualityJob).AutoJobByDisch(7,"2014-01-01",5,6)
ClassMethod AutoJobByDisch(ARuleID As %String, AJobDate As %String, ADays As %String, AdmitRuleID As %String, AManualRuleID As %String) As %String
{
	s ret = 0
	q:(ARuleID = "")||(AJobDate = "") ret
	s Action="D"
	s JobDate = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AJobDate)
	s JobDate = +$p(JobDate," ",1)
	s ADays = +$g(ADays)
	s DischDate = JobDate - ADays
	s IsBSQualityEnable=##Class(EPRservice.Quality.CommonHelper).IsBSQualityEnable()  //BS版本质控维护程序是否启用
	s UniqueKey = $i(^CacheTemp)

	s EpisodeID = ""
	for {
		s EpisodeID = $o(^PAADMi("DischDate",DischDate,EpisodeID))
		q:(EpisodeID = "")
				
		// 检查就诊是否有效
		s flag = ##Class(EPRservice.Quality.CommonHelper).CheckAdmUserful(+EpisodeID)
		continue:(flag < 1)
		
		s objPaAdm = $g(^PAADM(+EpisodeID))
		continue:(objPaAdm = "")
		
		s VisitStatus = $p(objPaAdm,"^",20)
		continue:(VisitStatus '= "D") 
		
		s AdmType = $p(objPaAdm,"^",2)
		continue:(AdmType '= "I")
		
		s AdmLocID = $p(objPaAdm,"^",4)
		continue:(AdmLocID = "")
		
		s AdmDocID = $p(objPaAdm,"^",9)
		if (AdmDocID '= "")
		{
			s AdmDoctor = $p($g(^CTPCP(AdmDocID,1)),"^",2)
		}
		else
		{
			s AdmDocID = -1, AdmDoctor = "未指定"
		}
		s Employee = AdmDocID_"||"_AdmDoctor
		
		//起始质控结构
		s StructId = ##Class(EPRservice.Quality.DataAccess.BOQualitySetting).GetRootStructID(AdmLocID,ARuleID)
		continue:(StructId = "")
		
		//清除在院数据
		s ClearFlag = ##Class(EPRservice.Quality.DataAccess.BOQualityResult).ClearLastJobData(EpisodeID,AdmitRuleID)
		continue:(ClearFlag <= 0)
		
		//创建质控结果
		s RString = EpisodeID_"^"_ARuleID_"^"_AJobDate_"^"_"-1"
		s ResultID = ##Class(EPRservice.Quality.DataAccess.BOQualityResult).CreateQualityResult(RString)

		s arryParam = ##Class(%ArrayOfDataTypes).%New()
		d arryParam.SetAt(ResultID,"ResultID")
		d arryParam.SetAt(Employee,"Employee")
		d arryParam.SetAt(AdmLocID,"LocID")
		d arryParam.SetAt(AJobDate,"JobDate")
	
		//根据质控结构检查质控条目
		s:(IsBSQualityEnable'="Y") count = ##Class(EPRservice.Quality.DataAccess.BOQualityStruct).CheckStruct(StructId,ARuleID,EpisodeID,UniqueKey,"AutoJob",arryParam)
        s:(IsBSQualityEnable="Y") count = ##Class(EPRservice.Quality.DataAccess.BOQualityStruct).CheckStructNew(StructId,ARuleID,EpisodeID,UniqueKey,"AutoJob",arryParam)
		//计算分数级别
		s TempObj = ##Class(EPRservice.Quality.OperationLogic.EvaluationResult).CreateInstance()
		s ActualScore = TempObj.GetEvaluationResult(EpisodeID,ARuleID)
		d ##Class(EPRservice.Quality.DataAccess.BOQualityResult).SetActualScore(ActualScore,ResultID)
		
		//计算终末分数级别(加入手工评分)
		s RuleIDs = ARuleID_"^"_AManualRuleID  
		s ActualScore = TempObj.GetEvaluationResult(EpisodeID,RuleIDs,Action)
		s LastScore =  ##Class(EPRservice.Quality.DataAccess.BOQualityResult).SetLastScore(ActualScore,ARuleID,EpisodeID,AJobDate)
		d TempObj.%Close()
		s TempObj = ""
	}
	s ret = 1
	q ret
}

/// Creator:		Zuoxiang Xie
/// CreatDate:		2010-12-14
/// Description:	运行态病历质量监控(适用于医务科和临床医生);
/// Table:       	无
/// Input:			ALocID为科室RowID;
/// 				AWardID为病区RowID(注意该RowID为病区在Ct_Loc表中的RowID);
/// 				ADoctorID为主治医RowID;
/// 				ARuleID为选择质控标准RowID;
/// 				ARegNo为患者登记号;
/// 				APatientName为患者姓名;
/// 				AType为监控类型(1:临床医生;0:医务科);
/// Output: 		运行态病历监控结果;
/// Return:			column = (RuleID,EpisodeID,RegNo,Name,Sex,BirthDate,Age,LocDesc,DocDesc,WardDesc,RoomDesc,BedDesc,AdmDateTime,DischDateTime,Score,Count,PatientID)
/// Others:			d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityJob","GetJITQualityList","6","","","2","0000000048","","62719","63455")
Query GetJITQualityList(ALocID As %String, AWardID As %String, ADoctorID As %String, ARuleID As %String, ARegNo As %String, APatientName As %String, AFromDate As %String, AToDate As %String, AStructID As %String, AType As %String = "0") As %Query(ROWSPEC = "RuleID,EpisodeID,RegNo,Name,Sex,BirthDate,Age,LocDesc,DocDesc,WardDesc,RoomDesc,BedDesc,AdmDateTime,DischDateTime,Score,Count,PatientID")
{
}

ClassMethod GetJITQualityListExecute(ByRef qHandle As %Binary, ALocID As %String, AWardID As %String, ADoctorID As %String, ARuleID As %String, ARegNo As %String, APatientName As %String, AFromDate As %String, AToDate As %String, AStructID As %String, AType As %String = "0") As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	q:(ARuleID = "")||($d(ARuleID) = 0)||(AStructID = "") $$$OK	
	s UniqueKey = repid
	s:(AFromDate '= "") AFromDate = ##Class(EPRservice.Quality.CommonHelper).ChangeDateToNum(AFromDate)
	s:(AToDate '= "") AToDate = ##Class(EPRservice.Quality.CommonHelper).ChangeDateToNum(AToDate)	
	q:((AType = 1)&&(ADoctorID = "")) $$$OK
	s curLogonDocID = $s(AType="1":ADoctorID,1:"") 

	k ^CacheTemp("EPRQuality","JITMonitor",UniqueKey)
	
	if (ARegNo '= "")
	{
		s PatientID = $o(^PAPERi("PAPMI_PatNo",ARegNo,""))
		q:(PatientID = "") $$$OK
		
		//根据PatientID去取 
		s EpisodeID = ""
		for {
			s EpisodeID = $o(^PAPERdr(PatientID,"ADM","I",EpisodeID))
			q:(EpisodeID = "")
			s flag = ..BuildMonitorData("","",curLogonDocID,ARuleID,EpisodeID,"","",AStructID,UniqueKey)
			continue:(flag < 0)
		}	
	}
	elseif (APatientName '= "")
	{
		s PatientID = ""
		for {
			s PatientID = $o(^PAPERi("PAPER_PatName",APatientName,PatientID))
			q:(PatientID = "") 
			s EpisodeID = ""
			for {
				s EpisodeID = $o(^PAPERdr(PatientID,"ADM","I",EpisodeID))
				q:(EpisodeID = "")
				s flag = ..BuildMonitorData("","",curLogonDocID,ARuleID,EpisodeID,"","",AStructID,UniqueKey)
				continue:(flag < 0)
			}	
		}
	}
	else
	{
		s WardID = $g(AWardID)
		s:(WardID '= "") WardID = $o(^PAWARD(0,"WARD_LocationDR",WardID,""))
		q:(ALocID = "")&&(WardID = "") $$$OK
		
		s EpisodeID = ""
		for {
			s EpisodeID = $o(^PAADMi("AdmTypeCurr","I",EpisodeID))
			q:(EpisodeID = "")
			s flag = ..BuildMonitorData(ALocID,WardID,ADoctorID,ARuleID,EpisodeID,AFromDate,AToDate,AStructID,UniqueKey)
			continue:(flag < 0)
		}
	}
	s TmpWard = ""
	for {
		s TmpWard = $o(^CacheTemp("EPRQuality","JITMonitor",UniqueKey,TmpWard))	
		q:(TmpWard = "")
		
		s TmpBed = ""
		for {
			s TmpBed = $o(^CacheTemp("EPRQuality","JITMonitor",UniqueKey,TmpWard,TmpBed))
			q:(TmpBed = "")
			
			s TmpAdmID = ""
			for {
				s TmpAdmID = $o(^CacheTemp("EPRQuality","JITMonitor",UniqueKey,TmpWard,TmpBed,TmpAdmID))
				q:(TmpAdmID = "")
				
				s Data = $g(^CacheTemp("EPRQuality","JITMonitor",UniqueKey,TmpWard,TmpBed,TmpAdmID))
				s ^CacheTemp(repid,ind) = Data
				s ind = ind + 1	
			}	
		}
	}
	s TotalCount = ind -1
	w "病历总数:"_ TotalCount _" 缺陷病历数:"_+$g(^CacheTemp("EPRQuality","JITMonitor",UniqueKey,"disqualification")) 
	k ^CacheTemp("EPRQuality","JITMonitor",UniqueKey)
	
	q $$$OK
}

ClassMethod BuildMonitorData(ALocID As %String, AWardID As %String, ADoctorID As %String, ARuleID As %String, AEpisodeID As %String, AStartDate As %String, AEndDate As %String, AStructID As %String, AUniqueKey As %String) As %String
{
	s ret = -1
	q:(AStructID = "")||(ARuleID = "") ret
	//检查就诊是否有效
	s flag = ##Class(EPRservice.Quality.CommonHelper).CheckAdmUserful(+AEpisodeID)
	q:(flag < 1) ret
	s objAdm = $g(^PAADM(+AEpisodeID))
	
	s AdmType = $p(objAdm,"^",2)
	q:(AdmType '= "I") ret
	
	s VisitStatus = $p(objAdm,"^",20)
	q:(VisitStatus '= "A") ret
		
	s AdmLocID = $p(objAdm,"^",4)
	q:(AdmLocID = "") ret
	q:(ALocID '= "")&&(AdmLocID '= ALocID) ret
	
	s AdmWardID = $p(objAdm,"^",70)
	q:(AdmWardID = "") ret
	q:(AWardID '= "")&&(AdmWardID '= AWardID) ret
	
	//检查医生
	s AdmDocID = $p(objAdm,"^",9)
	q:(ADoctorID '= "")&&(AdmDocID '= ADoctorID) ret
		
	//检查日期范围
	s AdmDate = $p(objAdm,"^",6)
	q:(AStartDate '= "")&&(AdmDate < AStartDate) ret
	q:(AEndDate '= "")&&(AdmDate > AEndDate) ret
		
	s (RegNo,Name,Sex,BirthDate,Age,LocDesc,DocDesc,WardDesc,RoomDesc,BedDesc,AdmDate,AdmTime,AdmDateTime,DischgDate,DischgTime,DischDateTime,Score,Count) = $C(0)
	s result = ##Class(EPRservice.Quality.DataAccess.BOQualityStruct).CheckStruct(AStructID,ARuleID,AEpisodeID,AUniqueKey,"","")
	s Score = 0
	s Count = result
	s tmp = $g(^PAADM(+AEpisodeID))
	s Papmi = +$p(tmp,"^",1)
	s RegNo = $p(^PAPER(Papmi,"PAT",1),"^",1)
	s Name = $p($g(^PAPER(Papmi,"ALL")),"^",1)
	s Sex = $p($g(^CT("SEX",$p($g(^PAPER(Papmi,"ALL")),"^",7))),"^",2)
	s BirthDate = $p($g(^PAPER(Papmi,"ALL")),"^",6)
	s:(BirthDate '= "") BirthDate = $zd(BirthDate,3)
	s Age = "", IntAge = ""
	//s:(BirthDate '= "") Age = ((+$h)-$zdh(BirthDate,3))\365
    s AdmType = $p(tmp,"^",2), AdmNo = $p(tmp,"^",81)
    s AdmDate = $zd($p(tmp,"^",6),3), AdmTime = $zt($p(tmp,"^",7))
    s AdmDateTime = AdmDate_" "_AdmTime
	s Age = ##class(EPRservice.Quality.DataGather.AdmInfo).Age(Papmi,AEpisodeID,AdmDate,AdmTime)
    s CTLoc = +$p(tmp,"^",4)
    s Doc = +$p(tmp,"^",9)
    s Ward = +$p(tmp,"^",70)
    s Room = +$p(tmp,"^",69)
    s Bed = $p(tmp,"^",73)
    s:($p(tmp,"^",17) '= "") DischgDate = $zd($p(tmp,"^",17),3),DischgTime=$zt($p(tmp,"^",18)),DischDateTime=DischgDate_" "_DischgTime
    s:(CTLoc '= 0) LocDesc = $p($g(^CTLOC(CTLoc)),"^",2)
    s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
    s:(Ward '= 0) WardDesc = $p($g(^PAWARD(Ward)),"^",2)
    s:(WardDesc [ "-") WardDesc = $p(WardDesc,"-",2)
    s:(Doc '= 0) DocDesc = $p($g(^CTPCP((Doc),1)),"^",2)
    s:(Room '= 0) RoomDesc = $p($g(^PAROOM(Room)),"^",2)
    s:(Bed '= "") BedDesc = $p($g(^PAWARD(+Bed,"BED",$p(Bed,"||",2))),"^",1)
    
    s ^CacheTemp("EPRQuality","JITMonitor",AUniqueKey,WardDesc,BedDesc,AEpisodeID) = $lb(ARuleID,AEpisodeID,RegNo,Name,Sex,BirthDate,Age,LocDesc,DocDesc,WardDesc,RoomDesc,BedDesc,AdmDateTime,DischDateTime,Score,Count,Papmi)
    s:(Count>0) ^CacheTemp("EPRQuality","JITMonitor",AUniqueKey,"disqualification") = $g(^CacheTemp("EPRQuality","JITMonitor",AUniqueKey,"disqualification")) + 1
    q "1"
}

ClassMethod GetJITQualityListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetJITQualityListExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetJITQualityListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetJITQualityListExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Desc:	获取运行态病历分数;
/// Input:	AEpisodeID为患者就诊号;
/// 		ARuleID为病历质控标准RowID;
///         modify by Candyxu 2012-12-05 去掉算分
/// Debug:	w ##Class(EPRservice.Quality.BOQualityJob).GetRunTimeScore("65","2")
ClassMethod GetRunTimeScore(AEpisodeID As %String, ARuleID As %String, AUniqueKey As %String) As %String
{
	s ret = ""
	q:(AEpisodeID = "")||(ARuleID = "") ret
	
	s Score = 100, Count = 0
	s EntryID = ""
	for {
		//逐条检查某质控标准下质控项目
		s EntryID = $o(^DHCEPRM.QualityEntryI("IdxRuleDR"," "_ARuleID,EntryID))
		q:EntryID=""

		s objEntry = $g(^DHCEPRM.QualityEntryD(EntryID))
		continue:(objEntry = "")
		
		//检查质控条目是否有效
		s IsActive = $list(objEntry,8)
		continue:(IsActive '= "Y")
		
		//检查质控条目是否在检查范围内
		s flag = ##Class(EPRservice.Quality.ExpExplain.BOCheckRange).IsCheckEntry(AEpisodeID,EntryID,"Save",AUniqueKey)
		continue:(flag < 0)
		
		//解析质控项目
		s flag = ##Class(EPRservice.Quality.ExpExplain.BOExplainVal).GetExplainVal(AEpisodeID,EntryID,"")
		continue:(flag >= 0)
		s Count = Count + 1
	}
	s ret = Score_"^"_Count
	q ret
}

/// Desc:	Get JIT problems of given patient <AEpisodeID> by <ARuleID>
/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.Quality.BOQualityJob","GetProblemList","76","2")
Query GetProblemList(AEpisodeID As %String, ARuleID As %String) As %Query(ROWSPEC = "EntryID:%String,EntryTitle:%String,DoctorName:%String,DoctorID:%String,EntryScore:%String")
{
}

ClassMethod GetProblemListExecute(ByRef qHandle As %Binary, AEpisodeID As %String, ARuleID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:(AEpisodeID = "")||(ARuleID = "") $$$OK
	q:($d(AEpisodeID)=0)||($d(ARuleID)=0) $$$OK
	
	s UniqueKey = repid
	k ^CacheTemp("EPRQuality",UniqueKey)
	
	//检查患者有效性
	s flag = ##Class(EPRservice.Quality.CommonHelper).CheckAdmUserful(+AEpisodeID)
	q:(flag < 1) $$$OK
	s objAdm = $g(^PAADM(+AEpisodeID))
	
	s AdmType = $p(objAdm,"^",2)
	q:(AdmType '= "I") $$$OK
	
	s VisitStatus = $p(objAdm,"^",20)
	q:(VisitStatus '= "A") $$$OK
		
	s AdmLocID = $p(objAdm,"^",4)
	q:(AdmLocID = "") $$$OK
    
    //起始质控结构 
    s structId = ##Class(EPRservice.Quality.DataAccess.BOQualitySetting).GetRootStructID(AdmLocID,ARuleID)
	
	//检查质控条目
	s count = ##Class(EPRservice.Quality.DataAccess.BOQualityStruct).CheckStruct(structId,ARuleID,AEpisodeID,UniqueKey,"GetProblemList","")
	q:(count < 1) $$$OK
	q:('$d(^CacheTemp("EPRQuality",UniqueKey,AEpisodeID))) $$$OK
	
	//取质控结果
	s RuleID = $o(^CacheTemp("EPRQuality",UniqueKey,AEpisodeID,""))
	While(RuleID '= "")
	{
		s RuleTitle = $g(^CacheTemp("EPRQuality",UniqueKey,AEpisodeID,ARuleID))
		
		s EntryID = $o(^CacheTemp("EPRQuality",UniqueKey,AEpisodeID,ARuleID,""))
		While(EntryID '= "")
		{
			s EntryTitle = $g(^CacheTemp("EPRQuality",UniqueKey,AEpisodeID,ARuleID,EntryID))
			s objEntry = $g(^DHCEPRM.QualityEntryD(EntryID))
			
			//获得评分标准 Modify by Candyxu 2012-12-05
			s Score = $list(objEntry,4)
			s objEResult = ##Class(EPRservice.Quality.OperationLogic.EvaluationResult).CreateInstance()
			s Score = objEResult.GetEvaluationValue(Score)
			d objEResult.%Close()
			s objEResult = ""
			s DoctorID = $p($g(^PAADM(+AEpisodeID)),"^",9), DoctorName = ""
			s:(DoctorID '= "") DoctorName = $p($g(^CTPCP((DoctorID),1)),"^",2)
			s EntryTitle = $tr(EntryTitle,$c(2,1),"")
			
			s Data = $lb(EntryID,EntryTitle,DoctorName,DoctorID,Score)
			s ^CacheTemp(repid,ind) = Data
			s ind = ind+1
			
			s EntryID = $o(^CacheTemp("EPRQuality",UniqueKey,AEpisodeID,ARuleID,EntryID))
		}
		s RuleID = $o(^CacheTemp("EPRQuality",UniqueKey,AEpisodeID,ARuleID))
	}
	
	k ^CacheTemp("EPRQuality",UniqueKey)
	
	q $$$OK
}

ClassMethod GetProblemListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetProblemListExecute ]
{
 	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetProblemListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetProblemListExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod SetCheckEntrys(AEpisodeID As %String, ARuleID As %String, AUniqueKey As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(ARuleID = "") ret
	
	//获取待检测的质控父目录结构ID
	s RootStructID = $list($g(^DHCEPRM.QualityRuleD(ARuleID)),3)
	q:(RootStructID = "") ret
	
	//清理检查范围
	k ^CacheTemp("DHCEPRQQualityCTS",AUniqueKey)
	
	//根据质控父目录结构ID设置检查范围
	d ##Class(EPRservice.Quality.ExpExplain.BOCheckRange).SetNoTriggerCheckRange(AEpisodeID,RootStructID,AUniqueKey)
	
	//没有满足检查条件的检查范围则退出
	q:('$d(^CacheTemp("DHCEPRQQualityCTS",AUniqueKey))) ret
	
	//逐条检查质控标准下所有质控项目
	s EntryID = ""
	for {
		s EntryID = $o(^DHCEPRM.QualityEntryI("IdxRuleDR"," "_ARuleID,EntryID))
		q:(EntryID = "")
		
		s objEntry = ##Class(EPRmeta.Quality.QualityEntry).%OpenId(EntryID) //$g(^DHCEPRM.QualityEntryD(EntryID))
		continue:(objEntry = "")
		
		//检查质控条目是否有效
		s isEntryActive = objEntry.IsActive  //$list(objEntry,8)
		continue:($zcvt(isEntryActive,"U") '= "Y")
		
		//判断质控条目过滤条件
		s EntryConditionDR = objEntry.EntryConditionDR 
		if ((EntryConditionDR '= 0) && (EntryConditionDR '= $c(0)) &&(EntryConditionDR '= ""))
		{
		   s flag = ##Class(EPRservice.Quality.ExpExplain.BOExplainVal).GetQualityQueryValue(AEpisodeID,EntryConditionDR)
		   continue:(flag '= "1")
		}
		
		//检查质控条目是否在检查范围内
		s flag = ##Class(EPRservice.Quality.ExpExplain.BOCheckRange).IsCheckEntry(AEpisodeID,EntryID,"Save",AUniqueKey)
		continue:(flag < 0)
		
		//运行质控项目并获取结果
		s flag = ##class(EPRservice.Quality.ExpExplain.BOExplainVal).GetExplainVal(AEpisodeID,EntryID,"")
		continue:(flag >= 0)
		
		//质控标准
		s RuleTitle = $list($g(^DHCEPRM.QualityRuleD(ARuleID)),2)
		
		//质控项目描述
		s PoolID = objEntry.PoolDR   //$list(objEntry,1)
		continue:(PoolID = "")

		s EntryTitle = ##Class(EPRmeta.Quality.QualityPool).GetTitleByPoolID(PoolID)
		s EntryTitle = $tr(EntryTitle,$c(2,1),"")
		
		//将违反规则的质控项目写入临时Global
		s ^CacheTemp("EPRQuality",AUniqueKey,AEpisodeID,ARuleID) = RuleTitle
		s ^CacheTemp("EPRQuality",AUniqueKey,AEpisodeID,ARuleID,EntryID) = EntryTitle
	}
	
	k ^CacheTemp("DHCEPRQQualityCTS",AUniqueKey)
	
	s ret = 1
	q ret
}

/// Desc:	手动执行自动任务用来补数据;
/// Input:	AAdmitRuleCode为在院质控标准代码;
/// 		ADischRuleCode为出院质控标准代码;
///         AmanualRuleCode为手工评分r质控标准代码;
/// 		AStartDate为补数据开始日期;
/// 		AEndDate为补数据截止日期;
/// Debug:	w ##Class(EPRservice.Quality.BOQualityJob).ManualRunQualityJob("F","G","A","2008-12-11","2008-12-15")
ClassMethod ManualRunQualityJob(AAdmitRuleCode As %String, ADischRuleCode As %String, AManualRuleCode As %String, AStartDate As %String = "", AEndDate As %String = "") As %String
{
	if (AAdmitRuleCode = "")||(ADischRuleCode = "")
	{
		s ret = "-1^请指定自动任务定在院和出院质控标准代码!" 
		q ret	
	}
	
	s AdmitRuleID = $o(^DHCEPRM.QualityRuleI("IdxCode",AAdmitRuleCode,""))
	if (AdmitRuleID = "") 
	{
		s ret = "-2^无法获取在院质控标准RowID，请检查在院质控标准代码!"	
		q ret
	}
	
	s DischRuleID = $o(^DHCEPRM.QualityRuleI("IdxCode",ADischRuleCode,""))
	if (DischRuleID = "") 
	{
		s ret = "-3^无法获取出院质控标准RowID，请检查出院质控标准代码!"	
		q ret
	}
	
    s ManualRuleID = $o(^DHCEPRM.QualityRuleI("IdxCode",AManualRuleCode,""))
	if (ManualRuleID = "") 
	{
		s ret = "-4^无法获取手工质控标准RowID，请检查手工质控标准代码!"	
		q ret
	}
	s StartDate = $g(AStartDate)
	if (StartDate = "")
	{
		//如果起始日期为空, 则默认为昨天
		s StartDate = +$h - 1	 	
	}
	else
	{
		s StartDate = $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)	
	}
	
	s $zt = "CatchQualityJobError"
	
	TStart
	
	s EndDate = $g(AEndDate)
	if (EndDate = "")
	{
		// 只执行昨天的自动任务
		w "准备运行: "_$zd(StartDate,3)_"质控自动任务. 当前系统日期时间为: "_$zd($h,3)_" "_$zt($h,1),!
		s flag = ..Run(AdmitRuleID,DischRuleID,$zd(StartDate,3),ManualRuleID)
		if (flag < 0)
		{
			w $zd(StartDate,3)_" :质控自动任务运行失败!系统开始数据回滚......",!
			TRollback
			w "回滚完毕!"
			q	
		}
		else
		{
			TCommit
			w "完毕,"_$zd(StartDate,3)_" 质控自动任务运行成功. 当前系统日期时间为:"_$zd($h,3)_" "_$zt($h,1),!
			q
		} 	
	}
	else
	{
		// Run automation from start date to end date
		s EndDate = $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
		if (EndDate < StartDate)||(EndDate > +$h)
		{
			s ret = "截止日期应该在起始日期之后, 在"_$zd($h,3)_"之前!"
			q ret	
		}
		
		s ret = 1
		for JobDate = StartDate:1:EndDate
		{
			w "准备运行: "_$zd(JobDate,3)_"质控自动任务，当前日期"_$zd($h,3)_" "_$zt($h,1),!
			s flag = ..Run(AdmitRuleID,DischRuleID,$zd(JobDate,3),ManualRuleID)
			if (flag < 0)
			{
				s ret = -1
				q
			}
			else
			{
				w "完毕,"_"质控自动任务运行成功: "_$zd(JobDate,3),!	
			}	
		}
		
		if (ret = 1)
		{
			w "自动任务数据提交中......",!
			TCommit	
			// 修改提示信息 2012-07-17
			w "完毕,"_$zd(StartDate,3)_" 质控自动任务运行成功. 当前系统日期时间为:"_$zd($h,3)_" "_$zt($p($h,",",2),1),!  
		}
		else
		{
			w "质控自动任务运行过程中发生异常退出,数据开始回滚......",!
			TRollback	
			w "回滚完毕!",!
		}
		
		q ret
	}
	
CatchQualityJobError
	s error = $ZERROR
	s ^CacheTemp("EPRQuality","ManualRunQualityJob",$h) = "质控自动任务运行过程中发生异常: "_error
   	w "质控自动任务运行过程中发生异常: "_error,!
   	s ret = -100
   	q ret
}

ClassMethod Run(AAdmitRuleID As %String, ADischRuleID As %String, AJobDate As %String, AManualRuleID As %String) As %String
{
	s ret = -1
	
	/*
	if (AAdmitRuleID '= "")
	{
		s flag = ..AutoJobByAdmit(AAdmitRuleID, AJobDate)
		q:(flag <= 0) ret	
	}
	*/
	
	if (ADischRuleID '= "")
	{
		s Days = 5
		s ParamID = $o(^DHCEPRM.QualityParamsI("IdxCode","AutoDischDays",""))
		s:(ParamID '= "") Days = +$list($g(^DHCEPRM.QualityParamsD(+ParamID)),2)
	
		s flag = ..AutoJobByDisch(ADischRuleID,AJobDate,Days,AAdmitRuleID,AManualRuleID)
		q:(flag <= 0) ret	
	}
	
	s ret = 1
	q ret
}

/// Desc:	创建后台自动任务(该方法仅使用于P7,P8的自动任务在System Management Portal中创建即可);
/// Input:	ANameSpace为命名空间(WEBSRC或DHC-APP)
/// 		AAdmitRuleCode为自动在院任务标准代码;
/// 		ADischRuleCode为自动出院任务标准代码;
/// Debug:	d ##Class(EPRservice.Quality.BOQualityJob).CreateQualityJob("WEBSRC","F","G")
ClassMethod CreateQualityJob(ANameSpace As %String, AAdmitRuleCode As %String, ADischRuleCode As %String, AManualRuleCode As %String)
{
	// 新建一个自动任务对象
	s objTask = ##Class(%SYSTEM.Task).%New()
		
	s objTask.Name = "EPR Quality"
	s objTask.NameSpace = ANameSpace
	s objTask.Description = "Run EPR quality check every night at 1:00am"
	s objTask.ExecuteCode = "d ##Class(EPRservice.Quality.BOQualityJob).RunQualityJob("""_AAdmitRuleCode_""","""_ADischRuleCode_""","""_AManualRuleCode_""")"
	s objTask.TimePeriod = 0
	s objTask.TimePeriodEvery = 1
	s objTask.TimePeriodDay = ""
	s objTask.DailyFrequency = 0
	s objTask.DailyFrequencyTime = ""
	s objTask.DailyIncrement = ""
	s objTask.DailyStartTime = 3600
	s objTask.DailyEndTime = ""
	s rc = objTask.%Save()
}

/// Desc:	根据EpisodeID执行出院自动任务(根据EpisodeID终末质控);
/// Input:	ret<=0为失败; ret>0为成功;
/// Debug:	w ##Class(EPRservice.Quality.BOQualityJob).QualityJobByDischEpisodeID(13)
ClassMethod QualityJobByDischEpisodeID(AEpisodeID As %String = "") As %String
{
	s ret = 0
	q:(AEpisodeID="") ret
	s ADischRuleID=7,AdmitRuleID=6,AManualRuleID=1
	s JobDate = +$h
	
	// Check the given <ADischRuleID> is active
	s objRule = $g(^DHCEPRM.QualityRuleD(+ADischRuleID))
	q:(objRule = "") ret
	q:($list(objRule,4) '= "Y") ret

	// Get the root struct
	s RootStructID = $list($g(^DHCEPRM.QualityRuleD(+ADischRuleID)),3)
	q:(RootStructID = "") ret


	s UniqueKey = $i(^CacheTemp)

		
		// Check if current visit of <EpisodeID> is active
		s flag = ##Class(EPRservice.Quality.CommonHelper).CheckAdmUserful(+AEpisodeID)
		q:(flag < 1) ret

		s objPaAdm = $g(^PAADM(+AEpisodeID))
		q:(objPaAdm = "") ret
		
		// Only process discharge patient
		s VisitStatus = $p(objPaAdm,"^",20)
		q:(VisitStatus '= "D") ret 

		// Only process inpatient patient
		s AdmType = $p(objPaAdm,"^",2)
		q:(AdmType '= "I") ret
	
		// Only process patient that allocate department
		s AdmLocID = $p(objPaAdm,"^",4)
		q:(AdmLocID = "") ret
		
		// Only process patient that allocate physician
		s AdmDocID = $p(objPaAdm,"^",9)
		if (AdmDocID '= "")
		{
			s AdmDoctor = $p($g(^CTPCP(AdmDocID,1)),"^",2)
		}
		else
		{
			s AdmDocID = -1, AdmDoctor = "未指定"
		}
		s Employee = AdmDocID_"||"_AdmDoctor
		
		// Clear admit automation result if existed unit now
		s ClearFlag = ##Class(EPRservice.Quality.DataAccess.BOQualityResult).ClearLastJobData(AEpisodeID,AdmitRuleID)
		q:(ClearFlag <= 0) ret
		
		// Collect information to create QualityResult for this cycle
		s RString = AEpisodeID_"^"_ADischRuleID_"^"_JobDate_"^"_"-1"

		// Invoke method to insert QualityResult table, if LE zero then turn to next cycle
		// Unique index:(EpisodeID, RuleID, ExamineDate)
		s ResultID = ##Class(EPRservice.Quality.DataAccess.BOQualityResult).CreateQualityResult(RString)
		
		k ^CacheTemp("DHCEPRQQualityCTS",UniqueKey)
		
		// Write check range to global ^CacheTemp("DHCEPRQQualityCTS",UniqueKey)
		d ##Class(EPRservice.Quality.ExpExplain.BOCheckRange).SetNoTriggerCheckRange(AEpisodeID,RootStructID,UniqueKey)

		// Loop all entries under the given <ADischRuleID>
		s EntryID = ""
		for {
			s EntryID = $o(^DHCEPRM.QualityEntryI("IdxRuleDR"," "_ADischRuleID,EntryID))
			q:(EntryID = "")
			
			s objEntry = ##Class(EPRmeta.Quality.QualityEntry).%OpenId(EntryID)  //$g(^DHCEPRM.QualityEntryD(+EntryID))
			continue:(objEntry = "")
			
			// Check if current <EntryID> is active			
			s isEntryActive = objEntry.IsActive   //$list(objEntry,8)
			continue:(isEntryActive '= "Y")
			
			// Get entry title information
			s PoolID = objEntry.PoolDR     //$list(objEntry,1)
			continue:(PoolID = "")
			
			//判断质控条目过滤条件
		    s EntryConditionDR = objEntry.EntryConditionDR 
		    if ((EntryConditionDR '= 0) && (EntryConditionDR '= $c(0)) &&(EntryConditionDR '= ""))
		    {
		       s flag = ##Class(EPRservice.Quality.ExpExplain.BOExplainVal).GetQualityQueryValue(AEpisodeID,EntryConditionDR)
		       continue:(flag '= "1")
		    }
			
			// Check if current <EntryID> is in range					
			// IsCheckEntry(AEpisodeID,AEntryID,ACheckStatus,AUniqueKey)
			s isEntryInRange = ##Class(EPRservice.Quality.ExpExplain.BOCheckRange).IsCheckEntry(AEpisodeID,EntryID,"Save",UniqueKey)
			continue:(isEntryInRange < 0)
			
			// Explain the expression of this <EntryID> and get the result, less than zero means offend the regulation
			// GetExplainVal(AEpisodeID,AEntryID,AInstanceID)
			s isEntryValid = ##Class(EPRservice.Quality.ExpExplain.BOExplainVal).GetExplainVal(AEpisodeID,EntryID,"")
			
			continue:(isEntryValid >= 0)
			
			s RealUserLoc=##class(EPRservice.Quality.CommonHelper).GetRealUserForEntryResult(AEpisodeID,isEntryValid)
		
			
			//判断条目是否检查过 modify by Candy 2013-01-12
			s isEntryExist = ##Class(EPRservice.Quality.DataAccess.BOQualityResult).CheckEpisodeEntryExist(AEpisodeID,EntryID)
			continue:(isEntryExist > 0)
			
			//条目触发次数 add by Candy 2013-01-12
			s ExamCount = ##Class(EPRservice.Quality.DataAccess.BOQualityResult).GetExamCount(objEntry,isEntryValid) 
			
			s EntryTitle = ##Class(EPRmeta.Quality.QualityPool).GetTitleByPoolID(PoolID)

			// Get entry score
			s EntryScore = ##Class(EPRservice.Quality.DataAccess.BOQualityEntry).GetEntryScoreByID(EntryID,JobDate)
			// Get entry grade
			s EntryGrade = objEntry.VetoGrade  //$list(objEntry,11)

			// Update QualityResult table and Insert QualityResultDetail & QualityResultPeople table
			s DString = ResultID_"^"_AEpisodeID_"^"_Employee_"^"_EntryID_"^"_EntryScore_"^"_EntryGrade_"^"_JobDate_"^"_AdmLocID_"^"_ExamCount_"^"_RealUserLoc
			s RetID = ##Class(EPRservice.Quality.DataAccess.BOQualityResult).SaveAutoResult(DString)
			s:(RetID < 1) ^DHCEPRQERSTLog("AutoJob_Disch_Error",+ADischRuleID,+AJobDate,+AEpisodeID,+EntryID) = EntryTitle_"||"_EntryScore
		}
		k ^CacheTemp("DHCEPRQQualityCTS",UniqueKey)
		s TempObj = ##Class(EPRservice.Quality.OperationLogic.EvaluationResult).CreateInstance()
		//出院得扣分级别
		s ActualScore = TempObj.GetEvaluationResult(AEpisodeID,ADischRuleID)
		d ##Class(EPRservice.Quality.DataAccess.BOQualityResult).SetActualScore(ActualScore,ResultID)
		//出院含手工评分得扣分级别
		s RuleIDs = ADischRuleID_"^"_AManualRuleID  //出院质控标准ID^手工评分质控标准ID
		s ActualScore = TempObj.GetEvaluationResult(AEpisodeID,RuleIDs)
		s LastScore =  ##Class(EPRservice.Quality.DataAccess.BOQualityResult).SetLastScore(ActualScore,ADischRuleID,AEpisodeID,JobDate)
		d TempObj.%Close()
		s TempObj = ""
	    s ret = 1
	    q ret
}

Storage Default
{
<Data name="BOQualityJobDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^EPRservice.Qua6EF.BOQualityJobD</DataLocation>
<DefaultData>BOQualityJobDefaultData</DefaultData>
<IdLocation>^EPRservice.Qua6EF.BOQualityJobD</IdLocation>
<IndexLocation>^EPRservice.Qua6EF.BOQualityJobI</IndexLocation>
<StreamLocation>^EPRservice.Qua6EF.BOQualityJobS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
