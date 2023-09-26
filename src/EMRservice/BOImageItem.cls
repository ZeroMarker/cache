Class EMRservice.BOImageItem Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "ImageItemInfo";

ClassMethod Create(AEImageItem As EMRservice.entity.EImageItem) As %String [ WebMethod ]
{
	q ##Class(EMRservice.DAL.DAImageItem).Create(AEImageItem)
}

ClassMethod GetByImageTreeID(AImageTreeID As %String) As EMRservice.dataset.EImageItemDataSet [ WebMethod ]
{
	s ds = ##Class(EMRservice.dataset.EImageItemDataSet).%New()
	d ds.SetArgs(AImageTreeID)
	q ds
}

ClassMethod GetEntity(AImgeItemID As %String) As EMRservice.entity.EImageItem [ WebMethod ]
{
	q ##Class(EMRservice.DAL.DAImageItem).GetEntity(AImgeItemID)
}

ClassMethod Update(AEImageItem As EMRservice.entity.EImageItem) As %String [ WebMethod ]
{
	q ##Class(EMRservice.DAL.DAImageItem).Update(AEImageItem)
}

ClassMethod DeleteByID(AImageItemID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.DAL.DAImageItem).DeleteByID(AImageItemID)
}

/// Debug:	w ##Class(EMRservice.BOImageItem).GetChildCountByTreeID()
ClassMethod GetChildCountByTreeID(AImageTreeID As %String) As %String
{
	s count = 0
	&sql(SELECT COUNT(*) INTO :count FROM EMRmeta.ImageItem WHERE ImageTreeID = :AImageTreeID)
	q count
}

/// Debug:	w ##Class(EMRservice.BOImageItem).CheckImageItemPublished(8,"ci")
ClassMethod CheckImageItemPublished(AFigureID As %String, AFigureType As %String) As %String [ WebMethod ]
{
	s ret = 0
	q:($g(AFigureID) = "")||($g(AFigureType) = "") ret
	
	s isPublished = 0
	if ($zcvt(AFigureType,"U") = "CI")
	{
		&sql(SELECT IsPublish INTO :isPublished FROM EMRmeta.ImageItem WHERE ID = :AFigureID)
	}
	else
	{
		//&sql(SELECT IsPublish INTO :isPublished FROM EMRinstance.AdmImageItem WHERE ID = :AFigureID)	
	}
	s:(isPublished = "") isPublished = 0
	q isPublished
}

}
