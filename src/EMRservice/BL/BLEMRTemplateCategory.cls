Class EMRservice.BL.BLEMRTemplateCategory Extends (%RegisteredObject, %XML.Adaptor)
{

ClassMethod GetEMRTemplateCategory() As %String
{
	s result=""
	&sql(DECLARE curCategory CURSOR FOR 
			SELECT ID INTO :id FROM EMRmeta.EMRTemplateCategory WHERE CategoryType ='Category' 
			ORDER BY CategorySeq)
	&sql(OPEN curCategory)
	for {
		&sql(FETCH curCategory)
		q:(SQLCODE)
		
		s obj=##Class(EMRmeta.EMRTemplateCategory).%OpenId(id)
		s item="{'id':"_id_",'text':'"_obj.CategoryName_"','state':'closed'"_..GetEMRTemplateCategoryChapter(id)_"}"
		
		if (""=result)
		{
			s result=item
		}
		else
		{
			s result=result_","_item
		}
	}
	&sql(CLOSE curCategory)
	
	q:(""'=result) "["_result_"]"
	q result
}

ClassMethod GetEMRTemplateCategoryChapter(cateID As %String) As %String
{
	
    s result=""
	&sql(DECLARE curChapter CURSOR FOR 
			SELECT ID INTO :id FROM EMRmeta.EMRTemplateCategory 
			WHERE CategoryType ='CategoryChapter' AND ParentCategoryID = :cateID  
			ORDER BY CategorySeq)
	&sql(OPEN curChapter)
	for {
		&sql(FETCH curChapter)
		q:(SQLCODE)
		
		s obj=##Class(EMRmeta.EMRTemplateCategory).%OpenId(id)
		s item="{'id':"_id_",'text':'"_obj.CategoryName_"','state':'open'}"
		
		if (""=result)
		{
			s result=item
		}
		else
		{
			s result=result_","_item
		}
	}
	&sql(CLOSE curChapter)
	
	q:(""'=result) ",'children':["_result_"]"
	q result
}

/// 将目录类型转化为节点ID前缀
ClassMethod TransCategoryType(argCategoryType) As %String
{
	q:((argCategoryType="") || ($d(argCategoryType)=0)) ""
	
	set resultType = ""
	if (argCategoryType="Category")
	{
		s resultType = "CG"
	}
	elseif (argCategoryType="CategoryChapter")
	{
		s resultType = "CC"
	}
	elseif (argCategoryType="TempCate")
	{
		s resultType = "TC"
	}
	elseif (argCategoryType="PrtTemplate") 
	{
		s resultType = "LF"
	}
	elseif (argCategoryType="PhotoScan")
	{
		s resultType = "PS"
	}else
	{
		s resultType = "CG"
	}
	
	q resultType
}

/// CreateUser: guozongtao
/// CreateDate: 2014-01-07
/// Desc: 获取绑定打印模板的类型
/// Input：argEPRTemplateCategoryId: PrtTemplate或TempCate类型的EPRmeta.EPRTemplateCategory记录rowid
/// Output: 绑定打印模板的类型，共三种情况
/// 			Single 		唯一打印模板
/// 			Multiple 	可重复打印模板
/// 			""			未绑定任何类型打印模板
/// Debug: w ##class(EMRservice.BLEMRTemplateCategory).GetBindPrtTemplateType("43")
ClassMethod GetBindPrtTemplateType(argEPRTemplateCategoryId) As %String
{
	q:(argEPRTemplateCategoryId="") ""
	
	s objEPRTemplateCategory = ##class(EMRmeta.EMRTemplateCategory).%OpenId(argEPRTemplateCategoryId)
	q:(objEPRTemplateCategory="") ""
	
	s bindPrtTemplateId = objEPRTemplateCategory.BindPrnTemplateID
	q:(bindPrtTemplateId="") ""
	
	s objPrtTemplate = ##class(EPRmeta.PrintTemplate).%OpenId(bindPrtTemplateId)
	q:(objPrtTemplate="") ""
	
	q objPrtTemplate.ChartItemType
}

/// CreateTime: 2015-05-01
/// CreateUser: flc
/// Desc: 根据父节点类型获取其下所有PrtTemplate类型的节点
/// Input: 	parentCategoryId: Category类型父节点Id
/// 			parentCategoryChapterId：CategoryChapter类型父节点Id
/// Return：PrtTemplate类型的节点rowid序列，rowid1^rowid2^rowid3
/// Debug: w ##class(EMRservice.BL.BLEMRTemplateCategory).GetSubPrtTemplateCategory("1","50")
ClassMethod GetSubPrtTemplateCategory(parentCategoryId As %String, parentCategoryChapterId As %String) As %String
{
	q:(($d(parentCategoryId)=0)||($d(parentCategoryChapterId)=0)) ""
	q:((parentCategoryId="")&&(parentCategoryChapterId="")) ""
	
	s retValue = ""
	s parentIDs = ""
	
	//取CategoryChapter类型节点Id
	if (parentCategoryChapterId '= "")
	{	s parentIDs = parentCategoryChapterId}
	else
	{	
		s rowid = ""
		
		&sql( declare myCursor cursor for
		select ID into :rowid from EMRmeta.EMRTemplateCategory 
		where  ParentCategoryID = :parentCategoryId and CategoryType = 'CategoryChapter')
	
		&sql(open myCursor)
		for {
			&sql(fetch myCursor)
			q:SQLCODE
			
			if parentIDs = ""
			{	s parentIDs = rowid}
			else
			{	s parentIDs = parentIDs_"^"_rowid}
		}
		
		&sql(close myCursor)
	}
	
	q:(parentIDs="") ""
	
	for i=1:1:$L(parentIDs,"^")
	{
		s parentID = $P(parentIDs,"^",i)
		s rowid = ""
		&sql( declare myCursor2 cursor for
			select ID into :rowid from EMRmeta.EMRTemplateCategory 
			where  ParentCategoryID = :parentID and CategoryType = 'TempCate')
		
		&sql(open myCursor2)
		for {
			&sql(fetch myCursor2)
			q:SQLCODE
			
			if retValue = ""
			{	s retValue = rowid}
			else
			{	s retValue = retValue_"^"_rowid}
		}
		
		&sql(close myCursor2)
	}
	
	q retValue
}

/// Desc:		获取病历展现结构-病历模板目录树
/// Creator:	Lina
/// CreateDate:	2016-12-15
/// OutPut:		CategoryId   目录CategoryId
/// 			CategoryName 目录名称
///             CategoryType 目录节点类型
/// Debug: 		w ##Class(EMRservice.BL.BLEMRTemplateCategory).GetAllCategory()
ClassMethod GetAllCategory() As %GlobalBinaryStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	s cjson = ##Class(%GlobalCharacterStream).%New()
	s count = 0
	s parentCategoryID = ""
	for
	{
		s parentCategoryID = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_parentCategoryID))
		q:(parentCategoryID = "")
		s parentCategoryID = $tr(parentCategoryID," ","")
		s seq = ""
		for 
		{
			s seq = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_parentCategoryID,seq))
			q:(seq = "")
			s rowId = ""
			for
			{
				s rowId = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_parentCategoryID,seq,rowId))
				q:(rowId = "")
				s objCatergory = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(rowId)
				continue:(objCatergory = "")
				continue:(objCatergory.CategoryType '= "Category")
				s cjson = ..GetChildTemplateByParentCategoryID(rowId)
				continue:(cjson.Size = 0)
				d:(count '= 0) json.Write(",")
				d json.Write("{")
				d json.Write("""CategoryId"":"""_rowId_"""")
				d json.Write(",""CategoryName"":"""_objCatergory.CategoryName_"""")
				d json.Write(",""CategoryType"":"""_objCatergory.CategoryType_"""")
				d json.Write(",""child"":[")
				d json.CopyFrom(cjson)
				d json.Write("]")
				d json.Write("}")
				s count = count + 1
			}
		}
	}
	q json
}

/// Desc:		按父节点ID取挂靠的目录
/// Creator:	Lina
/// CreateDate:	2016-12-15
/// InPut:      AParentCategoryID   父节点ID
/// OutPut:		CategoryId   目录CategoryId
/// 			CategoryName 目录名称
///             CategoryType 目录节点类型
/// Debug: 		w ##Class(EMRservice.BL.BLEMRTemplateCategory).GetChildTemplateByParentCategoryID(3)
ClassMethod GetChildTemplateByParentCategoryID(AParentCategoryID As %String) As %GlobalBinaryStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	s cjson = ##Class(%GlobalCharacterStream).%New()
	q:(AParentCategoryID = "") json
	s count = 0
	s seq = ""
	for
	{
		s seq = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_AParentCategoryID,seq))
		q:(seq = "")
		s rowId = ""
		for
		{
			s rowId = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_AParentCategoryID,seq,rowId))
			q:(rowId = "")
			s objCatergory = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(rowId)
			if (objCatergory.CategoryType '= "TempCate")
			{
				s cjson = ..GetChildTemplateByParentCategoryID(rowId)
				continue:(cjson.Size = 0)
			}
			d:(count '= 0) json.Write(",")
			d json.Write("{")
			d json.Write("""CategoryId"":"""_rowId_"""")
			d json.Write(",""CategoryName"":"""_objCatergory.CategoryName_"""")
			d json.Write(",""CategoryType"":"""_objCatergory.CategoryType_"""")
			d:(cjson.Size '= 0) json.Write(",""children"":[")
			d:(cjson.Size '= 0) json.CopyFrom(cjson)
			d:(cjson.Size '= 0) json.Write("]")
			d json.Write("}")
			s count = count + 1
		}
	}
	q json
}

/// Desc:       根据AType类型以及查询时间返回病历目录列表
/// Creator:    Lina
/// CreateDate: 2016-12-15
/// Input:      ADocId     目录展现结构挂模板一层的目录Id
/// 			ATitleCode 标题Code
///             AStartDate 开始查询日期
///             AEndDate   结束查询日期
///             AType      查询时间类型,目前只有CreateDateTime一种类型
/// Output:     病历目录列表Json  
/// Debug:      w ##Class(EMRservice.BL.BLEMRTemplateCategory).GetRecordCatalogByDate(66,"EMR100001","2016-12-01","2016-12-15","CreateDateTime")
///             w ##Class(EMRservice.BL.BLEMRTemplateCategory).GetRecordCatalogByDate(58,"","2016-12-01","2016-12-15","CreateDateTime")
ClassMethod GetRecordCatalogByDate(ADocId As %String, ATitleCode As %String = "", AStartDate As %String, AEndDate As %String, AType As %String) As %GlobalBinaryStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	q:(ADocId = "")||(AStartDate = "")||(AEndDate = "")||(AType = "") json
	s count = 0
	s StartDate = $zdh(AStartDate,3)
	s EndDate=$zdh(AEndDate,3)
	for date = StartDate:1:EndDate
	{
		s time = ""
		for
		{
			s time = $o(^DHCEMRI.EMRLogsI("IdxCreateDateTime",date,time))
			q:(time = "")
			s EpisodeID = ""
			for
			{
				s EpisodeID = $o(^DHCEMRI.EMRLogsI("IdxCreateDateTime",date,time,EpisodeID))
				q:(EpisodeID = "")
				s EpisodeID = $tr(EpisodeID," ","")
				s EMRNum = ""
				for
				{
					s EMRNum = $o(^DHCEMRI.EMRLogsI("IdxCreateDateTime",date,time,EpisodeID,ADocId,EMRNum))
					q:(EMRNum = "")
					s EMRNum = $tr(EMRNum," ","")
					s ecrecordID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",EpisodeID,ADocId,""))
					q:(ecrecordID = "")
					s objRecord = ##Class(EMRinstance.ECRecord).%OpenId(ecrecordID)
					q:(objRecord = "")
					s rowId = ecrecordID_"||"_EMRNum
					s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(rowId)
					q:(objInstance = "")
					continue:(objInstance.Status '= "Save")
					continue:(objInstance.TitleCode '= ATitleCode)
					s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(ADocId)
					q:(objTemplate = "")
					s log = ##Class(EMRservice.BL.BLEMRLogs).GetLogStatus(objInstance.RealEpisodeID,ADocId,objInstance.ListNo)
					//患者姓名
					s PAPMIName = $p(^PAPER(objRecord.PatientID,"ALL"),"^",1)
					//性别
					s Sex=$P(^PAPER(objRecord.PatientID,"ALL"),"^",7)
					s PAPMISex=$P($g(^CT("SEX",Sex)),"^",2)
					//病案号
					s MedicareNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetMRNoByEpisodeID(EpisodeID)
					//科室
					s CtlocDesc = $p(^CTLOC($p(^PAADM(EpisodeID),"^",4)),"^",2)
					//就诊日期
					s PAADMAdmDate = $p(^PAADM(EpisodeID),"^",6)
					//就诊时间
					s PAADMAdmTime = $p(^PAADM(EpisodeID),"^",7)
					d:(count '= 0) json.Write(",")
					d RecordListJson
					s count = count + 1
				}
			}
		}
	}
	q json
RecordListJson
	d json.Write("{")
	d json.Write("""Id"":"""_rowId_"""")
	d json.Write(",""Title"":"""_objInstance.Title_"""")
	d json.Write(",""PatientId"":"""_objRecord.PatientID_"""")
	d json.Write(",""PAPMIName"":"""_PAPMIName_"""")
	d json.Write(",""PAPMISex"":"""_PAPMISex_"""")
	d json.Write(",""MedicareNo"":"""_MedicareNo_"""")
	d json.Write(",""CtlocDesc"":"""_CtlocDesc_"""")
	d json.Write(",""PAADMAdmDate"":"""_$zd(PAADMAdmDate,3)_"""")
	d json.Write(",""PAADMAdmTime"":"""_$zt(PAADMAdmTime)_"""")
	d json.Write(",""EpisodeId"":"""_EpisodeID_"""")
	d json.Write(",""ChartItemType"":"""_objTemplate.ChartItemType_"""")
	d json.Write(",""DocumentType"":"""_objTemplate.DocumentType_"""")
	d json.Write(",""EmrDocId"":"""_objRecord.RealChartItemID_"""")
	d json.Write(",""Characteristic"":"""_objRecord.DocumentCharacteristic_"""")
	d json.Write(",""CreateDate"":"""_$zd(objInstance.CreateDate,3)_"""")
	d json.Write(",""CreateTime"":"""_$zt(objInstance.CreateTime)_"""")
	d json.Write(",""Creator"":"""_$tr($p(log,"^",1)," ","")_"""")
	d json.Write(",""HappenDate"":"""_$zd(objInstance.HappenDate,3)_"""")
	d json.Write(",""HappenTime"":"""_$zt(objInstance.HappenTime)_"""")
	d json.Write(",""ModifyDate"":"""_$zd(objInstance.ModifyDate,3)_"""")
	d json.Write(",""ModifyTime"":"""_$zt(objInstance.ModifyTime)_"""")
	d json.Write(",""Status"":"""_$p(log,"^",11)_"""")
	d json.Write("}")
	q
}

ClassMethod GetChartItemTypeByDocID(ADocID As %String) As %String
{
	///docid下存在多个emrtemplate,默认为可重复模板配置
	///docid只存在唯一emrtemplate,验证BindTemplate为唯一模板。
	s ret=""
	s retList = ""
	s emrTemplateID=""
	for
	{
		s emrTemplateID=$o(^DHCEMRM.EMRTemplateI("IdxCategoryID"," "_ADocID,emrTemplateID))
		q:(emrTemplateID="")
		
		s objEMRTemplate=##class(EMRmeta.EMRTemplate).%OpenId(emrTemplateID)
		continue:(objEMRTemplate="")
		s bindTemplateID = objEMRTemplate.BindTemplateID

		s objTemplate = ##class(EMRmeta.Template).%OpenId(bindTemplateID)
		continue:(objTemplate="")
		
		s tmpChartItemType = objTemplate.ChartItemType
		
		s retList= retList_$lb(tmpChartItemType)
		
				
	}
	
	if ($ll(retList)>1)
	{
		s:($lf(retList,"Single")>0) ret="errorMsg:展现结构存在异常配置。"	
	}
	
	if (retList'="")
	{
		
		s ret=$list(retList,1)	
	}
	
	q ret
}

/// Desc:       根据模板批量添加病历展现
/// Creator:    yejian
/// CreateDate: 2021-6-15
/// Input:      argArr 模板集合，aParentID 目录ID，aInternalID 业务活动记录编码
/// OutPut:     返回值：成功 1，失败 -1
/// debug:		w ##class(EMRservice.BL.BLEMRTemplateCategory).AddTemps()
ClassMethod AddTemps(argArr As %ListOfDataTypes(ELEMENTTYPE="%String",MAXLEN="200"), aParentID As %String, aInternalID As %String) As %String
{
	s strRes = "-1"
	q:($d(aParentID)=0)||(aParentID="") strRes
	s ^AddTemps("1")=argArr
	TSTART 
	s key = ""
	s strMark = 1
	for
	{
		s strTemNames = argArr.GetNext(.key)
		s strTemID = $p(strTemNames,"^",1)
		s strTemName = $p(strTemNames,"^",2)
		q:(strTemID="")||(strTemName="")
		s hasTem = $o(^DHCEMRM.EMRTemplateI("IdxBindTemplateID"," "_strTemID,""))
		continue:(hasTem'="")
		s aEMRTemplateCategory=##class(EMRmeta.EMRTemplateCategory).%New()
		q:(aEMRTemplateCategory="")	  
		s aEMRTemplateCategory.CategoryName=strTemName
		s aEMRTemplateCategory.CategoryType="TempCate"
		s aEMRTemplateCategory.ParentCategoryID=aParentID
		s aEMRTemplateCategory.CategorySeq=+($g(^DHCEMRM.EMRTemplateCategoryD))+1
	 	s aEMRTemplateCategory.IsMutex="0"
	 	s aEMRTemplateCategory.IsLeadframe="0"
	 	s aEMRTemplateCategory.IsWaitsign="0"
	 	s aEMRTemplateCategory.ImageUrl=""
	 	s aEMRTemplateCategory.InternalID=aInternalID
	 	s aEMRTemplateCategory.FullFight=##class(EMRservice.Tools.Tool).GetCNCODE(strTemName,3,"")
	 	s aEMRTemplateCategory.JaneSpell=##class(EMRservice.Tools.Tool).GetCNCODE(strTemName,4,"")
		s sc=aEMRTemplateCategory.%Save()
		if '(sc)
		{
			TROLLBACK
			s strMark = 0
		    q
		}
		 s objBindTemplate = ##class(EMRmeta.Template).%OpenId(strTemID)
	    if (objBindTemplate="")
		{
			TROLLBACK
			s strMark = 0
		    q
		}
	    s bindCategoryId = objBindTemplate.TemplateCategoryID
		s aEMRTemplate=##class(EMRmeta.EMRTemplate).%New()
		q:(aEMRTemplate="")
		s aEMRTemplate.TemplateName=strTemName
		s aEMRTemplate.CategoryID=aEMRTemplateCategory.%Id()
		s aEMRTemplate.TemplateSeq=+($g(^DHCEMRM.EMRTemplateD))+1
		s aEMRTemplate.BindTemplateID=strTemID
		s aEMRTemplate.BindTemplateCategoryID=bindCategoryId
		s aEMRTemplate.NecessaryTemplate=""
		s aEMRTemplate.InternalID=""
		s temsc=aEMRTemplate.%Save()
		if '(temsc)
		{
			TROLLBACK
			s strMark = 0
		    q
		}
	}
	if (strMark = 0)
	{
		TROLLBACK
		q strRes
	 }
	TCOMMIT
	q "1"
}

/// w ##class(EMRservice.BL.BLEMRTemplateCategory).AddTemps("87","EMR070001")
ClassMethod test(aParentID As %String, aInternalID As %String) As %String
{
	s argArr= ##class(%ArrayOfDataTypes).%New()
	;d argArr.SetAt("202^了世纪东方了电饭锅里多发两个就离开多发两个家里的饭咖喱豆腐健康顾多了几分管理的锅里多发两个就离开多发两个家里的饭咖喱豆腐健康顾多了几分管理的老方工具东方国锅里多发两个就离开多发两个家里的饭咖喱豆腐健康顾多了几分管理的老方工具东方国，际多个了京东方际多个了京东方老方工具东方国际多个了京东方。","1")
	
 	;w ##class(EMRservice.BL.BLEMRTemplateCategory).AddTemps(argArr,aParentID,aInternalID)
 	
 	s one = ##class(EMRservice.entity.EAgreeDocIDList).%New()
 	s one.DocID="1^2^3"
 	s two = ##class(EMRservice.entity.EAgreeDocIDList).%New()
 	s two.DocID="4^5"
 	s pone = ##class(EMRservice.entity.EAgreeDocIDList).%New()
 	s pone.DocID="6"
 	d pone.NodeData.Insert(one)
 	s ptwo = ##class(EMRservice.entity.EAgreeDocIDList).%New()
 	s ptwo.DocID="7"
 	d ptwo.NodeData.Insert(two)
 	s pp = ##class(EMRservice.entity.EAgreeDocIDList).%New()
 	s pp.DocID="10"
 	d pp.NodeData.Insert(pone)
 	d pp.NodeData.Insert(ptwo)
 	w ..GetNodeDatas(pp)
}

ClassMethod GetNodeDatas(alist As EMRservice.entity.EAgreeDocIDList) As %String
{
	s docID = alist.DocID
	w docID
	for i=1:1:alist.NodeData.Count()
 	{
	 	s item = alist.NodeData.GetAt(i)
	 	s strStructID = ..GetNodeDatas(item)
 	}
 	q docID
}

}
