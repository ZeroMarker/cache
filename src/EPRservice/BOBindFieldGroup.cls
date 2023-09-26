Class EPRservice.BOBindFieldGroup Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "BindFieldGroupService";

ClassMethod AddBindFieldGroup(AEBindFieldGroup As EPRservice.entity.EBindFieldGroup) As EPRservice.entity.EBindFieldGroup [ WebMethod ]
{
	s objBindFieldGroup = ##class(EPRmeta.BindFieldGroup).%New()
	q:(objBindFieldGroup="") ""
	
	s objBindFieldGroup.QueryID = AEBindFieldGroup.QueryID
	s objBindFieldGroup.GroupFieldName = AEBindFieldGroup.GroupFieldName
	s objBindFieldGroup.GroupFieldDesc = AEBindFieldGroup.GroupFieldDesc
	s objBindFieldGroup.DefaultSelect = AEBindFieldGroup.DefaultSelect
	s objBindFieldGroup.SelectMaxLimit = AEBindFieldGroup.SelectMaxLimit
	s objBindFieldGroup.QueryCName = AEBindFieldGroup.QueryCName
	s objBindFieldGroup.QueryQName = AEBindFieldGroup.QueryQName
	s objBindFieldGroup.ReadOnlySetting = AEBindFieldGroup.ReadOnlySetting
	
	s sc = objBindFieldGroup.%Save()
	if ($$$ISOK(sc))
	{
		s AEBindFieldGroup.ID = objBindFieldGroup.%Id()
		q AEBindFieldGroup
	}
	else
	{
		q ""
	}
}

ClassMethod UpdateBindFieldGroup(AEBindFieldGroup As EPRservice.entity.EBindFieldGroup) As %String [ WebMethod ]
{
	s objBindFieldGroup = ##class(EPRmeta.BindFieldGroup).%OpenId(AEBindFieldGroup.ID)
	q:(objBindFieldGroup="") "0"
	
	s objBindFieldGroup.QueryID =  AEBindFieldGroup.QueryID
	s objBindFieldGroup.GroupFieldName = AEBindFieldGroup.GroupFieldName
	s objBindFieldGroup.GroupFieldDesc = AEBindFieldGroup.GroupFieldDesc
	s objBindFieldGroup.DefaultSelect = AEBindFieldGroup.DefaultSelect
	s objBindFieldGroup.SelectMaxLimit = AEBindFieldGroup.SelectMaxLimit
	s objBindFieldGroup.QueryCName = AEBindFieldGroup.QueryCName
	s objBindFieldGroup.QueryQName = AEBindFieldGroup.QueryQName
	s objBindFieldGroup.ReadOnlySetting = AEBindFieldGroup.ReadOnlySetting
	
	s sc = objBindFieldGroup.%Save()
	if ($$$ISOK(sc))
	{
		q "1"
	}
	else
	{
		q "0"
	}
}

ClassMethod DeleteBindFieldGroup(ABindFieldGroupID As %String) As %String [ WebMethod ]
{
	s sc = ##Class(EPRmeta.BindFieldGroup).%DeleteId(ABindFieldGroupID)
	if ($$$ISOK(sc))
	{
		q "1"
	}
	else
	{
		q "0"
	}
}

/// s a = ##Class(EPRservice.BOBindFieldGroup).GetBindFieldGroup("15")
ClassMethod GetBindFieldGroup(ABindQueryID As %String) As EPRservice.entity.EBindFieldGroup [ WebMethod ]
{
	//b "s"
	s id = $O(^DHCEPRM.BindFieldGroupI("IdxQueryID"," "_ABindQueryID,""))
	q:(id="") ""
	
	s objBindFieldGroup = ##class(EPRmeta.BindFieldGroup).%OpenId(id)
	q:(objBindFieldGroup="") ""
	
	s entity = ##class(EPRservice.entity.EBindFieldGroup).%New()
	s entity.ID = objBindFieldGroup.%Id()
	s entity.QueryID = objBindFieldGroup.QueryID
	s entity.GroupFieldName = objBindFieldGroup.GroupFieldName
	s entity.GroupFieldDesc = objBindFieldGroup.GroupFieldDesc
	s entity.DefaultSelect = objBindFieldGroup.DefaultSelect
	s entity.SelectMaxLimit = objBindFieldGroup.SelectMaxLimit
	s entity.QueryCName = objBindFieldGroup.QueryCName
	s entity.QueryQName = objBindFieldGroup.QueryQName
	s entity.ReadOnlySetting = objBindFieldGroup.ReadOnlySetting
	
	q entity
}

/// w ##Class(EPRservice.BOBindFieldGroup).GetBindFieldGroupByCQ("EPRservice.SystemData","GetTestInfo")
ClassMethod GetBindFieldGroupByCQ(ABindQueryCName As %String, ABindQueryQName As %String) As EPRservice.entity.EBindFieldGroup [ WebMethod ]
{
	//b "s"
	s id = $O(^DHCEPRM.BindFieldGroupI("IdxQueryInfo"," "_$zcvt(ABindQueryCName,"u")," "_$zcvt(ABindQueryQName,"u"),""))
	q:(id="") ""
	
	s objBindFieldGroup = ##class(EPRmeta.BindFieldGroup).%OpenId(id)
	q:(objBindFieldGroup="") ""
	
	s entity = ##class(EPRservice.entity.EBindFieldGroup).%New()
	s entity.ID = objBindFieldGroup.%Id()
	s entity.QueryID = objBindFieldGroup.QueryID
	s entity.GroupFieldName = objBindFieldGroup.GroupFieldName
	s entity.GroupFieldDesc = objBindFieldGroup.GroupFieldDesc
	s entity.DefaultSelect = objBindFieldGroup.DefaultSelect
	s entity.SelectMaxLimit = objBindFieldGroup.SelectMaxLimit
	s entity.QueryCName = objBindFieldGroup.QueryCName
	s entity.QueryQName = objBindFieldGroup.QueryQName
	s entity.ReadOnlySetting = objBindFieldGroup.ReadOnlySetting
	
	q entity
}

ClassMethod GetFieldInfoByCQ(ABindQueryCName As %String, ABindQueryQName As %String) As EPRservice.dataset.EBindFieldDataset [ WebMethod ]
{
	s id = ##Class(EPRmeta.BindQuery).SelectIDByClassName(ABindQueryCName,ABindQueryQName)
	q:(id="")||(id=$C(0)) ""
	
 	Set result=##class(EPRservice.dataset.EBindFieldDataset).%New()
 	Do result.SetArgs(id)
 	Quit result
}

}
