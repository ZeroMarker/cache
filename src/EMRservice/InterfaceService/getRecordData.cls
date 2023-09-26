/// Desc:       对外接口-取患者病历数据JSON数据
Class EMRservice.InterfaceService.getRecordData Extends %RegisteredObject
{

/// Input:      AEpisodeID 
/// 			AUserID
/// 			AUserLocID
/// 			ASSGroupID
/// 			AType : "INSTANCE"-只返回实例数据; "ALL"-返回空模板和实例数据
/// OutPut:     %GlobalCharacterStream 类型的JSON格式数据  
/// w ##class(EMRservice.InterfaceService.getRecordData).GetJsonStream("4","10209","95","29","instance")
ClassMethod GetJsonStream(AEpisodeID As %String, AUserID As %String, AUserLocID As %String, ASSGroupID As %String, AType As %String) As %GlobalCharacterStream
{
	s jsonStream = ##class(%GlobalCharacterStream).%New()
	d jsonStream.Write("[")
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLClientCategory:GetCategory")
	d result.Execute(AUserLocID,ASSGroupID,AEpisodeID)
	
	while result.%Next()
	{
		continue:(result.Data("ItemCategoryID")="")
		d:(jsonStream.Size '= 1) jsonStream.Write(",")
		d jsonStream.Write("{")
		d jsonStream.Write(..TrimEnter("""id"":"""_result.Data("ItemCategoryID")_""","))
		d jsonStream.Write(..TrimEnter("""text"":"""_result.Data("ItemTitle")_""","))
		d jsonStream.Write(..TrimEnter("""children"":["))
		
		s docIds = ..GetDocIdsByParent(result.Data("ItemCategoryID"))
		s length = $l(docIds,",")
		for i=1:1:length{
			s docId = $p(docIds,",",i)
			s docJson = ..GetDocJsonsById(docId,AEpisodeID,"",AType)
			d:((i > 1)&&(docJson '= "")) jsonStream.Write(",")
			d jsonStream.Write(docJson)
		}
		d jsonStream.Write("]}")
	}
	d jsonStream.Write("]") 
	q jsonStream
}

/// Desc:       根据目录展现结构取DocID
/// Input:      AParentId 目录展现结构ID,取所有的为0
///             AEpisodeId 就诊ID
/// OutPut:     以","分隔的DOCID集合         
/// Debug       d ##Class(EMRservice.InterfaceService.getRecordData).GetDocIdsByParent(3)
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

/// Desc:		根据docID是否有实例以及是否Single判断是获取实例的json还是模板的json
/// Input:		DocId和就诊Id
/// Output:		这一DocId下的所有json串
/// Debug	w ##Class(EMRservice.InterfaceService.getRecordData).GetDocJsonsById(51,5,"","instance")
ClassMethod GetDocJsonsById(ADocId As %String, AEpisodeId As %String, AResultType As %String = "", AType As %String) As %String
{
	s json = ""
	q:(ADocId = "")||(AEpisodeId = "")||(AType = "") json
	s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(ADocId)
	q:(objTemplate = "") json
	s Sflag = ""
	s result = ##class(EMRservice.BL.BLInstanceData).IsHasInstance(AEpisodeId,"",ADocId)
	//第一层判断：是否有实例
	q:((result = "0")&&($zcvt(AType,"U") = "INSTANCE")) json
	q:((result = "0")&&($zcvt(AType,"U") '= "INSTANCE")) ..GetTempJsonByID(ADocId)
	s tempjson = ..DoInstanceJsonByDocID(ADocId,AEpisodeId,"SAVE")
	q:(tempjson = "") json
	s json = json_tempjson
	/*
	s:(objTemplate.ChartItemType = "Single") Sflag = 1
	//第二层判断：是否SINGLE
	if ('Sflag = 1)
	{
		s tempjson = ..GetTempJsonByID(ADocId)
		q:(tempjson = "") json
		q:(Sflag = 1) //tempJson = $p(tempJson,",",1,5)_","_$p(tempJson,",",7)
		s json = json_","_tempjson
	}
	*/
	q json
}

/// Desc: 取模板数据JSon
/// Modify:     LIUZHONGWAN
/// DateTime:   2016-02-22
/// Input:     ADocID 空模板的DocID，TempCate类型的
/// Output:    模板的信息JSon串
/// Debug:     w ##Class(EMRservice.InterfaceService.getRecordData).GetTempJsonByID(51)
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

/// Desc:		根据DocId取实例
/// Input: 		AParentId 目录categoryID
/// 			AEpisodeId 就诊号
/// 			AUniqueKey 唯一标示
/// 			OutPut result 1成功，0错误
/// Debug：     w ##Class(EMRservice.InterfaceService.getRecordData).DoInstanceJsonByDocID(74,5,"Save")
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
/// Debug:     w ##Class(EMRservice.InterfaceService.getRecordData).GetInstanceJsonByID(1,1)
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
	s title = objInstance.Title
	s tmeplateId = objInstance.RealTemplateID
	s createdate = $zd(objInstance.CreateDate,3)
    s createdate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",createdate)
	s createtime = $zt(objInstance.CreateTime)
    s createtime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",createtime)
	s createuserID = objInstance.CreateUser
	s createuserCode = $p($g(^SSU("SSUSR",createuserID)),"^",14)
	s createuserName=$p($g(^CTPCP(createuserCode,1)),"^",2)
	//重构所有模板的显示text，以防丢失Title或者用以区分不同的日常病程记录等；
	s text = title_" "_createdate_" "_createtime_" "_createuserName
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

///   d ##Class(%ResultSet).RunQuery("EMRservice.InterfaceService.getRecordData","GetRecordDataQuery","4","10209","95","29")
Query GetRecordDataQuery(AEpisodeID As %String, AUserID As %String, AUserLocID As %String, ASSGroupID As %String) As %Query(ROWSPEC = "CategoryID:%String,CategoryTitle:%String,InstanceID:%String,InstanceText:%String")
{
}

ClassMethod GetRecordDataQueryExecute(ByRef qHandle As %Binary, AEpisodeID As %String, AUserID As %String, AUserLocID As %String, ASSGroupID As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLClientCategory:GetCategory")
	d result.Execute(AUserLocID,ASSGroupID,AEpisodeID)
	
	while result.%Next()
	{
		s CategoryTitle = result.Data("ItemTitle")
		s CategoryID = result.Data("ItemCategoryID")
		continue:(CategoryID = "")
		
		s docIds = ..GetDocIdsByParent(CategoryID)
		s length = $l(docIds,",")
		for i=1:1:length{
			s docId = $p(docIds,",",i)
			s docJson = ..GetDocDatasById(docId,AEpisodeID,"")
			continue:(docJson = "")
			
			s subDocJsonCount = $l(docJson,",")
			for j=1:1:subDocJsonCount
			{
				s subDocJson = $p(docJson,",",j)
				s InstanceID = $p(subDocJson,"^",1)
				s InstanceText = $p(subDocJson,"^",2)
				continue:(InstanceID = "")
				
				s data = $lb(CategoryID,CategoryTitle,InstanceID,InstanceText)
				s ^CacheTemp(repid,ind) = data
				s ind=ind+1 
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod GetRecordDataQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRecordDataQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetRecordDataQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRecordDataQueryExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDocDatasById(ADocId As %String, AEpisodeId As %String, AResultType As %String = "") As %String
{
	s json = ""
	q:(ADocId = "")||(AEpisodeId = "") json
	s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(ADocId)
	q:(objTemplate = "") json
	s Sflag = ""
	s result = ##class(EMRservice.BL.BLInstanceData).IsHasInstance(AEpisodeId,"",ADocId)
	//第一层判断：是否有实例
	q:(result = "0") json
	s tempjson = ..DoInstanceDataByDocID(ADocId,AEpisodeId,"SAVE")
	q:(tempjson = "") json
	s json = json_tempjson
	/*
	s:(objTemplate.ChartItemType = "Single") Sflag = 1
	//第二层判断：是否SINGLE
	if ('Sflag = 1)
	{
		s tempjson = ..GetTempJsonByID(ADocId)
		q:(tempjson = "") json
		q:(Sflag = 1) //tempJson = $p(tempJson,",",1,5)_","_$p(tempJson,",",7)
		s json = json_","_tempjson
	}
	*/
	q json
}

ClassMethod DoInstanceDataByDocID(ADocId As %String, AEpisodeId As %String, AStauts As %String) As %String
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
 				s tempJson = ..GetInstanceDataByID(ecrecordId,subId)
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

ClassMethod GetInstanceDataByID(AEcrecordID As %String, ASubID As %String) As %String
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
	s title = objInstance.Title
	s tmeplateId = objInstance.RealTemplateID
	s createdate = $zd(objInstance.CreateDate,3)
    s createdate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",createdate)
	s createtime = $zt(objInstance.CreateTime)
    s createtime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",createtime)
	s createuserID = objInstance.CreateUser
	s createuserCode = $p($g(^SSU("SSUSR",createuserID)),"^",14)
	s createuserName=$p($g(^CTPCP(createuserCode,1)),"^",2)
	//重构所有模板的显示text，以防丢失Title或者用以区分不同的日常病程记录等；
	s text = title_" "_createdate_" "_createtime_" "_createuserName
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
	/*
	s json = json_"{"
	s json = json_"""id"":"""_rowId_""""
	s json = json_",""attributes"":{" 
	s json = json_"""type"":""cc"""
	s json = json_"}"
	s json = json_",""text"":"""_text_""""
	s json = json_"}"	
	*/
	s json = rowId_"^"_text
	q json
}

}
