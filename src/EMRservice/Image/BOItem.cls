/// 名称：		EMRservice.Image.BOItem
/// 描述：		图片BO层
/// 编写者：	yejian
/// 编写时间：	2016-5-17
Class EMRservice.Image.BOItem Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "ImageBOItemInfo";

ClassMethod Create(AEImageItem As EMRservice.entity.Image.EItem) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.Image.BLItem).Create(AEImageItem)
}

ClassMethod GetByImageTreeID(AImageTreeID As %String) As EMRservice.dataset.Image.EItemDataSet [ WebMethod ]
{
	s ds = ##Class(EMRservice.dataset.Image.EItemDataSet).%New()
	d ds.SetArgs(AImageTreeID)
	q ds
}

ClassMethod GetEntity(AImgeItemID As %String) As EMRservice.entity.Image.EItem [ WebMethod ]
{
	q ##Class(EMRservice.BL.Image.BLItem).GetEntity(AImgeItemID)
}

ClassMethod Update(AEImageItem As EMRservice.entity.Image.EItem) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.Image.BLItem).Update(AEImageItem)
}

ClassMethod DeleteByID(AImageItemID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.Image.BLItem).DeleteByID(AImageItemID)
}

/// Debug:	w ##Class(EMRservice.BOImageItem).GetChildCountByTreeID()
ClassMethod GetChildCountByTreeID(AImageTreeID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.Image.BLItem).GetChildCountByTreeID(AImageTreeID)
}

/// w ##Class(EMRservice.BOImageItem).GetItemsByTreeID("5")
ClassMethod GetItemsByTreeID(AImageCatID As %String) As EMRservice.entity.Image.Items [ WebMethod ]
{
	q ##Class(EMRservice.BL.Image.BLItem).GetItemsByTreeID(AImageCatID)
}

/// Debug:	w ##Class(EMRservice.BOImageItem).CheckImageItemPublished(8,"ci")
ClassMethod CheckImageItemPublished(AFigureID As %String, AFigureType As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.Image.BLItem).CheckImageItemPublished(AFigureID,AFigureType)
}

/// 更新顺序
ClassMethod UpdateSequences(argStr As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.Image.BLItem).UpdateSequences(argStr)
}

/// 判断code编号是否存在
ClassMethod CheckCodeExist(Acode As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.Image.BLItem).CheckCodeExist(Acode)
}

/// 批量更新状态
ClassMethod UpPublish(ACategoryID As %String, AStatue As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.Image.BLItem).UpPublish(ACategoryID,AStatue)
}

}
