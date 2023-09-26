/// 名称:EMR.DOC.COM.Template
/// 描述:通用文档管理模块 Document(Doc) 公用程序层 Template维护业务类
/// 编写者：Guozongtao@mediway.cn
/// 编写日期: 2020-07-08
/// 产品组：电子病历产品组
Class EMR.DOC.COM.Template Extends %RegisteredObject
{

/// Creator：      Guozongtao@mediway.cn
/// CreatDate：    2020-07-08
/// Description:   Template 增加
/// Table：        CT_EMR_DOC.Template
/// Input：        
/// Output         对输出参数的说明
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug:         w ##Class(EMR.DOC.COM.Template).Add()
ClassMethod Add(argDTO As EMR.DOC.DTO.Template) As %String
{
	s obj = ##class(CT.EMR.DOC.Template).%New()
	
	s obj.Code = argDTO.Code
	s obj.Name = argDTO.Name
	s obj.Description = argDTO.Description
	s obj.GUID = argDTO.GUID
	s obj.DocumentType = argDTO.DocumentType
	s obj.TempLastVersion = argDTO.TempLastVersion
	s obj.TempPublishVersion = argDTO.TempPublishVersion
	s obj.TemplateCategoryCode = argDTO.TemplateCategoryCode
	
	//需要增加TemplateVersion的状态管理逻辑
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		q (obj.%Id())
	}
	else
	{
		 quit "-1"
	}
}

/// w ##Class(EMR.DOC.COM.Template).Test()
ClassMethod Test() As %String
{
	s ReturnValue = ""
	
	s objDTO  = ##class(EMR.DOC.DTO.Template).%New()
	
	s objDTO.Code = "EMR090001"
	s objDTO.Name = "入院记录"
	s objDTO.Description = " 入院记录"
	s objDTO.GUID = "831650e5-21ce-4ddc-bb62-092fe3d92517"
	s objDTO.DocumentType = "DOC"
	s objDTO.TempLastVersion = 1
	s objDTO.TempPublishVersion = 1
	s objDTO.TemplateCategoryCode = "EMR090001"
	
	s ReturnValue =  ..Add(objDTO)
	
	q ReturnValue
}

}
