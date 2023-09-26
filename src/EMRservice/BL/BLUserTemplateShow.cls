Class EMRservice.BL.BLUserTemplateShow Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       取配置前端目录展现病历目录
/// Creator:    yejian
/// CreateDate: 2018-1-12
/// Input:      ACTLocID 用户登录科室
/// Debug       d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLUserTemplateShow","GetCategory",6)
Query GetCategory(ACTLocID As %String, schemType As %String) As %Query(ROWSPEC = "ItemID:%String,ItemTitle:%String,ItemImagePath:%String,ItemCategoryID:%String,ItemURL:%String,ItemParas:%String,ItemType:%String,recordFlag:%String")
{
}

ClassMethod GetCategoryExecute(ByRef qHandle As %Binary, ACTLocID As %String, schemType As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	q:(ACTLocID = "") $$$OK
	s:(schemType="") schemType = "RUNNING"
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
			s locFlag = $d(^DHCEMRM.EMRNavItemLocI("IdxCodeCTLocID"," "_schemType," "_objNavItem.ItemCode," "_ACTLocID))
			s objOrgItem = ##Class(EMRmeta.CTOrganizationSchemeItem).%OpenId(objNavItem.ItemDr)
			continue:(objOrgItem = "")
			s type = ""
			s:(objOrgItem.ItemType '= "") type = objOrgItem.ItemType
			s:(type = "") type = $Case(objOrgItem.EMRTemplateCategoryID,"":"HIS",:"EMR")
			s recordFlag = "0"
			continue:(locFlag <= 0)
			
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

/// Desc:       取配置前端目录展现病历目录
/// Creator:    yejian
/// CreateDate: 2018-1-12
/// Input:      ACTLocID 用户登录科室
/// Debug       d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLUserTemplateShow","GetTempCateJsonByCategoryID",3,10)
Query GetTempCateJsonByCategoryID(AParentID As %String, ACTLocID As %String) As %Query(ROWSPEC = "docId:%String,name:%String,Sequence:%String,TemplateName:%String")
{
}

ClassMethod GetTempCateJsonByCategoryIDExecute(ByRef qHandle As %Binary, AParentID As %String, ACTLocID As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	q:(ACTLocID = "") $$$OK
	s priActivity = ##Class(EMRservice.BL.BLClientCategory).CheckTPrivActivity()  //权限控制	
	s strdocIds = ..GetDocByCategoryID(AParentID,priActivity,ACTLocID)
	q:((AParentID = "")) json
	s mutexdoc = $p(strdocIds,"&",1)
	s nomutexdoc = $p(strdocIds,"&",2)
	s strdocIds = mutexdoc_"^"_nomutexdoc
	
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
		
		s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(docId)
	    continue:(objTemplate = "")
	    
		s name =objchapter.CategoryName
		s Sequence = objchapter.CategorySeq
		s TemplateName = objTemplate.Name
		s data = $lb(docId,name,Sequence,TemplateName)
		s ^CacheTemp(repid,ind) = data
		s ind=ind+1 	
	}			
    Quit $$$OK
}

ClassMethod GetTempCateJsonByCategoryIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTempCateJsonByCategoryIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetTempCateJsonByCategoryIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTempCateJsonByCategoryIDExecute ]
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

/// Desc:      取目录下doc
/// Creator:   yejian
/// CreateDate:2016-11-26
/// Debug:     d ##Class(EMRservice.BL.BLUserTemplateShow).GetDocByCategoryID(3,76,105)
ClassMethod GetDocByCategoryID(AParentID As %String, APriActivity As %String, ACTLocID As %String) As %String
{
	s result = ""
	s mutexdoc = ""
	s nomutexdoc = ""
	q:((AParentID = "")) result
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
			/*
			s curObjDocCategory = ..GetDocIDInChapter(curCategoryId,APriActivity,ACTLocID)
			continue:(curObjDocCategory = "")
			s curDocId = $e(curObjDocCategory.ID,3,$l(curObjDocCategory.ID))  	
			continue:(curDocId = "")
			s curIsMutex = objEMRTemplateCategory.IsMutex
	        s:(curIsMutex '= 1) curIsMutex = 0	
	        if (curIsMutex = 1)
	        {
		        s mutexdoc = mutexdoc_curDocId_"^"
		    }
		    else
		    {
			    s nomutexdoc = nomutexdoc_curDocId_"^"
			}*/
			//获取符号权限的DOCID集合已^分隔		
			s curDocIDS = ..GetDocIDInChapter(curCategoryId,APriActivity,ACTLocID)
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
			        s mutexdoc = mutexdoc_curDocId_"^"
			    }
			    else
			    {
				    s nomutexdoc = nomutexdoc_curDocId_"^"
				}	
			}	
		}
	}
	s result = $e(mutexdoc,1,$l(mutexdoc)-1)_"&"_$e(nomutexdoc,1,$l(nomutexdoc)-1)
	q result
}

/// Creator: yejian
/// CreatDate: 2018-1-16
/// Description：取出ChapterDoc节点下可用的DocID（即可用的TempCate的Doc）
/// 			 在构造病历结构树形时，处理ChapterDoc类型的节点，该类型的节点将被隐藏，其位置由TempCate类型的节点代替
/// Table:
/// Input: EpisodeID--病人就诊号;parOthers--用于扩展的信息串（未用）;parCategoryID--Chapter的ID； parPriActivity--是否开启了模板权限, parPatInfo--病人信息
/// Output:
/// Return: DocID(挂靠界面模板的目录)
ClassMethod GetDocIDInChapter(parCategoryID As %String, parPriActivity As %String, ACTLocID As %String) As %String
{
	 s resultDocID = ""
	 
	 s resultDocID = ..GetDocIDForView(parCategoryID, parPriActivity, ACTLocID)
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

/// Creator:     yejian
/// CreatDate:   2018-1-16
/// Description：处理唯一模板配置规则: 
///              优先取已保存过的打印模板DocID，
///              如果不存在，取当前可用的打印模板DocID
/// Table:
/// Input:       EpisodeID--病人就诊号;parOthers--用于扩展的信息串（未用）;parChapterDocID--Chapter的ID； parPriActivity--是否开启了模板权限, parPatInfo--病人信息
/// Output:
/// Return:      第一个符合规则的DocID(打印模板 或 挂靠界面模板的目录)
ClassMethod GetDocIDForView(parChapterDocID As %String, parPriActivity As %String, ACTLocID As %String) As %String
{
	s resultDocID = ""
	
	//第二优先级: 根据权限规则开启情况，取当前可用的打印模板DocID
	if (parPriActivity = "Y")
	{
		//权限规则开启，取权限规则允许的第一个可用打印模板DocID
		s resultDocID = ..GetTempByCacAndAct(ACTLocID, parChapterDocID, "READ")
	}
	else
	{
		//权限规则关闭，取该Chapter下第一个可用打印模板DocID
		s resultDocID = ..GetAllDocID(parChapterDocID)
	}
	
	q resultDocID
}

/// Creator: yejian
/// CreatDate: 2018-1-16
/// Description：取出某个ChapterID下的第一个适用规则的DocID(打印模板 或 挂靠界面模板的目录)
/// Table:
/// Input: parPatInfo--病人信息列表（如 科室、性别等） ;parChapterID--Chapter的ID； parAction--操作类型，现在只有查看（这个没用）
/// Output:
/// Return:第一个符合规则的DocID(打印模板 或 挂靠界面模板的目录)
ClassMethod GetTempByCacAndAct(ACTLocID As %String, parChapterID As %String, parAction As %String) As %String
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
		 s curDocId = 0
		 s curDocId = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq", curChapterId,curseq, curDocId))
		 WHILE (curDocId '= "") 
		 {
			s curResult = ..CanTempAct(curDocId, parAction, ACTLocID)
			if (curResult = 1)
			{
				s resultDocId = $case(resultDocId,"":curDocId,:resultDocId_"^"_curDocId)
			}
			
	  		s curDocId = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq", curChapterId,curseq, curDocId))
		 }
	 }
	 q resultDocId
}

/// Creator: yejian
/// CreatDate: 2018-1-16
/// Description：取 CategoryChapter 下属第一个DocID的值/// 
/// Table:
/// Input:       argEpisodeID:病人就诊号
///              argCategoryChapterID 病历展现结构第二层节点ID
/// Output:
/// Return:     
ClassMethod GetFirstDocID(argCategoryChapterID As %String) As %String
{
	s curDocID = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID", " "_argCategoryChapterID, ""))
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

/// Creator: yejian
/// CreatDate: 2018-1-16
/// Description：判断某一个DocID(打印模板 或 挂靠界面模板的目录)是否适用于指定的病人
/// Table:
/// Input: parDocID--打印模板 或 挂靠界面模板的目录的ID; parPatInfo--病人信息列表（如 科室、性别等）;  parAction--操作类型，现在只有查看（这个没用）
/// Output:
/// Return: 1--适用  0--不适用
ClassMethod CanTempAct(parDocId As %String, parAction As %String, ACTLocID As %String) As %Status
{
	q:(($d(parDocId)=0) || (parDocId = "")) 0
 	q:(($d(parAction)=0) || (parAction = "")) 0
 	q:(($d(ACTLocID)=0) || (ACTLocID = "")) 0
	s privResult = 0
 	//取出模板所属的规则
 	s strCtLocid = "PATDEPT:"_ACTLocID
 	set argDocID = " "_parDocId
 	set groupID = ""
 	for 
 	{
		set groupID = $o(^DHCEMRM.DocRes.DocsInGroupI("DocIDIdx",argDocID,groupID)) //注：此处取得的 groupID 在左侧含有空格
		q:(groupID="")

		s privResult = 0
		//遍历该模板组下的规则，校验是否有规则适合
		s restrictionId = ""
		s restrictionId = $o(^DHCEMRM.DocRes.DocRestrictionI("GroupIDIdx",groupID,restrictionId))
		WHILE (restrictionId '= "") 
		{
				//取出规则中的条件
	 		s restrictionCondition = $lg(^DHCEMRM.DocRes.DocRestrictionD(restrictionId), 3)
			
			if (restrictionCondition = strCtLocid)
			{
				s privResult = 1
				q
			}
			
	  		s restrictionId = $o(^DHCEMRM.DocRes.DocRestrictionI("GroupIDIdx",groupID,restrictionId))
		}
		q:(privResult =  1)
 	}
 	q privResult
}

/// Desc:       根据标题编码取标题信息
/// Creator:    yejian
/// CreateDate: 2018-7-6
/// Input:      ATiteCode 标题编码
/// Debug: d ##Class(EMRservice.BL.BLUserTemplateShow).GetTitleByCode(4)
ClassMethod GetTitleByCode(ATiteCode As %String) As EMRservice.entity.ETitles
{
	s result = ##Class(EMRservice.entity.ETitles).%New()
	q:(ATiteCode = "") result
	
	s rowId = $o(^DHCEMRM.TitlesI("IdxCode"," "_ATiteCode,""))
	q:(rowId = "") result
	s obj = ##Class(EMRmeta.Titles).%OpenId(rowId)
	q:(obj = "") result
	s result.ID = rowId
	s result.Code = obj.Code
    s result.Alias = obj.Alias
    s result.Description = obj.Description
    q result
}

}
