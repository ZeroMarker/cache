/// 名称：		EMRservice.Image.BOCategory
/// 描述：		图片目录BO层
/// 编写者：	yejian
/// 编写时间：	2016-5-17
Class EMRservice.Image.BOCategory Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "ImageBOCategoryInfo";

/// Creator:	yejian
/// CreatDate:	2011-09-16
/// Desc:		查询所有图库目录
/// Input：		无
/// Return：	EMRservice.dataset.EImageCategoryDataset 图库dataset
ClassMethod GetAllImageCategories() As EMRservice.dataset.Image.ECategoryDataset [ WebMethod ]
{
	s result = ##Class(EMRservice.dataset.Image.ECategoryDataset).%New()
	q result
}

/// Creator:	yejian
/// CreatDate:	2011-09-16
/// Desc:		创建图库目录
/// Table：		EMRservice.entity.Image.ECategory
/// Input：		AECategory为图库目录实体对象
/// Return：	图库目录RowID	
ClassMethod CreateImageCategory(AECategory As EMRservice.entity.Image.ECategory) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.Image.BLCategory).CreateImageCategory(AECategory)
}

/// Creator:	yejian
/// CreatDate:	2011-10-14
/// Desc:		删除图库目录
/// Table：		EMRservice.entity.Image.ECategory
/// Input：		ACategoryID为图库目录RowID
/// Return：	删除成功返回1，否则返回0
ClassMethod DeleteImageCategory(ACategoryID As %String) As %Boolean [ WebMethod ]
{
	q ##Class(EMRservice.BL.Image.BLCategory).DeleteImageCategory(ACategoryID)
}

/// Creator:	yejian
/// CreatDate:	2011-10-14
/// Desc:		修改图库目录
/// Table：		EMRservice.entity.Image.ECategory
/// Input：		AECategory为图库目录实体对象
/// Return：	修改成功返回1，否则返回0
ClassMethod UpdateImageCategory(AECategory As EMRservice.entity.Image.ECategory) As %Boolean [ WebMethod ]
{
	q ##Class(EMRservice.BL.Image.BLCategory).UpdateImageCategory(AECategory)
}

/// 更新顺序
ClassMethod UpdateSequences(argStr As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.Image.BLCategory).UpdateSequences(argStr)
}

/// 判断code编号是否存在
ClassMethod CheckCodeExist(Acode As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.Image.BLCategory).CheckCodeExist(Acode)
}

}
