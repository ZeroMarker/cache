/// Creator: 陈文俊
/// CreatDate: 
/// Description：新框架模板权限的处理类
/// Log:
/// 	(1)重构 GetDocIDForView() 方法：
/// 		新增 GetSingleDocIDForView()
/// 		新增 GetMultipleDocIDForView()
/// 		新增 GetFirstDocID()
/// 		新增 GetFirstSavedDocID()
/// 		停用 GetSavedDocID()
Class EPRservice.DocRestLogic.PrivLogic Extends %RegisteredObject [ ProcedureBlock ]
{

/// "查看"操作的标志
Parameter ACTIONVIEW = "READ";

/// Creator: 陈文俊
/// CreatDate: 2009-08-06
/// Description：取出适用于EpisodeID的某一个Chapter下的第一个符合规则的DocID(打印模板 或 挂靠界面模板的目录)
/// Table:
/// Input: EpisodeID--病人就诊号;parOthers--用于扩展的信息串（未用）;parChapterDocID--Chapter的ID； parPriActivity--是否开启了模板权限, parPatInfo--病人信息
/// Output:
/// Return:第一个符合规则的DocID(打印模板 或 挂靠界面模板的目录)
ClassMethod GetDocIDForView(EpisodeID As %String, parOthers As %String, parChapterDocID As %String, parPriActivity As %String, parPatInfo As %Library.List) As %String
{
	 s resultDocID = "" //第一个符合规则的DocID

	 q:(($d(EpisodeID)=0) || (EpisodeID = "")) resultDocID
	 q:(($d(parChapterDocID)=0) || (parChapterDocID = "")) resultDocID
	 
	 //取出该Chapter的类型
	 set chartItemType = ##class(EPRservice.EPRDoc.DocCategoryFunSet).GetChapterDocType(parChapterDocID)
	 
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

/// Desc:	处理唯一模板配置规则: 
/// 			优先取已保存过的打印模板DocID，
/// 			如果不存在，取当前可用的打印模板DocID
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
		s resultDocID = ##class(EPRservice.DocRestLogic.CategoryActLogic).GetTempByCacAndAct(parPatInfo, parChapterDocID, ..#ACTIONVIEW)
	}
	else
	{
		//权限规则关闭，取该Chapter下第一个可用打印模板DocID
		s resultDocID = ..GetFirstDocID(parChapterDocID)
	}
	
	q resultDocID
}

/// Desc:	处理可重复模板配置规则:
/// 			优先取当前可用的打印模板DocID
/// 			如果不存在，取当前可用的打印模板DocID
ClassMethod GetMultipleDocIDForView(EpisodeID As %String, parOthers As %String, parChapterDocID As %String, parPriActivity As %String, parPatInfo As %Library.List) As %String
{
	s resultDocID = ""
	
	if (parPriActivity = "Y")
	{
		//权限开启时第一优先级: 取权限规则允许的第一个可用打印模板DocID
		s resultDocID = ##class(EPRservice.DocRestLogic.CategoryActLogic).GetTempByCacAndAct(parPatInfo, parChapterDocID, ..#ACTIONVIEW)
		
		//权限开启时第二优先级: 没有规则允许的打印模板DocID，取第一个已保存过的打印模板DocID
		if (resultDocID = "")
		{
			s resultDocID = ..GetFirstSavedDocID(EpisodeID, parChapterDocID)
		}
	}
	else
	{
		//权限关闭时第一优先级：取该Chapter下第一个可用的打印模板DocID
		s resultDocID = ..GetFirstDocID(parChapterDocID)
	}
	
	q resultDocID
}

/// Status:  停用 -- 2011-08-19 by houj
/// Creator: 陈文俊
/// CreatDate: 2009-08-07
/// Description：取出某一个Chapter下已保存过的打印模板的DocID,并返回其是否保存过的标志
/// Table:
/// Input: EpisodeID--病人就诊号; chapterID--Chapter的ID
/// Output:
/// Return: 格式:是否保存^打印模板的DocID(如 Y^256)
///         如果保存过，则返回保存过的打印模板的DocID, 如果没有保存过，则返回该Chapter下第一个打印模板的DocID
ClassMethod GetSavedDocID(EpisodeID As %String, chapterID As %String) As %String
{
	 s result = ""
	 s isSaved = 0
	 s firstDocID = ""
	 s savedDocID = ""
	 s chapterID = " "_chapterID
	 s curDocID = 0
	 s curDocID = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", chapterID, curDocID))
	 s firstDocID = curDocID
	 WHILE (curDocID '= "") 
	 {
		 //判断日志是否已保存过
		s curResult = $d(^DHCEPRI.EPRLogsI("IdxMain"," "_EpisodeID," "_curDocID))
		 
		if (curResult '= 0)
		{
			s isSaved = 1
			s savedDocID = curDocID
			quit
		}
		
  		s curDocID = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", chapterID, curDocID))
	 }
	 
	 if (isSaved = 1)
	 {
	 	q "Y^"_savedDocID
	 }
	 else
	 {
	 	q "N^"_firstDocID
	 }
}

/// Desc:	取 CategoryChapter 下属第一个DocID的值
ClassMethod GetFirstDocID(ACategoryChapterID As %String) As %String
{
	s curDocID = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", " "_ACategoryChapterID, ""))
	q curDocID
}

/// Desc:	取 CategoryChapter 下属第一个保存过的DocID的值
ClassMethod GetFirstSavedDocID(AEpisodeID As %String, ACategoryChapterID As %String) As %String
{
	s savedDocID = ""
	
	s curDocID = ""
	for {
		s curDocID = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", " "_ACategoryChapterID, curDocID))
		q:(curDocID = "")
		
		 //判断日志是否已保存过
		s curResult = $d(^DHCEPRI.EPRLogsI("IdxMain"," "_AEpisodeID," "_curDocID))
		 
		if (curResult '= 0)
		{
			s savedDocID = curDocID
			quit
		}		
	}
	 
	q savedDocID
}

/// Creator: 陈文俊
/// CreatDate: 2009-08-06
/// Description：判断某个EpisodeID是否适用某个DocId(打印模板 或 挂靠界面模板的目录)，用于在选择模板时过滤模板
/// Table:
/// Input: EpisodeID--病人就诊号;parOthers--用于扩展的信息串（未用）;parTemplateID--打印模板 或 挂靠界面模板的目录 的 DocID
/// Output:
/// Return:是否适用  1--适用  0--不适用
ClassMethod CheckTempValid(EpisodeID As %String, parOthers As %String, parTemplateID As %String) As %Status
{
	 q:(($d(EpisodeID)=0) || (EpisodeID = "")) 0
	 q:(($d(parTemplateID)=0) || (parTemplateID = "")) 0
	 
	 //取出病人的信息
	 s curPatInfo = ..GetPatInfo(EpisodeID)
	 q:(($d(curPatInfo)=0) || (curPatInfo = "")) ""

	 //判断该病人是否适用DocID
	 s result = ##class(EPRservice.DocRestLogic.TempActLogic).CanTempAct(parTemplateID, ..#ACTIONVIEW, curPatInfo)
	 
	 q result
}

/// Creator: 陈文俊
/// CreatDate: 2009-08-06
/// Description：取出病人信息
/// Table:
/// Input: EpisodeID--病人就诊号
/// Output:
/// Return:病人的信息,包括性别、当前科室、病人类型等
ClassMethod GetPatInfo(EpisodeID As %String) As %Library.List
{
	 q:(($d(EpisodeID)=0) || (EpisodeID = "")) ""
	 s objPatInfo = ##class(EPRservice.DocRestLogic.PatientInfoAssist).%New()
	 s objPatInfo.AdmId = EpisodeID
	 
	 s patSex = objPatInfo.PatSex //性别
	 s patDept = objPatInfo.PatDept //当前科室
	 s patWard = objPatInfo.PatWard //当前病区
	 s patType = objPatInfo.PatType //病人类型
	 s patPriv = objPatInfo.PatPriv //所有权限
     
     q $lb(patSex,patDept,patWard,patType,patPriv)
}

/// Creator: 陈文俊
/// CreatDate: 2009-08-06
/// Description：系统参数是否设置为开启模板权限控制
/// Table:
/// Input:
/// Output:
/// Return:是否开启  Y--是  N--否
ClassMethod CheckTPrivActivity() As %String
{
	 s templatePrivActivityStr = "N"
	 s templatePrivActivityRowId = ""
	 
     s templatePrivActivityRowId = $o(^DHCEPRM.SysOptionI("NameIndex"," TPRIVACTIVITY",""))
	 if templatePrivActivityRowId'=""
	 {
		s templatePrivActivityStr=$li(^DHCEPRM.SysOptionD(templatePrivActivityRowId),4)	
	 }
	 
	 if templatePrivActivityStr '= "Y"
	 {
		s templatePrivActivityStr = "N"
	 }
	 
	 q templatePrivActivityStr
}

/// Creator: 陈文俊
/// CreatDate: 2009-08-12
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
	 if ($d(^DHCEPRI.EPRDeptI("EpisodeAndActIdx"," "_EpisodeID," Y")) '= 0)
	 {
	 	s appointDeptRowID = $o(^DHCEPRI.EPRDeptI("EpisodeAndActIdx", " "_EpisodeID, " Y", 0))
	 }
	 q:(appointDeptRowID = "") ""
	 
	 //取出指定科室记录中的有效期并判断其是否仍有效
	 s curObjAppointDept = ##class(EPRinstance.EPRDept).%OpenId(appointDeptRowID)
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
	 	 s resultDept = curObjAppointDept.EPRDept
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

}
