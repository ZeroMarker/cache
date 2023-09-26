Class EPRservice.BOImageItem Extends %SOAP.WebService [ ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "ImageItemInfo";

ClassMethod Create(AEImageItem As EPRservice.entity.EImageItem) As %String [ WebMethod ]
{
	q ##Class(EPRservice.DAL.DAImageItem).Create(AEImageItem)
}

ClassMethod GetByImageTreeID(AImageTreeID As %String) As EPRservice.dataset.EImageItemDataSet [ WebMethod ]
{
	s ds = ##Class(EPRservice.dataset.EImageItemDataSet).%New()
	d ds.SetArgs(AImageTreeID)
	q ds
}

ClassMethod GetEntity(AImgeItemID As %String) As EPRservice.entity.EImageItem [ WebMethod ]
{
	q ##Class(EPRservice.DAL.DAImageItem).GetEntity(AImgeItemID)
}

ClassMethod Update(AEImageItem As EPRservice.entity.EImageItem) As %String [ WebMethod ]
{
	q ##Class(EPRservice.DAL.DAImageItem).Update(AEImageItem)
}

ClassMethod DeleteByID(AImageItemID As %String) As %String [ WebMethod ]
{
	q ##Class(EPRservice.DAL.DAImageItem).DeleteByID(AImageItemID)
}

/// Debug:	w ##Class(EPRservice.BOImageItem).GetChildCountByTreeID()
ClassMethod GetChildCountByTreeID(AImageTreeID As %String) As %String
{
	s count = 0
	&sql(SELECT COUNT(*) INTO :count FROM EPRmeta.ImageItem WHERE ImageTreeID = :AImageTreeID)
	q count
}

/// Debug:	w ##Class(EPRservice.BOImageItem).CheckImageItemPublished(8,"ci")
ClassMethod CheckImageItemPublished(AFigureID As %String, AFigureType As %String) As %String [ WebMethod ]
{
	s ret = 0
	q:($g(AFigureID) = "")||($g(AFigureType) = "") ret
	
	s isPublished = 0
	if ($zcvt(AFigureType,"U") = "CI")
	{
		&sql(SELECT IsPublish INTO :isPublished FROM EPRmeta.ImageItem WHERE ID = :AFigureID)
	}
	else
	{
		&sql(SELECT IsPublish INTO :isPublished FROM EPRinstance.AdmImageItem WHERE ID = :AFigureID)	
	}
	s:(isPublished = "") isPublished = 0
	q isPublished
}

}
