Class EMRservice.Ajax.auth.request Extends %CSP.Page
{

ClassMethod OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
	i ##Class(websys.SessionEvents).SessionExpired() q 1
	q 1
}

ClassMethod OnPage() As %Status
{
	s action = $g(%request.Data("Action",1),"")
	s episodeID = $Get(%request.Data("EpisodeID",1),"")
	s patientID = $Get(%request.Data("PatientID",1),"")
    
    s LOGONCTLOCID = $g(%session.Data("LOGON.CTLOCID"))
	s LOGONUSERID = $g(%session.Data("LOGON.USERID"))
	s LOGONGROUPID =$g(%session.Data("LOGON.GROUPID"))
		
	s pageSize = $g(%request.Data("rows",1),"")
	s pageNum = $g(%request.Data("page",1),"")
	s startRow = (pageNum -1)*pageSize + 1
	s endRow = startRow + pageSize -1

	if (action = "gettree")
	{
		//获取查询条件
		s condition = $g(%request.Data("Condition",1),"")
		//获取选中医生,根据被授权的医生能够看到的病历展现结构进行授权
		s selectedDocID = $Get(%request.Data("selectedDocID",1),"")
		s selecteddocCTLocID = $Get(%request.Data("selecteddocCTLocID",1),"")
		s selecteddocSSGroupID = $Get(%request.Data("selecteddocSSGroupID",1),"")
		//d ..GetEMRTree(episodeID,selecteddocCTLocID,selecteddocSSGroupID,LOGONUSERID)
		s ResultStream = ..GetEMRTree(episodeID,selecteddocCTLocID,selecteddocSSGroupID,LOGONUSERID,condition)
		//输出流数据
		while (ResultStream.AtEnd = 0)
		{
			w $ZSTRIP(ResultStream.Read(32000),"*C",,$c(1)_$c(2))
		}
	}
	elseif (action="request")
	{
		s requestCateCharpter = $g(%request.Data("RequestCateCharpter",1),"")
		s requestUserID = $g(%request.Data("RequestUserID",1),"")
		s requestDept = $g(%request.Data("RequestDept",1),"")	
		s EPRAction = $g(%request.Data("EPRAction",1),"")
		s requestReason = $g(%request.Data("RequestReason",1),"")
		s beforeRequestContent = $g(%request.Data("BeforeRequestContent",1),"")
		s afterRequestContent = $g(%request.Data("AfterRequestContent",1),"")
		s requestNumber = $g(%request.Data("RequestNumber",1),"")
		//w ..AddRequest(episodeID,requestCateCharpter,requestUserID,requestDept,EPRAction,requestReason,beforeRequestContent,afterRequestContent)
		w ..AddRequest(episodeID,requestCateCharpter,requestUserID,requestDept,EPRAction,requestReason,beforeRequestContent,afterRequestContent,patientID,LOGONCTLOCID,LOGONGROUPID,requestNumber)
	}
	ElseIf (action="getRequestPriv"){
		s episodeID = $Get(%request.Data("EpisodeID",1),"")
		s requestCateCharpter = $Get(%request.Data("RequestCateCharpter",1),"")
		w ..CanRequest(episodeID,requestCateCharpter)
	}
	Quit $$$OK
}

/// Description:新增申请
/// Table:EMRinstance.AuthRequest、EMRinstance.AuthAppoint、EMRinstance.AuthAppointDetail
/// Input:AEpisodeID-病人就诊号,ARequestCateCharpter-申请范围,ARequestUserID-申请人,
/// 	  ARequestDept-申请人科室,AEPRAction-申请权限类型,ARequestReason-申请原因,
///       ABeforeRequestContent-申请前计划修改的内容,AAfterRequestContent-申请后想要改成的内容,
/// Output:
/// Return:  AppointID:新增操作成功;  0:有的参数为空;  -1:新增未成功
/// Others:
/// Debug: w ##class(EMRservice.Ajax.AuthAppoint).AddRequest("220","877||13^935||2^935||3^68^1297||1^1301||1^1296||1","359","6","save,delete,print,view,new","123","aaa","bbb","240","6","134")
/// liuzhongwan 入参改名
ClassMethod AddRequest(AEpisodeID As %String, ARequestCateCharpter As %String, ARequestUserID As %String, ARequestDept As %String, AEPRActions As %String, ARequestReason As %String, ABeforeRequestContent As %String, AAfterRequestContent As %String, APatientID, AUserLocID, ASSGroupID, ARequestNumber As %String = "") As %String
{
	//s ^Tempncc("0") = AEpisodeID_"^"_ARequestCateCharpter_"^"_ARequestUserID_"^"_ARequestDept_"^"_AEPRActions_"^"_ARequestReason_"^"_ABeforeRequestContent_"^"_AAfterRequestContent_"^"_APatientID_"^"_AUserLocID_"^"_ASSGroupID
	s result = "0"
	q:(AEpisodeID = "")||(ARequestUserID = "")||(ARequestDept = "")||(ARequestCateCharpter = "")||(AEPRActions = "") result
	
	//取当前系统时间
	s date = $p($H,",",1)
	s time = $p($H,",",2)
	
	s flag = "0"
	TStart
	//对申请表插入数据
	s RequestObj = ##class(EMRinstance.AuthRequest).%New()
	if (RequestObj = "")
	{
		TRollback
		s flag = "-1"
		q flag
	}
	
	s RequestObj.EpisodeID = AEpisodeID
	s RequestObj.RequestUserID = ARequestUserID
	s RequestObj.RequestDept = ARequestDept
	s RequestObj.RequestDate = date
	s RequestObj.RequestTime = time
	s RequestObj.RequestReason = ARequestReason
	s RequestObj.BeforeRequestContent = ABeforeRequestContent
	s RequestObj.AfterRequestContent = AAfterRequestContent
	s RequestObj.RequestCateCharpter = ARequestCateCharpter
	s RequestObj.RequestAction = AEPRActions
	s RequestObj.RequestNumber = ARequestNumber
	
	s RequestSC = RequestObj.%Save()

	if ('$$$ISOK(RequestSC))
	{
		TRollback
		s flag = "-2"
		q flag
	}
	else
	{
		s RequestID = RequestObj.%Id()
	}

	//判断是否重复提交申请
	s HasAppointID = ""
	for {
		s HasAppointID = $O(^DHCEMRI.AuthAppointI("IdxStatusEpisode"," N"," "_AEpisodeID,HasAppointID))
		q:(HasAppointID = "")
		s HasAppointobj = ##class(EMRinstance.AuthAppoint).%OpenId(HasAppointID)
		continue:(HasAppointobj = "")
		s HasAppointCharpter = HasAppointobj.RequestCateCharpter
		s HasAppointUserID = HasAppointobj.RequestUserID
		s HasAppointAction = HasAppointobj.RequestAction
		if ((HasAppointCharpter=ARequestCateCharpter)&&(HasAppointUserID=ARequestUserID)&&(AEPRActions=HasAppointAction)) 
		{
			s flag = "-7"
			q
		}
	}
	if (flag = "-7")
	{
		TRollback
		s result = "-2"
		q result
	}
	
	s PAAdmType = $p($g(^PAADM(AEpisodeID)),"^",2)
	//"Y#1^2^3&4^5^6&7^8^9"
	s multilevelAppoint = "N#"
	s multilevelAppoint = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("AuthMultilevelAppoint","N")
	s IsMultilevelAppoint = $p(multilevelAppoint,"#",1)
	//开启了三级授权
	s ^tempncc("004") = IsMultilevelAppoint
	if (IsMultilevelAppoint = "Y")
	{
		s ^tempncc("005") = IsMultilevelAppoint
		s LevelGroups1 = $p($p(multilevelAppoint,"#",2),"&",1)
		s LevelGroups2 = $p($p(multilevelAppoint,"#",2),"&",2)
		s LevelGroups3 = $p($p(multilevelAppoint,"#",2),"&",3)
		
		s AppointObj = ##class(EMRinstance.AuthAppoint).%New()
		if (AppointObj = "")
		{
			s flag = "-3"
			q 
		}
		s AppointObj.RequestID = RequestID
		s AppointObj.EpisodeID = AEpisodeID
		s AppointObj.RequestUserID = ARequestUserID
		s AppointObj.RequestDept = ARequestDept
		s AppointObj.RequestDate = date
		s AppointObj.RequestTime = time
		s AppointObj.RequestCateCharpter = ARequestCateCharpter
		s AppointObj.RequestAction = AEPRActions
		s AppointObj.AppointStatus = "N"
		s AppointObj.AppointStatus1 = "N"
		s AppointObj.AppointStatus2 = "N"
		s AppointObj.AppointStatus3 = "N"
		//s AppointObj.AuthLevel = level

		s AppointSC = AppointObj.%Save()
		if ('$$$ISOK(AppointSC))
		{
			s flag = "-4"
			q 
		}
		else
		{
			s AppointID = AppointObj.%Id()
			s result = AppointID
		}
		//对授权明细表插入数据
		s currLevelCharpterCount = $l(ARequestCateCharpter, "^")
		for j = 1:1:currLevelCharpterCount
		{
			s curActions = AEPRActions
			s newflag = 0
			s currLevelCharpter = $p(ARequestCateCharpter,"^",j)
			//对模板的处理
				if '(currLevelCharpter [ "||")
			{
				continue:('(curActions [ "new"))
				if ('(curActions [ "save"))
				{
					s curActions = curActions_",save"
				}
				s newflag = 1
			}
			
			s ActionCount = $l(curActions, ",")
			for k = 1:1:ActionCount
			{
				s action = $p(curActions,",",k)
				continue:(newflag = 0)&&(action = "new") //过滤掉对实例病历的“创建”权限的申请
				
				s DetailObj = ##class(EMRinstance.AuthAppointDetail).%New()
				if (DetailObj = "")
				{
					s flag = "-5"
					q 
				}
				
				s DetailObj.AppointID = AppointID
				s DetailObj.EpisodeID = AEpisodeID
				s DetailObj.CateCharpter = currLevelCharpter
				s DetailObj.Action = action
				s DetailObj.DetailStatus = "0"
				s DetailObj.Modify = "0"
				
				s DetailSC = DetailObj.%Save()
				if ('$$$ISOK(DetailSC))
				{
					s flag = "-6"
					q 
				}
			}
		}
	}
	else
	{
		//对授权表插入数据 -- 未开启三级授权
	s splitChapter = ..SplitRequestChapter(APatientID, AEpisodeID, ARequestCateCharpter, ARequestUserID, AUserLocID, ASSGroupID)
	for i = 1:1:4
	{
		s chapter = $P(splitChapter, "#", i)
		s level = (i * 100)
		continue:(chapter = "")
		
		s AppointObj = ##class(EMRinstance.AuthAppoint).%New()
		if (AppointObj = "")
		{
			s flag = "-3"
			q 
		}
		s AppointObj.RequestID = RequestID
		s AppointObj.EpisodeID = AEpisodeID
		s AppointObj.RequestUserID = ARequestUserID
		s AppointObj.RequestDept = ARequestDept
		s AppointObj.RequestDate = date
		s AppointObj.RequestTime = time
		s AppointObj.RequestCateCharpter = chapter
		s AppointObj.RequestAction = AEPRActions
		s AppointObj.AppointStatus = "N"
		s AppointObj.AuthLevel = level

		s AppointSC = AppointObj.%Save()
		if ('$$$ISOK(AppointSC))
		{
			s flag = "-4"
			q 
		}
		else
		{
			s AppointID = AppointObj.%Id()
			s result = AppointID
		}
		//对授权明细表插入数据
			s currLevelCharpterCount = $l(chapter, "^")
			for j = 1:1:currLevelCharpterCount
			{
			s curActions = AEPRActions
			s newflag = 0
				s currLevelCharpter = $p(chapter,"^",j)
			//对模板的处理
				if '(currLevelCharpter [ "||")
			{
				continue:('(curActions [ "new"))
				if ('(curActions [ "save"))
				{
					s curActions = curActions_",save"
				}
				s newflag = 1
			}
			
			s ActionCount = $l(curActions, ",")
				for k = 1:1:ActionCount
				{
				s action = $p(curActions,",",k)
				continue:(newflag = 0)&&(action = "new") //过滤掉对实例病历的“创建”权限的申请
				
				s DetailObj = ##class(EMRinstance.AuthAppointDetail).%New()
				if (DetailObj = "")
				{
					s flag = "-5"
					q 
				}
				
				s DetailObj.AppointID = AppointID
				s DetailObj.EpisodeID = AEpisodeID
					s DetailObj.CateCharpter = currLevelCharpter
				s DetailObj.Action = action
				s DetailObj.DetailStatus = "0"
				s DetailObj.Modify = "0"
				
				s DetailSC = DetailObj.%Save()
				if ('$$$ISOK(DetailSC))
				{
					s flag = "-6"
					q 
					}
				}
			}
		}
	}
	if (flag < 0)
	{
		TRollback
		s result = "-1"
		q result
	}
	
	TCommit
	s MessageBody = "病历操作权限的申请！"
	s toLocRowIds = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("RequestSendMessageLocID","")
	if (toLocRowIds'="")
	{
		d ##class(websys.DHCMessageInterface).Send(MessageBody,"1043",ARequestUserID,AEpisodeID,"","","",toLocRowIds,"","")
	} 
	q result
}

/// Debug:	w ##Class(web.eprajax.EPRAction).SplitRequestChapter("5","42","104","105","6","100")
ClassMethod SplitRequestChapter(APatientID, AEpisodeID, ARequestChapterList, AUserID, AUserLocID, ASSGroupID) As %String
{
	q:(ARequestChapterList = "") "###"
	
	//100 患者主管医师审核级别，200 科主任审核级别，300 病案室审核级别
	s level100 = "", level200 = "", level300 = "",level400 =""
	
	s count = $L(ARequestChapterList,"^")
	for i = 1:1:count
	{
		s Chapter = $P(ARequestChapterList,"^",i)
		continue:(Chapter = "")
		
		//使用权限判断申请级别
		//二版
  		//s privPara = "userid^"_AUserID_"!admid^"_AEpisodeID_"!patientid^"_APatientID_"!userloc^"_AUserLocID_"!templateid^0!ssgroupid^"_ASSGroupID_"!categoryid^0!docid^"_eprDocID_"!isnewframework^1!eprnum^0"
   		//三版
   		s InstanceID = ""
   		s DocID = ""
   		if (Chapter [ "||")
   		{
	   		s InstanceID = Chapter
	   	}
	   	else
	   	{
		   	s DocID = Chapter
		}
   		s privPara = "userid^"_AUserID_"!userloc^"_AUserLocID_"!ssgroupid^"_ASSGroupID_"!admid^"_AEpisodeID_"!patientid^"_APatientID_"!instanceid^"_InstanceID_"!docid^"_DocID
   		//s privString = "userid^"_AUserId_"!userloc^"_AUserLoc_"!ssgroupid^"_AssgroupId_"!admid^"_AadmId_"!patientid^"_APatientId_"!instanceid^"_AInstanceId
   		
   		s privArr = ##Class(EMRservice.BOPrivRule).GetAuthLevelPriv(privPara)
 		s authLevel = privArr.GetAt("authlevel")
 		
 		if (authLevel < 101)
 		{	
 			//患者主管医师审核级别
 			//s authLevel = "100"
 			if (level100 = "")
 			{	s level100 = Chapter}
 			else
 			{	s level100 = level100_"^"_Chapter}
 		}	
 		elseif (authLevel < 201)	
 		{	
 			//患者所在科室科主任审核级别
 			//s authLevel = "200"
 			if (level200 = "")
 			{	s level200 = Chapter}
 			else
 			{	s level200 = level200_"^"_Chapter}
 		}
 		elseif(authLevel<301)
 		{
	 		//医务科审核级别
 			//s authLevel = "300"
	 		if (level300 = "")
	 		{s level300=Chapter}
	 		else
 			{	s level300 = level300_"^"_Chapter}
	 		}	
 		else
 		{	
 			//病案室审核级别
 			//s authLevel = "400"
 			if (level400 = "")
 			{	s level400 = Chapter}
 			else
 			{	s level400 = level400_"^"_Chapter}
 		}
	}
	
	q level100_"#"_level200_"#"_level300_"#"_level400
}

/// Debug:	d ##Class(EMRservice.Ajax.auth.request).GetEMRTree("190","277","29","17828")
ClassMethod GetEMRTree(AEpisodeID, AUserLoc, AGroupID, AUserID, ACondition As %String = "") As %GlobalCharacterStream
{
	s ResultStream = ##Class(%GlobalCharacterStream).%New()
	s AStauts = "SAVE"
	//insert into EPRmeta.SysOption (Description,IsVisible,Name,OptionValue) Values ("授权|直接授权时默认不勾选的模板CategoryChapterID集合，以^分隔","Y","DirectCategoryChapterIDS","101^102")
	//由于EMRservice.BL.BLClientCategory.cls中改变了GetCategory这个Query，所以跟随改变，获取病历树
	/*
	s disDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(AEpisodeID)
	s schemType = $case(disDateTime,"":"Running",:"Archiving")
	q:(schemType = "") ""
	*/
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	d ResultStream.Write("[{")
	d ResultStream.Write("""id"":""RT00"",")
	//w """type"":""RT"","
	s rangeDesc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","授权范围")
	d ResultStream.Write("""text"":"""_rangeDesc_""",")
	d ResultStream.Write("""attributes"":{")
	d ResultStream.Write("""type"":""RT""},")
	d ResultStream.Write("""children"":")
	d ResultStream.Write("[")    //RT-children
	//已写病历start
	d ResultStream.Write("{")
	d ResultStream.Write(..TrimEnter("""id"":""INS"","))
	d ResultStream.Write("""attributes"":{")
	d ResultStream.Write(..TrimEnter("""type"":""zdy""},"))
	d ResultStream.Write(..TrimEnter("""state"":""open"","))
	s hasEmr = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","已写病历")
	d ResultStream.Write(..TrimEnter("""text"":"""_hasEmr_""","))
	d ResultStream.Write("""children"":")
	
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLClientCategory:GetCategory")
	d result.Execute(AUserLoc,AGroupID,AEpisodeID)
	
	//第一次只查找实例病历
	s InsFlag = 0
	d ResultStream.Write("[")
	while result.%Next()
	{
		s curCategoryId = result.Data("ItemCategoryID")
		s InsJson = ##Class(%GlobalCharacterStream).%New()
		s docIds = ..GetDocIdsByParent(curCategoryId)
		s length = $l(docIds,",")
		for I=1:1:length
		{
			s docId = $p(docIds,",",I)
			//判断是否有实例
			s hasIns = ##class(EMRservice.BL.BLInstanceData).IsHasInstance(AEpisodeID,"",docId)
			continue:(hasIns = "0")
			s InstanceJson = ..DoInstanceJsonByDocID(docId,AEpisodeID,"SAVE",ACondition)
			continue:(InstanceJson.Size <= 0)
			//s:(InsJson '= "") InsJson = InsJson_","
			d:(InsJson.Size > 0) InsJson.Write(",")
			//s InsJson = InsJson_InstanceJson
			d InsJson.CopyFrom(InstanceJson)
		}
		continue:(InsJson.Size <= 0)
		//w:(InsFlag = 1)&&(InsJson '= "") ","
		d:(InsFlag = 1)&&(InsJson '= "") ResultStream.Write(",")
		//w ..TrimEnter(InsJson)
		d ResultStream.CopyFrom(InsJson)
		s InsFlag = 1
	}
	d ResultStream.Write("]")
	d ResultStream.Write("},")
	//已写病历end
	//空模板start
	s templateName = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","模板")
	d ResultStream.Write("{")
	d ResultStream.Write(..TrimEnter("""id"":""TEMP"","))
	d ResultStream.Write("""attributes"":{")
	d ResultStream.Write(..TrimEnter("""class"":""M"","))
	d ResultStream.Write(..TrimEnter("""type"":""zdy""},"))
	d ResultStream.Write(..TrimEnter("""state"":""open"","))
	d ResultStream.Write(..TrimEnter("""text"":"""_templateName_""","))
	d ResultStream.Write("""children"":")
	//第二次只查找空模板，并且Category默认不展开
	s parentId = " 0"
	s curCategoryId = ""
	s hasWrite = 0
	d ResultStream.Write("[")
	
	
	
	
	
	s TempResult = ##class(%ResultSet).%New("EMRservice.BL.BLClientCategory:GetCategory")
	d TempResult.Execute(AUserLoc,AGroupID,AEpisodeID)
	while TempResult.%Next()
	{
		if (hasWrite = 1) d ResultStream.Write(",")
		s curCategoryId = TempResult.Data("ItemCategoryID")
		continue:(curCategoryId = "11")
		s hasWrite = 0
		s tempString = "{""id"":"""_curCategoryId_""","_"""attributes"":{""class"":""M"",""type"":""cg""},""state"":""closed"","_..TrimEnter("""text"":"""_TempResult.Data("ItemTitle")_""",")_"""children"":["
		
		s MutexFlg = 0
		s json = ##Class(%GlobalCharacterStream).%New()
		s docIds = ..GetDocIdsByParent(curCategoryId)
		s length = $l(docIds,",")
		for I=1:1:length
		{
			s docId = $p(docIds,",",I)
			s curPatInfo = ##class(EMRservice.DocRestLogic.PrivLogic).GetPatInfo(AEpisodeID,AUserID)
			s checkpriv = ##Class(EMRservice.DocRestLogic.TempActLogic).CanTempAct(docId, "READ", curPatInfo)
			s checkInstance = ##Class(EMRservice.BL.BLInstanceData).IsHasInstance(AEpisodeID, "", docId)
			continue:(checkpriv = 0)&&(checkInstance = 0)
			s docObj = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
			s parentId = docObj.ParentCategoryID
			s parentObj = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(parentId)
			s parentMutex = parentObj.IsMutex
			continue:(MutexFlg = 1)&&(parentMutex = 1)
			//s checkInstance = ##Class(EMRservice.BL.BLInstanceData).IsHasInstance(AEpisodeID, "", docId)
			s:(parentMutex=1)&&(checkInstance'=0) MutexFlg = 1
			//liuzhongwan 16/03/09
			//s docJson = ..DoInstanceJsonByDocID(docId,AEpisodeID,"Save")
			s docJson = ..GetTempJsonByID(docId,ACondition)
			//s:(json '= "")&&(docJson '= "") json = json_","
			d:(json.Size > 0)&&(docJson.Size > 0) json.Write(",")
			//s json = json_docJson
			d json.CopyFrom(docJson)
		}
		if (json.Size > 0)
		{
			d ResultStream.Write(tempString)
			d ResultStream.CopyFrom(json)
			
			d ResultStream.Write("]")
			d ResultStream.Write("}")
		
			s hasWrite = 1
		}
		
		
		
	}
	
	
	
	
	
	
	d ResultStream.Write("]")
	d ResultStream.Write("}")
	
	//空模板end
	d ResultStream.Write("]")   //RT-children
	d ResultStream.Write("}]") //root
	
	q ResultStream
}

/// Creator:duan
/// CreatDate:2018-10-08
/// Description:是否可以申请对应就诊号的病历
/// 已经打印的病历
/// Return:0-申请无限制,非0-申请限制
/// w ##Class(EMRservice.Ajax.auth.request).CanRequest("4","56||9")
ClassMethod CanRequest(AEpisodeID As %String, ArequestCateCharpter As %String)
{
	s text = ""
	s unPrintText = ""
	s requestCateCharpter = ArequestCateCharpter
	/*通过脚本取值
	s privPara = "admid^"_AEpisodeID
	s privArr = ##Class(EMRservice.BOPrivRule).GetRequestPriv(privPara)
	*/
	s flag = ##class(EMRservice.SystemParameter).hasPrint()
	if (flag = "N"){
		s text = 0
	}else{
		s printPriv = ##class(DHCEPRFS.BL.BLMRLog).IsPrinted(AEpisodeID)
		q:(printPriv="") text=0
		if (printPriv = 1){
			s text = "无纸化病案已生成，是否申请？"	
		}else{
			q:(requestCateCharpter = "") text = 0
			for i=1:1:$l(requestCateCharpter,"^")
			{
				s instanceId = $p(requestCateCharpter,"^",i)
				continue:(instanceId = "")
				continue:(instanceId["||" = 0)
				s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(instanceId)
				s logID = ##Class(EMRservice.BL.BLEMRLogs).GetLogID(AEpisodeID,objInstance.TheECRecord.RealChartItemID,objInstance.ListNo)
				continue:(logID = "")
				s lastInstanceLog = ##Class(EMRservice.BL.BLEMRLogs).GetFinalLog(logID)
				if (lastInstanceLog.Action = "print")
				{
					s text = text_##class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.Titles","Description","病历")
					s text = text_" "_##class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.Titles","Description",objInstance.Title)
					s text = text_" "_##class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.Titles","Description","已打印，是否申请")
					s text = text_"?  "
				}				
				else
				{
					s unPrintText = unPrintText_##class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.Titles","Description","病历")
					s unPrintText = unPrintText_" "_##class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.Titles","Description",objInstance.Title)
					s unPrintText = unPrintText_" "_##class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.Titles","Description","未打印")
					s unPrintText = unPrintText_", "
				}
			}
		}
	}
	s:(text="") text = 0
	if ($l(text)>400) s text = "除"_unPrintText_"均已打印!是否申请?"
	q text
}

/// Desc:		根据docID是否有实例以及是否Single判断是获取实例的json还是模板的json
/// Modify:     LIUZHONGWAN
/// DateTime:   2016-03-09
/// Input:		DocId和就诊Id
/// Output:		这一DocId下的所有json串
/// Debug	w ##Class(EMRservice.Ajax.AuthDirectAppoint).GetDocJsonsById(884,456449)
ClassMethod GetDocJsonsById(ADocId As %String, AEpisodeId As %String) As %String
{
	s json = ""
	q:((ADocId = "")||(AEpisodeId = "")||(ADocId=11)||(ADocId=10)) json
	s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(ADocId)
	q:(objTemplate = "") json
	s Sflag = ""
	s result = ##class(EMRservice.BL.BLInstanceData).IsHasInstance(AEpisodeId,"",ADocId)
	//第一层判断：是否有实例
	q:(result = "0") ..GetTempJsonByID(ADocId)
	s tempjson = ..DoInstanceJsonByDocID(ADocId,AEpisodeId,"SAVE")
	q:(tempjson = "") json
	s json = json_tempjson
	s:(objTemplate.ChartItemType = "Single") Sflag = 1
	//第二层判断：是否SINGLE
	if ('Sflag = 1)
	{
		s tempjson = ..GetTempJsonByID(ADocId)
		q:(tempjson = "") json
		q:(Sflag = 1) //tempJson = $p(tempJson,",",1,5)_","_$p(tempJson,",",7)
		s json = json_","_tempjson
	}
	q json
}

/// Desc: 取模板数据JSon
/// Modify:     LIUZHONGWAN
/// DateTime:   2016-02-22
/// Input:     ADocID 空模板的DocID，TempCate类型的
/// Output:    模板的信息JSon串
/// Debug:     w ##Class(EMRservice.Ajax.AuthDirectAppoint).GetTempJsonByID(51)
ClassMethod GetTempJsonByID(ADocID As %String, ACondition As %String = "") As %GlobalCharacterStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	q:(ADocID = "") json
	s objTemplate = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(ADocID)
	q:(objTemplate = "") json
	s rowId = ADocID
	s parentId = objTemplate.ParentCategoryID
	s objparentTemplate = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(parentId)
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	s text = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.EMRTemplateCategory","CategoryName",objTemplate.CategoryName,langid)

	if (ACondition '="")
	{
		//前端获取到的输入信息(首拼)
		s inFirstMessage = ##class(web.DHCINSUPort).GetCNCODE(ACondition,4,"")
		s outFirstMessage = ##class(web.DHCINSUPort).GetCNCODE(..TrimEnter(text),4,"")
		q:(outFirstMessage '[ inFirstMessage) json
		//前端获取到的输入信息(全拼)
		s inWholeMessage = ##class(web.DHCINSUPort).GetCNCODE(ACondition,3,"")
		s outWholeMessage = ##class(web.DHCINSUPort).GetCNCODE(..TrimEnter(text),3,"")
		q:(outWholeMessage '[ inWholeMessage) json
	}
	d json.Write("{")
	d json.Write("""id"":"""_rowId_"""")
	d json.Write(",""attributes"":{" )
	d json.Write("""type"":""ct""")
	d json.Write("}")
	//d json.Write(",""checked"":""false""")
	d json.Write(",""text"":"""_..TrimEnter(text)_"""")
	d json.Write("}")

	q json
}

/// Desc:       根据目录展现结构取DocID
/// Input:      AParentId 目录展现结构ID,取所有的为0
///             AEpisodeId 就诊ID
/// OutPut:     以","分隔的DOCID集合         
/// Debug       w ##Class(EMRservice.Ajax.Appoint).GetDocIdsByParent(3)
ClassMethod GetDocIdsByParent(AParentId As %String) As %String
{
	s docIds = ""
	q:(AParentId = "") docIds
	s seq = ""
	for
	{
		s seq = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_AParentId,seq))
		q:(seq = "")
		s curCategoryId	= ""
		for
		{
			s curCategoryId = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_AParentId,seq,curCategoryId))
			q:(curCategoryId = "")
			s objCatergory = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(curCategoryId)
			continue:(objCatergory = "")
			s result = curCategoryId
			if (objCatergory.CategoryType '= "TempCate")
			{
				s result = ..GetDocIdsByParent(curCategoryId)
				q:(result = "")
			}
			s:(docIds '= "") docIds = docIds_","
            s docIds = docIds_result
		}
	}
	q docIds
}

/// Desc:		根据DocId取实例
/// Input: 		AParentId 目录categoryID
/// 			AEpisodeId 就诊号
/// 			AUniqueKey 唯一标示
/// 			OutPut result 1成功，0错误
/// Debug：     w ##Class(EMRservice.Ajax.AuthDirectAppoint).DoInstanceJsonByDocID(100,43,"Save")
ClassMethod DoInstanceJsonByDocID(ADocId As %String, AEpisodeId As %String, AStauts As %String, ACondition As %String = "") As %GlobalCharacterStream
{
	s $zt = "Error"
	s json = ##Class(%GlobalCharacterStream).%New()
	s count = 0
	
	q:(ADocId = "")||(AEpisodeId = "")||(AStauts = "") json
	s docId = ADocId
	s ecrecordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeId,docId,""))
	
	q:(ecrecordId = "") json
	s objEcrecod =  ##Class(EMRinstance.ECRecord).%OpenId(ecrecordId)
	q:(objEcrecod = "") json
	s docId = objEcrecod.RealChartItemID
	s chartItemType = objEcrecod.ChartItemType
	s documentType = objEcrecod.DocumentType
	s objEmrTemplateCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
	q:(objEmrTemplateCategoryDoc = "") json
	s isLeadframe = objEmrTemplateCategoryDoc.IsLeadframe
	s objEmrTemplateCategoryChapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objEmrTemplateCategoryDoc.ParentCategoryID)
	q:(objEmrTemplateCategoryChapter = "") json
	s isMutex = objEmrTemplateCategoryChapter.IsMutex
	
	s date = ""
	for
	{
		s date = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordId," "_$zcvt(AStauts,"U"),date))
		q:(date = "")
		s time = ""
		for
		{
			s time = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordId," "_$zcvt(AStauts,"U"),date,time))	
			q:(time = "")
			s subId = ""
			for
			{
				s subId = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordId," "_$zcvt(AStauts,"U"),date,time,subId))			
				q:(subId = "")
 				s tempJson = ..GetInstanceJsonByID(ecrecordId,subId,ACondition)
 				continue:(tempJson.Size <= 0)
 				//s:(count '= 0) json = json_","
 				d:(count '= 0) json.Write(",")
				//s json = json_tempJson
				d json.CopyFrom(tempJson)
				s count = count + 1			
			}
		}
	}
	//s json = $ZSTRIP(json,"*C")
	q json
Error
	q ##Class(%GlobalCharacterStream).%New()
}

/// Desc: 取实例数据JSon
/// Input:     AEcrecordID EMRinstance.ECRecord的ID
///            ASubID EMRinstance.InstanceData的subId
/// Debug:     w ##Class(EMRservice.Ajax.Appoint).GetInstanceJsonByID(1,1)
ClassMethod GetInstanceJsonByID(AEcrecordID As %String, ASubID As %String, ACondition As %String = "") As %GlobalCharacterStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	q:((AEcrecordID = "")||(ASubID = "")) json
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	s rowId = AEcrecordID_"||"_ASubID
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(rowId)
	q:(objInstance = "") json
	s objRecord = ##Class(EMRinstance.ECRecord).%OpenId(AEcrecordID)
	q:(objRecord = "") json
	s epsiodeId = objRecord.RealEpisodeID
	s docId = objRecord.RealChartItemID
	s num = objInstance.ListNo
	s objCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
	q:(objCategoryDoc = "") json
	s objChapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objCategoryDoc.ParentCategoryID)
	q:(objChapter = "") json
	s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(docId)
	s chartItemType = objTemplate.ChartItemType
	s documentType = objTemplate.DocumentType
	s categoryId = objChapter.ParentCategoryID
	s isLeadframe = objCategoryDoc.IsLeadframe
	s isMutex = objChapter.IsMutex
	s happendate = $zd(objInstance.HappenDate,3)
	s happentime = $zt(objInstance.HappenTime)
	s title = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRinstance.InstanceData","Title",objInstance.Title,langid)
	s tmeplateId = objInstance.RealTemplateID
	s createdate = $zd(objInstance.CreateDate,3)
    s createdate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",createdate)
	s createtime = $zt(objInstance.CreateTime)
    s createtime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",createtime)
	s createuserID = objInstance.CreateUser
	s createuserCode = $p($g(^SSU("SSUSR",createuserID)),"^",14)
	s createuserName=$p($g(^CTPCP(createuserCode,1)),"^",2)
	s createuserName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("User.SSUser","SSUSRName",createuserName,langid)
	//重构所有模板的显示text，以防丢失Title或者用以区分不同的日常病程记录等；
	s text = title_" "_createdate_" "_createtime_" "_createuserName
	
	s checkedFlag = "true"
	s IsSealed = "N"
	if (##class(%Dictionary.CompiledMethod).%ExistsId("DHCWMR.MO.SealRecordEpr||CheckByAdmInstance") = 1)
	{
		s Sealed = ##class(DHCWMR.MO.SealRecordEpr).CheckByAdmInstance(epsiodeId,rowId)
		if (Sealed = 1)
		{
			s text = title_" "_createdate_" "_createtime_" "_createuserName_"<span style='color:red;font-weight:bold;'> 已封存</span>"
			s IsSealed = "Y"
			s checkedFlag = "false"
		}
	}
	if (ACondition '="")
	{
		//前端获取到的输入信息(首拼)
		s inFirstMessage = ##class(web.DHCINSUPort).GetCNCODE(ACondition,4,"")
		s outFirstMessage = ##class(web.DHCINSUPort).GetCNCODE(..TrimEnter(title),4,"")
		q:(outFirstMessage '[ inFirstMessage) json
		//前端获取到的输入信息(全拼)
		s inWholeMessage = ##class(web.DHCINSUPort).GetCNCODE(ACondition,3,"")
		s outWholeMessage = ##class(web.DHCINSUPort).GetCNCODE(..TrimEnter(title),3,"")
		q:(outWholeMessage '[ inWholeMessage) json
	}
	d json.Write("{")
	d json.Write("""id"":"""_rowId_"""")
	d json.Write(",""attributes"":{")
	d json.Write("""type"":""cc""")
	d json.Write("}")
	d json.Write(",""IsSealed"":"""_IsSealed_"""")
	d json.Write(",""checked"":"""_checkedFlag_"""")
	//d json.Write(",""checked"":""true""")
	d json.Write(",""text"":"""_..TrimEnter(text)_"""")
	d json.Write("}")	
	
	q json
}

ClassMethod TrimEnter(AInput As %String) As %String
{
	s ret = $TR(AInput,$C(13),"")
	s ret = $TR(ret,$C(10),"")
	s ret = $TR(ret,$C(0),"")
	
	//替换双引号
	for {
		s count = $f(ret,"“")
		if (count > 0)
		{
			s ret = $e(ret,1,count-2)_""_$e(ret,count,$l(ret))	
		}
		else
		{
			q
		}	
	}
	for {
		s count = $f(ret,"”")
		if (count > 0)
		{
			s ret = $e(ret,1,count-2)_""_$e(ret,count,$l(ret))	
		}
		else
		{
			q
		}	
	}
	//替换单引号
	for {
		s count = $f(ret,"'")
		if (count > 0)
		{
			s ret = $e(ret,1,count-2)_"@@@"_$e(ret,count,$l(ret))	
		}
		else
		{
			q
		}	
	}
	
	//替换斜杠
	for {
		s count = $f(ret,"\")
		if (count > 0)
		{
			s ret = $e(ret,1,count-2)_"xiegangxiegang"_$e(ret,count,$l(ret))	
		}
		else
		{
			q
		}	
	}
	q ret
}

/// Debug:	d ##Class(EMRservice.Ajax.AuthDirectAppoint).GetDocListJSON("李红英^^^","1","20")
ClassMethod GetDocListJSON(AParam As %String, AIdxStart As %Integer, AIdxLast As %Integer)
{
 	s AUserName = $p(AParam,"^",1)
	s AUserCode = $p(AParam,"^",2)
	s AGroupID = $p(AParam,"^",3)
    s ACTLocID = $p(AParam,"^",4)
	
	s result = ##Class(%ResultSet).%New("EMRservice.Ajax.AuthDirectAppoint:GetUser")
	s sc = result.Execute(AUserName, AUserCode, AGroupID, ACTLocID)
	
 	s count = 0
 	s first = 1
 	w "{""rows"":["
 	
	While (result.Next())
 	{
	 	s count = count + 1		
	 	if ( count >= AIdxStart) && (count <= AIdxLast)
		{
		 	if ((count > 1)&&(first '= 1)) w ","
			w "{"
			w ..TrimEnter("""SSUserID"":"""_$g(result.Data("SSUserID"))_""",")
			w ..TrimEnter("""UserName"":"""_$g(result.Data("UserName"))_""",")
			w ..TrimEnter("""UserCode"":"""_$g(result.Data("UserCode"))_""",")
			w ..TrimEnter("""CTLocID"":"""_$g(result.Data("CTLocID"))_""",")			
			w ..TrimEnter("""SSGroupID"":"""_$g(result.Data("SSGroupID"))_""",")
			w ..TrimEnter("""CTLoc"":"""_$g(result.Data("CTLoc"))_""",")
			w ..TrimEnter("""SSGroup"":"""_$g(result.Data("SSGroup"))_"""")
			w "}"
			s first = 0
		}
	}
	w "],""total"":"_count_"}"
}

}
