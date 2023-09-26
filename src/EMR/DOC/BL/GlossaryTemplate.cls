/// 名称:	EMR.DOC.BL.GlossaryTemplate
/// 描述:	通用文档管理模块 Document(Doc) 术语集模板关联业务类
/// 编写者：yejian
/// 编写日期: 2021-1-12
/// 产品组：电子病历产品组
Class EMR.DOC.BL.GlossaryTemplate Extends EMR.DOC.COM.ActionBase
{

/// Desc:       根据内部标识符获取关联模板ID集
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      aInternalID 内部标识符
/// Output:     模板ID集合
/// Debug:		q ##Class(EMR.DOC.BL.GlossaryTemplate).GetTemIDSByInternalID("HDSD00.13.01")
ClassMethod GetTemIDSByInternalID(aInternalID As %String) As %String
{
	s jsonArr = ##class(%DynamicArray).%New()
	q:(aInternalID="") jsonArr
	s templateIndexID = ""
	for
	{
		s templateIndexID = $o(^CF.EMR.DOC.GlossarysTemplateI("IdxInteIDTemID"," "_$ZCVT(aInternalID,"U"),templateIndexID))	
		q:templateIndexID=""
		s glossaryTemplateID =""
		for
		{
			s glossaryTemplateID = $o(^CF.EMR.DOC.GlossarysTemplateI("IdxInteIDTemID"," "_$ZCVT(aInternalID,"U"),templateIndexID,glossaryTemplateID))
			q:glossaryTemplateID=""
			s ObjGlossaryTemplate = ##class(CF.EMR.DOC.GlossarysTemplate).%OpenId(glossaryTemplateID)
			q:ObjGlossaryTemplate=""
			s templateID = ObjGlossaryTemplate.TemplateID
			s ObjTemplate = ##class(CF.EMR.DOC.Template).%OpenId(templateID)
			q:(ObjTemplate="")
			s templateObj = ##class(%DynamicObject).%New()
			s templateObj.key=ObjTemplate.%Id()_"||DT"
			s templateObj.id = ObjTemplate.%Id()
			s templateObj.title = ObjTemplate.Name
			d jsonArr.%Push(templateObj)
		}
	}
	q jsonArr
}

}
