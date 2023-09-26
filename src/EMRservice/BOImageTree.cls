Class EMRservice.BOImageTree Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "ImageTreeInfo";

ClassMethod Create(AEImageTree As EMRservice.entity.EImageTree) As %String [ WebMethod ]
{
	q ##Class(EMRservice.DAL.DAImageTree).Create(AEImageTree)
}

ClassMethod GetImageTreeCount() As %String [ WebMethod ]
{
	s count = 0
	&sql(SELECT max(Sequence) INTO :count FROM EMRmeta.ImageTree)
	i (count=$C(0)) s count=0
	i (count="") s count=0
	q count
}

ClassMethod GetByImageLibID(AImageLibID As %String) As EMRservice.dataset.EImageTreeDataSet [ WebMethod ]
{
	s ds = ##Class(EMRservice.dataset.EImageTreeDataSet).%New()
	d ds.SetArgs(AImageLibID)
	q ds
}

/// Debug: 	s obj = ##Class(EMRservice.BOImageTree).GetEntity("3")
ClassMethod GetEntity(AImageTreeID As %String) As EMRservice.entity.EImageTree [ WebMethod ]
{
	q ##Class(EMRservice.DAL.DAImageTree).GetEntity(AImageTreeID)
}

ClassMethod Update(AImageTreeID As EMRservice.entity.EImageTree) As %String [ WebMethod ]
{
	q ##Class(EMRservice.DAL.DAImageTree).Update(AImageTreeID)
}

ClassMethod DeleteByID(AImageTreeID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.DAL.DAImageTree).Delete(AImageTreeID)
}

ClassMethod SwapSequence(AImageTreeID1 As %String, AImageTreeID2 As %String) As %Boolean [ WebMethod ]
{
	s ret = 0
	s objNextTree = ##Class(EMRmeta.ImageTree).%OpenId(AImageTreeID1)
	s objSelectTree = ##class(EMRmeta.ImageTree).%OpenId(AImageTreeID2)
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
