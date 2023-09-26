/// Desc:个人模板
/// Creator:Candy
/// CreateDate:2019-2-16
Class EMRservice.BL.PersonalTemplate Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       范例病例目录树
/// Creator:    Candy
/// CreateDate: 2018-4-8
/// Input:      argUserID 用户ID
/// Output:     目录流数据
/// Debug:      w ##Class(EMRservice.BL.PersonalTemplate).GetDataTree(10209,"219||1").Read(32000)
ClassMethod GetDataTree(argUserID As %String, argInstanceID As %String, argUserLocID As %String = "") As %GlobalCharacterStream
{
	s result = ##class(%GlobalCharacterStream).%New()
	q:(argUserID = "")||(argInstanceID = "") result
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") result
	s docId = objInstance.TheECRecord.RealChartItemID
	s objEmrTempalteDoc = ##class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
	q:(objEmrTempalteDoc = "") result
	s text = objEmrTempalteDoc.CategoryName
	s objUser = ##class(User.SSUser).%OpenId(argUserID)
	s userName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("User.SSUser","SSUSRName",objUser.SSUSRName,langid)
	s text = userName_##class(EMRservice.HISInterface.Translation).Get("EMRTrans","个人模板")
	
	s result = ..GetDataTreeJson(argUserID,docId,text,argUserLocID)
	q result
}

ClassMethod GetDataTreeJson(argUserID As %String, docId As %String, text As %String, argUserLocID As %String = "") As %GlobalCharacterStream
{
	s result = ##class(%GlobalCharacterStream).%New()
	d result.Write("[")
	d result.Write("{")
	d result.Write("""id"":"""_-docId_"""")
	d result.Write(",""text"":"""_text_"""")
	d result.Write(",""state"":""opened""")
	d result.Write(",""iconCls"":""""")
	d result.Write(",""attributes"":{""type"":""root""}")
	d result.Write(",""children"":[")
	s cateData = ..GetCategoryData(argUserID,-docId,argUserLocID)
	d:(cateData.Size >0) result.CopyFrom(cateData)
	s examples = ..GetExampleData(argUserID,-docId)
	d:(cateData.Size >0)&&(examples.Size >0) result.Write(",")
	d:(examples.Size >0) result.CopyFrom(examples)
	d result.Write("]}")
	d result.Write("]")
	q result
}

/// Desc:      获取所有模板的个人模板，在前端展示，用于用户维护   
/// Input:     argEpisodeID 就诊ID
///            argUserLocID 用户所在科室ID
///            argUserID 用户ID
///            argSsgroup 用户所在安全组ID
/// Debug:     w ##Class(EMRservice.BL.PersonalTemplate).GetPersonalTemplates(4634,684,7,28)
ClassMethod GetAllDataTree(argEpisodeID As %String, argUserLocID As %String, argUserID As %String, argSsgroup As %String) As %Stream
{
    s result = ##class(%GlobalCharacterStream).%New()
    q:(argUserID = "")||(argEpisodeID = "")||(argUserLocID = "")||(argSsgroup = "") "[]"
    
    s arrTemplate = ##Class(EMRservice.BL.BLOPClientCategory).GetTemplateLst(argUserLocID,argSsgroup,argEpisodeID,argUserID)
    s personalList = ##class(%GlobalCharacterStream).%New()
    Set langid=20
    if ($d(%session)){
        set langid=+$g(%session.Data("LOGON.LANGID"))
    }
       
    s tmpList = ##class(%GlobalCharacterStream).%New()
    s cateData = ..GetCategoryData(argUserID,"0",argUserLocID)
	d:(cateData.Size >0) tmpList.CopyFrom(cateData)
	s examples = ..GetExampleData(argUserID,"0")
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
        
        s cateData = ..GetCategoryData(argUserID,-curEMRCateId,argUserLocID)
		d:(cateData.Size >0) tmpList.CopyFrom(cateData)
		s examples = ..GetExampleData(argUserID,-curEMRCateId)
		d:(cateData.Size >0)&&(examples.Size >0) tmpList.Write(",")
        d tmpList.CopyFrom(examples)
        
        s categoryName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.EMRTemplateCategory","CategoryName",chapter.CategoryName,langid)
        s DociDName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.EMRTemplateCategory","CategoryName",TempCate.CategoryName,langid)
        
        d:(personalList.Size>0)&&(tmpList.Size>0) personalList.Write(",")
        d personalList.CopyFrom(tmpList)
    }
	
	s objUser = ##class(User.SSUser).%OpenId(argUserID,0)
	s userName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("User.SSUser","SSUSRName",objUser.SSUSRName,langid)
    s persontext = userName_##class(EMRservice.HISInterface.Translation).Get("EMRTrans","个人模板")
    
    d result.Write("[{")
    d result.Write("""id"":""0""")
    d result.Write(",""text"":"""_persontext_"""")
    d result.Write(",""state"":""opened""")
    d result.Write(",""attributes"":{""type"":""root""}")
    d result.Write(",""children"":[")   
    d result.CopyFrom(personalList) 
    d result.Write("]}]")
 
    q result
}

/// Desc:       取目录分类数据
/// Creator:    Candy
/// CreateDate: 2018-4-8
/// Input:      argUserID 用户ID
///             argParentID 父节点
/// Output:     目录流数据
/// Debug:      w ##Class(EMRservice.BL.PersonalTemplate).GetCategoryData(10209,102).Read(32000)
ClassMethod GetCategoryData(argUserID As %String, argParentID As %String, argUserLocID As %String = "", argEpisodeID As %String = "", argSearchText As %String = "", argType As %String = "") As %GlobalCharacterStream
{
	s result = ##class(%GlobalCharacterStream).%New() 
	s seq = ""
	for
	{
		s seq = $o(^DHCEMRM.ExamInsCategoryI("ParentSeqence",argParentID,seq))
		q:(seq = "")
		s rowId = ""
		for
		{
			s rowId = $o(^DHCEMRM.ExamInsCategoryI("ParentSeqence",argParentID,seq,rowId))
			q:(rowId = "")
            //个人模板根目录时，parentID存储为DocID，当目录ID与DocID一致时，会出现死循环现象，在此进行过滤
			//continue:(argParentID = rowId)
			s obj = ##Class(EMRmeta.ExampleInstanceCategory).%OpenId(rowId)
			continue:(obj = "")
			s isShare = "0"
            continue:(argUserID '= obj.UserID)
            s Collapse = ##Class(EMRservice.SystemParameter).SetPersonalTemplateCollapse()
            if (Collapse = "2")
            {
	            s CollapseState = "closed"
	        }
	        else
	        {
		        s CollapseState = "open"
		    }
            //子节点为0时，如果设置state为open，图标会显示异常
            s child = ..GetCategoryData(argUserID,rowId,argUserLocID,argEpisodeID,argSearchText,argType)
			s examples = ..GetExampleData(argUserID,rowId,argEpisodeID,argSearchText)
            if (child.Size = 0)&&(examples.Size = 0)
            {
                s CollapseState = "closed"
            }
            
			d:(result.Size > 0) result.Write(",")
			d result.Write("{")	
			///前端treegrid加载时，目录ID与节点ID一致，导致加载异常，目录ID前拼接PersonalCate区分
            if (argType = "LIST") {
                d result.Write("""id"":""PersonalCate"_rowId_"""")
            } else {
                d result.Write("""id"":"""_rowId_"""")
            }
			d result.Write(",""text"":"""_obj.Name_"""")
			d result.Write(",""type"":""PersonalCate""")
			d result.Write(",""DocIDText"":"""_obj.Name_"""")
			d result.Write(",""state"":"""_CollapseState_"""")
			d result.Write(",""attributes"":{""type"":""category""")
			d result.Write(",""parentID"":"""_argParentID_"""")
			d result.Write(",""isShare"":"""_isShare_"""")
			d result.Write(",""py"":"""_obj.JianpinName_"""}")
			d result.Write(",""children"":[")
			d:(child.Size >0) result.CopyFrom(child)
			d:(child.Size >0)&&(examples.Size >0) result.Write(",")
			d:(examples.Size >0) result.CopyFrom(examples)
			d result.Write("]")	
			d result.Write("}")	
		}
	}
	q result
}

/// Desc:       取范例数据
/// Creator:    Candy
/// CreateDate: 2018-4-8
/// Input:      argCategoryID 分类ID
/// Output:     目录流数据
ClassMethod GetExampleData(argUserID As %String, argCategoryID As %String, argEpisodeID As %String = "", argSearchText As %String = "") As %GlobalCharacterStream
{
	s result = ##class(%GlobalCharacterStream).%New()
	q:(argCategoryID = "")
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	s seq = ""
	for
	{
		s seq = $o(^DHCEMRM.ExampleInstanceI("CategorySeqence",argCategoryID,seq))
		q:(seq = "")
		s rowId = ""
		for
		{
			s rowId = $o(^DHCEMRM.ExampleInstanceI("CategorySeqence",argCategoryID,seq,rowId))
			q:(rowId = "")
			s obj = ##Class(EMRmeta.ExampleInstance).%OpenId(rowId)
			continue:(obj = "")
			continue:(obj.UserID '= argUserID)
			s exampleName =  ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.ExampleInstance","Name",obj.Name,langid)
			s exampleName = ##class(EMRservice.Util.EscapeSpecialWord).JsonEscape(exampleName)
			s isShare = "0"
			
			s titleCode = ""
			if ((obj.ChartItemType = "Multiple")&&(obj.DocumentCharacteristic = "1"))
			{
				s titleCode = obj.TitleCode
				if (argEpisodeID '= "")
				{
					s isUniqueCreate = ##Class(EMRservice.BL.BLClientCategory).IsTitleUniqueCreate(titleCode,argEpisodeID) 
					continue:(isUniqueCreate = "1")
				}
			}
			
			if (argSearchText '= "")
			{
				s FullFight=##class(EMRservice.Tools.Tool).GetCNCODE(exampleName,3,"")
				s JaneSpell=##class(EMRservice.Tools.Tool).GetCNCODE(exampleName,4,"")
				continue:(($find(exampleName,argSearchText) = 0)&&($find(JaneSpell,argSearchText) = 0)&&($find(FullFight,argSearchText) = 0)) 
			}  
			
			s objdoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(obj.EMRDocID)
        	continue:(objdoc = "")
			s objchapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objdoc.ParentCategoryID)
			continue:(objchapter = "")
			s objcategory = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objchapter.ParentCategoryID)
			continue:(objcategory = "")
			s collect = ##Class(EMRservice.BL.BLCollectTemplate).GetIsCollect(argUserID,rowId)
			d:(result.Size > 0) result.Write(",")
			d result.Write("{")
			d result.Write("""id"":"""_rowId_"""")
			d result.Write(",""text"":"""_exampleName_"""")
			d result.Write(",""isCollect"":"""_collect_"""")
			d result.Write(",""DocIDText"":"""_exampleName_"""")
			d result.Write(",""iconCls"":""icon-person""")
			d result.Write(",""attributes"":{""type"":""node""")
			d result.Write(",""templateId"":"""_obj.TemplateID_"""")
			d result.Write(",""nodeType"":""personal""")
			d result.Write(",""emrdocId"":"""_obj.EMRDocID_"""")
			d result.Write(",""emrcategoryId"":"""_obj.EMRCategoryID_"""")
			d result.Write(",""documentType"":"""_obj.DocumentType_"""")
			d result.Write(",""chartItemType"":"""_obj.ChartItemType_"""")
			d result.Write(",""isLeadframe"":"""_objdoc.IsLeadframe_"""")
			d result.Write(",""isMutex"":"""_objchapter.IsMutex_"""")
			d result.Write(",""docCharacteristic"":"""_obj.DocumentCharacteristic_"""")
			d result.Write(",""titleCode"":"""_titleCode_"""")
			d result.Write(",""isShare"":"""_isShare_"""")
			d result.Write(",""py"":"""_obj.JianpinName_"""}")
			d result.Write("}")
		}
	}
	q result
}

/// Desc:       添加目录
/// Creator:    Candy
/// CreateDate: 2018-4-8
/// Input:      argUserID 用户ID
///             argParentID 父目录ID
///             argName 目录名称
/// Output:     成功返回ID ,失败返回空 
/// Debug:      w ##Ckass(EMRservice.BL.PersonalTemplate).AddCategory(4133,0,"范例病历1","12||1")
ClassMethod AddCategory(argUserID As %String, argParentID As %String, argName As %String, argInstanceID As %String) As %String
{
	s result = ""
	q:(argUserID = "")||(argParentID = "")||(argName = "")||(argInstanceID = "") result
    
    //如果是docID,则parentID存为负数
	//s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	//q:(objInstance = "") result
	//s docId = objInstance.TheECRecord.RealChartItemID
	//s:(argParentID = docId) argParentID = -argParentID
    
	s obj = ##Class(EMRmeta.ExampleInstanceCategory).%New()
	s obj.Name = argName
	s obj.JianpinName = ##class(web.DHCINSUPort).GetCNCODE($tr(argName," ",""),4,"")
	s obj.ParentID = argParentID
	s obj.UserID = argUserID
	s obj.Seqence = $case($d(^DHCEMRM.ExamInsCategoryD),0:1,:^DHCEMRM.ExamInsCategoryD+1)
	s obj.Status = 1
	s obj.CreateDate = $p($h,",",1)
	s obj.CreateTime = $p($h,",",2)
	s sc = obj.%Save()
	s:($$$ISOK(sc)) result = obj.%Id()
	q result
}

/// Desc:       修改名称
/// Creator:    Candy
/// CreateDate: 2018-4-19
/// Input:      argRowID rowId
///             argName  修改名称
///             argAction 修改类型
/// Output:     成功返回1 ,失败返回空
ClassMethod ReName(argRowID As %String, argName As %String, argAction As %String) As %String
{
	s result = ""
	q:(argRowID = "")||(argName = "")||(argAction = "") result
	if (argAction = "category")
	{
		s obj = ##Class(EMRmeta.ExampleInstanceCategory).%OpenId(argRowID)
		q:(obj = "")
		s obj.Name = argName
	}
	else
	{
		s obj = ##Class(EMRmeta.ExampleInstance).%OpenId(argRowID)
		q:(obj = "")
		s obj.Name = argName
	}
	s sc = obj.%Save()
	s:($$$ISOK(sc)) result = "1"
	q result
}

/// Desc:       删除数据
/// Creator:    Candy
/// CreateDate: 2018-4-19
/// Input:      argRowID rowId
///             argAction 修改类型
/// Output:     成功返回1 ,失败返回空
ClassMethod DeleteData(argRowID As %String, argAction As %String) As %String
{
	s result = ""
	q:(argRowID = "")||(argAction = "") result
	if (argAction = "category")
	{
		s sc = ##Class(EMRmeta.ExampleInstanceCategory).%DeleteId(argRowID)
		s:($$$ISOK(sc)) result = 1
		q result
	}
	else
	{
		s flag = 1
		TStart
		s sc = ##Class(EMRmeta.ExampleInstance).%DeleteId(argRowID)
		if ($$$ISOK(sc))
		{
			s rowId = ""
			for
			{
				s rowId = $o(^DHCEMRM.ExamInsSectionI("ExampleID",argRowID,rowId))
				q:(rowId = "")
				s sesc =  ##Class(EMRmeta.ExampleInstanceSection).%DeleteId(rowId)
				s:($$$ISERR(sesc)) flag = 0
				q:(flag = 0)
			}
		}
		if (flag = 0)
		{
			Trollback
			q result
		}
		else
		{
			s result = 1
		}
		Tcommit:(result = 1)
	}
	q result
}

/// Desc:       排序交换节点
/// Creator:    Candy
/// CreateDate: 2018-4-19
/// Input:      argRowID1 rowId1
///             argRowID2 rowId2
///             argAction 修改类型
/// Output:     成功返回1 ,失败返回空
/// Debug:      w ##Class(EMRservice.BL.PersonalTemplate).SwapSequence(1,2,"category")
ClassMethod SwapSequence(argRowID1 As %String, argRowID2 As %String, argAction As %String) As %String
{
	s result = ""
	q:(argRowID1 = "")||(argRowID2 = "") result
 	if (argAction = "category") 
 	{
		s obj1 = ##class(EMRmeta.ExampleInstanceCategory).%OpenId(argRowID1)
		s obj2 = ##class(EMRmeta.ExampleInstanceCategory).%OpenId(argRowID2)		
	}
	else 
 	{
		s obj1 = ##class(EMRmeta.ExampleInstance).%OpenId(argRowID1)
		s obj2 = ##class(EMRmeta.ExampleInstance).%OpenId(argRowID2)	 	
	}
	q:((obj1 = "")||(obj2 = "")) result
	 
	s tempSequence = obj1.Seqence
	s obj1.Seqence = obj2.Seqence
	s obj2.Seqence = tempSequence
	
	s $zt = "SwapErrorHandler"
	Tstart
	s scResult = obj1.%Save()
	if $$$ISERR(scResult)
	{
		Trollback
		q result
	}
	s scResultSele = obj2.%Save() 
	if $$$ISERR(scResultSele)
	{
		Trollback
		q result
	}
	
	TCOMMIT
			    
	do obj1.%Close()
	do obj2.%Close()
	
	s result = 1
	q result
	

SwapErrorHandler
	Trollback
	q $zerror
}

/// Desc:       更改节点/目录的上级目录
/// CreateDate: 2019-7-19
/// Input:      argRowID1
///             argRowID2
///             argAction 修改类型(目录传入category、节点传入node)
/// Output:     成功返回1 ,失败返回空
/// Debug:      w ##Class(EMRservice.BL.PersonalTemplate).UpdateCategoryID(1,2,"category")
ClassMethod UpdateCategoryID(argRowID1 As %String, argRowID2 As %String, argAction As %String) As %String
{
	s result = ""
	q:(argRowID1 = "")||(argRowID2 = "") result
 	if (argAction = "category") 
 	{
		s obj1 = ##class(EMRmeta.ExampleInstanceCategory).%OpenId(argRowID1)
		q:(obj1 = "") result
		s obj1.ParentID = argRowID2
	}
	else 
 	{
		s obj1 = ##class(EMRmeta.ExampleInstance).%OpenId(argRowID1)
		q:(obj1 = "") result
		s obj1.CategoryID = argRowID2	
	}

	s $zt = "SwapErrorHandler"
	Tstart
	s scResult = obj1.%Save()
	if $$$ISERR(scResult)
	{
		Trollback
		q result
	}

	TCOMMIT
			    
	do obj1.%Close()
	s result = 1
	q result
	

SwapErrorHandler
	Trollback
	q $zerror
}

/// Desc:       分享为科室模板
/// Input:      argRowID rowId
/// Output:     成功返回1 ,失败返回-1
/// w ##class(EMRservice.BL.PersonalTemplate).Share(13,6)
ClassMethod Share(argRowID As %String, argCtLocID, argTitleCode As %String = "", argGroupID As %String = "") As %String
{
	s $zt = "ShareError"
	
	s result = "-1"
	q:(argRowID = "") "-1^获取个人模板ID为空"
	q:(argCtLocID = "") "-1^获取当前登录科室ID为空"

	s obj = ##Class(EMRmeta.ExampleInstance).%OpenId(argRowID)
	q:(obj = "") result

	s templateID = obj.TemplateID
	q:(templateID = "") "-1^获取个人模板对应的基础模板ID为空"
	s templateobj = ##Class(EMRmeta.Template).%OpenId(templateID)
	q:(templateobj = "") "-1^获取基础模板信息失败"
	s publishVersion = templateobj.PublishVersion
	q:(publishVersion="") "-1^获取基础模板已发布版本号失败"
	
	Tstart
	//创建科室模板主表数据
	s newobj = ##Class(EMRmeta.UserTemplate).%New()
	s newobj.Name = obj.Name
	s newobj.Code = "NULL"
	s newobj.AuditID = ""
	s newobj.AuditDate = ""
	s newobj.Sequence = "0"
	d newobj.TemplateData.Write()
	s newobj.SimpleSpelName = obj.JianpinName
	s newobj.TemplateID = templateID
	s newobj.UserID = obj.UserID
	s newobj.CreateDate = $zd($P($H,",",1),3)_" "_$zt($P($H,",",2),1)
	s newobj.Status = "2"  //申请审核状态
	s newobj.Type = "1"    //科室模板，0为全院模板
	s newobj.Remark = "个人模板分享为科室模板，待审核，个人模板ID为"_argRowID
	s newobj.VersionNumber = publishVersion
	s sc = newobj.%Save()
	
	if $$$ISERR(sc)
	{
		//Trollback
		q "-1^新建科室模板数据失败"
	}
	
	//修改科室模板主表数据中的code与sequence和ID一致
	s UserTemplateID = newobj.%Id()
	s UserTemplateobj = ##Class(EMRmeta.UserTemplate).%OpenId(UserTemplateID)
	s UserTemplateobj.Code = UserTemplateID
	s UserTemplateobj.Sequence = UserTemplateID
	s sc2 = UserTemplateobj.%Save()
	if $$$ISERR(sc2)
	{
		Trollback
		q "-1^修改科室模板数据失败"
	}
	
	//循环创建科室模板章节信息表数据
	s ExaSectionID = ""
    s CopySectionResult = "1"
    s CopySectionRelaResult = "1"
	for
	{
		s ExaSectionID = $o(^DHCEMRM.ExamInsSectionI("ExampleID",argRowID,ExaSectionID))
		q:(ExaSectionID = "")
		s CopySectionResult = ..CopySection(ExaSectionID,UserTemplateID)
		s CopySectionRelaResult = ..CopySectionRelation(ExaSectionID,UserTemplateID)
		if (CopySectionResult '= "1")||(CopySectionRelaResult '= "1")
		{
			q
		}
	}
	if (CopySectionResult '= "1")||(CopySectionRelaResult '= "1")
	{
		Trollback
		q "-1^新建科室模板章节数据失败"
	}
	
	//创建科室模板科室关联表数据
	s ctobj = ##Class(EMRmeta.UserTemplateCTLoc).%New()
	s ctobj.Code = UserTemplateID
	s ctobj.CTLocID = argCtLocID
	s ctobj.CTLocName = $p($g(^CTLOC(argCtLocID)),"^",2)
	s ctsc = ctobj.%Save()
	if $$$ISERR(ctsc)
	{
		Trollback
		q "-1^新建科室模板关联科室数据失败"
	}
	
	s shareLocID = obj.ShareLocID	
	s:(shareLocID '= "") shareLocID = shareLocID_"^"
	s obj.ShareLocID = shareLocID_argCtLocID
	s sharesc = obj.%Save()
	if $$$ISERR(sharesc)
	{
		Trollback
		q "-1^存储分享到科室ID(shareLocID)数据失败"
	}
	
	if (argTitleCode '= "")
	{
		//创建用户模板标题关联表数据
		s titleObj = ##Class(EMRmeta.UserTemplateTitle).%New()
		s titleObj.Code = UserTemplateID
		s titleObj.TitleCode = argTitleCode
		s titleID = $o(^DHCEMRM.TitlesI("IdxCode"," "_argTitleCode,""))
		if (titleID = "")
		{
			Trollback
			q "-1^新建用户模板标题关联表数据失败"
		}
		s objTitles = ##class(EMRmeta.Titles).%OpenId(titleID)
		s titleObj.TitleName = objTitles.Description
		s titlesc = titleObj.%Save()
		if $$$ISERR(titlesc)
		{
			Trollback
			q "-1^新建用户模板标题关联表数据失败"
		}
	}

    if (argGroupID '= ""){
        s groupItemObj = ##Class(EMRmeta.UserTemplateGroupItem).%New()
        s groupItemObj.Code = UserTemplateID
        s groupItemObj.GroupID = argGroupID
        s groupItemsc = groupItemObj.%Save()
        if $$$ISERR(groupItemsc)
        {
            Trollback
            q "-1^新建科室模板分组子项表数据失败"
        }
        s groupItemObj.Sequence = groupItemObj.%Id()
        s groupItemsc2 = groupItemObj.%Save()
        if $$$ISERR(groupItemsc2)
        {
            Trollback
            q "-1^修改科室模板分组子项表数据失败"
        }
    }

	TCOMMIT
	s result = "1"
	q result
	
ShareError
	Trollback
	q "-1^"_$zerror
}

/// Desc:       判断此个人模板是否已分享过当前科室的科室模板
/// Input:      argRowID argCtLocID
/// Output:     已分享过1 ,其余返回0
/// w ##class(EMRservice.BL.PersonalTemplate).Share(13,6)
ClassMethod IsShareToLoc(argRowID As %String, argCtLocID) As %String
{
	s result = "0"
	q:(argRowID = "")||(argCtLocID = "") result

	s obj = ##Class(EMRmeta.ExampleInstance).%OpenId(argRowID)
	q:(obj = "") result

	s shareLocID = obj.ShareLocID
	q:(shareLocID = "") "0"
	
	if ($f("^"_shareLocID_"^","^"_argCtLocID_"^")>0)
	{
		s result = "1"
	}
	q result
}

ClassMethod CopySection(argSectionRowID As %String, UserTemplateID As %String) As %String
{
	s $zt = "CopySectionError"
	
	s result = "-1"
	q:(argSectionRowID = "")||(UserTemplateID = "") result
	s sectionobj = ##Class(EMRmeta.ExampleInstanceSection).%OpenId(argSectionRowID)
	q:(sectionobj = "") result
	
	s newsectionobj = ##Class(EMRmeta.UserTemplateSection).%New()
	s newsectionobj.Code = UserTemplateID
	s newsectionobj.SectionCode = sectionobj.SectionCode
	s newsectionobj.ActiveFlag = sectionobj.Status
	d newsectionobj.MetaData.CopyFrom(sectionobj.MetaData)
	d newsectionobj.MediasData.CopyFrom(sectionobj.MediasData)
	d newsectionobj.PresentationData.CopyFrom(sectionobj.PresentationData)
	d newsectionobj.ScriptData.CopyFrom(sectionobj.ScriptData)
	d newsectionobj.InitialData.CopyFrom(sectionobj.InitialData)
	
	s scsectionsc = newsectionobj.%Save()

	s:($$$ISOK(scsectionsc)) result = "1"
	q result
	
CopySectionError
	q result
}

ClassMethod CopySectionRelation(argSectionRowID As %String, UserTemplateID As %String) As %String
{
	s $zt = "CopySectioRelnError"
	
	s result = "-1"
	q:(argSectionRowID = "")||(UserTemplateID = "") result
	
	s persionSectionObj = ##class(EMRmeta.ExampleInstanceSection).%OpenId(argSectionRowID)
	q:(persionSectionObj = "") result
	
	s PersonTempID = persionSectionObj.ExampleID
	s sectionCode = persionSectionObj.SectionCode
	q:(PersonTempID = "")||(sectionCode = "") result
	
	s PersonTempSecRelationID = $O(^DHCEMRM.ExampleInsSecRelationI("IdxExampleIDSection"," "_PersonTempID," "_sectionCode,""))
	q:(PersonTempSecRelationID = "") result

	s PersonTempSecRelationObj = ##class(EMRmeta.ExampleInsSecRelation).%OpenId(PersonTempSecRelationID)
	q:(PersonTempSecRelationObj = "") result
	
	s newsectionrelaobj = ##Class(EMRmeta.UserTemplateSectionRelation).%New()
	s newsectionrelaobj.TemplateID= PersonTempSecRelationObj.TemplateID
	s newsectionrelaobj.Code = UserTemplateID
	s newsectionrelaobj.Name = PersonTempSecRelationObj.Name
	s newsectionrelaobj.SectionCode = PersonTempSecRelationObj.SectionCode
	s newsectionrelaobj.SectionName = PersonTempSecRelationObj.SectionName
	s newsectionrelaobj.Status = PersonTempSecRelationObj.Status	
	s scsectionrelasc = newsectionrelaobj.%Save()

	s:($$$ISOK(scsectionrelasc)) result = "1"
	q result
	
CopySectioRelnError
	q result
}

/// Desc:		取章节结点
/// Input:		AUserTemplateCode: 用户模板ID
///             ATitleCode: 标题代码
/// OutPut:     Node xml流数据
ClassMethod GetBindSection(APersonalTemplateID As %String, ATitleCode As %String, ByRef OutStream As %GlobalBinaryStream) As %String
{
	s result = ""
	q:(APersonalTemplateID = "") result
	s result = 1
	s relationSectionCode = ""
	for
	{
		s relationSectionCode = $o(^DHCEMRM.ExampleInsSecRelationI("IdxStatusSection"," "_APersonalTemplateID, " REPLACE", " "_relationSectionCode))
		s relationSectionCode = $tr(relationSectionCode," ","")
		q:(relationSectionCode = "")

		s rowId = $o(^DHCEMRM.ExamInsSectionI("ExampleIDSectionCode",APersonalTemplateID," "_relationSectionCode,""))
		q:(rowId = "")
		s obj = ##Class(EMRmeta.ExampleInstanceSection).%OpenId(rowId)
		q:(obj = "")
		s setionCode = obj.SectionCode
		s tmpStream = ##Class(%GlobalBinaryStream).%New()
		s status = ..GetNodeXML(rowId,tmpStream)
		continue:(status '= 1)
		d:(OutStream.Size > 0) OutStream.Write("-----------------------------7da4a26140fde")
		d OutStream.Write("{""SectionCode"":"""_setionCode_"""}$$")
		d OutStream.CopyFrom(tmpStream)
	}
	q result
}

/// Desc:       取知识内容xml
/// Creator:    yejian
/// CreateDate: 2014-01-19
/// Input:      ANodeID 知识库ID
/// OutPut:     OutSection 知识库节点xml            
ClassMethod GetNodeXML(AID As %String, ByRef OutSection As %GlobalBinaryStream) As %String
{
	s result = "-1"
	q:(AID = "") result
	s objSection = ##Class(EMRmeta.ExampleInstanceSection).%OpenId(AID)
	q:(objSection = "") result
	d OutSection.Write("<?xml version=""1.0"" encoding=""UTF-8""?>")
	d OutSection.Write("<Template>")
	  d OutSection.Write("<Macros>")
	  d OutSection.Write("<Macro/>")
	  d OutSection.Write("</Macros>")
      d OutSection.Write("<StructuredBody>")
	    d OutSection.CopyFrom(objSection.MetaData)
	    d OutSection.CopyFrom(objSection.ScriptData)
	    d OutSection.CopyFrom(objSection.MediasData)
	    d OutSection.CopyFrom(objSection.InitialData)
        d OutSection.CopyFrom(objSection.ScatterData)
	    d OutSection.CopyFrom(objSection.PresentationData)
	    d OutSection.Write("</StructuredBody>")
	d OutSection.Write("</Template>") 
	q 1
}

/// Desc:		得到xml文档
/// Input:		AInstanceIDs: 实例数据ID,多个以"#"分隔
///             {"params":{"action":"LOAD_DOCUMENT", "InstanceID":"160202"},"type":"action"}
///             AOutRecords: 返回xml 
/// OutPut:     result: 返回1保存成功, -1保存失败
/// Debug:      d ##Class(EMRservice.BL.PersonalTemplate).LoadDocument()
ClassMethod LoadDocument(ByRef AOutRecords As %GlobalBinaryStream, AExampleInstanceID As %ListOfDataTypes, AOutMessage As %GlobalBinaryStream) As %String
{
	s $zt = "loadpersonal"
    s result = "-1"		
    q:(AExampleInstanceID = "") result
	s obj = ##Class(EMRmeta.ExampleInstance).%OpenId(AExampleInstanceID)
	q:(obj = "") result
	
	s TemplateID = obj.TemplateID
	q:(TemplateID = "") result
	s templateobj = ##Class(EMRmeta.Template).%OpenId(TemplateID)
	q:(templateobj = "") result
	s publishVersion = templateobj.PublishVersion
	q:(publishVersion = "") result
	
	d AOutRecords.CopyFrom(##class(EMRservice.BL.BLInstanceData).GetNewDocByTemplateID(TemplateID,publishVersion))
	d AOutMessage.Write("[]")
	s result = "1"
	q result
	
loadpersonal
	q result
}

/// Desc:       范例病例目录树
/// Creator:    Donglulu
/// CreateDate: 2021-8-13
/// Input:      argUserID 用户ID
/// Output:     目录流数据
/// Debug:      w ##Class(EMRservice.BL.PersonalTemplate).GetDataTreeByDocID(10209,"58").Read(32000)
ClassMethod GetDataTreeByDocID(argUserID As %String, argDocID As %String, argUserLocID As %String, argEpisodeID As %String = "") As %GlobalCharacterStream
{
	s result = ##class(%GlobalCharacterStream).%New()
	q:(argUserID = "")||(argDocID = "")||(argEpisodeID = "") result
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	s objEmrTempalteDoc = ##class(EMRmeta.EMRTemplateCategory).%OpenId(argDocID)
	q:(objEmrTempalteDoc = "") result
	s text = objEmrTempalteDoc.CategoryName
	s objUser = ##class(User.SSUser).%OpenId(argUserID)
	s userName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("User.SSUser","SSUSRName",objUser.SSUSRName,langid)
	s text = userName_##class(EMRservice.HISInterface.Translation).Get("EMRTrans","个人模板")
    s Collapse = ##Class(EMRservice.SystemParameter).SetPersonalTemplateCollapse()
    if (Collapse = "3")
    {
        s CollapseState = "closed"
    }
    else
    {
        s CollapseState = "open"
    }
	
	d result.Write("[")
	d result.Write("{")
	d result.Write("""id"":"""_-argDocID_"""")
	d result.Write(",""text"":"""_text_"""")
	d result.Write(",""state"":"""_CollapseState_"""")
	d result.Write(",""iconCls"":""""")
	d result.Write(",""attributes"":{""type"":""root""}")
	d result.Write(",""children"":[")
	s cateData = ..GetCategoryData(argUserID,-argDocID,argUserLocID,argEpisodeID)
	d:(cateData.Size >0) result.CopyFrom(cateData)
	s examples = ..GetExampleData(argUserID,-argDocID,argEpisodeID)
	d:(cateData.Size >0)&&(examples.Size >0) result.Write(",")
	d:(examples.Size >0) result.CopyFrom(examples)
	d result.Write("]}")
	d result.Write("]")
	//d result.OutputToDevice()
	q result
}

/// Desc:       获取范例的DocumentType
/// Creator:    Donglulu
/// CreateDate: 2021-8-18
/// Input:      argExampleID
/// Output:     范例的具体信息
/// Debug:      w ##Class(EMRservice.BL.PersonalTemplate).GetDocumentType("")
ClassMethod GetExampleInfo(argExampleID As %String) As %String
{
	s result = ""
	q:(argExampleID = "") result
	s obj = ##Class(EMRmeta.ExampleInstance).%OpenId(argExampleID)
	q:(obj = "") result
	s result = result_"{"
	s result = result_"""Name"":"""_obj.Name_""""
	s result = result_",""DocumentType"":"""_obj.DocumentType_"""" 
	s result = result_"}"
	q result
}

/// Desc:       获取病案首页的categoryID
/// Creator:    Donglulu
/// CreateDate: 2021-8-20
/// Input:      
/// Output:     病案首页的categoryID
/// Debug:      w ##Class(EMRservice.BL.PersonalTemplate).GetMedRecordCategoryID()
ClassMethod GetMedRecordCategoryID() As %String
{
	s result = ""
	s docIDs = ##Class(EMRservice.SystemParameter).GetMedicalRecordDocID()
	s docID = $p(docIDs,"^",1)
	q:(docID = "") result
	s objDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docID)
	q:(objDoc = "") result
	s tempcateID = objDoc.ParentCategoryID
	q:(tempcateID = "") result
	s objTempcate = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(tempcateID)
	q:(objTempcate = "") result
	s result = objTempcate.ParentCategoryID
	q result
}

/// Desc:       是否配置个人模板
/// Creator:    Donglulu
/// CreateDate: 2021-11-12
/// Input:      ALocID 科室ID 
///             ATemplateID 基础模板ID
/// Output:     1,0
/// Debug       w ##Class(EMRservice.BL.PersonalTemplate).HasPersonalTemplate(10209,66)
ClassMethod HasPersonalTemplate(AUserID As %String, ADocID As %String) As %String
{
	s result = 0
	q:(AUserID = "")||(ADocID = "") result
	
	s rowId = $o(^DHCEMRM.ExampleInstanceI("IdxUserIDDocID"," "_AUserID," "_ADocID,""))
	q:(rowId = "") result
	s result = 1
	q result
}

/// Desc:       取默认加载标题的默认排序第一的个人模板ID及信息
/// Creator:    DongLulu
/// CreateDate: 2021-11-16
/// Input:      argTitleCode 默认加载的TitleCode
/// Output:     个人模板ID及信息
/// Debug       w ##Class(EMRservice.BL.PersonalTemplate).GetFirstPersonalByTitle("EMR100001",16983,66)
ClassMethod GetFirstPersonalByTitle(argTitleCode As %String, argUserID As %String, argDocID As %String) As %String
{
	s result = ""
	q:((argTitleCode = "")||(argUserID = "")||(argDocID = "")) result
	
	s titleCode = $zcvt(argTitleCode,"U")
	s titleID = $o(^DHCEMRM.TitlesI("IdxCode"," "_titleCode,""))
	q:(titleID = "") result
	s obj = ##Class(EMRmeta.Titles).%OpenId(titleID)
	q:(obj = "") result
	s name = obj.Description
	q:(name = "") result
	
	s date = $zd($p($h,",",1),3)
	s time = $zt($p($h,",",2))
	s dateTime = date_" "_time
	s rowId = ""
	s flag = "0"
	s seq = ""
	for
	{
		s seq = $o(^DHCEMRM.ExampleInstanceI("IdxUserIDDocIDSeq"," "_argUserID," "_argDocID,seq))
		q:(seq = "")
		s rowId = ""
		for
		{
			s rowId = $o(^DHCEMRM.ExampleInstanceI("IdxUserIDDocIDSeq"," "_argUserID," "_argDocID,seq,rowId))
			q:(rowId = "")
			s obj = ##Class(EMRmeta.ExampleInstance).%OpenId(rowId)
			continue:(obj = "")
			s exampleName = obj.Name
			
			s instanceID = obj.InstanceID
			continue:(instanceID = "")
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(instanceID)
			continue:(objInstance = "")
			s titleCode = objInstance.TitleCode
			continue:($zcvt(titleCode,"U") '= $zcvt(argTitleCode,"U"))
			s flag = "1"
			q
			
		}
		q:(flag = "1")
	}
	q:(rowId = "") result
	s result = "{"
	s result=result_"""exampleId"":"""_rowId_""""
	s result=result_",""titleCode"":"""_argTitleCode_""""
	s result=result_",""titleName"":"""_name_""""
	s result=result_",""dateTime"":"""_dateTime_""""
	s result=result_"}"
	q result
}

/// d ##class(EMRservice.BL.PersonalTemplate).updateParentDocID()
ClassMethod updateParentDocID() As %String
{
	s $zt = "error"
	s docIDs = ","_##Class(EMRservice.BL.BLClientCategory).GetDocIdsByParent(0)_","
	s updateData = ""
	s ID = ""
	for
	{
		s ID = $O(^DHCEMRM.ExamInsCategoryD(ID))
		q:(ID = "")
		s obj = ##Class(EMRmeta.ExampleInstanceCategory).%OpenId(ID)
		continue:(obj = "")
		s parentID = obj.ParentID
		
		//如果parentID与DocID一致，修改数据
		if ($F(docIDs, ","_parentID_",") > 0)
		{
			s obj.ParentID = -parentID
			s sc = obj.%Save()
			if $$$ISERR(sc)
			{
				w "ID:"_ID_"更新失败，请手工处理"
			}
			else
			{
				s:(updateData '= "") updateData = updateData_","
				s updateData = updateData_ID
			}
		}
	}
   	
   	if (updateData '= "") 
   	{
		w "修改数据ID为："_updateData
   	}
   	else
   	{
		w "未检查到错误数据"   	
	}
	q

error
	w "方法执行异常："_$zstrip($zerror,"*C")
}

/// Desc:       之前的程序。个人模板在根目录下创建时，CategoryID为根目录ID(DocID)，在自定义目录下创建时，CategoryID为实际目录ID(EMRmeta.ExampleInstanceCategory表ID)
///             当数据超出一定数量后，DocID与实际目录ID重合导致数据异常
///             修改代码逻辑，根目录时，CategoryID存为负的DocID，与实际的目录ID区分
///             此方法处理历史数据，判断CategoryID与DocID一致时，并且这条数据的USerID与目录表的USerID不一致，则认为此节点应在根目录下，修改CategoryID为负数
/// Creator:    yb
/// CreateDate: 2022-11-4
/// Output:     修改的数据ID
/// Debug:      d ##class(EMRservice.BL.PersonalTemplate).updateCategoryIDData()
/// 
ClassMethod updateCategoryIDData() As %String
{
	s $zt = "error"
	s docIDs = ","_##Class(EMRservice.BL.BLClientCategory).GetDocIdsByParent(0)_","
	s updateData = ""
	s ID = ""
	for
	{
		s ID = $O(^DHCEMRM.ExampleInstanceD(ID))
		q:(ID = "")
		s obj = ##Class(EMRmeta.ExampleInstance).%OpenId(ID)
		continue:(obj = "")
		s categoryID = obj.CategoryID
		s userID = obj.UserID
		
		//如果parentID与DocID一致，修改数据
		if ($F(docIDs, ","_categoryID_",") > 0)
		{
			s cateUserID = ""
			//判断这条数据的USerID与目录表的USerID是否一致
			s cateObj = ##Class(EMRmeta.ExampleInstanceCategory).%OpenId(categoryID)
			s:(cateObj '= "") cateUserID = cateObj.UserID
			if (cateUserID '= "")
			{
				continue:(userID = cateUserID)	
			}
			
			s obj.CategoryID = -categoryID
			s sc = obj.%Save()
			if $$$ISERR(sc)
			{
				w "ID:"_ID_"更新失败，请手工处理"
			}
			else
			{
				s:(updateData '= "") updateData = updateData_","
				s updateData = updateData_ID
			}
		}
	}
   	
   	if (updateData '= "") 
   	{
		w "修改数据ID为："_updateData
   	}
   	else
   	{
		w "未检查到错误数据"   	
	}
	q

error
	w "方法执行异常："_$zstrip($zerror,"*C")
}

/// Desc:       在EMRmeta.ExampleInstance表中添加TitleCode字段处理，旧数据需要迁移
/// CreateDate: 2021-12-27
/// Input:      argType 迁移方式,默认为1,建议先迁移后清空病历实例数据(表EMRInstance.InstanceData)
///             "1":以病历实例数据(表EMRInstance.InstanceData)未清空为前提;
///             "2":清空病历实例数据(表EMRInstance.InstanceData)后,用该方法补数据,需注意：一个模板关联多个标题时，以下程序赋值的titlecode 会存在错误，需要针对该模板id手工对照titlecode
/// Output:     1:成功;0:不成功;
/// Debug       w ##Class(EMRservice.BL.PersonalTemplate).saveTitleCode()
ClassMethod saveTitleCode(argType As %String = "1") As %String
{
	s result = "1"
	s argCategoryID = ""
	for
	{
		s argCategoryID = $o(^DHCEMRM.ExampleInstanceI("CategorySeqence",argCategoryID))
		q:(argCategoryID = "")
		s seq = ""
		for
		{
			s seq = $o(^DHCEMRM.ExampleInstanceI("CategorySeqence",argCategoryID,seq))
			q:(seq = "")
			s rowId = ""
			for
			{
				s rowId = $o(^DHCEMRM.ExampleInstanceI("CategorySeqence",argCategoryID,seq,rowId))
				q:(rowId = "")
				s obj = ##Class(EMRmeta.ExampleInstance).%OpenId(rowId)
				continue:(obj = "")
				
                //未清空实例之前用该方式补数据
                if (argType = "1")
				{
					s objInstance = ##class(EMRinstance.InstanceData).%OpenId(obj.InstanceID)
					s obj.TitleCode = objInstance.TitleCode
					s sc = obj.%Save()
                    s:($$$ISERR(sc)) result = "0"
				}else
				{
                    //清空实例后用以下方法补数据
					//**注释：一个模板关联多个标题时，以下程序赋值的titlecode 会存在错误，需要针对该模板id手工对照titlecode
                    //例如：日常病程是同一个模板书写的不同病程，需要手工核对
					s EMRTemplateRowID = ""
					for
					{
						
						s EMRTemplateRowID = $o(^DHCEMRM.EMRTemplateI("IdxBindTemplateID"," "_obj.TemplateID,EMRTemplateRowID))
						q:(EMRTemplateRowID = "")
						s objEmrTempalteCategory = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(obj.EMRDocID)
						q:(objEmrTempalteCategory = "")
						s CategoryID = objEmrTempalteCategory.ParentCategoryID
						q:(CategoryID = "")
						s sequence = ""
						for
						{ 
							s sequence = $o(^DHCEMRM.TitleConfigI("IdxCategorySequence"," "_CategoryID,sequence))
							q:(sequence = "")
							s TitleConfigRowID = ""
							for
							{
								s TitleConfigRowID = $o(^DHCEMRM.TitleConfigI("IdxCategorySequence"," "_CategoryID,sequence,TitleConfigRowID))
								q:(TitleConfigRowID = "")
								s objTitleConfig = ##Class(EMRmeta.TitleConfig).%OpenId(TitleConfigRowID)
								q:(objTitleConfig = "")
								continue:(EMRTemplateRowID '= objTitleConfig.TemplateID)
								
								s obj.TitleCode = objTitleConfig.TitleCode
								s sc = obj.%Save()
                                s:($$$ISERR(sc)) result = "0"
                                q:(result = "0")
                            }
                            q:(result = "0")
                        }
                        q:(result = "0")
                    }
                }
                q:(result = "0")
            }
            q:(result = "0")
        }
        q:(result = "0")
    }
    q result
}

/// Desc:       取目录分类数据列表视图下
/// Creator:    Donglulu
/// CreateDate: 2018-8-10
/// Input:      argUserID 用户ID
///             argParentID 父节点
/// Output:     目录流数据
/// Debug:      w ##Class(EMRservice.BL.PersonalTemplate).GetCategoryDataForList("18881","3","191","61","123").Read(32000)
ClassMethod GetCategoryDataForList(argUserID As %String, argParentID As %String, argUserLocID As %String = "", argEpisodeID As %String, argSearchText As %String) As %GlobalCharacterStream
{
	s result = ##class(%GlobalCharacterStream).%New() 
	
	s priActivity = ##Class(EMRservice.BL.BLClientCategory).CheckTPrivActivity()  //权限控制
	s curPatInfo = ##class(EMRservice.DocRestLogic.PrivLogic).GetPatInfo(argEpisodeID,argUserID)
	s patDept = $p($li(curPatInfo,2),$c(2),2)
	s strdocIds = ##Class(EMRservice.BL.BLClientCategory).GetDocByCategoryID(argParentID,argEpisodeID,argUserID,priActivity,curPatInfo)
	q:((argParentID = "")||(argEpisodeID = "")) result
	d result.Write("[")
	s mutexdoc = $p(strdocIds,"&",1)
	s nomutexdoc = $p(strdocIds,"&",2)
	s iswrited = ##class(EMRservice.BL.BLInstanceData).IsHasInstanceByDocIDs(argEpisodeID,mutexdoc)
	if (iswrited = "1")
	{
	 	s strdocIds = nomutexdoc
	}
	else
	{
		s strdocIds = mutexdoc_"^"_nomutexdoc
	}
	for i=1:1:$l(strdocIds,"^")
	{
		s argDocID = $p(strdocIds,"^",i)
		continue:(argDocID = "")
		
		Set langid=20
		if ($d(%session)){
			set langid=+$g(%session.Data("LOGON.LANGID"))
		}
		s objEmrTempalteDoc = ##class(EMRmeta.EMRTemplateCategory).%OpenId(argDocID)
		q:(objEmrTempalteDoc = "")
		s text = objEmrTempalteDoc.CategoryName
		s objUser = ##class(User.SSUser).%OpenId(argUserID)
		s userName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("User.SSUser","SSUSRName",objUser.SSUSRName,langid)
		s text = userName_##class(EMRservice.HISInterface.Translation).Get("EMRTrans","个人模板")
	    s Collapse = ##Class(EMRservice.SystemParameter).SetPersonalTemplateCollapse()
	    if (Collapse = "3")
	    {
	        s CollapseState = "closed"
	    }
	    else
	    {
	        s CollapseState = "open"
	    }
	    s tmpList = ##class(%GlobalCharacterStream).%New()
		s cateData = ..GetCategoryData(argUserID,-argDocID,argUserLocID,argEpisodeID,argSearchText,"LIST")
		d tmpList.CopyFrom(cateData)
		s examples = ..GetExampleData(argUserID,-argDocID,argEpisodeID,argSearchText)
		d:((cateData.Size >0)&&(examples.Size >0)) tmpList.Write(",")
		d tmpList.CopyFrom(examples)
		continue:(tmpList.Size = 0)
		d:(result.Size >1) result.Write(",")
		d result.CopyFrom(tmpList)
	}
	
	d result.Write("]")

	q result
}

}
