Class CT.WS.BO.BODataElementCategory Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "DataElementCategoryInfo";

/// 创建一个数据元范畴
ClassMethod CreateDataElementCategory(aEDataElementCategoryInfo As EPRservice.entity.EDataElementCategory) As %String [ WebMethod ]
{
	set objDataElementCategory=##class(CT.WS.DataElementCategory).%New()
	quit:(objDataElementCategory="") ""
	
	set objDataElementCategory.Name=aEDataElementCategoryInfo.Name
	set objDataElementCategory.Description=aEDataElementCategoryInfo.Description
	set objDataElementCategory.ParentID=aEDataElementCategoryInfo.ParentID
	set objDataElementCategory.InternalID=aEDataElementCategoryInfo.InternalID
	
	do objDataElementCategory.%Save()
	quit objDataElementCategory.%Id()
}

/// 删除一个数据元范畴
ClassMethod DeleteDataElementCategory(aDataElementCategoryId As %String) As %String [ WebMethod ]
{
	s result = ##class(CT.WS.DataElementCategory).%DeleteId(aDataElementCategoryId)
	q (+result)
}

/// 更新一个数据元范畴
ClassMethod UpdateDataElementCategory(aEDataElementCategoryInfo As EPRservice.entity.EDataElementCategory) As %String [ WebMethod ]
{
	set objDataElementCategory=##class(CT.WS.DataElementCategory).%OpenId(aEDataElementCategoryInfo.ID)
	quit:(objDataElementCategory="") "0"
	
	set objDataElementCategory.Name=aEDataElementCategoryInfo.Name
	set objDataElementCategory.Description=aEDataElementCategoryInfo.Description
	set objDataElementCategory.ParentID=aEDataElementCategoryInfo.ParentID
	set objDataElementCategory.InternalID=aEDataElementCategoryInfo.InternalID
	set result = objDataElementCategory.%Save()
	q (+result)
}

/// 查找数据元范畴
ClassMethod SelectAllDataElementCategory() As EPRservice.dataset.EDataElementCategoryDataset [ WebMethod ]
{
	set result=##class(EPRservice.dataset.EDataElementCategoryDataset).%New()
	quit result
}

/// 查找数据元范畴
ClassMethod SelectDataElementCategoryByID(aDataElementCategoryId As %String) As EPRservice.entity.EDataElementCategory [ WebMethod ]
{
	set objDataElementCategory=##class(CT.WS.DataElementCategory).%OpenId(aDataElementCategoryId)
	quit:(objDataElementCategory="") ""
	
	set objEDataElementCategory=##class(EPRservice.entity.EDataElementCategory).%New()
	quit:(objEDataElementCategory="") ""
	
	set objEDataElementCategory.ID=objDataElementCategory.%Id()
	set objEDataElementCategory.Name=objDataElementCategory.Name
	set objEDataElementCategory.Description=objDataElementCategory.Description
	set objEDataElementCategory.ParentID=objDataElementCategory.ParentID
	set objEDataElementCategory.InternalID=objDataElementCategory.InternalID
	
	quit objEDataElementCategory
}

}
