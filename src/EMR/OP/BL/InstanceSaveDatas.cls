/// 名称:	EMR.OP.BL.InstanceSaveDatas
/// 描述:	门诊病历 文档已生成实例业务逻辑类
/// 编写者：yejian
/// 编写日期: 2021-7-29
/// 产品组：电子病历产品组
Class EMR.OP.BL.InstanceSaveDatas Extends EMR.OP.COM.ActionBase
{

/// Desc:       获取已经保存的病历列表
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		EMR_OP.ECRecord 实例主表，EMR_OP.InstanceData 实例表
/// Input:      argArray  命令参数 {"action":"GET_EMRSAVEDRECORDS","params":{"episodeId":"4","ctlocId":"6","ssgroupId":"28"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetEMRSaveRecords(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s episodeID = argInJson.params.episodeId
	s ctlocId = argInJson.params.ctlocId
	s ssgroupID = argInJson.params.ssgroupId
    s strRes = ##Class(EMR.OP.BL.InstanceSaveDatas).GetEMRSaveRecordsJson(episodeID,ctlocId,ssgroupID,.argOutData)
	//-100 就诊号不能为空  -101 科室ID不能为空  -102 安全组不能为空
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes="-100")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","就诊号不能为空",2)
	}
	elseif(strRes="-100")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","科室ID不能为空",2)
	}
	elseif(strRes="-100")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","安全组不能为空",2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取已经保存的病历列表
/// Creator:    yejian
/// CreateDate: 2021-7-30
/// Input:      dtoInData 实例对象，dtoLog 日志对象
/// OutPut:     成功 返回实例ID，
/// 			失败 -100 就诊号不能为空  -101 科室ID不能为空  -102 安全组不能为空
/// 				argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.OP.BL.InstanceSaveDatas).CreateDocumentJson("YS01","TEMPLATE",.argOutData)
ClassMethod GetEMRSaveRecordsJson(aEpisodeID As %String, aUserLocID As %String, aSSGroupID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes="1"
	q:(aEpisodeID = "") "-100"
	;q:(aUserLocID = "") "-101"
	;q:(aSSGroupID = "") "-102"
	s ArrCate = ##Class(%ArrayOfDataTypes).%New()
	//获取科室和安全组授权的模板列表
	/*
	s retCategory = ##class(%ResultSet).%New("EMRservice.BL.BLClientCategory:GetCategory")
	d retCategory.Execute(AUserLocID, ASSGroupID, AEpisodeID)
	while retCategory.%Next()
	{
		s ItemType = retCategory.Data("ItemType")
		continue:(ItemType = "HIS")
		s categoryId = retCategory.Data("ItemCategoryID")
		d ArrCate.SetAt(categoryId, categoryId)
	}
	*/
	s jsonArr = ##class(%DynamicArray).%New()
	s TILECRecord = ##class(EMR.DAO.ECRecord).GetTureIndexLocation(aEpisodeID)
	s tmpID = ""
	for {
		s tmpID = $O(@TILECRecord@("IdxEpisodeIDTemID"," "_aEpisodeID, tmpID))
		q:(tmpID="")
		s ecRecordID = $O(@TILECRecord@("IdxEpisodeIDTemID"," "_aEpisodeID, tmpID, ""))
		s objECRecord = ##class(EMR.DAO.ECRecord).%OpenId(ecRecordID)
		s count = objECRecord.InstanceCount
		q:(0=count)
		
		s strTmpId = $tr(tmpID," ")
		s objTmp = ##class(CF.EMR.DOC.Template).%OpenId(strTmpId)
		continue:(objTmp = "")
		//判断该模板是否在授权列表中
		//continue:(""=ArrCate.GetAt(cateChapter.ParentCategoryID))
		s objTemCat = objTmp.TemplateCategory
		s categoryName = $case(objTemCat,"":"",:objTemCat.Name)
		;s categoryName = ##Class(EMR.DOC.COM.Translation).GetTranByDesc("CF.EMR.DOC.TemplateCategory","Name",categoryName ,langid)	
		//获取重复模板标识、引导框标识
		s isMultiple = objTmp.ChartItemType
		s isLeadframe = "0"
		s documentType = objTmp.DocumentType.Code
		
		if (("Multiple"=isMultiple) && ("1"=isLeadframe))
		{
			s idx = count
			for 
			{
				q:(idx=0)
				s objInstance = objECRecord.Instances.GetAt(idx)
				if ("Save" = objInstance.Status)
				{
					s jsonItem = ##class(%DynamicObject).%New()
					s jsonItem.id = objInstance.%Id()
					s jsonItem.actionType = "LOAD"
					s jsonItem.categoryId = objTmp.TemplateCategory.%Id()
					s jsonItem.chartItemType = objTmp.ChartItemType
					s jsonItem.closable ="true"
					s jsonItem.isLeadframe =isLeadframe
					s jsonItem.isMutex =isMultiple
					s jsonItem.pluginType = documentType
					s jsonItem.templateId = strTmpId
					s jsonItem.text = categoryName
					d jsonArr.%Push(jsonItem)
					//可重复不换页，有引导窗的模板加载第一个
					q
				}
				s idx = idx - 1
			} 
		}
		else
		{
			s idx = 1
			for 
			{
				q:(idx>count)
				s objInstance = objECRecord.Instances.GetAt(idx)
				if ("Save" = objInstance.Status)
				{
					s jsonItem = ##class(%DynamicObject).%New()
					s jsonItem.id = objInstance.%Id()
					s jsonItem.actionType = "LOAD"
					s jsonItem.categoryId = objTmp.TemplateCategory.%Id()
					s jsonItem.chartItemType = objTmp.ChartItemType
					s jsonItem.closable ="true"
					s jsonItem.isLeadframe =isLeadframe
					s jsonItem.isMutex =isMultiple
					s jsonItem.pluginType = documentType
					s jsonItem.templateId = strTmpId
					s jsonItem.text = categoryName
					d jsonArr.%Push(jsonItem)
				}
				s idx = idx + 1
			} 
		}
	}
	d jsonArr.%ToJSON(argOutData)
	q strRes
}

/// Desc:       获取文档片段目录tree
/// Creator:    yejian
/// CreateDate: 2021-05-06
/// Input:      argUserCode 用户Code
/// Output:     成功：1 失败  -200 aSectionID参数未传 -201 根据kbbaseId未查到数据
/// debug:  q ##Class(EMR.OP.BL.InstanceSaveDatas).GetKBTreeJson("YS01")
ClassMethod GetKBTreeJson(aSectionID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	q:(aSectionID="") "-200"
	s objCat = ##Class(CF.EMR.DOC.KBCategory).%OpenId(aSectionID)
    q:(objCat="") "-201"
	s jsonArr = ##class(%DynamicArray).%New()
	s strRes = "1"
    s jsonCat  = ##class(%DynamicObject).%New()
    s type = ..FormatType(objCat.KBCategoryTypes.Code)
    s jsonCat.key = aSectionID_"||"_type
    s jsonCat.title = objCat.Name
    s jsonCat.type = type
    s jsonCat.description = objCat.Description
	s jsonCategory = ##class(%DynamicArray).%New()
	d ##Class(EMR.OP.BL.KBCategory).GetJsonCategroyByPID(aSectionID,.jsonCategory)
	s:(jsonCategory.%Size()>0) jsonCat.children = jsonCategory
	d jsonArr.%Push(jsonCat)
	d jsonArr.%ToJSON(argOutData)
	q strRes
}

/// Desc:       递归获取业务模型目录数据
/// Creator:    yejian
/// CreateDate: 2021-03-22
/// Input:      aParentId 目录ID
///             jsonCategory 目录json对象
/// Output:     
/// Debug:	q ##Class(EMR.OP.BL.KBCategory).GetJsonCategroyByID(0,1,1,)
ClassMethod GetJsonCategroyByPID(aParentId As %String, ByRef jsonCategory As %DynamicArray)
{
	s res = "1"
	s rowCID = ""
	for {
		s rowCID = $o(^CF.EMR.DOC.KBCategoryI("IdxParentId"," "_aParentId,rowCID))
		q:(rowCID = "")				
		s objCat = ##Class(CF.EMR.DOC.KBCategory).%OpenId(rowCID)
	    continue:(objCat="")
	    s type = ..FormatType(objCat.KBCategoryTypes.Code)
	    s jsonCat  = ##class(%DynamicObject).%New()
	    s jsonCat.key = rowCID_"||"_type
	    s jsonCat.title = objCat.Name
	    s jsonCat.type = type
	    s jsonCat.description = objCat.Description
		s jsonCateNew = ##class(%DynamicArray).%New()
		
		if (($ZCVT(objCat.KBCategoryTypes.Code,"U")="KBTREE")&&(objCat.ResChildCount'=0))
		{
			// 通过KBTRee获取node节点
			s result = ##Class(EMR.OP.BL.KBNode).GetKBNodeJsonByPID(rowCID,.jsonCateNew)
			s:(jsonCateNew.%Size()>0) jsonCat.children = jsonCateNew
		}
		else
		{
			s result = ##Class(EMR.OP.BL.KBCategory).GetJsonCategroyByPID(rowCID,.jsonCateNew)
			s:(jsonCateNew.%Size()>0) jsonCat.children = jsonCateNew	
		}
		d jsonCategory.%Push(jsonCat)	
	}
	q res
}

}
