Class EPRservice.BOEPRLogs Extends %SOAP.WebService [ ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "EPRLogsInfo";

/// Creator: houj
/// CreateDate: 2009-11-14
/// Desc: 根据唯一界面模板所属病历类型判断病历日志顺序号EPRNum
/// Input: argPrtDocId 打印模板类型目录或挂载界面模板类型目录的id
/// Output: 1 或 0
/// 		1 表示挂载在唯一病历下的唯一界面模板对应的日志顺序号
/// 		0 表示挂载在科研病历或可重复打印病历下的唯一界面模板对应的日志顺序号
/// Debug: w ##class(EPRservice.BOEPRLogs).GetSingleEPRNumByDocType("41")
ClassMethod GetSingleEPRNumByDocType(argPrtDocId As %String) As %String
{
	
	s printTemplateType = ##class(EPRservice.BOEPRTemplateCategory).GetBindPrtTemplateType(argPrtDocId)
	
	s eprNum = ""
	if (printTemplateType="")||(printTemplateType="Multiple")
	{
		//唯一界面模板挂载在科研病历或可重复打印病历下
		//此时其 EPRNum 设置为 0，以便与挂载在唯一打印病历下的唯一界面模板区分开来
		s eprNum = "0"
	}
	else
	{
		//唯一界面模板挂载在唯一打印病历下
		s eprNum = "1"
	}
	
	q eprNum
}

/// Desc: 取某次就诊、某份病历、某段日期范围内的日志rowid
/// Input: parEpisodeID:就诊rowid，parStartDate：起始日期，parEndDate：结束日期，
///  		   parEPRDocIDs：打印模板在病历结构表中的ID序列，如 23^24^34^40
/// Output: 无
/// Return：EPRLogs的rowid序列，格式: docId1^logId1#docId2^logId2
/// Debug: w ##class(EPRservice.BOEPRLogs).GetLogIDByDate("297","0","0","61613","0","28")
ClassMethod GetLogIDByDate(parEpisodeID As %String, parStartDate As %String, parStartTime As %String, parEndDate As %String, parEndTime As %String, parEPRDocIDs As %String) As %String
{
	q:((parEpisodeID="")||(parStartDate="")||(parEndDate="")||(parStartTime="")||(parEndTime="")||(parEPRDocIDs="")) ""
	q:((+parStartDate)>(+parEndDate)) ""
	s retValue = ""
	
	s blankEID = " "_parEpisodeID
	s blankStDate = " "_parStartDate
	s blankEndDate = " "_parEndDate
	s blankStTime = " "_parStartTime
	s blankEndTime = " "_parEndTime
	s eprDocIDList= "^"_parEPRDocIDs_"^"
	
	s date = blankStDate
	while (date '= "") 
	{
		s time = ""
		for {                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
			s time = $O(^DHCEPRI.EPRLogsI("IdxForLink",blankEID,date,time))
			q:(time="")
			
			if $$CheckDateTime(date,time)="0" continue
			
			s eprDocId=""
			for {
				s eprDocId = $O(^DHCEPRI.EPRLogsI("IdxForLink",blankEID,date,time,eprDocId))
				q:(eprDocId="")
				
				s docId = $E(eprDocId,2,$L(eprDocId))
				if $find(eprDocIDList,"^"_docId_"^")>0
				{
					//b
					s rowid = $O(^DHCEPRI.EPRLogsI("IdxForLink",blankEID,date,time,eprDocId,""))
					s retValue = retValue_"#"_docId_"^"_rowid
				}
			}
		}
		
		s date =  $O(^DHCEPRI.EPRLogsI("IdxForLink",blankEID,date))
		q:(date="")
		q:(date>blankEndDate)
	}
	
	if retValue '= ""
	{	s retValue = $E(retValue,2,$L(retValue))}
	
	q retValue
	
CheckDateTime(date, time)
    s tmpTime = $E(time,2,$L(time))
    
	if (blankStDate = blankEndDate)
	{
		//起始日期等于结束日期，时间要满足：起始时间 <= time <= 结束时间	
		if (tmpTime '<  parStartTime)&&(tmpTime '> parEndTime)
		{	q "1"}
	}
	elseif (date = blankStDate)
	{
		//起始日期不等于结束日期且date等于起始日期，时间要满足：time >= 起始时间
		if (tmpTime '< parStartTime) {q "1"}
	}
	elseif (date = blankEndDate)
	{
		//起始日期不等于结束日期且date等于结束日期，时间要满足：time <= 结束时间
		if (tmpTime '> parEndTime) {q "1"}
	}
	else
	{
		//起始日期不等于结束日期且date在起始和结束日期之间，任何时间都满足条件
		q "1"
	}
	
	q "0"
}

ClassMethod GetCreaterID(argEpisodeID As %String, argPrintDocID As %String, argEPRNum As %String) As %String
{
	s logs = ##class(EPRinstance.EPRLogs).GetCurrLog(argEpisodeID,argPrintDocID,argEPRNum)
	q:(logs="") ""
	q logs.CreateUserID
}

/// 获取审核者的ID
ClassMethod GetCheckerID(argEpisodeID As %String, argPrintDocID As %String, argEPRNum As %String) As %String
{
	s chkUser = ""
	s logs = ##class(EPRinstance.EPRLogs).GetCurrLog(argEpisodeID,argPrintDocID,argEPRNum)
	q:(logs="") ""
	
	s count=logs.Log.Count()
	q:(count=0) ""
	 
	for i=count:-1:1 
	{
		s log=logs.Log.GetAt(i)
		if log="" continue
		
		s action = log.Action
		if (("chiefCheck"=action)||("attendingCheck"=action))
		{
			s chkUser = log.OperateUserID
		    q
		}
	}	
	q chkUser
}

/// Desc: 获取最后一个做了指定操作的用户ID
ClassMethod GetUserIDByAction(argEpisodeID As %String, argPrintDocID As %String, argEPRNum As %String, argAction As %String) As %String
{
	s userID = ""
	s logs = ##class(EPRinstance.EPRLogs).GetCurrLog(argEpisodeID,argPrintDocID,argEPRNum)
	q:(logs="") ""
	
	s count=logs.Log.Count()
	q:(count=0) ""
	 
	for i=count:-1:1 
	{
		s log=logs.Log.GetAt(i)
		if log="" continue
		
		s action = log.Action
		if ($zcvt(argAction,"U")=$zcvt(action,"U"))
		{
			s userID = log.OperateUserID
		    q
		}	
	}
 
	q userID
}

/// Desc: 获取最后一个做了指定操作的时间
ClassMethod GetOperationDateTimeByAction(argEpisodeID As %String, argPrintDocID As %String, argEPRNum As %String, argAction As %String) As %String
{
	s operateDate = ""
	s operateTime = ""
	s logs = ##class(EPRinstance.EPRLogs).GetCurrLog(argEpisodeID,argPrintDocID,argEPRNum)
	q:(logs="") ""
	
	s count=logs.Log.Count()
	q:(count=0) ""
	 
	for i=count:-1:1 
	{
		s log=logs.Log.GetAt(i)
		if log="" continue
		
		s action = log.Action
		if ($zcvt(argAction,"U")=$zcvt(action,"U"))
		{
			s operateDate = log.OperateDate
			s operateTime = log.OperateTime
		    q
		}	
	}
 
	q operateDate_","_operateTime
}

/// Desc: 获取最后一个做了指定操作的用户姓名
ClassMethod GetUserNameByAction(argEpisodeID As %String, argPrintDocID As %String, argEPRNum As %String, argAction As %String) As %String
{
	s userName = ""
	s logs = ##class(EPRinstance.EPRLogs).GetCurrLog(argEpisodeID,argPrintDocID,argEPRNum)
	q:(logs="") ""
	
	s count=logs.Log.Count()
	q:(count=0) ""
	 
	for i=count:-1:1 
	{
		s log=logs.Log.GetAt(i)
		if log="" continue
		
		s action = log.Action
		if ($zcvt(argAction,"U")=$zcvt(action,"U"))
		{
			s userName = log.OperateUserName
		    q
		}	
	}
 
	q userName
}

/// Desc: 获取所有做了指定操作的用户姓名
/// Debug: w ##class(EPRservice.BOEPRLogs).GetUserByAction(objEPRLogs,"save^complete")
ClassMethod GetUserByAction(argEpisodeID As %String, argPrintDocID As %String, argEPRNum As %String, argAction As %String) As %String
{
	s logs = ##class(EPRinstance.EPRLogs).GetCurrLog(argEpisodeID,argPrintDocID,argEPRNum)
	q:(logs="") ""
	
	s count=logs.Log.Count()
	q:(count=0) ""
	
	s retValue = "/"
	
	s actionStr="^"_argAction_"^"
  	
	for i=1:1:count {
		s log=logs.Log.GetAt(i)
		if log="" continue
		
		s action = log.Action
		if $find(actionStr,"^"_action_"^")<1 continue
		
		s userName = log.OperateUserName
		b
		if userName="" continue
		
		//检查是否重名
		if $find(retValue,"/"_userName_"/")>1 continue
		
		s retValue = retValue_userName_"/"
	}
	
	//去掉两端的"/"
	if retValue="/"
	{	s retValue = ""}
	else
	{	
		s retValue = $E(retValue,2,$L(retValue)-1)
		s retValue = $tr(retValue,$c(13),"")
  		s retValue = $tr(retValue,$c(10),"")
	}
	
	q retValue
}

/// Desc: 获取某份病历的所有操作记录
Query GetAllLogInfo(argAdm As %String, argPrintDocID As %String, argEPRNum As %String) As %Query(ROWSPEC = "OrderID:%String, UserName:%String, OperDate:%String, OperTime:%String, MachineIP:%String, Action:%String, TplName:%String, TplCreateDate:%String, TplCreateTime:%String")
{
}

ClassMethod GetAllLogInfoExecute(ByRef qHandle As %Binary, argAdm As %String, argPrintDocID As %String, argEPRNum As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	s logs = ##class(EPRinstance.EPRLogs).GetCurrLog(argAdm,argPrintDocID,argEPRNum)
	//s logs = $ZOBJCLASSMETHOD("EPRinstance.EPRLogs","GetCurrLog",argAdm,argPrintDocID,argEPRNum)
	q:(logs="") $$$OK
	
	s count=logs.Log.Count()
	q:(count=0) ""
	
	//临时缓存
	s arrMemo = ##class(%ArrayOfDataTypes).%New()
	
	for i=1:1:count {
		s log=logs.Log.GetAt(i)
		if log="" continue
		
		s (userName, operDate, operTime, machineIP, action) = ""
		s (tplName, tplCreateDate, tplCreateTime) = ""
		
		s userName = log.OperateUserName
		s userName = $tr(userName,$c(13),"")
  		s userName = $tr(userName,$c(10),"")
		s:(log.OperateDate'="") operDate = $ZD(log.OperateDate, 3)
  		s:(log.OperateTime'="") operTime = $ZT(log.OperateTime, 1)
		s machineIP = log.OperateMachineIP
		s action = log.Action
  		//&sql(select top 1 ActionName into :action from EPRmeta.EPRAction where ActionCode = :action)
		s action = ..GetActionName(action)
		
		s tplID = log.TemplateID
		if (tplID '= "")
		{
			s tplInfo = arrMemo.GetAt(tplID)
			if (tplInfo = "")
			{
				s tplInfo = ..GetTplInfo(argAdm, argPrintDocID, argEPRNum, tplID)
				s tplInfo = $tr(tplInfo, $c(10))
				s tplInfo = $tr(tplInfo, $c(13))
				d arrMemo.SetAt(tplID, tplInfo)
			}
			s tplName = $P(tplInfo, "^", 1)
			s tplCreateDate = $P(tplInfo, "^", 2)
			s tplCreateTime = $P(tplInfo, "^", 3)
		}
		
		s ^CacheTemp(repid, ind) = $LB(ind, userName,operDate,operTime,machineIP,action,tplName,tplCreateDate,tplCreateTime)
		s ind = ind + 1
	}
	
	Quit $$$OK
}

ClassMethod GetAllLogInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllLogInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAllLogInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllLogInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

//设置病历状态优先级

ClassMethod GetEPRStatusPriority(EPRStatus As %String) As %String
{
	s Priority="2"
	s:(EPRStatus="create") Priority=1
	s:(EPRStatus="unfinished") Priority=2
	s:(EPRStatus="finished") Priority=3
	s:(EPRStatus="commited") Priority=4
	s:(EPRStatus="attendingChecked") Priority=5
	s:(EPRStatus="chiefChecked") Priority=6
	s:(EPRStatus="archieved") Priority=7
	q Priority
}

/// Desc: 取某次就诊、某份病历、某段日期范围内的日志rowid
/// Input: parEpisodeID:就诊rowid，parStartDate：起始日期，parEndDate：结束日期，
///  		   parEPRDocIDs：打印模板在病历结构表中的ID序列，如 23^24^34^40
/// Output: 无
/// Return：EPRLogs的rowid序列，格式: docId1^logId1#docId2^logId2
/// Debug: w ##class(EPRinstance.EPRLogs).GetLogIDByDate("297","0","0","61613","0","28")
ClassMethod GetRankedLogIDByDate(AEpisodeID As %String, AEPRDocIDList As %String, AStartDate As %String, AStartTime As %String, AEndDate As %String, AEndTime As %String) As %String
{
	s retValue = ""
	
	q:((AEpisodeID="")||(AEPRDocIDList="")) retValue
	
	//是否使用日期时间段过滤病历
	s dateTimeflag = "0"
	if ((AStartDate'="")&&(AEndDate'="")&&(AStartTime'="")&&(AEndTime'=""))
	{	
		s dateTimeflag = "1"
	}
	
	//获取系统设置病历状态参数
	s SysStatus=##class(EPRmeta.SysOption).GetOptionValueByName("SysEPRStatus")
	s SysStatusPriority=..GetEPRStatusPriority(SysStatus)
	
	s uniqueID = $I(^CacheTemp)
	
	s count =  $L(AEPRDocIDList, "^")
	for i = 1:1:count
	{
		s eprDocID = $P(AEPRDocIDList, "^", i)
		continue:(eprDocID = "")
		
		s eprNum = "0"
		for {
			s eprNum = $O(^DHCEPRI.EPRLogsI("IdxMain"," "_AEpisodeID," "_eprDocID, eprNum))
			q:(eprNum="")
			
			s eprLogsID = $O(^DHCEPRI.EPRLogsI("IdxMain"," "_AEpisodeID," "_eprDocID, eprNum, ""))
			
			s objEPRLogs = ##Class(EPRinstance.EPRLogs).%OpenId(eprLogsID)
			continue:(objEPRLogs="")
			
			s happenDate = objEPRLogs.HappenDate
			s happenTime = objEPRLogs.HappenTime
			s EPRStatus  = objEPRLogs.EPRStatus
			
			s EPRStatusPriority=..GetEPRStatusPriority(EPRStatus)
			continue:(EPRStatusPriority<SysStatusPriority)			
			
			if (dateTimeflag = "1")
			{
				s isValid = $$IsDateTimeValid(happenDate, happenTime, AStartDate, AStartTime, AEndDate, AEndTime)
				continue:('isValid)
			}
			
			s ^CacheTemp(uniqueID, happenDate, happenTime, eprDocID) = eprLogsID 	
		}
	}
	
	s date = ""
	for {
		s date = $O(^CacheTemp(uniqueID, date))
		q:(date="")
		
		s time = ""
		for {                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
			s time = $O(^CacheTemp(uniqueID, date, time))
			q:(time="")
			
			s eprDocID = ""
			for {
				s eprDocID = $O(^CacheTemp(uniqueID, date, time, eprDocID))
				q:(eprDocID="")
				
				s eprLogsID = $g(^CacheTemp(uniqueID, date, time, eprDocID))
				if (retValue = "")
				{
					s retValue = eprDocID_"^"_eprLogsID
				}
				else
				{
					s retValue = retValue_"#"_eprDocID_"^"_eprLogsID
				}
			}
		}
	}
	
	k ^CacheTemp(uniqueID)
	
	q retValue
	
IsDateTimeValid(date, time, startDate, startTime, endDate, endTime)
	if (date < startDate)
	{
		q "0"
	}
	elseif (date > endDate)
	{
		q "0"
	}
	elseif (date = startDate)&&(date = endDate)
	{
		if (time < startTime) 
		{
			q "0"
		}
		elseif (time > endTime)
		{
			q "0"
		}
	}
	
	q "1"
}

/// Desc:	获取模板数据创建日期和时间信息
ClassMethod GetTplInfo(admID, eprDocID, eprNum, tplID) As %String
{
	s tname = "", date = "", time = ""
	s chartType = "", cateID = ""
	
	//取模板信息
	//&sql(select top 1 TemplateCategoryID, ChartItemType into :cateID, :chartType
	//	from EPRmeta.Template where id = :tplID) 
	s templateInfo = $G(^DHCEPRM.TemplateD(tplID))
	if (templateInfo '= "")
	{
		s cateID = $List(templateInfo,7)
		s chartType = $List(templateInfo,9)
	}
	
	//模板名称:使用界面模板所属目录名称代替界面模板名称
	if (cateID '= "")&&(cateID '= $c(13))
	{
		//&sql(select Name into :tname from EPRmeta.TemplateCategory where id = :cateID)
		s tplCategoryInfo = $G(^DHCEPRM.TemplateCategoryD(cateID))
		if (tplCategoryInfo '= "")
		{
			s tname = $List(tplCategoryInfo,3)
			s tname = tname_"->"_$ListGet(templateInfo,5)
		}
	}
	
	if (chartType = "Single")
	{	s chartID = "CG"_tplID}
	else
	{	s chartID = "ML"_eprDocID}
	
	s ecRecordID = "", instanceID = ""
	
	//&sql(select top 1 ID into :ecRecordID from EPRinstance.ECRecord 
	//	where EpisodeID = :admID and ChartItemID = :chartID)
	s ecRecordID = ..GetECRecordID(admID, chartID)
	
	q:(ecRecordID = "") tname_"^"_date_"^"_time
	
	//&sql(select top 1 to_date(CreateDate,'yyyy-mm-dd'), to_char(CreateTime) into :date, :time from EPRinstance.InstanceData
	//	where TheECRecord = :ecRecordID and ListNo = :eprNum)
	//if (time '= "") {s time = $zt(time,1)}
	s instanceID = ..GetInstanceID(ecRecordID, eprNum)
	s childSub = $P(instanceID,"||",2)
	if (childSub '= "")
	{
		s instanceInfo = $G(^DHCEPRI.ECRecordD(ecRecordID,"Instances",childSub))
		if (instanceInfo '= "")
		{
			s date = $List(instanceInfo,25)
			s date = $zd(date,3)
			s time = $List(instanceInfo,26)
			s time = $zt(time,1)
		}
	}
	
	q tname_"^"_date_"^"_time
}

/// Desc:	取ECRecordID
ClassMethod GetECRecordID(AEpisodeID As %String, AChartItemID As %String) As %String
{
	s ecRecordID = $O(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_AChartItemID,""))
	q ecRecordID
}

/// Desc:	取InstanceDataID
ClassMethod GetInstanceID(AECRecordID As %String, AEPRNum As %String) As %String
{
	s childSub = $O(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo",AECRecordID," "_AEPRNum,""))
	q:(childSub = "") ""
	q AECRecordID_"||"_childSub
}

ClassMethod GetRecordTitle(AEPRLogsID As %String) As %String [ WebMethod ]
{
	q $p($h,",",2)
	
	s title = "unknown"
	
	q:(AEPRLogsID = "") title
	
	s objEPRLogs = ##Class(EPRinstance.EPRLogs).%OpenId(AEPRLogsID)
	q:(objEPRLogs = "") title
	
	s objEPRTemplateCategory = ##Class(EPRmeta.EPRTemplateCategory).%OpenId(objEPRLogs.EPRDocID)
	q:(objEPRTemplateCategory = "") title
	
	s printTemplateID = objEPRTemplateCategory.BindPrnTemplateID
	q:(printTemplateID = "")
	
	s objPrintTemplate = ##Class(EPRmeta.PrintTemplate).%OpenId(printTemplateID)
	q:(objPrintTemplate = "") title
	
	s printTemplateCategoryID = objPrintTemplate.PrintTemplateCategoryID
	q:(printTemplateCategoryID = "") title
	
	s objPrintTemplateCategory = ##Class(EPRmeta.PrintTemplateCategory).%OpenId(printTemplateCategoryID)
	q:(objPrintTemplateCategory = "") title
	
	s title = objPrintTemplateCategory.Name
	s title = $e(title, 1, 7)
	
	q title
	
	//s objParentEPRTemplateCategory = ##Class(EPRmeta.EPRTemplateCategory).%OpenId(objEPRTemplateCategory.ParentID)
	//q:(objParentEPRTemplateCategory = "") title
	
	//q objParentEPRTemplateCategory.Name
}

/// 	Desc:	取操作名称
ClassMethod GetActionName(AAction As %String) As %String
{
	q:(AAction = "") ""
	
	s action = $zcvt(AAction,"U")
	s id = $O(^DHCEPRM.EPRActionI("IdxActionCode"," "_action,""))
	q:(id = "") ""
	
	s actionInfo = $G(^DHCEPRM.EPRActionD(id))
	q:(actionInfo = "") ""
	
	s actionName = $List(actionInfo,3)
	q actionName
}

/// Desc: 获取最后一个做了指定操作的用户姓名
ClassMethod GetFristLogByAction(argEpisodeID As %String, argPrintDocID As %String, argEPRNum As %String, argAction As %String) As %String
{
	s eprLogs = ##class(EPRinstance.EPRLogs).GetCurrLog(argEpisodeID,argPrintDocID,argEPRNum)
	q:(eprLogs="") ""
	
	s instanceLog = eprLogs.GetFirstLogByAction(argAction)
	q instanceLog
}

/// Desc:	获取指定病历记录数
/// Debug:	w ##Class(EPRservice.BOEPRLogs).GetMaxEPRNum("","")
ClassMethod GetMaxEPRNum(AEpisodeID As %String, APrintDocID As %String) As %Integer
{
	q:(AEpisodeID="")||(APrintDocID="") "0"
	s eprNum = $O(^DHCEPRI.EPRLogsI("IdxMain", " "_AEpisodeID, " "_APrintDocID, ""), -1)
	s:(eprNum = "") eprNum = 0
	q eprNum
}

/// Desc:	获取EPRLogsID
/// Debug:	w ##Class(EPRservice.BOEPRLogs).GetEPRLogsID("201764","3","1")
ClassMethod GetEPRLogsID(AEpisodeID As %String, APrintDocID As %String, AEPRNum As %String) As %String
{
	q:(AEpisodeID="")||(APrintDocID="")||(AEPRNum="") ""
	s eprLogsID = $O(^DHCEPRI.EPRLogsI("IdxMain", " "_AEpisodeID, " "_APrintDocID, AEPRNum, ""))
	q eprLogsID
}

/// 获取最后一个做了指定操作的时间
ClassMethod GetOperTimeByAction(argEpisodeID As %String, argPrintDocID As %String, argEPRNum As %String, argAction As %String) As %String
{
	s operTime = ""
	s logs = ##class(EPRinstance.EPRLogs).GetCurrLog(argEpisodeID,argPrintDocID,argEPRNum)
	q:(logs="") ""
	
	s count=logs.Log.Count()
	q:(count=0) ""
	 
	for i=count:-1:1 
	{
		s log=logs.Log.GetAt(i)
		if log="" continue
		
		s action = log.Action
		if ($zcvt(argAction,"U")=$zcvt(action,"U"))
		{
			s operTime = $zd(log.OperateDate,3)_" "_$zt(log.OperateTime,1)
		    q
		}	
	}
 
	q operTime
}

/// 病历书写下方状态栏信息 返回的是HTML代码
/// {创建者 时间} | {病历状态} | {提交} {主治审核} {主任审核} | {医生签名状态} {患者签名状态}
ClassMethod GetStatusHtml(episodeID As %String, printTemplateDocId As %String, eprNum As %String) As %String
{
	s info = ""
  	s logID = ##class(EPRinstance.EPRLogs).GetLogID(episodeID, printTemplateDocId, eprNum)
  	
  	s objPrtDoc = ##class(EPRmeta.EPRTemplateCategory).%OpenId(printTemplateDocId)
  	s chapterDocID = objPrtDoc.ParentCategoryID
  	d objPrtDoc.%Close()
  	k objPrtDoc
  	
  	s objChapterDoc = ##class(EPRmeta.EPRTemplateCategory).%OpenId(chapterDocID)
  	s categoryNameServer = objChapterDoc.CategoryName
  	d objChapterDoc.%Close()
  	k objChapterDoc
  	  	
  	s eprLogs = ##class(EPRinstance.EPRLogs).%OpenId(logID)	
  	
    if (""=eprLogs)
  	{
	  	s info="<b>未完成</b>"
  	}
  	else
  	{  		
  		// 1.创建者 时间
  		s author=""
  		s author=eprLogs.CreateUserID
  		if (""'=author)
  		{
	  		s author=##class(EPRmeta.Privilege.PowerUser).GetUserName(author)
	  		s author=author_" "_$ZD(eprLogs.CreateDate, 3)_" "_$ZT(eprLogs.CreateTime, 1)
  		}
  		s info="<b>创建:</b> "_author
  		
 		// 2.病历状态
		s currState = ##class(EPRinstance.EPRLogs).GetEPRStatus(episodeID, printTemplateDocId, eprNum)
  		&sql(select StatusName into :currState from EPRmeta.EPRStatus where StatusCode = :currState)
  		s info=info_" | <b>"_currState_"</b>" 		
  		
  		// 3.{提交} {主治审核} {主任审核}
  		s checkInfo=""
  		s commit=##Class(EPRservice.BOEPRLogs).GetUserNameByAction(episodeID, printTemplateDocId, eprNum,"commit")
  		s:(""'=commit) checkInfo=checkInfo_" <b>提交:</b> "_commit
  		s attendingCheck=##Class(EPRservice.BOEPRLogs).GetUserNameByAction(episodeID, printTemplateDocId, eprNum,"attendingCheck")
  		s:(""'=attendingCheck) checkInfo=checkInfo_" <b>主治审核:</b> "_attendingCheck
  		s chiefCheck=##Class(EPRservice.BOEPRLogs).GetUserNameByAction(episodeID, printTemplateDocId, eprNum,"chiefCheck")
  		s:(""'=chiefCheck) checkInfo=checkInfo_" <b>主任审核:</b> "_chiefCheck
  		
  		s:(""'=checkInfo) info=info_" | "_checkInfo
  		// 4.医生签名状态
  		s info=info_" | <b>"_##Class(EPRservice.BLDigitalSignature).GetSignLog(episodeID, printTemplateDocId, eprNum)_"</b>"
	}
  	
  	q "&nbsp;"_info
}

/// Debug: w ##Class(EPRservice.BOEPRLogs).test(adm,docid,eprnum)
ClassMethod test(adm, docid, eprnum)
{
 Set rset = ##class(%ResultSet).%New("EPRservice.BOEPRLogs:GetAllLogInfo")
 Set columns = rset.GetColumnCount()
 Set sc = rset.Execute(adm,docid,eprnum)
 While (rset.Next()) {
 Write "------------------------",!
 	For col = 1:1:columns {
 	Write rset.GetColumnName(col),": "
 	Write rset.GetData(col),!
 }
 	Write "------------------------"
 }
 Do rset.Close()
}

}
