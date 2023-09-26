Class EMRservice.Ajax.AuthDirectAppoint Extends %CSP.Page
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
	s regNo = $Get(%request.Data("RegNo",1),"")
	s patientName = $Get(%request.Data("PatientName",1),"")
	s patientLocID = $Get(%request.Data("PatientLocID",1),"")
    s patientWardID = $Get(%request.Data("PatientWardID",1),"")
    s MedicareNo = $g(%request.Data("MedicareNo",1),"")
    s onlyCurrentDept = $g(%request.Data("onlyCurrentDept",1),"")
    
    s LOGONCTLOCID = $g(%session.Data("LOGON.CTLOCID"))
	s LOGONUSERID = $g(%session.Data("LOGON.USERID"))
	s LOGONGROUPID =$g(%session.Data("LOGON.GROUPID"))
	s LOGONHOSPID =$g(%session.Data("LOGON.HOSPID"))
    
    s userID = $Get(%request.Data("UserID",1),"")
    s userName = $Get(%request.Data("DocUserName",1),"")
    s userCode = $Get(%request.Data("DocUserCode",1),"")
    s groupID = $Get(%request.Data("DocSSGroupID",1),"")
    s ctLocID = $Get(%request.Data("DocLocID",1),"")
    
    s appointSpan = $Get(%request.Data("AppointSpan",1),"")
    s appointCateCharpter = $Get(%request.Data("AppointCateCharpter",1),"")
    s appointUserID = $Get(%request.Data("AppointUserID",1),"")
    s eprActions = $Get(%request.Data("EPRAcitons",1),"")
    s appointIDs = $Get(%request.Data("AppointIDs",1),"")
    s isValid = $Get(%request.Data("IsValid",1),"")
		
	s pageSize = $g(%request.Data("rows",1),"")
	s pageNum = $g(%request.Data("page",1),"")
	s startRow = (pageNum -1)*pageSize + 1
	s endRow = startRow + pageSize -1
	
	s filter = $g(%request.Data("Filter",1),"")
	s dicCode = $g(%request.Data("DicCode",1),"")
	
	s param = patientID_"^"_patientName_"^"_patientLocID_"^"_patientWardID_"^"_episodeID_"^"_regNo_"^"_MedicareNo_"^"_LOGONCTLOCID_"^"_LOGONUSERID_"^"_onlyCurrentDept
	s paramDoc = userName_"^"_userCode_"^"_groupID_"^"_ctLocID_"^"_LOGONHOSPID
	
	//s ^CacheTemp("debug","input","111") = pageSize_"^"_pageNum_"^"_filter
    
	if (action = "gettree")
	{	
		//获取查询条件
		s condition = $g(%request.Data("Condition",1),"")
		//获取选中医生,根据被授权的医生能够看到的病历展现结构进行授权
		s selectedDocID = $Get(%request.Data("selectedDocID",1),"")
		s selecteddocCTLocID = $Get(%request.Data("selecteddocCTLocID",1),"")
		s selecteddocSSGroupID = $Get(%request.Data("selecteddocSSGroupID",1),"")
		s ResultStream = ..GetEMRTree(episodeID,selecteddocCTLocID,selecteddocSSGroupID,LOGONUSERID,condition)
		//输出流数据
		while (ResultStream.AtEnd = 0)
		{
			w $ZSTRIP(ResultStream.Read(32000),"*C",,$c(1)_$c(2))
		}
	}
	elseif (action = "doclist")
	{
		d ..GetDocListJSON(paramDoc,startRow,endRow)
	}
	elseif (action = "givepower")
	{
		w ..GivePower(appointSpan,appointCateCharpter,appointUserID,eprActions,userID,ctLocID,episodeID)	
	}
	elseif (action = "history")
	{
		s ResultStream = ..GetHistoryJSON(LOGONCTLOCID,LOGONGROUPID,"","",isValid,startRow, endRow,LOGONHOSPID,LOGONUSERID)
		//输出流数据
		while (ResultStream.AtEnd = 0)
		{
			w $ZSTRIP(ResultStream.Read(32000),"*C",,$c(1)_$c(2))
		}
	}
	elseif (action = "withdraw")
	{
		w ..Withdraw(appointIDs)	
	}
	//liuzhongwan 实例继承模板的权限
	elseif (action = "inherit")
	{
		//增加入参DocID,LOGONUSERID,LOGONCTLOCID
		d ..InherTempPriv("",appointCateCharpter,episodeID,LOGONUSERID,LOGONCTLOCID)
	}
	//end liuzhongwan
	elseif (action = "ssgroup")
	{
		d ..GetSSGroup(filter,startRow,endRow)
	}
	elseif (action = "getdiclist")
	{
		//d ..GetDicList(dicCode,filter,startRow-1,pageSize,"True",0,"","","")
		d ..GetDicList(dicCode,filter,pageNum,pageSize,"True",0,"","S012",LOGONHOSPID)
	}
	else
	{
		d ..GetEPREpisodeListJSON(param, startRow, endRow)
	}
	
	Quit $$$OK
}

/// Debug:	w ##Class(EMRservice.Ajax.AuthDirectAppoint).GetEMRTree("6861","113",30,"17828").Read(32000)
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
	d ResultStream.Write(..TrimEnter("""text"":""已写病历"","))
	d ResultStream.Write("""children"":")
	
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLClientCategory:GetCategory")
	d result.Execute(AUserLoc,AGroupID,AEpisodeID)
	//第一次只查找实例病历
	s InsFlag = 0
	d ResultStream.Write("[")
	while result.%Next()
	{
		s curCategoryId = result.Data("ItemCategoryID")
		continue:(curCategoryId = "11")
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
	d ResultStream.Write("{")
	d ResultStream.Write(..TrimEnter("""id"":""TEMP"","))
	d ResultStream.Write("""attributes"":{")
	d ResultStream.Write(..TrimEnter("""class"":""M"","))
	d ResultStream.Write(..TrimEnter("""type"":""zdy""},"))
	d ResultStream.Write(..TrimEnter("""state"":""open"","))
	d ResultStream.Write(..TrimEnter("""text"":""模板"","))
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

/// Desc:		根据docID是否有实例以及是否Single判断是获取实例的json还是模板的json
/// Modify:     LIUZHONGWAN
/// DateTime:   2016-03-09
/// Input:		DocId和就诊Id
/// Output:		这一DocId下的所有json串
/// Debug	w ##Class(EMRservice.Ajax.AuthDirectAppoint).GetDocJsonsById(51,1)
ClassMethod GetDocJsonsById(ADocId As %String, AEpisodeId As %String) As %String
{
	s json = ""
	q:(ADocId = "")||(AEpisodeId = "") json
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
	s text = ..TrimEnter(title)_" "_createdate_" "_createtime_" "_..TrimEnter(createuserName)
	
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
	d json.Write(",""text"":"""_text_"""")
	d json.Write("}")	
	
	q json
}

ClassMethod TrimEnter(input As %String) As %String
{
	s input = $TR(input,$C(13),"")
	s input = $TR(input,$C(10),"")
	s input = $TR(input,$C(0),"")

	
	//替换斜杠
	for {
		s count = $f(input,"\")
		if (count > 0)
		{
			s input = $e(input,1,count-2)_""_$e(input,count,$l(input))	
		}
		else
		{
			q
		}	
	}
	
	//替换反斜杠
	for {
		s count = $f(input,"/")
		if (count > 0)
		{
			s input = $e(input,1,count-2)_""_$e(input,count,$l(input))	
		}
		else
		{
			q
		}	
	}
	
	q input
}

/// Debug:	d ##Class(EMRservice.Ajax.AuthDirectAppoint).GetDocListJSON("李红英^^^","1","20")
ClassMethod GetDocListJSON(AParam As %String, AIdxStart As %Integer, AIdxLast As %Integer)
{
 	s AUserName = $p(AParam,"^",1)
	s AUserCode = $p(AParam,"^",2)
	s AGroupID = $p(AParam,"^",3)
    s ACTLocID = $p(AParam,"^",4)
    s ALOGONHOSPID = $p(AParam,"^",5)
	s ShowShareHospital = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("ShowShareHospital","N")
	
	s result = ##Class(%ResultSet).%New("EMRservice.Ajax.AuthDirectAppoint:GetUser")
	s sc = result.Execute(AUserName, AUserCode, AGroupID, ACTLocID)
	
 	s count = 0
 	s first = 1
 	w "{""rows"":["
 	
	While (result.Next())
 	{
	 	//共库的医院，读取系统参数，判断是否显示非本院数据，默认为N-不显示；
		if (ShowShareHospital = "N")
		{
			s currHOSPID = $p($g(^CTLOC($g(result.Data("CTLocID")))),"^",22)
			continue:(currHOSPID '= "")&&(ALOGONHOSPID '= currHOSPID)
		}
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

/// do ##class(%ResultSet).RunQuery("EMRservice.Ajax.AuthDirectAppoint","GetUser","","","","")
Query GetUser(AUserName As %String, AUserCode As %String, AGroupID As %String, ACTLocID As %String) As %Query(ROWSPEC = "SSUserID:%String,UserName:%String,UserCode:%String,CTLocID:%String,SSGroupID:%String,CTLoc:%String,SSGroup:%String")
{
}

ClassMethod GetUserExecute(ByRef qHandle As %Binary, AUserName As %String, AUserCode As %String, AGroupID As %String, ACTLocID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	
	s:(AUserName = $c(0)) AUserName = ""
	s:(AUserCode = $c(0)) AUserCode = ""
	s:(AGroupID = $c(0)) AGroupID = ""
	s:(ACTLocID = $c(0)) ACTLocID = ""
	
	if (AUserName '= "")
	{
		s rset = ##Class(%ResultSet).%New("EMRservice.Ajax.AuthDirectAppoint:SelectByUserName")
		s sc = rset.Execute("%"_AUserName_"%")		
	}
	elseif (AUserCode '= "")
	{
		s rset = ##Class(%ResultSet).%New("EMRservice.Ajax.AuthDirectAppoint:SelectByUserCode")
		s sc = rset.Execute(AUserCode)
	}
	elseif (AGroupID '= "")
	{
		s rset = ##Class(%ResultSet).%New("EMRservice.Ajax.AuthDirectAppoint:SelectBySSGroupID")
		s sc = rset.Execute(AGroupID)	
	}
	elseif (ACTLocID '= "")
	{
		s rset = ##Class(%ResultSet).%New("EMRservice.Ajax.AuthDirectAppoint:SelectByCTLocID")
		s sc = rset.Execute(ACTLocID)
	}
	else
	{
		Quit $$$OK
	}
	
	while (rset.Next())
	{
		s SSUserID = rset.Data("ID")
		s UserName = rset.Data("Name")
		s UserCode = rset.Data("Code")
		s CTLocID = rset.Data("CTLocID")
		continue:((ACTLocID '= "") && (ACTLocID '= CTLocID))
		s SSGroupID = rset.Data("SSGroupID")
		continue:((AGroupID '= "") && (AGroupID '= SSGroupID))
		s CTLoc = rset.Data("CTLOC") 
		s SSGroup = rset.Data("SSGroup")	

		s ^CacheTemp(repid,ind) = $lb(SSUserID,UserName,UserCode,CTLocID,SSGroupID,CTLoc,SSGroup)
	    s ind=ind+1	
   }	
   Quit $$$OK
}

ClassMethod GetUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

Query SelectByCTLocID(ACTLocID As %String) As %SQLQuery
{
	/*
  	select SSUSR_RowId as ID, SSUSR_Name as Name, SSUSR_Initials as Code, SSUSR_DefaultDept_DR as CTLocID, SSUSR_Group as SSGroupID, SSUSR_DefaultDept_DR->CTLOC_Desc as CTLOC, SSUSR_Group->SSGRP_Desc as SSGroup
	from SQLUser.SS_User  
	where SSUSR_DefaultDept_DR = :ACTLocID and (SSUSR_Active='Y' or SSUSR_Active='Yes') 
	order by SSUSR_name
	*/
	/*
	select a.SSUSR_RowId as ID, a.SSUSR_Name as Name, a.SSUSR_Initials as Code, 
	b.RES_CTLOC_DR as CTLocID, a.SSUSR_Group as SSGroupID, 
	b.RES_CTLOC_DR->CTLOC_Desc as CTLOC, 
	a.SSUSR_Group->SSGRP_Desc as SSGroup
	from SQLUser.RB_Resource b LEFT JOIN SQLUser.SS_User a
	ON b.RES_Code = a.SSUSR_Initials
	LEFT JOIN SQLUser.SS_UserOtherLogonLoc c
	ON b.RES_CTLOC_DR = c.OTHLL_CTLOC_DR 
	where b.RES_CTLOC_DR = :ACTLocID AND (a.SSUSR_Active='Y' or a.SSUSR_Active='Yes')
	order by a.SSUSR_Name
	*/
	
	select a.SSUSR_RowId as ID, a.SSUSR_Name as Name, a.SSUSR_Initials as Code, 
	b.RES_CTLOC_DR as CTLocID, 
	CASE WHEN
	(SELECT OTHLL_UserGroup_DR FROM SQLUser.SS_UserOtherLogonLoc WHERE OTHLL_CTLOC_DR =b.RES_CTLOC_DR AND OTHLL_ParRef = a.SSUSR_RowId) IS NULL
	THEN a.SSUSR_Group
	ELSE
	(SELECT OTHLL_UserGroup_DR FROM SQLUser.SS_UserOtherLogonLoc WHERE OTHLL_CTLOC_DR =b.RES_CTLOC_DR AND OTHLL_ParRef = a.SSUSR_RowId)
	END
	as SSGroupID, 
	b.RES_CTLOC_DR->CTLOC_Desc as CTLOC, 
	CASE WHEN
	(SELECT OTHLL_UserGroup_DR->SSGRP_Desc FROM SQLUser.SS_UserOtherLogonLoc WHERE OTHLL_CTLOC_DR =b.RES_CTLOC_DR AND OTHLL_ParRef = a.SSUSR_RowId) IS NULL
	THEN a.SSUSR_Group->SSGRP_Desc 
	ELSE
	(SELECT OTHLL_UserGroup_DR->SSGRP_Desc FROM SQLUser.SS_UserOtherLogonLoc WHERE OTHLL_CTLOC_DR =b.RES_CTLOC_DR AND OTHLL_ParRef = a.SSUSR_RowId)
	END
	as SSGroup
	from SQLUser.RB_Resource b LEFT JOIN SQLUser.SS_User a
	ON b.RES_Code = a.SSUSR_Initials
	where b.RES_CTLOC_DR = :ACTLocID AND (a.SSUSR_Active='Y' or a.SSUSR_Active='Yes')
	order by a.SSUSR_Name
}

Query SelectByUserName(AUserName As %String) As %SQLQuery
{
	/*
  	select SSUSR_RowId as ID, SSUSR_Name as Name, SSUSR_Initials as Code, SSUSR_DefaultDept_DR as CTLocID, SSUSR_Group as SSGroupID, SSUSR_DefaultDept_DR->CTLOC_Desc as CTLOC, SSUSR_Group->SSGRP_Desc as SSGroup
	from SQLUser.SS_User
	where SSUSR_Name like :AUserName and (SSUSR_Active='Y' or SSUSR_Active='Yes') 
	order by SSUSR_name
	*/
	/*
	select a.SSUSR_RowId as ID, a.SSUSR_Name as Name, a.SSUSR_Initials as Code, 
	b.RES_CTLOC_DR as CTLocID, a.SSUSR_Group as SSGroupID, 
	b.RES_CTLOC_DR->CTLOC_Desc as CTLOC, 
	a.SSUSR_Group->SSGRP_Desc as SSGroup
	from SQLUser.RB_Resource b LEFT JOIN SQLUser.SS_User a
	ON b.RES_Code = a.SSUSR_Initials
	where a.SSUSR_Name like :AUserName AND (a.SSUSR_Active='Y' or a.SSUSR_Active='Yes')
	order by a.SSUSR_Name
	*/
	
	select a.SSUSR_RowId as ID, a.SSUSR_Name as Name, a.SSUSR_Initials as Code, 
	b.RES_CTLOC_DR as CTLocID, 
	CASE WHEN
	(SELECT OTHLL_UserGroup_DR FROM SQLUser.SS_UserOtherLogonLoc WHERE OTHLL_CTLOC_DR =b.RES_CTLOC_DR AND OTHLL_ParRef = a.SSUSR_RowId) IS NULL
	THEN a.SSUSR_Group
	ELSE
	(SELECT OTHLL_UserGroup_DR FROM SQLUser.SS_UserOtherLogonLoc WHERE OTHLL_CTLOC_DR =b.RES_CTLOC_DR AND OTHLL_ParRef = a.SSUSR_RowId)
	END
	as SSGroupID,  
	b.RES_CTLOC_DR->CTLOC_Desc as CTLOC, 
	CASE WHEN
	(SELECT OTHLL_UserGroup_DR->SSGRP_Desc FROM SQLUser.SS_UserOtherLogonLoc WHERE OTHLL_CTLOC_DR =b.RES_CTLOC_DR AND OTHLL_ParRef = a.SSUSR_RowId) IS NULL
	THEN a.SSUSR_Group->SSGRP_Desc 
	ELSE
	(SELECT OTHLL_UserGroup_DR->SSGRP_Desc FROM SQLUser.SS_UserOtherLogonLoc WHERE OTHLL_CTLOC_DR =b.RES_CTLOC_DR AND OTHLL_ParRef = a.SSUSR_RowId)
	END
	as SSGroup
	from SQLUser.RB_Resource b LEFT JOIN SQLUser.SS_User a
	ON b.RES_Code = a.SSUSR_Initials
	where a.SSUSR_Name like :AUserName AND (a.SSUSR_Active='Y' or a.SSUSR_Active='Yes')
	order by a.SSUSR_Name
}

Query SelectByUserCode(AUserCode As %String) As %SQLQuery
{
	/*
  	select SSUSR_RowId as ID, SSUSR_Name as Name, SSUSR_Initials as Code, SSUSR_DefaultDept_DR as CTLocID, SSUSR_Group as SSGroupID, SSUSR_DefaultDept_DR->CTLOC_Desc as CTLOC, SSUSR_Group->SSGRP_Desc as SSGroup
	from SQLUser.SS_User
	where SSUSR_Initials = :AUserCode and (SSUSR_Active='Y' or SSUSR_Active='Yes') 
	order by SSUSR_name
	*/
	/*
	select a.SSUSR_RowId as ID, a.SSUSR_Name as Name, a.SSUSR_Initials as Code, 
	b.RES_CTLOC_DR as CTLocID, a.SSUSR_Group as SSGroupID, 
	b.RES_CTLOC_DR->CTLOC_Desc as CTLOC, 
	a.SSUSR_Group->SSGRP_Desc as SSGroup
	from SQLUser.RB_Resource b LEFT JOIN SQLUser.SS_User a
	ON b.RES_Code = a.SSUSR_Initials
	where a.SSUSR_Initials = :AUserCode AND (a.SSUSR_Active='Y' or a.SSUSR_Active='Yes')
	order by a.SSUSR_Name*/
	
	select a.SSUSR_RowId as ID, a.SSUSR_Name as Name, a.SSUSR_Initials as Code, 
	b.RES_CTLOC_DR as CTLocID, 
	CASE WHEN
	(SELECT OTHLL_UserGroup_DR FROM SQLUser.SS_UserOtherLogonLoc WHERE OTHLL_CTLOC_DR =b.RES_CTLOC_DR AND OTHLL_ParRef = a.SSUSR_RowId) IS NULL
	THEN a.SSUSR_Group
	ELSE
	(SELECT OTHLL_UserGroup_DR FROM SQLUser.SS_UserOtherLogonLoc WHERE OTHLL_CTLOC_DR =b.RES_CTLOC_DR AND OTHLL_ParRef = a.SSUSR_RowId)
	END
	as SSGroupID, 
	b.RES_CTLOC_DR->CTLOC_Desc as CTLOC, 
	CASE WHEN
	(SELECT OTHLL_UserGroup_DR->SSGRP_Desc FROM SQLUser.SS_UserOtherLogonLoc WHERE OTHLL_CTLOC_DR =b.RES_CTLOC_DR AND OTHLL_ParRef = a.SSUSR_RowId) IS NULL
	THEN a.SSUSR_Group->SSGRP_Desc 
	ELSE
	(SELECT OTHLL_UserGroup_DR->SSGRP_Desc FROM SQLUser.SS_UserOtherLogonLoc WHERE OTHLL_CTLOC_DR =b.RES_CTLOC_DR AND OTHLL_ParRef = a.SSUSR_RowId)
	END
	as SSGroup
	from SQLUser.RB_Resource b LEFT JOIN SQLUser.SS_User a
	ON b.RES_Code = a.SSUSR_Initials
	where a.SSUSR_Initials = :AUserCode AND (a.SSUSR_Active='Y' or a.SSUSR_Active='Yes')
	order by a.SSUSR_Name
}

Query SelectBySSGroupID(ASSGroupID As %String) As %SQLQuery
{
  	select SSUSR_RowId as ID, SSUSR_Name as Name, SSUSR_Initials as Code, SSUSR_DefaultDept_DR as CTLocID, SSUSR_Group as SSGroupID, SSUSR_DefaultDept_DR->CTLOC_Desc as CTLOC, SSUSR_Group->SSGRP_Desc as SSGroup
  	from SQLUser.SS_User
	where SSUSR_Group = :ASSGroupID and (SSUSR_Active='Y' or SSUSR_Active='Yes')
	order by SSUSR_name
}

/// Debug:	d ##Class(EMRservice.Ajax.AuthDirectAppoint).GivePower("24","1296||1^935||2^935||3^1297||1^1301||1^877||13","628","save,view,print","359","6","220")
ClassMethod GivePower(AAppointSpan, AAppointCateCharpter, AAppointUserID, AEprActions, AUserID, ACTLocID, AEpisodeID, AAppointType As %String = "", AppointStatus As %String = "", AObjID As %String = "", ARelatedAppoint As %String = "")
{
	q:(AAppointSpan = "")||(AAppointCateCharpter = "")||(AAppointUserID = "")||(AEprActions = "")||(AUserID = "")||(ACTLocID = "")||(AEpisodeID = "") "-1"
	s flag = "1"
	TStart
	if (AAppointType = "")
	{
		s AAppointType = "0"
	}
	if (AppointStatus = "")
	{
		s AppointStatus = "G"
	}
	s AppointObj = ##class(EMRinstance.AuthAppoint).%New()
	if (AppointObj = "")
	{
		s flag = "-1"
	}
	//取当前系统时间
	s date = $p($H,",",1)
	s time = $p($H,",",2)
	
	s AppointObj.RequestID = "-1"
	s AppointObj.EpisodeID = AEpisodeID
	s AppointObj.RequestUserID = AUserID
	s AppointObj.RequestDept = ACTLocID
	s AppointObj.RequestDate = date
	s AppointObj.RequestTime = time
	s AppointObj.RequestCateCharpter = AAppointCateCharpter
	s AppointObj.RequestAction = AEprActions
	s AppointObj.AppointDate = date
	s AppointObj.AppointTime = time
	
	s timeSpan = +(+AAppointSpan * 3600)

	s EndDateTime = ..GetEndDateTime(date,time,timeSpan)
	s AppointObj.AppointEndDate = $p(EndDateTime,",",1)
	s AppointObj.AppointEndTime = $p(EndDateTime,",",2)
	s AppointObj.AppointUserID = AAppointUserID
	s AppointObj.AppointStatus = AppointStatus
	s AppointObj.AppointType = AAppointType
	s AppointObj.RelatedAppoint = ARelatedAppoint
	
	s AppointSC = AppointObj.%Save()
	if ('$$$ISOK(AppointSC))
	{
		s flag = "-2"
	}
	else
	{
		s AppointID = AppointObj.%Id()
		//如果是其他产品组调用此接口进行授权的，例如会诊授权、检查授权、检验授权等，写关联表数据
		if ((AppointStatus = "IC")||(AppointStatus = "IP")||(AppointStatus = "IL"))
		{
			s appointSub = ##Class(EMRinstance.AuthAppointSub).%New()
	 		s appointSub.AppointID = AppointID
	 		s appointSub.EpisodeID = AEpisodeID
	 		s appointSub.ObjID = AObjID
	 		s appointSub.Status = AppointStatus
	 		
	 		s appointSubSC = appointSub.%Save()
			if ('$$$ISOK(appointSubSC))
			{
				s flag = "-5"
			}
		}
		//对授权明细表插入数据
		s RequestCateCharpterCount = $l(AAppointCateCharpter, "^")
		for j = 1:1:RequestCateCharpterCount{
			s newflag = 0
			s RequestCateCharpter = $p(AAppointCateCharpter,"^",j)
			//对模板的处理
			if '(RequestCateCharpter [ "||")
			{
				continue:('(AEprActions [ "new"))
				if ('(AEprActions [ "save"))
				{
					s AEprActions = AEprActions_",save"
				}
				s newflag = 1
			}
			
			s ActionCount = $l(AEprActions, ",")
			for k = 1:1:ActionCount{
				s action = $p(AEprActions,",",k)
				continue:(newflag = 0)&&(action = "new") //过滤掉对实例病历的“创建”权限的申请
				
				s DetailObj = ##class(EMRinstance.AuthAppointDetail).%New()
				if (DetailObj = "")
				{
					s flag = "-3"
					q 
				}
				
				s DetailObj.AppointID = AppointID
				s DetailObj.EpisodeID = AEpisodeID
				s DetailObj.CateCharpter = RequestCateCharpter
				s DetailObj.Action = action
				s DetailObj.DetailStatus = "1"
				s DetailObj.Modify = "1"
				
				s DetailSC = DetailObj.%Save()
				if ('$$$ISOK(DetailSC))
				{
					s flag = "-4"
					q 
				}
			}
		}
	}
	
	if (flag < 0)
	{
		TRollback
		s flag = "-1"
		q flag
	}
	
	TCommit
	q flag
}

ClassMethod GetEndDateTime(startDate As %Date, startTime As %Time, timeSpan As %Integer) As %String
{
	//b "s"
	s curDate = (startTime+timeSpan)\86400
	if (curDate=0)
	{
		q startDate_","_(startTime+timeSpan)
	}
	else
	{
		s curTime = startTime+timeSpan-(curDate*86400)
		q startDate+curDate_","_curTime
	}
}

/// Debug:	w ##Class(EMRservice.Ajax.AuthDirectAppoint).GetHistoryJSON("6","134","","","all","1","20")
ClassMethod GetHistoryJSON(ALogonCtLocID As %String, ALogonGroupID As %String, AAppointStartDate As %String, AAppointEndDate As %String, AIsValid As %String, AIdxStart As %Integer, AIdxLast As %Integer, ALOGONHOSPID As %String, ALOGONUSERID As %String) As %GlobalCharacterStream
{
	//s ^tempncc("0") = ALogonCtLocID_"^"_ALogonGroupID_"^"_AAppointStartDate_"^"_AAppointEndDate_"^"_AIsValid_"^"_AIdxStart_"^"_AIdxLast
	s ResultStream = ##Class(%GlobalCharacterStream).%New()
	d ResultStream.Write("{""rows"":[")
	
	s authorizationSSGroupID = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("AuthorizationSSGroupID")
	s length = $l(authorizationSSGroupID,"^")
	s onlyCurrentDept = "1"
	for index=1:1:length
	{
		if ($p(authorizationSSGroupID,"^",index) = ALogonGroupID){
			s onlyCurrentDept = "2"	//1-本科室的病人的授权申请?非1-全部的病人授权申请	
		}
	}
		
	//取当前系统日期时间,默认查询30天内的数据
	s date = $p($h,",",1)
	s time = $p($h,",",2)
	if (AAppointStartDate = "")&&(AAppointEndDate = "")
	{
		s AAppointStartDate = date-30
		s AAppointEndDate = date
	}	
	
	s count = 0
 	s first = 1
	for i=AAppointEndDate:-1:AAppointStartDate
	{
		s AppointID = ""
		for 
		{
			s AppointID = $o(^DHCEMRI.AuthAppointI("IdxAppointDt"," G", i, AppointID),-1)
			q:(AppointID = "")
			
			s obj = ##class(EMRinstance.AuthAppoint).%OpenId(AppointID)
			
			s EpisodeID = obj.EpisodeID
			if (onlyCurrentDept = "1")
			{
				//只能显示当前登录科室患者被授权情况  add by niucaicai 2017-8-28
				s PatCtLocID = $P($g(^PAADM(EpisodeID)),"^",4)
				//医生 
				s LOGONUSERDr = $p($g(^SSU("SSUSR",ALOGONUSERID)),"^",14)
				s PAAdmDoctorID = $P($g(^PAADM(EpisodeID)),"^",9) 
				continue:((PatCtLocID '= ALogonCtLocID)&&(LOGONUSERDr '= PAAdmDoctorID))
			}
			elseif (onlyCurrentDept = "2")
			{
				//共库的医院，读取系统参数，判断是否显示非本院数据，默认为N-不显示；
				s ShowShareHospital = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("ShowShareHospital","N")
				if (ShowShareHospital = "N")
				{
					s PatCtLocID = $P($g(^PAADM(EpisodeID)),"^",4)
					s currHOSPID = $p($g(^CTLOC(PatCtLocID)),"^",22)
					continue:(currHOSPID '= "")&&(ALOGONHOSPID '= currHOSPID)
				}
			}
			
			s isValidText = "生效中"
			s isValid = "active"
			if (obj.AppointEndDate< $p($h,",",1))
			{ 
				s isValid = "past"
				s isValidText = "过期"
			}
			if ((obj.AppointEndDate = $p($h,",",1)) && (obj.AppointEndTime < $p($h,",",2)))
			{ 
				s isValid = "past"
				s isValidText = "过期"
			}
			
			continue:((AIsValid '= "all") && (AIsValid '= isValid) )
			
		 	s count = count + 1		
		 	if ( count >= AIdxStart) && (count <= AIdxLast)
			{
				s PatientID = $p($g(^PAADM(obj.EpisodeID)),"^",1)
				s PAAdmType = $p($g(^PAADM(obj.EpisodeID)),"^",2)   
				//就诊类型
				if PAAdmType = "I"
				{
					s PAAdmType = "住院"
				}elseif PAAdmType = "O"
				{
					s PAAdmType = "门诊"
				}elseif PAAdmType = "E"
				{
					s PAAdmType = "急诊"
				}
				//病人姓名
				s PAPMIName = $p($g(^PAPER(PatientID,"ALL")),"^",1)  
				//登记号
				s PAPMINO = $p($g(^PAPER(PatientID,"PAT",1)),"^",1) 

				s RequestUser = ""
				if (obj.RequestUserID '= "")
				{
					s requestUserID = obj.RequestUserID
					&sql(select TOP 1 SSUSR_Name into :RequestUser from SQLUser.SS_User where SSUSR_RowId = :requestUserID)
				}
				s AppointUser = ""
				if (obj.AppointUserID '= "")
				{
					s appointUserID = obj.AppointUserID
					&sql(select TOP 1 SSUSR_Name into :AppointUser from SQLUser.SS_User where SSUSR_RowId = :appointUserID)

				}
				
				s RequestUserCTLocName = ""
				s RequestUserCTLocID = obj.RequestDept
				if (RequestUserCTLocID '= "")
				{
					s RequestUserCTLocName = $P($g(^CTLOC(RequestUserCTLocID)),"^",2)
					s num = $L(RequestUserCTLocName,"-")
					if (num = 2)
					{
						s RequestUserCTLocName = $P(RequestUserCTLocName,"-",2)
					}
				}
				
				if ((count > 1)&&(first '= 1)) d ResultStream.Write(",")
				d ResultStream.Write("{")
				d ResultStream.Write(..TrimEnter("""AppointID"":"""_AppointID_""","))
				d ResultStream.Write(..TrimEnter("""EpisodeID"":"""_obj.EpisodeID_""","))
				d ResultStream.Write(..TrimEnter("""PatientID"":"""_PatientID_""","))
				d ResultStream.Write(..TrimEnter("""PAAdmType"":"""_PAAdmType_""","))
				d ResultStream.Write(..TrimEnter("""PAPMIName"":"""_PAPMIName_""","))
				d ResultStream.Write(..TrimEnter("""PAPMINO"":"""_PAPMINO_""","))
				s tmpAppointDate = ##class(EMRservice.Util.DateTimeFormat).GetHisDateTimeFormat(obj.AppointDate,"date")
				s tmpAppointTime = ##class(EMRservice.Util.DateTimeFormat).GetHisDateTimeFormat(obj.AppointTime,"time")
				s tmpAppointEndDate = ##class(EMRservice.Util.DateTimeFormat).GetHisDateTimeFormat(obj.AppointEndDate,"date")
				s tmpAppointEndTime = ##class(EMRservice.Util.DateTimeFormat).GetHisDateTimeFormat(obj.AppointEndTime,"time")
				d ResultStream.Write("""AppointDateTime"":"""_tmpAppointDate_" "_tmpAppointTime_""",")
				d ResultStream.Write("""AppointEndDateTime"":"""_tmpAppointEndDate_" "_tmpAppointEndTime_""",")
				d ResultStream.Write(..TrimEnter("""AppointUserID"":"""_obj.AppointUserID_""","))
				d ResultStream.Write(..TrimEnter("""AppointUserName"":"""_AppointUser_""","))
				d ResultStream.Write(..TrimEnter("""IsValid"":"""_isValidText_""","))
				d ResultStream.Write(..TrimEnter("""RequestUserName"":"""_RequestUser_""","))
				d ResultStream.Write(..TrimEnter("""RequestUserCTLocID"":"""_RequestUserCTLocID_""","))
				d ResultStream.Write(..TrimEnter("""RequestUserCTLocName"":"""_RequestUserCTLocName_""","))
				d ResultStream.Write(..TrimEnter("""RequestUserID"":"""_obj.RequestUserID_""","))
				
				d ResultStream.Write(..TrimEnter("""DetailData"":["))
				s DetailDataStream = ..GetDetailDataStreamByID(AppointID)
				d ResultStream.CopyFrom(DetailDataStream)
				d ResultStream.Write(..TrimEnter("]"))
				
				d ResultStream.Write("}")
				s first = 0
			}
		}
	}
	
	d ResultStream.Write("],""total"":"_count_"}")
	q ResultStream
}

ClassMethod GetDetailDataStreamByID(ARowID As %String) As %GlobalCharacterStream
{
	s DetailDataStream = ##Class(%GlobalCharacterStream).%New()
	q:(ARowID = "") DetailDataStream

	s count = 0
	s CateCharpterIndex = ""
	for
	{
		s CateCharpterIndex = $o(^DHCEMRI.AuthAppointDetailI("IdxAppointCharpter", " "_ARowID, CateCharpterIndex))
		q:(CateCharpterIndex = "")
		
		s CateCharpter = $E(CateCharpterIndex,2,$L(CateCharpterIndex))
		s CCDesc = ""
		s CCDateTime = ""
		s CCCreator = ""
		s CCDescStr = ""
		s CCDescStr = ..GetCateCharpterDescByID(CateCharpter)
		if (CCDescStr '= "")
		{
			s CCDesc = $p(CCDescStr,"^",1)
			s CCDateTime = $p(CCDescStr,"^",2)
			s CCCreator = $p(CCDescStr,"^",3)
		}
		s ActionStr = ""
		s ActionDescStr = ""
		s DetailID = ""
		for
		{
			s DetailID = $o(^DHCEMRI.AuthAppointDetailI("IdxAppointCharpter", " "_ARowID, CateCharpterIndex,DetailID))
			q:(DetailID = "")
			
			s DetailObj = ##class(EMRinstance.AuthAppointDetail).%OpenId(DetailID)
			
			s Action = DetailObj.Action
			s ActionDesc = ""
			if (Action = "save")
			{
				s ActionDesc = "保存"
			}
			elseif (Action = "print")
			{
				s ActionDesc = "打印"
			}
			elseif (Action = "delete")
			{
				s ActionDesc = "删除"
			}
			elseif (Action = "view")
			{
				s ActionDesc = "查看"
			}
			elseif (Action = "new")
			{
				s ActionDesc = "创建"
			}
			elseif (Action = "check")
			{
				s ActionDesc = "签名"
			}			
			if (ActionStr = "")
			{
				s ActionStr = Action
				s ActionDescStr = ActionDesc
			}
			else
			{
				s ActionStr = ActionStr_","_Action
				s ActionDescStr = ActionDescStr_","_ActionDesc
			}
		}
		if (count > 0)
		{
			d DetailDataStream.Write(",")
		}
		
		s HISFormatCCDateTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime", CCDateTime)
		d DetailDataStream.Write("{")
		d DetailDataStream.Write("""CateCharpter"":"""_CateCharpter_""",")
		d DetailDataStream.Write("""CCDesc"":"""_CCDesc_""",")
		d DetailDataStream.Write("""CCDateTime"":"""_HISFormatCCDateTime_""",")
		d DetailDataStream.Write("""CCCreator"":"""_CCCreator_""",")
		d DetailDataStream.Write("""ActionStr"":"""_ActionStr_""",")
		d DetailDataStream.Write("""ActionDescStr"":"""_ActionDescStr_"""")
		d DetailDataStream.Write("}")
		
		s count = count + 1
	}
	q DetailDataStream
}

ClassMethod GetCateCharpterDescByID(ACateCharpterIDs As %String) As %String
{
	s CateCharpterDescStr = ""
	q:(ACateCharpterIDs = "") CateCharpterDescStr
	
	s length = $l(ACateCharpterIDs,"^")
	for i=1:1:length
	{
		s InstanceId = $P(ACateCharpterIDs,"^",i)
		// liuzhongwan 这里需要取空模板的名字
		if ($find(InstanceId,"||") = 0)
		{
			s docId = InstanceId
			s objCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
			if (objCategoryDoc = "")
			{	
				s ccName = "申请模板不存在"
			}
			else{
				s objChapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objCategoryDoc.ParentCategoryID)
				s ccName = objChapter.CategoryName
			}
		}
		else
		{			
		// end liuzhongwan
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(InstanceId)
			q:(objInstance = "")
		
			s AEcrecordID = $P(InstanceId,"||",1)
			s objRecord = ##Class(EMRinstance.ECRecord).%OpenId(AEcrecordID)
			q:(objRecord = "")
			s epsiodeId = objRecord.RealEpisodeID
			s docId = objRecord.RealChartItemID
			s num = objInstance.ListNo
			s objCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
			if (objCategoryDoc = "")
			{	
				s ccName = "申请病历不存在"
			}
			else
			{
				s ccName = objCategoryDoc.CategoryName
				s objChapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objCategoryDoc.ParentCategoryID)
				if (objChapter '= "")
				{	
                    s createuserID = ""
					s createuserName = ""
					//s ccName = objChapter.CategoryName_"."_ccName_"."_objInstance.Title
					s createdate = $zd(objInstance.CreateDate,3)
					s createtime = $zt(objInstance.CreateTime)
					s createuserID = objInstance.CreateUser
					if (createuserID '= "")
					{
						s createuserCode = $p($g(^SSU("SSUSR",createuserID)),"^",14)
						s createuserName=$p($g(^CTPCP(createuserCode,1)),"^",2)
					}
					//重构所有模板的显示text，以防丢失Title或者用以区分不同的日常病程记录等；
					s ccName = objChapter.CategoryName_"."_objInstance.Title_"^"_createdate_" "_createtime_"^"_createuserName
					/*
					//重构可重复模板的显示text
					if (objRecord.ChartItemType = "Multiple")
					{
						s ccName = objChapter.CategoryName_"."_objInstance.Title_" "_createdate_" "_createtime_" "_createuserName
					}
					else
					{
						s ccName = objChapter.CategoryName_"."_objInstance.Title
					}
					*/
				}
			}
		}
		
		if CateCharpterDescStr = ""
		{	
			s CateCharpterDescStr = ccName
		}
		else
		{
			s CateCharpterDescStr = CateCharpterDescStr_"^"_ccName
		}
	}
	q CateCharpterDescStr
}

/// Debug:	d ##Class(EMRservice.Ajax.AuthDirectAppoint).Withdraw("")
ClassMethod Withdraw(AApointIDS As %String)
{
	s count = $l(AApointIDS,"^")
	//取当前系统时间
	s date = $p($H,",",1)
	s time = $p($H,",",2)
	
	s flag = "1"
	TStart
	for index=1:1:count
	{
		s appointID = $p(AApointIDS,"^",index)
		s appoint = ##class(EMRinstance.AuthAppoint).%OpenId(appointID)
		if (appoint = "")
		{
			s flag = "-1"
			q
		}
		
		s endDate = appoint.AppointEndDate
		s endTime = appoint.AppointEndTime
		
		//已过期则不操作
		continue:(endDate < date)
		continue:((endDate = date) && (endTime < time))

		//未过期设过期时间为当前时间
		s appoint.AppointEndDate = date
		s appoint.AppointEndTime = time-1
	
		s sc = appoint.%Save()
		d appoint.%Close()
	
		if ('$$$ISOK(sc))
		{
			s flag = "-1"
			q
		}
	}
	if (flag = "-1")
	{
		TRollback
		s flag = "-1"
		q flag
	}
	
	TCommit
	q flag
}

/// Debug:	d ##Class(EMRservice.Ajax.AuthDirectAppoint).GetEPREpisodeListJSON("^^95^^^^^95^10209^0","1","20")
ClassMethod GetEPREpisodeListJSON(AParam As %String, AIdxStart As %Integer, AIdxLast As %Integer)
{
	//b "s"
	s key = $i(^CacheTemp)
	k ^TempEPREpisodeListJSON(key)
	s result = ##Class(%ResultSet).%New("EMRservice.Ajax.AuthDirectAppoint:GetPatientList")
	s sc = result.Execute(AParam)
 	s count = 0
 	s json = ""
 	w "{""rows"":["
	While (result.Next())
 	{
	 	s tempJson = ""
	 	s count = count + 1		
		s tempJson = tempJson_"{"
		s tempJson = tempJson_..TrimEnter("""PAStatusType"":"""_$g(result.Data("PAStatusType"))_""",")
		s tempJson = tempJson_..TrimEnter("""PAAdmType"":"""_$g(result.Data("PAAdmType"))_""",")
		s tempJson = tempJson_..TrimEnter("""PAPMIName"":"""_$g(result.Data("PAPMIName"))_""",")
		s tempJson = tempJson_..TrimEnter("""PAPMINO"":"""_$g(result.Data("PAPMINO"))_""",")			
		s tempJson = tempJson_"""PAPMIDOB"":"""_$g(result.Data("PAPMIDOB"))_""","
		s tempJson = tempJson_..TrimEnter("""PAPMIAge"":"""_$g(result.Data("PAPMIAge"))_""",")
		s tempJson = tempJson_..TrimEnter("""PAPMISex"":"""_$g(result.Data("PAPMISex"))_""",")
		s tempJson = tempJson_"""PAAdmDateTime"":"""_$g(result.Data("PAAdmDateTime"))_""","
		s tempJson = tempJson_..TrimEnter("""PAAdmWard"":"""_$g(result.Data("PAAdmWard"))_""",")
		s tempJson = tempJson_..TrimEnter("""PAAdmRoom"":"""_$g(result.Data("PAAdmRoom"))_""",")
		s tempJson = tempJson_..TrimEnter("""PAAdmBed"":"""_$g(result.Data("PAAdmBed"))_""",")
		s tempJson = tempJson_..TrimEnter("""PAAdmLoc"":"""_$g(result.Data("PAAdmLoc"))_""",")			
		s tempJson = tempJson_"""PADischgeDateTime"":"""_$g(result.Data("PADischgeDateTime"))_""","
		s tempJson = tempJson_..TrimEnter("""PAAdmDoc"":"""_$g(result.Data("PAAdmDoc"))_""",")
		s tempJson = tempJson_..TrimEnter("""PayMode"":"""_$g(result.Data("PayMode"))_""",")
		s tempJson = tempJson_..TrimEnter("""EpisodeID"":"""_$g(result.Data("EpisodeID"))_""",")
		s tempJson = tempJson_..TrimEnter("""MedicareNo"":"""_$g(result.Data("MedicareNo"))_""",")
		s tempJson = tempJson_..TrimEnter("""PatientID"":"""_$g(result.Data("PatientID"))_"""")
		s tempJson = tempJson_"}"
		if ($g(result.Data("PAStatusType")) = "在院")
		{
			s ^TempEPREpisodeListJSON(key,$g(result.Data("PAStatusType")),$g(result.Data("PAAdmDateTime")),count) = tempJson
		}
		else
		{
			s ^TempEPREpisodeListJSON(key,$g(result.Data("PAStatusType")),$g(result.Data("PADischgeDateTime")),count) = tempJson
		}
	}
	s json = ..GetTempEPREpisodeListJSON(key,AIdxStart,AIdxLast)
	k ^TempEPREpisodeListJSON
	w json_"],""total"":"_count_"}"
}

/// Desc: 		按Key取数据
/// Creator:	Candy
/// CreateDate:	2021-01-28
/// Input: 		Key
/// Output:     Json
/// Debug:  	w ##Class(EMRservice.Ajax.AuthDirectAppoint).GetTempEPREpisodeListJSON()
ClassMethod GetTempEPREpisodeListJSON(Key As %String, AIdxStart As %Integer, AIdxLast As %Integer) As %String
{
	s json = ""
	s PAStatusType = "在院" , tempDateTime = "" , i=1 ,j=0
	for
	{
		s tempDateTime = $o(^TempEPREpisodeListJSON(Key,PAStatusType,tempDateTime),-1)
		if (tempDateTime = "")
		{
			if (PAStatusType = "在院")
			{
				s PAStatusType = "出院"
				continue
			}
			else
			{
				q
			}
		}
		s order = ""
		for
		{
			s order = $o(^TempEPREpisodeListJSON(Key,PAStatusType,tempDateTime,order))
			q:(order="")
			if ((AIdxStart <= i)&(i <= AIdxLast))
			{
				s:(j'=0) json = json_","
				s json = json_^TempEPREpisodeListJSON(Key,PAStatusType,tempDateTime,order)
				s j = j + 1
			}
			s i = i + 1
		}
	}
	q json
}

/// do ##class(%ResultSet).RunQuery("EMRservice.Ajax.AuthDirectAppoint","GetPatientList","^^6^^^^^6^105")
Query GetPatientList(AParam As %String) As %Query(ROWSPEC = "PAStatusType:%String,PAAdmType:%String,PAPMIName:%String,PAPMINO:%String,PAPMIDOB:%String,PAPMIAge:%String,PAPMISex:%String,PAAdmDateTime:%String,PAAdmWard:%String,PAAdmRoom:%String,PAAdmBed:%String,PAAdmLoc:%String,PADischgeDateTime:%String,PAAdmDoc:%String,PayMode:%String,EpisodeID:%String,PatientID:%String,MedicareNo:%String")
{
}

ClassMethod GetPatientListExecute(ByRef qHandle As %Binary, AParam As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s APatientID = $p(AParam,"^",1)
	s APatientName = $p(AParam,"^",2)
	s ALocID = $p(AParam,"^",3)
    s AWard = $p(AParam,"^",4)
	s AAdmNo = $p(AParam,"^",5)
	s ARegNo = $p(AParam,"^",6)
	s AMedicareNo = $p(AParam,"^",7)
	s LOGONCTLOCID = $p(AParam,"^",8)
	s LOGONUSERID = $p(AParam,"^",9)
	s onlyCurrentDept = $p(AParam,"^",10)
 	
 	d DealParamter   //处理参数
 	
	if (AAdmNo '= ""){
		s count = 0
		for {
			s count = count + 1
			q:(count > 1)
			s PAAdm = AAdmNo
			
			if (onlyCurrentDept '= "2")
			{
				//判断患者是否属于当前登录科室或者当前登录用户
				s ret = ..checkLocAndUser(PAAdm,LOGONCTLOCID,LOGONUSERID,onlyCurrentDept)
				continue:('ret)
			}
			
			d OutPutRow 		
		}

	}
	elseif (APatientID '= ""){
		s PAPMI = APatientID
		d OutPutPAMI
	}
 	elseif (ARegNo '= ""){
	 	s ARegNo = ..AddZero(ARegNo)
	 	s PAPMI = $o(^PAPERi("PAPMI_PatNo",ARegNo,""))
	 	q:(PAPMI = "") $$$OK
	 	d OutPutPAMI 
	}
	//add by niucaicai 2015-10-08 按病案号查询
	elseif (AMedicareNo '= "")
	{
		s patientID = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPatientIDByMRNo(AMedicareNo)
		s PAPMI = patientID
		q:(PAPMI = "") $$$OK
	 	d OutPutPAMI
	}
	elseif (APatientName '= ""){ 
		s PAPMI = ""
		for {
		   s PAPMI = $O(^PAPERi("PAPER_PatName",$zcvt($zstrip(APatientName,"*p"),"U"),PAPMI))
		   q:(PAPMI = "")
		   d OutPutPAMI
	    }	 
	}
	elseif(AWard '= ""){
		s RowID = ""
		for {
			 s RowID = $o(^PAADMi("CurrWard",AWard,RowID))
			 q:(RowID = "")
			 s PAAdm = ""
			 for {
				 	s PAAdm = $o(^PAADMi("CurrWard",AWard,RowID,PAAdm))
				 	q:(PAAdm = "")
				 	if (onlyCurrentDept '= "2")
					{
						//判断患者是否属于当前登录科室或者当前登录用户
						s ret = ..checkLocAndUser(PAAdm,LOGONCTLOCID,LOGONUSERID,onlyCurrentDept)
						continue:('ret)
					}
					
		         	d OutPutRow 
			 }
		}		
	}
	else{
		//科室
		s TempDate = ""
		for {
			s TempDate = $o(^PAADMi("DepDateTime",ALocID,TempDate))
			q:(TempDate = "")
			s TempTime = ""
			for {
				s TempTime = $o(^PAADMi("DepDateTime",ALocID,TempDate,TempTime))
				q:(TempTime = "")
				s PAAdm = ""
				for {
					s PAAdm = $o(^PAADMi("DepDateTime",ALocID,TempDate,TempTime,PAAdm))
					q:(PAAdm = "")
					
					if (onlyCurrentDept '= "2")
					{
						//判断患者是否属于当前登录科室或者当前登录用户
						s ret = ..checkLocAndUser(PAAdm,LOGONCTLOCID,LOGONUSERID,onlyCurrentDept)
						continue:('ret)
					}
					
					d OutPutRow
				}
			}
		}
	}
	Quit $$$OK
	
OutPutPAMI
	s AdmType = ""
	for {
	    s AdmType = $o(^PAPERdr(PAPMI,"ADM",AdmType))
	    q:(AdmType = "")
	    s PAAdm = ""
	    for {
		     s PAAdm = $o(^PAPERdr(PAPMI,"ADM",AdmType,PAAdm))
		     q:(PAAdm = "")
		     
		     //判断患者是否属于当前登录科室或者当前登录用户
			 if (onlyCurrentDept '= "2")
			{
				//判断患者是否属于当前登录科室或者当前登录用户
				s ret = ..checkLocAndUser(PAAdm,LOGONCTLOCID,LOGONUSERID,onlyCurrentDept)
				continue:('ret)
			}
		     
		     d OutPutRow
		}
	}
	q
	
OutPutRow
    //过滤掉已退院患者的就诊信息
    s VisitStatus = $p($g(^PAADM(PAAdm)),"^",20)
    q:(VisitStatus = "C")
	//s Hospital=##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
	s Hospital =##class(EMRservice.BL.BLSysOption).GetOptionValueByName("HospitalName")
	s PatientID = $p($g(^PAADM(PAAdm)),"^",1)
	s PAAdmType = $p($g(^PAADM(PAAdm)),"^",2)   
	//就诊类型
	if PAAdmType = "I"
	{
		s PAAdmType = "住院"
	}elseif PAAdmType = "O"
	{
		s PAAdmType = "门诊"
	}elseif PAAdmType = "E"
	{
		s PAAdmType = "急诊"
	}elseif PAAdmType = "H"
	{
		s PAAdmType = "体检"
	}
	//病人姓名
	s PAPMIName = $p($g(^PAPER(PatientID,"ALL")),"^",1)  
	//身份证号
	s IdCardNo = $P($G(^PAPER(PatientID,"ALL")),"^",9) 
	//登记号
	s PAPMINO = $p($g(^PAPER(PatientID,"PAT",1)),"^",1) 
		//病案号  add by niucaicai 2016-3-31
		s MedicareNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetMRNoByEpisodeID(PAAdm)
		s admdate = $P($g(^PAADM(PAAdm)),"^",6)  //入院日期
		s admtime = $P($g(^PAADM(PAAdm)),"^",7)  //入院时间
		s PAAdmDate = ##class(EMRservice.Util.DateTimeFormat).GetHisDateTimeFormat(admdate,"date") //$ZD(admdate,3) 
		s PAAdmTime = ##class(EMRservice.Util.DateTimeFormat).GetHisDateTimeFormat(admtime,"time") //$ZT(admtime,3)  
		s PAAdmDateTime = PAAdmDate_" "_PAAdmTime

	//出生日期,年龄
	s PAPMIDOB = "" ,PAPMIAge = ""  
	s DobDate = $p($g(^PAPER(PatientID,"ALL")),"^",6)
	If DobDate '= ""
	{
		s PAPMIDOB = ##class(EMRservice.Util.DateTimeFormat).GetHisDateTimeFormat(DobDate,"date")
		s tmpDoB = $ZD(DobDate,3)
		s AgeStr = ##Class(web.UDHCJFIPReg).getpatage(tmpDoB,"")
		s PAPMIAge = $p(AgeStr,"^",1)
		}
		
	//性别
	s Sex = $P($g(^PAPER(PatientID,"ALL")),"^",7)  
	s PAPMISex = $P($g(^CT("SEX",Sex)),"^",2)
	//婚姻
 	s tmpMarriage=##Class(EMRservice.HISInterface.PatientInfoAssist).Marriage(PatientID)
 	if tmpMarriage'=""
 	{
	 	s Marriage= $p($g(tmpMarriage),"^",3)
	}
	//出生地
	s tmpNative=##Class(EMRservice.HISInterface.PatientInfoAssist).Native(PatientID,Hospital)
 	if tmpNative'=""
 	{
   		//出生地城市 
   		s CityBirth = $p($g(tmpNative),"!",2)
   		s CityBirth = $p($g(CityBirth),"^",2)
 
   		//出生地省份 
   		s ProvinceBirth = $p($g(tmpNative),"!",1)
   		s ProvinceBirth = $p($g(ProvinceBirth),"^",2)
 	}
 	//职业
 	s tmpOccupation=##Class(EMRservice.HISInterface.PatientInfoAssist).Occupation(PatientID,Hospital)
 	i tmpOccupation'=""
 	{
   		s Occupation = $p($g(tmpOccupation),"^",2)
 	}
	//民族
	s tmpNation=##Class(EMRservice.HISInterface.PatientInfoAssist).Nation(PatientID,Hospital)
	i tmpNation'=""
 	{
   		s Nation = $p($g(tmpNation),"^",2)
 	}
 	//手机
	s MobilePhone=##Class(EMRservice.HISInterface.PatientInfoAssist).MobilePhone(PatientID,Hospital)
	
	//病区
	s PAAdmWard = ""  
	s WardDr = $P($g(^PAADM(PAAdm)),"^",70)
	if (WardDr '= "")
	{
		s PAAdmWard = $P($g(^PAWARD(WardDr)),"^",2)
		s count = $L(PAAdmWard,"-")
		if (count = 2)
		{
			s PAAdmWard = $P(PAAdmWard,"-",2)
		}
	}
	
	s PAAdmRoom = "" //病房
	s RoomDr = $P($g(^PAADM(PAAdm)),"^",69)
	if RoomDr '="" s PAAdmRoom = $p($g(^PAROOM(RoomDr)),"^",1)
	
	s PAAdmBed = ""  //病床
	s BedId = $P($g(^PAADM(PAAdm)),"^",73)   
	if BedId '= "" s PAAdmBed = $P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)
	//当前科室
	s PAAdmLoc = ""    
	s Loc = $P($g(^PAADM(PAAdm)),"^",4)  
	if (Loc '= "")
	{
		s PAAdmLoc = $P($g(^CTLOC(Loc)),"^",2)
		s count = $L(PAAdmLoc,"-")
		if (count = 2)
		{
			s PAAdmLoc = $P(PAAdmLoc,"-",2)
		}
	}
	//出院日期时间
	s PADischgeDate=$P($g(^PAADM(PAAdm)),"^",17) 
	s PADischgeDate=##class(EMRservice.Util.DateTimeFormat).GetHisDateTimeFormat(PADischgeDate,"date")
	s PADischgeTime=$P($g(^PAADM(PAAdm)),"^",18)
	s PADischgeTime=##class(EMRservice.Util.DateTimeFormat).GetHisDateTimeFormat(PADischgeTime,"time")
	s PADischgeDateTime = PADischgeDate_" "_PADischgeTime //$zd(PADischgeDate,3)_","_$zt(PADischgeTime,3)
	//在院状态
	s PAStatusType = "A"
	if (PADischgeDate = "") s PADischgeDateTime = "" 
	if (PADischgeDateTime '= "") s PAStatusType = "D"
	s ^CacheTemp("PAStatusType") = PADischgeDateTime_"||"_PAStatusType
	if (PAStatusType = "A")
	{
		s PAStatusType = "在院"
	}elseif (PAStatusType = "D")
	{
		s PAStatusType = "出院"
	}
	//医生 
	s PAAdmDoc = ""  
	s Doctor = $P($g(^PAADM(PAAdm)),"^",9) 
	if Doctor '= ""  s PAAdmDoc = $P($g(^CTPCP(Doctor,1)),"^",2)
	//付费方式
	s PayMode = "" 
	s prtRowID = ""
	for {
		s prtRowID = $o(^DHCSFPRINTDETAIL(0,"adm",PAAdm,prtRowID))
		q:(prtRowID = "")
		s pmRowID = +$p($g(^DHCSFPRINTDETAIL(prtRowID)),"^",9)
		q:(pmRowID = "")
		s pmDesc = $p($g(^CT("CTPM",pmRowID)),"^",2)
		if $f(PayMode,pmDesc) = 0 s PayMode = PayMode_pmDesc_" "
	}
	 	s data = $lb(PAStatusType,PAAdmType,PAPMIName,PAPMINO,PAPMIDOB,PAPMIAge,PAPMISex,PAAdmDateTime,PAAdmWard,PAAdmRoom,PAAdmBed,PAAdmLoc,PADischgeDateTime,PAAdmDoc,PayMode,PAAdm,PatientID,MedicareNo)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1 
	q
	
DealParamter    
    if AWard = $c(0) s AWard = ""
    if AWard '= ""
    {
       s TempWard = $o(^PAWARD(0,"WARD_LocationDR",AWard,""))
       if TempWard '= "" s AWard = TempWard
    }
    if APatientID = $c(0) s APatientID = ""
    if ARegNo = $c(0) s ARegNo = ""
    if APatientName = $c(0) s APatientName = ""
    if ALocID = $c(0) s ALocID = ""
    if AAdmNo = $c(0) s AAdmNo = ""
    if AMedicareNo = $c(0) s AMedicareNo = ""

    q
}

ClassMethod GetPatientListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatientListExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPatientListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatientListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod checkLocAndUser(PAAdm As %String, LOGONCTLOCID As %String, LOGONUSERID As %String, onlyCurrentDept As %String) As %String
{
	s ret = 0
	q:(PAAdm = "")||(LOGONCTLOCID = "")||(LOGONUSERID = "") ret
	
	//当前科室  
	s PAAdmLocID = $P($g(^PAADM(PAAdm)),"^",4)
	//医生 
	s LOGONUSERDr = $p($g(^SSU("SSUSR",LOGONUSERID)),"^",14)
	s PAAdmDoctorID = $P($g(^PAADM(PAAdm)),"^",9) 
	
	if (onlyCurrentDept = "0")
	{
		if (LOGONUSERDr = PAAdmDoctorID)
		{
			s ret = 1
		}
	}
	elseif (onlyCurrentDept = "1")
	{
		if (LOGONCTLOCID = PAAdmLocID)
		{
			s ret = 1
		}
	}
	
	q ret
}

ClassMethod AddZero(APatientNo As %String) As %String
{
	s patientNo = ""
	s patientNo = $o(^PAPERi("PAPMI_PatNo",patientNo))
	s patientNo = $tr(patientNo, " ")
	s patientNo = $tr(patientNo,$c(10),"")
	s patientNo = $tr(patientNo,$c(13),"")
	s length = $l(patientNo)
	q:(length = $l(APatientNo)) APatientNo
	
	for index=1:1:(length - $l(APatientNo)) {
		s APatientNo = "0"_APatientNo
	}
	q APatientNo
}

/// d ##Class(EMRservice.Ajax.AuthDirectAppoint).GetDicList("S07","光谷",0,10,"True",0,"","","")
/// d ##Class(EMRservice.Ajax.AuthDirectAppoint).GetDicList("S07","",0,10,"True",0,"","","")
ClassMethod GetDicList(ADicCode As %String, AItem As %String, ApageNum As %Integer, ApageSize As %Integer, CountFlag As %String, ByRef AResultCount As %String, ByRef ASessionId As %String, AConditionCode As %String = "", ACondition As %String = "")
{
    //检查参数有效性
 	if (ADicCode=$C(0)) { s ADicCode= "" Quit ""}
 	if (AItem=$C(0)){ s AItem= ""}
 	if (ApageNum=$C(0)){ s ApageNum = 0 Quit ""}
 	if (ApageSize=$C(0)){ s ApageSize = 0 Quit ""} 
 	
   	S SessionId=$I(^CacheTemp)
   	s ASessionId=SessionId
   	K ^CacheTempStdQuery(SessionId)
   
   	//生成字典查询结果集，并存储在临时global中
   	s PageCount= ##class(EMRservice.BL.BLStdDictionary).SelectNewStdDicPageCount(ADicCode,AItem,ApageNum,ApageSize,SessionId,AConditionCode,ACondition)
   	s AResultCount =PageCount
   	s TotalRowCount = $G(^CacheTempStdQuery(SessionId,"StdQueryDataCount"))
   	
   	//取相应页码的结果
  	if (PageCount'=0)
  	{ 
  		//以AStartRow开始，查询ARowCount个数据到Result中，与下面的按页查询相区别
  		//s startRow = (ApageNum -1)*ApageSize + 1
		//s endRow = startRow + ApageSize -1
  		//s Result = ##class(%ResultSet).%New("EMRservice.DAL.DAGetDicInTurn:GetDicInTurn")
  		//d Result.Execute(ADicCode,AItem,startRow,endRow,SessionId)
  		
  		//按第几页取数据 此处调用EMR环境中统一的取字典数据方法，缓存符合当前查询条件的当前页的前5页和后9页数据到临时global中
  		s Result = ##class(%ResultSet).%New("EMRservice.BL.BLStdDictionary:GetStdDicOrList")
    	d Result.Execute(ADicCode,AItem,ApageNum,ApageSize,SessionId)
  	}
  	else
  	{
		s SessionId=0
		s Result = "" 
	}
 	
 	w "{""rows"":["
 	s count = 0
 	if ($g(Result) '= "")
	{
	 	while(Result.Next())
	 	{
		 	s count = count + 1
		 	if (count > 1) w ","
			w "{"
			w ..TrimEnter("""ID"":"""_$g(Result.Data("ID"))_""",")
		 	w ..TrimEnter("""DicAlias"":"""_$g(Result.Data("DicAlias"))_""",")
		 	w ..TrimEnter("""DicCode"":"""_$g(Result.Data("DicCode"))_""",")
			w ..TrimEnter("""DicDesc"":"""_$g(Result.Data("DicDesc"))_"""")
			w "}"	
		}
	}
	w "],""total"":"_TotalRowCount_"}"
}

/// d ##Class(web.eprajax.DicList).GetSSGroup("门",1,10)
ClassMethod GetSSGroup(AGroupName As %String, AIdxStart As %Integer, AIdxLast As %Integer)
{

	if (AGroupName = $c(0)) s AGroupName = ""
	
	if (AGroupName = "")
	{
		s result = ##Class(%ResultSet).%New("EMRservice.Ajax.AuthDirectAppoint:GetAllSSGroup")
		s sc = result.Execute()
	}
	else
	{
		s result = ##Class(%ResultSet).%New("EMRservice.Ajax.AuthDirectAppoint:GetSSGroupByName")
		s sc = result.Execute("%"_AGroupName_"%")		
	}
	
 	//b "s"
 	w "{""rows"":["
 	s count = 0
 	s first = 1
 	while(result.Next())
 	{
	 	s count = count + 1
		if ( count >= AIdxStart) && (count <= AIdxLast)
		{
		 	if ((count > 1)&&(first '= 1)) w ","
			w "{"
			w ..TrimEnter("""ID"":"""_$g(result.Data("SSGRP_RowId"))_""",")
			w ..TrimEnter("""DicDesc"":"""_$g(result.Data("SSGRP_Desc"))_"""")
			w "}"
			s first = 0	
		}
 	}
	w "],""total"":"_count_"}"
}

Query GetAllSSGroup() As %SQLQuery(CONTAINID = 1, ROWSPEC = "SSGRP_RowId:%String,SSGRP_Desc:%String")
{
	select SSGRP_RowId,SSGRP_Desc 
	from SQLUser.SS_Group 
	order by SSGRP_RowId
}

Query GetSSGroupByName(argGroupName As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "SSGRP_RowId:%String,SSGRP_Desc:%String")
{
	select SSGRP_RowId,SSGRP_Desc 
	from SQLUser.SS_Group 
	where SSGRP_Desc like :argGroupName
}

/// Desc 移植自Appoint.cls，判断该条权限是否有效
/// Modify LIUZHONGWAN
ClassMethod CheckAppointIsActive(AID As %String) As %String
{
	
	s appoint = ##class(EMRinstance.AuthAppoint).%OpenId(AID)
	q:(appoint = "") "0"
	
	///授权日期或者授权时间为空,即没有授权
	q:(appoint.AppointDate = "" || appoint.AppointTime = "") "0"
	
	s date = $p($H,",",1)
	s time = $p($H,",",2)
	
	///授权截止日期小于当前日期,授权已过期
	q:(appoint.AppointEndDate<date) "0"
	
	///授权截止日期等于当前日期,授权截至时间小于当前时间,授权已过期
	q:(appoint.AppointEndDate=date)&&(appoint.AppointEndTime<time) "0"
	
	q "1"
}

/// Desc	令新创建的实例从模板处继承权限并封装privelege串
/// Modify	LIUZHONGWAN
/// Input	AAppointCateCharpter 新创建的实例ID
/// 			AEpisodeID 就诊信息
/// Output	仿照ActionFactory类中的GetPrivilege方法的privelege串，并且在DHCEMRI.EMRActionAppointD表中添加新的纪录
/// Debug	w ##class(EMRservice.Ajax.AuthDirectAppoint).InherTempPriv("885","2674160||8","456449","4133","190")
ClassMethod InherTempPriv(ADocID As %String, AInstanceID As %String, AEpisodeID As %String, AUserID As %String, AUserLocID As %String) As %String
{
	//s ^tempncc("2") = ADocID_"^"_AInstanceID_"^"_AEpisodeID_"^"_AUserID_"^"_AUserLocID
	s result = "1"
	q:(AInstanceID = "")||(AEpisodeID = "")||(AUserID = "")||(AUserLocID = "") "-1"
	
	if (ADocID = "")
	{
		s ECRecordID = $p(AInstanceID,"||",1)
		s ECRecordObj = ##class(EMRinstance.ECRecord).%OpenId(ECRecordID)
		q:(ECRecordObj = "")
		s ADocID = ECRecordObj.RealChartItemID
		d ECRecordObj.%Close()
	}
	
	//取当前时间
	s date = $p($H,",",1)
	s time = $p($H,",",2)
	
	s AppointID = ""
	for
	{
		q:(result = "-1")
		
		s span = ""
		s ActionStr = ""
		s AppointUserID = ""
		//索引中，F为集中授权的已授权状态；G为直接授权的已授权状态；所以此处应该兼容二者数据；
		//s AppointID = $o(^DHCEMRI.AuthAppointI("IdxStatusEpisode"," F"," "_AEpisodeID,AppointID),-1)
		s AppointID = $o(^DHCEMRI.AuthAppointI("IdxEpisode"," "_AEpisodeID,AppointID),-1)
		q:(AppointID = "")
		s AppointObj = ##class(EMRinstance.AuthAppoint).%OpenId(AppointID)
		q:(AppointObj = "")
		s AppointStatus = AppointObj.AppointStatus
		continue:(AppointStatus = "")
		continue:(AppointStatus '= "F")&&(AppointStatus '= "G")
		
		s flag = ..CheckAppointIsActive(AppointID)
		continue:(flag = "0")
		
		continue:($find("^"_AppointObj.RequestCateCharpter_"^","^"_ADocID_"^") = 0)
		continue:($find(","_AppointObj.RequestAction_",",",new,") = 0)
		
		if (AppointObj.AppointType="0")
		{	
			continue:(AppointObj.RequestUserID '= AUserID)
		}
		elseif (AppointObj.AppointType="1")
		{	
			continue:(AppointObj.RequestDept '= AUserLocID)
		}
		else
		{	
			continue
		}
		
		s AppointUserID = AppointObj.AppointUserID
		//计算和授权end时间的差，给span
		s Enddate = AppointObj.AppointEndDate
		s Endtime = AppointObj.AppointEndTime
		s span = (Enddate-date)*24 + ((Endtime-time)/3600)
		
		s DetailID=""
		for {
			
			s DetailID = $o(^DHCEMRI.AuthAppointDetailI("IdxAppoint"," "_AppointID,DetailID))
			q:(DetailID = "")
			
			s DetailObj = ##class(EMRinstance.AuthAppointDetail).%OpenId(DetailID)
			//获取当前登录用户有此DocID的哪些权限
			s action = DetailObj.Action
			if (DetailObj.DetailStatus = "1")
			{
				if (ActionStr = "")
				{
					s ActionStr = action
				}
				else
				{
					s ActionStr = ActionStr_","_action
				}
			}
		}
		
		if (AppointUserID '= "")
		{
			s GivePowerRet = ..GivePower(span,AInstanceID,AppointUserID,ActionStr,AUserID,AUserLocID,AEpisodeID)
			if (GivePowerRet '= "1")
			{
				s result = "-1"
			}
		}
	}
	
	q result
}

}
