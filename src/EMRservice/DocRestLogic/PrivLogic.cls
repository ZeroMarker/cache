Class EMRservice.DocRestLogic.PrivLogic Extends %RegisteredObject
{

/// "查看"操作的标志
Parameter ACTIONVIEW = "READ";

/// Creator: guozongtao
/// CreatDate: 2014-1-7
/// Description：取出病人信息
/// Table:
/// Input: EpisodeID--病人就诊号
/// Output:
/// Return:病人的信息,包括性别、当前科室、病人类型等
ClassMethod GetPatInfo(argEpisodeID As %String, AuserID As %String) As %Library.List
{
	 q:(($d(argEpisodeID)=0) || (argEpisodeID = "")) ""
	 s objPatInfo = ##class(EMRservice.DocRestLogic.PatientInfoAssist).%New()
	 s objPatInfo.AdmId = argEpisodeID
	 s objPatInfo.UserId = AuserID
	  
	 s patSex = objPatInfo.PatSex //性别
	 s patDept = objPatInfo.PatDept //当前科室
	 s patWard = objPatInfo.PatWard //当前病区
	 s patType = objPatInfo.PatType //病人类型
	 s patPriv = objPatInfo.PatPriv //所有权限
     s patULevel = objPatInfo.PatULevel //用户级别
     s SSLAN = objPatInfo.SSLAN //用户语言
     
     q $lb(patSex,patDept,patWard,patType,patPriv,patULevel,SSLAN)
}

/// Creator: yejian
/// CreatDate: 2021-6-17
/// Description：取出病人信息（知情同意书，获取其他科室常用同意书）
/// Table:
/// Input: EpisodeID--病人就诊号
/// Output:
/// Return:病人的信息,包括性别、当前科室、病人类型等
ClassMethod GetPatInfoByCT(argEpisodeID As %String, AuserID As %String, AlocID As %String = "") As %Library.List
{
	 q:(($d(argEpisodeID)=0) || (argEpisodeID = "")) ""
	 s objPatInfo = ##class(EMRservice.DocRestLogic.PatientInfoAssist).%New()
	 s objPatInfo.AdmId = argEpisodeID
	 s objPatInfo.UserId = AuserID
	  
	 s patSex = objPatInfo.PatSex //性别
	 s patDept = $case(AlocID,"":objPatInfo.PatDept,:"PATDEPT"_$c(2)_AlocID) //科室为空使用当前科室,否则使用传入科室
	 s patWard = objPatInfo.PatWard //当前病区
	 s patType = objPatInfo.PatType //病人类型
	 s patPriv = objPatInfo.PatPriv //所有权限
     s patULevel = objPatInfo.PatULevel //用户级别
     s SSLAN = objPatInfo.SSLAN //用户语言
     
     q $lb(patSex,patDept,patWard,patType,patPriv,patULevel,SSLAN)
}

/// Creator: guozongtao
/// CreatDate: 2014-01-07
/// Description：获取指定病人当前被指定的科室
/// Table:
/// Input:
/// Output:
/// Return:指定的科室ID，如果在当前时间段中没有有效的指定，则返回空
ClassMethod GetAppointDept(EpisodeID As %String) As %String
{
	 q:(EpisodeID = "") ""
	 
	 //取出指定科室表中的记录ID
	 s appointDeptRowID = ""
	 if ($d(^DHCEMRI.EMRDeptI("EpisodeAndActIdx"," "_EpisodeID," Y")) '= 0)
	 {
	 	s appointDeptRowID = $o(^DHCEMRI.EMRDeptI("EpisodeAndActIdx", " "_EpisodeID, " Y", 0))
	 }
	 q:(appointDeptRowID = "") ""
	 
	 //取出指定科室记录中的有效期并判断其是否仍有效
	 s curObjAppointDept = ##class(EMRinstance.EMRDept).%OpenId(appointDeptRowID)
	 q:(curObjAppointDept = "") ""
	 if (curObjAppointDept.IsActivity = "N")
	 {
	 	q ""
	 }
	 
	 s isActivity = "N"
	 s endDate = curObjAppointDept.EndDate
	 s endTime = curObjAppointDept.EndTime
	 s curDate = $p($h, ",", 1)
	 s curTime = $p($h, ",", 2)
	 if ((+endDate) > (+curDate))
	 {
		 s isActivity = "Y"
	 }
	 elseif ((+endDate) = (+curDate))
	 {
	 	 if ((+endTime) > (+curTime))
	 	 {
		 	s isActivity = "Y"
		 }
	 }
	 
	 //如果有效则返回指定的DeptID,如果无效则返回空同时设置状态
	 s resultDept = ""
	 if (isActivity = "Y")
	 {
	 	 s resultDept = curObjAppointDept.EMRDept
	 }
	 else
	 {
		 s resultDept = ""
		 s curObjAppointDept.IsActivity = "N"
		 d curObjAppointDept.%Save()
	 }
	 d curObjAppointDept.%Close()
	 s curObjAppointDept = ""
	 
	 //返回结果
	 q resultDept
}

/// Creator:     guozongtao
/// CreatDate:   2014-1-7
/// Description：取出适用于EpisodeID的某一个Chapter下的第一个符合规则的DocID(打印模板 或 挂靠界面模板的目录)
/// Table:
/// Input:       EpisodeID--病人就诊号;parOthers--用于扩展的信息串（未用）;parChapterDocID--Chapter的ID； parPriActivity--是否开启了模板权限, parPatInfo--病人信息
/// Output:
/// Return:      第一个符合规则的DocID(打印模板 或 挂靠界面模板的目录)
ClassMethod GetDocIDForView(EpisodeID As %String, parOthers As %String, parChapterDocID As %String, parPriActivity As %String, parPatInfo As %Library.List) As %String
{
	 s resultDocID = "" //第一个符合规则的DocID

	 q:(($d(EpisodeID)=0) || (EpisodeID = "")) resultDocID
	 q:(($d(parChapterDocID)=0) || (parChapterDocID = "")) resultDocID
	 
	 //取出该Chapter的类型
	 set chartItemType = ##class(EMRservice.EMRDoc.DocCategoryFunSet).GetChapterDocType(parChapterDocID)
	 
	 //分开类型及是否保存过来处理
	 if (chartItemType = "Single")
	 {
		 s resultDocID = ..GetSingleDocIDForView(EpisodeID, parOthers, parChapterDocID, parPriActivity, parPatInfo)
	 }
	 else
	 {
		 s resultDocID = ..GetMultipleDocIDForView(EpisodeID, parOthers, parChapterDocID, parPriActivity, parPatInfo)
	 }
	 
	 q resultDocID
}

/// Creator:     guozongtao
/// CreatDate:   2014-1-7
/// Description：处理唯一模板配置规则: 
///              优先取已保存过的打印模板DocID，
///              如果不存在，取当前可用的打印模板DocID
/// Table:
/// Input:       EpisodeID--病人就诊号;parOthers--用于扩展的信息串（未用）;parChapterDocID--Chapter的ID； parPriActivity--是否开启了模板权限, parPatInfo--病人信息
/// Output:
/// Return:      第一个符合规则的DocID(打印模板 或 挂靠界面模板的目录)
ClassMethod GetSingleDocIDForView(EpisodeID As %String, parOthers As %String, parChapterDocID As %String, parPriActivity As %String, parPatInfo As %Library.List) As %String
{
	s resultDocID = ""
	
	//第一优先级: 取该Chapter下已保存过的打印模板DocID
	s resultDocID = ..GetFirstSavedDocID(EpisodeID, parChapterDocID)
	q:(resultDocID '= "") resultDocID
	
	//第二优先级: 根据权限规则开启情况，取当前可用的打印模板DocID
	if (parPriActivity = "Y")
	{
		//权限规则开启，取权限规则允许的第一个可用打印模板DocID
		s resultDocID = ##class(EMRservice.DocRestLogic.CategoryActLogic).GetTempByCacAndAct(parPatInfo, parChapterDocID, ..#ACTIONVIEW)
	}
	else
	{
		//权限规则关闭，取该Chapter下第一个可用打印模板DocID
		//s resultDocID = ..GetFirstDocID(parChapterDocID)
		//权限规则关闭，取该chapter下所有可以用的DocID
		s resultDocID = ..GetAllDocID(parChapterDocID)
		
	}
	
	q resultDocID
}

/// Creator:     guozongtao
/// CreatDate:   2014-1-7
/// Description：处理可重复模板配置规则: 
///              优先取当前可用的打印模板DocID
///              如果不存在，取当前可用的打印模板DocID
/// Table:
/// Input:       EpisodeID--病人就诊号;parOthers--用于扩展的信息串（未用）;parChapterDocID--Chapter的ID； parPriActivity--是否开启了模板权限, parPatInfo--病人信息
/// Output:
/// Return:      第一个符合规则的DocID(打印模板 或 挂靠界面模板的目录)
ClassMethod GetMultipleDocIDForView(EpisodeID As %String, parOthers As %String, parChapterDocID As %String, parPriActivity As %String, parPatInfo As %Library.List) As %String
{
	s resultDocID = ""
	
	if (parPriActivity = "Y")
	{
		//权限开启时第一优先级: 取权限规则允许的第一个可用打印模板DocID
		s resultDocID = ##class(EMRservice.DocRestLogic.CategoryActLogic).GetTempByCacAndAct(parPatInfo, parChapterDocID, ..#ACTIONVIEW)
		
		//权限开启时第二优先级: 没有规则允许的打印模板DocID，取第一个已保存过的打印模板DocID
		if (resultDocID = "")
		{
			s resultDocID = ..GetFirstSavedDocID(EpisodeID, parChapterDocID)
		}
	}
	else
	{
		//权限关闭时第一优先级：取该Chapter下第一个可用的打印模板DocID
		//s resultDocID = ..GetFirstDocID(parChapterDocID)
		//权限规则关闭，取该chapter下所有可以用的DocID
		s resultDocID = ..GetAllDocID(parChapterDocID)
	}
	
	q resultDocID
}

/// Creator:     guozongtao
/// CreatDate:   2014-1-7
/// Description：取 CategoryChapter 下属第一个保存过的DocID的值
/// Table:
/// Input:       argEpisodeID:病人就诊号
///              argCategoryChapterID 病历展现结构第二层节点ID
/// Output:
/// Return:     
ClassMethod GetFirstSavedDocID(argEpisodeID As %String, argCategoryChapterID As %String) As %String
{
	s ReturnValue = ""
	s argCategoryChapterID=" "_argCategoryChapterID
	//优化索引，逻辑遗漏代码
	//s argEpisodeID=" "_argEpisodeID
	
	s curseq = ""
	for
	{
		s curseq = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq",argCategoryChapterID,curseq))
		q:(curseq = "")
		s curDocID = ""
		for
		{
			s curDocID = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq",argCategoryChapterID,curseq,curDocID))
			q:(curDocID = "")
		
			 //判断日志是否已保存过,修改增加状态判断，如果有日志，切不为删除状态。
			 //s curResult = $d(^DHCEMRI.EMRLogsI("IdxMain",argEpisodeID," "_curDocID))
			 s curResult = 0
			 s EMRNum = ""
			 for
			 {
				s EMRNum = $o(^DHCEMRI.EMRLogsI("IdxMain",argEpisodeID,curDocID,EMRNum))
				q:(EMRNum="")
				q:(curResult'=0)
				s logRowID = ""
		 		for
		 		{
			 		s logRowID = $o(^DHCEMRI.EMRLogsI("IdxMain",argEpisodeID,curDocID,EMRNum,logRowID))
			 		q:(logRowID="")
			 		s objLog = ##class(EMRinstance.EMRLogs).%OpenId(logRowID)
			 		q:(objLog="")
			 		if (objLog.EMRStatus '="deleted")
			 		{
				 		s curResult=logRowID
				 		q
			 		}
		 		}
			 }
			 
			if (curResult '= 0)
			{
				s ReturnValue = $case(ReturnValue,"":curDocID,:ReturnValue_"^"_curDocID)
				//quit
			}		
		}
	}
	q ReturnValue
}

/// Creator:     guozongtao
/// CreatDate:   2014-1-7
/// Description：取 CategoryChapter 下属第一个DocID的值/// 
/// Table:
/// Input:       argEpisodeID:病人就诊号
///              argCategoryChapterID 病历展现结构第二层节点ID
/// Output:
/// Return:     
ClassMethod GetFirstDocID(argCategoryChapterID As %String) As %String
{
	s curDocID = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID", " "_argCategoryChapterID, ""))
	q curDocID
}

/// Creator:     yejian
/// CreatDate:   2020-5-25
/// Description：取 CategoryChapter 下所有DocID的值/// 
/// Table:
/// Input:       argEpisodeID:病人就诊号
///              argCategoryChapterID 病历展现结构第二层节点ID
/// Output:返回CategoryChapter下所有DocID
/// Return: DocID1^DocID2^DocID3
ClassMethod GetAllDocID(argCategoryChapterID As %String) As %String
{
	s ReturnValue=""
	s curseq = ""
	for
	{
		s curseq = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_argCategoryChapterID,curseq))
		q:(curseq = "")
		s curDocID = ""
		for
		{
			s curDocID = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_argCategoryChapterID,curseq,curDocID))
			q:(curDocID = "")
			s ReturnValue = $case(ReturnValue,"":curDocID,:ReturnValue_"^"_curDocID)	
		}
	}
	q ReturnValue
}

}
