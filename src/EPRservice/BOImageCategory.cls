Class EPRservice.BOImageCategory Extends %SOAP.WebService [ ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "ImageCategoryInfo";

/// Creator:	Kumon Xie
/// CreatDate:	2011-09-16
/// Desc:		查询所有图库目录
/// Input：		无
/// Return：	EPRservice.dataset.EImageCategoryDataset: 图库dataset
ClassMethod GetAllImageCategories() As EPRservice.dataset.EImageCategoryDataset [ WebMethod ]
{
	s result = ##Class(EPRservice.dataset.EImageCategoryDataset).%New()
	q result
}

/// Creator:	Kumon Xie
/// CreatDate:	2011-09-16
/// Desc:		创建图库目录
/// Table：		EPRservice.entity.EImageCategory
/// Input：		AECategory为图库目录实体对象
/// Return：	图库目录RowID	
ClassMethod CreateImageCategory(AECategory As EPRservice.entity.EImageCategory) As %String [ WebMethod ]
{
	s objCategory = ##Class(EPRmeta.ImageCategory).%New()
	
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
/// Table：		EPRservice.entity.EImageCategory
/// Input：		ACategoryID为图库目录RowID
/// Return：	删除成功返回1，否则返回0
ClassMethod DeleteImageCategory(ACategoryID As %String) As %Boolean [ WebMethod ]
{
	TSTART 
	s objCategory = ##Class(EPRmeta.ImageCategory).%OpenId(ACategoryID)
	if '(objCategory.%DeleteId(ACategoryID))
	{
	  	TROLLBACK
 		q 0
	} 
	TCOMMIT
 	q 1
}

/// Creator:	Kumon Xie
/// CreatDate:	2011-10-14
/// Desc:		修改图库目录
/// Table：		EPRservice.entity.EImageCategory
/// Input：		AECategory为图库目录实体对象
/// Return：	修改成功返回1，否则返回0
ClassMethod UpdateImageCategory(AECategory As EPRservice.entity.EImageCategory) As %Boolean [ WebMethod ]
{
	TSTART
	s objCategory = ##Class(EPRmeta.ImageCategory).%OpenId(AECategory.ID)
	q:(objCategory = "") 0
	
	s objCategory.Name = AECategory.Name
	s objCategory.ParentID=  AECategory.ParentID
	s objCategory.Description = AECategory.Description

	 if '(objCategory.%Save()) {
		TROLLBACK  
		q 0
	 } 
	 TCOMMIT
	 q 1
}

}
