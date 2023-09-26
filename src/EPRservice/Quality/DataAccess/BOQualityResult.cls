Import SQLUser

/// ************************************************************
/// * Class Name:	EPRservice.Quality.DataAccess.BOQualityResult
/// * Description:	质控评估结果后台业务逻辑处理类
/// * Author:		Zuoxiang Xie
/// * Create Date:	2010-07-22
/// * Version:
/// ************************************************************/
Class EPRservice.Quality.DataAccess.BOQualityResult Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/qualityservice";

Parameter SERVICENAME = "QualityResultInfo";

/// Desc:	Save automation task result into table of QualityResult,QualityResultDetail and QualityResultPeople
/// Input:	AInput = ResultID_"^"_EpisodeID_"^"_Employee_"^"_EntryID_"^"_EntryScore_"^"_EntryGrade_"^"_AJobDate_"^"_AdmLocID
/// Debug:	w ##Class(EPRservice.Quality.DataAccess.BOQualityResult).SaveAutoResult()
ClassMethod SaveAutoResult(AInput As %String, AErrInfo As %String = "") As %String
{
	s ret=0
	
	s ResultID	 = $p(AInput,"^",1)					//父表QualityResult的RowID
	s EpisodeID	 = $p(AInput,"^",2)         		//就诊号
	s Employee	 = $p(AInput,"^",3)      			//责任人（AdmDocID||AdmDoctor）
	s EntryID	 = $p(AInput,"^",4)     			//质控项目RowID
	s EntryScore = $p(AInput,"^",5) 				//质控项目分数
	s EntryGrade = $p(AInput,"^",6)					//质控项目等级，如果不允许单项否决，则此项为空
	s ExamDate	 = $p(AInput,"^",7)      			//自动任务日期
	s AdmLocID	 = $p(AInput,"^",8) 				//责任人科室
	s ExamCount  = $p(AInput,"^",9)                 //评分次数
	
	q:(ResultID = "")||(EpisodeID = "")||(EntryID = "")||(ExamDate = "") ret

	TStart
	
	s ret = -1
	s InString = ResultID_"^"_EntryScore_"^"_EntryGrade
	s flag = ..UpdateQualityResult(InString)
	TRollback:(flag < 1)
	q:(flag < 1) ret
	
	s ret = -2
	s:(ExamCount = "") ExamCount = "1"
	s InString = ResultID_"^"_EpisodeID_"^"_EntryID_"^"_ExamCount_"^"_EntryScore_"^"_EntryGrade_"^"_ExamDate_"^"_Employee_"^"_AdmLocID
	s flag = ..UpdateDetailPeople(InString,AErrInfo)
	TRollback:(flag < 1)
	q:(flag < 1) ret
	
	s DetailID = flag

	TCommit
	s ret = DetailID
	q ret
}

/// Desc:	保存手工评分结果
/// Input:	AInput = EpisodeID^RuleID^EntryID^LocID^EmployeeID^SignUserID^TriggerNum^HappenDate^ResumeText
ClassMethod SaveManualResult(AInput As %String) As %String
{
	s ret = 0
	q:(AInput = "") ret

	s EpisodeID	= $p(AInput,"^",1)
	s RuleID = $p(AInput,"^",2)
	s EntryID = $p(AInput,"^",3)
	s CtLocID = $p(AInput,"^",4)
	s EmployeeID = $p(AInput,"^",5)
	s SignUserID = $p(AInput,"^",6)
	s TriggerNum = $p(AInput,"^",7)
	s HappenDate = $p(AInput,"^",8)
	s ResumeText = $p(AInput,"^",9)
	s Action = $p(AInput,"^",10)
	s InstanceId = $p(AInput,"^",11)
	s EmrDocId= $p(AInput,"^",12)
	s Path= $p(AInput,"^",13)
	
	//s ^CacheTempXZX("EPRQuality","SaveManualResult",1,"Params")="EpisodeID="_EpisodeID_";RuleID="_RuleID_";EntryID="_EntryID_";CtLocID="_CtLocID_";EmployeeID="_EmployeeID_";SignUserID="_SignUserID_";TriggerNum="_TriggerNum_";HappenDate="_HappenDate_";ResumeText="_ResumeText
	
	TStart
	
	s InitString1 = EpisodeID_"^"_RuleID_"^"_HappenDate_"^"_SignUserID_"^"_Action
	s flag = ..CreateQualityResult(InitString1)
	TRollback:(flag < 1)
	q:(flag < 1) ret
	s ResultID = flag
	s IsBSQualityEnable=##Class(EPRservice.Quality.CommonHelper).IsBSQualityEnable()  //BS版本质控维护程序是否启用
	if (IsBSQualityEnable'="Y")
	{
		if ($d(^DHCEPRM.QualityEntryD(EntryID)) '= 0) s EntryScore = $li(^DHCEPRM.QualityEntryD(EntryID),4)
		//hky 20180824 放开注释
		s EntryScore = ##Class(EPRservice.Quality.DataAccess.BOQualityEntry).GetEntryScoreByID(EntryID)
		s EntryGrade = ##Class(EPRservice.Quality.DataAccess.BOQualityEntry).GetEntryGradeByID(EntryID)
	}
	else
	{
		s objEntry=##Class(CT.MA.QC.QualityEntry).%OpenId(EntryID)
		q:(objEntry) ret
		s EntryScore=objEntry.Score
		s EntryGrade=objEntry.VetoGrade
	}
	s InitString2 = ResultID_"^"_EpisodeID_"^"_EntryID_"^"_TriggerNum_"^"_EntryScore_"^"_EntryGrade_"^"_HappenDate_"^"_EmployeeID_"^"_CtLocID_"^"_ResumeText_"^"_InstanceId_"^"_EmrDocId_"^"_Path
	s flag = ..UpdateDetailPeople(InitString2)
	TRollback:($p(flag,"||",2) < 1)
	q:($p(flag,"||",2) < 1) ret
	
	s InitString3 = ResultID_"^"_EntryScore_"^"_EntryGrade
	s flag = ..UpdateQualityResult(InitString3)
	TRollback:(flag < 1)
	q:(flag < 1) ret
	TCommit
	
	s ret = 1
	q ret
}

/// Desc:	清除上一次自动任务结果;
/// Input:	AEpisodeID为患者就诊号;
/// 		ARuleID为自动任务质控标准;
/// 		AJobDate为自动任务日期;
/// Debug:	w ##Class(EPRservice.Quality.DataAccess.BOQualityResult).ClearLastJobData(201863,9,"2010-10-08")
ClassMethod ClearLastJobData(AEpisodeID As %String, ARuleID As %String, AJobDate As %String = "") As %String
{
	s ret = 0
	
	s EpisodeID = $g(AEpisodeID)
	s RuleID = $g(ARuleID)
	q:(EpisodeID = "")||(RuleID = "") ret
	
	s JobDate = $g(AJobDate)
	if (JobDate '= "")
	{
		//清除某一天的数据
		s ResultID = $o(^DHCEPRQ.QualityResultI("IdxComposite"," "_EpisodeID," "_RuleID," "_JobDate,""))
		
		s ret = ..ClearAdmitJobResult(ResultID)		
	}
	else
	{
		TStart
		
		s flag = 1	
		s JobDate = ""
		for {
			s JobDate = $o(^DHCEPRQ.QualityResultI("IdxComposite"," "_EpisodeID," "_RuleID,JobDate))
			q:(JobDate = "")
			
			s ResultID = ""
			for {
				s ResultID = $o(^DHCEPRQ.QualityResultI("IdxComposite"," "_EpisodeID," "_RuleID,JobDate,ResultID))
				q:(ResultID = "")
				
				s temRet = ..ClearAdmitJobResult(ResultID)
				if (temRet <= 0)
				{
					s flag = temRet
					q
				}
					
			}
		}
		
		if (flag = 1)
		{
			TCommit
			s ret = 1
		}
		else
		{
			TRollBack
			s ret = -1	
		}
	}
	q ret
}

/// Desc:	清除自动任务数据
/// Input:	AResultID为质控数据父表RowID;
/// Table:	EPRinstance_Quality.QualityResult
/// Debug:	w ##Class(EPRservice.Quality.DataAccess.BOQualityResult).ClearAdmitJobResult(21)
ClassMethod ClearAdmitJobResult(AResultID As %String) As %String
{
	s ret = 0
	
	s ResultID = $g(AResultID)
	q:(ResultID = "") ret
	
	s objResult = ##Class(EPRinstance.Quality.QualityResult).%OpenId(ResultID)
	q:(objResult = "") ret
	
	TStart
	
	s ChildSub = ""
	for {
		s ChildSub = $o(^DHCEPRQ.QualityResultD(ResultID,"Details",ChildSub))
		q:(ChildSub = "")
		
		s objDetail = $g(^DHCEPRQ.QualityResultD(ResultID,"Details",ChildSub))
		continue:(objDetail = "")
		
		s PeopleID = $list(objDetail,8)
	
		s objPeople = ##Class(EPRinstance.Quality.QualityResultPeople).%OpenId(PeopleID)
		continue:(objPeople = "")
	
		d objPeople.%DeleteId(PeopleID)
	}
	
	if '(objResult.%DeleteId(ResultID))
 	{
	 	TRollBack
	 	q ret
	}
	//删除最终结果表 add by Candyxu
	s EpisodeID = objResult.EpisodeID
	if ($d(^DHCEPRQ.QualityResultEndI("IdxEpisodeID"," "_EpisodeID)))
	{
		s qresRowID = $o(^DHCEPRQ.QualityResultEndI("IdxEpisodeID"," "_EpisodeID,""))
		if (qresRowID '= "")
		{
		    s objQRES = ##Class(EPRinstance.Quality.QualityResultEnd).%OpenId(qresRowID)
		    if (objQRES '= "" ) 
		    {
			    s objrc = objQRES.%DeleteId(qresRowID)
			    if $$$ISERR(objrc)
			    {
				    TRollBack
				    q ret
				}
		    }
		}
	}
	
	TCommit
	
	s ret = 1
	q ret
}

/// Desc:	根据质控标准清除质控数据;
/// Input:	ARuleID为质控标准RowID;
/// Debug:	w ##Class(EPRservice.Quality.DataAccess.BOQualityResult).ClearDataByRuleID(7)
ClassMethod ClearDataByRuleID(ARuleID As %String) As %String
{
	s ret = -1
	q:(ARuleID = "") ret
	
	s ret = 1
	s ResultID = ""
	for {
		s ResultID = $o(^DHCEPRQ.QualityResultI("IdxRuleID"," "_ARuleID,ResultID))
		q:(ResultID = "")
		
		s flag = ..ClearAdmitJobResult(ResultID)
		if (flag < 1)
		{
			s ret = -1
			q	
		}
	}
	q ret
}

/// Desc:	根据质控数据子表RowID删除手工质控数据
/// Input:	ADetailRowIDs为质控数据子表RowID字符串,多个以"^"分隔;
/// Table:	EPRinstance_Quality.QualityResultDetail
/// Debug:	w ##Class(EPRservice.Quality.DataAccess.BOQualityResult).DeleteManualResult("8871||8")
ClassMethod DeleteManualResult(ADetailRowIDs As %String) As %String
{
	s ret = 0
	q:(ADetailRowIDs = "") ret

	s flag = 1
	TStart
	s DetailRowIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ADetailRowIDs,"^")
	for i = 1:1:$listlength(DetailRowIDs) 
	{
		s DetailRowID = $listget(DetailRowIDs,i)
		continue:(DetailRowID = "")

		s objDetail = ##Class(EPRinstance.Quality.QualityResultDetail).%OpenId(DetailRowID)
		continue:(objDetail = "") 
		
		s ResultID = $p(DetailRowID,"||",1)
		s entryScore = objDetail.EntryScore
		//hky 20180824 增加处理分数在条目删除是变化
		//级别先不处理 
		//s entryGrade = objDetail.EntryGrade
		
		s objResult = ##Class(EPRinstance.Quality.QualityResult).%OpenId(ResultID)
		
		
		if '(objDetail.%DeleteId(DetailRowID))
 		{
	 		s flag = 0
	 		q
		}
		
		s objResult.ActualDeScore = objResult.ActualDeScore - entryScore
		
		s objResult.ActualScore = objResult.ActualScore + entryScore
		
		d objResult.%Save()
		
	}
	
	if (flag = 1)
	{
		TCommit	
		s ret = 1
	}
	else
	{
		TRollback
		s ret = 0	
	}
	q ret
}

/// Desc:	插入质控数据;
/// Input:	AInput=EpisodeID_"^"_ARuleID_"^"_AJobDate_"^"_SignUserID
/// Debug:	d ##Class(EPRservice.Quality.DataAccess.BOQualityResult).CreateQualityResult()
ClassMethod CreateQualityResult(AInput As %String) As %String
{
	s EpisodeID = $p(AInput,"^",1)
	s RuleID = $p(AInput,"^",2)
	s JobDate = $p(AInput,"^",3)			// Format like YYYY-MM-DD hh:mm:ss
	s ExamineDate = $p(JobDate," ",1)		// Format like YYYY-MM-DD
	s SignUserID = $p(AInput,"^",4)
	s Action = $p(AInput,"^",5)
	
	s ResultID = $o(^DHCEPRQ.QualityResultI("IdxCompositeAction"," "_EpisodeID," "_RuleID," "_Action," "_ExamineDate," "_SignUserID,""))
	q:(ResultID '= "") ResultID
	
	s objQResult = ##Class(EPRinstance.Quality.QualityResult).%New()
	s objQResult.EpisodeID = EpisodeID
	s objQResult.RuleDR = RuleID
	s objQResult.ActualDeScore = 0
	//hky 20180824 初始化总分
	s objQResult.ActualScore = 100
	s objQResult.GradeDR = "甲@0@0"
	s objQResult.SignUserDR = SignUserID
	s objQResult.ExamineDate = $p(JobDate," ",1)
	s objQResult.ExamineTime = $p(JobDate," ",2)
	s objQResult.ExecuteDate = $zd(+$h,3)
	s objQResult.ExecuteTime = $zt($p($h,",",2),1)
	s objQResult.IsActive = "Y"
	s objQResult.ResumeText = ""
	s objQResult.Action = Action
	
	s sc = objQResult.%Save()
	if $SYSTEM.Status.IsError(sc) 
	{                               
   		d $SYSTEM.OBJ.DisplayError(sc) 
   		s ResultID = -1
	}
	else
	{
		s ResultID = objQResult.%Id()
	}
	d objQResult.%Close()	
	q ResultID
}

/// Desc:	判断患者是否已违反某个质控条目; 
/// Input:	AEpisodeID为患者就诊号;
/// 		AEntryID为质控项目RowID;
/// Debug:	d ##Class(EPRservice.Quality.DataAccess.BOQualityResult).CheckEpisodeEntryExist("65","")
ClassMethod CheckEpisodeEntryExist(AEpisodeID As %String, AEntryID As %String)
{
	s ret = 0
	q:(AEpisodeID = "")||(AEntryID = "") ret
	/*
	// 先判断质控项目是否允许多次评分
	s objEntry = $g(^DHCEPRM.QualityEntryD(+AEntryID))
	s isEntryMultiErr = $list(objEntry,6)
	q:(isEntryMultiErr = "") ret
	*/
	// 检查质控项目是否已经针对患者的某次就诊检查过
	s RowID = $o(^DHCEPRQ.QualityResultDetailI("IdxEpisodeEntryID"," "_AEpisodeID," "_AEntryID,""))
	s:(+RowID > 0) ret = 1

	q ret
}

/// Desc:获得多次评分次数
/// Creator:Candyxu
/// Createdate:2012-1-12
/// Input: AobjEntry Entry表的list值，AEntryResult Entry表达式的结果
ClassMethod GetExamCount(AobjEntry As EPRmeta.Quality.QualityEntry, AEntryResult As %String) As %String
{
	s ExamCount = 1
	s isEntryMultiErr = AobjEntry.IsMultiErr   //$list(AobjEntry,6)
	s:(isEntryMultiErr = "Y") ExamCount = $p(AEntryResult,"^",3)
	q ExamCount
}

/// Desc:	更新质控结果表记录;
/// Input:	ResultID_"^"_EntryScore_"^"_EntryGrade
ClassMethod UpdateQualityResult(AInput As %String) As %String
{
	s ret = -1
	
	s ResultID = $p(AInput,"^",1)
	s EntryScore = $p(AInput,"^",2)
	s EntryGrade = $p(AInput,"^",3)
	
	s objQResult = ##Class(EPRinstance.Quality.QualityResult).%OpenId(ResultID)
	
	s InitGrade = objQResult.GradeDR
		
	s Grade = $p(InitGrade,"@",1)
	s BCount = $p(InitGrade,"@",2)
	s CCount = $p(InitGrade,"@",3)
	
	if (EntryGrade '= "")
	{
		s NewGrade = "甲", NewBCount = 0, NewCCount = 0	
		if (Grade = "甲")
		{
			if (EntryGrade="乙级")
			{
				s NewGrade = "乙"
				s NewBCount = 1
			}
			elseif (EntryGrade="丙级")
			{
				s NewGrade = "丙"
				s NewCCount = 1
			}	
		}
		elseif (Grade = "乙")
		{
			if (EntryGrade="乙级")
			{
				s NewGrade = "乙"
				s NewBCount = (+BCount) + 1
			}
			elseif (EntryGrade="丙级")
			{
				s NewGrade = "丙"
				s NewCCount = (+CCount) + 1
			}	
		}
		else
		{
			if (EntryGrade = "乙级")
			{
				s NewBCount = (+BCount) + 1
			}
			elseif (EntryGrade="丙级")
			{
				s NewCCount = (+CCount) + 1
			}		
		}
		
		s objQResult.GradeDR = NewGrade_"@"_NewBCount_"@"_NewCCount
	}
	//hky 20180824 增加分数计算（评项目）
	s objQResult.ActualDeScore = objQResult.ActualDeScore + EntryScore
	s objQResult.ActualScore = objQResult.ActualScore - EntryScore
	
	s sc = objQResult.%Save()
	if $SYSTEM.Status.IsError(sc) 
	{                               
   		d $SYSTEM.OBJ.DisplayError(sc) 
   		q ret
	}
	else
	{
		s ret = objQResult.%Id()
	}
	d objQResult.%Close()
	q ret
}

/// Desc:	根据质控结果父表RowID删除质控数据;
/// Input:	AResultID为质控结果父表EPRinstance_Quality.QualityResult表的RowID;
/// Debug: 	w ##Class(EPRservice.Quality.DataAccess.BOQualityResult).DeleteQualityResult(8)
ClassMethod DeleteQualityResult(AResultID As %String) As %String
{
	TStart
	s objResult = ##Class(EPRinstance.Quality.QualityResult).%OpenId(AResultID)
	q:(objResult = "") 0
	
	if '(objResult.%DeleteId(AResultID))
 	{
	 	TRollBack
	 	q 0	
	}
	TCommit
	q 1
}

/// Desc:	更新质控项目责任人信息;
/// Input:	ResultID_"^"_EpisodeID_"^"__EntryID_"^"_ExamCount_"^"_EntryScore_"^"_EntryGrade_"^"_ExamDate_"^"_Employee_"^"_AdmLocID_"^"_ResumeText
ClassMethod UpdateDetailPeople(AInput As %String, AErrInfo As %String = "") As %String
{
	
	TStart
	
	s objQDetail = ##Class(EPRinstance.Quality.QualityResultDetail).%New()
	s objQDetail.EpisodeID	= $p(AInput,"^",2)
	s objQDetail.EntryDR	= $p(AInput,"^",3)
	s objQDetail.ExamCount= $p(AInput,"^",4)
	s objQDetail.EntryScore	= $p(AInput,"^",5)
	s objQDetail.EntryGrade	= $p(AInput,"^",6)
	s objQDetail.TriggerDate= $p(AInput,"^",7)
	s objQDetail.IsActive	= "Y"
	s objQDetail.ResumeText	= $p(AInput,"^",10)
	s objQDetail.InstanceId = $p(AInput,"^",11)
	s objQDetail.EmrDocId = $p(AInput,"^",12)
    s objQDetail.Path= $p(AInput,"^",13)
    s:(AErrInfo'="") objQDetail.ErrInfo=AErrInfo
	s ResultID = $p(AInput,"^",1) 
	s objQResult = ##Class(EPRinstance.Quality.QualityResult).%OpenId(ResultID)
	if $IsObject(objQResult)
	{
		s objQDetail.TheResult=objQResult
	}
	
	s objPeople = ##Class(EPRinstance.Quality.QualityResultPeople).%New()
	s objPeople.EmployeeDr	= $p($p(AInput,"^",8),"||",1)
	s objPeople.CtLocDr		= $p(AInput,"^",9)
	s objPeople.IsActive	= "Y"
	s objPeople.ResumeText	= ""
	
	s status = objPeople.%Save()
	//s status = objQDetail.People.Insert(objPeople)
	if ('$$$ISOK(status))
	{
		TRollback 
		q "0"	
	}
	s objQDetail.People = objPeople
	
	d objPeople.%Close()
	
	set sc=objQDetail.%Save()
	if $system.Status.IsError(sc) 
	{                               
   		d $system.OBJ.DisplayError(sc) 
   		TRollback 
   		q "-1"
	}
	else
	{
		TCommit
		set id = objQDetail.%Id()
	}
	d objQDetail.%Close()
	q id
}

/// Desc:	获取某科室某病区下所有病人运行时质控
ClassMethod GetJitQualityResult(ADeptID As %String, AWardID As %String, ADoctorID As %String, ARuleID As %String, AStartDate As %String, AEndDate As %String) As EPRservice.dataset.Quality.EJITQualityDataset [ WebMethod ]
{
	if (ADeptID = $C(0))
	{
		s ADeptID = ""	
	}
	if (ARuleID = $C(0))
	{
		s ARuleID = ""	
	}
	if (ADoctorID = $C(0))
	{
		s ADoctorID = ""	
	}
	s dsResult = ##Class(EPRservice.dataset.Quality.EJITQualityDataset).%New()
	d dsResult.SetArgs(ADeptID, AWardID, ADoctorID, ARuleID, AStartDate, AEndDate)
	q dsResult
}

/// Desc:	获取某科室某病区下所有病人运行时质控明细
ClassMethod GetJitQualityDetail(AEpisodeID As %String, ARuleID As %String) As EPRservice.dataset.Quality.EProblemListDataset [ WebMethod ]
{
	s dsDetail = ##Class(EPRservice.dataset.Quality.EProblemListDataset).%New()
	d dsDetail.SetArgs(AEpisodeID, ARuleID)
	q dsDetail
}

/// Desc:设置不含手工评分的最后得分(结果保存在EPRinstance.Quality.QualityResult中)
/// Creator: Candyxu
/// Date:2012-7-11
ClassMethod SetActualScore(AGradeScore As %String, AResultID As %String)
{
   s objQResult = ##Class(EPRinstance.Quality.QualityResult).%OpenId(AResultID)
   s TempGrade = $p(AGradeScore,"^",1)
   s TempScore = +$p(AGradeScore,"^",2)
   s TempDeScore = +$p(AGradeScore,"^",5)
   s objQResult.ActualScore = TempScore 
   s objQResult.ActualGrade = TempGrade
   s objQResult.ActualDeScore = TempDeScore
   d objQResult.%Save()
   d objQResult.%Close()
   s objQResult = ""
}

/// Desc：最终得分(包含手工评分得分)
/// Creator: Candyxu
/// Date:2012-7-11
ClassMethod SetLastScore(AGradeScore As %String, ARuleID As %String, AEpisodeID As %String, AJobDate As %String) As %String
{
   s ret = -1
   s TempGrade = $p(AGradeScore,"^",1)
   s TempScore = $p(AGradeScore,"^",2)
   s BCount = $p(AGradeScore,"^",3)
   s CCount = $p(AGradeScore,"^",4)
   s TempDeScore = $p(AGradeScore,"^",5)
   s objQRES = ##Class(EPRinstance.Quality.QualityResultEnd).%New()
   s objQRES.EpisodeID = AEpisodeID
   s objQRES.RuleDR = ARuleID
   s objQRES.DeScore = +TempDeScore
   s objQRES.Score = +TempScore
   s objQRES.Grade = TempGrade
   s objQRES.ExecuteDate = AJobDate
   s objQRES.BCount = BCount
   s objQRES.CCount = CCount
   s sc = objQRES.%Save()
   if $$$ISERR(sc)
   {
	  q ret
   }
   else
   {
	  s ret = objQRES.%Id()
	  q ret
   }
}

/// Desc:	获取病历质控终末结果
/// Creator:Candyxu
ClassMethod GetLastScore(AEpisodeID As %String) As %String
{
	s Result = ""
	q:($d(^DHCEPRQ.QualityResultEndI("IdxEpisodeID"," "_AEpisodeID))<=0) Result
	s RowID = $o(^DHCEPRQ.QualityResultEndI("IdxEpisodeID"," "_AEpisodeID,""))
	q:( RowID ="") Result
	s Score = $li(^DHCEPRQ.QualityResultEndD(RowID),6)
	s Grade = $li(^DHCEPRQ.QualityResultEndD(RowID),4)
	s Result = Score_"^"_Grade 
	q Result
}

/// Desc: 获取不包括手工评分的病历质控结果
/// Creator:Candyxu
/// CreateDate:2013-02-27
ClassMethod GetActualScore(AEpisodeID As %String, ARuleID As %String) As %String
{
	s Result = ""
	q:($d(^DHCEPRQ.QualityResultI("IdxEpisodeRuleID"," "_AEpisodeID," "_ARuleID))<=0) Result
	s RowID = $o(^DHCEPRQ.QualityResultI("IdxEpisodeRuleID"," "_AEpisodeID," "_ARuleID,""))
	q:( RowID ="") Result
	s Score = $li(^DHCEPRQ.QualityResultD(RowID),12)
	s Grade = $li(^DHCEPRQ.QualityResultD(RowID),14)
	s Result = Score_"^"_Grade 
	q Result
}

/// Desc: 获取质控结果明细表的ID =》EPRinstance.Quality.QualityResultDetail
/// debug:##class(EPRservice.Quality.DataAccess.BOQualityResult).GetAdmAutoTaskResultDetailID("6")
ClassMethod GetAdmAutoTaskResultDetailID(ARuleID As %String) As %String
{
	s Result = ""
	
	q:(ARuleID="") Result
	
	s resultId=""
	
	for
	{
		s resultId=$o(^DHCEPRQ.QualityResultI("IdxRuleID"," "_ARuleID,resultId))
		q:(resultId="")
		
		s detailCount=""
		
		for
		{
			s detailCount=$o(^DHCEPRQ.QualityResultDetailI("IdxResult",resultId,detailCount))
			q:(detailCount="")
			
			s detailId=resultId_"||"_detailCount
			
			s Result=Result_detailId_"^"
		}
	}
	
	
	q $e(Result,1,*-1)
}

/// Desc:获取门诊质控医师、
/// Input:EpisodeID 就诊号
/// Output:质控医师名
/// Creator:2022年6月30日 WZL
/// Debug:w ##class(EPRservice.Quality.DataAccess.BOQualityResult).GetOPCheckUser(1935861)
ClassMethod GetOPCheckUser(EpisodeID)
{
	s ret=""
	
	q:(EpisodeID="") ret
	
	s ResultID=$O(^DHCEPRQ.QualityResultI("IdxEpisodeRuleID"," "_EpisodeID," 1",""))
	
	q:(ResultID="") ret
	
	s OBJResult=##class(EPRinstance.Quality.QualityResult).%OpenId(ResultID)
	
	s User=$p($g(^SSU("SSUSR",OBJResult.SignUserDR)),"^",2)
	
	q User
}

/// Desc:获取手工评分备注、
/// Input:EpisodeID 就诊号,EntryID
/// Output:备注
/// Creator:2022年6月30日 WZL
/// Debug:w ##class(EPRservice.Quality.DataAccess.BOQualityResult).GetResumeText(1935861,1864)
ClassMethod GetResumeText(EpisodeID, EntryID)
{
	s ret=""
	
	q:(EpisodeID="") ret
	
	s ResultID=""
	for
	{
		s ResultID=$o(^DHCEPRQ.QualityResultDetailI("IdxEpisodeEntryID"," "_EpisodeID," "_EntryID,ResultID))
		q:(ResultID="")
		
		s DetailID=""
		
		for
		{
			s DetailID=$o(^DHCEPRQ.QualityResultDetailI("IdxEpisodeEntryID"," "_EpisodeID," "_EntryID,ResultID,DetailID))
			q:(DetailID="")
			
			s ID=ResultID_"||"_DetailID
			
			s OBJDetail=##class(EPRinstance.Quality.QualityResultDetail).%OpenId(ID)
			s ResumeText=OBJDetail.ResumeText
			s:(ret'="") ret=ret_"^"_ResumeText
			s:(ret="") ret=ResumeText
		}
	}
	
	q ret
}

}
