Class EMRservice.BL.BLClientCategory Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       取配置前端目录展现病历目录
/// Creator:    Candy
/// CreateDate: 2014-8-27
/// Input:      ACTLocID 用户登录科室
///             ASSGroupID 用户安全组
///             AEpisodeID 患者就诊号
/// Debug       d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLClientCategory","GetCategory",6,29,112,"Running")
Query GetCategory(ACTLocID As %String, ASSGroupID As %String, AEpisodeID As %String) As %Query(ROWSPEC = "ItemID:%String,ItemTitle:%String,ItemImagePath:%String,ItemCategoryID:%String,ItemURL:%String,ItemParas:%String,ItemType:%String,recordFlag:%String")
{
}

ClassMethod GetCategoryExecute(ByRef qHandle As %Binary, ACTLocID As %String, ASSGroupID As %String, AEpisodeID As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
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
	//如果该科室设置病例导航科室项目顺序，通过科室项目顺序获取
	s rowSeqID = $o(^DHCEMRM.EMRNavSchemeItemSeqLocI("IdxLocGID"," "_ACTLocID,""))
	if (rowSeqID'="")
	{
		s objItemSeqLoc = ##class(EMRmeta.EMRNavigationSchemeItemSeqLoc).%OpenId(rowSeqID)
		s strCTLocGroupID = objItemSeqLoc.CTLocGroupID
		s seq = ""
		for
		{
			s seq = $o(^DHCEMRM.EMRNavSchemeItemSeqI("IdxSchemeLocGSeq"," "_strCTLocGroupID," "_schemType,seq))
			q:(seq = "")
			s seqrowId = ""
			for
			{
				s seqrowId = $o(^DHCEMRM.EMRNavSchemeItemSeqI("IdxSchemeLocGSeq"," "_strCTLocGroupID," "_schemType,seq,seqrowId))
				q:(seqrowId = "")
				s objNavSeqItem = ##Class(EMRmeta.EMRNavigationSchemeItemSeq).%OpenId(seqrowId)
				s rowId = objNavSeqItem.ItemID
				d getData
				
			}
		}
	}
	else //如果该科室没有设置病例导航科室项目顺序，通过默认顺序获取
	{
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
				d getData
					
			}
		}
	}	
    Quit $$$OK
getData
	s objNavItem = ##Class(EMRmeta.EMRNavigationSchemeItem).%OpenId(rowId)
	q:(objNavItem = "")
	q:(objNavItem.ItemCode = "")
	q:(objNavItem.ItemDr = "")
	q:($d(^DHCEMRM.EMRNavItemSSGroupI("IdxCodeSSGroup"," "_schemType," "_objNavItem.ItemCode," "_ASSGroupID))<=0)			
	s locFlag = $d(^DHCEMRM.EMRNavItemLocI("IdxCodeCTLocID"," "_schemType," "_objNavItem.ItemCode," "_ACTLocID))
	s objOrgItem = ##Class(EMRmeta.CTOrganizationSchemeItem).%OpenId(objNavItem.ItemDr)
	q:(objOrgItem = "")
	s type = ""
	s:(objOrgItem.ItemType '= "") type = objOrgItem.ItemType
	s:(type = "") type = $Case(objOrgItem.EMRTemplateCategoryID,"":"HIS",:"EMR")
	s recordFlag = "0"
	if (type = "EMR")
	{
		s recordFlag = ..CheckHasRecord(objOrgItem.EMRTemplateCategoryID,AEpisodeID)
		q:((locFlag <= 0)&&(recordFlag <= 0))
	} 
	else
	{
		q:(locFlag <= 0)
	}
	s itemTitle = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.CTOrganizationSchemeItem","ItemTitle",objOrgItem.ItemTitle,langid)
	s data = $lb(objNavItem.ItemDr,itemTitle,objOrgItem.imagePath,objOrgItem.EMRTemplateCategoryID,objOrgItem.ItemURL,objOrgItem.ItemParas,type,recordFlag)
	s ^CacheTemp(repid,ind) = data
	s ind=ind+1
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

/// Desc:		判断categoryId是否在当前科室病历目录导航下
/// Creator:	liuyunfei
/// CreateDate:	2020-04-21
/// Input:		AEpisodeID：患者就诊号
/// 			ALocID：	用户登录科室
/// 			ACategoryId:categoryId
/// 			AGroupID:	用户安全组
/// output:		result: 1:在；0:不在
/// Debug:     	w ##Class(EMRservice.BL.BLClientCategory).CheckCategoryIdInLocId("1","95","3","29")
ClassMethod CheckCategoryIdInLocId(AEpisodeID As %String, ALocID As %String, ACategoryId As %String, AGroupID As %String)
{
	q:(AEpisodeID="")||(ALocID="")||(ACategoryId="") 0
	s result = 0
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
	
	s rowId = ""
	for
	{
		s rowId = $o(^DHCEMRM.CTOrgSchemeItemI("IdxEMRTemplateCategoryID"," "_ACategoryId,rowId))
		q:(rowId="")
		s objOrgItem = ##Class(EMRmeta.CTOrganizationSchemeItem).%OpenId(rowId)
		q:(objOrgItem="")
		continue:($d(^DHCEMRM.EMRNavItemSSGroupI("IdxCodeSSGroup"," "_schemType," "_objOrgItem.ItemCode," "_AGroupID))<=0)
		continue:($d(^DHCEMRM.EMRNavItemLocI("IdxCodeCTLocID"," "_schemType," "_objOrgItem.ItemCode," "_ALocID))<=0)
		s result=1
		q
	}
	q result
}

/// Desc:       前端写过病历的病历展现目录
/// Creator:    Candy
/// CreateDate: 2014-8-27
/// Input:      AEpisodeID 用户登录科室
/// Debug       d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLClientCategory","GetAllCategory",76)
Query GetAllCategory(AEpisodeID As %String, AStatus As %String) As %Query(ROWSPEC = "ItemID:%String,ItemTitle:%String,ItemImagePath:%String,ItemCategoryID:%String,ItemURL:%String,ItemParas:%String,ItemType:%String")
{
}

ClassMethod GetAllCategoryExecute(ByRef qHandle As %Binary, AEpisodeID As %String, AStatus As %String = "Save") As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	q:(AEpisodeID = "") $$$OK
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
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
			if (type = "EMR")
			{
				s recordFlag = ..CheckHasRecord(objOrgItem.EMRTemplateCategoryID,AEpisodeID,AStatus)
				continue:(recordFlag <= 0)
			}
			s title = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.CTOrganizationSchemeItem","ItemTitle",objOrgItem.ItemTitle,langid)
			s data = $lb(objNavItem.ItemDr,title,objOrgItem.imagePath,objOrgItem.EMRTemplateCategoryID,objOrgItem.ItemURL,objOrgItem.ItemParas,type)
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
ClassMethod CheckHasRecord(ACategoryID As %String, AEpisodeID As %String, AStatus As %String = "Save") As %String
{
	s result = 0
	s docIds = ..GetDocIdsByParent(ACategoryID)
	q:(docIds="") result
	s length = $l(docIds,",")
	for I=1:1:length
	{
		s docId = $p(docIds,",",I)
		s rowId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID,docId,""))
		continue:(rowId = "")
		s flag = $d(^DHCEMRI.InstanceDataI("IdxHappenDateTime",rowId," "_$zcvt(AStatus,"U")))
		s:(flag >0) result = 1
		q:(result =1)
	}	
	q result
}

/// Desc:      判断目录展现结构下写病历的数量
/// Input:     ACategoryID 目录ID
///            AEpisodeID 就诊号
/// Output:    所写病历的数量
/// Debug:     w ##Class(EMRservice.BL.BLClientCategory).GetRecordCount(3,456449)
ClassMethod GetRecordCount(ACategoryID As %String, AEpisodeID As %String) As %String
{
	s count = 0
	s docIds = ..GetDocIdsByParent(ACategoryID)
    q:(docIds="") count
    
	s length = $l(docIds,",")
	for I=1:1:length
	{
		s docId = $p(docIds,",",I)
		s rowId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID,docId,""))
		continue:(rowId = "")
		s date = ""
		for
		{
			s date = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",rowId," SAVE",date))
			q:(date = "")
			s time = ""
			for
			{
				s time = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",rowId," SAVE",date,time))	
				q:(time = "")
				s subId = ""
				for
				{
					s subId = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",rowId," SAVE",date,time,subId))			
					q:(subId = "")
					s count = count + 1			
				}
			}
		}
	}	
	q count
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

	s result = ##class(%ResultSet).%New("EMRservice.BL.BLClientCategory:GetCategory")
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

/// Desc:      取目录下doc
/// Creator:   Candy
/// CreateDate:2016-11-26
/// Debug:     d ##Class(EMRservice.BL.BLClientCategory).GetDocByCategoryID(3,76,105)
ClassMethod GetDocByCategoryID(AParentID As %String, AEpisodeID As %String, AUserID As %String, APriActivity As %String, AParPatInfo As %Library.List) As %String
{
	s result = ""
	s mutexdoc = ""
	s nomutexdoc = ""
	q:((AParentID = "")||(AEpisodeID = "")) result
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
			//获取符号权限的DOCID集合已^分隔		
			s curDocIDS = ..GetDocIDInChapter(AEpisodeID,"",curCategoryId,APriActivity,AParPatInfo)
			continue:(curDocIDS = "")
			for i=1:1:$l(curDocIDS,"^")
			{
				s strDocID = $p(curDocIDS,"^",i)
				//根据DOCID获取属性对象
				s curObjDocCategory = ..GetEmrCategoryPropertyByDocID(strDocID)
				
				s curDocId = $e(curObjDocCategory.ID,3,$l(curObjDocCategory.ID))  	
				continue:(curDocId = "")
				s curIsMutex = objEMRTemplateCategory.IsMutex
		        s:(curIsMutex '= 1) curIsMutex = 0	
		        if (curIsMutex = 1)
		        {
			        s mutexdoc = $case(mutexdoc,"":curDocId,:mutexdoc_"^"_curDocId)
			    }
			    else
			    {
				    s nomutexdoc = $case(nomutexdoc,"":curDocId,:nomutexdoc_"^"_curDocId)
				}	
			}
		}
	}
	//根据用户使用频率排序
	if (##Class(EMRservice.SystemParameter).IsSortByUserFrequency() = "Y")&&(AUserID'="")
	{
		s mutexdoc = ##Class(EMRservice.BL.BLClientCategory).SortDocIDByFrequency(mutexdoc,AUserID)
		s nomutexdoc = ##Class(EMRservice.BL.BLClientCategory).SortDocIDByFrequency(nomutexdoc,AUserID)
	}
	s result = mutexdoc_"&"_nomutexdoc
	
	q result
}

/// Desc:       病历模板目录
/// Modify:     Candyxu
/// DateTime:   2016-11-28
/// Input:      AParentId:目录CategoryId
///             AEpisodeID:就诊号
/// OutPut:     json   
/// Debug:      w ##Class(EMRservice.BL.BLClientCategory).GetTempCateJsonByCategoryID(4,456449,4173,"List")
ClassMethod GetTempCateJsonByCategoryID(AParentID As %String, AEpisodeID As %String, AUserID As %String, AResultType As %String = "", AEventType As %String = "", AEventID As %String = "", ACTLocId As %String = "", ADocId As %String = "", ACollect As %String = "") As %GlobalCharacterStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	s priActivity = ..CheckTPrivActivity()  //权限控制
	s curPatInfo = ##class(EMRservice.DocRestLogic.PrivLogic).GetPatInfo(AEpisodeID,AUserID)
	s patDept = $p($li(curPatInfo,2),$c(2),2)
	s strdocIds = ..GetDocByCategoryID(AParentID,AEpisodeID,AUserID,priActivity,curPatInfo)
	q:((AParentID = "")||(AEpisodeID = "")) json
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		s userId =+$g(%session.Data("LOGON.USERID"))  
	}
	s mutexdoc = $p(strdocIds,"&",1)
	s nomutexdoc = $p(strdocIds,"&",2)
	s iswrited = ##class(EMRservice.BL.BLInstanceData).IsHasInstanceByDocIDs(AEpisodeID,mutexdoc)
	if (iswrited = "1")
	{
	 	s strdocIds = nomutexdoc
	}
	else
	{
		s strdocIds = mutexdoc_"^"_nomutexdoc
	}
	s key = $i(^CacheTemp("GetTempCateJsonByCategoryID"))
	for i=1:1:$l(strdocIds,"^")
	{
		s docId = $p(strdocIds,"^",i)
		continue:(docId = "")
		//continue:((ADocId '= "")&&(ADocId '= docId))
		s tempFlag = 0
		if (ADocId '= "")
		{
			for k=1:1:$l(ADocId,",")
			{
				s tempADocId = $p(ADocId,",",k)
				if (tempADocId = docId)
				{
					s tempFlag = 1
					q
				}
			}
			continue:(tempFlag = 0)
		}
		s objdoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
        continue:(objdoc = "")
		s objchapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objdoc.ParentCategoryID)
		continue:(objchapter = "")
		s objcategory = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objchapter.ParentCategoryID)
		continue:(objcategory = "")
		
		s JaneSpell = objchapter.JaneSpell
	    s FullFight = objchapter.FullFight
		
		//病历是否已写，写过则不显示新建卡片
		/*
		if ((AEventID '= "") && (AEventType '= ""))
		{
			s isLinkDocumentWrited = ##Class(EMRservice.BL.Event.BLLinkDocument).IsLinkDocumentWrited(AEpisodeID,docId,AEventType,AEventID)
			continue:(isLinkDocumentWrited = 1)
		}
		*/
		s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(docId)
	    continue:(objTemplate = "")
	    
	    s objEMRTemplateCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
	    set EMRChartItemType = ##class(EMRservice.EMRDoc.DocCategoryFunSet).GetChapterDocType(objEMRTemplateCategoryDoc.ParentCategoryID)
	
	    s result = ##class(EMRservice.BL.BLInstanceData).IsHasInstance(AEpisodeID, objTemplate.ID,docId)
		continue:((result '= 0) && (objTemplate.ChartItemType = "Single"))	
		s childs = ..GetTitleByDocID(docId,AEpisodeID,AEventType,AEventID,ACTLocId)
		s quotationFlag = ##Class(EMRservice.BL.BLQuotation).GetDocQuationFlag(patDept,docId) 
		s displayFlag = ##Class(EMRservice.SystemParameter).SetNavQuoteDisplay(AEpisodeID)
		s:(displayFlag = "N") quotationFlag = "0"
		s title = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.EMRTemplateCategory","CategoryName",objchapter.CategoryName,langid)
		s docidText = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.EMRTemplateCategory","CategoryName",objdoc.CategoryName,langid)
        s collect = ##Class(EMRservice.BL.BLCollectTemplate).GetIsCollect(AUserID,docId)
        if (AResultType = "List")
        {
	        continue:((ACollect="collect")&&(+collect'=1))
	        d DisplayInList 
	    }
	    else
		{
			continue:((ACollect="collect")&&(+collect'=1))
			d DisPlayInTree
		}
		s cjson = $ZSTRIP(cjson,"*C")
		s ^CacheTemp("GetTempCateJsonByCategoryID",key,i)= cjson
		s ^CacheTemp("GetTempCateJsonByCategoryID",key,"Flag",docId) = i
	}
	if (AResultType = "List")
	{
		s tempJson = ##Class(EMRservice.BL.BLEMRTemplateDocGroup).GetGroupTemplate(patDept,"CG"_AParentID,key)
		d json.CopyFrom(tempJson)
	}
	if ( "Y"=##Class(EMRservice.SystemParameter).IsLoadTemplateByFrequency(userId) )
	{
		d ..ChangeTemplateSeqByFrequency(key,userId)
	}
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
    s cjson = "{"
	s cjson = cjson_ """id"":"""_docId_""""
	s cjson = cjson_ ",""text"":"""_$s(((EMRChartItemType="Multiple")&&(objdoc.IsLeadframe=0)):docidText,1:title)_""""
	s cjson = cjson_ ",""type"":""TempCate""" 
	s cjson = cjson_ ",""chartItemType"":"""_objTemplate.ChartItemType_"""" 
	s cjson = cjson_ ",""documentType"":"""_objTemplate.DocumentType_"""" 
	s cjson = cjson_ ",""isLeadframe"":"""_objdoc.IsLeadframe_""""
	s cjson = cjson_ ",""isMutex"":"""_objchapter.IsMutex_""""
	s cjson = cjson_",""templateId"":"""_objTemplate.ID_""""
	s cjson = cjson_",""categoryId"":"""_AParentID_""""
	s cjson = cjson_",""quotation"":"""_$case(quotationFlag>0,1:1,:0)_""""
	s cjson = cjson_ ",""JaneSpell"":"""_JaneSpell_"""" 
	s cjson = cjson_ ",""FullFight"":"""_FullFight_""""
	s cjson = cjson_ ",""DocIDText"":"""_docidText_""""
	s docIDTitle = docidText
	if ($l(docidText)>"29")
	{
		s docIDTitle = $e(docidText,1,29)_"..."
	}
	s cjson = cjson_ ",""DocIDTitle"":"""_docIDTitle_""""
	s cjson = cjson_ ",""isCollect"":"""_collect_""""
	s cjson = cjson_ "}"
	q
DisPlayInTree  
	s cjson = "{"
	s cjson = cjson_ """id"":"""_docId_""""
	s cjson = cjson_ ",""isCollect"":"""_collect_""""
	s cjson = cjson_ ",""text"":"""_$s(((EMRChartItemType="Multiple")&&(objdoc.IsLeadframe=0)):docidText,1:title)_""""
	s cjson = cjson_ ",""childs"":["_childs_"]"
	s cjson = cjson_ ",""attributes"":{" 
	s cjson = cjson_ """type"":""TempCate""" 
	s cjson = cjson_ ",""chartItemType"":"""_objTemplate.ChartItemType_"""" 
	s cjson = cjson_ ",""documentType"":"""_objTemplate.DocumentType_"""" 
	s cjson = cjson_ ",""isLeadframe"":"""_objdoc.IsLeadframe_""""
	s cjson = cjson_ ",""isMutex"":"""_objchapter.IsMutex_""""
	s cjson = cjson_",""templateId"":"""_objTemplate.ID_""""
	s cjson = cjson_",""categoryId"":"""_AParentID_""""
	s cjson = cjson_",""quotation"":"""_$case(quotationFlag>0,1:1,:0)_""""
	s cjson = cjson_ ",""JaneSpell"":"""_JaneSpell_"""" 
	s cjson = cjson_ ",""FullFight"":"""_FullFight_"""" 
	s cjson = cjson_ ",""DocIDText"":"""_docidText_""""
	s docIDTitle = docidText
	if ($l(docidText)>"29")
	{
		s docIDTitle = $e(docidText,1,29)_"..."
	}
	s cjson = cjson_ ",""DocIDTitle"":"""_docIDTitle_""""	
	s cjson = cjson_ "}"
	s cjson = cjson_ "}"
	q
}

/// Debug:w ##Class(EMRservice.BL.BLClientCategory).ChangeTemplateSeqByFrequency()
ClassMethod ChangeTemplateSeqByFrequency(AKey As %String, AUserID As %String)
{

	s newKey = $i(^CacheTemp)
	s newKey2 = $i(^CacheTemp)
	
	s EMRDocId = ""
	for{
		s EMRDocId = $o(^CacheTemp("GetTempCateJsonByCategoryID",AKey,"Flag",EMRDocId))
		q:(EMRDocId="")
		//Frequency
		s Frequency = ##Class(EMRservice.BL.BLTemplateFrequency).GetData(AUserID,EMRDocId)
		s sequence = $g(^CacheTemp("GetTempCateJsonByCategoryID",AKey,"Flag",EMRDocId))
		s data = $g(^CacheTemp("GetTempCateJsonByCategoryID",AKey,sequence))
		
		s ^CacheTemp("GetTempCateJsonByCategoryID",newKey,Frequency,sequence,EMRDocId) = data
		//s ^CacheTemp("GetTempCateJsonByCategoryID",newKey,"Flag",EMRDocId) = $lb(Frequency,sequence)
	}
	
	s tmpFrq = "",newSeq=""
	for
	{
		s tmpFrq = $o(^CacheTemp("GetTempCateJsonByCategoryID",newKey,tmpFrq),-1)
		q:(tmpFrq="")
		s tmpseq = ""
		for
		{
			s tmpseq = $o(^CacheTemp("GetTempCateJsonByCategoryID",newKey,tmpFrq,tmpseq))
			q:(tmpseq="")
			s tmpDocID=""
			for
			{
				s tmpDocID = $o(^CacheTemp("GetTempCateJsonByCategoryID",newKey,tmpFrq,tmpseq,tmpDocID))
				q:(tmpDocID="")
				s tmpData = $g(^CacheTemp("GetTempCateJsonByCategoryID",newKey,tmpFrq,tmpseq,tmpDocID))
				s newSeq=+$g(newSeq)+1
				s ^CacheTemp("GetTempCateJsonByCategoryID",newKey2,"Flag",tmpDocID)=newSeq
				s ^CacheTemp("GetTempCateJsonByCategoryID",newKey2,newSeq)=tmpData

			}
		}
		
	}
	k ^CacheTemp("GetTempCateJsonByCategoryID",AKey)
	merge ^CacheTemp("GetTempCateJsonByCategoryID",AKey) = ^CacheTemp("GetTempCateJsonByCategoryID",newKey2)
}

/// Desc:       病历模板目录
/// Modify:     yejian
/// DateTime:   2021-6-17
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
/// 			pDiseaseCodeAndName:诊断
/// OutPut:     json   
/// Debug:      w ##Class(EMRservice.BL.BLClientCategory).GetTempCateJsonByCategoryIDNew(12,4,10209,"List","","",)
ClassMethod GetTempCateJsonByCategoryIDNew(AParentID As %String, AEpisodeID As %String, AUserID As %String, AResultType As %String = "", AEventType As %String = "", AEventID As %String = "", ACTLocId As %String = "", ADocId As %String = "", AOtherCTLocId As %String = "", pText As %String = "", pDiseaseCodeAndName As %String = "", pcollect As %String = "") As %GlobalCharacterStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	s priActivity = ..CheckTPrivActivity()  //权限控制
	//知情同意书单独处理
	s objCate = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(AParentID)
	s isGetAgree = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("GetNewAgreeRecord","N")
	if (objCate'="")&&(objCate.InternalID ="EMR07")&&(isGetAgree="Y")
	{
		q ..GetTempCateAgreeJsonByCategoryID(AParentID,AEpisodeID,AUserID,AResultType,AEventType,AEventID,ACTLocId,ADocId,AOtherCTLocId,pText,pcollect)
	}
	s ctLocID =$case(AOtherCTLocId,"ALL":"","":ACTLocId,:AOtherCTLocId)
	s curPatInfo = ##class(EMRservice.DocRestLogic.PrivLogic).GetPatInfoByCT(AEpisodeID,AUserID,ctLocID)
	//s curPatInfo = ##class(EMRservice.DocRestLogic.PrivLogic).GetPatInfo(AEpisodeID,AUserID)
	s patDept = $p($li(curPatInfo,2),$c(2),2)
	if ((AOtherCTLocId="ALL")&&(objCate.InternalID="EMR07"))
	{
		s strdocIds = ..GetAllDocByCategoryID(AParentID,AEpisodeID,pText,ACTLocId)
	}
	else
	{
		s strdocIds = ..GetDocByCategoryID(AParentID,AEpisodeID,AUserID,priActivity,curPatInfo)
	}
	q:((AParentID = "")||(AEpisodeID = "")) json
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	s mutexdoc = $p(strdocIds,"&",1)
	s nomutexdoc = $p(strdocIds,"&",2)
	s iswrited = ##class(EMRservice.BL.BLInstanceData).IsHasInstanceByDocIDs(AEpisodeID,mutexdoc)
	if (iswrited = "1")
	{
	 	s strdocIds = nomutexdoc
	}
	else
	{
		s strdocIds = mutexdoc_"^"_nomutexdoc
	}
	//无关联手术、需要通过系统参数判断docID
	if ((AEventType= "Operation")&&(AEventID=""))
	{
		//获取无关联手术的相关模板DocIDs "70^68^80^76"
	    s operativeDocIds = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("OperativeDocIds","")
	    q:($ZSTRIP(operativeDocIds,"*C") = "") json
	    s result = ""
	    for i=1:1:$l(strdocIds,"^")
	    {
	        s tmpDocId = $p(strdocIds,"^",i)
	        continue:($f("^"_operativeDocIds_"^", "^"_tmpDocId_"^") = 0)
	        s result = $case(result,"":tmpDocId,:result_"^"_tmpDocId)
	    }
	    q:(result = "") json
	    s strdocIds = result
	}
	s key = $i(^CacheTemp("GetTempCateJsonByCategoryID"))
	for i=1:1:$l(strdocIds,"^")
	{
		s docId = $p(strdocIds,"^",i)
		continue:(docId = "")
		//continue:((ADocId '= "")&&(ADocId '= docId))
		s tempFlag = 0
		if (ADocId '= "")
		{
			for k=1:1:$l(ADocId,",")
			{
				s tempADocId = $p(ADocId,",",k)
				if (tempADocId = docId)
				{
					s tempFlag = 1
					q
				}
			}
			continue:(tempFlag = 0)
		}
		s objdoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
        continue:(objdoc = "")
		s objchapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objdoc.ParentCategoryID)
		continue:(objchapter = "")
		s objcategory = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objchapter.ParentCategoryID)
		continue:(objcategory = "")
		
		s JaneSpell = objchapter.JaneSpell
	    s FullFight = objchapter.FullFight
		
		//病历是否已写，写过则不显示新建卡片
		/*
		if ((AEventID '= "") && (AEventType '= ""))
		{
			s isLinkDocumentWrited = ##Class(EMRservice.BL.Event.BLLinkDocument).IsLinkDocumentWrited(AEpisodeID,docId,AEventType,AEventID)
			continue:(isLinkDocumentWrited = 1)
		}
		*/
		s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(docId)
	    continue:(objTemplate = "")
	    
	    s objEMRTemplateCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
	    set EMRChartItemType = ##class(EMRservice.EMRDoc.DocCategoryFunSet).GetChapterDocType(objEMRTemplateCategoryDoc.ParentCategoryID)
	
	    s result = ##class(EMRservice.BL.BLInstanceData).IsHasInstance(AEpisodeID, objTemplate.ID,docId)
		continue:((result '= 0) && (objTemplate.ChartItemType = "Single"))	
		s childs = ..GetTitleByDocID(docId,AEpisodeID,AEventType,AEventID,ACTLocId)
		s quotationFlag = ##Class(EMRservice.BL.BLQuotation).GetDocQuationFlag(patDept,docId) 
		s displayFlag = ##Class(EMRservice.SystemParameter).SetNavQuoteDisplay(AEpisodeID)
		s:(displayFlag = "N") quotationFlag = "0"
		s title = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.EMRTemplateCategory","CategoryName",objchapter.CategoryName,langid)
		s docidText = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.EMRTemplateCategory","CategoryName",objdoc.CategoryName,langid)  
       	
       	//获取科室模板数据
       	s strjson =""
       	s strjson = strjson_ ",""emrDocId"":"""_docId_"""" 
		s strjson = strjson_ ",""chartItemType"":"""_objTemplate.ChartItemType_"""" 
		s strjson = strjson_ ",""documentType"":"""_objTemplate.DocumentType_"""" 
		s strjson = strjson_ ",""isLeadframe"":"""_objdoc.IsLeadframe_""""
		s strjson = strjson_ ",""isMutex"":"""_objchapter.IsMutex_""""
		s strjson = strjson_",""templateId"":"""_objTemplate.ID_""""
		s strjson = strjson_",""categoryId"":"""_AParentID_""""
		s strjson = strjson_",""quotation"":"""_$case(quotationFlag>0,1:1,:0)_""""
		s strjson = strjson_ ",""JaneSpell"":"""_JaneSpell_"""" 
		s strjson = strjson_ ",""FullFight"":"""_FullFight_""""
		
       	s userTemps= ""
       	s ctLocID =$case(AOtherCTLocId,"ALL":"","":ACTLocId,:AOtherCTLocId)
       	s streamTemps = ##Class(EMRservice.BL.BLUserTemplate).GetUserTemplateJsonNew(ctLocID,docId,AEpisodeID,pText,AUserID,pDiseaseCodeAndName,strjson)
       	//获取通用标题数据
       	s titleTemps =  ##Class(EMRservice.BL.BLTitleConfig).GetTitlesNew(docId,ctLocID,pText,AUserID,strjson,AEpisodeID)
       	if ((streamTemps'="")&&(streamTemps.Size>1))||((titleTemps'="")&&(titleTemps.Size>1))
       	{	
			if (streamTemps.Size>0)
	       	{
       			s userTemps = streamTemps.Read(streamTemps.Size)
	       	}
	       	if (titleTemps.Size>0)
	       	{
	       		s:(userTemps'="") userTemps = userTemps_","_titleTemps.Read(titleTemps.Size) 
	       		s:(userTemps="") userTemps = titleTemps.Read(titleTemps.Size) 
	       	}
       	}
       	else //科室模板没有数据则过滤DOCID数据
       	{
	       	s strDocIDText=$s(((EMRChartItemType="Multiple")&&(objdoc.IsLeadframe=0)):docidText,1:title)
			continue:(($find(strDocIDText,pText) = 0)&&($find(JaneSpell,pText) = 0)&&($find(FullFight,pText) = 0))   	
       	}
       	
       	
        if (AResultType = "List")
        {
	        d DisplayInList 
	    }
	    else
		{
			d DisPlayInTree
		}
		s cjson = $ZSTRIP(cjson,"*C")
		s ^CacheTemp("GetTempCateJsonByCategoryID",key,i)= cjson
		s ^CacheTemp("GetTempCateJsonByCategoryID",key,"Flag",docId) = i
	}
	if (AResultType = "List")
	{
		s tempJson = ##Class(EMRservice.BL.BLEMRTemplateDocGroup).GetGroupTemplate(patDept,"CG"_AParentID,key,pText)
		d json.CopyFrom(tempJson)
	}
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
	//获取是否收藏
    s collect = ##Class(EMRservice.BL.BLCollectTemplate).GetIsCollect(AUserID,docId)
    s cjson = "{"
	s cjson = cjson_ """id"":"""_"TempCate-"_docId_""""
	s cjson = cjson_ ",""text"":"""_$s(((EMRChartItemType="Multiple")&&(objdoc.IsLeadframe=0)):docidText,1:title)_""""
	s cjson = cjson_ ",""type"":""TempCate""" 
	s cjson = cjson_ ",""emrDocId"":"""_docId_"""" 
	s cjson = cjson_ ",""chartItemType"":"""_objTemplate.ChartItemType_"""" 
	s cjson = cjson_ ",""documentType"":"""_objTemplate.DocumentType_"""" 
	s cjson = cjson_ ",""isLeadframe"":"""_objdoc.IsLeadframe_""""
	s cjson = cjson_ ",""isMutex"":"""_objchapter.IsMutex_""""
	s cjson = cjson_",""templateId"":"""_objTemplate.ID_""""
	s cjson = cjson_",""categoryId"":"""_AParentID_""""
	s cjson = cjson_",""quotation"":"""_$case(quotationFlag>0,1:1,:0)_""""
	s cjson = cjson_ ",""JaneSpell"":"""_JaneSpell_"""" 
	s cjson = cjson_ ",""FullFight"":"""_FullFight_""""
	s cjson = cjson_ ",""DocIDText"":"""_docidText_""""
	s cjson = cjson_ ",""iconCls"":""general-template"""
	s cjson = cjson_ ",""isCollect"":"""_collect_""""
	//科室模板添加为子节点数据
	if (userTemps'="")
	{
		s cjson = cjson_ ",""children"":["_userTemps_"]"
	}
	s cjson = cjson_ "}"
	q
DisPlayInTree  
	s collect = ##Class(EMRservice.BL.BLCollectTemplate).GetIsCollect(AUserID,docId)
	s cjson = "{"
	s cjson = cjson_ """id"":"""_docId_""""
	s cjson = cjson_ ",""text"":"""_$s(((EMRChartItemType="Multiple")&&(objdoc.IsLeadframe=0)):docidText,1:title)_""""
	s cjson = cjson_ ",""childs"":["_childs_"]"
	s cjson = cjson_ ",""isCollect"":"""_collect_""""
	s cjson = cjson_ ",""attributes"":{" 
	s cjson = cjson_ """type"":""TempCate""" 
	s cjson = cjson_ ",""chartItemType"":"""_objTemplate.ChartItemType_"""" 
	s cjson = cjson_ ",""documentType"":"""_objTemplate.DocumentType_"""" 
	s cjson = cjson_ ",""isLeadframe"":"""_objdoc.IsLeadframe_""""
	s cjson = cjson_ ",""isMutex"":"""_objchapter.IsMutex_""""
	s cjson = cjson_",""templateId"":"""_objTemplate.ID_""""
	s cjson = cjson_",""categoryId"":"""_AParentID_""""
	s cjson = cjson_",""quotation"":"""_$case(quotationFlag>0,1:1,:0)_""""
	s cjson = cjson_ ",""JaneSpell"":"""_JaneSpell_"""" 
	s cjson = cjson_ ",""FullFight"":"""_FullFight_"""" 
	s cjson = cjson_ ",""DocIDText"":"""_docidText_""""
	s cjson = cjson_ "}"
	s cjson = cjson_ "}"
	q
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
/// Debug:      w ##Class(EMRservice.BL.BLClientCategory).GetTempCateJsonByCategoryIDNew(6,5,10209,"List")
ClassMethod GetTempCateAgreeJsonByCategoryID(AParentID As %String, AEpisodeID As %String, AUserID As %String, AResultType As %String = "", AEventType As %String = "", AEventID As %String = "", ACTLocId As %String = "", ADocId As %String = "", AOtherCTLocId As %String = "", pText As %String = "", pCollect As %String = "") As %GlobalCharacterStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	s priActivity = ..CheckTPrivActivity()  //权限控制	
	s strdocIds = ""
	s ctLocID =$case(AOtherCTLocId,"ALL":"","":ACTLocId,:AOtherCTLocId)
	s curPatInfo = ##class(EMRservice.DocRestLogic.PrivLogic).GetPatInfoByCT(AEpisodeID,AUserID,ctLocID)
	s patDept = $p($li(curPatInfo,2),$c(2),2)
	//获取所有知情同意书数据
	if (AOtherCTLocId="ALL")
	{
		s strdocIds = ..GetAllDocByCategoryID(AParentID,AEpisodeID,pText,ACTLocId)
	}
	else
	{
		s strdocIds = ..GetDocByCategoryID(AParentID,AEpisodeID,AUserID,priActivity,curPatInfo)
	}
	q:(strdocIds="&") json
	q:((AParentID = "")||(AEpisodeID = "")) json
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	s mutexdoc = $p(strdocIds,"&",1)
	s nomutexdoc = $p(strdocIds,"&",2)
	s iswrited = ##class(EMRservice.BL.BLInstanceData).IsHasInstanceByDocIDs(AEpisodeID,mutexdoc)
	if (iswrited = "1")
	{
	 	s strdocIds = nomutexdoc
	}
	else
	{
		s strdocIds = mutexdoc_"^"_nomutexdoc
	}
	s key = $i(^CacheTemp("GetTempCateJsonByCategoryID"))
	for i=1:1:$l(strdocIds,"^")
	{
		s docId = $p(strdocIds,"^",i)
		continue:(docId = "")
		//continue:((ADocId '= "")&&(ADocId '= docId))
		s tempFlag = 0
		if (ADocId '= "")
		{
			for k=1:1:$l(ADocId,",")
			{
				s tempADocId = $p(ADocId,",",k)
				if (tempADocId = docId)
				{
					s tempFlag = 1
					q
				}
			}
			continue:(tempFlag = 0)
		}
		s objdoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
        continue:(objdoc = "")
		s objchapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objdoc.ParentCategoryID)
		continue:(objchapter = "")
		s objcategory = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objchapter.ParentCategoryID)
		continue:(objcategory = "")
		s docCategoryName = objdoc.CategoryName
		s docJaneSpell = objdoc.JaneSpell
	    s docFullFight = objdoc.FullFight
		//通过搜索条件过滤
		continue:(($find(docCategoryName,pText) = 0)&&($find(docJaneSpell,pText) = 0)&&($find(docFullFight,pText) = 0))
		
		s JaneSpell = objchapter.JaneSpell
	    s FullFight = objchapter.FullFight
		
		//病历是否已写，写过则不显示新建卡片
		/*
		if ((AEventID '= "") && (AEventType '= ""))
		{
			s isLinkDocumentWrited = ##Class(EMRservice.BL.Event.BLLinkDocument).IsLinkDocumentWrited(AEpisodeID,docId,AEventType,AEventID)
			continue:(isLinkDocumentWrited = 1)
		}
		*/
		s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(docId)
	    continue:(objTemplate = "")
	    
	    s objEMRTemplateCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
	    set EMRChartItemType = ##class(EMRservice.EMRDoc.DocCategoryFunSet).GetChapterDocType(objEMRTemplateCategoryDoc.ParentCategoryID)
	
	    s result = ##class(EMRservice.BL.BLInstanceData).IsHasInstance(AEpisodeID, objTemplate.ID,docId)
		continue:((result '= 0) && (objTemplate.ChartItemType = "Single"))	
		s childs = ..GetTitleByDocID(docId,AEpisodeID,AEventType,AEventID,ACTLocId)
		s quotationFlag = ##Class(EMRservice.BL.BLQuotation).GetDocQuationFlag(patDept,docId) 
		s displayFlag = ##Class(EMRservice.SystemParameter).SetNavQuoteDisplay(AEpisodeID)
		s:(displayFlag = "N") quotationFlag = "0"
		s title = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.EMRTemplateCategory","CategoryName",objchapter.CategoryName,langid)
		s docidText = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.EMRTemplateCategory","CategoryName",objdoc.CategoryName,langid)
        if (AResultType = "List")
        {
	        s collect = ##Class(EMRservice.BL.BLCollectTemplate).GetIsCollect(AUserID,docId)
	       	continue:((pCollect="collect")&&(+collect'=1))
	        d DisplayInList 
	    }
	    else
		{
			s collect = ##Class(EMRservice.BL.BLCollectTemplate).GetIsCollect(AUserID,docId)
			continue:((pCollect="collect")&&(+collect'=1))
			d DisPlayInTree
		}
		s cjson = $ZSTRIP(cjson,"*C")
		s ^CacheTemp("GetTempCateJsonByCategoryID",key,i)= cjson
		s ^CacheTemp("GetTempCateJsonByCategoryID",key,"Seq",i,docId)= i
		s ^CacheTemp("GetTempCateJsonByCategoryID",key,"Flag",docId) = i
	}
	if (AResultType = "List")
	{
		//知情告知书目录结构通过模板树获取
		;s tempJson = ##Class(EMRservice.BL.BLEMRTemplateDocGroup).GetGroupTemplate(patDept,"CG"_AParentID,key)
		s tempJson = ##Class(EMRservice.BL.BLEMRTemplateDocGroup).GetGroupAgreeTemplate(key)
		d json.CopyFrom(tempJson)
	}
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
    s cjson = "{"
	s cjson = cjson_ """id"":"""_"TempCate-"_docId_""""
	s cjson = cjson_ ",""isCollect"":"""_collect_""""
	s cjson = cjson_ ",""text"":"""_$s(((EMRChartItemType="Multiple")&&(objdoc.IsLeadframe=0)):docidText,1:title)_""""
	s cjson = cjson_ ",""type"":""TempCate""" 
	s cjson = cjson_ ",""emrDocId"":"""_docId_"""" 
	s cjson = cjson_ ",""chartItemType"":"""_objTemplate.ChartItemType_"""" 
	s cjson = cjson_ ",""documentType"":"""_objTemplate.DocumentType_"""" 
	s cjson = cjson_ ",""isLeadframe"":"""_objdoc.IsLeadframe_""""
	s cjson = cjson_ ",""isMutex"":"""_objchapter.IsMutex_""""
	s cjson = cjson_",""templateId"":"""_objTemplate.ID_""""
	s cjson = cjson_",""categoryId"":"""_AParentID_""""
	s cjson = cjson_",""quotation"":"""_$case(quotationFlag>0,1:1,:0)_""""
	s cjson = cjson_ ",""JaneSpell"":"""_JaneSpell_"""" 
	s cjson = cjson_ ",""FullFight"":"""_FullFight_""""
	s cjson = cjson_ ",""DocIDText"":"""_docidText_""""
	s cjson = cjson_ "}"
	q
DisPlayInTree  
	s cjson = "{"
	s cjson = cjson_ """id"":"""_docId_""""
	s cjson = cjson_ ",""isCollect"":"""_collect_""""
	s cjson = cjson_ ",""text"":"""_$s(((EMRChartItemType="Multiple")&&(objdoc.IsLeadframe=0)):docidText,1:title)_""""
	s cjson = cjson_ ",""childs"":["_childs_"]"
	s cjson = cjson_ ",""attributes"":{" 
	s cjson = cjson_ """type"":""TempCate""" 
	s cjson = cjson_ ",""chartItemType"":"""_objTemplate.ChartItemType_"""" 
	s cjson = cjson_ ",""documentType"":"""_objTemplate.DocumentType_"""" 
	s cjson = cjson_ ",""isLeadframe"":"""_objdoc.IsLeadframe_""""
	s cjson = cjson_ ",""isMutex"":"""_objchapter.IsMutex_""""
	s cjson = cjson_",""templateId"":"""_objTemplate.ID_""""
	s cjson = cjson_",""categoryId"":"""_AParentID_""""
	s cjson = cjson_",""quotation"":"""_$case(quotationFlag>0,1:1,:0)_""""
	s cjson = cjson_ ",""JaneSpell"":"""_JaneSpell_"""" 
	s cjson = cjson_ ",""FullFight"":"""_FullFight_"""" 
	s cjson = cjson_ ",""DocIDText"":"""_docidText_""""
	s cjson = cjson_ "}"
	s cjson = cjson_ "}"
	q
}

/// Desc:       查询过滤当前患者所有展现数据
/// Modify:     yejian
/// DateTime:   2021-8-16
/// Input:      ACategoryIds 目录ID集合,以逗号","分隔
///             AEpisodeID:就诊号
/// 			AUserID:用户ID
/// 			AResultType:展现类型，卡片 "",列表 "List"
/// 			AEventType:事件类型
/// 			AEventID:事件ID
/// 			ACTLocId:本科ID
/// 			ADocId:docID
/// 			AOtherCTLocId:其他科室ID，所有 "ALL"
/// 			pText:搜索条件
/// 			pDiseaseCodeAndName:诊断
/// OutPut:     json流数据             
/// Debug: 		s obj = ##Class(EMRservice.BL.BLClientCategory).SelectAllCategoryJson("1,2,3,4,5,6,23,25","4","10209","","","","95","","ALL","首次","")
/// 			d obj.OutputToDevice()
ClassMethod SelectAllCategoryJson(ACategoryIds As %String, AEpisodeID As %String, AUserID As %String, AResultType As %String = "", AEventType As %String = "", AEventID As %String = "", ACTLocId As %String = "", ADocId As %String = "", AOtherCTLocId As %String = "", pText As %String = "", pDiseaseCodeAndName As %String = "") As %GlobalCharacterStream
{
	s leftJson = "",rightJson = "",count = 0
	s jsonRes = ##Class(%GlobalCharacterStream).%New()
	q:(ACategoryIds = "")||(AEpisodeID = "") jsonRes
	s langid=20
	if ($d(%session)){
		s langid=+$g(%session.Data("LOGON.LANGID"))
	}
	s count =$l(ACategoryIds,",")
	for i=1:1:count
	{
		s strParentID = $p(ACategoryIds,",",i)
		continue:(strParentID="")
		s itemID = $o(^DHCEMRM.CTOrgSchemeItemI("IdxEMRTemplateCategoryID"," "_strParentID,""))
		continue:(itemID="")
		s objOrgItem = ##Class(EMRmeta.CTOrganizationSchemeItem).%OpenId(itemID)
		continue:(objOrgItem = "")
		s strParentID = objOrgItem.EMRTemplateCategoryID
		s objCate = ##class(EMRmeta.EMRTemplateCategory).%OpenId(strParentID)
		continue:((objCate=""))
		//病历展现上，如果没有挂子节点屏蔽
		s strPid = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID"," "_strParentID,""))
		continue:(strPid = "")
		s strType = $case(objOrgItem.ItemType,"":"",:objOrgItem.ItemType)
		s:(strType = "") strType = $Case(objOrgItem.EMRTemplateCategoryID,"":"HIS",:"EMR")
		s itemTitle = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.CTOrganizationSchemeItem","ItemTitle",objOrgItem.ItemTitle,langid)
		s docJson = ##Class(EMRservice.BL.BLClientCategory).GetTempCateJsonByCategoryIDNew(strParentID,AEpisodeID,AUserID,"List",AEventType,AEventID,ACTLocId,ADocId,AOtherCTLocId,pText,pDiseaseCodeAndName)
		continue:((docJson="")||(docJson.Size<=1))
		
		d:(jsonRes.Size > 1) jsonRes.Write(",") 
		s leftJson = "{"
		s leftJson = leftJson_"""id"":"""_itemID_""""
		s leftJson = leftJson_",""text"":"""_itemTitle_""""
		s leftJson = leftJson_",""DocIDText"":"""_itemTitle_""""
		s leftJson = leftJson_ ",""type"":""flod""" 
		s leftJson = leftJson_ ",""children"":["
		d jsonRes.Write(leftJson)
		d docJson.Rewind()
		while (docJson.AtEnd = 0)
		{
			s tmpOut = docJson.Read(30000)
			;s tmpUtf8 = $zcvt(tmpOut,"I","UTF8")
			d jsonRes.Write(tmpOut)
	  	} 
		s rightJson = "]"
		s rightJson = rightJson_ ",""attributes"":{" 
		s rightJson = rightJson_ """image"":"""_objOrgItem.imagePath_"""" 
		s rightJson = rightJson_ ",""categoryId"":"""_strParentID_""""
		s rightJson = rightJson_ ",""type"":"""_strType_"""" 		
		s rightJson = rightJson_ ",""itemUrl"":"""_objOrgItem.ItemURL_"?"_objOrgItem.ItemParas_""""
		s rightJson = rightJson_ "}"
		s rightJson = rightJson_ "}"
		d jsonRes.Write(rightJson)
	}	
	q jsonRes
}

/// Desc:       获取所有知情同意书DOCID
/// Modify:     yejian
/// DateTime:   2021-6-17
/// Input:      AParentId:目录CategoryId
///             AEpisodeID:就诊号
/// 			ASelectValue:名称过滤
/// 			ACTLocId:本科ID(排除本科常用数据)
/// OutPut:     json    
/// w ##Class(EMRservice.BL.BLClientCategory).GetAllDocByCategoryID(6,456449)
ClassMethod GetAllDocByCategoryID(AParentID As %String, AEpisodeID As %String, ASelectValue As %String, ACTLocId As %String) As %GlobalCharacterStream
{
	s result = ""
	s mutexdoc = ""
	s nomutexdoc = ""
	q:((AParentID = "")||(AEpisodeID = "")||(ACTLocId="")) result
	s strReCTLoc = "PATDEPT:"_ACTLocId
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
			s curDocIDS=""
	        s curDocID=""
	        for
	        {		
			s curDocID = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID"," "_curCategoryId,curDocID))
			q:(curDocID = "")
			s curObjDocCategory =##Class(EMRmeta.EMRTemplateCategory).%OpenId(curDocID)
			continue:(curObjDocCategory.CategoryType '= "TempCate")
			s curDocCategoryName = curObjDocCategory.CategoryName
			s JaneSpell = curObjDocCategory.JaneSpell
		        s FullFight = curObjDocCategory.FullFight
		        continue:(($find(curDocCategoryName,ASelectValue) = 0)&&($find(JaneSpell,ASelectValue) = 0)&&($find(FullFight,ASelectValue) = 0))
		        //增加docid未在模板组中配置过滤
		        s curDocGropID = ""
			s curDocGropID = $o(^DHCEMRM.DocRes.DocsInGroupI("DocIDIdx"," "_curDocID,""))
			continue:(curDocGropID = "")
				
		        //排除本科室常用知情告知
		        /*
		        s strMark = "0"
				s curDocGropID = ""
				set groupID = ""
			 	for 
			 	{
					set groupID = $o(^DHCEMRM.DocRes.DocsInGroupI("DocIDIdx"," "_curDocID,groupID)) //注：此处取得的 groupID 在左侧含有空格
					q:(groupID="")
					q:(strMark="1")
					//遍历该模板组下的规则，校验是否有规则适合
					s restrictionId = ""
					for
					{
						s restrictionId = $o(^DHCEMRM.DocRes.DocRestrictionI("GroupIDIdx",groupID,restrictionId))
						q:(restrictionId="")
						s objRes = ##class(EMRmeta.EMRDocRestriction.DocRestriction).%OpenId(restrictionId)
						q:(objRes = "")
						if (objRes.RuleItemIDs=strReCTLoc)
						{
							s strMark="1"
							q
						}
					}
					
			 	}
				continue:(strMark="1")
				*/
				
				s curDocIDS = $case(curDocIDS,"":curDocID,:curDocIDS_"^"_curDocID)	
	        }
	        continue:(curDocIDS = "")
			for i=1:1:$l(curDocIDS,"^")
			{
				s strDocID = $p(curDocIDS,"^",i)
				//根据DOCID获取属性对象
				s curObjDocCategory = ..GetEmrCategoryPropertyByDocID(strDocID)
				
				s curDocId = $e(curObjDocCategory.ID,3,$l(curObjDocCategory.ID))  	
				continue:(curDocId = "")
				s curIsMutex = objEMRTemplateCategory.IsMutex
		        s:(curIsMutex '= 1) curIsMutex = 0	
		        if (curIsMutex = 1)	
				{
			        s mutexdoc = $case(mutexdoc,"":curDocId,:mutexdoc_"^"_curDocId)
			    }
			    else
			    {
				    s nomutexdoc = $case(nomutexdoc,"":curDocId,:nomutexdoc_"^"_curDocId)
				}
			}
		}
	}
	//根据用户使用频率排序
	if (##Class(EMRservice.SystemParameter).IsSortByUserFrequency() = "Y")&&(AUserID'="")
	{
		s mutexdoc = ##Class(EMRservice.BL.BLClientCategory).SortDocIDByFrequency(mutexdoc,AUserID)
		s nomutexdoc = ##Class(EMRservice.BL.BLClientCategory).SortDocIDByFrequency(nomutexdoc,AUserID)
	}
	s result = mutexdoc_"&"_nomutexdoc
	q result
}

/// Desc:       知情同意书搜索
/// Modify:     董璐璐
/// DateTime:   2016-3-10
/// Input:      AParentId:目录CategoryId
///             AEpisodeID:就诊号
/// OutPut:     json    
/// w ##Class(EMRservice.BL.BLClientCategory).GetInformConsentTempCateJson("病",11,456449,4133，"List")
ClassMethod GetInformConsentTempCateJson(ASelectValue As %String, AParentID As %String, AEpisodeID As %String, AUserID As %String, AResultType As %String = "", AEventType As %String = "", AEventID As %String = "") As %GlobalCharacterStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	s count = 0
	q:(AEpisodeID = "") ""
	s curPatInfo = ##class(EMRservice.DocRestLogic.PrivLogic).GetPatInfo(AEpisodeID,AUserID)
	s patDept = $p($li(curPatInfo,2),$c(2),2)
	s key = $i(^CacheTemp("GetTempCateJsonByCategoryID"))
	s seq = ""
	s docId = ""
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

	        s curIsMutex = objEMRTemplateCategory.IsMutex
	        s:(curIsMutex '= 1) curIsMutex = 0
	        s objEMRTemplateCategory = "" k objEMRTemplateCategory
	        s curEMRTemplategoryID=""
	        for
	        {		
				s curEMRTemplategoryID = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID"," "_curCategoryId,curEMRTemplategoryID))
				q:(curEMRTemplategoryID = "")
				s curObjDocCategory =##Class(EMRmeta.EMRTemplateCategory).%OpenId(curEMRTemplategoryID)
				continue:(curObjDocCategory.CategoryType '= "TempCate")
				s docId = curEMRTemplategoryID
				
				s collect = ##Class(EMRservice.BL.BLCollectTemplate).GetIsCollect(AUserID,curEMRTemplategoryID)
				s curDocCategoryName = curObjDocCategory.CategoryName
				s JaneSpell = curObjDocCategory.JaneSpell
		        s FullFight = curObjDocCategory.FullFight
		        continue:(($find(curDocCategoryName,ASelectValue) = 0)&&($find(JaneSpell,ASelectValue) = 0)&&($find(FullFight,ASelectValue) = 0))
		        
		        
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
				s nowcurCategoryName = curDocCategoryName
				
				s disCurDocGropName = disCurDocGropName_"模板组："
				s disCurDocGropName = disCurDocGropName_curDocGropName
				s nowcurCategoryName = nowcurCategoryName_"（"
				s nowcurCategoryName = nowcurCategoryName_disCurDocGropName
				s nowcurCategoryName = nowcurCategoryName_"）"

				///病历是否已写，写过则不显示新建卡片
				/*
				if ((AEventID '= "") && (AEventType '= ""))
				{
					s isLinkDocumentWrited = ##Class(EMRservice.BL.Event.BLLinkDocument).IsLinkDocumentWrited(AEpisodeID,curEMRTemplategoryID,AEventType,AEventID)
					continue:(isLinkDocumentWrited = 1)
				}
				*/
		        s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(curEMRTemplategoryID)
			    continue:(objTemplate = "")
			    s result = ##class(EMRservice.BL.BLInstanceData).IsHasInstance(AEpisodeID, objTemplate.ID,curEMRTemplategoryID)
				continue:((result '= 0) && (objTemplate.ChartItemType = "Single"))
				s childs = ..GetTitleByDocID(curEMRTemplategoryID,AEpisodeID,AEventType,AEventID)
				s quotationFlag = ##Class(EMRservice.BL.BLQuotation).GetDocQuationFlag(patDept,curEMRTemplategoryID) 
		        s displayFlag = ##Class(EMRservice.SystemParameter).SetNavQuoteDisplay(AEpisodeID)
		        s:(displayFlag = "N") quotationFlag = "0"
		        s collect = ##Class(EMRservice.BL.BLCollectTemplate).GetIsCollect(AUserID,curEMRTemplategoryID)
		        if (AResultType = "List")
		        {
			        d DisplayInList 
			    }
			    else
				{
					d DisPlayInTree
				}
				s count = count + 1
				s cjson = $ZSTRIP(cjson,"*C")
				s ^CacheTemp("GetTempCateJsonByCategoryID",key,count)= cjson
				s ^CacheTemp("GetTempCateJsonByCategoryID",key,"Flag",curEMRTemplategoryID) = count
	        }
		}
	}
	if (AResultType = "List")
	{
		s tempJson = ##Class(EMRservice.BL.BLEMRTemplateDocGroup).GetGroupTemplate("","CG"_AParentID,key)
		d json.CopyFrom(tempJson)
	}
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
    s cjson = "{"
	s cjson = cjson_ """id"":"""_curEMRTemplategoryID_""""
	s cjson = cjson_ ",""text"":"""_curDocCategoryName_""""
	s cjson = cjson_ ",""emrDocId"":"""_docId_"""" 
	s cjson = cjson_ ",""type"":""TempCate""" 
	s cjson = cjson_ ",""chartItemType"":"""_objTemplate.ChartItemType_"""" 
	s cjson = cjson_ ",""documentType"":"""_objTemplate.DocumentType_"""" 
	s cjson = cjson_ ",""isLeadframe"":"""_curIsLeadframe_""""
	s cjson = cjson_ ",""isMutex"":"""_curIsMutex_""""
	s cjson = cjson_",""templateId"":"""_objTemplate.ID_""""
	s cjson = cjson_",""categoryId"":"""_AParentID_""""
	s cjson = cjson_",""quotation"":"""_$case(quotationFlag>0,1:1,:0)_""""
	s cjson = cjson_ ",""JaneSpell"":"""_JaneSpell_"""" 
	s cjson = cjson_ ",""FullFight"":"""_FullFight_""""
	s cjson = cjson_ ",""DocIDText"":"""_nowcurCategoryName_""""
	s docIDTitle = nowcurCategoryName
	if ($l(docIDTitle)>"29")
	{
		s docIDTitle = $e(docIDTitle,1,29)_"..."
	}
	s cjson = cjson_ ",""DocIDTitle"":"""_docIDTitle_""""	
	s cjson = cjson_ ",""isCollect"":"""_collect_""""
	s cjson = cjson_ "}"
	q
DisPlayInTree  
	s cjson = "{"
	s cjson = cjson_ """id"":"""_curEMRTemplategoryID_""""
	s cjson = cjson_ ",""text"":"""_curDocCategoryName_""""
	s cjson = cjson_ ",""isCollect"":"""_collect_""""
	s cjson = cjson_ ",""childs"":["_childs_"]"
	s cjson = cjson_ ",""attributes"":{" 
	s cjson = cjson_ """type"":""TempCate""" 
	s cjson = cjson_ ",""emrDocId"":"""_docId_"""" 
	s cjson = cjson_ ",""chartItemType"":"""_objTemplate.ChartItemType_"""" 
	s cjson = cjson_ ",""documentType"":"""_objTemplate.DocumentType_"""" 
	s cjson = cjson_ ",""isLeadframe"":"""_curIsLeadframe_""""
	s cjson = cjson_ ",""isMutex"":"""_curIsMutex_""""
	s cjson = cjson_",""templateId"":"""_objTemplate.ID_""""
	s cjson = cjson_",""quotation"":"""_$case(quotationFlag>0,1:1,:0)_""""
	s cjson = cjson_",""disCurDocGropName"":"""_disCurDocGropName_""""
	s cjson = cjson_ ",""JaneSpell"":"""_JaneSpell_"""" 
	s cjson = cjson_ ",""FullFight"":"""_FullFight_"""" 
	s cjson = cjson_ ",""DocIDText"":"""_nowcurCategoryName_""""
	s docIDTitle = nowcurCategoryName
	if ($l(docIDTitle)>"29")
	{
		s docIDTitle = $e(docIDTitle,1,29)_"..."
	}
	s cjson = cjson_ ",""DocIDTitle"":"""_docIDTitle_""""	
	s cjson = cjson_ ",""isCollect"":"""_collect_""""
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
/// Debug: w ##Class(EMRservice.BL.BLClientCategory).GetTempCateJson(190,29,746482,146)
ClassMethod GetTempCateJson(ACTLocID As %String, ASSgroupID As %String, AEpisodeID As %String, AUserID As %String, AResultType As %String = "", AEventType As %String = "", AEventID As %String = "") As %GlobalCharacterStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	s count = 0
	q:(ACTLocID = "")||(ASSgroupID = "")||(AEpisodeID = "")||(AUserID = "") json
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLClientCategory:GetCategory")
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
/// Description：取出ChapterDoc节点下可用的DocID集合（即可用的TempCate的Doc）
/// 			 在构造病历结构树形时，处理ChapterDoc类型的节点，该类型的节点将被隐藏，其位置由TempCate类型的节点代替
/// Table:
/// Input: EpisodeID--病人就诊号;parOthers--用于扩展的信息串（未用）;parCategoryID--Chapter的ID； parPriActivity--是否开启了模板权限, parPatInfo--病人信息
/// Output:
/// Return: DocID集合(挂靠界面模板的目录，以^分隔)
ClassMethod GetDocIDInChapter(EpisodeID As %String, parOthers As %String, parCategoryID As %String, parPriActivity As %String, parPatInfo As %Library.List) As %String
{
	 s resultDocID = ""
	 
	 s resultDocID = ##class(EMRservice.DocRestLogic.PrivLogic).GetDocIDForView(EpisodeID, parOthers, parCategoryID, parPriActivity, parPatInfo)
	 q:(resultDocID = "") ""
	 q resultDocID
	 /*
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

/// Desc:		根据DocId取实例
/// Creator:	Candy
/// CreateDate: 2014-8-29
/// Input: 		AParentId 目录categoryID
/// 			AEpisodeId 就诊号
/// 			AUniqueKey 唯一标示
/// 			AuserLocID 用户登录科室
/// 			AValidState 是否增加病历状态验证 Y：验证，空或者N：不验证
/// 			OutPut result 1成功，0错误
/// Debug：     w ##Class(EMRservice.BL.BLClientCategory).DoInstanceJsonByDocID(4,112,"Save","")
ClassMethod DoInstanceJsonByDocID(ADocId As %String, AEpisodeId As %String, AStauts As %String, AResultType As %String = "", ASequence As %String = "", Key As %String = "", AuserLocID As %String = "", AValidState As %String = "") As %GlobalCharacterStream
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
	s seq = 1
	s:(ASequence = "DESC") seq = -1
	s date = ""
	for
	{
		s date = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordId," "_$zcvt(AStauts,"U"),date),seq)
		q:(date = "")
		s time = ""
		for
		{
			s time = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordId," "_$zcvt(AStauts,"U"),date,time),seq)	
			q:(time = "")
			s subId = ""
			for
			{
				s subId = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordId," "_$zcvt(AStauts,"U"),date,time,subId),seq)			
				q:(subId = "")
				if (AValidState="Y")
				{
					s aInstanceID = ecrecordId_"||"_subId
					//增加病历状态验证
					s strState = ##class(EMRservice.BL.BLClientCategory).GetInstanceState(aInstanceID,AuserLocID)
					continue:(strState=0)
				}
 				s tempJson = ..GetInstanceJsonByID(ecrecordId,subId,AResultType)
 				continue:(tempJson = "")
 				d:(count '= 0) json.Write(",")
				d json.Write($ZSTRIP(tempJson,"*C"))
				s count = count + 1			
				if (Key '= "")
				{
					s ^TempEMRCategoryData(Key,date,time,docId,count) = $ZSTRIP(tempJson,"*C")
				}
			}
		}
	}
	q json
Error
	q ""
}

/// Desc: 		根据实例ID判断是否符合条件
/// Creator: 	yejian
/// CreateDate:	2014-9-2 
/// Input:       AInstanceID 实例ID
///              ACTLocid  登录科室ID
/// Output:      符合：1，不符合：0
/// Debug:       w ##Class(EMRservice.BL.BLClientCategory).GetInstanceState("2||2",76)
ClassMethod GetInstanceState(AInstanceID As %String, ACTLocid As %String) As %String
{
	s $zt = "Error"
	s strRes = "0"
	q:(AInstanceID = "") strRes
	s strDataState = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName2("BrowseViewDataState","{""ISEnable"":""N"",""State"":""SAVE"",""CTLocids"":""""}")
	s strDataState = $zcvt(strDataState,"U")
	s objJson = ##class(%DynamicAbstractObject).%FromJSON(strDataState)
	q:(objJson.ISENABLE="N")||(objJson.STATE="SAVE") "1"
	//如果科室为空，所有科室根据状态过滤数据
	if (objJson.CTLOCIDS'="")
	{
		s strCTlocIds = "^"_objJson.CTLOCIDS_"^"
		s strCTlocid = "^"_ACTLocid_"^"
		q:(strCTlocIds '[ strCTlocid) "1"
	}
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") strRes
	//判断是否签名状态
	if (objJson.STATE="SIGN")
	{
		//是否有有效签名，1：有效，0：无效
		s strRes = ##Class(EMRservice.BOPrivAssist).HasValidSign(AInstanceID)
	}
	elseif(objJson.STATE="PRINT") //判断是否打印
	{
		s strRes = ##class(EMRservice.BL.BLEMRLogs).RecHasAction(objInstance.EpisodeID,AInstanceID,"Print")
	}
	else
	{
		s strRes = "1"
	}
	q strRes
Error
	q "1"
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
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s templatId = objInstance.RealTemplateID
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
/// Debug:  	w ##Class(EMRservice.BL.BLClientCategory).GetInstanceJsonByCategoryID(4,112)
ClassMethod GetInstanceJsonByCategoryID(AParentId As %String, AEpisodeId As %String, AResultType As %String = "", ASequence As %String = "", ADocID As %String = "") As %GlobalCharacterStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	s key = $i(^CacheTemp)
	k ^TempEMRCategoryData(key)
	q:(AEpisodeId = "")||(AParentId = "") json
	if (ADocID = "")
	{
		s docIds = ..GetDocIdsByParent(AParentId)
	}
	else
	{
		//interface接口页只显示对应docID的病历
		s docIds = ADocID
	}
	s length = $l(docIds,",")
	for I=1:1:length
	{
		s docId = $p(docIds,",",I)
		//s docJson = ..DoInstanceJsonByDocID(docId,AEpisodeId,"Save",AResultType,ASequence)
		//d:(json.Size '= 0)&&(docJson.Size '= 0) json.Write(",")
		//d json.CopyFrom(docJson)
		d ..DoInstanceJsonByDocID(docId,AEpisodeId,"Save",AResultType,ASequence,key)
	}
	//从临时global中获取数据
	d json.CopyFrom(..GetTempEMRCategoryData(key,ASequence))
	k ^TempEMRCategoryData(key)
	q json
}

/// Desc: 		按Key取实例数据
/// Creator:	Candy
/// CreateDate:	2021-01-26
/// Input: 		Key
/// Output:     Json
/// Debug:  	w ##Class(EMRservice.BL.BLClientCategory).GetTempEMRCategoryData()
ClassMethod GetTempEMRCategoryData(Key As %String, ASequence As %String = "") As %GlobalCharacterStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	s seq = 1
	s:(ASequence = "DESC") seq = -1
	s tempDate = ""
	for
	{
		s tempDate = $o(^TempEMRCategoryData(Key,tempDate),seq)
		q:(tempDate="")
		s tempTime = ""
		for
		{
			s tempTime = $o(^TempEMRCategoryData(Key,tempDate,tempTime),seq)
			q:(tempTime="")
			s docID = ""
			for
			{
				s docID = $o(^TempEMRCategoryData(Key,tempDate,tempTime,docID),seq)
				q:(docID="")
				s count = ""
				for
				{
					s count = $o(^TempEMRCategoryData(Key,tempDate,tempTime,docID,count),seq)
					q:(count="")
					d:(json.Size '= 0) json.Write(",")
					d json.Write(^TempEMRCategoryData(Key,tempDate,tempTime,docID,count))	
				}
			}
		}
	}
	q json
}

/// Desc:      取参考病历目录(取出相关病历,母婴病历)
/// Creator:   Candyxu
/// CreateDate:2015-10-19
/// Input:     ACTLocId 科室
///           AEpisodeId 就诊ID
/// Debug:    w ##Class(EMRservice.BL.BLClientCategory).GetReferenceJsons(456449)  
ClassMethod GetReferenceJsons(AEpisodeId As %String, AResultType As %String = "") As %GlobalCharacterStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	q:(AEpisodeId = "") json
	s episodeIds = $lb(AEpisodeId)
	if (AResultType = "List")
	{
		s resultType = "List"
		s jsonType = "text"
	}
	else
	{
		s resultType = "ZTree"
		s jsonType = "name"
	}
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
	
    //患者查看供者的病历
    if (##class(%Dictionary.CompiledClass).%ExistsId("web.DHCWMYTest") '= "0")
    {
        if (##class(%Dictionary.CompiledQuery).%ExistsId("web.DHCWMYTest||FindApplySupplyQuery") '= "0")
        {
            //d ##class(%ResultSet).RunQuery("web.DHCWMYTest","FindApplySupplyQuery",episodeId,"N")
            s ds = ##Class(%Library.ResultSet).%New("web.DHCWMYTest:FindApplySupplyQuery")
            d ds.Execute(AEpisodeId,"N")
            While (ds.Next()){
                s episodeIds = episodeIds_$lb(ds.Data("DonorAdmNO")_"^(供)")
            }
        }
    }
	
	for i = 1:1:$listlength(episodeIds) 
	{
		s episodeId = $listget(episodeIds,i)
        s fixName = ""
        if (episodeId [ "^(供)"){
            s fixName = $p(episodeId,"^",2)
            s episodeId = $p(episodeId,"^",1)
        }
		s patientId = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(episodeId)
		s desc = ##Class(EMRservice.HISInterface.PatientInfoAssist).Name(patientId)
        s:(fixName '= "") desc = desc_fixName
		s category = ..GetAllInstanceByCategory(episodeId,resultType)
		d:(i '= 1) json.Write(",")
		d json.Write("{")
		d json.Write("""id"":"""_episodeId_"""")
		d json.Write(","""_jsonType_""":"""_desc_"""")
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
/// Debug:          w ##Class(EMRservice.BL.BLClientCategory).GetInstanceJson(6,100,76)	
ClassMethod GetInstanceJson(ACTLocId As %String, ASSgroupId As %String, AEpisodeId As %String, AResultType As %String = "") As %GlobalCharacterStream
{
	s json = ##Class(%GlobalCharacterStream).%New(),count = 0
	q:(ACTLocId = "")||(AEpisodeId = "")||(ASSgroupId = "") json	
		
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLClientCategory:GetCategory")
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
				s directoryId = $o(^DHCEMRI.DirectoryInformationI("IdxEpisodeIDDocID"," "_AEpisodeId," "_docId,""))
				continue:(directoryId = "")
		        s objDirectory = ##Class(EMRinstance.DirectoryInformation).%OpenId(directoryId)
		        continue:(objDirectory = "")
			    d json.Write("{")
			    d json.Write("""id"":"""_docId_"""")
			    d json.Write(",""name"":"""_objDirectory.DocName_"""")
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
/// Debug 		w ##Class(EMRservice.BL.BLClientCategory).GetBrowseCategory("1","","","95")
ClassMethod GetBrowseCategory(AEpisodeId As %String, AResultType As %String = "", AdocIDs As %String = "", AuserLocID As %String = "", Atype As %String = "") As %GlobalBinaryStream
{
	s json = ##Class(%GlobalBinaryStream).%New()
	q:(AEpisodeId = "") json
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	d json.Write("[")
	if (AdocIDs '="")
	{
		s docIds = AdocIDs
		d Output
	}
	else
	{
		s result = ##class(%ResultSet).%New("EMRservice.BL.BLClientCategory:GetAllCategory")
		d result.Execute(AEpisodeId)	
		while result.%Next()
		{
			s ItemType = result.Data("ItemType")
			if (ItemType = "EMR")
			{ 
				s categoryID = result.Data("ItemCategoryID")	
				s docIds = ..GetDocIdsByParent(categoryID)
				d Output
			}
			else
			{
				if (Atype'="browse"){
					d:(json.Size '= 1) json.Write(",")
					d json.Write("{")
					d json.Write("""id"":"""_result.Data("ItemID")_"""")
					d json.Write(",""name"":"""_result.Data("ItemTitle")_"""")
					d json.Write(",""attributes"":{")
					d json.Write( """itemType"":"""_result.Data("ItemType")_"""" )	
					d json.Write(",""itemUrl"":"""_result.Data("ItemURL")_"?"_result.Data("ItemParas")_"""")
					d json.Write("}")
					d json.Write("}")	
				}	
			}
		 }
	}
	d json.Write("]")
	q json
Output
	s length = $l(docIds,",")
	for I=1:1:length
	{
		s docId = $p(docIds,",",I)
		s resultJson = ..DoInstanceJsonByDocID(docId,AEpisodeId,"SAVE",AResultType,"","",AuserLocID,"Y")
		continue:(resultJson.Size = 0)
		s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(docId)
	    continue:(objTemplate = "")
	    if (objTemplate.ChartItemType = "Single")
	    {
		    d:(json.Size '= 1) json.Write(",")
		    d json.CopyFrom(resultJson)	
		}
		else
		{
			s directoryId = $o(^DHCEMRI.DirectoryInformationI("IdxEpisodeIDDocID"," "_AEpisodeId," "_docId,""))
			continue:(directoryId = "")
	        s objDirectory = ##Class(EMRinstance.DirectoryInformation).%OpenId(directoryId)
	        continue:(objDirectory = "")
	        s name = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRinstance.DirectoryInformation","DocName",objDirectory.DocName,langid)
	        d:(json.Size '= 1) json.Write(",")
		    d json.Write("{")
		    d json.Write("""id"":"""_docId_"""")
		    d json.Write(",""name"":"""_name_"""")
		    d json.Write(",""children"":[") d json.CopyFrom(resultJson) d json.Write("]")
		    d json.Write("}")
		}	
	}
}

/// Desc:       根据instanceID取部分病历参数
/// Modify:     chenpeng
/// DateTime:   2019-10-27
/// Input:      AInstanceID:病历ID
///    
/// OutPut:     json    
/// w ##Class(EMRservice.BL.BLClientCategory).GetParamByInstanceID("245||1")
ClassMethod GetParamByInstanceID(AInstanceID As %String) As %String
{
	s json = ""
	if (AInstanceID= "") 
	{
		 s json = json_"{"
	     s json = json_"""id"":"""""
	     s json = json_",""text"":"""""
	     s json = json_",""emrDocId"":"""""
	     s json = json_",""chartItemType"":"""""
	     s json = json_",""pluginType"":""""" 
	     s json = json_",""characteristic"":"""""
	     s json = json_",""pdfDocType"":"""""
		 s json = json_",""templateId"":"""""
	     s json = json_"}"
	     q json
	}
	else
	{
	     s rowId=AInstanceID
	     s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(rowId)
	     q:(objInstance = "") json
	     s title = ##Class(EMRservice.Util.EscapeSpecialWord).HtmlEscape(objInstance.Title)
	     s docId = objInstance.TheECRecord.RealChartItemID
	     s characteristic = objInstance.TheECRecord.DocumentCharacteristic
	     s chartItemType = objInstance.TheECRecord.ChartItemType
	     s documentType = objInstance.TheECRecord.DocumentType
		 s templateId = objInstance.TemplateID
		 
	     //指定病历实例是否有对应患者签名后的PDF文档
	     s pdfStatus = ##Class(EMRservice.BL.BLPDFAuditSignLog).GetPDFStatus(rowId, objInstance.EpisodeID.%Id())
	     s pdfDocType = $Case($zcvt(pdfStatus,"U"),"SIGNED":"PDF",:"XML")
		 
	     s json = json_"{"
	     s json = json_"""id"":"""_rowId_""""
	     s json = json_",""text"":"""_title_""""
	     s json = json_",""emrDocId"":"""_docId_""""
	     s json = json_",""chartItemType"":"""_chartItemType_"""" 
	     s json = json_",""pluginType"":"""_documentType_"""" 
	     s json = json_",""characteristic"":"""_characteristic_""""
	     s json = json_",""pdfDocType"":"""_pdfDocType_""""
		 s json = json_",""templateId"":"""_templateId_""""
	     s json = json_"}"
         k objInstance
         q json
	}
}

/// Desc:		按分类显示所有目录数据
/// Creator:	Candy
/// CreateDate: 2018-2-27
/// Input: 		ACTLocId 科室
///       		AEpisodeId 就诊号
/// Output: 	json
/// Debug 		w ##Class(EMRservice.BL.BLClientCategory).GetBrowseCategory(76)
ClassMethod GetAllInstanceByCategory(AEpisodeId As %String, AResultType As %String = "") As %GlobalBinaryStream
{
	s json = ##Class(%GlobalBinaryStream).%New()
	q:(AEpisodeId = "") json
	if (AResultType = "List")
	{
		s jsonType = "text"
	}
	else
	{
		s jsonType = "name"
	}
	d json.Write("[")
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLClientCategory:GetAllCategory")
	d result.Execute(AEpisodeId)	
	while result.%Next()
	{
		s ItemType = result.Data("ItemType")
		continue:(ItemType '= "EMR")
		
		s categoryID = result.Data("ItemCategoryID")	
		s docIds = ..GetDocIdsByParent(categoryID)
		s length = $l(docIds,",")
		s tempJson = ##Class(%GlobalBinaryStream).%New()
		for I=1:1:length
		{
			s docId = $p(docIds,",",I)
			s resultJson = ..DoInstanceJsonByDocID(docId,AEpisodeId,"SAVE",AResultType)
			continue:(resultJson.Size = 0)				
			d:(tempJson.Size '= 0) tempJson.Write(",")
			d tempJson.CopyFrom(resultJson)
		}
		if (tempJson.Size > 0)
		{
			d:(json.Size > 1) json.Write(",")
			d json.Write("{")
			d json.Write("""id"":"""_categoryID_"""")
			d json.Write(","""_jsonType_""":"""_result.Data("ItemTitle")_"""")
			d json.Write(",""children"":[")	
			d json.CopyFrom(tempJson)	
			d json.Write("]}")
		}
	}
	d json.Write("]")
	q json
}

/// Desc:       按目录分类展示病历目录
/// Creator:    CandyXu
/// CreateDate: 2018-2-26
/// Input:      ACTLocID    用户登录科室
///            ASSGroupID  用户安全组
///            AEpisodeID  患者就诊号
///            AResultType 输出类型
///            ASequence   显示顺序  
/// Debuger:    w ##Class(EMRservice.BL.BLClientCategory).GetInstanceByCategory(110,29,35,"Tree")
ClassMethod GetInstanceByCategory(ACTLocID As %String, ASSgroupID As %String, AEpisodeID As %String, AResultType As %String = "", ASequence As %String = "", AStatus As %String = "Save", ADocID As %String = "", ARecordShowType As %String = "") As %GlobalCharacterStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	q:(ACTLocID = "")||(AEpisodeID = "") json
	s tempDocID = ""
	s tempCategoryID = ""
	if (ARecordShowType = "Doc")
	{
		s tempDocID = ADocID
	}
	elseif (ARecordShowType = "Category")
	{
		s tempCategoryID = ##Class(EMRservice.BL.BLClientCategory).GetCategoryIDByDocID(ADocID)
	}

	s category = ##class(%ResultSet).%New("EMRservice.BL.BLClientCategory:GetAllCategory")
	d category.Execute(AEpisodeID,AStatus)
	
	while category.%Next()
	{
		s ItemType = category.Data("ItemType")
		continue:(ItemType = "HIS")
		s categoryId = category.Data("ItemCategoryID")	
		continue:((tempCategoryID '= "")&&(tempCategoryID '= categoryId))
		s docIds = ..GetDocIdsByParent(categoryId)
		s length = $l(docIds,",")
		s tempJson = ##Class(%GlobalCharacterStream).%New()
		for I=1:1:length
		{
			s docId = $p(docIds,",",I)
			//continue:((tempDocID '= "")&&(tempDocID '= docId))
			if (tempDocID '= "")
			{
				s tempFlag = 0
				for k=1:1:$l(tempDocID,",")
				{
					s tempADocId = $p(tempDocID,",",k)
					if (tempADocId = docId)
					{
						s tempFlag = 1
						q
					}
				}
				continue:(tempFlag = 0)
			}
			s docJson = ..DoInstanceJsonByDocID(docId,AEpisodeID,AStatus,AResultType,ASequence)
			d:((tempJson.Size '= 0)&&(docJson.Size '= 0)) tempJson.Write(",")
			d tempJson.CopyFrom(docJson)
		}
		if (tempJson.Size > 0)
		{
			d:(json.Size > 0) json.Write(",")
			d json.Write("{")
			d json.Write("""id"":"""_categoryId_"""")
			s pname = "name"
			s:(AResultType = "Tree") pname = "text"
			d json.Write(","""_pname_""":"""_category.Data("ItemTitle")_"""")
			d json.Write(",""children"":[")	
			d json.CopyFrom(tempJson)	
			d json.Write("]}")
		}
	}
	q json
}

/// Desc:       按目录分类展示病历目录(只显示对应docID的)
/// Creator:    董璐璐
/// CreateDate: 2020-1-7
/// Input:      ACTLocID    用户登录科室
///            ASSGroupID  用户安全组
///            AEpisodeID  患者就诊号
///            AResultType 输出类型
///            ASequence   显示顺序  
/// Debuger:    w ##Class(EMRservice.BL.BLClientCategory).GetInstanceByDocID(110,29,35,"Tree")
ClassMethod GetInstanceByDocID(ACTLocID As %String, ASSgroupID As %String, AEpisodeID As %String, AResultType As %String = "", ASequence As %String = "", AStatus As %String = "Save", ADocID As %String = "") As %GlobalCharacterStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	q:(ACTLocID = "")||(AEpisodeID = "")||(ADocID = "") json

	s docIds = ADocID
	s objDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId($p(ADocID,",",1))
	q:(objDoc = "") json
	s categoryId = objDoc.ParentCategoryID
	s objCategory = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(categoryId)
	q:(objCategory = "") json
	s title = objCategory.CategoryName
	s length = $l(docIds,",")
	s tempJson = ##Class(%GlobalCharacterStream).%New()
	for I=1:1:length
	{
		s docId = $p(docIds,",",I)
		s docJson = ..DoInstanceJsonByDocID(docId,AEpisodeID,AStatus,AResultType,ASequence)
		d:((tempJson.Size '= 0)&&(docJson.Size '= 0)) tempJson.Write(",")
		d tempJson.CopyFrom(docJson)
	}
	if (tempJson.Size > 0)
	{
		d:(json.Size > 0) json.Write(",")
		d json.Write("{")
		d json.Write("""id"":"""_categoryId_"""")
		s pname = "name"
		s:(AResultType = "Tree") pname = "text"
		d json.Write(","""_pname_""":"""_title_"""")
		d json.Write(",""children"":[")	
		d json.CopyFrom(tempJson)	
		d json.Write("]}")
	}
	q json
}

/// Desc:     	按创建时间顺序返回病历目录列表
/// Creator:   	Candyxu
/// CreateDate:	2014-8-16
/// Input:     	AEpisodeId 就诊号
///           	AStatus 病历状态
/// Output:    	json
/// debug:     	w ##Class(EMRservice.BL.BLClientCategory).GetRecordCatalogByHappenDate(112,"Save")
ClassMethod GetRecordCatalogByHappenDate(AEpisodeId As %String, AStatus As %String, AResultType As %String = "", ASequence As %String = "", ADocID As %String = "", ARecordShowType As %String = "") As %GlobalCharacterStream
{
	s json = ##Class(%GlobalCharacterStream).%New(),count = 1
	q:(AEpisodeId = "") json
	s tempDocID = ""
	s tempCategoryID = ""
	if (ARecordShowType = "Doc")
	{
		s tempDocID = ADocID
	}
	elseif (ARecordShowType = "Category")
	{
		s tempCategoryID = ##Class(EMRservice.BL.BLClientCategory).GetCategoryIDByDocID(ADocID)
	}
	s seq = 1
	s:(ASequence = "DESC") seq = -1
	s date = ""
	for
	{
		s date = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeId," "_$zcvt(AStatus,"U"),date),seq)
		q:(date = "")
		s time = ""
		for
		{
			s time = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeId," "_$zcvt(AStatus,"U"),date,time),seq)
			q:(time = "")
			s parentId = ""
			for
			{
				s parentId = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeId," "_$zcvt(AStatus,"U"),date,time,parentId),seq)
				q:(parentId = "")
				s subId = ""
				for
				{
					s subId = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeId," "_$zcvt(AStatus,"U"),date,time,parentId,subId),seq)
					q:(subId = "")
					
					if (ARecordShowType '= "")
					{
						s rowId = parentId_"||"_subId
						s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(rowId)
						q:(objInstance = "")
						s docId = objInstance.TheECRecord.RealChartItemID
						if (tempDocID '= "")
						{
							//continue:(docId '= tempDocID)
							s tempFlag = 0
							for k=1:1:$l(tempDocID,",")
							{
								s tempADocId = $p(tempDocID,",",k)
								if (tempADocId = docId)
								{
									s tempFlag = 1
									q
								}
							}
							continue:(tempFlag = 0)
						}
						elseif (tempCategoryID '= "")
						{
							s categoryId = ##Class(EMRservice.BL.BLClientCategory).GetCategoryIDByDocID(docId)
							continue:(categoryId '= tempCategoryID)
						}
					}
					
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
/// 				AOperInfo 手术信息（手术相关界面获取手术实例表格时传入手术信息）
/// Debug:     w ##Class(EMRservice.BL.BLClientCategory).GetInstanceJsonByID(1,1,"ZTree")
ClassMethod GetInstanceJsonByID(AEcrecordID As %String, ASubID As %String, AResultType As %String = "", AOperInfo As %String = "") As %String
{
	s json = ""
	q:((AEcrecordID = "")||(ASubID = "")) json
	s rowId = AEcrecordID_"||"_ASubID
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(rowId)
	q:(objInstance = "") json
	s epsiodeId = objInstance.TheECRecord.RealEpisodeID
	s docId = objInstance.TheECRecord.RealChartItemID
	s num = objInstance.ListNo
	s title = ##Class(EMRservice.Util.EscapeSpecialWord).HtmlEscape(objInstance.Title)
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	s title = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRinstance.InstanceData","Title",title,langid)
	s templateId = objInstance.RealTemplateID
	s templateName=##class(EMRmeta.Template).%OpenId(templateId).Name
	s summary = objInstance.Memo
	s objCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
	q:(objCategoryDoc = "") json
	s objChapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objCategoryDoc.ParentCategoryID)
	q:(objChapter = "") json
	s categoryId = objChapter.ParentCategoryID
	s categoryName = objChapter.CategoryName
	s isLeadframe = objCategoryDoc.IsLeadframe
	s isMutex = objChapter.IsMutex
	s isWaitsign = objCategoryDoc.IsWaitsign
	s characteristic = objInstance.TheECRecord.DocumentCharacteristic
	s chartItemType = objInstance.TheECRecord.ChartItemType
	s documentType = objInstance.TheECRecord.DocumentType
	s happendate = $zd(objInstance.HappenDate,3)
	s happentime = $zt(objInstance.HappenTime)
	//add by lifb 2017-08-21
	s HISFormatHappenDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",happendate)
	s HISFormatHappenTime=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",happentime)


	s log = ##Class(EMRservice.BL.BLEMRLogs).GetLogStatus(epsiodeId,docId,num)
	s statusCode = $p(log,"^",10)
	s status = $p(log,"^",11)
	s revokeSign = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("IsRevokeSign","Y")
	s hasSign = ##Class(EMRservice.BL.BLTemplateSign).HasRecordSign(epsiodeId,docId,num)
	s:(($p(log,"^",10)="finished")||($p(log,"^",10)="checkedRevision")) hasSign = "0"
	s waitTitleCode = objInstance.TitleCode
	s:(characteristic = "0") waitTitleCode = $zcvt(chartItemType,"U")
	if (isWaitsign '= "1")
	{
		s doctorwait = ##Class(EMRservice.BL.BLTemplateSign).GetSignWaitStatus(templateId,objInstance.TemplateVersion,waitTitleCode,"MEDICAL",hasSign,epsiodeId,docId,num,revokeSign)
	}
	else
	{
		s doctorwait = "0"
	}
	if (##Class(EMRservice.SystemParameter).IsPatientSignPDF() = "Y")
	{
		s patientwait = ##Class(EMRservice.BL.BLTemplateSign).GetPatientPDFSignWaitStatus(templateId,objInstance.TemplateVersion,waitTitleCode,"PATIENT",hasSign,epsiodeId,docId,num,rowId)
	}
	else
	{
		s patientwait = ##Class(EMRservice.BL.BLTemplateSign).GetSignWaitStatus(templateId,objInstance.TemplateVersion,waitTitleCode,"PATIENT",hasSign,epsiodeId,docId,num,revokeSign)
	}
	//患者签名状态
	s patSignStatus = ##Class(EMRservice.BL.BLClientCategory).GetPatSignStatus(rowId,epsiodeId,patientwait)
	//指定病历实例是否有对应患者签名后的PDF文档
    s pdfStatus = ##Class(EMRservice.BL.BLPDFAuditSignLog).GetPDFStatus(rowId, epsiodeId)
    s pdfDocType = $Case($zcvt(pdfStatus,"U"),"SIGNED":"PDF",:"XML")
	s doctorIsSignCA =  ##Class(EMRservice.BL.BLClientCategory).GetIsSignCAByType(rowId,"Doctor")
	s creator = $tr($p(log,"^",1)," ","")
	s creator = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("User.SSUser","SSUSRName",creator,langid)
	//获取病历日志明细最后一次操作的Action名字
	s action = $p(log,"^",8)
	s:(action '= "print") action = ""
    s printDesc = ""
    if (action = "") {
        s recHasAction = ##Class(EMRservice.BL.BLEMRLogs).RecHasAction(epsiodeId,rowId,"print")
        s:(recHasAction '= "0") printDesc = "打印后修改"
    }
	//产品来源名称
	s productSource = $p(log,"^",17)
	if (action '= "") 
	{
		s action = ##Class(EMRservice.BL.BLOperationNameBasedProduct).GetOperationName(action,productSource)
		s:(action = "") action = "已打印"
	}
	//是否打印过的标志 add 202-12-19 lfy
	s isHasPrinted = ##class(EMRservice.BL.BLEMRLogs).RecHasAction(epsiodeId,AEcrecordID_"||"_ASubID,"print")
	
	//系统签名日志ID
	s emrSignID = $p(log,"^",18)
	//CA签名日志表ID
	s caSignID = ""
	if (emrSignID '= "")
	{
		s emrSignObj = ##class(EMRinstance.EMRSign).%OpenId(emrSignID)
		s:(emrSignObj '= "") caSignID = emrSignObj.SignID
	}
	//病历目前最新状态status的操作者operator
	s operator = ##Class(EMRservice.BL.BLEMRLogs).GetOperatorByInstanceId(epsiodeId,rowId)
	s operator = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("User.SSUser","SSUSRName",operator,langid)
	s operateDateTime = ##Class(EMRservice.BL.BLEMRLogs).GetOperateDateTimeByInstanceId(rowId)
	s operateDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",$p(operateDateTime,"^",1))
	s operateTime=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",$p(operateDateTime,"^",2))	
	s startPage = objInstance.StartPageNum
	s endPage = objInstance.EndPageNum
	//修改了记录时间的标志
	s modifyTimeFlag = 0
	if ((objInstance.CreateDate '= objInstance.HappenDate)||($zabs(objInstance.CreateTime - objInstance.HappenTime) > 120))
	{
		s modifyTimeFlag = 1
	}
	
	s isModifyColorChangeColor = ##Class(EMRservice.SystemParameter).IsModifyRecordChangeColor()
	
	s orgItemId = $o(^DHCEMRM.CTOrgSchemeItemI("IdxEMRTemplateCategoryID"," "_categoryId,""))
	q:(orgItemId = "") json
	s objOrgItem = ##Class(EMRmeta.CTOrganizationSchemeItem).%OpenId(orgItemId)
	q:(objOrgItem = "") json
	
	s itemTitle = objOrgItem.ItemTitle

	//表格视图查询json数据
	if ((AResultType = "ZTree")||(AResultType = "Tree"))
	{
		s name = happendate_" "_happentime_" "_title_" "_creator_" "_status
        s HISUIname = title_" "_creator_" "_status
		if ((modifyTimeFlag = 1)&&(isModifyColorChangeColor = "Y"))
		{
			if (action '= "")
			{
				s name = "<span style='color:red;background-color:#E0ECFF;'>"_name_"</span>"
			}
			else
			{
				s name = "<span style='color:red;'>"_name_"</span>"
			}
		}
		elseif(action '= "")
		{
			s name = "<span style='background-color:#E0ECFF;'>"_name_"</span>"
		}
		d RecordZTreeType
	}
	else
	{
		d RecordListType
	}
	k objInstance,objCategoryDoc,objChapter
	s json = $ZSTRIP(json,"*C")
	q json
RecordListType
	s json = json_"{"
	s json = json_"""id"":"""_rowId_""""
	s json = json_",""text"":"""_title_""""
	s json = json_",""chartItemType"":"""_chartItemType_"""" 
	s json = json_",""documentType"":"""_documentType_"""" 
	s json = json_",""categoryId"":"""_ categoryId_""""
    s json = json_",""categoryName"":"""_categoryName_""""
	s json = json_",""emrDocId"":"""_docId_""""
	s json = json_",""emrNum"":"""_num_""""
	s json = json_",""templateId"":"""_templateId_""""
	s json = json_",""templateName"":"""_templateName_""""
	s json = json_",""isLeadframe"":"""_isLeadframe_"""" 
	s json = json_",""isMutex"":"""_isMutex_"""" 
	s json = json_",""characteristic"":"""_characteristic_""""
	s json = json_",""happendate"":"""_HISFormatHappenDate_""""
	s json = json_",""happentime"":"""_HISFormatHappenTime_""""
	s json = json_",""creator"":"""_creator_""""
	s json = json_",""operator"":"""_operator_""""
	s json = json_",""operateDate"":"""_operateDate_""""
	s json = json_",""operateTime"":"""_operateTime_""""
	s json = json_",""statusCode"":"""_statusCode_""""
	s json = json_",""status"":"""_status_""""
	s json = json_",""printstatus"":"""_action_""""
    s json = json_",""printDesc"":"""_printDesc_""""
	s json = json_",""isHasPrinted"":"""_isHasPrinted_""""
	s json = json_",""summary"":"""_summary_""""
	s json = json_",""JaneSpell"":"""_objChapter.JaneSpell_""""
	s json = json_",""FullFight"":"""_objChapter.FullFight_""""
	s json = json_",""startPage"":"""_startPage_""""
	s json = json_",""endPage"":"""_endPage_""""
	s json = json_",""hasSign"":"""_hasSign_""""
	s json = json_",""modifyTimeFlag"":"""_modifyTimeFlag_""""
	s json = json_",""isWaitsign"":"""_isWaitsign_""""
	s json = json_",""createdate"":"""_HISFormatHappenDate_""""
	s json = json_",""createtime"":"""_HISFormatHappenTime_""""
	s json = json_",""itemTitle"":"""_itemTitle_""""
	s json = json_",""nodeType"":""instance"""
	s json = json_",""doctorwait"":"""_doctorwait_""""
	s json = json_",""doctorIsSignCA"":"""_doctorIsSignCA_""""
    s json = json_",""epsiodeId"":"""_epsiodeId_""""
	s json = json_",""pdfDocType"":"""_pdfDocType_""""
	s json = json_",""patSignStatus"":"""_patSignStatus_""""
	s json = json_",""emrSignID"":"""_emrSignID_""""
    s json = json_",""caSignID"":"""_caSignID_""""
    s json = json_",""OperInfo"":"""_AOperInfo_""""
	s json = json_"}"
	q
RecordZTreeType
	s json = json_"{"
	s json = json_"""id"":"""_rowId_""""
	s pname = "name"
	s:(AResultType = "Tree") pname= "text"
	s json = json_","""_pname_""":"""_name_""""
	s json = json_",""attributes"":{" 
	s json = json_"""chartItemType"":"""_chartItemType_"""" 
    s json = json_",""specialtext"":"""_HISUIname_"""" 
	s json = json_",""documentType"":"""_documentType_"""" 
	s json = json_",""categoryId"":"""_categoryId_""""
	s json = json_",""categoryName"":"""_categoryName_""""
	s json = json_",""emrDocId"":"""_docId_""""
	s json = json_",""emrNum"":"""_num_""""
	s json = json_",""templateId"":"""_templateId_""""
	s json = json_",""templateName"":"""_templateName_""""
	
	s json = json_",""isLeadframe"":"""_isLeadframe_"""" 
	s json = json_",""isMutex"":"""_isMutex_"""" 
	s json = json_",""characteristic"":"""_characteristic_""""
	s json = json_",""happendate"":"""_HISFormatHappenDate_""""
	s json = json_",""happentime"":"""_HISFormatHappenTime_""""
	s json = json_",""creator"":"""_creator_""""
	s json = json_",""operator"":"""_operator_""""
	s json = json_",""statusCode"":"""_statusCode_""""
	s json = json_",""status"":"""_status_""""
	s json = json_",""printstatus"":"""_action_""""
    s json = json_",""printDesc"":"""_printDesc_""""
	s json = json_",""isHasPrinted"":"""_isHasPrinted_""""
	s json = json_",""summary"":"""_summary_""""
	s json = json_",""text"":"""_title_""""
	s json = json_",""JaneSpell"":"""_objChapter.JaneSpell_""""
	s json = json_",""FullFight"":"""_objChapter.FullFight_""""
	s json = json_",""startPage"":"""_startPage_""""
	s json = json_",""endPage"":"""_endPage_""""
	s json = json_",""hasSign"":"""_hasSign_""""
    s json = json_",""itemTitle"":"""_itemTitle_""""
	s json = json_",""isWaitsign"":"""_isWaitsign_""""
	s json = json_",""doctorwait"":"""_doctorwait_""""
	s json = json_",""doctorIsSignCA"":"""_doctorIsSignCA_""""	
    s json = json_",""epsiodeId"":"""_epsiodeId_""""
	s json = json_",""emrSignID"":"""_emrSignID_""""
	s json = json_",""pdfDocType"":"""_pdfDocType_""""
	s json = json_",""patSignStatus"":"""_patSignStatus_""""
    s json = json_",""caSignID"":"""_caSignID_""""
	s json = json_"}"
	s json = json_"}"	
	q
}

/// Desc:       获取患者签名状态
/// Creator:    Donglulu
/// CreateDate: 2022-9-13
/// Input:      AInstanceID 病历ID
///             AEpisodeID:就诊号
///             APatientwait:待签配置的患者待签，1 患者待签/0 未配置患者待签或者患者已签名
/// OutPut:     json    
/// w ##Class(EMRservice.BL.BLClientCategory).GetPatSignStatus(601,76,"")
ClassMethod GetPatSignStatus(AInstanceID As %String, AEpisodeID As %String, APatientwait As %String) As %String
{
	s result = ""
	q:((AInstanceID = "")||(AEpisodeID = "")) result
	//指定病历实例是否有对应患者签名后的PDF文档
    s pdfStatus = ##Class(EMRservice.BL.BLPDFAuditSignLog).GetPDFStatus(AInstanceID, AEpisodeID)
    s caStatus = ##Class(EMRservice.BL.BLClientCategory).GetIsSignCAByType(AInstanceID, "Patient")
    if (pdfStatus = "SIGNED")
    {
	    s result = "已签[PDF]"
    }
    elseif (pdfStatus = "TOSIGN")
    {
	    s result = "待签[PDF]"
    }
    elseif (caStatus = "1")
    {
	    s result = "已签"
    }
    elseif (APatientwait = "1")
    {
	    s result = "待签"
    }
	q result
}

/// Desc:       获取病历是否有CA有效签名
/// Creator:    Donglulu
/// CreateDate: 2022-9-13
/// Input:      AInstanceID 病历ID
///             AType: Doctor 医生/Patient 患者
/// Output:     1 有/0 无
/// Debug:      w ##Class(EMRservice.BL.BLClientCategory).GetIsSignCAByType("223||1","")
ClassMethod GetIsSignCAByType(AInstanceID As %String, AType As %String) As %String
{
	s result = "0"
	q:(AInstanceID = "")||(AType = "") result
	s rowId = ""
	for
	{
		s rowId = $o(^DHCEMRI.EMRSignI("IdxInstance"," "_AInstanceID,rowId))
		q:(rowId = "")
		s objEmrsign = ##Class(EMRinstance.EMRSign).%OpenId(rowId)
		continue:(objEmrsign = "")
		continue:(objEmrsign.isSignValid '= "1")
		continue:(objEmrsign.Type '= "CA")
		if (AType = "Patient")
		{
			continue:(objEmrsign.Action '= "patientSign")
		}
		else
		{
			continue:(objEmrsign.Action = "patientSign")
		}
		s result = "1"
		q
	}
	q result
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

/// Desc:       根据docID取病历模板目录
/// Modify:     Candyxu
/// DateTime:   2014-7-17
/// Input:      AparentID:目录Id
///             AepisodeID:就诊号
/// OutPut:     json    
/// d ##Class(EMRservice.BL.BLClientCategory).GetINSUTempCateByDocID(601,76)
ClassMethod GetINSUTempCateByDocID(AdocID As %String, AepisodeID As %String) As %String
{
	s json = ""
	s result = ""
	q:((AdocID = "")||(AepisodeID = "")) json
	s objCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(AdocID)
	q:(objCategoryDoc = "") json
	s objChapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objCategoryDoc.ParentCategoryID)
	q:(objChapter = "") json
	s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(AdocID)
	q:(objTemplate = "") json
	s objcategory = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objChapter.ParentCategoryID)
	q:(objcategory = "") json
	s json = json_"{"
	s json = json_ """id"":"""_AdocID_""""
	s json = json_ ",""text"":"""_objChapter.CategoryName_""""
	s json = json_ ",""pluginType"":"""_objTemplate.DocumentType_""""
	s json = json_ ",""chartItemType"":"""_objTemplate.ChartItemType_""""
	s json = json_ ",""isLeadframe"":"""_objCategoryDoc.IsLeadframe_""""
	s json = json_ ",""isMutex"":"""_objCategoryDoc.IsMutex_""""
	s json = json_ ",""templateId"":"""_objTemplate.ID_""""
	s json = json_ ",""categoryId"":"""_objChapter.ParentCategoryID_""""
	s json = json_ ",""actionType"":""CREATE"""
	s json = json_ ",""closable"":""False"""
	s json = json_ "}"
	s result = "{""id"":"""_objChapter.ParentCategoryID_""""
	s result = result_",""text"":"""_objcategory.CategoryName_""""			
    s result = result_",""type"":"""""
	s result = result_",""childs"":["_json_"]}"	
	q result
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
	s saveFlag = $d(^DHCEMRI.InstanceDataI("IdxEpisodeTitleCodeStatus",AEpisodeID," "_$zcvt(ATitleCode,"U")," SAVE"))
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
/// 			AOperInfo 手术信息（手术相关界面获取手术实例表格时传入手术信息）
/// Debug:      d ##Class(EMRservice.BL.BLClientCategory).GetInstanceByCategoryEvent(5,76,"Operation","1")
ClassMethod GetInstanceByCategoryEvent(ACategoryId As %String, AEpisodeId As %String, AEventType As %String, AEventId As %String, ASequence As %String = "", AOperInfo As %String = "") As %GlobalBinaryStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	q:(AEpisodeId = "")||(ACategoryId = "")||(AEventType = "")||(AEventId = "") json
	s docIds = ..GetDocIdsByParent(ACategoryId)
	s length = $l(docIds,",")
	for I=1:1:length
	{
		s docId = $p(docIds,",",I)
		s docJson = ##Class(EMRservice.BL.Event.BLLinkDocument).GetInstanceJson(docId,AEpisodeId,"Save",AEventType,AEventId,ASequence,AOperInfo)
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
/// 			AOperInfo 手术信息（手术相关界面获取手术实例表格时传入手术信息）
/// OutPut:     result
ClassMethod GetInstanceNoLinkEvent(ACategoryId As %String, AEpisodeId As %String, AEventType As %String, AOperInfo As %String = "") As %GlobalBinaryStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	q:(AEpisodeId = "")||(ACategoryId = "")||(AEventType = "") json
	s docIds = ..GetDocIdsByParent(ACategoryId)
	s length = $l(docIds,",")
	for I=1:1:length
	{
		s docId = $p(docIds,",",I)
		s ecredordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeId,docId,""))
		continue:(ecredordId = "")
		s date = ""
		for
		{
			s date = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecredordId," SAVE",date))
			q:(date = "")
			s time = ""
			for
			{
				s time = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecredordId," SAVE",date,time))
				q:(time = "")
				s subId = ""
				for
				{
					s subId = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecredordId," SAVE",date,time,subId))
					q:(subId = "")
					continue:($d(^DHCEMRI.Events.LinkDocumnentsI("IdxInstanceType"," "_ecredordId_"||"_subId," "_$zcvt(AEventType,"U")))>0)
					s resultJson = ..GetInstanceJsonByID(ecredordId,subId,"",AOperInfo)
					continue:(resultJson = "")
					d:(json.Size '= 0) json.Write(",")
					d json.Write(resultJson)
				}
			}
		} 
	}
	q json
}

/// Desc:     取未关联手术的病历模板目录
/// Modify:   Lina
/// DateTime: 2019-11-5
/// Input:    AParentId:目录CategoryId
///           AEpisodeID:就诊号
/// OutPut:   json   
/// Debug:    w ##Class(EMRservice.BL.BLClientCategory).GetTempCateJsonNoLink(5,4,10209,"","Operation")
ClassMethod GetTempCateJsonNoLink(AParentID As %String, AEpisodeID As %String, AUserID As %String, AResultType As %String = "", AEventType As %String, ACTLocId As %String = "") As %GlobalCharacterStream
{
    s json = ##Class(%GlobalCharacterStream).%New()
    s priActivity = ..CheckTPrivActivity()  //权限控制  
    s curPatInfo = ##class(EMRservice.DocRestLogic.PrivLogic).GetPatInfo(AEpisodeID,AUserID)
    s patDept = $p($li(curPatInfo,2),$c(2),2)   
    s strdocIds = ..GetDocByCategoryID(AParentID,AEpisodeID,AUserID,priActivity,curPatInfo)
    q:((AParentID = "")||(AEpisodeID = "")||(strdocIds = "")) json
    Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
    s mutexdoc = $p(strdocIds,"&",1)
    s nomutexdoc = $p(strdocIds,"&",2)
    s iswrited = ##class(EMRservice.BL.BLInstanceData).IsHasInstanceByDocIDs(AEpisodeID,mutexdoc)
    if (iswrited = "1")
    {
        s strdocIds = nomutexdoc
    }
    else
    {
        s strdocIds = $case(mutexdoc,"":nomutexdoc,:mutexdoc_"^"_nomutexdoc)
    }
    //获取无关联手术的相关模板DocIDs "70^68^80^76"
    s operativeDocIds = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("OperativeDocIds","")
    q:($ZSTRIP(operativeDocIds,"*C") = "") json
    s result = ""
    for i=1:1:$l(strdocIds,"^")
    {
        s tmpDocId = $p(strdocIds,"^",i)
        continue:($f("^"_operativeDocIds_"^", "^"_tmpDocId_"^") = 0)
        s result = $case(result,"":tmpDocId,:result_"^"_tmpDocId)
    }
    q:(result = "") json
    s strdocIds = result
    s key = $i(^CacheTemp("GetTempCateJsonByCategoryID"))
    for i=1:1:$l(strdocIds,"^")
    {
        s docId = $p(strdocIds,"^",i)
        continue:(docId = "")
        s objdoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
        continue:(objdoc = "")
        s objchapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objdoc.ParentCategoryID)
        continue:(objchapter = "")
        s objcategory = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objchapter.ParentCategoryID)
        continue:(objcategory = "")
        
        s JaneSpell = objchapter.JaneSpell
        s FullFight = objchapter.FullFight
        
        s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(docId)
        continue:(objTemplate = "")
        s result = ##class(EMRservice.BL.BLInstanceData).IsHasInstance(AEpisodeID, objTemplate.ID,docId)
        continue:((result '= 0) && (objTemplate.ChartItemType = "Single"))  
        s childs = ..GetTitleByDocID(docId,AEpisodeID,AEventType,"",ACTLocId)
        s quotationFlag = ##Class(EMRservice.BL.BLQuotation).GetDocQuationFlag(patDept,docId) 
        s displayFlag = ##Class(EMRservice.SystemParameter).SetNavQuoteDisplay(AEpisodeID)
        s:(displayFlag = "N") quotationFlag = "0"
        s objEMRTemplateCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
	    set EMRChartItemType = ##class(EMRservice.EMRDoc.DocCategoryFunSet).GetChapterDocType(objEMRTemplateCategoryDoc.ParentCategoryID)
        s title = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.EMRTemplateCategory","CategoryName",objchapter.CategoryName,langid)
		s docidText = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.EMRTemplateCategory","CategoryName",objdoc.CategoryName,langid)
        if (AResultType = "List")
        {
            d DisplayInList 
        }
        else
        {
            d DisPlayInTree
        }
        s cjson = $ZSTRIP(cjson,"*C")
        s ^CacheTemp("GetTempCateJsonByCategoryID",key,i)= cjson
        s ^CacheTemp("GetTempCateJsonByCategoryID",key,"Flag",docId) = i
    }
    if (AResultType = "List")
    {
        s tempJson = ##Class(EMRservice.BL.BLEMRTemplateDocGroup).GetGroupTemplate(patDept,"CG"_AParentID,key)
        d json.CopyFrom(tempJson)
    }
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
    s cjson = "{"
    s cjson = cjson_ """id"":"""_docId_""""
    s cjson = cjson_ ",""text"":"""_$s(((EMRChartItemType="Multiple")&&(objdoc.IsLeadframe=0)):docidText,1:title)_""""
    s cjson = cjson_ ",""type"":""TempCate""" 
    s cjson = cjson_ ",""chartItemType"":"""_objTemplate.ChartItemType_"""" 
    s cjson = cjson_ ",""documentType"":"""_objTemplate.DocumentType_"""" 
    s cjson = cjson_ ",""isLeadframe"":"""_objdoc.IsLeadframe_""""
    s cjson = cjson_ ",""isMutex"":"""_objchapter.IsMutex_""""
    s cjson = cjson_",""templateId"":"""_objTemplate.ID_""""
    s cjson = cjson_",""categoryId"":"""_AParentID_""""
    s cjson = cjson_",""quotation"":"""_$case(quotationFlag>0,1:1,:0)_""""
    s cjson = cjson_ ",""JaneSpell"":"""_JaneSpell_"""" 
    s cjson = cjson_ ",""FullFight"":"""_FullFight_""""
    s cjson = cjson_ "}"
    q
DisPlayInTree  
    s cjson = "{"
    s cjson = cjson_ """id"":"""_docId_""""
    s cjson = cjson_ ",""text"":"""_$s(((EMRChartItemType="Multiple")&&(objdoc.IsLeadframe=0)):docidText,1:title)_""""
    s cjson = cjson_ ",""childs"":["_childs_"]"
    s cjson = cjson_ ",""attributes"":{" 
    s cjson = cjson_ """type"":""TempCate""" 
    s cjson = cjson_ ",""chartItemType"":"""_objTemplate.ChartItemType_"""" 
    s cjson = cjson_ ",""documentType"":"""_objTemplate.DocumentType_"""" 
    s cjson = cjson_ ",""isLeadframe"":"""_objdoc.IsLeadframe_""""
    s cjson = cjson_ ",""isMutex"":"""_objchapter.IsMutex_""""
    s cjson = cjson_",""templateId"":"""_objTemplate.ID_""""
    s cjson = cjson_",""categoryId"":"""_AParentID_""""
    s cjson = cjson_",""quotation"":"""_$case(quotationFlag>0,1:1,:0)_""""
    s cjson = cjson_ ",""JaneSpell"":"""_JaneSpell_"""" 
    s cjson = cjson_ ",""FullFight"":"""_FullFight_"""" 
    s cjson = cjson_ "}"
    s cjson = cjson_ "}"
    q
}

/// Desc:       将病历模板目录CategoryName转换成全拼和简拼存入表中
/// Creator:    Donglulu
/// CreateDate: 2017-2-16
/// Input:      
/// OutPut:  
/// d ##Class(EMRservice.BL.BLClientCategory).GetCategoryNameJaneSpellAndFullFight(0)   
ClassMethod GetCategoryNameJaneSpellAndFullFight(AParentCategoryID As %String)
{
	s categoryID = ""
	for
	{
		s categoryID = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID"," "_AParentCategoryID,categoryID))
		q:(categoryID = "")
		s objEMRTemplateCategory =##Class(EMRmeta.EMRTemplateCategory).%OpenId(categoryID)
		continue:(objEMRTemplateCategory = "")
		s objEMRTemplateCategory.FullFight = ##class(EMRservice.Tools.Tool).GetCNCODE(objEMRTemplateCategory.CategoryName,3,"")
		s objEMRTemplateCategory.JaneSpell = ##class(EMRservice.Tools.Tool).GetCNCODE(objEMRTemplateCategory.CategoryName,4,"")
		d objEMRTemplateCategory.%Save()
	    d objEMRTemplateCategory.%Close()	
		k objEMRTemplateCategory
		d ..GetCategoryNameJaneSpellAndFullFight(categoryID)
	}
}

/// Desc:       获得当前目录状态
/// Creator:    Candy
/// CreateDate: 2017-10-10
/// Input:      ACTLocID 科室ID
///            ASSGroupID 安全组ID
///            AEpisodeID 就诊号
///            ACategoryID 目录分类ID(目录展现结构第一层ID)
/// Output:     {"Visible":"1","Sequence":"0"} Visible 为1可见0不可见  Sequence 目录的所在顺序
/// Debug:      w ##Class(EMRservice.BL.BLClientCategory).GetCategoryStatus(6,100,112,3)
ClassMethod GetCategoryStatus(ACTLocID As %String, ASSGroupID As %String, AEpisodeID As %String, ACategoryID As %String) As %String
{
	s result = "{""Visible"":""0"",""Sequence"":""0"",""Num"":""0""}"
	s dataVer = ##Class(EMRservice.BL.BLScatterData).GetDataVersion(AEpisodeID)
	if (dataVer = "2")
	{
		s:(ACategoryID = "EPR") result = "{""Visible"":""1"",""Sequence"":""1""}" 
		q result
	}
	q:(ACategoryID = "EPR") result
	q:(ACTLocID = "")||(ASSGroupID = "")||(AEpisodeID = "")||(ACategoryID = "") result
	s itemDr = $o(^DHCEMRM.CTOrgSchemeItemI("IdxEMRTemplateCategoryID"," "_ACategoryID,""))
	q:(itemDr = "") result
	s objCTOrgScheme = ##Class(EMRmeta.CTOrganizationSchemeItem).%OpenId(itemDr)
	q:(objCTOrgScheme = "") result
	s itemCode = objCTOrgScheme.ItemCode
	s episodeType = $p(^PAADM(AEpisodeID),"^",2)
	if (episodeType = "I")
	{
		s disDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(AEpisodeID)
		s schemCode = $case(disDateTime,"":"RUNNING",:"ARCHIVING")
	}
	else
	{
		s schemCode = "OUTPATIENT"
	}
	s rowId = $o(^DHCEMRM.EMRNavSchemeItemI("IdxSchemeItemCode"," "_schemCode," "_$zcvt(itemCode,"U"),""))
	q:(rowId = "") result
	s objNav = ##Class(EMRmeta.EMRNavigationSchemeItem).%OpenId(rowId)
	q:(objNav = "") result
	
	
	s strItemSeq = objNav.ItemSeq
	//如果该科室设置病例导航科室项目顺序，通过科室项目顺序获取
	s rowSeqID = $o(^DHCEMRM.EMRNavSchemeItemSeqLocI("IdxLocGID"," "_ACTLocID,""))
	if (rowSeqID'="")
	{
		s objItemSeqLoc = ##class(EMRmeta.EMRNavigationSchemeItemSeqLoc).%OpenId(rowSeqID)
		s strCTLocGroupID = objItemSeqLoc.CTLocGroupID
		s rowSeqID = $o(^DHCEMRM.EMRNavSchemeItemSeqI("IdxLocGItemID"," "_strCTLocGroupID," "_rowId,""))
		if (rowSeqID'="")
		{
			s objNavSeq = ##Class(EMRmeta.EMRNavigationSchemeItemSeq).%OpenId(rowSeqID)
			s:(objNavSeq '= "") strItemSeq = objNavSeq.ItemSeq
		}
	}
	
	q:($d(^DHCEMRM.EMRNavItemSSGroupI("IdxCodeSSGroup"," "_schemCode," "_itemCode," "_ASSGroupID))<=0) result			
	s locFlag = $d(^DHCEMRM.EMRNavItemLocI("IdxCodeCTLocID"," "_schemCode," "_itemCode," "_ACTLocID))
	s recordFlag = ..CheckHasRecord(ACategoryID,AEpisodeID)
	q:((locFlag <=0)&&(recordFlag<=0)) result
	s num = ##Class(EMRservice.BL.BLClientCategory).GetRecordCount(ACategoryID,AEpisodeID)
    s printNum = ##Class(EMRservice.BL.BLClientCategory).GetPrintedRecordCount(ACategoryID,AEpisodeID)
    s result = "{""Visible"":""1"",""Sequence"":"""_strItemSeq_""",""Num"":"""_num_""",""PrintNum"":"""_printNum_"""}"
	q result
}

/// Desc:取加载导航参数
/// Creator:    Candy
/// CreateDate: 2017-10-10
/// Input:      ACategoryID 目录ID
///             AUserID 用户ID
///             ALocID 科室ID
/// Debug: w ##Class(EMRservice.BL.BLClientCategory).GetNavParam(3,4133,190)
ClassMethod GetNavParam(ACategoryID As %String, AUserID As %String, ALocID As %String) As %String
{
	s json = ""
	q:(ACategoryID = "") "{}"
	s itemDr = $o(^DHCEMRM.CTOrgSchemeItemI("IdxEMRTemplateCategoryID"," "_ACategoryID,""))
	q:(itemDr = "") result
	s objCTOrgScheme = ##Class(EMRmeta.CTOrganizationSchemeItem).%OpenId(itemDr)
	q:(objCTOrgScheme = "") result
	s navCsp = objCTOrgScheme.ItemURL
	s defaultSequence = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("RecordSequence")
	s Stream = ##Class(%GlobalCharacterStream).%New()
	d Stream.Write(defaultSequence)
	//解析json参数
	s objJson = ##Class(EMRservice.Parser.Json).%New()  
	s array = objJson.Deserialize(Stream)
	s sequence = array.GetAt("NavRecord")
	// 若当前用户没有记录升/倒序，默认为系统参数RecordSequence配置
	s recordSequence = ##Class(EMRservice.BL.BLUserConfig).GetConfig(AUserID,ALocID,"NAVRECORDSEQ")
	s:(recordSequence = "") recordSequence = sequence
	s config = ##Class(EMRservice.BL.BLUserConfig).GetConfig(AUserID,ALocID,"DISPLAYTYPE") 
	s json = json_"{"
	s json = json_"""ItemURL"":"""_navCsp_""""	
	s json = json_",""Sequence"":"""_recordSequence_""""
	s json = json_",""DisplayType"":"""_config_""""
	s json = json_"}"
	q json
}

/// Desc:       根据docID,title取病历模板目录
/// Modify:     Candyxu
/// DateTime:   2014-7-17
/// Input:      AparentID:目录Id
///             AepisodeID:就诊号
/// OutPut:     json    
/// d ##Class(EMRservice.BL.BLClientCategory).GetTempCateByTitle(601,76)
ClassMethod GetTempCateByTitle(AdocID As %String, ATitleCode As %String) As %String
{
	s json = ""
	q:((AdocID = "")||(ATitleCode = "")) json
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
	s json = json_ ",""titleCode"":"""_ATitleCode_""""
	s json = json_ ",""templateId"":"""_objTemplate.ID_""""
	s json = json_ ",""categoryId"":"""_objChapter.ParentCategoryID_""""
	s json = json_ ",""actionType"":""CREATEBYTITLE"""
	s json = json_ ",""closable"":""False"""
	s json = json_ "}"
	q json
}

/// Desc:       根据docID取CategoryID
/// Modify:     Donglulu
/// DateTime:   2019-9-17
/// Input:      ADocID
/// OutPut:     CategoryID    
/// w ##Class(EMRservice.BL.BLClientCategory).GetCategoryIDByDocID(58)
ClassMethod GetCategoryIDByDocID(ADocID As %String) As %String
{
	s categoryID = ""
	q:(ADocID = "") categoryID
	s objCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(ADocID)
	q:(objCategoryDoc = "") categoryID
	s objChapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objCategoryDoc.ParentCategoryID)
	q:(objChapter = "") categoryID
	s categoryID = objChapter.ParentCategoryID
	q categoryID
}

/// Desc:       根据就诊号获取所写过病历的病历展现目录
/// Creator:    Lina
/// CreateDate: 2020-2-21
/// Input:      AEpisodeIDs 就诊号，多个以","分隔
/// Debug  w ##Class(EMRservice.BL.BLClientCategory).GetBrowseCategoryByEpisodeIDs("24,43,646").OutputToDevice()
ClassMethod GetBrowseCategoryByEpisodeIDs(AEpisodeIDs As %String) As %GlobalBinaryStream
{
    s json = ##Class(%GlobalBinaryStream).%New()
    q:(AEpisodeIDs = "") json
    
    s key = $i(^CacheTemp("GetBrowseCategoryID"))
    s parentCategoryID = ""
    for
    {
        s parentCategoryID = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq",parentCategoryID))
        q:(parentCategoryID = "")
        s categorySeq = ""
        for
        {
            s categorySeq = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq",parentCategoryID,categorySeq))
            q:(categorySeq = "")
            s curCategoryID = ""
            for
            {
                s curCategoryID = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq",parentCategoryID,categorySeq,curCategoryID))
                q:(curCategoryID = "")
                s objCategory = ##class(EMRmeta.EMRTemplateCategory).%OpenId(curCategoryID)
                q:(objCategory = "")||(objCategory.CategoryType '= "Category")
                s categoryChapterSeq = ""
                for
                {
                    s categoryChapterSeq = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_curCategoryID,categoryChapterSeq))
                    q:(categoryChapterSeq = "")
                    s curCategoryChapterID = ""
                    for
                    {
                        s curCategoryChapterID = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_curCategoryID,categoryChapterSeq,curCategoryChapterID))
                        q:(curCategoryChapterID = "")
                        s objCategoryChapter = ##class(EMRmeta.EMRTemplateCategory).%OpenId(curCategoryChapterID)
                        q:(objCategoryChapter = "")||(objCategoryChapter.CategoryType '= "CategoryChapter")
                        s docIDs = ..GetDocIdsByParent(curCategoryChapterID)
                        s cJson = ##Class(%GlobalBinaryStream).%New()
                        s num = $l(docIDs,",")
                        for n=1:1:num
                        {
                            s docID = $p(docIDs,",",n)
                            continue:(docID = "")
                            s length = $l(AEpisodeIDs,",")
                            for i=1:1:length
                            {
                                s episodeID = $p(AEpisodeIDs,",",i)
                                continue:(episodeID = "")
                                s tempJson = ..DoInstanceJsonByDocID(docID,episodeID,"SAVE")
                                continue:(tempJson.Size = 0)
                                d:(cJson.Size '= 0) cJson.Write(",")
                                d cJson.CopyFrom(tempJson)
                            }
                        }
                        if (cJson.Size '= 0)
                        {
                            d:(json.Size '= 0) json.Write(",")
                            d json.Write("{")
                            d json.Write("""id"":"""_curCategoryChapterID_"""")
                            d json.Write(",""categoryId"":"""_objCategoryChapter.ParentCategoryID_"""")
                            d json.Write(",""text"":"""_objCategoryChapter.CategoryName_"""")
                            d json.Write(",""children"":[") 
                            d json.CopyFrom(cJson)   
                            d json.Write("]}")
                        }
                    }
                }
            }
        }
    }
    
    q json
}

/// Desc:       根据业务域代码取DocID
/// Modify:     Donglulu
/// DateTime:   2021-5-13
/// Input:      AInternalID 业务域代码
/// OutPut:     DocID    
/// w ##Class(EMRservice.BL.BLClientCategory).GetDocIDByInternalID("EMR100009")
ClassMethod GetDocIDByInternalID(AInternalID As %String) As %String
{
	s result = ""
	q:(AInternalID = "") result
	s internalID = ""
	for
	{
		s internalID = $o(^DHCEMRM.EMRTemplateCategoryI("IdxInternalID",internalID))
	    q:(internalID = "")
	    continue:(internalID '[ AInternalID)
	    s rowID = ""
	    for
	    {
	        s rowID = $o(^DHCEMRM.EMRTemplateCategoryI("IdxInternalID",internalID,rowID))
	        q:(rowID = "")
	        s objCategory = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(rowID)
			q:(objCategory = "")
			continue:(objCategory.CategoryType '= "TempCate")
			s result = rowID
	    }
	}
	
	q result
}

/// Desc:       根据instanceID取createdatetime
/// Modify:     Donglulu
/// DateTime:   2021-6-7
/// Input:      AInstanceID 实例ID
/// OutPut:     createdatetime，例：    
/// w ##Class(EMRservice.BL.BLClientCategory).GetCreateDateTimeByInstanceID("98||149")
ClassMethod GetCreateDateTimeByInstanceID(AInstanceID As %String) As %String
{
	s result = ""
	q:(AInstanceID = "") result
	
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s createDate = $zd(objInstance.CreateDate,3)
	q:(createDate = "") result
	s createTime = $zt(objInstance.CreateTime)
	s result = createDate_" "_createTime
	q result
}

/// Desc:  取病历文书目录
/// CreateDate: 2021-6-23
/// Input: ACategoryIDs 目录IDs,多个以","分隔
/// Debug: w ##Class(EMRservice.BL.BLClientCategory).GetCategoryJsonByCategoryIDs("1,3,4,6,5,2",10209,95)
ClassMethod GetCategoryJsonByCategoryIDs(ACategoryIDs As %String, AUserID As %String, ALocID As %String) As %GlobalBinaryStream
{
    s json = ##Class(%GlobalBinaryStream).%New()
    q:(ACategoryIDs = "") json
    s length = $l(ACategoryIDs,",")
    for i=1:1:length
    {
        s cjson = ""
        s categoryID = $p(ACategoryIDs,",",i)
        continue:(categoryID = "")
        //知情同意书单独处理"EMR07"
        s objCate = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(categoryID)
		s isGetAgree = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("GetNewAgreeRecord","N")
        s itemDr = $o(^DHCEMRM.CTOrgSchemeItemI("IdxEMRTemplateCategoryID"," "_categoryID,""))
        continue:(itemDr = "")
        s objCTOrgScheme = ##Class(EMRmeta.CTOrganizationSchemeItem).%OpenId(itemDr)
        continue:(objCTOrgScheme = "")
        continue:(objCTOrgScheme.EMRTemplateCategoryID="")||(objCTOrgScheme.ItemName="批量创建")
        s navCsp = objCTOrgScheme.ItemURL
        s langid=20
        if ($d(%session)){
            set langid=+$g(%session.Data("LOGON.LANGID"))
        }
        s itemTitle = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.CTOrganizationSchemeItem","ItemTitle",objCTOrgScheme.ItemTitle,langid)
        s defaultSequence = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("RecordSequence")
        s Stream = ##Class(%GlobalCharacterStream).%New()
        d Stream.Write(defaultSequence)
        //解析json参数
        s objJson = ##Class(EMRservice.Parser.Json).%New()  
        s array = objJson.Deserialize(Stream)
        s sequence = array.GetAt("NavRecord")
        // 若当前用户没有记录升/倒序，默认为系统参数RecordSequence配置
        s recordSequence = ##Class(EMRservice.BL.BLUserConfig).GetConfig(AUserID,ALocID,"NAVRECORDSEQ")
        s:(recordSequence = "") recordSequence = sequence
        s config = ##Class(EMRservice.BL.BLUserConfig).GetConfig(AUserID,ALocID,"DISPLAYTYPE")
        d getJson
        s cjson = $ZSTRIP(cjson,"*C")
        d:(json.Size >0) json.Write(",")
        d json.Write(cjson)
    }
    q json
getJson
    s cjson = "{""CategoryID"":"""_categoryID_""""
    s cjson = cjson_",""InternalID"":"""_objCate.InternalID_""""
	s cjson = cjson_",""isGetAgree"":"""_isGetAgree_""""
    s cjson = cjson_",""ItemTitle"":"""_itemTitle_""""
    s cjson = cjson_",""ItemURL"":"""_navCsp_""""  
    s cjson = cjson_",""Sequence"":"""_recordSequence_""""
    s cjson = cjson_",""DisplayType"":"""_config_"""}"
    q
}

/// Desc:   获取CategoryID目录下所有模板DocIds
/// CreateDate: 2021-6-23    
/// Input:  ACategoryID 病历目录ID 
///         AEpisodeID 就诊ID
///         AUserID 当前登录用户ID
/// Output: docIDs 目录展现结构ID串,多个以"^"分隔
/// Debug:  w ##Class(EMRservice.BL.BLClientCategory).GetTempDocIdsByCategoryID(3,4,10209)
ClassMethod GetTempDocIdsByCategoryID(ACategoryID As %String, AEpisodeID As %String, AUserID As %String) As %String
{
    s docIDs = ""
    q:((ACategoryID = "")||(AEpisodeID = "")) docIDs
    s priActivity = ..CheckTPrivActivity()  //权限控制  
    s curPatInfo = ##class(EMRservice.DocRestLogic.PrivLogic).GetPatInfo(AEpisodeID,AUserID)
    s patDept = $p($li(curPatInfo,2),$c(2),2)
    s strdocIds = ..GetDocByCategoryID(ACategoryID,AEpisodeID,AUserID,priActivity,curPatInfo)
    s mutexdoc = $p(strdocIds,"&",1)
    s nomutexdoc = $p(strdocIds,"&",2)
    s iswrited = ##class(EMRservice.BL.BLInstanceData).IsHasInstanceByDocIDs(AEpisodeID,mutexdoc)
    if (iswrited = "1")
    {
        s docIDs = nomutexdoc
    }
    else
    {
        s docIDs = $case(mutexdoc,"":nomutexdoc,:$case(nomutexdoc,"":mutexdoc,:mutexdoc_"^"_nomutexdoc))
    }
    q docIDs
}

/// Desc:       按目录分类获取病历目录列表
/// Creator:    Lina
/// CreateDate: 2021-7-26
/// Input:      AEpisodeID  患者就诊号
///             AStatus     病历状态,默认为Save
///             ASequence   病历显示顺序,默认升序ASCE;DESC为降序;  
/// Debuger:    w ##Class(EMRservice.BL.BLClientCategory).GetInstanceListByCategory(4)
ClassMethod GetInstanceListByCategory(AEpisodeID As %String, AStatus As %String = "Save", ASequence As %String = "ASCE") As %GlobalCharacterStream
{
    s json = ##Class(%GlobalCharacterStream).%New()
    q:(AEpisodeID = "") json

    s category = ##class(%ResultSet).%New("EMRservice.BL.BLClientCategory:GetAllCategory")
    d category.Execute(AEpisodeID,AStatus)
    s categoryJson = ##Class(%GlobalCharacterStream).%New()
    s count = 0
    Set langid=20
    if ($d(%session)){
        set langid=+$g(%session.Data("LOGON.LANGID"))
    }
    while category.%Next()
    {
        s ItemType = category.Data("ItemType")
        continue:(ItemType = "HIS")
        s categoryId = category.Data("ItemCategoryID")
        s categoryTitle = category.Data("ItemTitle")
        s docIds = ..GetDocIdsByParent(categoryId)
        s length = $l(docIds,",")
        s docJson = ##Class(%GlobalCharacterStream).%New()
        for I=1:1:length
        {
            s docId = $p(docIds,",",I)
            continue:(docId = "")
            s ecrecordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID,docId,""))
            continue:(ecrecordId = "") 
            s objEcrecod = ##Class(EMRinstance.ECRecord).%OpenId(ecrecordId)
            continue:(objEcrecod = "") 
            s (docCount,docCountByDocId) = 0
            s leadFrame = objEcrecod.DocumentCharacteristic
            s objEMRTemplateCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
            continue:(objEMRTemplateCategoryDoc = "")
            ;s isWaitsign = objEMRTemplateCategoryDoc.IsWaitsign
            if (leadFrame '= "0"){
                s docIdTitle = ##Class(EMRservice.Util.EscapeSpecialWord).HtmlEscape(objEMRTemplateCategoryDoc.CategoryName)
                s docIdTitle = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.EMRTemplateCategory","CategoryName",docIdTitle,langid)
                s (signFlag,prinFlag) = "1"       
            }
            s seq = 1
            s:(ASequence = "DESC") seq = -1
            s date = ""
            for
            {
                s date = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordId," "_$zcvt(AStatus,"U"),date),seq)
                q:(date = "")
                s time = ""
                for
                {
                    s time = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordId," "_$zcvt(AStatus,"U"),date,time),seq)    
                    q:(time = "")
                    s subId = ""
                    for
                    {
                        s subId = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordId," "_$zcvt(AStatus,"U"),date,time,subId),seq)         
                        q:(subId = "")
                        s rowId = ecrecordId_"||"_subId
                        s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(rowId)
                        q:(objInstance = "")
                        s num = objInstance.ListNo
                        s pluginType = objInstance.TheECRecord.DocumentType
                        s chartItemType = objInstance.TheECRecord.ChartItemType
                        s title = ##Class(EMRservice.Util.EscapeSpecialWord).HtmlEscape(objInstance.Title)
                        s title = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRinstance.InstanceData","Title",title,langid)
                        s createDate = $zd(objInstance.CreateDate,3)
                        s createTime = $zt(objInstance.CreateTime)
                        s HISFormatCreateDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",createDate)
                        s HISFormatCreateTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",createTime)
                        s creator = ##class(EMRservice.BL.BLPowerUser).GetUserName(objInstance.CreateUser)
                        s creator = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("User.SSUser","SSUSRName",creator,langid)
                        ///主管医师接口：入院医生        [AdmDoctor]         PA_Adm.PAAdm_AdmDocCodeDR ->
                        s Hospital = ##class(EMRservice.HISInterface.PatientInfoAssist).HospitalName(AEpisodeID)
                        s tmpAdmDoctor=##Class(EMRservice.HISInterface.PatientInfoAssist).AdmDoctor(AEpisodeID,Hospital)
                        s admDocDesc = $P(tmpAdmDoctor,"^",3)
                        s log = ##Class(EMRservice.BL.BLEMRLogs).GetLogStatus(AEpisodeID,docId,num)
                        //病历目前最新状态status的操作者operator
                        s operator = $p(log,"^",4)
                        s operator = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("User.SSUser","SSUSRName",operator,langid)
                        s status = $p(log,"^",11)
                        //最后一次有效签名信息
                        s (SignDate,SignTime,SignUserName) = ""
                        s Signarray = ##Class(EMRservice.BL.BLEMRSign).GetLastSignInfo(rowId)
                        s:Signarray.GetAt("SignDate")'="" SignDate = $zd(Signarray.GetAt("SignDate"),3)
                        s HISFormatSignDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",SignDate)
                        s:Signarray.GetAt("SignTime")'="" SignTime = $zt(Signarray.GetAt("SignTime"))
                        s HISFormatSignTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",SignTime)
                        s:Signarray.GetAt("UserID")'="" SignUserName = $p($g(^SSU("SSUSR",Signarray.GetAt("UserID"))),"^",2)
                        s SignUserName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("User.SSUser","SSUSRName",SignUserName,langid)
                        //病历是否签名
                        s hasSign = ##Class(EMRservice.BL.BLTemplateSign).HasRecordSign(AEpisodeID,docId,num)
                        s:(($p(log,"^",10)="finished")||($p(log,"^",10)="checkedRevision")) hasSign = "0"
                        //维护不显示待签
                        ;s:(isWaitsign = "1") hasSign = "1"
                        //维护没有签名单元
                        s hasSignUnit = $O(^DHCEMRM.TemplateSignConfigI("IndexTIDHasSign"," "_$zcvt(objInstance.RealTemplateID,"U"),objInstance.TemplateVersion,""))
                        s hasSignUnit = $replace(hasSignUnit," ","")
                        s:(hasSignUnit = "0") hasSign = "1"
                        //病历是否打印过
                        s hasPrinted = ##class(EMRservice.BL.BLEMRLogs).RecHasAction(AEpisodeID,rowId,"print")
                        s docCount = docCount + 1
                        if (leadFrame '= "0"){
                            s:(hasSign = "0") signFlag = "0"
                            s:(hasPrinted '= "1") prinFlag = "0"
                            s:(docCountByDocId = 0) docCountByDocId = ##Class(EMRservice.BL.BLInstanceData).getInstanceCount(rowId,"SAVE")
                            s tempJson = ""
                            d:(docCountByDocId = docCount) DocIdList
                        }else{
                            d RecordList
                        }
                        d objInstance.%Close()
                        k objInstance
                        s tempJson = $ZSTRIP(tempJson,"*C")
                        continue:(tempJson = "")
                        d:(docJson.Size > 0) docJson.Write(",")
                        d docJson.Write(tempJson)
                        s count = count + 1
                    }
                }
            }
            d objEcrecod.%Close()
            k objEcrecod
            if (leadFrame '= "0"){
                d objEMRTemplateCategoryDoc.%Close()
                k objEMRTemplateCategoryDoc
        }
        }
        if (docJson.Size > 0){
            d:(categoryJson.Size > 0) categoryJson.Write(",")
            d CategoryList
            s tempJson = $ZSTRIP(tempJson,"*C")
            d categoryJson.Write(tempJson)
            s count = count + 1
            d categoryJson.Write(",")
            d categoryJson.CopyFrom(docJson)
        }
    }
    d json.Write("{""total"":"""_count_""",""rows"":[")
    d:(categoryJson.Size > 0) json.CopyFrom(categoryJson)
    d json.Write("]}")
    q json
DocIdList
    s printQuality = ""
    if (##class(%Dictionary.CompiledMethod).%ExistsId("EMRservice.HISInterface.QualityInterface||QualityInterfaceCheckBatch") '= 0){
	    s printQuality = ##class(EMRservice.HISInterface.QualityInterface).QualityInterfaceCheckBatch(AEpisodeID,"Print",docId)
	    if ($p(printQuality,"^",1) = "-1"){
	        s printQuality = $p(printQuality,"^",2)
	    	s printQuality = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(printQuality)
	    }else{
		    s printQuality = ""
		}
    }
    s tempJson = "{"
    s tempJson = tempJson_"""id"":"""_$replace(rowId,"||","-")_""""
    s tempJson = tempJson_",""instanceId"":"""_rowId_""""
    s tempJson = tempJson_",""text"":"""_docIdTitle_""""
    s tempJson = tempJson_",""hasSign"":"""_signFlag_""""
    s tempJson = tempJson_",""hasPrinted"":"""_prinFlag_""""
    s tempJson = tempJson_",""pluginType"":"""_pluginType_""""
    s tempJson = tempJson_",""chartItemType"":"""_chartItemType_""""
    s tempJson = tempJson_",""emrDocId"":"""_docId_""""
    s tempJson = tempJson_",""isLeadframe"":"""_leadFrame_""""
    s tempJson = tempJson_",""nodeType"":""instance"""
    s tempJson = tempJson_",""_parentId"":"""_categoryId_""""
    s tempJson = tempJson_",""printQuality"":"""_printQuality_""""
    s tempJson = tempJson_"}"
    q
RecordList
    s printQuality = ""
    if (##class(%Dictionary.CompiledMethod).%ExistsId("EMRservice.HISInterface.QualityInterface||QualityInterfaceCheckBatch") '= 0){
	    s printQuality = ##class(EMRservice.HISInterface.QualityInterface).QualityInterfaceCheckBatch(AEpisodeID,"Print",docId)
	    if ($p(printQuality,"^",1) = "-1"){
	        s printQuality = $p(printQuality,"^",2)
	    	s printQuality = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(printQuality)
	    }else{
		    s printQuality = ""
		}
    }
    s tempJson = "{"
    s tempJson = tempJson_"""id"":"""_$replace(rowId,"||","-")_""""
    s tempJson = tempJson_",""instanceId"":"""_rowId_""""
    s tempJson = tempJson_",""text"":"""_title_""""
    s tempJson = tempJson_",""creator"":"""_creator_""""
    s tempJson = tempJson_",""createDate"":"""_HISFormatCreateDate_""""
    s tempJson = tempJson_",""createTime"":"""_HISFormatCreateTime_""""
    s tempJson = tempJson_",""admDocDesc"":"""_admDocDesc_""""
    s tempJson = tempJson_",""operator"":"""_operator_""""
    s tempJson = tempJson_",""status"":"""_status_""""
    s tempJson = tempJson_",""signer"":"""_SignUserName_""""
    s tempJson = tempJson_",""signDate"":"""_HISFormatSignDate_""""
    s tempJson = tempJson_",""signTime"":"""_HISFormatSignTime_""""
    s tempJson = tempJson_",""hasSign"":"""_hasSign_""""
    s tempJson = tempJson_",""hasPrinted"":"""_hasPrinted_""""
    s tempJson = tempJson_",""pluginType"":"""_pluginType_""""
    s tempJson = tempJson_",""chartItemType"":"""_chartItemType_""""
    s tempJson = tempJson_",""emrDocId"":"""_docId_""""
    s tempJson = tempJson_",""isLeadframe"":"""_leadFrame_""""
    s tempJson = tempJson_",""nodeType"":""instance"""
    s tempJson = tempJson_",""_parentId"":"""_categoryId_""""
    s tempJson = tempJson_",""printQuality"":"""_printQuality_""""
    s tempJson = tempJson_"}"
    q
CategoryList
    s tempJson = "{"
    s tempJson = tempJson_"""id"":"""_categoryId_""""
    s tempJson = tempJson_",""text"":"""_categoryTitle_""""
    s tempJson = tempJson_",""nodeType"":""category"""
    s tempJson = tempJson_"}"
    q
}

/// Desc:       将模板按照用户使用频率排序
/// Creator:    yejian
/// CreateDate: 2021-9-14	
/// Input:      ADocIDs docid集合以"^"分隔
/// 			AUserID 用户ID
/// Output:     resultID String
/// Debug:      w ##Class(EMRservice.BL.BLClientCategory).SortDocIDByFrequency("306^308^58^317^318^319^60^62^","10209")
ClassMethod SortDocIDByFrequency(ADocIDs As %String, AUserID As %String) As %String
{
	s strRes=""
	s key = $i(^CacheTemp("GetTemplateDocIDSeq"))
	for i=1:1:$l(ADocIDs,"^")
	{
		s docId = $p(ADocIDs,"^",i)
		continue:(docId = "")
		s frequency = $o(^DHCEMRI.TemplateFrequencyI("IdxDocUserFreq"," "_docId," "_AUserID,""))
		s:(frequency = "") frequency = 0
		s ^CacheTemp("GetTemplateDocIDSeq",key,frequency,i) = docId
	}
	s docSeq = ""
	for
	{
		s docSeq = $o(^CacheTemp("GetTemplateDocIDSeq",key,docSeq),-1)
		q:(docSeq = "")
		s Iseq = ""
		for
		{
			s Iseq = $o(^CacheTemp("GetTemplateDocIDSeq",key,docSeq,Iseq))
			q:(Iseq = "")
			s nDocID = ^CacheTemp("GetTemplateDocIDSeq",key,docSeq,Iseq)
			s strRes = $case(strRes,"":nDocID,:strRes_"^"_nDocID)
		}
	}
	k ^CacheTemp("GetTemplateDocIDSeq",key)
	q strRes
}

/// Desc:      判断目录展现结构下被打印病历的数量（打印后未修改病历,若修改会导致病历签名失效,此时打印也算失效 --- 北京妇产）
/// Input:     ACategoryID 目录ID
///            AEpisodeID 就诊号
/// Output:    打印病历的数量
/// Debug:     w ##Class(EMRservice.BL.BLClientCategory).GetPrintedRecordCount(3,456449)
ClassMethod GetPrintedRecordCount(ACategoryID As %String, AEpisodeID As %String) As %String
{
    s count = 0
    s docIds = ..GetDocIdsByParent(ACategoryID)
    q:(docIds="") count
    
    s length = $l(docIds,",")
    for I=1:1:length
    {
        s docId = $p(docIds,",",I)
        s rowId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID,docId,""))
        continue:(rowId = "")
        s date = ""
        for
        {
            s date = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",rowId," SAVE",date))
            q:(date = "")
            s time = ""
            for
            {
                s time = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",rowId," SAVE",date,time))    
                q:(time = "")
                s subId = ""
                for
                {
                    s subId = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",rowId," SAVE",date,time,subId))         
                    q:(subId = "")
                    s instanceId = rowId_"||"_subId
                    s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(instanceId)
                    q:(objInstance = "")
                    s num = objInstance.ListNo
                    s log = ##Class(EMRservice.BL.BLEMRLogs).GetLogStatus(AEpisodeID,docId,num)
                    q:(log = "")
                    S:($P(log,"^",8) = "print") count = count + 1        
                }
            }
        }
    }   
    q count
}

/// Desc:       根据DocID获取病历模板
/// DateTime:   2021-11-19
/// Input:      ADocID  目录展现结构DocID
///             AInstanceID 病案首页采集页病历实例ID
/// OutPut:     json   
/// Debug:      w ##Class(EMRservice.BL.BLClientCategory).GetTempCateJsonByDocID(52,"1||1")
ClassMethod GetTempCateJsonByDocID(ADocID As %String, AInstanceID As %String) As %GlobalCharacterStream
{
    s json = ##Class(%GlobalCharacterStream).%New()
    q:(ADocID = "")||(AInstanceID = "") json
    Set langid=20
    if ($d(%session)){
        set langid=+$g(%session.Data("LOGON.LANGID"))
    }
    s objdoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(ADocID)
    q:(objdoc = "") json
    s objchapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objdoc.ParentCategoryID)
    q:(objchapter = "") json
    s objcategory = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objchapter.ParentCategoryID)
    q:(objcategory = "") json
    s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(ADocID)
    q:(objTemplate = "") json
    s objEMRTemplateCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(ADocID)
    s EMRChartItemType = ##class(EMRservice.EMRDoc.DocCategoryFunSet).GetChapterDocType(objEMRTemplateCategoryDoc.ParentCategoryID)
    s title = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.EMRTemplateCategory","CategoryName",objchapter.CategoryName,langid)
    s docidText = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.EMRTemplateCategory","CategoryName",objdoc.CategoryName,langid)
    s templateId = objTemplate.ID, templateVersion = objTemplate.PublishVersion
    s printUseLastVersion = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("PrintUseLastVersion","N")
    if (printUseLastVersion = "N"){
        //病案首页采集页是否打印过
        s printRowID = ""
        for{
            s printRowID = $o(^DHCEMRI.InstancePrintRecordI("IdxInstanceDataID"," "_AInstanceID,printRowID))
            q:(printRowID = "")
            s objInstancePrint = ##class(EMRinstance.InstancePrintRecord).%OpenId(printRowID)
            q:(objInstancePrint = "")
            continue:(templateId '= objInstancePrint.PrintTemplateID)
            s templateVersion = objInstancePrint.PrintTemplateVersion
            q
        }
    }
    d DisplayInList 
    s cjson = $ZSTRIP(cjson,"*C")
    d json.Write(cjson)
    q json
DisplayInList
    s cjson = "{"
    s cjson = cjson_ """id"":"""""
    s cjson = cjson_ ",""text"":"""_$s(((EMRChartItemType="Multiple")&&(objdoc.IsLeadframe=0)):docidText,1:title)_""""
    s cjson = cjson_ ",""pluginType"":"""_objTemplate.DocumentType_"""" 
    s cjson = cjson_ ",""chartItemType"":"""_objTemplate.ChartItemType_""""
    s cjson = cjson_ ",""emrDocId"":"""_ADocID_""""
    s cjson = cjson_ ",""templateId"":"""_templateId_""""
    s cjson = cjson_ ",""templateVersion"":"""_templateVersion_""""
    s cjson = cjson_ ",""isLeadframe"":"""_objdoc.IsLeadframe_""""
    s cjson = cjson_ ",""isMutex"":"""_objchapter.IsMutex_""""
    s cjson = cjson_ ",""categoryId"":"""_objdoc.ParentCategoryID_""""
    s cjson = cjson_ ",""actionType"":""CREATE"""
    s cjson = cjson_ ",""status"":""NORMAL"""
    s cjson = cjson_ ",""closable"":""False"""
    s cjson = cjson_ "}"
    q
}

/// Desc:       根据就诊号和DocID获取病案首页采集页数据
/// DateTime:   2021-11-19
/// Input:      ADocID      目录展现结构DocID
///             AEpisodeID  就诊号
/// OutPut:     json   
/// Debug:      w ##Class(EMRservice.BL.BLClientCategory).GetParamJsonByDocID(246,4)
ClassMethod GetParamJsonByDocID(ADocID As %String, AEpisodeID As %String) As %GlobalCharacterStream
{
    s json = ##Class(%GlobalCharacterStream).%New()
    q:((ADocID = "")||(AEpisodeID = "")) json
    s ECRecordID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID,ADocID,""))
    q:(ECRecordID = "") json
    s date = ""
    for {
        s date = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ECRecordID," SAVE",date))
        q:(date = "")
        s time = ""
        for {
            s time = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ECRecordID," SAVE",date,time))
            q:(time = "")
            s instanceSubID = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ECRecordID," SAVE",date,time,""))  
            q:(instanceSubID = "")
            s instanceID = ECRecordID_"||"_instanceSubID
            q:(instanceID = "")
            s param = ##Class(EMRservice.BL.BLInstanceData).getInstanceDataByInsID(instanceID)
            s param = $ZSTRIP(param,"*C")
            d json.Write(param)
            q
        }
    }
    q json
}

/// Desc:       根据实例ID获取打开病历参数
/// DateTime:   2022-12-14
/// Input:      AInstanceID 实例ID
/// OutPut:     json   
/// Debug:      w ##Class(EMRservice.BL.BLClientCategory).GetRecodeParamByInsID("53||1")
ClassMethod GetRecodeParamByInsID(AInstanceID As %String) As %String
{
	s ret=""
	q:(AInstanceID = "") ret
	
	s InstanceData = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(InstanceData = "") ret
	s ECrecordID = $p(AInstanceID,"||",1)
	q:(ECrecordID = "") ret

	s TemplateID = InstanceData.RealTemplateID
	q:(TemplateID = "") ret
	s TemplateData = ##Class(EMRmeta.Template).%OpenId(TemplateID)
	q:(TemplateData = "") ret
	
	s ECRecordData = ##Class(EMRinstance.ECRecord).%OpenId(ECrecordID)
	q:(ECRecordData = "") ret
	s categoryId = ECRecordData.RealChartItemID
	s chapterdata = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(categoryId)
	q:(chapterdata = "") ret
	s cate = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(chapterdata.ParentCategoryID)
	q:(cate = "") ret
	s characteristic = ECRecordData.DocumentCharacteristic
	s epsiodeId = ECRecordData.RealEpisodeID
	//指定病历实例是否有对应患者签名后的PDF文档
    s pdfStatus = ##Class(EMRservice.BL.BLPDFAuditSignLog).GetPDFStatus(AInstanceID, epsiodeId)
    s pdfDocType = $Case($zcvt(pdfStatus,"U"),"SIGNED":"PDF",:"XML")

	s ret = "{""id"":"""_AInstanceID_""",""actionType"":""LOAD"",""categoryId"":"""_cate.ParentCategoryID_""","
	s ret = ret_"""chartItemType"":"""_TemplateData.ChartItemType_""",""closable"":true,"
	s ret = ret_"""emrDocId"":"""_categoryId_""",""isLeadframe"":"""_chapterdata.IsLeadframe_""","
	s ret = ret_"""isMutex"":"""_cate.IsMutex_""",""pluginType"":"""_TemplateData.DocumentType_""","
	s ret = ret_"""characteristic"":"""_characteristic_""",""pdfDocType"":"""_pdfDocType_""","
	s ret = ret_"""status"":""NORMAL"",""templateId"":"""_TemplateID_""",""text"":"""_InstanceData.Title_"""}"
	q ret
}

}
