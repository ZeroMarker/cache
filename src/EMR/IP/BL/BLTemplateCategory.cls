/// 名称:	EMR.IP.BL.BLTemplateCategory
/// 描述:	门诊病历 文档目录业务类
/// 编写者：yejian(lifengbo)
/// 编写日期: 2021-7-27
/// 产品组：电子病历产品组
Class EMR.IP.BL.BLTemplateCategory Extends EMR.IP.COM.ActionBase
{

/// Desc:       获取业务活动记录ID集合
/// Creator:    yejian(lifengbo)
/// CreateDate: 2021-7-30
/// Input:      dtoItem 病历导航入参对象
/// 			aPatInfo 患者信息对象
/// OutPut:     成功 返回1，
/// 			失败 -1^失败提示信息
/// 			argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.IP.BL.BLTemplateCategory).GetRecordsByPid()
ClassMethod GetRecordsByPid(dtoItem As EMR.IP.DTO.DocCategory) As %DynamicArray
{
	s jsonCate = ##class(%DynamicArray).%New()
	s objBdmcCat = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(dtoItem.ParentID)
	q:(objBdmcCat="") jsonCate
	s rowTemCID = ""
	for {
		s rowTemCID = $o(^CF.EMR.DOC.TemplateCategoryI("IdxParentID"," "_dtoItem.ParentID,rowTemCID))
		q:(rowTemCID = "")		
		s objTemCat = ##Class(CF.EMR.DOC.TemplateCategory).%OpenId(rowTemCID)
	    continue:((objTemCat="")||(objTemCat.StructType="")||(objTemCat.StructType.Code'="Record"))
	    continue:(dtoItem.DOCCode'="")&&(dtoItem.DOCCode'=objTemCat.Code)
	    s jsonItem  = ##class(%DynamicObject).%New()
	    s jsonItem.ID = rowTemCID
	    s jsonItem.Code = objTemCat.Code
	    s iswrited = ##class(EMR.DOC.BL.DocumentData).IsHasInstanceByBDMCode(dtoItem.EpisodeID,objTemCat.Code)
	    continue:(objTemCat.Title.IsMutex=1)&&(iswrited=1)
		s jsonItem.isMutex=$case(objTemCat.Title.IsMutex,"1":objTemCat.Title.IsMutex,:"0")
		s jsonItem.isLeadframe = $case(objTemCat.Title.IsLeadframe,"1":objTemCat.Title.IsLeadframe,:"0")
		s jsonItem.serial = $case(objTemCat.Title.Serial,"1":objTemCat.Title.Serial,:"0")
	    s jsonItem.type = "Record"
	    s jsonItem.docCategoryCode = objBdmcCat.Code
	    s jsonItem.docCategoryName = objBdmcCat.EMRName
	    s jsonItem.text = objTemCat.EMRName
	    s jsonItem.quotation="0" //##Class(EMRservice.BL.BLQuotation).GetDocQuationFlag(patDept,docId) 
		s jsonItem.JaneSpell = objTemCat.Alias
		s jsonItem.FullFight = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(objTemCat.EMRName,3,"")
		d jsonCate.%Push(jsonItem)	
	}
	q jsonCate
}

/// Desc:       根据业务活动记录获取文档ID集合
/// Creator:    yejian
/// CreateDate: 2021-7-30
/// Input:      dtoItem 病历导航入参对象
/// 			arrRecordIds 业务活动记录JSON数组
/// OutPut:     成功 返回1，
/// 			失败 -1^失败提示信息
/// 			argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.OP.BL.Template).GetTemIDByRecordID("YS01","TEMPLATE",.argOutData)
ClassMethod GetTemIDByRecordID(dtoItem As EMR.IP.DTO.DocCategory, arrRecordIds As %DynamicArray) As %DynamicArray
{
	s jsonTemplate = ##class(%DynamicArray).%New()
	
	set iter = arrRecordIds.%GetIterator()
	while iter.%GetNext(.key , .item ) {
        s jsonRecord = item
        continue:(jsonRecord = "")||(jsonRecord.ID="")
		s objTemCat = ##Class(CF.EMR.DOC.TemplateCategory).%OpenId(jsonRecord.ID)
	    continue:(objTemCat="")
	    //如果子节点为模板则ResChildCount不为0
	    if (objTemCat.ResChildCount=0)
	    {
		    s strRes = ##class(EMR.IP.BL.BLTemplateCategory).GetJsonCategroyByID(jsonRecord.ID,jsonRecord,"",.jsonTemplate)
	    }
	    else
	    {
		    s strRes = ##Class(EMR.IP.BL.BLTemplate).GetJsonTempalteByCID(jsonRecord.ID,jsonRecord,"",.jsonTemplate)
	    }
	}
	
	q jsonTemplate
}

/// Desc:       递归获取模板目录数据
/// Creator:    yejian(lifengbo)
/// CreateDate: 2020-12-17
/// Input:      aParentId 目录ID
///             aProduct 项目标识
///             aPids 目录id串1^2^3
/// Output:    成功 1，失败 -1 
/// 	Debug:	q ##Class(EMR.IP.BL.BLTemplateCategory).GetJsonCategroyByID(0,1,1,)
ClassMethod GetJsonCategroyByID(aParentId As %String, jsonRecord As %DynamicAbstractObject, ByRef aPids As %String, ByRef jsonTemplate As %DynamicAbstractObject) As %String
{
	s res = "1"
	s strSeq = ""
	s arrCategory = ##CLASS(%DynamicArray).%New()
	for {
		s strSeq = $o(^CF.EMR.DOC.TemplateCategoryI("IdxPidSeq"," "_aParentId,strSeq))
		q:(strSeq = "")	
		s strCId = $o(^CF.EMR.DOC.TemplateCategoryI("IdxPidSeq"," "_aParentId,strSeq,""))
		q:(strCId = "")		
		s objTemCat = ##Class(CF.EMR.DOC.TemplateCategory).%OpenId(strCId)
	    continue:(objTemCat="")
	    
		s aPids = $case(aPids,"":strCId,:(aPids_"^"_strCId))
		//如果子节点为模板则ResChildCount不为0
		if (objTemCat.ResChildCount=0)
		{
			s result = ##Class(EMR.IP.BL.BLTemplateCategory).GetJsonCategroyByID(strCId,jsonRecord,.aPids,.jsonTemplate)
		}
		else
		{
			s result = ##Class(EMR.IP.BL.BLTemplate).GetJsonTempalteByCID(strCId,jsonRecord,.aPids,.jsonTemplate)
			s aPids=""
		}
	}
	q res
}

/// Desc:       获取业务活动记录类型文档目录
/// Creator:    yejian
/// CreateDate: 2022-4-19
/// Input:      objCategory 模板目录对象
/// Output:    成功 目录ID，失败 "-1"
/// 	Debug:	q ##Class(EMR.IP.BL.BLTemplateCategory).GetTemplateRecord()
ClassMethod GetTemplateRecord(objCategory As CF.EMR.DOC.TemplateCategory) As %String
{
	s res = "-1"
	q:(objCategory="") res
	q:(objCategory.StructType.Code ="Record") objCategory.%Id()
	if (objCategory.ParentID'="")
	{
		s objPCategory = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(objCategory.ParentID)
		s res= ##Class(EMR.IP.BL.BLTemplateCategory).GetTemplateRecord(objPCategory)
	}
	q res
}

}
