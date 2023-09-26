/// 门诊获取所有可查看的模板列表
/// 改造自 EMRservice.BL.BLClientCategory
Class EMRservice.BL.BLOPClientCategory Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter ACTIONVIEW = "READ";

/// Desc:       取配置前端目录展现病历目录 停用
/// EMRservice.BL.BLClientCategory GetCategory
/// Creator:    Candy
/// CreateDate: 2014-8-27
/// Input:      ACTLocID 用户登录科室
///            ASchemType 方案类型，在院取Running 出院取Archiveing
/// Debug d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLOPClientCategory","GetCategory",1,"Running")
Query GetCategory(ACTLocID As %String, ASchemType As %String) As %Query(ROWSPEC = "ItemID:%String,ItemTitle:%String,ItemImagePath:%String,ItemCategoryID:%String,ItemURL:%String,ItemParas:%String,ItemType:%String")
{
}

ClassMethod GetCategoryExecute(ByRef qHandle As %Binary, ACTLocID As %String, ASchemType As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	q:(ACTLocID = "")||(ASchemType = "") $$$OK
	s schemeId=""
	for {
		s schemeId = $o(^DHCEMRM.EMROrgSchemeLocI("IdxCTLocIDSchemeID"," "_ACTLocID,schemeId))
	
		q:(schemeId = "")
		s schemeId = $tr(schemeId," ","")
		s scheme=##Class(EMRmeta.EMROrganizationScheme).%OpenId(schemeId)
		q:(""=scheme)
 
		q:(scheme.SchemeName["门诊")
		s schemeId=" "_schemeId	
	}
	q:(""=schemeId) $$$OK
	s subTypeId = $o(^DHCEMRM.EMROrgSchemeTypeI("IdxSchemType"," "_$zcvt(ASchemType,"U"),schemeId,""))
	q:(subTypeId = "") $$$OK
	s seq = 0
	for
	{
		s seq = $o(^DHCEMRM.EMROrgSchemeDetailsI("IdxItemSeq",schemeId,subTypeId,seq))
		q:(seq = "")
		s subdetialId = $o(^DHCEMRM.EMROrgSchemeDetailsI("IdxItemSeq",schemeId,subTypeId,seq,""))
		continue:(subdetialId = "")
		s rowId = schemeId_"||"_subTypeId_"||"_subdetialId
		s objDetials = ##Class(EMRmeta.EMROrganizationSchemeDetails).%OpenId(rowId)
		continue:(objDetials = "")
		s itemId = objDetials.ItemDr
		s objItem = ##Class(EMRmeta.CTOrganizationSchemeItem).%OpenId(itemId)
		continue:(objItem = "")
		s type = $Case(objItem.EMRTemplateCategoryID,"":"HIS",:"EMR") 
		s data = $lb(itemId,objItem.ItemTitle,objItem.imagePath,objItem.EMRTemplateCategoryID,objItem.ItemURL,objItem.ItemParas,type)
		s ^CacheTemp(repid,ind) = data
		s ind=ind+1 		
	}		
	Quit $$$OK
}

ClassMethod GetCategoryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCategoryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCategoryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCategoryExecute ]
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

/// Input:		ACTLocId 科室ID
/// 			ASchemType 目录加载方案
/// 			AEpisodeID 就诊号
/// 			AUserID 用户ID
/// Output:     json
/// Debug: w ##Class(EMRservice.BL.BLOPClientCategory).GetTempCateJson(1, 32, 11411, 2062)
ClassMethod GetTempCateJson(ACTLocId, ASSGroupID, AEpisodeID, AUserID As %String) As %String
{
	s json = "",count = 0
	q:(ACTLocId = "")||(AEpisodeID = "")||(AUserID = "") json
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLClientCategory:GetCategory")
	d result.Execute(ACTLocId, ASSGroupID, AEpisodeID)
	while result.%Next()
	{
		s ItemType = result.Data("ItemType")
		continue:(ItemType = "HIS")
		s categoryId = result.Data("ItemCategoryID")
		
		s cjson = ..GetTempCateJsonByCategoryID(categoryId,AEpisodeID,AUserID)
		//w "ItemTitle:"_result.Data("ItemTitle"),!
		s:(count '= 0) json = json_","
		s json = json_"{"
		s json = json_"""id"":"""_categoryId_""""
		s json = json_",""text"":"""_result.Data("ItemTitle")_""""
		s json = json_",""childs"":["_cjson_"]"
		s json = json_"}" 
		s count = count + 1
	}
	s json = $ZSTRIP(json,"*C")
	q json
}

/// Input:      AParentId:目录CategoryId
///             AEpisodeID:就诊号
/// OutPut:     json    
/// d ##Class(EMRservice.BL.BLOPClientCategory).GetTempCateJsonByCategoryID(3,76,105)
ClassMethod GetTempCateJsonByCategoryID(AParentId As %String, AEpisodeID As %String, AUserID As %String) As %String
{
	s json = "",count = 0,flag = 0
	s jsonList = ##Class(%ListOfDataTypes).%New()
	q:((AParentId = "")||(AEpisodeID = "")) ""
	s priActivity = ..CheckTPrivActivity()  //权限控制
	s curPatInfo = ##class(EMRservice.DocRestLogic.PrivLogic).GetPatInfo(AEpisodeID,AUserID)
	s patDept = $p($li(curPatInfo,2),$c(2),2)
	s flag = ""
	s seq = ""
	for
	{
		s seq = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_AParentId,seq))
		q:(seq = "")
		s curCategoryId = ""
		for
		{
			s curCategoryId = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_AParentId,seq,curCategoryId))
			q:(curCategoryId = "")
			s objEMRTemplateCategory =##Class(EMRmeta.EMRTemplateCategory).%OpenId(curCategoryId)
			continue:(objEMRTemplateCategory.CategoryType '= "CategoryChapter")
	        s curCategoryName = objEMRTemplateCategory.CategoryName
	        s curIsMutex = objEMRTemplateCategory.IsMutex
	        s:(curIsMutex '= 1) curIsMutex = 0
	        continue:((flag = 1)&&(curIsMutex = 1))
	        s objEMRTemplateCategory = "" k objEMRTemplateCategory
			//初始化CategoryChapter节点时，不直接初始化CategoryChapter节点，而是直接初始化其下级中适用的挂靠界面模板的节点
			//即文档中说明的隐藏第二层
			s resultDocID =""
			//for
			//{
			//s curObjDocCategory = ..GetDocIDInChapter(AEpisodeID,"",curCategoryId,priActivity,curPatInfo,.resultDocID)
		
			//q:(curObjDocCategory = "")
			s curDocIDS = ..GetDocIDInChapter(AEpisodeID,"",curCategoryId,priActivity,curPatInfo,.resultDocID)
			continue:(curDocIDS = "")
			for i=1:1:$l(curDocIDS,"^")
			{
				s strDocID = $p(curDocIDS,"^",i)
				//根据DOCID获取属性对象
				s curObjDocCategory = ..GetEmrCategoryPropertyByDocID(strDocID)
				q:(curObjDocCategory = "")
				s curEMRTemplategoryID = $e(curObjDocCategory.ID,3,$l(curObjDocCategory.ID))  // CategoryType="TempCate"	
				q:(curEMRTemplategoryID = "")
				s curIsLeadframe = curObjDocCategory.IsLeadframe
				s curObjDocCategoryName = curObjDocCategory.Name
	        	s curObjDocCategory = ""  k curObjDocCategory
	        	s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(curEMRTemplategoryID)
		    	q:(objTemplate = "")
		    	s result = ##class(EMRservice.BL.BLInstanceData).IsHasInstance(AEpisodeID, objTemplate.ID,curEMRTemplategoryID)
				
				if ((result '= 0) && (objTemplate.ChartItemType = "Single"))
				{
					s:(curIsMutex = 1) flag = 1
					q
				}
				s quotationFlag = $d(^DHCEMRM.QuotationSchemeI("IdxCTLocIDDocID",patDept,curEMRTemplategoryID))
				s cjson = "{"
				s cjson = cjson_ """id"":"""_curEMRTemplategoryID_""""
				s cjson = cjson_ ",""text"":"""_curObjDocCategoryName_""""
				s cjson = cjson_ ",""attributes"":{" 
				s cjson = cjson_ """type"":""TempCate""" 
				s cjson = cjson_ ",""chartItemType"":"""_objTemplate.ChartItemType_"""" 
				s cjson = cjson_ ",""documentType"":"""_objTemplate.DocumentType_"""" 
				s cjson = cjson_ ",""isLeadframe"":"""_curIsLeadframe_""""
				s cjson = cjson_ ",""isMutex"":"""_curIsMutex_""""
				s cjson = cjson_",""templateId"":"""_objTemplate.ID_""""
				s cjson = cjson_",""quotation"":"""_$case(quotationFlag>0,1:1,:0)_""""
				s cjson = cjson_ "}"
				s cjson = cjson_ "}"
				d jsonList.Insert(curIsMutex_"^"_cjson)
			}
			//}
		}
	}
    s key = ""
    for
    {
	    s value = jsonList.GetNext(.key)
	    q:(key = "")
	    s curIsMutex = $p(value,"^",1)
	    continue:((flag = 1)&&(curIsMutex = 1))
	    s:(count '= 0) json = json_","
	    s json = json_$p(value,"^",2)
	    s count = count + 1
	}
	s json = $ZSTRIP(json,"*C")
    q json
}

/// Input: EpisodeID--病人就诊号;parOthers--用于扩展的信息串（未用）;parCategoryID--Chapter的ID； parPriActivity--是否开启了模板权限, parPatInfo--病人信息
/// Output:
/// Return: DocID(挂靠界面模板的目录)
ClassMethod GetDocIDInChapter(EpisodeID As %String, parOthers As %String, parCategoryID As %String, parPriActivity As %String, parPatInfo As %Library.List, resultDocID As %String) As %String
{
	 
	 s resultDocID = ..GetDocIDForView(EpisodeID, parOthers, parCategoryID, parPriActivity, parPatInfo, resultDocID)
	 q:(resultDocID = "") ""
	 q resultDocID
	 /*
	 s objEMRTemplateCategory=##Class(EMRmeta.EMRTemplateCategory).%OpenId(resultDocID)
	 s curCategoryType = objEMRTemplateCategory.CategoryType
 
     s objEEMRTemplateCategory = ##Class(EMRservice.entity.EEMRCategoryProperty).%New()
     s objEEMRTemplateCategory.ID = ##class(EMRservice.BOEMRTemplateCategory).TransCategoryType(curCategoryType)_resultDocID
     s objEEMRTemplateCategory.IsLeadframe = objEMRTemplateCategory.IsLeadframe
     s objEEMRTemplateCategory.IsMutex = objEMRTemplateCategory.IsMutex
     s objEEMRTemplateCategory.Name = objEMRTemplateCategory.CategoryName
	 //返回结果
	 q objEEMRTemplateCategory
	 */
}

/// Creator: yejian
/// CreatDate: 2020-5-22
/// Description：取出ChapterDoc节点下可用的DocID（即可用的TempCate的Doc）
/// 			 在构造病历结构树形时，处理ChapterDoc类型的节点，该类型的节点将被隐藏，其位置由TempCate类型的节点代替
/// Table:
/// Input: DocID(挂靠界面模板的目录)
/// Output:
/// Return: EMRservice.entity.EEMRCategoryProperty(挂靠界面模板的目录)
ClassMethod GetEmrCategoryPropertyByDocID(aDocID As %String) As EMRservice.entity.EEMRCategoryProperty
{
	 q:(aDocID = "") ""
	 
	 s objEMRTemplateCategory=##Class(EMRmeta.EMRTemplateCategory).%OpenId(aDocID)
	 s curCategoryType = objEMRTemplateCategory.CategoryType
	 s resultDocID = ##class(EMRservice.BOEMRTemplateCategory).TransCategoryType(curCategoryType)_aDocID
     s objEEMRTemplateCategory = ##Class(EMRservice.entity.EEMRCategoryProperty).%New()
     s objEEMRTemplateCategory.ID = resultDocID
     s objEEMRTemplateCategory.IsLeadframe = objEMRTemplateCategory.IsLeadframe
     s objEEMRTemplateCategory.IsMutex = objEMRTemplateCategory.IsMutex
     s objEEMRTemplateCategory.Name = objEMRTemplateCategory.CategoryName
	 //返回结果
	 q objEEMRTemplateCategory
}

ClassMethod CheckTPrivActivity() As %String
{
	//q "N"
	s ReturnValue = "N"
	s ReturnValue = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("TPRIVACTIVITY") 
	if ReturnValue '= "Y"
	{
		s ReturnValue = "N"
	}
	q ReturnValue
}

/// Input:       EpisodeID--病人就诊号;parOthers--用于扩展的信息串（未用）;parChapterDocID--Chapter的ID； parPriActivity--是否开启了模板权限, parPatInfo--病人信息
/// Output:
/// Return:      符合规则的DocID(打印模板 或 挂靠界面模板的目录)
ClassMethod GetDocIDForView(EpisodeID, parOthers, parChapterDocID, parPriActivity As %String, parPatInfo As %Library.List, resultDocID As %String) As %String
{
	 q:(($d(EpisodeID)=0) || (EpisodeID = "")) resultDocID
	 q:(($d(parChapterDocID)=0) || (parChapterDocID = "")) resultDocID
	 
	 //取出该Chapter的类型
	 set chartItemType = ##class(EMRservice.EMRDoc.DocCategoryFunSet).GetChapterDocType(parChapterDocID)
	 
	 //分开类型及是否保存过来处理
	 if (chartItemType = "Single")
	 {
		 //w "parChapterDocID:"_parChapterDocID,!
		 s resultDocID = ..GetSingleDocIDForView(EpisodeID, parOthers, parChapterDocID, parPriActivity, parPatInfo, resultDocID)
	 }
	 else
	 {
		 s resultDocID = ..GetMultipleDocIDForView(EpisodeID, parOthers, parChapterDocID, parPriActivity, parPatInfo, resultDocID)
	 }
	 
	 q resultDocID
}

ClassMethod GetSingleDocIDForView(EpisodeID, parOthers, parChapterDocID, parPriActivity As %String, parPatInfo As %Library.List, resultDocID As %String) As %String
{
	//根据权限规则开启情况，取当前可用的打印模板DocID
	if (parPriActivity = "Y")
	{
		//权限规则开启，取权限规则允许的第一个可用打印模板DocID
		s resultDocID = ..GetTempByCacAndAct(parPatInfo, parChapterDocID, ..#ACTIONVIEW, resultDocID)
	}
	else
	{
		//权限规则关闭，取该Chapter下第一个可用打印模板DocID
		//s resultDocID = ..GetDocID(parChapterDocID, resultDocID)
		//权限规则关闭，取该chapter下所有可以用的DocID
		s resultDocID = ..GetAllDocID(parChapterDocID)
	}
	
	q resultDocID
}

/// Return:      第一个符合规则的DocID(打印模板 或 挂靠界面模板的目录)
ClassMethod GetMultipleDocIDForView(EpisodeID, parOthers, parChapterDocID, parPriActivity As %String, parPatInfo As %Library.List, resultDocID As %String) As %String
{
	
	if (parPriActivity = "Y")
	{
		//权限开启时第一优先级: 取权限规则允许的第一个可用打印模板DocID
		s resultDocID = ..GetTempByCacAndAct(parPatInfo, parChapterDocID, ..#ACTIONVIEW, resultDocID)

	}
	else
	{
		//权限关闭时第一优先级：取该Chapter下第一个可用的打印模板DocID
		//s resultDocID = ..GetDocID(parChapterDocID, resultDocID)
		//权限规则关闭，取该chapter下所有可以用的DocID
		s resultDocID = ..GetAllDocID(parChapterDocID)
	}
	
	q resultDocID
}

ClassMethod GetTempByCacAndAct(parPatInfo As %Library.List, parChapterID, parAction, curDocId As %String) As %String
{
	q:(($d(parChapterID)=0) || (parChapterID = "")) ""
	q:(($d(parAction)=0) || (parAction = "")) ""
	 
	 //依次取出parChapterID下的DocID,取得第一个具有权限的DocID后返回
	 s resultDocId = ""
	 s curChapterId = " "_parChapterID
	 s curseq = ""
	 for
	 {
		 s curseq = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq",curChapterId,curseq))
		 q:(curseq = "")
		 s curDocId = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq", curChapterId,curseq, curDocId))
		 WHILE (curDocId '= "") 
		 {
			s curResult = ##Class(EMRservice.DocRestLogic.TempActLogic).CanTempAct(curDocId, parAction, parPatInfo)
		
			if (curResult = 1)
			{
				//s resultDocId = curDocId
				s resultDocId =  $case(resultDocId,"":curDocId,:resultDocId_"^"_curDocId)
				//quit
			}
			
	  		s curDocId = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq", curChapterId,curseq, curDocId))
		 }
	 }
	 q resultDocId
}

ClassMethod GetDocID(argCategoryChapterID, curDocID As %String) As %String
{
	s curDocID = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID", " "_argCategoryChapterID, curDocID))
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

ClassMethod GetTemplates(AEpisodeID, AUserID, AParentId As %String, ArrTemplate As %ArrayOfDataTypes)
{
	s json = "",count = 0,flag = 0
	s jsonList = ##Class(%ListOfDataTypes).%New()
	q:((AParentId = "")||(AEpisodeID = "")) ""
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	s priActivity = ..CheckTPrivActivity()  //权限控制
	s curPatInfo = ##class(EMRservice.DocRestLogic.PrivLogic).GetPatInfo(AEpisodeID,AUserID)
	s patDept = $p($li(curPatInfo,2),$c(2),2)
	s flag = ""
	s seq = ""
	for
	{
		s seq = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_AParentId,seq))
		q:(seq = "")
		s curCategoryId = ""
		for
		{
			s curCategoryId = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_AParentId,seq,curCategoryId))
			q:(curCategoryId = "")
			
			s objEMRTemplateCategory =##Class(EMRmeta.EMRTemplateCategory).%OpenId(curCategoryId)
			continue:(objEMRTemplateCategory.CategoryType '= "CategoryChapter")
	        s curCategoryName = objEMRTemplateCategory.CategoryName
	        s curCategoryName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.EMRTemplateCategory","CategoryName",objEMRTemplateCategory.CategoryName,langid)

	        s curIsMutex = objEMRTemplateCategory.IsMutex
	        s:(curIsMutex '= 1) curIsMutex = 0
	        continue:((flag = 1)&&(curIsMutex = 1))
	        s CategorySeq = objEMRTemplateCategory.CategorySeq
	        s objEMRTemplateCategory = "" k objEMRTemplateCategory
			//初始化CategoryChapter节点时，不直接初始化CategoryChapter节点，而是直接初始化其下级中适用的挂靠界面模板的节点
			//即文档中说明的隐藏第二层
			s resultDocID =""
			//for
			//{
			//s curObjDocCategory = ..GetDocIDInChapter(AEpisodeID,"",curCategoryId,priActivity,curPatInfo,.resultDocID)
		
			//q:(curObjDocCategory = "")
			s curDocIDS = ..GetDocIDInChapter(AEpisodeID,"",curCategoryId,priActivity,curPatInfo,.resultDocID)
			continue:(curDocIDS = "")
			for i=1:1:$l(curDocIDS,"^")
			{
				s strDocID = $p(curDocIDS,"^",i)
				//根据DOCID获取属性对象
				s curObjDocCategory = ..GetEmrCategoryPropertyByDocID(strDocID)
				q:(curObjDocCategory = "")
				s curEMRTemplategoryID = $e(curObjDocCategory.ID,3,$l(curObjDocCategory.ID))  // CategoryType="TempCate"	
				q:(curEMRTemplategoryID = "")
				s curIsLeadframe = curObjDocCategory.IsLeadframe
	        	s curObjDocCategory = ""  k curObjDocCategory
	        	s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(curEMRTemplategoryID)
		    	q:(objTemplate = "")
 				
 				s CategorySeq =..GetKey(CategorySeq,ArrTemplate)
				///d ArrTemplate.SetAt(curCategoryName, curEMRTemplategoryID)
				d ArrTemplate.SetAt(curEMRTemplategoryID_"^"_curCategoryName, CategorySeq)
			}
			//}
		}
	}
}

// 获取不重复的Key值

ClassMethod GetKey(key As %String, ArrTemplate As %ArrayOfDataTypes) As %String
{
 	for
 	{
	 	s idx = 1
	 	q:ArrTemplate.GetAt(key)="" 
	 	s key=key + idx
	}
	q key
}

/// w ##Class(EMRservice.BL.BLOPClientCategory).GetTemplateLst(1,"Running",8651,2062)
ClassMethod GetTemplateLst(ACTLocId, ASSGroupID, AEpisodeID, AUserID As %String, ACategoryID As %String = "") As %ArrayOfDataTypes
{
	s ArrTemplate = ##Class(%ArrayOfDataTypes).%New()
	q:(ACTLocId = "")||(AEpisodeID = "")||(AUserID = "") ArrTemplate
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLClientCategory:GetCategory")
	d result.Execute(ACTLocId, ASSGroupID, AEpisodeID)
 
	while result.%Next()
	{
		s ItemType = result.Data("ItemType")
		
		continue:(ItemType = "HIS")
		s categoryId = result.Data("ItemCategoryID")
		// 配置门诊病历页面传入病历导航分类目录CategoryID用于过滤模板数据
		continue:((ACategoryID '= "")&&(ACategoryID '= categoryId))
		d ..GetTemplates(AEpisodeID, AUserID, categoryId, .ArrTemplate)
		 		
	}	
		
	q ArrTemplate
}

/// w ##Class(EMRservice.BL.BLOPClientCategory).GetTemplateClassify(11411,1, 2062, 32)
ClassMethod GetTemplateClassify(episodeId, userLocId, userId, ssgroup As %String) As %Stream
{
	s Streamtmp = ##Class(%GlobalCharacterStream).%New()
	s Jsontmp = ##Class(%GlobalCharacterStream).%New()
	s ret = ""
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	
	s ArrTemplate = ##Class(EMRservice.BL.BLOPClientCategory).GetTemplateLst(userLocId,ssgroup,episodeId,userId)
 
	//处理门诊病历分类
	s jRet = ##Class(EMRservice.BL.BLTemplateClassify).GetTemplateClassifyTree("CTLOC"_userLocId, .ArrTemplate)
	s key = ""
	s arrTmp = ##Class(%ArrayOfDataTypes).%New()
	while (1)
	{
		s key = ArrTemplate.Next(key)
		q:(key="")
 
 		s modelInstance = ""
 		s curEMRCateId = $P(ArrTemplate.GetAt(key),"^",1)
 		s txt = $P(ArrTemplate.GetAt(key),"^",2)
 		s FPinyin = ##class(web.DHCINSUPort).GetCNCODE($tr(txt," ",""),4,"")
 		
		s TempCate = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(curEMRCateId)
		s Chapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(TempCate.ParentCategoryID)
		s Category = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(Chapter.ParentCategoryID)
		s DociDName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.EMRTemplateCategory","CategoryName",TempCate.CategoryName,langid)
		s ret=arrTmp.GetAt(Category.CategorySeq)

		s item="{""id"":"""_curEMRCateId_""",""text"":"""_DociDName_""",""attributes"":{""py"":"""_FPinyin_"""}}"
		d arrTmpSetAt
	}
	s ret=""
	s key = 0
	
	d Jsontmp.Write("[{""id"":"""",""text"":""病历模板"",""children"":[")
	
	while (1)
	{
		s key = arrTmp.Next(key)
		q:(key="")
		s item=arrTmp.GetAt(key)
		if (Streamtmp.Size = 0){
			d Streamtmp.Write(item)
		}else{ 
			d Streamtmp.Write("]},")
			d Streamtmp.Write(item)
		}
	}	
		
	
	if (Streamtmp.Size '= 0) {d Streamtmp.Write("]}")}
	
	if (jRet.Size '= 0)
	{
		if (Streamtmp.Size = 0) { d Streamtmp.CopyFrom(jRet) }
		else { d Streamtmp.Write(",")
			   d Streamtmp.CopyFrom(jRet)}
	}
	
	d Jsontmp.CopyFrom(Streamtmp)
	d Jsontmp.Write("]}]")
	
 	q Jsontmp
	
arrTmpSetAt
	
	s categoryName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.EMRTemplateCategory","CategoryName",Category.CategoryName,langid)
	if (ret="")
	{
		s ret = "{""id"":"""_Category.%Id()_""",""text"":"""_categoryName_""",""children"":["
		s item=ret_item
	} 
	else
	{
		s item=ret_","_item		
	}
	d arrTmp.SetAt(item,Category.CategorySeq)
	q
}

/// w ##Class(EMRservice.BL.BLOPClientCategory).GetEMRTemplateID("52","28","328","2543","114")
ClassMethod GetEMRTemplateID(AEpisodeId As %String, AUserID As %String, ACTLocId As %String, ASSgroupId As %String, emrTmplCateIdGroup As %String) As %String
{
	s json = "",Aresult = "0"
	q:(ACTLocId = "")||(AEpisodeId = "")||(ASSgroupId = "")||(AUserID = "")||(emrTmplCateIdGroup = "") result
	
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLClientCategory:GetCategory")
	d result.Execute(ACTLocId,ASSgroupId,AEpisodeId)
	while result.%Next()
	{
		s ItemType = result.Data("ItemType")
		continue:(ItemType = "HIS")
		s categoryID = result.Data("ItemCategoryID")
		s docIds = ..GetDocIdsByParent(categoryID,AEpisodeId,AUserID)
		continue:(docIds = "")
		for I=1:1:$l(docIds,"^")
		{
			s docId = $p(docIds,"^",I)
		    s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(docId)
		    continue:(objTemplate = "")
		    s:(json'="") json = json_"^"
			s json = json_docId	
		}
	}
	q:(json = "") Aresult
	for J=1:1:$l(emrTmplCateIdGroup,"^")
	{
		s emrTmplCateId = $P(emrTmplCateIdGroup,"^",J)
		i (("^"_json_"^")[("^"_emrTmplCateId_"^"))
		{
			s Aresult = emrTmplCateId
			q
		}
	}
	q Aresult
}

ClassMethod GetDocIdsByParent(AParentId As %String, AEpisodeID As %String, AUserID As %String) As %String
{
	s json = "",count = 0,flag = 0,cjson = ""
	s jsonList = ##Class(%ListOfDataTypes).%New()
	q:((AParentId = "")||(AEpisodeID = "")) ""
	s priActivity = ..CheckTPrivActivity()  //权限控制
	s curPatInfo = ##class(EMRservice.DocRestLogic.PrivLogic).GetPatInfo(AEpisodeID,AUserID)
	s patDept = $p($li(curPatInfo,2),$c(2),2)
	s flag = ""
	s seq = ""
	for
	{
		s seq = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_AParentId,seq))
		q:(seq = "")
		s curCategoryId = ""
		for
		{
			s curCategoryId = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_AParentId,seq,curCategoryId))
			q:(curCategoryId = "")
			s objEMRTemplateCategory =##Class(EMRmeta.EMRTemplateCategory).%OpenId(curCategoryId)
			continue:(objEMRTemplateCategory.CategoryType '= "CategoryChapter")
	        s curCategoryName = objEMRTemplateCategory.CategoryName
	        s curIsMutex = objEMRTemplateCategory.IsMutex
	        s:(curIsMutex '= 1) curIsMutex = 0
	        continue:((flag = 1)&&(curIsMutex = 1))
	        s objEMRTemplateCategory = "" k objEMRTemplateCategory
			//初始化CategoryChapter节点时，不直接初始化CategoryChapter节点，而是直接初始化其下级中适用的挂靠界面模板的节点
			//即文档中说明的隐藏第二层
			s resultDocID =""
			//for
			//{
			//s curObjDocCategory = ..GetDocIDInChapter(AEpisodeID,"",curCategoryId,priActivity,curPatInfo,.resultDocID)

			//q:(curObjDocCategory = "")
			s curDocIDS = ..GetDocIDInChapter(AEpisodeID,"",curCategoryId,priActivity,curPatInfo,.resultDocID)
			continue:(curDocIDS = "")
			for i=1:1:$l(curDocIDS,"^")
			{
				s strDocID = $p(curDocIDS,"^",i)
				//根据DOCID获取属性对象
				s curObjDocCategory = ..GetEmrCategoryPropertyByDocID(strDocID)
				q:(curObjDocCategory = "")
				s curEMRTemplategoryID = $e(curObjDocCategory.ID,3,$l(curObjDocCategory.ID))  // CategoryType="TempCate"	
				q:(curEMRTemplategoryID = "")
				s curIsLeadframe = curObjDocCategory.IsLeadframe
	        	s curObjDocCategory = ""  k curObjDocCategory
	        	s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(curEMRTemplategoryID)
		    	q:(objTemplate = "")
				s quotationFlag = $d(^DHCEMRM.QuotationSchemeI("IdxCTLocIDDocID",patDept,curEMRTemplategoryID))
				s:(json '="") json = json_"^"
				s json = json_curEMRTemplategoryID
			}
			//}
		}
	}
    q json
}

/// Desc:       科室模板与基础模板
/// Input:      argEpisodeID 就诊ID
///            userLocId 用户所在科室ID
///            userId 用户ID
///            ssgroup 用户所在安全组ID
/// Debug:      w ##Class(EMRservice.BL.BLOPClientCategory).GetTemplateClassifyForHISUI(11411,1, 2062, 32)
ClassMethod GetTemplateClassifyForHISUI(argEpisodeID As %String, argUserLocID As %String, argUserID As %String, argSsgroup As %String, argCategoryID As %String = "") As %Stream
{
	s Jsontmp = ##Class(%GlobalCharacterStream).%New()
	q:(argUserID = "")||(argEpisodeID = "")||(argUserLocID = "")||(argSsgroup = "") Jsontmp
	s Streamtmp = ##Class(%GlobalCharacterStream).%New()
	s ret = ""
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	s tempLocId = argUserLocID
	s tempGroupId = argSsgroup
	s specialLocIds = ##Class(EMRservice.SystemParameter).GetSpecialLocId()
	s locFlag = "0"
	for i=1:1:$l(specialLocIds,"^")
	{
		s specialLocId = $p(specialLocIds,"^",i)
		if (argUserLocID = specialLocId)
		{
			s locFlag = "1"
			q
		}
	}
	if (locFlag = "1")
	{
		s tempLocId = $p($g(^SSU("SSUSR",argUserID)),"^",4)
		s tempGroupId = $p($g(^SSU("SSUSR",argUserID)),"^",5)
	}
	s ArrTemplate = ##Class(EMRservice.BL.BLOPClientCategory).GetTemplateLst(tempLocId,tempGroupId,argEpisodeID,argUserID,argCategoryID)
 
	//处理门诊病历分类--HISUI采用科室模板方式进行文件夹排序
	//s jRet = ##Class(EMRservice.BL.BLTemplateClassify).GetTemplateClassifyTree("CTLOC"_argUserLocID, .ArrTemplate)
	s key = ""
	s arrTmp = ##Class(%ArrayOfDataTypes).%New()
	while (1)
	{
		s key = ArrTemplate.Next(key)
		q:(key="")
 
 		s modelInstance = ""
 		s curEMRCateId = $P(ArrTemplate.GetAt(key),"^",1)
 		s txt = $P(ArrTemplate.GetAt(key),"^",2)
 		s FPinyin = ##class(web.DHCINSUPort).GetCNCODE($tr(txt," ",""),4,"")
 		
		s TempCate = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(curEMRCateId)
		s Chapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(TempCate.ParentCategoryID)
		s Category = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(Chapter.ParentCategoryID)
		s DociDName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.EMRTemplateCategory","CategoryName",TempCate.CategoryName,langid)
		s ret=arrTmp.GetAt(Category.CategorySeq)
        s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(curEMRCateId)
        s templateVersionId = ##Class(EMRservice.BL.BLTemplateVersion).GetMaxPubVrnID(objTemplate.ID)
        if (objTemplate.ChartItemType = "Multiple")
        {
            s defaultTitleCode = ##Class(EMRservice.BL.BLTitleConfig).GetDefaultLoadTitleCode(curEMRCateId,tempLocId,"",objTemplate.ID)
            if (defaultTitleCode = "")
            {
                s:(TempCate.IsLeadframe = "1") templateVersionId = "isGuideBox"
            }elseif (defaultTitleCode '= objTemplate.Code)
            {
                s EMRTemplateID = $tr($o(^DHCEMRM.TitleConfigI("IdxCategoryTitleCodeTemplate"," "_TempCate.ParentCategoryID," "_defaultTitleCode,""))," ","")
                s objEMRTemplate = ##Class(EMRmeta.EMRTemplate).%OpenId(EMRTemplateID)
                s templateVersionId = ##Class(EMRservice.BL.BLTemplateVersion).GetMaxPubVrnID(objEMRTemplate.BindTemplateID)
            }
        }
		
        s userTemplate = ##class(EMRservice.BL.BLUserTemplate).GetUserTemplateJsonForHISUI(tempLocId,curEMRCateId,argEpisodeID,"","",argUserID)
		s item = ##Class(%GlobalCharacterStream).%New()
		if (userTemplate.Size = 0)
		{
            d item.Write("{""id"":"""_curEMRCateId_""",""text"":"""_DociDName_""",""iconCls"":""icon-base-word"",""attributes"":{""nodeType"":""template"",""py"":"""_FPinyin_""",""TemplateVersionId"":"""_templateVersionId_""",""TemplateID"":"""_objTemplate.ID_""",""documentType"":"""_objTemplate.DocumentType_""",""chartItemType"":"""_objTemplate.ChartItemType_"""}")
            d item.Write(",""children"":[")
            d item.CopyFrom(userTemplate)
            d item.Write("]")
		}
		else
		{
            d item.Write("{""id"":"""_curEMRCateId_""",""text"":"""_DociDName_""",""iconCls"":"""",""attributes"":{""nodeType"":""template"",""py"":"""_FPinyin_""",""TemplateID"":"""_objTemplate.ID_""",""chartItemType"":"""_objTemplate.ChartItemType_"""}")
			d item.Write(",""children"":[")
            d item.Write("{""id"":"""_curEMRCateId_""",""text"":"""_DociDName_""",""iconCls"":""icon-base-word"",""attributes"":{""nodeType"":""template"",""py"":"""_FPinyin_""",""TemplateVersionId"":"""_templateVersionId_""",""TemplateID"":"""_objTemplate.ID_""",""documentType"":"""_objTemplate.DocumentType_""",""chartItemType"":"""_objTemplate.ChartItemType_"""}}")
			d item.Write(",")
			d item.CopyFrom(userTemplate)
			d item.Write("]")
		}
		
		d item.Write("}")
		d arrTmpSetAt
	}
	s ret = ""
	s key = 0
	
	d Jsontmp.Write("[{""id"":"""",""text"":""病历模板"",""iconCls"":""user-folder-open"",""attributes"":{""nodeType"":""flod""},""children"":[")
	
	while (1)
	{
		s key = arrTmp.Next(key)
		q:(key="")
		s item=arrTmp.GetAt(key)
		if (Streamtmp.Size = 0){
			d Streamtmp.CopyFrom(item)
		}else{ 
			d Streamtmp.Write("]},")
			d Streamtmp.CopyFrom(item)
		}
	}	
		
	
	if (Streamtmp.Size '= 0) {d Streamtmp.Write("]}")}
	d Jsontmp.CopyFrom(Streamtmp)
	d Jsontmp.Write("]}]")
	
 	q Jsontmp
	
arrTmpSetAt
	s categoryName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.EMRTemplateCategory","CategoryName",Category.CategoryName,langid)
	if (ret="")
	{
		s ret = "{""id"":"""_Category.%Id()_""",""text"":"""_categoryName_""",""iconCls"":""user-folder-open"",""attributes"":{""nodeType"":""flod""},""children"":["
		s item2 = ##Class(%GlobalCharacterStream).%New()
		d item2.Write(ret)
		d item2.CopyFrom(item)
	} 
	else
	{
		s item2 = ##Class(%GlobalCharacterStream).%New()
		d item2.CopyFrom(ret)
		d item2.Write(",")
		d item2.CopyFrom(item)	
	}
	d arrTmp.SetAt(item2,Category.CategorySeq)
	q
}

/// Desc:       科室模板与基础模板
/// Input:      argEpisodeID 就诊ID
///            userLocId 用户所在科室ID
///            userId 用户ID
///            ssgroup 用户所在安全组ID
/// Debug:      w ##Class(EMRservice.BL.BLOPClientCategory).GetTemplateClassifyForHISUINew("1148","64","18881","28","46").Read()
ClassMethod GetTemplateClassifyForHISUINew(argEpisodeID As %String, argUserLocID As %String, argUserID As %String, argSsgroup As %String, argCategoryID As %String = "") As %Stream
{
	s Jsontmp = ##Class(%GlobalCharacterStream).%New()
	q:(argUserID = "")||(argEpisodeID = "")||(argUserLocID = "")||(argSsgroup = "") Jsontmp
	s Streamtmp = ##Class(%GlobalCharacterStream).%New()
	s ret = ""
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	s tempLocId = argUserLocID
	s tempGroupId = argSsgroup
	s specialLocIds = ##Class(EMRservice.SystemParameter).GetSpecialLocId()
	s locFlag = "0"
	for i=1:1:$l(specialLocIds,"^")
	{
		s specialLocId = $p(specialLocIds,"^",i)
		if (argUserLocID = specialLocId)
		{
			s locFlag = "1"
			q
		}
	}
	if (locFlag = "1")
	{
		s tempLocId = $p($g(^SSU("SSUSR",argUserID)),"^",4)
		s tempGroupId = $p($g(^SSU("SSUSR",argUserID)),"^",5)
	}
    
 	d Jsontmp.Write("[{""id"":"""",""text"":""病历模板"",""iconCls"":""user-folder-open"",""attributes"":{""nodeType"":""flod""},""children"":[")
	s Jsontmp2 = ##Class(%GlobalCharacterStream).%New()
 	
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLClientCategory:GetCategory")
	d result.Execute(tempLocId, tempGroupId, argEpisodeID)
	while result.%Next()
	{
		s ItemType = result.Data("ItemType")
		
		continue:(ItemType = "HIS")
		s categoryId = result.Data("ItemCategoryID")
		
		continue:((argCategoryID '= "")&&(argCategoryID '= categoryId))
		s Streamtmp = ..GetTempCateAgreeJsonByCategoryID(categoryId,argEpisodeID,argUserID,tempLocId)
        
        continue:(Streamtmp.Size < 1)
        
		if (Jsontmp2.Size '= 0) {d Jsontmp2.Write(",")}
		d Jsontmp2.CopyFrom(Streamtmp)		
	}	
	d Jsontmp.CopyFrom(Jsontmp2)
	d Jsontmp.Write("]}]")
	q Jsontmp
}

/// Desc:       知情同意书模板目录
/// Modify:     yejian
/// DateTime:   2021-6-16
/// Input:      AParentId:目录CategoryId
///             AEpisodeID:就诊号
/// 			AUserID:用户ID
/// 			AResultType:展现类型，卡片 "",列表 "List"
/// 			AEventType:事件类型
/// 			AEventID:事件ID
/// 			ACTLocId:本科ID
/// 			ADocId:docID
/// 			AOtherCTLocId:其他科室ID，所有 "ALL"
/// 			pText:搜索条件
/// OutPut:     json   
/// Debug:      w ##Class(EMRservice.BL.BLClientCategory).GetTempCateAgreeJsonByCategoryID(6,5,10209,"List")
ClassMethod GetTempCateAgreeJsonByCategoryID(AParentID As %String, AEpisodeID As %String, AUserID As %String, ACTLocId As %String = "") As %GlobalCharacterStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	s priActivity = ..CheckTPrivActivity()  //权限控制	
	s strdocIds = ""
	s curPatInfo = ##class(EMRservice.DocRestLogic.PrivLogic).GetPatInfoByCT(AEpisodeID,AUserID,ACTLocId)
	s patDept = $p($li(curPatInfo,2),$c(2),2)

	s strdocIds = ##class(EMRservice.BL.BLClientCategory).GetDocByCategoryID(AParentID,AEpisodeID,AUserID,priActivity,curPatInfo)
	q:(strdocIds="&") json
	q:((AParentID = "")||(AEpisodeID = "")) json
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	s mutexdoc = $p(strdocIds,"&",1)
	s nomutexdoc = $p(strdocIds,"&",2)
	s strdocIds = mutexdoc_"^"_nomutexdoc
	s key = $i(^CacheTemp("GetTempCateJsonByCategoryID"))
	for i=1:1:$l(strdocIds,"^")
	{
		s docId = $p(strdocIds,"^",i)
		continue:(docId = "")
		//continue:((ADocId '= "")&&(ADocId '= docId))

		s objdoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
        continue:(objdoc = "")
		s objchapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objdoc.ParentCategoryID)
		continue:(objchapter = "")
		s objcategory = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objchapter.ParentCategoryID)
		continue:(objcategory = "")
		s docCategoryName = objdoc.CategoryName
		s docJaneSpell = objdoc.JaneSpell
	    s docFullFight = objdoc.FullFight
		
		s JaneSpell = objchapter.JaneSpell
	    s FullFight = objchapter.FullFight
		
		s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(docId)
	    continue:(objTemplate = "")
	    
	    s objEMRTemplateCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
	    set EMRChartItemType = ##class(EMRservice.EMRDoc.DocCategoryFunSet).GetChapterDocType(objEMRTemplateCategoryDoc.ParentCategoryID)
	
	    s result = ##class(EMRservice.BL.BLInstanceData).IsHasInstance(AEpisodeID, objTemplate.ID,docId)
		s quotationFlag = ##Class(EMRservice.BL.BLQuotation).GetDocQuationFlag(patDept,docId) 
		s displayFlag = ##Class(EMRservice.SystemParameter).SetNavQuoteDisplay(AEpisodeID)
		s:(displayFlag = "N") quotationFlag = "0"
		s title = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.EMRTemplateCategory","CategoryName",objchapter.CategoryName,langid)
		s docidText = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.EMRTemplateCategory","CategoryName",objdoc.CategoryName,langid)
	    d DisplayInList 


		s cjson = $ZSTRIP(cjson,"*C")
		s ^CacheTemp("GetTempCateJsonByCategoryID",key,i)= cjson
		s ^CacheTemp("GetTempCateJsonByCategoryID",key,"Seq",i,docId)= i
		s ^CacheTemp("GetTempCateJsonByCategoryID",key,"Flag",docId) = i
	}

	//知情告知书目录结构通过模板树获取
	;s tempJson = ..GetGroupTemplate(patDept,"CG"_AParentID,key)
	s tempJson = ..GetGroupAgreeTemplate(key)
	d json.CopyFrom(tempJson)

	s seq = ""
	for
	{
		s seq = $o(^CacheTemp("GetTempCateJsonByCategoryID",key,seq))
		q:(seq = "")||(seq = "Flag")
		d:(json.Size >0) json.Write(",")
		d json.Write(^CacheTemp("GetTempCateJsonByCategoryID",key,seq))
	}
	k ^CacheTemp("GetTempCateJsonByCategoryID",key)
    q json

DisplayInList  
	s text = $s(((EMRChartItemType'="Multiple")||(objdoc.IsLeadframe=0)):docidText,1:title)
	s py = ##class(web.DHCINSUPort).GetCNCODE($tr(text," ",""),4,"")
	s cjson = "{"
	s cjson = cjson_ """id"":"""_docId_""""
	s cjson = cjson_ ",""text"":"""_text_""""
	s cjson = cjson_ ",""iconCls"":"""_"icon-base-word"_""""
	s cjson = cjson_ ",""attributes"":{" 
	s cjson = cjson_ """nodeType"":""template""" 
	s cjson = cjson_ ",""documentType"":"""_objTemplate.DocumentType_"""" 
	s cjson = cjson_ ",""py"":"""_py_"""" 
	s cjson = cjson_ ",""TemplateVersionId"":"""_objTemplate.PublishVersion_"""" 
	s cjson = cjson_ "}"
	s cjson = cjson_ ",""children"":"_"[]"_"" 
	s cjson = cjson_ "}"
	q
}

/// Desc:      按模板目录结构，显示知情告知结构
/// Creator:    yejian
/// CreateDate: 2018-3-9
/// Input:      ALocID 科室ID
///            AParentID 父节点
///            AKey 临时global节点位置
/// Output:     模板目录json流
/// Debug:      s json = ##Class(EMRservice.BL.BLEMRTemplateDocGroup).GetGroupAgreeTemplate(3)
/// 			d json.OutputToDevice()
ClassMethod GetGroupAgreeTemplate(AKey As %String) As %GlobalBinaryStream
{
	s jsonStream = ##Class(%GlobalBinaryStream).%New()
	s gourpArr = ##class(%ArrayOfDataTypes).%New()
	s tmpDocId = ""
	s tJsons = ""
	s intSeq =0
	s intCategoryID = 0
	s docGroup = ""
	s flagRowId =""
	for
	{
		s flagRowId = $o(^CacheTemp("GetTempCateJsonByCategoryID",AKey,"Seq",flagRowId))
		q:(flagRowId="")
		s tmpDocId =$o(^CacheTemp("GetTempCateJsonByCategoryID",AKey,"Seq",flagRowId,""))
		continue:(tmpDocId="")
		s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(tmpDocId)
	    continue:(objTemplate = "")
	    s intParentID = objTemplate.TemplateCategoryID	 
	    s structID = ..GetStructParentIDByID(intParentID)
	    s docStartEnd = gourpArr.GetAt(structID)
	    s docStartEnd = $case(docStartEnd,"":tmpDocId,:$p(docStartEnd,"^",1))
	    s docStartEnd =docStartEnd_"^"_tmpDocId
	    //记录同一个业务活动记录分类的"开始docid^结束docid"
	    d gourpArr.SetAt(docStartEnd,structID)
	    //目录相同数据以^分隔
	    if (intCategoryID = intParentID)
	    {
		    s docGroup=$Case(docGroup,"":tmpDocId,:docGroup_"^"_tmpDocId)
	    }
	    else //目录不同以,分隔
	    {
		    s docGroup=$Case(docGroup,"":tmpDocId,:docGroup_","_tmpDocId)
		    s intCategoryID = intParentID
	    }
	}
	q:(docGroup="") jsonStream
	//获取目录对象集合
	s listObjs = ..GetCateTemByDocID(docGroup)
	s blnMark =0
	s key =""
	for 
	{
		s item = listObjs.GetNext(.key)
		q:(item ="")
		if (item.ShowCategory = "0")
		{
			d:(key'=1) jsonStream.Write(",") 
			s intDocIDs = item.DocID
			s docjson = ##Class(EMRservice.BL.BLEMRTemplateDocGroup).GetDocIDJsonByKeys(intDocIDs,AKey)
			d jsonStream.Write(docjson)
		}
		else
		{
			s cjson = ""
			s strStructID = item.DocID
			s obj = ##Class(EMRmeta.TemplateCategory).%OpenId(strStructID)
			d:(key'=1) jsonStream.Write(",") 
			s cjson = "{"
			s cjson = cjson_ """id"":"""_strStructID_""""
			s cjson = cjson_ ",""text"":"""_obj.Name_""""
			s cjson = cjson_ ",""iconCls"":"""_"user-folder-open"_""""
			s cjson = cjson_ ",""attributes"":{" 
			s cjson = cjson_ """nodeType"":""flod""" 
			s cjson = cjson_ "}"
			s cjson = cjson_ ",""children"":["
			d jsonStream.Write(cjson)
			s jsons = ..GetAgreeNodeDatas(item,AKey)
			s jsons = jsons_ "]}"
			d jsonStream.Write(jsons)
		}
	}
	s mergeJsonStream = jsonStream //..MergeJsonData(jsonStream)
	s jsonStreamNew = ##Class(%GlobalBinaryStream).%New()
	d jsonStreamNew.CopyFrom(mergeJsonStream)
	q jsonStreamNew
}

/// d ##Class(EMRservice.Tools.DailyWorkTool).MergeJsonData("")
ClassMethod MergeJsonData(AJsonSteam As %GlobalBinaryStream) As %Stream
{
	s fullJsonStrem = ##class(%GlobalBinaryStream).%New()
	d fullJsonStrem.Write("[")
	d fullJsonStrem.CopyFrom(AJsonSteam)
	d fullJsonStrem.Write("]")
	s json = [].%FromJSON(fullJsonStrem)
	s ind = $i(^CacheTemp)
	s seq = 1
	set iter = json.%GetIterator()
  	while iter.%GetNext(.key, .jsonsub) 
  	{ 
		set itersub = jsonsub.children.%GetIterator()
		while itersub.%GetNext(.keysub, .jsonsubchild) 
  		{ 
			if ($d(^CacheTemp(ind,seq,jsonsubchild.text))=0) 
			{
				s tmpnumber = 1
			}
			else
			{
				s tmpnumber = $o(^CacheTemp(ind,seq,jsonsubchild.text,""),-1)+1
			}
			s ^CacheTemp(ind,seq,jsonsubchild.text,tmpnumber) = jsonsubchild.%ToJSON()
			s seq = seq + 1
		}
  	}
  	s seq = ""
  	for 
  	{
	  	s seq = $o(^CacheTemp(ind,seq))
	  	q:(seq = "")
	  	s text=""
	  	for
	  	{
			 s text = $o(^CacheTemp(ind,seq,text))
			 q:(text="")
			 s number=""
			 s jsonH={}
			 for
			 {
				s number = $o(^CacheTemp(ind,seq,text,number))
			 	q:(number="")
			 	s tmpJson = ^CacheTemp(ind,seq,text,number)	
			 	if (number=1)
			 	{
				
					s jsonH = {}.%FromJSON(tmpJson)
				}
				else
				{
					s jsonChild = {}.%FromJSON(tmpJson)
					set itersub = jsonChild.children.%GetIterator()
					while itersub.%GetNext(.key, .jsonchild) 
			  		{
				  		d jsonH.children.%Push(jsonchild)
			  		}
				}
			 }

			 s ^CacheTemp(ind,seq,"NEW",text) = jsonH.%ToJSON()
		}
  	}
  	s returnJSON=[]
  	s seq = ""
  	for
  	{
	  	s seq = $o(^CacheTemp(ind,seq))
	  	q:(seq = "")
	  	s newText=""
	  	for
	  	{
			s newText = $o(^CacheTemp(ind,seq,"NEW",newText))
			q:(newText="")
			s subjson = {}.%FromJSON(^CacheTemp(ind,seq,"NEW",newText))
			d returnJSON.%Push(subjson)
		}
  	}

  	k ^CacheTemp(ind)
  	s returnStream = ##class(%GlobalBinaryStream).%New()
  	d returnJSON.%ToJSON(returnStream)
  	//剥离最外层的[]
  	s tmpStream = ##class(%GlobalBinaryStream).%New()
  	d tmpStream.CopyFrom(returnStream)
  	d returnStream.Clear()
  	s tmpStreamLen = tmpStream.Size-2
  	d tmpStream.MoveTo(2)
  	while('tmpStream.AtEnd)
  	{
	  	if (tmpStreamLen>32000)
		{
			s readLen=32000
			d returnStream.Write(tmpStream.Read(readLen))
			s tmpStreamLen = tmpStreamLen-32000
		}
		else
		{
			s readLen=tmpStreamLen
			d returnStream.Write(tmpStream.Read(readLen))
			q
		}
	}
  	q returnStream
}

ClassMethod GetStructParentIDByID(aParentID As %String) As %String
{
	s itemCount = 0
	s strStructID= ""
	s obj = ##Class(EMRmeta.TemplateCategory).%OpenId(aParentID)
	q:(obj="") "-1"
	q:(obj.PropertyCode = "EMR02")||(obj.PropertyCode [ "EMR020") aParentID
	
	s strStructID = ..GetStructParentIDByID(obj.ParentID)
	q strStructID
}

/// Desc:      获取知情目录json数据
/// Creator:    yejian
/// CreateDate: 2021-7-11
/// Input:      alist 知情模板目录结构对象
/// Output:     模板目录json流
/// Debug:      s json = ##Class(EMRservice.BL.BLEMRTemplateDocGroup).GetNodeDatas()
/// 			d json.OutputToDevice()
ClassMethod GetAgreeNodeDatas(agreeCates As EMRservice.entity.EAgreeDocIDList, AKey As %String) As %String
{
	s cjson = ""

	s key =""
	for
 	{
	 	s item = agreeCates.NodeData.GetNext(.key)
		q:(item ="")
		s intCatID = item.DocID
		;w item.DocID,!
		if (item.NodeData="")||(item.NodeData.Count()=0)
		{
			 s docjson = ##Class(EMRservice.BL.BLEMRTemplateDocGroup).GetDocIDJsonByKeys(intCatID,AKey)
			 if (docjson'="")
			{
				s cjson = cjson_docjson
			}
		}
		else
		{
			s obj = ##Class(EMRmeta.TemplateCategory).%OpenId(intCatID)
			q:(obj ="")
			s cjson = cjson_$Case(key,1:"{",:",{")
			s cjson = cjson_ """id"":"""_intCatID_""""
			s cjson = cjson_ ",""text"":"""_obj.Name_""""
			s cjson = cjson_ ",""iconCls"":"""_"user-folder-open"_""""
			s cjson = cjson_ ",""attributes"":{" 
			s cjson = cjson_ """nodeType"":""flod""" 
			s cjson = cjson_ "}"
			s cjson = cjson_ ",""children"":["
			s childJson = ..GetAgreeNodeDatas(item,AKey)
			if (childJson'="")
			{
				s cjson = cjson_childJson
			}
			s cjson = cjson_ "]}"
		}
 	}
 	q cjson
}

/// Desc:      按模板目录结构，显示知情告知结构
/// Desc:      按模板目录结构，显示知情告知结构
/// Creator:    yejian
/// CreateDate: 2018-3-9
/// Input:      ALocID 科室ID
///            AParentID 父节点
///            AKey 临时global节点位置
/// Output:     模板目录json流
/// Debug:      s json = ##Class(EMRservice.BL.BLEMRTemplateDocGroup).GetCateTemByDocID("602,603^604,605,606,607^612")
/// 			d json.OutputToDevice()
ClassMethod GetCateTemByDocID(docGroup As %String) As %ListOfObjects(ELEMENTTYPE="EMRservice.entity.EAgreeDocIDList")
{
	s gourpArr = ##class(%ListOfObjects).%New()
	q:(docGroup="") gourpArr
	s blnMark =0
	s countGroup =$l(docGroup,",")
	for i=1:1:countGroup
	{
		s strItems = $p(docGroup,",",i)
		s countTem = $l(strItems,"^")
		s cNode = ##class(EMRservice.entity.EAgreeDocIDList).%New()
		s cNode.DocID = strItems
		s intParentID= ""
		s tJsons = ""
		if (countTem>0)
		{
			s tmpDocId = $p(strItems,"^",1)
			s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(tmpDocId)
		    continue:(objTemplate = "")
			s intParentID = objTemplate.TemplateCategoryID
			s objp = ##Class(EMRmeta.TemplateCategory).%OpenId(intParentID)
			continue:(objp="")
			//如果目录为业务活动记录，不显示目录
			if (objp.PropertyCode = "EMR02")||(objp.PropertyCode [ "EMR020")
			{
				s cNode.ShowCategory = "0"
				d gourpArr.Insert(cNode)
				continue	
			}
			else
			{
				s catNode = ##class(EMRservice.entity.EAgreeDocIDList).%New()
				s catNode.DocID = intParentID
				d catNode.NodeData.Insert(cNode)
				d gourpArr.Insert(catNode)
			}
		}
	}
	s strCountg = gourpArr.Count()
	q:(strCountg<=0) gourpArr
	s arrayItems = ..GetAgreeTemplateCategory(gourpArr)
	q arrayItems
}

/// Desc:      获取知情告知第二层、及其以下目录结构
/// Creator:    yejian
/// CreateDate: 2021-6-18
/// Input:      ALocID 科室ID
///            AParentID 父节点
///            AKey 临时global节点位置
/// Output:     模板目录json流
/// Debug:      d ##Class(EMRservice.BL.BLEMRTemplateDocGroup).GetGroupTemplateByLoc(190,0,1)
ClassMethod GetAgreeTemplateCategory(aList As %ListOfObjects(ELEMENTTYPE="EMRservice.entity.EAgreeDocIDList")) As %ListOfObjects(ELEMENTTYPE="EMRservice.entity.EAgreeDocIDList")
{
	s itemCount = 0
	s intCategoryID = 0
	s listArr = ##class(%ListOfObjects).%New()
	s blMark =0
	s key =""
	for 
	{
		s item = aList.GetNext(.key)
		q:(item ="")
		s strID = item.DocID
		//不显示目录，直接添加数据
		if (item.ShowCategory = "0")
		{
			d listArr.Insert(item)
			continue
		}
		s obj = ##Class(EMRmeta.TemplateCategory).%OpenId(strID)
		continue:(obj="")
		s aParentID = obj.ParentID
		s objp = ##Class(EMRmeta.TemplateCategory).%OpenId(aParentID)
		continue:(objp="")
		if (objp.PropertyCode = "EMR02")||(objp.PropertyCode [ "EMR020")
		{
			d listArr.Insert(item)
			continue	
		}
		else
		{
			s blMark =1	
		}
		//目录不同以
	    if (intCategoryID'=aParentID)
	    {
		    s pNode = ##class(EMRservice.entity.EAgreeDocIDList).%New()
			s pNode.DocID = aParentID
			d pNode.NodeData.Insert(item)
			d listArr.Insert(pNode)
			s intCategoryID=aParentID		    
	    }
	    else
	    {
		    s pNode =listArr.GetAt(listArr.Count())
		    d pNode.NodeData.Insert(item)
	    }
	}
	if (listArr.Count()>0)&&(blMark=1)
	{
		s listArr = ..GetAgreeTemplateCategory(listArr)
	}
	elseif(listArr.Count()>0)&&(blMark=0) ////标识所有集合内容都为第一层目录
	{
		s listArr = ..GetPaAgreeTemplateCategory(listArr)
	}
	else
	{
		s listArr= aList
	}
	q listArr
}

/// Desc:      获取知情告知第一层目录结构
/// Creator:    yejian
/// CreateDate: 2021-6-18
/// Input:      ALocID 科室ID
///            AParentID 父节点
///            AKey 临时global节点位置
/// Output:     模板目录json流
/// Debug:      d ##Class(EMRservice.BL.BLEMRTemplateDocGroup).GetGroupTemplateByLoc(190,0,1)
ClassMethod GetPaAgreeTemplateCategory(aList As %ListOfObjects(ELEMENTTYPE="EMRservice.entity.EAgreeDocIDList")) As %ListOfObjects
{
	s paArr = ##class(%ListOfObjects).%New()
	s paCategoryID =0
	s key = ""
	for 
	{
		s item = aList.GetNext(.key)
		q:(item ="")
		s strID = item.DocID 
		if (item.ShowCategory="0")
		{
			d paArr.Insert(item)
			continue
		}
		s obj = ##Class(EMRmeta.TemplateCategory).%OpenId(strID)
		s aParentID = obj.ParentID
		s objp = ##Class(EMRmeta.TemplateCategory).%OpenId(aParentID)
		continue:(objp="")
		if (objp.PropertyCode = "EMR02")
		{
			d paArr.Insert(item)
			continue
		}
		//目录不同以
	    if (paCategoryID'=aParentID)
	    {
		    s pNode = ##class(EMRservice.entity.EAgreeDocIDList).%New()
			s pNode.DocID = aParentID
			d pNode.NodeData.Insert(item)
			d paArr.Insert(pNode)
			s paCategoryID=aParentID		    
	    }
	    else
	    {
		    s pNode =paArr.GetAt(paArr.Count())
		    d pNode.NodeData.Insert(item)
	    }
	}
	q paArr
}

/// Desc:       个人模板   
/// Input:      argEpisodeID 就诊ID
///            argUserLocID 用户所在科室ID
///            argUserID 用户ID
///            argSsgroup 用户所在安全组ID
/// Debug:      w ##Class(EMRservice.BL.BLOPClientCategory).GetPersonalTemplates(4634,684,7,28)
ClassMethod GetPersonalTemplatesForHISUI(argEpisodeID As %String, argUserLocID As %String, argUserID As %String, argSsgroup As %String) As %Stream
{
	s result = ##class(%GlobalCharacterStream).%New()
	q:(argUserID = "")||(argEpisodeID = "")||(argUserLocID = "")||(argSsgroup = "") result
	s arrTemplate = ##Class(EMRservice.BL.BLOPClientCategory).GetTemplateLst(argUserLocID,argSsgroup,argEpisodeID,argUserID)
	s personalList = ##class(%GlobalCharacterStream).%New()
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	s key = ""
	for
	{
		s key = arrTemplate.Next(key)
		q:(key="")
  		s curEMRCateId = $P(arrTemplate.GetAt(key),"^",1)
		s TempCate = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(curEMRCateId)
		continue:(TempCate = "")
		s chapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(TempCate.ParentCategoryID)
		continue:(chapter = "")
		s tmpList = ##class(%GlobalCharacterStream).%New()

		s cateData = ##Class(EMRservice.BL.PersonalTemplate).GetCategoryData(argUserID,-curEMRCateId,argUserLocID)
		d tmpList.CopyFrom(cateData)
		s examples = ##Class(EMRservice.BL.PersonalTemplate).GetExampleData(argUserID,-curEMRCateId)
		d:((cateData.Size >0)&&(examples.Size >0)) tmpList.Write(",")
		d tmpList.CopyFrom(examples)
		
		//过滤无个人模板的文件夹
		continue:(tmpList.Size = 0)
		
		s categoryName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.EMRTemplateCategory","CategoryName",chapter.CategoryName,langid)
		s DociDName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.EMRTemplateCategory","CategoryName",TempCate.CategoryName,langid)
		
		d:(personalList.Size>0) personalList.Write(",")
		d personalList.Write("{")
		d personalList.Write("""id"":"""_curEMRCateId_"""")
		d personalList.Write(",""text"":"""_DociDName_"""")
		d personalList.Write(",""iconCls"":""user-folder-open""")
		d personalList.Write(",""attributes"":{""nodeType"":""flod""}")
		d personalList.Write(",""children"":[")
		d personalList.CopyFrom(tmpList)
		d personalList.Write("]}")			
	}
	if (personalList.Size>0)
	{
		s persontext = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","个人模板")
		
		d result.Write("[{")
		d result.Write("""id"":""0""")
		d result.Write(",""text"":"""_persontext_"""")
		d result.Write(",""iconCls"":""user-folder-open""")
		d result.Write(",""attributes"":{""nodeType"":""flod""}")
		d result.Write(",""children"":[")	
		d result.CopyFrom(personalList)	
		d result.Write("]}]")
	}
    
    if (result.Size=0)
    {
        d result.Write("[]")
    }    
    q result
}

/// Desc:       个人模板   
/// Input:     argEpisodeID 就诊ID
///            argUserLocID 用户所在科室ID
///            argUserID 用户ID
///            argSsgroup 用户所在安全组ID
/// Debug:     w ##Class(EMRservice.BL.BLOPClientCategory).GetPersonalTemplates(4634,684,7,28)
ClassMethod GetPersonalTemplatesForHISUINew(argEpisodeID As %String, argUserLocID As %String, argUserID As %String, argSsgroup As %String) As %Stream
{
    s result = ##class(%GlobalCharacterStream).%New()
    q:(argUserID = "")||(argEpisodeID = "")||(argUserLocID = "")||(argSsgroup = "") result
    s arrTemplate = ##Class(EMRservice.BL.BLOPClientCategory).GetTemplateLst(argUserLocID,argSsgroup,argEpisodeID,argUserID)
    s personalList = ##class(%GlobalCharacterStream).%New()
    Set langid=20
    if ($d(%session)){
        set langid=+$g(%session.Data("LOGON.LANGID"))
    }
    
    s tmpList = ##class(%GlobalCharacterStream).%New()
    s cateData = ##Class(EMRservice.BL.PersonalTemplate).GetCategoryData(argUserID,"0",argUserLocID)
	d:(cateData.Size >0) tmpList.CopyFrom(cateData)
	s examples = ##Class(EMRservice.BL.PersonalTemplate).GetExampleData(argUserID,"0")
	d:(cateData.Size >0)&&(examples.Size >0) tmpList.Write(",")
    d tmpList.CopyFrom(examples)
    
    d:(personalList.Size>0)&&(tmpList.Size>0) personalList.Write(",")
    d personalList.CopyFrom(tmpList)
    
    s key = ""
    for
    {
        s key = arrTemplate.Next(key)
        q:(key="")
        s curEMRCateId = $P(arrTemplate.GetAt(key),"^",1)
        s TempCate = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(curEMRCateId)
        continue:(TempCate = "")
        s chapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(TempCate.ParentCategoryID)
        continue:(chapter = "")
        s tmpList = ##class(%GlobalCharacterStream).%New()

        s cateData = ##Class(EMRservice.BL.PersonalTemplate).GetCategoryData(argUserID,-curEMRCateId,argUserLocID)
        d tmpList.CopyFrom(cateData)
        s examples = ##Class(EMRservice.BL.PersonalTemplate).GetExampleData(argUserID,-curEMRCateId)
        d:((cateData.Size >0)&&(examples.Size >0)) tmpList.Write(",")
        d tmpList.CopyFrom(examples)
        
        //过滤无个人模板的文件夹
        continue:(tmpList.Size = 0)
        
        s categoryName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.EMRTemplateCategory","CategoryName",chapter.CategoryName,langid)
        s DociDName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.EMRTemplateCategory","CategoryName",TempCate.CategoryName,langid)
        
        d:(personalList.Size>0)&&(tmpList.Size>0) personalList.Write(",")
        d personalList.CopyFrom(tmpList)        
    }
    if (personalList.Size>0)
    {
        s persontext = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","个人模板")
        
        d result.Write("[{")
        d result.Write("""id"":""0""")
        d result.Write(",""text"":"""_persontext_"""")
        d result.Write(",""iconCls"":""user-folder-open""")
        d result.Write(",""attributes"":{""nodeType"":""flod""}")
        d result.Write(",""children"":[")   
        d result.CopyFrom(personalList) 
        d result.Write("]}]")
    }
    
    if (result.Size=0)
    {
        d result.Write("[]")
    }    
    q result
}

}
