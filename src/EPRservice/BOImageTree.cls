Class EPRservice.BOImageTree Extends %SOAP.WebService [ ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "ImageTreeInfo";

ClassMethod Create(AEImageTree As EPRservice.entity.EImageTree) As %String [ WebMethod ]
{
	q ##Class(EPRservice.DAL.DAImageTree).Create(AEImageTree)
}

ClassMethod GetByImageLibID(AImageLibID As %String) As EPRservice.dataset.EImageTreeDataSet [ WebMethod ]
{
	s ds = ##Class(EPRservice.dataset.EImageTreeDataSet).%New()
	d ds.SetArgs(AImageLibID)
	q ds
}

/// Debug: 	s obj = ##Class(EPRservice.BOImageTree).GetEntity("3")
ClassMethod GetEntity(AImageTreeID As %String) As EPRservice.entity.EImageTree [ WebMethod ]
{
	q ##Class(EPRservice.DAL.DAImageTree).GetEntity(AImageTreeID)
}

ClassMethod Update(AImageTreeID As EPRservice.entity.EImageTree) As %String [ WebMethod ]
{
	q ##Class(EPRservice.DAL.DAImageTree).Update(AImageTreeID)
}

ClassMethod SwapSequence(AImageTreeID1 As %String, AImageTreeID2 As %String) As %Boolean [ WebMethod ]
{
	s ret = 0
	s objNextTree = ##Class(EPRmeta.ImageTree).%OpenId(AImageTreeID1)
	s objSelectTree = ##class(EPRmeta.ImageTree).%OpenId(AImageTreeID2)
	q:((objNextTree = "")||(objSelectTree = "")) ret
	
	s tmpSequence = objNextTree.Sequence
	s objNextTree.Sequence = objSelectTree.Sequence
	s objSelectTree.Sequence = tmpSequence
	
	s $zt = "SwapErrorHandler"
	TSTART
	s scResult = objNextTree.%Save() 
	if $$$ISERR(scResult)
	{
		TROLLBACK
		q ret
	}
	s scResultSelect = objSelectTree.%Save() 
	if $$$ISERR(scResultSelect)
	{
		TROLLBACK
		q ret
	}
	TCOMMIT
	
	d objNextTree.%Close()
	d objSelectTree.%Close()
	s objNextTree = ""	
	s objSelectTree = ""
	
	s ret = 1
	q ret
	 
SwapErrorHandler
    s ret = 0
    q ret
}

}
