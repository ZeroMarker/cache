Class EMRservice.BOImageCategory Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "ImageCategoryInfo";

/// Creator:	Kumon Xie
/// CreatDate:	2011-09-16
/// Desc:		查询所有图库目录
/// Input：		无
/// Return：	EMRservice.dataset.EImageCategoryDataset 图库dataset
ClassMethod GetAllImageCategories() As EMRservice.dataset.EImageCategoryDataset [ WebMethod ]
{
	s result = ##Class(EMRservice.dataset.EImageCategoryDataset).%New()
	q result
}

/// Creator:	Kumon Xie
/// CreatDate:	2011-09-16
/// Desc:		创建图库目录
/// Table：		EMRservice.entity.EImageCategory
/// Input：		AECategory为图库目录实体对象
/// Return：	图库目录RowID	
ClassMethod CreateImageCategory(AECategory As EMRservice.entity.EImageCategory) As %String [ WebMethod ]
{
	s objCategory = ##Class(EMRmeta.ImageCategory).%New()
	
	s objCategory.Name = AECategory.Name
	s objCategory.Description = AECategory.Description
	s objCategory.ParentID = AECategory.ParentID
	d objCategory.%Save()
	
	s ret = objCategory.%Id()
	q ret
}

/// Creator:	Kumon Xie
/// CreatDate:	2011-10-14
/// Desc:		删除图库目录
/// Table：		EMRservice.entity.EImageCategory
/// Input：		ACategoryID为图库目录RowID
/// Return：	删除成功返回1，否则返回0
ClassMethod DeleteImageCategory(ACategoryID As %String) As %Boolean [ WebMethod ]
{
	s objCategory = ##Class(EMRmeta.ImageCategory).%OpenId(ACategoryID)
	if '(objCategory.%DeleteId(ACategoryID))
	{
 		q 0
	} 
 	q 1
}

/// Creator:	Kumon Xie
/// CreatDate:	2011-10-14
/// Desc:		修改图库目录
/// Table：		EMRservice.entity.EImageCategory
/// Input：		AECategory为图库目录实体对象
/// Return：	修改成功返回1，否则返回0
ClassMethod UpdateImageCategory(AECategory As EMRservice.entity.EImageCategory) As %Boolean [ WebMethod ]
{
	s objCategory = ##Class(EMRmeta.ImageCategory).%OpenId(AECategory.ID)
	q:(objCategory = "") 0
	
	s objCategory.Name = AECategory.Name
	s objCategory.ParentID=  AECategory.ParentID
	s objCategory.Description = AECategory.Description

	 if '(objCategory.%Save()) {
		q 0
	 } 
	 q 1
}

}
