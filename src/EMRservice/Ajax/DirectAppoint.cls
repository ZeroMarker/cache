Class EMRservice.Ajax.DirectAppoint Extends %CSP.Page
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
    
    s LOGONCTLOCID = $g(%session.Data("LOGON.CTLOCID"))
	s LOGONUSERID = $g(%session.Data("LOGON.USERID"))
	s LOGONGROUPID =$g(%session.Data("LOGON.GROUPID"))
    
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
	
	s param = patientID_"^"_patientName_"^"_patientLocID_"^"_patientWardID_"^"_episodeID_"^"_regNo_"^"_MedicareNo_"^"_LOGONCTLOCID_"^"_LOGONUSERID
	s paramDoc = userName_"^"_userCode_"^"_groupID_"^"_ctLocID
	
	//s ^CacheTemp("debug","input","111") = pageSize_"^"_pageNum_"^"_filter
    
	if (action = "gettree")
	{
		//获取选中医生,根据被授权的医生能够看到的病历展现结构进行授权
		s selectedDocID = $Get(%request.Data("selectedDocID",1),"")
		s selecteddocCTLocID = $Get(%request.Data("selecteddocCTLocID",1),"")
		s selecteddocSSGroupID = $Get(%request.Data("selecteddocSSGroupID",1),"")
		d ..GetEMRTree(episodeID,selecteddocCTLocID,selecteddocSSGroupID)
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
		d ..GetHistoryJSON(LOGONCTLOCID,isValid,startRow, endRow)	
	}
	elseif (action = "withdraw")
	{
		w ..Withdraw(appointIDs)	
	}
	//liuzhongwan 实例继承模板的权限
	elseif (action = "inherit")
	{
		//s curLocID = $g(%session.Data("LOGON.CTLOCID"))
		//s curuserID = $g(%session.Data("LOGON.USERID"))
		//s curssgroupID =$g(%session.Data("LOGON.GROUPID")) 
		//s privString = "userid^"_curuserID_"!userloc^"_curLocID_"!ssgroupid^"_curssgroupID_"!admid^"_episodeID_"!patientid^"_patientID_"!instanceid^"_appointCateCharpter
		d ..InherTempPriv(appointCateCharpter,episodeID)
	}
	//end liuzhongwan
	elseif (action = "ssgroup")
	{
		d ..GetSSGroup(filter,startRow,endRow)
	}
	elseif (action = "getdiclist")
	{
		//d ..GetDicList(dicCode,filter,startRow-1,pageSize,"True",0,"","","")
		d ..GetDicList(dicCode,filter,pageNum,pageSize,"True",0,"","","")
	}
	else
	{
		d ..GetEPREpisodeListJSON(param, startRow, endRow)
	}
	
	Quit $$$OK
}

/// Debug:	d ##Class(EMRservice.Ajax.DirectAppoint).GetEMRTree("43","6")
ClassMethod GetEMRTree(AEpisodeID, AUserLoc, AGroupID)
{
	s AStauts = "SAVE"
	//insert into EPRmeta.SysOption (Description,IsVisible,Name,OptionValue) Values ("授权|直接授权时默认不勾选的模板CategoryChapterID集合，以^分隔","Y","DirectCategoryChapterIDS","101^102")
	//由于EMRservice.BL.BLClientCategory.cls中改变了GetCategory这个Query，所以跟随改变，获取病历树
	/*
	s disDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(AEpisodeID)
	s schemType = $case(disDateTime,"":"Running",:"Archiving")
	q:(schemType = "") ""
	*/
	w "[{"
	w """id"":""RT00"","
	//w """type"":""RT"","
	w """text"":""授权范围"","
	w """attributes"":"
	w "{"
	w """type"":""RT""},"
	w """children"":"
	
	//遍历根节点的第一层目录(Category类型)
	s parentId = " 0"
	s curCategoryId = ""
	s count = 0
	w "["
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLClientCategory:GetCategory")
	d result.Execute(AUserLoc,AGroupID,AEpisodeID)
	while result.%Next()
	{
		s curCategoryId = result.Data("ItemCategoryID")
		if (count '= 0) w ","
		w "{"
		w ..TrimEnter("""id"":"""_curCategoryId_""",")
		//w ..TrimEnter("""type"":""cg"",")
		w """attributes"":"
		w "{"
		w ..TrimEnter("""type"":""cg""},")
		w ..TrimEnter("""text"":"""_result.Data("ItemTitle")_""",")
		w """children"":"
		w "["
		
		s json = ""
		s docIds = ..GetDocIdsByParent(curCategoryId)
		s length = $l(docIds,",")
		for I=1:1:length
		{
			s docId = $p(docIds,",",I)
			//liuzhongwan 16/03/09
			//s docJson = ..DoInstanceJsonByDocID(docId,AEpisodeID,"Save")
			s docJson = ..GetDocJsonsById(docId,AEpisodeID)
			s:(json '= "")&&(docJson '= "") json = json_","
			s json = json_docJson
		}
		w ..TrimEnter(json)
		
		w "]"
		w "}"
		
		s count = count+1
	}
		
	w "]"
	w "}]" //root
}

/// Desc:		根据docID是否有实例以及是否Single判断是获取实例的json还是模板的json
/// Modify:     LIUZHONGWAN
/// DateTime:   2016-03-09
/// Input:		DocId和就诊Id
/// Output:		这一DocId下的所有json串
/// Debug	w ##Class(EMRservice.Ajax.DirectAppoint).GetDocJsonsById(51,1)
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
/// Debug:     w ##Class(EMRservice.Ajax.DirectAppoint).GetTempJsonByID(51)
ClassMethod GetTempJsonByID(ADocID As %String) As %String
{
	s json = ""
	q:(ADocID = "") json
	s objTemplate = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(ADocID)
	q:(objTemplate = "") json
	s rowId = ADocID
	s parentId = objTemplate.ParentCategoryID
	s objparentTemplate = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(parentId)
	s text = objparentTemplate.CategoryName
	
	s json = json_"{"
	s json = json_"""id"":"""_rowId_""""
	s json = json_",""attributes"":{" 
	s json = json_"""type"":""ct"""
	s json = json_"}"
	//s json = json_",""checked"":""false"""
	s json = json_",""text"":"""_text_""""
	s json = json_"}"	

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
/// Debug：     w ##Class(EMRservice.Ajax.DirectAppoint).DoInstanceJsonByDocID(100,43,"Save")
ClassMethod DoInstanceJsonByDocID(ADocId As %String, AEpisodeId As %String, AStauts As %String) As %String
{
	s $zt = "Error"
	s json = ""
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
 				s tempJson = ..GetInstanceJsonByID(ecrecordId,subId)
 				continue:(tempJson = "")
 				s:(count '= 0) json = json_","
				s json = json_tempJson
				s count = count + 1			
			}
		}
	}
	s json = $ZSTRIP(json,"*C")
	q json
Error
	q ""
}

/// Desc: 取实例数据JSon
/// Input:     AEcrecordID EMRinstance.ECRecord的ID
///            ASubID EMRinstance.InstanceData的subId
/// Debug:     w ##Class(EMRservice.Ajax.Appoint).GetInstanceJsonByID(1,1)
ClassMethod GetInstanceJsonByID(AEcrecordID As %String, ASubID As %String) As %String
{
	s json = ""
	q:((AEcrecordID = "")||(ASubID = "")) json
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
	s title = objInstance.Title.%Id()
	s tmeplateId = objInstance.TemplateID
	s createdate = $zd(objInstance.CreateDate,3)
	s createtime = $zt(objInstance.CreateTime)
	s createuserID = objInstance.CreateUser
	s createuserCode = $p($g(^SSU("SSUSR",createuserID)),"^",14)
	s createuserName=$p($g(^CTPCP(createuserCode,1)),"^",2)
	//重构所有模板的显示text，以防丢失Title或者用以区分不同的日常病程记录等；
	s text = title_" "_createdate_" "_createtime_" "_createuserName
	s createdatetime=createdate_" "_createtime
	s createdatetime=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",createdatetime)
	s text = title_" "_createdatetime_" "_createuserName
	/*
	//重构可重复模板的显示text
	if (objRecord.ChartItemType = "Multiple")
	{
		s text = title_" "_createdate_" "_createtime_" "_createuserName
	}
	else
	{
		s text = title
	}
	
	s log = ##Class(EMRservice.BL.BLEMRLogs).GetLogStatus(epsiodeId,docId,num)
	s status = $p(log,"^",2)
	s creator = $tr($p($p($p(log,"^",1),"|",2),":",2)," ","")
	s notes =  objInstance.Memo //..GetInstanceSummery(rowId,epsiodeId)	
	*/
	s json = json_"{"
	s json = json_"""id"":"""_rowId_""""
	s json = json_",""attributes"":{" 
	s json = json_"""type"":""cc"""
	s json = json_"}"
	s json = json_",""checked"":""true"""
	s json = json_",""text"":"""_text_""""
	s json = json_"}"	
	
	q json
}

ClassMethod TrimEnter(AInput As %String) As %String
{
	s ret = $TR(AInput,$C(13),"")
	s ret = $TR(ret,$C(10),"")
	q ret
}

/// Debug:	d ##Class(EMRservice.Ajax.DirectAppoint).GetDocListJSON("李红英^^^","1","20")
ClassMethod GetDocListJSON(AParam As %String, AIdxStart As %Integer, AIdxLast As %Integer)
{
 	s AUserName = $p(AParam,"^",1)
	s AUserCode = $p(AParam,"^",2)
	s AGroupID = $p(AParam,"^",3)
    s ACTLocID = $p(AParam,"^",4)
	
	s result = ##Class(%ResultSet).%New("EMRservice.Ajax.DirectAppoint:GetUser")
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

/// do ##class(%ResultSet).RunQuery("EMRservice.Ajax.DirectAppoint","GetUser","","","","")
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
		s rset = ##Class(%ResultSet).%New("EMRservice.Ajax.DirectAppoint:SelectByUserName")
		s sc = rset.Execute("%"_AUserName_"%")		
	}
	elseif (AUserCode '= "")
	{
		s rset = ##Class(%ResultSet).%New("EMRservice.Ajax.DirectAppoint:SelectByUserCode")
		s sc = rset.Execute(AUserCode)
	}
	elseif (AGroupID '= "")
	{
		s rset = ##Class(%ResultSet).%New("EMRservice.Ajax.DirectAppoint:SelectBySSGroupID")
		s sc = rset.Execute(AGroupID)	
	}
	elseif (ACTLocID '= "")
	{
		s rset = ##Class(%ResultSet).%New("EMRservice.Ajax.DirectAppoint:SelectByCTLocID")
		s sc = rset.Execute(ACTLocID)
	}
	else
	{
		q
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
  	select SSUSR_RowId as ID, SSUSR_Name as Name, SSUSR_Initials as Code, SSUSR_DefaultDept_DR as CTLocID, SSUSR_Group as SSGroupID, SSUSR_DefaultDept_DR->CTLOC_Desc as CTLOC, SSUSR_Group->SSGRP_Desc as SSGroup
	from SQLUser.SS_User  
	where SSUSR_DefaultDept_DR = :ACTLocID and (SSUSR_Active='Y' or SSUSR_Active='Yes') 
	order by SSUSR_name
}

Query SelectByUserName(AUserName As %String) As %SQLQuery
{
  	select SSUSR_RowId as ID, SSUSR_Name as Name, SSUSR_Initials as Code, SSUSR_DefaultDept_DR as CTLocID, SSUSR_Group as SSGroupID, SSUSR_DefaultDept_DR->CTLOC_Desc as CTLOC, SSUSR_Group->SSGRP_Desc as SSGroup
	from SQLUser.SS_User
	where SSUSR_Name like :AUserName and (SSUSR_Active='Y' or SSUSR_Active='Yes') 
	order by SSUSR_name
}

Query SelectByUserCode(AUserCode As %String) As %SQLQuery
{
  	select SSUSR_RowId as ID, SSUSR_Name as Name, SSUSR_Initials as Code, SSUSR_DefaultDept_DR as CTLocID, SSUSR_Group as SSGroupID, SSUSR_DefaultDept_DR->CTLOC_Desc as CTLOC, SSUSR_Group->SSGRP_Desc as SSGroup
	from SQLUser.SS_User
	where SSUSR_Initials = :AUserCode and (SSUSR_Active='Y' or SSUSR_Active='Yes') 
	order by SSUSR_name
}

Query SelectBySSGroupID(ASSGroupID As %String) As %SQLQuery
{
  	select SSUSR_RowId as ID, SSUSR_Name as Name, SSUSR_Initials as Code, SSUSR_DefaultDept_DR as CTLocID, SSUSR_Group as SSGroupID, SSUSR_DefaultDept_DR->CTLOC_Desc as CTLOC, SSUSR_Group->SSGRP_Desc as SSGroup
  	from SQLUser.SS_User
	where SSUSR_Group = :ASSGroupID and (SSUSR_Active='Y' or SSUSR_Active='Yes')
	order by SSUSR_name
}

/// Debug:	d ##Class(EMRservice.Ajax.DirectAppoint).GivePower("24","","","","","","","1")
ClassMethod GivePower(AAppointSpan, AAppointCateCharpter, AAppointUserID, AEprActions, AUserID, ACTLocID, AEpisodeID, AppointType = "0")
{
	s count = $l(AEprActions,"^")
	s flag = 0
	for index=1:1:count
	{
		s appoint = ##class(EMRinstance.EMRActionAppoint).%New()
		if (appoint = "")
		{
			s flag = 1
			q	
		}
	
		b "s"
		//取当前系统时间
		s date = $p($H,",",1)
		s time = $p($H,",",2)
		s appoint.RequestDate = date
		s appoint.RequestTime = time
		s appoint.AppointDate = date
		s appoint.AppointTime = time
		
		s timeSpan = +(+AAppointSpan * 3600)
	
		s EndDateTime = ..GetEndDateTime(date,time,timeSpan)
		s appoint.AppointEndDate = $p(EndDateTime,",",1)
		s appoint.AppointEndTime = $p(EndDateTime,",",2)
		s appoint.AppointCateCharpter = AAppointCateCharpter
		s appoint.RequestCateCharpter = AAppointCateCharpter
		s appoint.AppointUserID = AAppointUserID
		s appoint.AppointStatus = "G"
		s appoint.EpisodeID = AEpisodeID
		s appoint.RequestUserID = AUserID
		s appoint.RequestDept = ACTLocID

		s appoint.EPRAction = $p(AEprActions,"^",index)

		s appoint.AppointType = AppointType
	
		s sc = appoint.%Save()
		d appoint.%Close()
	
		s:('$$$ISOK(sc)) flag = 1
	}
	q:(flag = 1) "-1"
	q "1"
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

/// Debug:	d ##Class(EMRservice.Ajax.DirectAppoint).GetHistoryJSON("1","20")
ClassMethod GetHistoryJSON(ALogonCtLocID As %String, AIsValid As %String, AIdxStart As %Integer, AIdxLast As %Integer)
{
 	s count = 0
 	s first = 1
 	w "{""rows"":["
 	
 	s rowID = ""
 	
	for {
		s rowID = $o(^DHCEMRI.EMRActionAppointI("IdxAstatus", " G", rowID), -1)
		q:(rowID = "")
		
		//b "s"
		s obj = ##class(EMRinstance.EMRActionAppoint).%OpenId(rowID)
		//只能显示当前登录科室患者被授权情况  add by niucaicai 2017-8-28
		s EpisodeID = obj.EpisodeID
		s PatCtLocID = $P($g(^PAADM(EpisodeID)),"^",4)
		continue:(PatCtLocID '= ALogonCtLocID)
		
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
			s desc = ""
			s length = $l(obj.AppointCateCharpter,"^")
			for index=1:1:length
			{
				s rowId = $p(obj.AppointCateCharpter,"^",index)
				//liuzhongwan 如果是instanceID就正常走，如果是docID就显示XXX（模板）
				s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(rowId)
				if (objInstance '= "")
				{
					s text = objInstance.Title
				}
				else
				{
					s objTemplate = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(rowId)
					if (objTemplate '= ""){
						s text = objTemplate.CategoryName_"(模板)"
					}
					else
					{
						s text = "无名称"
					}
				}
				//end liuzhongwan
				if (desc = "") {
					s desc = text
					//s desc = $list($g(^DHCEPRM.EPRTemplateCategoryD($p(obj.AppointCateCharpter,"^",index))),8)
				}
				else {
					s desc = desc_" "_text
					//s desc = desc_" "_$list($g(^DHCEPRM.EPRTemplateCategoryD($p(obj.AppointCateCharpter,"^",index))),8)
				}
			}
			
			
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
			
			s eprAction = obj.EPRAction
			s eprActionText = ""
			if (eprAction = "save")
            {
	            s eprActionText = "保存"
            }
    		elseif (eprAction = "print")
            {
	            s eprActionText = "打印"
            }
			elseif (eprAction = "delete")
            {
	            s eprActionText = "删除"
            }
			elseif (eprAction = "reference")
            {
	            s eprActionText = "文档对照"
            }    
			elseif (eprAction = "export")
            {
	            s eprActionText = "导出文档"
            }   
			elseif (eprAction = "residentcheck")
            {
	            s eprActionText = "住院医师审核"
            } 
			elseif (eprAction = "chiefcheck")
            {
	            s eprActionText = "主任医师审核"
            } 
 			elseif (eprAction = "attendingcheck")
            {
	            s eprActionText = "主治医师审核"
            }
            elseif (eprAction = "view")
            {
	            s eprActionText = "查看病历"
            }
            elseif (eprAction = "new")
            {
	            s eprActionText = "创建病历"
            }
            elseif (eprAction = "copypaste")
            {
	            s eprActionText = "复制粘贴"
            } 
			
		 	if ((count > 1)&&(first '= 1)) w ","
			w "{"
			w ..TrimEnter("""AppointID"":"""_rowID_""",")
			w ..TrimEnter("""EpisodeID"":"""_obj.EpisodeID_""",")
			w ..TrimEnter("""EpisodeID"":"""_obj.EpisodeID_""",")
			w ..TrimEnter("""PatientID"":"""_PatientID_""",")
			w ..TrimEnter("""PAAdmType"":"""_PAAdmType_""",")
			w ..TrimEnter("""PAPMIName"":"""_PAPMIName_""",")
			w ..TrimEnter("""PAPMINO"":"""_PAPMINO_""",")
			w ..TrimEnter("""AppointDateTime"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",$zd(obj.AppointDate,3)_" "_$zt(obj.AppointTime,3))_""",")
			w ..TrimEnter("""AppointEndDateTime"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",$zd(obj.AppointEndDate,3)_" "_$zt(obj.AppointEndTime,3))_""",")
			w ..TrimEnter("""AppointUserID"":"""_obj.AppointUserID_""",")	
			w ..TrimEnter("""AppointUserName"":"""_AppointUser_""",")			
			w ..TrimEnter("""AppointCateCharpter"":"""_obj.AppointCateCharpter_""",")
			w ..TrimEnter("""AppointCateCharpterText"":"""_desc_""",")
			w ..TrimEnter("""EPRAction"":"""_obj.EPRAction_""",")
			w ..TrimEnter("""EPRActionText"":"""_eprActionText_""",")
			w ..TrimEnter("""IsValid"":"""_isValidText_""",")
			w ..TrimEnter("""RequestUserName"":"""_RequestUser_""",")
			w ..TrimEnter("""RequestUserCTLocID"":"""_RequestUserCTLocID_""",")
			w ..TrimEnter("""RequestUserCTLocName"":"""_RequestUserCTLocName_""",")
			w ..TrimEnter("""RequestUserID"":"""_obj.RequestUserID_"""")
			w "}"
			s first = 0
		}
	}
	w "],""total"":"_count_"}"
}

/// Debug:	d ##Class(EMRservice.Ajax.DirectAppoint).Withdraw("")
ClassMethod Withdraw(AApointIDS As %String)
{
	s count = $l(AApointIDS,"^")
	s flag = 0
	for index=1:1:count
	{
		s appointID = $p(AApointIDS,"^",index)
		s appoint = ##class(EMRinstance.EMRActionAppoint).%OpenId(appointID)
		if (appoint = "")
		{
			s flag = 1
			q	
		}
	
		//b "s"
		//取当前系统时间
		s date = $p($H,",",1)
		s time = $p($H,",",2)

		s endDate = appoint.AppointEndDate
		s endTime = appoint.AppointEndTime
		
		//已过期则不操作
		continue:(endDate < date)
		continue:((endDate = date) && (endTime < time))

		//未过期设过期时间为当前时间
		s appoint.AppointEndDate = date
		s appoint.AppointEndTime = time
	
		s sc = appoint.%Save()
		d appoint.%Close()
	
		s:('$$$ISOK(sc)) flag = 1
	}
	q:(flag = 1) "-1"
	q "1"
}

/// Debug:	d ##Class(EMRservice.Ajax.DirectAppoint).GetEPREpisodeListJSON("^^7^^","1","20")
ClassMethod GetEPREpisodeListJSON(AParam As %String, AIdxStart As %Integer, AIdxLast As %Integer)
{
	//b "s"
	s result = ##Class(%ResultSet).%New("EMRservice.Ajax.DirectAppoint:GetPatientList")
	s sc = result.Execute(AParam)
	
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
			w ..TrimEnter("""PAStatusType"":"""_$g(result.Data("PAStatusType"))_""",")
			w ..TrimEnter("""PAAdmType"":"""_$g(result.Data("PAAdmType"))_""",")
			w ..TrimEnter("""PAPMIName"":"""_$g(result.Data("PAPMIName"))_""",")
			w ..TrimEnter("""PAPMINO"":"""_$g(result.Data("PAPMINO"))_""",")			
			w ..TrimEnter("""PAPMIDOB"":"""_$g(result.Data("PAPMIDOB"))_""",")
			w ..TrimEnter("""PAPMIAge"":"""_$g(result.Data("PAPMIAge"))_""",")
			w ..TrimEnter("""PAPMISex"":"""_$g(result.Data("PAPMISex"))_""",")
			w ..TrimEnter("""PAAdmDateTime"":"""_$g(result.Data("PAAdmDateTime"))_""",")
			w ..TrimEnter("""PAAdmWard"":"""_$g(result.Data("PAAdmWard"))_""",")
			w ..TrimEnter("""PAAdmRoom"":"""_$g(result.Data("PAAdmRoom"))_""",")
			w ..TrimEnter("""PAAdmBed"":"""_$g(result.Data("PAAdmBed"))_""",")
			w ..TrimEnter("""PAAdmLoc"":"""_$g(result.Data("PAAdmLoc"))_""",")			
			w ..TrimEnter("""PADischgeDateTime"":"""_$g(result.Data("PADischgeDateTime"))_""",")
			w ..TrimEnter("""PAAdmDoc"":"""_$g(result.Data("PAAdmDoc"))_""",")
			w ..TrimEnter("""PayMode"":"""_$g(result.Data("PayMode"))_""",")
			w ..TrimEnter("""EpisodeID"":"""_$g(result.Data("EpisodeID"))_""",")
			w ..TrimEnter("""MedicareNo"":"""_$g(result.Data("MedicareNo"))_""",")
			w ..TrimEnter("""PatientID"":"""_$g(result.Data("PatientID"))_"""")
			w "}"
			s first = 0
		}
	}
	w "],""total"":"_count_"}"
}

/// do ##class(%ResultSet).RunQuery("EMRservice.Ajax.DirectAppoint","GetPatientList","^^6^^^^^6^105")
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
 	
 	d DealParamter   //处理参数
 	
	if (AAdmNo '= ""){
		s count = 0
		for {
			s count = count + 1
			q:(count > 1)
			s PAAdm = AAdmNo
			
			//判断患者是否属于当前登录科室或者当前登录用户
			s ret = ..checkLocAndUser(PAAdm,LOGONCTLOCID,LOGONUSERID)
			continue:('ret)
			
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
		   s PAPMI = $O(^PAPERi("PAPER_PatName",APatientName,PAPMI))
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
				 	//判断患者是否属于当前登录科室或者当前登录用户
					s ret = ..checkLocAndUser(PAAdm,LOGONCTLOCID,LOGONUSERID)
					continue:('ret)
					
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
					
					//判断患者是否属于当前登录用户
					/*
					s LOGONUSERDr = $p($g(^SSU("SSUSR",LOGONUSERID)),"^",14)
					s PAAdmDoctorDr = $P($g(^PAADM(PAAdm)),"^",9)
					continue:(PAAdmDoctorDr '= LOGONUSERDr)
					*/
					
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
			 s ret = ..checkLocAndUser(PAAdm,LOGONCTLOCID,LOGONUSERID)
			 continue:('ret)
		     
		     d OutPutRow
		}
	}
	q
	
OutPutRow
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
		
		s PAAdmDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",admdate)
		s PAAdmTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",admtime)     	 
		s PAAdmDateTime = PAAdmDate_" "_PAAdmTime
		if (PAAdmDateTime = " ") s PAAdmDateTime = ""

	//出生日期,年龄
	s PAPMIDOB = "" ,PAPMIAge = ""  
	s DobDate = $p($g(^PAPER(PatientID,"ALL")),"^",6)
	If DobDate '= ""
	{
		s PAPMIDOB = $ZD(DobDate,3)
		s PAPMIDOB = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",DobDate)
		//modify 20170823 修正年龄为统一接口
		//s PAPMIDOB=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",PAPMIDOB)
		//s AgeStr = ##Class(web.UDHCJFIPReg).getpatage(PAPMIDOB,"")
		//s PAPMIAge = $p(AgeStr,"^",1)
		s PAPMIAge = ##class(EMRservice.HISInterface.PatientInfoAssist).Age(PatientID,PAAdm,"","")
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
		s PADischgeDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",PADischgeDate)
		s PADischgeTime=$P($g(^PAADM(PAAdm)),"^",18)
		s PADischgeTime=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",PADischgeTime)
	        	 
		
		s PADischgeDateTime = PADischgeDate_" "_PADischgeTime
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
		s pmRowID = $p($g(^DHCSFPRINTDETAIL(prtRowID)),"^",9)
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

ClassMethod checkLocAndUser(PAAdm As %String, LOGONCTLOCID As %String, LOGONUSERID As %String) As %String
{
	s ret = 0
	q:(PAAdm = "")||(LOGONCTLOCID = "")||(LOGONUSERID = "") ret
	
	//当前科室  
	s PAAdmLocID = $P($g(^PAADM(PAAdm)),"^",4)
	//医生 
	s LOGONUSERDr = $p($g(^SSU("SSUSR",LOGONUSERID)),"^",14)
	s PAAdmDoctorID = $P($g(^PAADM(PAAdm)),"^",9) 
	
	if (LOGONCTLOCID = PAAdmLocID) //&&(LOGONUSERDr = PAAdmDoctorID)
	{
		s ret = 1
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

/// d ##Class(EMRservice.Ajax.DirectAppoint).GetDicList("S07","",0,10,"True",0,"","","")
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
	w "],""total"":"_TotalRowCount_"}"
}

/// d ##Class(web.eprajax.DicList).GetSSGroup("门",1,10)
ClassMethod GetSSGroup(AGroupName As %String, AIdxStart As %Integer, AIdxLast As %Integer)
{

	if (AGroupName = $c(0)) s AGroupName = ""
	
	if (AGroupName = "")
	{
		s result = ##Class(%ResultSet).%New("EMRservice.Ajax.DirectAppoint:GetAllSSGroup")
		s sc = result.Execute()
	}
	else
	{
		s result = ##Class(%ResultSet).%New("EMRservice.Ajax.DirectAppoint:GetSSGroupByName")
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
	
	s appoint = ##class(EMRinstance.EMRActionAppoint).%OpenId(AID)
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
/// Debug	d ##class(EMRservice.Ajax.DirectAppoint).InherTempPriv(330||11,468)
ClassMethod InherTempPriv(AAppointCateCharpter, AEpisodeID)
{
	//s json  = ""
	//q:(AEvironmentParams = "") json
	//s AppointCateCharpter = $p($p(AEvironmentParams,"!",6),"^",2)
	//s EpisodeID = $p($p(AEvironmentParams,"!",4),"^",2)
	q:(AAppointCateCharpter = "")||(AEpisodeID = "") //json
	s InstanceID = $p(AAppointCateCharpter,"||",1)
	s objInstance = ##class(EMRinstance.ECRecord).%OpenId(InstanceID)
	q:(objInstance = "")
	s DocID = objInstance.RealChartItemID
	s AppointIndex = ""
	for{
		s AppointIndex = $o(^DHCEMRI.EMRActionAppointI("IdxEpisode"," "_AEpisodeID, AppointIndex))
		q:(AppointIndex="")
		
		s flag = ..CheckAppointIsActive(AppointIndex)
		continue:(flag="0")
		
		s objAppoint = ##class(EMRinstance.EMRActionAppoint).%OpenId(AppointIndex)
		continue:($find("^"_objAppoint.AppointCateCharpter_"^","^"_DocID_"^")=0)
		
		//取当前时间，计算和授权end时间的差，给span
		s date = $p($H,",",1)
		s time = $p($H,",",2)
		s Enddate = objAppoint.AppointEndDate
		s Endtime = objAppoint.AppointEndTime
		s span = (Enddate-date)*24 + ((Endtime-time)/3600)
		s AppointUser = objAppoint.AppointUserID
		s Action = objAppoint.EPRAction
		s RequestUser = objAppoint.RequestUserID
		s RequestLoc = objAppoint.RequestDept
		s AppointType = objAppoint.AppointType
		d ..GivePower(span,AAppointCateCharpter,AppointUser,Action,RequestUser,RequestLoc,AEpisodeID,AppointType)
	}
	//获取该InstanceID的权限信息
	//s privRule = ##Class(EMRservice.BL.BLPrivRule).ParsePrivRule(AEvironmentParams,"ActionPrivilege")
	//q:(privRule = "") json
	//s json = "{""InstanceID"":"""_AppointCateCharpter_""",""privelege"":{"
	//s json = json_"""canSave"":"""_$p($p(privRule,"!",1),"^",2)
	//s json = json_""",""canPrint"":"""_$p($p(privRule,"!",2),"^",2)
	//s json = json_""",""canDelete"":"""_$p($p(privRule,"!",3),"^",2)
	//s json = json_""",""canResidentCheck"":"""_$p($p(privRule,"!",4),"^",2)
	//s json = json_""",""canChiefCheck"":"""_$p($p(privRule,"!",5),"^",2)
	//s json = json_""",""canAttendingCheck"":"""_$p($p(privRule,"!",6),"^",2)
	//s json = json_""",""canReference"":"""_$p($p(privRule,"!",7),"^",2)
	//s json = json_""",""canExport"":"""_$p($p(privRule,"!",8),"^",2)
	//s json = json_""",""canCopyPaste"":"""_$p($p(privRule,"!",11),"^",2)
	//s json = json_""",""canRevise"":"""_$p($p(privRule,"!",12),"^",2)
	//s json = json_""",""canViewRevise"":"""_$p($p(privRule,"!",13),"^",2)
	//s json = json_"""},""result"":""OK""}"
	//s json = $ZSTRIP(json,"*C")
	q //json
}

}
