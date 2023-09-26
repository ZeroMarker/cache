Class web.DHCCM.EMRservice.BL.BLClientCategory Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       取配置前端目录展现病历目录
/// Creator:    Candy
/// CreateDate: 2014-8-27
/// Input:      ACTLocID 用户登录科室
///             ASSGroupID 用户安全组
///             AEpisodeID 患者就诊号
/// Debug       d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLClientCategory","GetCategory","199","200","1517")
Query GetCategory(ACTLocID As %String, ASSGroupID As %String, AEpisodeID As %String) As %Query(ROWSPEC = "ItemID:%String,ItemTitle:%String,ItemImagePath:%String,ItemCategoryID:%String,ItemURL:%String,ItemParas:%String,ItemType:%String,recordFlag:%String")
{
}

ClassMethod GetCategoryExecute(ByRef qHandle As %Binary, ACTLocID As %String, ASSGroupID As %String, AEpisodeID As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	
	q:(ACTLocID = "")||(ASSGroupID = "")||(AEpisodeID = "") $$$OK
	s episodeType= $p(^PAADM(AEpisodeID),"^",2)
	if (episodeType = "I")
	{
		s disDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(AEpisodeID)
		s schemType = $case(disDateTime,"":"RUNNING",:"ARCHIVING")
	}
	else
	{
		s schemType = "OUTPATIENT"
	}
	s seq = ""
	for
	{
		s seq = $o(^DHCEMRM.EMRNavSchemeItemI("IdxItemSeq"," "_schemType,seq))
		q:(seq = "")
		s rowId = ""
		for
		{
			s rowId = $o(^DHCEMRM.EMRNavSchemeItemI("IdxItemSeq"," "_schemType,seq,rowId))
			q:(rowId = "")
			s objNavItem = ##Class(EMRmeta.EMRNavigationSchemeItem).%OpenId(rowId)
			continue:(objNavItem = "")
			continue:(objNavItem.ItemCode = "")
			continue:(objNavItem.ItemDr = "")
			continue:($d(^DHCEMRM.EMRNavItemSSGroupI("IdxCodeSSGroup"," "_schemType," "_objNavItem.ItemCode," "_ASSGroupID))<=0)			
			s locFlag = $d(^DHCEMRM.EMRNavItemLocI("IdxCodeCTLocID"," "_schemType," "_objNavItem.ItemCode," "_ACTLocID))
			s objOrgItem = ##Class(EMRmeta.CTOrganizationSchemeItem).%OpenId(objNavItem.ItemDr)
			continue:(objOrgItem = "")
			s type = $Case(objOrgItem.EMRTemplateCategoryID,"":"HIS",:"EMR")
			s recordFlag = "0"
			if (type = "EMR")
			{
				s recordFlag = ..CheckHasRecord(objOrgItem.EMRTemplateCategoryID,AEpisodeID)
				//continue:((locFlag <= 0)&&(recordFlag <= 0))
			} 
			else
			{
				continue:(locFlag <= 0)
			}
			s data = $lb(objNavItem.ItemDr,objOrgItem.ItemTitle,objOrgItem.imagePath,objOrgItem.EMRTemplateCategoryID,objOrgItem.ItemURL,objOrgItem.ItemParas,type,recordFlag)
			s ^CacheTemp(repid,ind) = data
			s ind=ind+1 		
		}
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

/// Desc:       前端写过病历的病历展现目录
/// Creator:    Candy
/// CreateDate: 2014-8-27
/// Input:      AEpisodeID 用户登录科室
/// Debug       d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLClientCategory","GetAllCategory",76)
Query GetAllCategory(AEpisodeID As %String) As %Query(ROWSPEC = "ItemID:%String,ItemTitle:%String,ItemImagePath:%String,ItemCategoryID:%String,ItemURL:%String,ItemParas:%String,ItemType:%String")
{
}

ClassMethod GetAllCategoryExecute(ByRef qHandle As %Binary, AEpisodeID As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	q:(AEpisodeID = "") $$$OK
	s episodeType= $p(^PAADM(AEpisodeID),"^",2)
	if (episodeType = "I")
	{
		s disDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(AEpisodeID)
		s schemType = $case(disDateTime,"":"RUNNING",:"ARCHIVING")
	}
	else
	{
		s schemType = "OUTPATIENT"
	}
	s seq = ""
	for
	{
		s seq = $o(^DHCEMRM.EMRNavSchemeItemI("IdxItemSeq"," "_schemType,seq))
		q:(seq = "")
		s rowId = ""
		for
		{
			s rowId = $o(^DHCEMRM.EMRNavSchemeItemI("IdxItemSeq"," "_schemType,seq,rowId))
			q:(rowId = "")
			s objNavItem = ##Class(EMRmeta.EMRNavigationSchemeItem).%OpenId(rowId)
			continue:(objNavItem = "")
			continue:(objNavItem.ItemCode = "")
			continue:(objNavItem.ItemDr = "")
			s objOrgItem = ##Class(EMRmeta.CTOrganizationSchemeItem).%OpenId(objNavItem.ItemDr)
			continue:(objOrgItem = "")
			s type = $Case(objOrgItem.EMRTemplateCategoryID,"":"HIS",:"EMR")
			s recordFlag = ..CheckHasRecord(objOrgItem.EMRTemplateCategoryID,AEpisodeID)
			continue:(recordFlag <= 0)
			s data = $lb(objNavItem.ItemDr,objOrgItem.ItemTitle,objOrgItem.imagePath,objOrgItem.EMRTemplateCategoryID,objOrgItem.ItemURL,objOrgItem.ItemParas,type)
			s ^CacheTemp(repid,ind) = data
			s ind=ind+1 		
		}
	}			
    Quit $$$OK
}

ClassMethod GetAllCategoryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllCategoryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAllCategoryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllCategoryExecute ]
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

/// Desc:      判断目录展现结构下是否写病历
/// Input:     ACategoryID 目录ID
///            AEpisodeID 就诊号
/// Output:    result 1 是 0 否
/// Debug:     w ##Class(EMRservice.BL.BLClientCategory).CheckHasRecord(51,76)
ClassMethod CheckHasRecord(ACategoryID As %String, AEpisodeID As %String) As %String
{
	s result = 0
	s docIds = ..GetDocIdsByParent(ACategoryID)
	s length = $l(docIds,",")
	for I=1:1:length
	{
		s docId = $p(docIds,",",I)
		s rowId = $o(^DHCPHI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_docId,""))
		continue:(rowId = "")
		s flag = $d(^DHCPHI.InstanceDataI("IdxHappenDateTime",rowId," SAVE"))
		s:(flag >0) result = 1
		q:(result =1)
	}	
	q result
}

/// Desc:       通过方案病历目录
/// Modify:     Candyxu
/// DateTime:   2014-8-25
/// Input:      ACTLocId 登录用户科室ID
///             AEpisodeId 就诊号
/// OutPut:     json             
/// w ##Class(EMRservice.BL.BLClientCategory).GetCategoryJson("6",100,76)	
ClassMethod GetCategoryJson(ACTLocID As %String, ASSgroupID As %String, AEpisodeID As %String) As %String
{
	s json = "",count = 0
	q:(ACTLocID = "")||(AEpisodeID = "") json

	s result = ##class(%ResultSet).%New("web.DHCCM.EMRservice.BL.BLClientCategory:GetCategory")
	d result.Execute(ACTLocID,ASSgroupID,AEpisodeID)
	while result.%Next()
	{
		s:(count '= 0) json = json_","
		s json = json_"{"
		s json = json_"""id"":"""_result.Data("ItemID")_""""
		s json = json_",""text"":"""_result.Data("ItemTitle")_"""" 
		s json = json_ ",""attributes"":{" 
		s json = json_ """image"":"""_result.Data("ItemImagePath")_"""" 
		s json = json_ ",""categoryId"":"""_result.Data("ItemCategoryID")_""""
		s json = json_ ",""type"":"""_result.Data("ItemType")_"""" 		
		s json = json_ ",""itemUrl"":"""_result.Data("ItemURL")_"?"_result.Data("ItemParas")_""""
		s json = json_ "}"
		s json = json_ "}"
		s count = count + 1
	}	
	s json = $ZSTRIP(json,"*C")
	q json
}

/// Desc:       病历模板目录
/// Modify:     Candyxu
/// DateTime:   2014-5-5
/// Input:      AParentId:目录CategoryId
///             AEpisodeID:就诊号
/// OutPut:     json    
/// d ##Class(EMRservice.BL.BLClientCategory).GetTempCateJsonByCategoryID(5,76,105,"","Operation","2")
ClassMethod GetTempCateJsonByCategoryID(AParentID As %String, AEpisodeID As %String, AUserID As %String, AResultType As %String = "", AEventType As %String = "", AEventID As %String = "", ACTLocId As %String = "") As %GlobalCharacterStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	s count = 0,flag = 0
	s jsonList = ##Class(%ListOfDataTypes).%New()
	q:((AParentID = "")||(AEpisodeID = "")) ""
	s priActivity = ..CheckTPrivActivity()  //权限控制
	s curPatInfo = ##class(EMRservice.DocRestLogic.PrivLogic).GetPatInfo(AEpisodeID,AUserID)
	s patDept = $p($li(curPatInfo,2),$c(2),2)
	s flag = ""
	s seq = ""
	for
	{
		s seq = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_AParentID,seq))
		q:(seq = "")
		s curCategoryId = ""
		for
		{
			s curCategoryId = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_AParentID,seq,curCategoryId))
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
			s curObjDocCategory = ..GetDocIDInChapter(AEpisodeID,"",curCategoryId,priActivity,curPatInfo)
			continue:(curObjDocCategory = "")
			s curEMRTemplategoryID = $e(curObjDocCategory.ID,3,$l(curObjDocCategory.ID))  	
			continue:(curEMRTemplategoryID = "")
			s curIsLeadframe = curObjDocCategory.IsLeadframe
			
			///病历是否已写，写过则不显示新建卡片
			if (AEventID '= "" && AEventType '= "")
			{
				s flag = 0
				s linkInstanceId = ""
				for 
				{
					s linkInstanceId = $o(^DHCEMRI.Events.LinkDocumnentsI("IdxEpisodeEventChartItemInstanceID"," "_AEpisodeID," "_$zcvt(AEventType,"U")," "_AEventID," "_curEMRTemplategoryID,linkInstanceId))
					q:(linkInstanceId = "")
					if (linkInstanceId '= "")
					{
						s tmplinkInstanceId = $tr(linkInstanceId," ")
						s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(tmplinkInstanceId)
						if (objInstance '= "")
						{
							s:(objInstance.Status = "Save") flag =1
							q:(flag = 1)
						}
					}
					q:(flag = 1)
				}
				continue:(flag = 1)
			}
			
	        s curObjDocCategory = ""  k curObjDocCategory
	        s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(curEMRTemplategoryID)
		    continue:(objTemplate = "")
		    s result = ##class(web.DHCCM.EMRservice.BL.BLInstanceData).IsHasInstance(AEpisodeID, objTemplate.ID,curEMRTemplategoryID)
			if ((result '= 0) && (objTemplate.ChartItemType = "Single"))
			{
				s:(curIsMutex = 1) flag = 1
				continue
			}
			s childs = ..GetTitleByDocID(curEMRTemplategoryID,AEpisodeID,AEventType,AEventID,ACTLocId)
			s quotationFlag = ##Class(EMRservice.BL.BLQuotation).GetDocQuationFlag(patDept,curEMRTemplategoryID) 
	        if (AResultType = "List")
	        {
		        d DisplayInList 
		    }
		    else
			{
				d DisPlayInTree
			}
			s cjson = $ZSTRIP(cjson,"*C")
			d jsonList.Insert(curIsMutex_"^"_cjson)
		}
	}
    s key = ""
    for
    {
	    s value = jsonList.GetNext(.key)
	    q:(key = "")
	    s curIsMutex = $p(value,"^",1)
	    continue:((flag = 1)&&(curIsMutex = 1))
	    d:(count '= 0) json.Write(",")
	    d json.Write($p(value,"^",2))
	    s count = count + 1
	}
    q json
DisplayInList
    s cjson = "{"
	s cjson = cjson_ """emrDocId"":"""_curEMRTemplategoryID_""""
	s cjson = cjson_ ",""text"":"""_curCategoryName_""""
	s cjson = cjson_ ",""type"":""TempCate""" 
	s cjson = cjson_ ",""chartItemType"":"""_objTemplate.ChartItemType_"""" 
	s cjson = cjson_ ",""documentType"":"""_objTemplate.DocumentType_"""" 
	s cjson = cjson_ ",""isLeadframe"":"""_curIsLeadframe_""""
	s cjson = cjson_ ",""isMutex"":"""_curIsMutex_""""
	s cjson = cjson_",""templateId"":"""_objTemplate.ID_""""
	s cjson = cjson_",""categoryId"":"""_AParentID_""""
	s cjson = cjson_",""quotation"":"""_$case(quotationFlag>0,1:1,:0)_""""
	s cjson = cjson_ "}"
	q
DisPlayInTree  
	s cjson = "{"
	s cjson = cjson_ """id"":"""_curEMRTemplategoryID_""""
	s cjson = cjson_ ",""text"":"""_curCategoryName_""""
	s cjson = cjson_ ",""childs"":["_childs_"]"
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
	q
}

/// Desc:       知情同意书搜索
/// Modify:     董璐璐
/// DateTime:   2016-3-10
/// Input:      AParentId:目录CategoryId
///             AEpisodeID:就诊号
/// OutPut:     json    
/// w ##Class(EMRservice.BL.BLClientCategory).GetInformConsentTempCateJson("同意书",7,230,"false")
ClassMethod GetInformConsentTempCateJson(ASelectValue As %String, AParentID As %String, AEpisodeID As %String, AUserID As %String, AResultType As %String = "", AEventType As %String = "", AEventID As %String = "") As %GlobalCharacterStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	s count = 0,flag = 0
	s jsonList = ##Class(%ListOfDataTypes).%New()
	q:(AEpisodeID = "") ""
	s priActivity = ..CheckTPrivActivity()  //权限控制
	s curPatInfo = ##class(EMRservice.DocRestLogic.PrivLogic).GetPatInfo(AEpisodeID,AUserID)
	s patDept = $p($li(curPatInfo,2),$c(2),2)
	s flag = ""
	s seq = ""
	s nowCurDocGropName = ""
	//判断当前挂靠的模板组的名称
	for
	{
		s seq = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_AParentID,seq))
		q:(seq = "")
		s curCategoryId = ""
		for
		{
			s curCategoryId = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_AParentID,seq,curCategoryId))
			q:(curCategoryId = "")
			s objEMRTemplateCategory =##Class(EMRmeta.EMRTemplateCategory).%OpenId(curCategoryId)
			continue:(objEMRTemplateCategory.CategoryType '= "CategoryChapter")
	        s curIsMutex = objEMRTemplateCategory.IsMutex
	        s:(curIsMutex '= 1) curIsMutex = 0
	        continue:((flag = 1)&&(curIsMutex = 1))
	        s objEMRTemplateCategory = "" k objEMRTemplateCategory
			//初始化CategoryChapter节点时，不直接初始化CategoryChapter节点，而是直接初始化其下级中适用的挂靠界面模板的节点
			//即文档中说明的隐藏第二层
			s curObjDocCategory = ..GetDocIDInChapter(AEpisodeID,"",curCategoryId,priActivity,curPatInfo)
			continue:(curObjDocCategory = "")
			s curEMRTemplategoryID = $e(curObjDocCategory.ID,3,$l(curObjDocCategory.ID))  	
			continue:(curEMRTemplategoryID = "")
			s curDocGropID = ""
			s curDocGropID = $o(^DHCEMRM.DocRes.DocsInGroupI("DocIDIdx"," "_curEMRTemplategoryID,""))
			continue:(curDocGropID = "")
			s curDocGropID = $ZSTRIP(curDocGropID,"<W")
			s curDocGropObj = ##Class(EMRmeta.EMRDocRestriction.DocGroup).%OpenId(curDocGropID)
			s nowCurDocGropName = curDocGropObj.GroupName
			s curDocGropObj = "" k curDocGropObj
			s curObjDocCategory = "" k curObjDocCategory
			q:(nowCurDocGropName '= "")
		}	
		q:(nowCurDocGropName '= "")
	}
	s flag = ""
	s seq = ""
	//获取模板信息
	for
	{
		s seq = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_AParentID,seq))
		q:(seq = "")
		s curCategoryId = ""
		for
		{
			s curCategoryId = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_AParentID,seq,curCategoryId))
			q:(curCategoryId = "")
			s objEMRTemplateCategory =##Class(EMRmeta.EMRTemplateCategory).%OpenId(curCategoryId)
			continue:(objEMRTemplateCategory.CategoryType '= "CategoryChapter")
	        s curCategoryName = objEMRTemplateCategory.CategoryName
	        
	        continue:($find(curCategoryName,ASelectValue) = 0)
	        
	        s curIsMutex = objEMRTemplateCategory.IsMutex
	        s:(curIsMutex '= 1) curIsMutex = 0
	        continue:((flag = 1)&&(curIsMutex = 1))
	        s objEMRTemplateCategory = "" k objEMRTemplateCategory
			//初始化CategoryChapter节点时，不直接初始化CategoryChapter节点，而是直接初始化其下级中适用的挂靠界面模板的节点
			//即文档中说明的隐藏第二层
			
			s curEMRTemplategoryID = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID"," "_curCategoryId,""))
			continue:(curEMRTemplategoryID = "")
			s curObjDocCategory =##Class(EMRmeta.EMRTemplateCategory).%OpenId(curEMRTemplategoryID)
			continue:(curObjDocCategory.CategoryType '= "TempCate")
			s curIsLeadframe = curObjDocCategory.IsLeadframe
			
			s curDocGropID = ""
			s curDocGropID = $o(^DHCEMRM.DocRes.DocsInGroupI("DocIDIdx"," "_curEMRTemplategoryID,""))
			continue:(curDocGropID = "")
			s curDocGropID = $ZSTRIP(curDocGropID,"<W")
			s curDocGropObj = ##Class(EMRmeta.EMRDocRestriction.DocGroup).%OpenId(curDocGropID)
			s curDocGropName = ""
			s curDocGropName = curDocGropObj.GroupName
			s curDocGropObj = "" k curDocGropObj
			s curObjDocCategory = "" k curObjDocCategory
			s disCurDocGropName = ""
			s nowcurCategoryName = curCategoryName
			
			if (curDocGropName '= nowCurDocGropName)
			{
				s disCurDocGropName = disCurDocGropName_"模板组："
				s disCurDocGropName = disCurDocGropName_curDocGropName
				s nowcurCategoryName = nowcurCategoryName_"（"
				s nowcurCategoryName = nowcurCategoryName_disCurDocGropName
				s nowcurCategoryName = nowcurCategoryName_"）"
			}

			///病历是否已写，写过则不显示新建卡片
			if (AEventID '= "" && AEventType '= "")
			{
				s flag = 0
				s linkInstanceId = ""
				for 
				{
					s linkInstanceId = $o(^DHCEMRI.Events.LinkDocumnentsI("IdxEpisodeEventChartItemInstanceID"," "_AEpisodeID," "_$zcvt(AEventType,"U")," "_AEventID," "_curEMRTemplategoryID,linkInstanceId))
					q:(linkInstanceId = "")
					if (linkInstanceId '= "")
					{
						s tmplinkInstanceId = $tr(linkInstanceId," ")
						s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tmplinkInstanceId)
						if (objInstance '= "")
						{
							s:(objInstance.Status = "Save") flag =1
							q:(flag = 1)
						}
					}
					q:(flag = 1)
				}
				continue:(flag = 1)
			}
			
	        s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(curEMRTemplategoryID)
		    continue:(objTemplate = "")
		    s result = ##class(EMRservice.BL.BLInstanceData).IsHasInstance(AEpisodeID, objTemplate.ID,curEMRTemplategoryID)
			if ((result '= 0) && (objTemplate.ChartItemType = "Single"))
			{
				s:(curIsMutex = 1) flag = 1
				continue
			}
			s childs = ..GetTitleByDocID(curEMRTemplategoryID,AEpisodeID,AEventType,AEventID)
			s quotationFlag = ##Class(EMRservice.BL.BLQuotation).GetDocQuationFlag(patDept,curEMRTemplategoryID) 
	        if (AResultType = "List")
	        {
		        d DisplayInList 
		    }
		    else
			{
				d DisPlayInTree
			}
			s cjson = $ZSTRIP(cjson,"*C")
			d jsonList.Insert(curIsMutex_"^"_cjson)
		}
	}
    s key = ""
    for
    {
	    s value = jsonList.GetNext(.key)
	    q:(key = "")
	    s curIsMutex = $p(value,"^",1)
	    continue:((flag = 1)&&(curIsMutex = 1))
	    d:(count '= 0) json.Write(",")
	    d json.Write($p(value,"^",2))
	    s count = count + 1
	}
    q json
DisplayInList
    s cjson = "{"
	s cjson = cjson_ """emrDocId"":"""_curEMRTemplategoryID_""""
	s cjson = cjson_ ",""text"":"""_nowcurCategoryName_""""
	s cjson = cjson_ ",""type"":""TempCate""" 
	s cjson = cjson_ ",""chartItemType"":"""_objTemplate.ChartItemType_"""" 
	s cjson = cjson_ ",""documentType"":"""_objTemplate.DocumentType_"""" 
	s cjson = cjson_ ",""isLeadframe"":"""_curIsLeadframe_""""
	s cjson = cjson_ ",""isMutex"":"""_curIsMutex_""""
	s cjson = cjson_",""templateId"":"""_objTemplate.ID_""""
	s cjson = cjson_",""categoryId"":"""_AParentID_""""
	s cjson = cjson_",""quotation"":"""_$case(quotationFlag>0,1:1,:0)_""""
	s cjson = cjson_ "}"
	q
DisPlayInTree  
	s cjson = "{"
	s cjson = cjson_ """id"":"""_curEMRTemplategoryID_""""
	s cjson = cjson_ ",""text"":"""_curCategoryName_""""
	s cjson = cjson_ ",""childs"":["_childs_"]"
	s cjson = cjson_ ",""attributes"":{" 
	s cjson = cjson_ """type"":""TempCate""" 
	s cjson = cjson_ ",""chartItemType"":"""_objTemplate.ChartItemType_"""" 
	s cjson = cjson_ ",""documentType"":"""_objTemplate.DocumentType_"""" 
	s cjson = cjson_ ",""isLeadframe"":"""_curIsLeadframe_""""
	s cjson = cjson_ ",""isMutex"":"""_curIsMutex_""""
	s cjson = cjson_",""templateId"":"""_objTemplate.ID_""""
	s cjson = cjson_",""quotation"":"""_$case(quotationFlag>0,1:1,:0)_""""
	s cjson = cjson_",""disCurDocGropName"":"""_disCurDocGropName_""""
	s cjson = cjson_ "}"
	s cjson = cjson_ "}"
	q
}

/// Desc:		所有模板
/// Creator:	Candy
/// CreateDate:	2014-8-29
/// Input:		ACTLocId 科室ID
/// 			AEpisodeID 就诊号
/// 			AUserID 用户ID
/// Output:     json
/// Debug: w ##Class(EMRservice.BL.BLClientCategory).GetTempCateJson(6,43,105)
ClassMethod GetTempCateJson(ACTLocID As %String, ASSgroupID As %String, AEpisodeID As %String, AUserID As %String, AResultType As %String = "", AEventType As %String = "", AEventID As %String = "") As %GlobalCharacterStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	s count = 0
	q:(ACTLocID = "")||(ASSgroupID = "")||(AEpisodeID = "")||(AUserID = "") json
	s result = ##class(%ResultSet).%New("web.DHCCM.EMRservice.BL.BLClientCategory:GetCategory")
	d result.Execute(ACTLocID,ASSgroupID,AEpisodeID)
	while result.%Next()
	{
		s ItemType = result.Data("ItemType")
		continue:(ItemType = "HIS")
		s categoryId = result.Data("ItemCategoryID")
		s cjson = ..GetTempCateJsonByCategoryID(categoryId,AEpisodeID,AUserID,AResultType,AEventType,AEventID,ACTLocID)
		continue:(cjson = "")
		s emrtype = ""
		s:(result.Data("ItemURL")="emr.record.library.navoperation.csp") emrtype = "Operation"
		d:(count '= 0) json.Write(",")
		d json.Write("{")
		d json.Write("""id"":"""_categoryId_"""")
		d json.Write(",""text"":"""_result.Data("ItemTitle")_"""")
		d json.Write(",""type"":"""_emrtype_"""")
		d json.Write(",""childs"":[")
		d json.CopyFrom(cjson)
		d json.Write("]")
		d json.Write("}")
		s count = count + 1
	}
	q json
}

/// Creator: guozongtao
/// CreatDate: 2014-1-7
/// Description：系统参数是否设置为开启模板权限控制
/// Table:
/// Input:
/// Output:
/// Return:是否开启  Y--是  N--否
ClassMethod CheckTPrivActivity() As %String
{
	s ReturnValue = "N"
	s ReturnValue = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("TPRIVACTIVITY") 
	if ReturnValue '= "Y"
	{
		s ReturnValue = "N"
	}
	q ReturnValue
}

/// Creator: guozongtao
/// CreatDate: 2014-1-7
/// Description：取出ChapterDoc节点下可用的DocID（即可用的TempCate的Doc）
/// 			 在构造病历结构树形时，处理ChapterDoc类型的节点，该类型的节点将被隐藏，其位置由TempCate类型的节点代替
/// Table:
/// Input: EpisodeID--病人就诊号;parOthers--用于扩展的信息串（未用）;parCategoryID--Chapter的ID； parPriActivity--是否开启了模板权限, parPatInfo--病人信息
/// Output:
/// Return: DocID(挂靠界面模板的目录)
ClassMethod GetDocIDInChapter(EpisodeID As %String, parOthers As %String, parCategoryID As %String, parPriActivity As %String, parPatInfo As %Library.List) As EMRservice.entity.EEMRCategoryProperty
{
	 s resultDocID = ""
	 
	 s resultDocID = ##class(EMRservice.DocRestLogic.PrivLogic).GetDocIDForView(EpisodeID, parOthers, parCategoryID, parPriActivity, parPatInfo)
	 q:(resultDocID = "") ""
	 
	 s objEMRTemplateCategory=##Class(EMRmeta.EMRTemplateCategory).%OpenId(resultDocID)
	 s curCategoryType = objEMRTemplateCategory.CategoryType
	 s resultDocID = ##class(EMRservice.BOEMRTemplateCategory).TransCategoryType(curCategoryType)_resultDocID
     s objEEMRTemplateCategory = ##Class(EMRservice.entity.EEMRCategoryProperty).%New()
     s objEEMRTemplateCategory.ID = resultDocID
     s objEEMRTemplateCategory.IsLeadframe = objEMRTemplateCategory.IsLeadframe
     s objEEMRTemplateCategory.IsMutex = objEMRTemplateCategory.IsMutex
     s objEEMRTemplateCategory.Name = objEMRTemplateCategory.CategoryName
	 //返回结果
	 q objEEMRTemplateCategory
}

/// Desc:		根据DocId取实例
/// Creator:	Candy
/// CreateDate: 2014-8-29
/// Input: 		AParentId 目录categoryID
/// 			AEpisodeId 就诊号
/// 			AUniqueKey 唯一标示
/// 			OutPut result 1成功，0错误
/// Debug：     w ##Class(EMRservice.BL.BLClientCategory).DoInstanceJsonByDocID(4,616,76,"Save")
ClassMethod DoInstanceJsonByDocID(ADocId As %String, AEpisodeId As %String, AStauts As %String, AResultType As %String = "") As %GlobalCharacterStream
{
	s $zt = "Error"
	s json = ##Class(%GlobalCharacterStream).%New()
	s count = 0
	q:(ADocId = "")||(AEpisodeId = "")||(AStauts = "") json
	s docId = ADocId
	s ecrecordId = $o(^DHCPHI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeId," "_docId,""))
	q:(ecrecordId = "") json
	
	s objEcrecod =  ##Class(User.DHCPHECRecord).%OpenId(ecrecordId)
	q:(objEcrecod = "") json
	s docId = objEcrecod.ChartItemID
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
		s date = $o(^DHCPHI.InstanceDataI("IdxHappenDateTime",ecrecordId," "_$zcvt(AStauts,"U"),date))
		q:(date = "")
		s time = ""
		for
		{
			s time = $o(^DHCPHI.InstanceDataI("IdxHappenDateTime",ecrecordId," "_$zcvt(AStauts,"U"),date,time))	
			q:(time = "")
			s subId = ""
			for
			{
				s subId = $o(^DHCPHI.InstanceDataI("IdxHappenDateTime",ecrecordId," "_$zcvt(AStauts,"U"),date,time,subId))			
				q:(subId = "")
 				s tempJson = ..GetInstanceJsonByID(ecrecordId,subId,AResultType)
 				continue:(tempJson = "")
 				d:(count '= 0) json.Write(",")
				d json.Write($ZSTRIP(tempJson,"*C"))
				s count = count + 1			
			}
		}
	}
	q json
Error
	q ""
}

/// Desc: 		根据模板维护打散数据信息，取病历摘要
/// Creator: 	Candy
/// CreateDate:	2014-9-2 
/// Input:       AInstanceID 实例ID
///             AEpsiodeId  就诊ID
/// Output:      result 打散数据
/// Debug:       w ##Class(EMRservice.BL.BLClientCategory).GetInstanceSummery("2||2",76)
ClassMethod GetInstanceSummery(AInstanceID As %String, AEpsiodeId As %String) As %String
{
	s result = ""
	q:(AInstanceID = "")||(AEpsiodeId = "") result
	s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s templatId = objInstance.TemplateID
	s templateVersion = objInstance.TemplateVersion	
	s versionId = $O(^DHCEMRM.TemplateVersionI("IndexTemplateVersion"," "_templatId,templateVersion,""))
	q:(versionId = "") result
	s objVersion = ##Class(EMRmeta.TemplateVersion).%OpenId(versionId)
	q:(objVersion = "") result
	s summaryItems = objVersion.TemplateSummary
	s count = $l(summaryItems,"^")
	for I=1:1:count
	{
		s item = $p(summaryItems,"^",I)
		s index = $f(item,"#")
		s name = $e(item,1,(index-2))
		s name = $p(name,".",$l(name,"."))
		s:((name'[":")&&(name'["：")&&(name '= "")) name = name_":"
		s code = $e(item,index,$l(item))
		s value = ##Class(EMRservice.BL.BLScatterData).GetScatterData(AEpsiodeId,code,AInstanceID)
		s value = name_value
		s:(value '= "") result = result_" "
		s result = result_value
	}
	s result = $ZSTRIP(result,"*C")
	s result = $tr(result,"""","'")
	q result
}

/// Desc:       根据目录展现结构取DocID
/// Creator：   Candy
/// CreateDate: 2014-4-8
/// Input:      AParentId 目录展现结构ID,取所有的为0
///             AEpisodeId 就诊ID
/// OutPut:     以","分隔的DOCID集合         
/// Debug       d ##Class(EMRservice.BL.BLClientCategory).GetDocIdsByParent(3)
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

/// Desc: 		按CategoryID取实例数据
/// Creator:	Candy
/// CreateDate:	2014-8-28
/// Input: 		AParentId CategoryID
///       		AEpisodeId 就诊号
/// Output:     Json
/// Debug:  	w ##Class(EMRservice.BL.BLClientCategory).GetInstanceJsonByCategoryID(3,76)
ClassMethod GetInstanceJsonByCategoryID(AParentId As %String, AEpisodeId As %String, AResultType As %String = "") As %GlobalCharacterStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	q:(AEpisodeId = "")||(AParentId = "") json
	s docIds = ..GetDocIdsByParent(AParentId)
	s length = $l(docIds,",")
	for I=1:1:length
	{
		s docId = $p(docIds,",",I)
		s docJson = ..DoInstanceJsonByDocID(docId,AEpisodeId,"Save",AResultType)
		d:(json.Size '= 0)&&(docJson.Size '= 0) json.Write(",")
		d json.CopyFrom(docJson)
	}
	q json
}

/// Desc:      取参考病历目录(取出相关病历,母婴病历)
/// Creator:   Candyxu
/// CreateDate:2015-10-19
/// Input:     ACTLocId 科室
///           AEpisodeId 就诊ID 
/// w ##class(web.DHCCM.EMRservice.BL.BLClientCategory).GetReferenceJsons(1218)
ClassMethod GetReferenceJsons(AEpisodeId As %String) As %GlobalCharacterStream
{
	
	s json = ##Class(%GlobalCharacterStream).%New()
	q:(AEpisodeId = "") json
	s episodeIds = $lb(AEpisodeId)
	s motheradm = $p(^PAADM(AEpisodeId),"^",75)
	if (motheradm '= "") 
	{
		s episodeIds = episodeIds_$lb(motheradm)
	}
	else
	{
		s babyadm = ""
		for
		{
			s babyadm = $o(^PAADMi("Mother",AEpisodeId,babyadm))
			q:(babyadm = "")
			s episodeIds = episodeIds_$lb(babyadm)
		}
	}

	for i = 1:1:$listlength(episodeIds) 
	{
		s episodeId = $listget(episodeIds,i)
		s patientId = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(episodeId)
		s desc = ##Class(EMRservice.HISInterface.PatientInfoAssist).Name(patientId)
		s category = ..GetBrowseCategory(episodeId,"ZTree")
		d:(i '= 1) json.Write(",")
		d json.Write("{")
		d json.Write("""id"":"""_episodeId_"""")
		d json.Write(",""name"":"""_desc_"""")
		d json.Write(",""children"":") d json.CopyFrom(category)
		d json.Write("}")
	}
	q json
}

/// Desc: 		   病历目录
/// Creator:		Candy
/// CreateDate: 	2014-8-29
/// Input:          ACTLocId 科室
///                 ASSgroupId 安全组
///                 AEpisodeId 就诊号
/// Output: 	    json
/// Debug:          w ##Class(web.DHCCM.EMRservice.BL.BLClientCategory).GetInstanceJson("199","200","1517","ZTree")	
ClassMethod GetInstanceJson(ACTLocId As %String, ASSgroupId As %String, AEpisodeId As %String, AResultType As %String = "") As %GlobalCharacterStream
{
	s json = ##Class(%GlobalCharacterStream).%New(),count = 0
	q:(ACTLocId = "")||(AEpisodeId = "")||(ASSgroupId = "") json	
		
	s result = ##class(%ResultSet).%New("web.DHCCM.EMRservice.BL.BLClientCategory:GetCategory")
	d result.Execute(ACTLocId,ASSgroupId,AEpisodeId)
	d json.Write("[")

	while result.%Next()
	{
		s ItemType = result.Data("ItemType")
		continue:(ItemType = "HIS")
		s categoryID = result.Data("ItemCategoryID")
		s docIds = ..GetDocIdsByParent(categoryID)
		s length = $l(docIds,",")
		for I=1:1:length
		{
			s docId = $p(docIds,",",I)
			s cjson = ..DoInstanceJsonByDocID(docId,AEpisodeId,"Save",AResultType)
		    continue:(cjson = "" || cjson.Size = 0)
		    s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(docId)
		    continue:(objTemplate = "")
		    d:(count '= 0) json.Write(",")
		    if (objTemplate.ChartItemType = "Single")
		    {
			    d json.CopyFrom(cjson)
			}
			else
			{
				//s directoryId = $o(^DHCEMRI.DirectoryInformationI("IdxEpisodeIDDocID"," "_AEpisodeId," "_docId,""))
				//continue:(directoryId = "")
		        //s objDirectory = ##Class(EMRinstance.DirectoryInformation).%OpenId(directoryId) 
			    // liubeibei 2018/7/4 EMRinstance.DirectoryInformation应该是存的分类信息，但没有存。且是电子病历的表结构，因此暂时将目录固定写死			  	  
			    d json.Write("{")
			    d json.Write("""id"":"""_docId_"""")
			    d json.Write(",""name"":"""_"药物治疗日志"_"""")
			    d json.Write(",""children"":[") d json.CopyFrom(cjson) d json.Write("]")
			    d json.Write("}")
			}
		    s count = count + 1		
		}
	} 
	d json.Write("]")	
	q json
}

/// Desc:		病历浏览目录
/// Creator:	Candy
/// CreateDate: 2014-8-28
/// Input: 		ACTLocId 科室
///       		AEpisodeId 就诊号
/// Output: 	json
/// Debug 		w ##Class(web.DHCCM.EMRservice.BL.BLClientCategory).GetBrowseCategory(76)
ClassMethod GetBrowseCategory(AEpisodeId As %String, AResultType As %String = "") As %GlobalBinaryStream
{
	s json = ##Class(%GlobalBinaryStream).%New()
	q:(AEpisodeId = "") json
	d json.Write("[")
	s result = ##class(%ResultSet).%New("web.DHCCM.EMRservice.BL.BLClientCategory:GetAllCategory")
	d result.Execute(AEpisodeId)	
	while result.%Next()
	{
		s ItemType = result.Data("ItemType")
		if (ItemType = "EMR")
		{
			s categoryID = result.Data("ItemCategoryID")	
			s docIds = ..GetDocIdsByParent(categoryID)
			s length = $l(docIds,",")
			for I=1:1:length
			{
				s docId = $p(docIds,",",I)
				s resultJson = ..DoInstanceJsonByDocID(docId,AEpisodeId,"SAVE",AResultType)
				continue:(resultJson.Size = 0)
				d:(json.Size '= 1) json.Write(",")
				s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(docId)
			    continue:(objTemplate = "")
			    if (objTemplate.ChartItemType = "Single")
			    {
				    d json.CopyFrom(resultJson)	
				}
				else
				{
					/*s directoryId = $o(^DHCEMRI.DirectoryInformationI("IdxEpisodeIDDocID"," "_AEpisodeId," "_docId,""))
					continue:(directoryId = "")
			        s objDirectory = ##Class(EMRinstance.DirectoryInformation).%OpenId(directoryId)
			        continue:(objDirectory = "")*/
				    d json.Write("{")
				    d json.Write("""id"":"""_docId_"""")
				    d json.Write(",""name"":"""_"药物治疗日志"_"""")
				    d json.Write(",""children"":[") d json.CopyFrom(resultJson) d json.Write("]")
				    d json.Write("}")
				}
				
			}	
		}
	}
	d json.Write("]")
	q json
}

/// Desc:     	按创建时间顺序返回病历目录列表
/// Creator:   	Candyxu
/// CreateDate:	2014-8-16
/// Input:     	AEpisodeId 就诊号
///           	AStatus 病历状态
/// Output:    	json
/// debug:     	w ##Class(EMRservice.BL.BLClientCategory).GetRecordCatalogByHappenDate("1974","save","List")
ClassMethod GetRecordCatalogByHappenDate(AEpisodeId As %String, AStatus As %String, AResultType As %String = "") As %GlobalCharacterStream
{
	s json = ##Class(%GlobalCharacterStream).%New(),count = 1
	q:(AEpisodeId = "") json
	s date = ""
	for
	{
		s date = $o(^DHCPHI.InstanceDataI("IdxEpisodeStatusHappenDateTime"," "_AEpisodeId," "_$zcvt(AStatus,"U"),date))
		q:(date = "")
		s time = ""
		for
		{
			s time = $o(^DHCPHI.InstanceDataI("IdxEpisodeStatusHappenDateTime"," "_AEpisodeId," "_$zcvt(AStatus,"U"),date,time))
			q:(time = "")
			s parentId = ""
			for
			{
				s parentId = $o(^DHCPHI.InstanceDataI("IdxEpisodeStatusHappenDateTime"," "_AEpisodeId," "_$zcvt(AStatus,"U"),date,time,parentId))
				q:(parentId = "")
				s subId = ""
				for
				{
					s subId = $o(^DHCPHI.InstanceDataI("IdxEpisodeStatusHappenDateTime"," "_AEpisodeId," "_$zcvt(AStatus,"U"),date,time,parentId,subId))
					q:(subId = "")
					s tempJson = ..GetInstanceJsonByID(parentId,subId,AResultType)
					continue:(tempJson = "")
					d:(count '= 1) json.Write(",")				
					d json.Write(tempJson)
					s count = count + 1
				}
			}
		}
	}
	q json
}

/// Desc: 取实例数据JSon
/// Creator:Candy
/// CreateDate:2014-11-28
/// Input:     AEcrecordID EMRinstance.ECRecord的ID
///            ASubID EMRinstance.InstanceData的subId
/// Debug:     w ##Class(web.DHCCM.EMRservice.BL.BLClientCategory).GetInstanceJsonByID(1,1,"ZTree")
ClassMethod GetInstanceJsonByID(AEcrecordID As %String, ASubID As %String, AResultType As %String = "") As %String
{
	s json = ""
	q:((AEcrecordID = "")||(ASubID = "")) json
	s rowId = AEcrecordID_"||"_ASubID
	s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(rowId)
	q:(objInstance = "") json
	s objRecord = ##Class(User.DHCPHECRecord).%OpenId(AEcrecordID)
	q:(objRecord = "") json
	s epsiodeId = objRecord.EpisodeID
	s docId = objRecord.ChartItemID
	s num = objInstance.ListNo
	s objCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
	q:(objCategoryDoc = "") json
	s objChapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objCategoryDoc.ParentCategoryID)
	q:(objChapter = "") json
	s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(docId)
	q:(objTemplate = "") json
	s happendate = ##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(objInstance.HappenDate)
	s happentime = $zt(objInstance.HappenTime)
	s log = ##Class(web.DHCCM.EMRservice.BL.BLEMRLogs).GetLogStatus(epsiodeId,docId,num)
	s status = $p(log,"^",11)
	s creator = $tr($p(log,"^",1)," ","")
	//获取病历日志明细最后一次操作的Action名字
	s action = $p(log,"^",8)
	s:(action '= "print") action = ""
	//表格视图查询json数据
	if (AResultType = "ZTree")
	{
		d RecordZTreeType
	}
	else
	{
		d RecordListType
	}
	k objInstance,objRecord,objCategoryDoc,objChapter,objTemplate
	s json = $ZSTRIP(json,"*C")
	q json
RecordListType
	s json = json_"{"
	s json = json_"""id"":"""_rowId_""""
	s json = json_",""text"":"""_objInstance.Title_""""
	s json = json_",""chartItemType"":"""_objTemplate.ChartItemType_"""" 
	s json = json_",""documentType"":"""_objTemplate.DocumentType_"""" 
	s json = json_",""categoryId"":"""_ objChapter.ParentCategoryID_""""
	s json = json_",""emrDocId"":"""_docId_""""
	s json = json_",""emrNum"":"""_num_""""
	s json = json_",""templateId"":"""_objInstance.TemplateID_""""
	s json = json_",""isLeadframe"":"""_objCategoryDoc.IsLeadframe_"""" 
	s json = json_",""isMutex"":"""_objChapter.IsMutex_"""" 
	s json = json_",""characteristic"":"""_objRecord.DocumentCharacteristic_""""
	s json = json_",""happendate"":"""_happendate_""""
	s json = json_",""happentime"":"""_happentime_""""
	s json = json_",""creator"":"""_creator_""""
	s json = json_",""status"":"""_status_""""
	s json = json_",""printstatus"":"""_action_""""
	s json = json_",""summary"":"""_objInstance.Memo_""""
	s json = json_"}"
	q
RecordZTreeType
	s text = happendate_" "_happentime_" "_objInstance.Title_" "_creator_" "_status	
	s json = json_"{"
	s json = json_"""id"":"""_rowId_""""
	s json = json_",""name"":"""_text_""""
	s json = json_",""attributes"":{" 
	s json = json_"""chartItemType"":"""_objTemplate.ChartItemType_"""" 
	s json = json_",""documentType"":"""_objTemplate.DocumentType_"""" 
	s json = json_",""categoryId"":"""_ objChapter.ParentCategoryID_""""
	s json = json_",""emrDocId"":"""_docId_""""
	s json = json_",""emrNum"":"""_num_""""
	s json = json_",""templateId"":"""_objInstance.TemplateID_""""
	s json = json_",""isLeadframe"":"""_objCategoryDoc.IsLeadframe_"""" 
	s json = json_",""isMutex"":"""_objChapter.IsMutex_"""" 
	s json = json_",""characteristic"":"""_objRecord.DocumentCharacteristic_""""
	s json = json_",""happendate"":"""_happendate_""""
	s json = json_",""happentime"":"""_happentime_""""
	s json = json_",""creator"":"""_creator_""""
	s json = json_",""status"":"""_status_""""
	s json = json_",""printstatus"":"""_action_""""
	s json = json_",""summary"":"""_objInstance.Memo_""""
	s json = json_",""text"":"""_objInstance.Title_""""
	s json = json_"}"
	s json = json_"}"	
	q
}

/// Desc:       根据docID取病历模板目录
/// Modify:     Candyxu
/// DateTime:   2014-7-17
/// Input:      AparentID:目录Id
///             AepisodeID:就诊号
/// OutPut:     json    
/// d ##Class(EMRservice.BL.BLClientCategory).GetTempCateByDocID(601,76)
ClassMethod GetTempCateByDocID(AdocID As %String, AepisodeID As %String) As %String
{
	s json = ""
	q:((AdocID = "")||(AepisodeID = "")) json
	s objCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(AdocID)
	q:(objCategoryDoc = "") json
	s objChapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objCategoryDoc.ParentCategoryID)
	q:(objChapter = "") json
	s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(AdocID)
	s json = json_"{"
	s json = json_ """id"":"""""
	s json = json_ ",""text"":"""_objChapter.CategoryName_""""
	s json = json_ ",""pluginType"":"""_objTemplate.DocumentType_""""
	s json = json_ ",""chartItemType"":"""_objTemplate.ChartItemType_""""
	s json = json_ ",""isLeadframe"":"""_objCategoryDoc.IsLeadframe_""""
	s json = json_ ",""isMutex"":"""_objCategoryDoc.IsMutex_""""
	s json = json_ ",""emrDocId"":"""_AdocID_""""
	s json = json_ ",""templateId"":"""_objTemplate.ID_""""
	s json = json_ ",""categoryId"":"""_objChapter.ParentCategoryID_""""
	s json = json_ ",""actionType"":""CREATE"""
	s json = json_ ",""closable"":""False"""
	s json = json_ "}"
	q json
}

/// Desc:       按DocID取标题信息
/// Creator:    Candy
/// CreateDate: 2015-4-15
/// Input:      ADocId 目录展现结构挂模板一层的目录ID
/// Output:     json 标题信息Json  
/// Debug:      w ##Class(EMRservice.BL.BLClientCategory).GetTitleByDocID(616)
ClassMethod GetTitleByDocID(ADocID As %String, AEpisodeID As %String, AEventType As %String = "", AEventID As %String = "", ACTLocId As %String = "") As %String
{
	s json = ""
	s count = 0
	s ds = ##Class(%Library.ResultSet).%New("EMRservice.BL.BLTitleConfig:GetTitleByDocID")
	d ds.Execute(ADocID,ACTLocId)
	While (ds.Next())
	{
		//判断标题是否只能创建一次，并是否已创建
		if (AEventID = "")
		{
			s isUniqueCreate = ..IsTitleUniqueCreate(ds.Data("ACode"),AEpisodeID) 
		}
		else
		{
			s isUniqueCreate = ..IsEventDocumentCreate(AEpisodeID,ADocID,ds.Data("ACode"),AEventType,AEventID)
		}
		continue:(isUniqueCreate = "1")
		
		s:(count '= 0) json = json_","
		s json = json_"{"
		s json = json_"""TitleCode"":"""_ds.Data("ACode")_""""
		s json = json_",""TitleDesc"":"""_ds.Data("ADesc")_"""" 
		s json = json_"}"
		s count = count + 1
	}
	q json
}

/// Desc:        判断标题是否只能创建一次，并是否已创建
/// Creator:     Candy
/// CreateDate:  2015-12-14
ClassMethod IsTitleUniqueCreate(ATitleCode As %String, AEpisodeID As %String)
{
	s result = 0
	q:((ATitleCode = "")||(AEpisodeID = "")) result
	s uniqueFlag = $d(^DHCEMRM.TitleConfigI("IdxTitleCodeUniqueCreate"," "_$zcvt(ATitleCode,"U")," TRUE"))
	s saveFlag = $d(^DHCPHI.InstanceDataI("IdxEpisodeTitleCodeStatus"," "_AEpisodeID," "_$zcvt(ATitleCode,"U")," SAVE"))
	s:((uniqueFlag >0) && (saveFlag >0)) result = 1
	q result
}

/// Desc:       判断事件关联病历是否已经书写
/// Creator:    Candy
/// CreateDate: 2015-12-14
ClassMethod IsEventDocumentCreate(AEpisodeID As %String, ADocID As %String, ATitleCode As %String, AEventType As %String, AEventID As %String)
{
	s result = 0
	q:(AEpisodeID = "")||(ADocID = "")||(ATitleCode = "")||(AEventType = "")||(AEventID = "") result
	s uniqueFlag = $d(^DHCEMRM.TitleConfigI("IdxTitleCodeUniqueCreate"," "_$zcvt(ATitleCode,"U")," TRUE"))
	s saveFlag = $d(^DHCEMRI.Events.LinkDocumnentsI("IdxEpisodeEventChartItemTitleCode"," "_AEpisodeID," "_$zcvt(AEventType,"U")," "_AEventID," "_ADocID," "_$zcvt(ATitleCode,"U")))
	s:((saveFlag >0)&&(uniqueFlag >0)) result = 1
	q result
}

/// Desc:       取事件关联病历数据
/// Creator:    Candy
/// CreateDate: 2015-12-16
/// Input:      ACategoryId 目录ID
///            AEpisodeId 就诊ID
///            AEventType 事件类型
///            AEventId 事件ID
/// Debug:      d ##Class(EMRservice.BL.BLClientCategory).GetInstanceByCategoryEvent(5,76,"Operation","1")
ClassMethod GetInstanceByCategoryEvent(ACategoryId As %String, AEpisodeId As %String, AEventType As %String, AEventId As %String) As %GlobalBinaryStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	q:(AEpisodeId = "")||(ACategoryId = "")||(AEventType = "")||(AEventId = "") json
	s docIds = ..GetDocIdsByParent(ACategoryId)
	s length = $l(docIds,",")
	for I=1:1:length
	{
		s docId = $p(docIds,",",I)
		s docJson = ##Class(EMRservice.BL.Event.BLLinkDocument).GetInstanceJson(docId,AEpisodeId,"Save",AEventType,AEventId)
		d:(json.Size '= 0)&&(docJson.Size '= 0) json.Write(",")
		d json.CopyFrom(docJson)
	}
	q json
}

/// Desc:       取未关联事件的病历信息
/// Creator:    Candy
/// CreateDate: 2016-3-7
/// Input:      ACategoryId
///            AEpisodeId
///            AEventType
/// OutPut:     result
ClassMethod GetInstanceNoLinkEvent(ACategoryId As %String, AEpisodeId As %String, AEventType As %String) As %GlobalBinaryStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	q:(AEpisodeId = "")||(ACategoryId = "")||(AEventType = "") json
	s docIds = ..GetDocIdsByParent(ACategoryId)
	s length = $l(docIds,",")
	for I=1:1:length
	{
		s docId = $p(docIds,",",I)
		s ecredordId = $o(^DHCPHI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeId," "_docId,""))
		continue:(ecredordId = "")
		s date = ""
		for
		{
			s date = $o(^DHCPHI.InstanceDataI("IdxHappenDateTime",ecredordId," SAVE",date))
			q:(date = "")
			s time = ""
			for
			{
				s time = $o(^DHCPHI.InstanceDataI("IdxHappenDateTime",ecredordId," SAVE",date,time))
				q:(time = "")
				s subId = ""
				for
				{
					s subId = $o(^DHCPHI.InstanceDataI("IdxHappenDateTime",ecredordId," SAVE",date,time,subId))
					q:(subId = "")
					continue:($d(^DHCEMRI.Events.LinkDocumnentsI("IdxInstanceType"," "_ecredordId_"||"_subId," "_$zcvt(AEventType,"U")))>0)
					s resultJson = ..GetInstanceJsonByID(ecredordId,subId)
					continue:(resultJson = "")
					d:(json.Size '= 0) json.Write(",")
					d json.Write(resultJson)
				}
			}
		} 
	}
	q json
}

/// Desc:       取病历操作人员代码
/// Creator:    zhaowuqiang
/// CreateDate: 2016-11-25
/// Input:      creator
/// Output：    userCode       
/// d ##Class(web.DHCCM.EMRservice.BL.BLClientCategory).GetuserCode("张月琴")
ClassMethod GetuserCode(creator)
{
	s userId=""
	s userId=$o(^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP^SSUTIL4(creator),userId))
	s userCode=$p(^SSU("SSUSR",userId),"^",1)
	q userCode
}

}
