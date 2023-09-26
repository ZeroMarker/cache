Class EPRservice.BOAdmImageItem Extends %SOAP.WebService [ ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "AdmImageItemInfo";

/// Desc:	获取指定就诊中的就诊图片信息
ClassMethod GetByEpisodeID(AEpisodeID As %String) As EPRservice.dataset.EAdmImageItemDataSet [ WebMethod ]
{
	s ds = ##Class(EPRservice.dataset.EAdmImageItemDataSet).%New()
	d ds.SetArgs(AEpisodeID)
	q ds
}

/// Desc:	获取指定就诊图片实体对象
ClassMethod GetEntity(AAdmImageItemID As %String) As EPRservice.entity.EAdmImageItem [ WebMethod ]
{
	q ##Class(EPRservice.DAL.DAAdmImageItem).GetEntity(AAdmImageItemID)
}

/// Desc:	创建就诊图片
ClassMethod Create(AEAdmImageItem As EPRservice.entity.EAdmImageItem) As %String [ WebMethod ]
{
	q ##Class(EPRservice.DAL.DAAdmImageItem).Create(AEAdmImageItem)
}

/// Desc:	创建就诊图片
ClassMethod Update(AEAdmImageItem As EPRservice.entity.EAdmImageItem) As %String [ WebMethod ]
{
	q ##Class(EPRservice.DAL.DAAdmImageItem).Update(AEAdmImageItem)
}

/// Desc:	删除就诊图片记录
ClassMethod Delete(AAdmImageItemID As %String) As %String [ WebMethod ]
{
	q ##Class(EPRservice.DAL.DAAdmImageItem).Delete(AAdmImageItemID)
}

}
