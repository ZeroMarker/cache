/// 	名称：EPRservice.tool.LogMgr
/// 	描述：日志管理器，提供查看，修改日志的工具
/// 		1、ReadInstanceLog 提取某次就诊所有的日志信息到临时global
/// 		2、ModifyLogByInstance 修改某个InstanceData的日志（旧框架）
/// 		3、ModifyLogByEPRLogs 修改某个EPRLogs的日志（新框架）
/// 		4、ReadLogByEPRLogs 查看某个EPRLogs的日志（新框架）
/// 		
/// 	创建者：houj
/// 	创建日期：2010-02-22
Class EPRservice.tool.LogMgr Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "LogMgrInfo";

/// w ##class(EPRservice.tool.LogMgr).ReadInstanceLog("56")
ClassMethod ReadInstanceLog(AEpisodeID As %String) As %String
{
	quit:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	
	s blankEpisodeID = " "_AEpisodeID
	
	s ChartItemID = $O(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID",blankEpisodeID,""))
	while ChartItemID '= ""
	{
		s ECRecordID = $O(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID",blankEpisodeID,ChartItemID,""))
		s objECRecord = ##class(EPRinstance.ECRecord).%OpenId(ECRecordID)
		if (objECRecord '= "")
		{
			for I = 1:1:objECRecord.InstanceCount
			{
				s InstanceID = ECRecordID_"||"_I
				s objInstance = ##class(EPRinstance.InstanceData).%OpenId(InstanceID)
				if objInstance '= ""
				{
					if objInstance.TemplateID '= ""
					{	
						s objTemplate = ##class(EPRmeta.Template).%OpenId(objInstance.TemplateID)
						s objCategory = ##class(EPRmeta.TemplateCategory).%OpenId(objTemplate.TemplateCategoryID)
						s templateName = objCategory.Name_"^"_objTemplate.Name
						for J = 1:1:objInstance.Log.Count()
						{
							s objLog = objInstance.Log.GetAt(J)
							s ^DHCEPRDebug("InstanceLog",InstanceID,templateName,J) = objLog.OperateDate_"^"_objLog.OperateTime_"^"_objLog.OperateUserID_"^"_objLog.Action
						}
					}
				}
			}
		}
		
		s ChartItemID = $O(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID",blankEpisodeID,ChartItemID))	
	}
}

/// Debug: w ##class(EPRservice.tool.LogMgr).ModifyLogByEPRLogs("60")
ClassMethod ModifyLogByEPRLogs(eprLogsID As %String)
{
	s objEPRLogs = ##class(EPRinstance.EPRLogs).%OpenId(eprLogsID)
	q:(objEPRLogs="") "InstanceData对象不存在"
	
	s count = objEPRLogs.Log.Count()
	w "InstanceData对象共 "_count_" 个InstanceLog",!
	for i=1:1:count 
	{
		s instanceLog = objEPRLogs.Log.GetAt(i)
		if (instanceLog="")
		{
			w "第 "_i_" 个InstanceLog不存在",!
			continue
		}
		
		
		w "第 "_i_" 个InstanceLog信息如下:",!
		w "OperateDate: "_instanceLog.OperateDate,!
		w "OperateTime: "_instanceLog.OperateTime,!
		w "OperateUserID: "_instanceLog.OperateUserID,!
		w "Action: "_instanceLog.Action,!
		w "InitStatus: "_instanceLog.InitStatus,!
		w "FinalStatus: "_instanceLog.FinalStatus,!
		w "OperateMachineIP: "_instanceLog.OperateMachineIP,!
		
		//与用户交互，确认是否修改InstanceLog
		s choice = ""
		for {
			Read "是否修改该InstanceLog? 是请输入y, 否请输入n或直接回车    ", choice
			w !
			if ((choice="")||($zcvt(choice,"U")="Y")||($zcvt(choice,"U")="N"))
			{	q }
			w "输入错误，请输入 y 或 n 或 直接回车",!
		}
		
		if ($zcvt(choice,"U")="Y")	
		{	
			d ..ModifyInstanceLog(.instanceLog)
			d objEPRLogs.%Save()
		}
	}
}

/// Debug: w ##class(EPRservice.tool.LogMgr).ModifyLogByInstance("60||1")
ClassMethod ModifyLogByInstance(instanceId As %String)
{
	s objInstance = ##class(EPRinstance.InstanceData).%OpenId(instanceId)
	q:(objInstance="") "InstanceData对象不存在"
	
	s count = objInstance.Log.Count()
	w "InstanceData对象共 "_count_" 个InstanceLog",!
	for i=1:1:count 
	{
		s instanceLog = objInstance.Log.GetAt(i)
		if (instanceLog="")
		{
			w "第 "_i_" 个InstanceLog不存在",!
			continue
		}
		
		
		w "第 "_i_" 个InstanceLog信息如下:",!
		w "OperateDate: "_instanceLog.OperateDate,!
		w "OperateTime: "_instanceLog.OperateTime,!
		w "OperateUserID: "_instanceLog.OperateUserID,!
		w "Action: "_instanceLog.Action,!
		w "InitStatus: "_instanceLog.InitStatus,!
		w "FinalStatus: "_instanceLog.FinalStatus,!
		
		//与用户交互，确认是否修改InstanceLog
		s choice = ""
		for {
			Read "是否修改该InstanceLog? 是请输入y, 否请输入n或直接回车    ", choice
			w !
			if ((choice="")||($zcvt(choice,"U")="Y")||($zcvt(choice,"U")="N"))
			{	q }
			w "输入错误，请输入 y 或 n 或 直接回车",!
		}
		
		if ($zcvt(choice,"U")="Y")	
		{	
			d ..ModifyInstanceLog(.instanceLog)
			d objInstance.%Save()
		}
	}
}

ClassMethod ModifyInstanceLog(ByRef instanceLog As EPRinstance.InstanceLog)
{
	w "开始修改InstanceLog",!
	
	//修改日期
	w "OperateDate: "_instanceLog.OperateDate_", 不修改请直接回车, 修改请输入, 格式为: 2009-1-12",!
	read input
	w !
	if (input'="")
	{
		s input = $zdh(input,3)	
		s instanceLog.OperateDate = input
	}
	
	//修改时间
	w "OperateTime: "_instanceLog.OperateTime_", 不修改请直接回车, 修改请输入, 格式为: 9:23:45",!
	read input
	w !
	if (input'="")
	{
		s input = $zth(input, 1)	
		s instanceLog.OperateTime = input
	}
	
	//修改用户
	s userStr = ""
	s user=##class(User.SSUser).%OpenId(instanceLog.RealOperateUserID)
	if (user="") 
	{
		s userStr = "当前日志的用户为空"
	}
	else
	{
		s userStr = "OperateUserID: 姓名:"_user.SSUSRName_", 工号:"_user.SSUSRInitials
	}
		
		w userStr_", 不修改请直接回车, 修改请输入工号",!
		s tmpId = ""
		for {
			read input
			w !
			
			if input=""
			{	quit}
			else
			{
				s tmpId="", tmpName=""
				&sql(select SSUSR_RowID, SSUSR_Name into :tmpId, :tmpName from sqluser.ss_user where SSUSR_Initials = :input)
				if tmpId=""
				{	w "您输入的用户不存在, 请重新输入",!}
				else
				{	quit}
			}
		}
		s input = tmpId
		if (input'="")
		{	s instanceLog.OperateUserID = input}
}

/// Debug: w ##class(EPRservice.tool.LogMgr).ReadLogByEPRLogs("49","292","1")
ClassMethod ReadLogByEPRLogs(AEpisodeID As %String, APrintDocID As %String, AEPRNum As %String)
{
	s objEPRLogs = ##class(EPRinstance.EPRLogs).GetCurrLog(AEpisodeID,APrintDocID,AEPRNum)
	if objEPRLogs=""
	{
		w "没有相关日志信息",!
	}
	
	
	w !,"您要查看的病历日志相关信息如下: ",!
	s papmiDR = ##class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
	s name = ##class(EPRservice.HISInterface.PatientInfoAssist).Name(papmiDR)
	s tname = ""
	s objEPRTemplate = ##class(EPRmeta.EPRTemplate).%OpenId(APrintDocID)
	if objEPRTemplate'=""
	{	s tname = objEPRTemplate.EPRTemplateName}
	w "病人姓名: ",name,!
	w "病历名称: ",tname,!
	w "日志ID: ", objEPRLogs.%Id()
	
	s count = objEPRLogs.Log.Count()
	//w "InstanceData对象共 "_count_" 个InstanceLog",!
	w "该份病历共 "_count_" 条操作日志信息",!,!
	for i=1:1:count 
	{
		s instanceLog = objEPRLogs.Log.GetAt(i)
		if (instanceLog="")
		{
			w "第 "_i_" 条操作日志不存在",!
			continue
		}
		
		s tmpAction = ""
		s tmpActionCode = instanceLog.Action
		&sql(select ActionName into :tmpAction from EPRmeta.EPRAction where ActionCode = :tmpActionCode)
		s tmpInitStatusName = ""
		s tmpFinalStatusName = ""
		s tmpInitStatusCode = instanceLog.InitStatus
		s tmpFinalStatusCode = instanceLog.FinalStatus
		&sql(select StatusName into :tmpInitStatusName from EPRmeta.EPRStatus where StatusCode = :tmpInitStatusCode)
		&sql(select StatusName into :tmpFinalStatusName from EPRmeta.EPRStatus where StatusCode = :tmpFinalStatusCode)
		
		w !
		w "第 "_i_" 个操作日志信息如下:",!
		w "OperateDate: "_$zd(instanceLog.OperateDate,3),!
		w "OperateTime: "_$Zt(instanceLog.OperateTime,1),!
		w "OperateUserID: "_instanceLog.OperateUserID,!
		w "Action: "_tmpAction,!
		w "InitStatus: "_tmpInitStatusName,!
		w "FinalStatus: "_tmpFinalStatusName,!
		w "OperateMachineIP: "_instanceLog.OperateMachineIP,!
		
		w !
		//与用户交互，确认是否修改InstanceLog
		s choice = ""
		for {
			Read "查看下一条日志信息请按直接回车, 结束请输入q然后回车!      ", choice
			w !
			if ((choice="")||($zcvt(choice,"U")="Q"))
			{	q }
			w "输入错误，请输入 q 或 直接回车",!
		}
		q:($zcvt(choice,"U")="Q")
	}
	
	w "查看结束",!
}

/// Debug: d ##class(EPRservice.tool.LogMgr).CheckMissedEPRDoc("")
ClassMethod CheckMissedEPRDoc(AEpisodeID As %String)
{
	s missedDoc1 = "", missedDoc2 = ""
	
	s blankEpisodeID = " "_AEpisodeID
	
	w !,"检查EPRLogs"
	s curId = ""
	for {
		s curId = $O(^DHCEPRI.EPRLogsI("IdxMain", blankEpisodeID, curId))
		q:(curId = "")
		
		s id = $e(curId, 2, $L(curId))
		continue:(id="")
		
		s obj = ##class(EPRmeta.EPRTemplateCategory).%OpenId(id)
		if (obj = "")
		{
			s missedDoc1 = missedDoc1_"^"_id
			continue
		}
		
		/*
		s count = ""
		s mlid = "ML"_id
		&sql(select count(*)  into :count from EPRinstance.ECRecord 
			where EpisodeID = :AEpisodeID and ChartItemID = :mlid)	
		if (count < "1")
		{
			s missedDoc1 = missedDoc1_"^"_id
			continue
		}
		*/
		
		w !,obj.CategoryName
	}
	
	w !,"检查实例数据"
	s chartId = ""
	for {
		s chartId = $O(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID",blankEpisodeID,chartId))
		q:(chartId="")
		
		s type = $e(chartId,2,3)
		continue:(type '= "ML")
		
		s id = $e(chartId,4,$L(chartId))
		s obj = ##class(EPRmeta.EPRTemplateCategory).%OpenId(id)
		//b
		if (obj = "")
		{
			s missedDoc2 = missedDoc2_"^"_id
		}
		
		s count = ""
		&sql(select count(*)  into :count from EPRinstance.EPRLogs 
			where EpisodeID = :AEpisodeID and EPRDocID = :id)	
		if (count < "1")
		{
			s missedDoc1 = missedDoc1_"^"_id
			continue
		}
		
		w !,obj.CategoryName	
	}
	
	if (missedDoc1 '= "")||(missedDoc2 '= "")
	{
		w !,"MissedDoc: "_missedDoc1_"^"_missedDoc2
	}
	else
	{
		w !,"MissedDoc: 无"
	}
}

/// Debug: d ##class(EPRservice.tool.LogMgr).InitEPRLogs("3")
ClassMethod InitEPRLogs(AEPRLogsID As %String)
{
	s objEPRLogs = ##class(EPRinstance.EPRLogs).%OpenId(AEPRLogsID)
	if (objEPRLogs = "")
	{
		w !, "未找到EPRLogs记录"
		q
	}
	
	s instanceLog = objEPRLogs.Log.GetAt(1)
	if (instanceLog = "")
	{
		w !, "EPRLogs中没有操作记录"
		q
	}
	
	/*
	s OperateDate = instanceLog.OperateDate
	s OperateTime = instanceLog.OperateTime
	s OperateUserID = instanceLog.OperateUserID
	s Action = instanceLog.Action
	s InitStatus = instanceLog.InitStatus
	s FinalStatus = instanceLog.FinalStatus
	s OperateMachineIP = instanceLog.OperateMachineIP
	*/
	
	s sc = objEPRLogs.Log.Clear()
	if (sc '= "1")
	{
		w !, "清空EPRLogs中的操作记录失败"
		q
	}

	s sc = objEPRLogs.Log.Insert(instanceLog)
	if (sc '= "1")
	{
		w !, "插入操作记录失败"
		q
	}
	
	s objEPRLogs.EPRStatus = instanceLog.FinalStatus
	s sc = objEPRLogs.%Save()
	if (sc '= "1")
	{
		w !, "保存EPRLogs失败"
		q
	}
	
	w !, "初始化EPRLogs成功"
}

/// Desc:	修改可重复病历的创建日期时间
/// Debug: d ##class(EPRservice.tool.LogMgr).ModifyMultiCreateDT("201764", "24", "2")
ClassMethod ModifyMultiCreateDT(AEpisodeID As %String, AEPRDocID As %String, AEPRNum As %String)
{
	&sql(select ID into :eprLogsID from EPRinstance.EPRLogs 
		where EpisodeID = :AEpisodeID and EPRDocID = :AEPRDocID and EPRNum = :AEPRNum)
	if (eprLogsID = "")||(eprLogsID = $c(0))
	{
		w !,"未找到指定病历:EPRLogs不存在"
		q
	}
	
	s objEPRLogs = ##class(EPRinstance.EPRLogs).%OpenId(eprLogsID)
	if (objEPRLogs = "")
	{
		w !,"未找到指定病历:EPRLogs不存在"
		q
	}
	
	s chartItemID = "ML"_AEPRDocID
	&sql(select ID into :ecRecordID from EPRinstance.ECRecord 
		where EpisodeID = :AEpisodeID and ChartItemID = :chartItemID)
	if (ecRecordID = "")||(ecRecordID = $c(0))
	{
		w !, "未找到指定病历: InstanceData不存在"
		q
	}
	s childSub = $O(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo",ecRecordID," "_AEPRNum,""))
	if (childSub = "")||(childSub = $c(0))
	{
		w !, "未找到指定病历: InstanceData不存在"
		q
	}
	s instanceID = ecRecordID_"||"_childSub
	s objInstance = ##Class(EPRinstance.InstanceData).%OpenId(instanceID)
	if (objInstance = "")
	{
		w !, "未找到指定病历: InstanceData不存在"
		q
	}
	
	s createDate = objEPRLogs.CreateDate
	s createTime = objEPRLogs.CreateTime
	s happenDate = objEPRLogs.HappenDate
	s happenTime = objEPRLogs.HappenTime
	
	w !, "当前病历信息:"
	w !, "创建日期:"_$zd(createDate,3)
	w !, "创建时间:"_$zt(createTime)
	
	w !, "是否修改创建日期时间? 是请输入y后回车, 否请直接回车  "
	read input
	if ($zcvt(input,"U")'="Y") 
	{	q}
	
	s inputDate = "", hDate = ""
	s inputTime = "", hTime = ""
	
	w !, "请输入创建日期后回车, 格式为: 2009-1-12",!
	read input
	s inputDate = input
	s hDate = $zdh(input,3)	
	
	w !, "请输入创建时间后回车, 格式为: 19:23:45",!
	read input
	s inputTime = input
	s hTime = $zth(input,1)	
	
	s objEPRLogs.CreateDate = hDate
	s objEPRLogs.CreateTime = hTime
	
	s instanceLog = objEPRLogs.Log.GetAt(1)
	s instanceLog.OperateDate = hDate
	s instanceLog.OperateTime = hTime
	
	s objInstance.CreateDate = hDate
	s objInstance.CreateTime = hTime
	
	if (objInstance.ModifyDate < hDate)||((objInstance.ModifyDate = hDate)&&(objInstance.ModifyTime < hTime))
	{
		s objInstance.ModifyDate = hDate
		s objInstance.ModifyTime = hTime
	}
	
	s $zt = "OnErrorHandler"
	
	TSTART
	
	if ($$$ISERR(objEPRLogs.%Save()))
	{
		w !,"更新EPRLogs失败"
		TROLLBACK
		q
	}
	
	if ($$$ISERR(objInstance.%Save()))
	{
		w !,"更新InstanceData失败"
		TROLLBACK
		q
	}
	
	TCOMMIT
	
	w !,"更新创建日期时间成功!"
	
	w !,!,"开始检查操作日志,所有日志的操作日期时间应该在创建日期时间之后"
	s count = objEPRLogs.Log.Count()
	w !,"共有 "_count_" 个操作日志"
	w !,"-------------------------"
	w !,"第1个操作日志已经同步"
	for i=2:1:count 
	{
		w !,"-------------------------"
		s instanceLog = objEPRLogs.Log.GetAt(i)
		if (instanceLog="")
		{
			w !,"第 "_i_" 个InstanceLog不存在"
			continue
		}
		
		
		w !,"第 "_i_" 个InstanceLog信息如下:",!
		w "OperateDate: "_$zd(instanceLog.OperateDate,3),!
		w "OperateTime: "_$zt(instanceLog.OperateTime,1),!
		w "OperateUserID: "_instanceLog.OperateUserID,!
		w "Action: "_instanceLog.Action,!
		w "InitStatus: "_instanceLog.InitStatus,!
		w "FinalStatus: "_instanceLog.FinalStatus,!
		w "OperateMachineIP: "_instanceLog.OperateMachineIP,!
		
		//与用户交互，确认是否修改InstanceLog
		s choice = ""
		for {
			Read "是否修改该InstanceLog? 是请输入y, 否请输入n或直接回车    ", choice
			w !
			if ((choice="")||($zcvt(choice,"U")="Y")||($zcvt(choice,"U")="N"))
			{	q }
			w "输入错误，请输入 y 或 n 或 直接回车",!
		}
		
		if ($zcvt(choice,"U")="Y")	
		{	
			d ..ModifyInstanceLog(.instanceLog)
			d objEPRLogs.%Save()
		}
	}
	
OnErrorHandler
	TROLLBACK	
	q
}

/// Desc:	修改可重复病历的发生日期时间
/// Debug: d ##class(EPRservice.tool.LogMgr).ModifyMultiHappenDT("201764", "24", "2")
ClassMethod ModifyMultiHappenDT(AEpisodeID As %String, AEPRDocID As %String, AEPRNum As %String)
{
	&sql(select ID into :eprLogsID from EPRinstance.EPRLogs 
		where EpisodeID = :AEpisodeID and EPRDocID = :AEPRDocID and EPRNum = :AEPRNum)
	if (eprLogsID = "")||(eprLogsID = $c(0))
	{
		w !,"未找到指定病历:EPRLogs不存在"
		q
	}
	
	s objEPRLogs = ##class(EPRinstance.EPRLogs).%OpenId(eprLogsID)
	if (objEPRLogs = "")
	{
		w !,"未找到指定病历:EPRLogs不存在"
		q
	}
	
	s chartItemID = "ML"_AEPRDocID
	&sql(select ID into :ecRecordID from EPRinstance.ECRecord 
		where EpisodeID = :AEpisodeID and ChartItemID = :chartItemID)
	if (ecRecordID = "")||(ecRecordID = $c(0))
	{
		w !, "未找到指定病历: InstanceData不存在"
		q
	}
	s childSub = $O(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo",ecRecordID," "_AEPRNum,""))
	if (childSub = "")||(childSub = $c(0))
	{
		w !, "未找到指定病历: InstanceData不存在"
		q
	}
	s instanceID = ecRecordID_"||"_childSub
	s objInstance = ##Class(EPRinstance.InstanceData).%OpenId(instanceID)
	if (objInstance = "")
	{
		w !, "未找到指定病历: InstanceData不存在"
		q
	}
	
	s createDate = objEPRLogs.CreateDate
	s createTime = objEPRLogs.CreateTime
	s happenDate = objEPRLogs.HappenDate
	s happenTime = objEPRLogs.HappenTime
	
	w !, "当前病历信息:"
	w !, "发生日期:"_$zd(createDate,3)
	w !, "发生时间:"_$zt(createTime)
	
	w !, "是否修改发生日期时间? 是请输入y后回车, 否请直接回车  "
	read input
	if ($zcvt(input,"U")'="Y") 
	{	q}
	
	s inputDate = "", hDate = ""
	s inputTime = "", hTime = ""
	
	w !, "请输入发生日期后回车, 格式为: 2009-1-12",!
	read input
	s inputDate = input
	s hDate = $zdh(input,3)	
	
	w !, "请输入创建时间后回车, 格式为: 19:23:45",!
	read input
	s inputTime = input
	s hTime = $zth(input,1)	
	
	s objEPRLogs.HappenDate = hDate
	s objEPRLogs.HappenTime = hTime
	
	/*
	s instanceLog = objEPRLogs.Log.GetAt(1)
	s instanceLog.OperateDate = hDate
	s instanceLog.OperateTime = hTime
	*/
	s objInstance.HappenDate = hDate
	s objInstance.HappenTime = hTime
	
	s $zt = "OnErrorHandler"
	
	TSTART
	
	if ($$$ISERR(objEPRLogs.%Save()))
	{
		w !,"更新EPRLogs失败"
		TROLLBACK
		q
	}
	
	if ($$$ISERR(objInstance.%Save()))
	{
		w !,"更新InstanceData失败"
		TROLLBACK
		q
	}
	
	TCOMMIT
	
	w !,"更新创建日期时间成功!"
OnErrorHandler
	TROLLBACK
	q
}

/// Desc:	修改唯一病历的发生日期时间
/// Input:	AEpisodeID  	就诊rowid
/// 		AEPRDocID		打印模板在病历展现结构中的ID
/// 		ATemplateDocID	界面模板在病历展现结构中的ID
/// 		
/// 		参数获取方法，已出院记录为例，
/// 		1）点击电子病历，
/// 		2）打开入院记录模板[注意过程中不要去操作其他模板]
/// 		3）在保存按钮左侧，鼠标右键，选择查看源文件，
/// 		4）在源文件中找到下面参数
/// 				//界面相关参数
/// 				 	var pateintID = '1';
/// 					var episodeID = '201764';
/// 					var templateDocId = '82';
/// 					var printTemplateDocId = '28';
/// 					var bindPrnTemplateID = '270';
/// 			其中 episodeID 			为 AEpisodeID
/// 			     printTemplateDocId	为 AEPRDocID
/// 			     templateDocId		为 ATemplateDocID
/// 			     
/// Debug: 	d ##class(EPRservice.tool.LogMgr).ModifySingleCreateDT("201764", "28", "82")
ClassMethod ModifySingleCreateDT(AEpisodeID As %String, AEPRDocID As %String, ATemplateDocID As %String)
{
	s objEPRTemplate = ##Class(EPRmeta.EPRTemplate).%OpenId(ATemplateDocID)
	if (objEPRTemplate = "")||(objEPRTemplate.BindTemplateID = "")
	{
		w !, "指定模板不存在"
		q
	}
	
	w !, "指定模板名称: "_objEPRTemplate.EPRTemplateName
	
	s ATemplateID = objEPRTemplate.BindTemplateID
	s chartItemID = "CG"_ATemplateID
	s AEPRNum = "1"
	&sql(select ID into :ecRecordID from EPRinstance.ECRecord 
		where EpisodeID = :AEpisodeID and ChartItemID = :chartItemID)
	if (ecRecordID = "")||(ecRecordID = $c(0))
	{
		w !, "未找到指定病历: InstanceData不存在"
		q
	}
	s childSub = $O(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo",ecRecordID," "_AEPRNum,""))
	if (childSub = "")||(childSub = $c(0))
	{
		w !, "未找到指定病历: InstanceData不存在"
		q
	}
	s instanceID = ecRecordID_"||"_childSub
	s objInstance = ##Class(EPRinstance.InstanceData).%OpenId(instanceID)
	if (objInstance = "")
	{
		w !, "未找到指定病历: InstanceData不存在"
		q
	}
	if (objInstance.Status = "")||(objInstance.Status = "UnSaved")
	{
		w !, "病历未保存"
		q
	}
	
	&sql(select ID into :eprLogsID from EPRinstance.EPRLogs 
		where EpisodeID = :AEpisodeID and EPRDocID = :AEPRDocID and EPRNum = :AEPRNum)
	if (eprLogsID = "")||(eprLogsID = $c(0))
	{
		w !,"未找到指定病历:EPRLogs不存在"
		q
	}
	
	s objEPRLogs = ##class(EPRinstance.EPRLogs).%OpenId(eprLogsID)
	if (objEPRLogs = "")
	{
		w !,"未找到指定病历:EPRLogs不存在"
		q
	}
	
	w !, "创建日期时间信息如下:"
	w !, "创建日期: "_$zd(objInstance.CreateDate,3)
	w !, "创建时间: "_$zt(objInstance.CreateTime,1)
	
	w !, "是否修改创建日期时间? 是请输入y后回车, 否请直接回车  "
	read input
	if ($zcvt(input,"U")'="Y") 
	{	q}
	
	w !, "请输入创建日期后回车[格式为: 2009-1-2]  ",!
	read input
	s inputDate = input
	s hDate = $zdh(input, 3)
	
	w !, "请输入创建时间后回车[格式为: 19:23:45]  ",!
	read input
	s inputTime = input
	s hTime = $zth(input, 1)
	
	s objInstance.CreateDate = hDate
	s objInstance.CreateTime = hTime
	
	if (objEPRLogs.CreateDate > hDate)||((objEPRLogs.CreateDate = hDate)&&(objEPRLogs.CreateTime > hTime))
	{
		s objEPRLogs.CreateDate = hDate
		s objEPRLogs.CreateTime = hTime
		s instanceLog = objEPRLogs.Log.GetAt(1)
		s instanceLog.OperateDate = hDate
		s instanceLog.OperateTime = hTime
	}
	
	s $zt = "OnErrorHandler"
	
	TSTART
	
	if ($$$ISERR(objInstance.%Save())) 
	{	
		TROLLBACK
		w !, "更新失败"
		Q	
	}
	
	if ($$$ISERR(objEPRLogs.%Save())) 
	{	
		TROLLBACK
		w !, "更新失败"
		Q	
	}
	
	TCommit
	w !, "更新成功"
	q
OnErrorHandler
	TROLLBACK
	Q
}

/// Desc:	修改可重复病历的发生日期时间
/// Input:	AEpisodeID  	就诊rowid
/// 		AEPRDocID		打印模板在病历展现结构中的ID
/// 		AEPRNum			病历顺序号，唯一病历永远是1
/// 		                            可重复病历为 EPRinstance.InstanceData.ListNo 的值
/// Debug: d ##class(EPRservice.tool.LogMgr).DeleteLog("201869", "26", "1")
ClassMethod DeleteLog(AEpisodeID As %String, AEPRDocID As %String, AEPRNum As %String)
{
	&sql(select ID into :eprLogsID from EPRinstance.EPRLogs 
		where EpisodeID = :AEpisodeID and EPRDocID = :AEPRDocID and EPRNum = :AEPRNum)
	if (eprLogsID = "")||(eprLogsID = $c(0))
	{
		w !,"未找到指定病历:EPRLogs不存在"
		q
	}
	
	s objEPRLogs = ##class(EPRinstance.EPRLogs).%OpenId(eprLogsID)
	if (objEPRLogs = "")
	{
		w !,"未找到指定病历:EPRLogs不存在"
		q
	}
	
	
	s count = objEPRLogs.Log.Count()
	s initCount = count
	w !,"共有 "_count_" 个操作日志"
	w !,"++++++++++++++++++++++++++"
	s i = 0
	for {
		s i = i + 1
		q:(i > count)
		
		w !,"-------------------------"
		s instanceLog = objEPRLogs.Log.GetAt(i)
		if (instanceLog="")
		{
			w !,"第 "_i_" 个InstanceLog不存在"
			continue
		}
		
		
		w !,"第 "_i_" 个InstanceLog信息如下:",!
		w "OperateDate: "_$zd(instanceLog.OperateDate,3),!
		w "OperateTime: "_$zt(instanceLog.OperateTime,1),!
		w "OperateUserID: "_instanceLog.OperateUserID,!
		w "Action: "_instanceLog.Action,!
		w "InitStatus: "_instanceLog.InitStatus,!
		w "FinalStatus: "_instanceLog.FinalStatus,!
		w "OperateMachineIP: "_instanceLog.OperateMachineIP,!
		s instanceLog = ""
		
		//与用户交互，确认是否修改InstanceLog
		s choice = ""
		for {
			Read "是否删除该InstanceLog? 是请输入y, 否请输入n或直接回车    ", choice
			w !
			if ((choice="")||($zcvt(choice,"U")="Y")||($zcvt(choice,"U")="N"))
			{	q }
			w "输入错误，请输入 y 或 n 或 直接回车",!
		}
		
		if ($zcvt(choice,"U")="Y")	
		{
			if (count = 1)
			{
				w !,"删除失败. 操作记录至少保留一条, 不允许删除"
				q
			}
				
			s status = objEPRLogs.Log.RemoveAt(i)
			s tmpCount = objEPRLogs.Log.Count()
			
			if (count = tmpCount + 1)
			{
				s status = objEPRLogs.%Save()
				
				if ('$$$ISERR(status)) 
				{
					w !, "删除第"_i_"条操作日志成功"
					w !, "后续操作日志依次上移一个位置"
					w !, ""
					s i = i - 1
					s count = count - 1
				}
				else
				{
					w !,"保存日志失败"
				}
			}
			else
			{
				w !,"删除操作记录失败"
				q
			}
			
		}
	}
	
	w !
	w !,"++++++++++++++++++++++++++"
	w !, "遍历操作日志结束"
	w !, "删除前操作记录数:"_initCount
	w !, "删除后操作记录数:"_count
}

}
