Class EMRservice.TemplatePriv.BOTemplateGroup Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://192.168.0.15/trakcarejst/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "TemplatePriv.TemplateGroup";

ClassMethod Add(argTemplateGroup As EMRservice.entity.TemplatePriv.ETemplateGroup) As %String [ WebMethod ]
{
	q:($d(argTemplateGroup)=0)||(argTemplateGroup="") 0
	s aTemplateGroup=""
	s aTemplateGroup=##class(EMRmeta.TemplatePriv.TemplateGroup).%New()
	q:(aTemplateGroup="") 0
	
	s aTemplateGroup.GroupName=argTemplateGroup.GroupName
	
	s result=""
	s result=aTemplateGroup.%Save()
	q aTemplateGroup.%Id()
}

ClassMethod Delete(argTemplateGroupID As %String) As %String [ WebMethod ]
{
	q:($d(argTemplateGroupID)=0)||(argTemplateGroupID="") 0
	s aTemplateGroup="",result=""
	s aTemplateGroup=##class(EMRmeta.TemplatePriv.TemplateGroup).%OpenId(argTemplateGroupID)
	q:(aTemplateGroup="") 0
	s aTemplateGroup=""
	s result=##class(EMRmeta.TemplatePriv.TemplateGroup).%DeleteId(argTemplateGroupID)
	q result
}

ClassMethod Update(argTemplateGroupID As %String, argTemplateGroup As EMRservice.entity.TemplatePriv.ETemplateGroup) As %String [ WebMethod ]
{
	q:($d(argTemplateGroupID)=0)||($d(argTemplateGroup)=0)||(argTemplateGroupID="")||(argTemplateGroup="") 0
	s aTemplateGroup="",result=""
	s aTemplateGroup=##class(EMRmeta.TemplatePriv.TemplateGroup).%OpenId(argTemplateGroupID)
	q:(aTemplateGroup="") 0
	
	s aTemplateGroup.GroupName=argTemplateGroup.GroupName
	
	s result=""
	s result=aTemplateGroup.%Save()
	q result
}

ClassMethod GetById(argTemplateGroupID As %String) As EMRservice.entity.TemplatePriv.ETemplateGroup [ WebMethod ]
{
	s result="",id="",tmpResult="" 
	s result=##class(EMRservice.entity.TemplatePriv.ETemplateGroup).%New()
	
	s tmpResult=##class(EMRmeta.TemplatePriv.TemplateGroup).%OpenId(argTemplateGroupID)
	q:(tmpResult="") result
	s result.ID=argTemplateGroupID
	s result.GroupName=tmpResult.GroupName
		
	q result
}

ClassMethod GetTemplatesByGroupName(argGroupName As %String) As EMRservice.dataset.TemplatePriv.ETemplateGroupDatasetName [ WebMethod ]
{
 Set result=##class(EMRservice.dataset.TemplatePriv.ETemplateGroupDatasetName).%New()
 d result.SetArgs(argGroupName)
 Quit result
}

ClassMethod GetAllGroupName() As EMRservice.dataset.TemplatePriv.ETemplateGroupDatasetAll [ WebMethod ]
{
 Set result=##class(EMRservice.dataset.TemplatePriv.ETemplateGroupDatasetAll).%New()
 Quit result
}

ClassMethod GetRulesDetailByGrpNameAndAct(argGroupName As %String, argAction As %String) As EMRservice.dataset.TemplatePriv.ETemplateGroupDatasetName [ WebMethod ]
{
 Set result=##class(EMRservice.dataset.TemplatePriv.ERulesDetailByGrpNameAndAct).%New()
 d result.SetArgs(argGroupName,argAction)
 Quit result
}

ClassMethod GetRulesByGroupName(argGroupName As %String) As EMRservice.dataset.TemplatePriv.ETemplateGroupDatasetAll [ WebMethod ]
{
 Set result=##class(EMRservice.dataset.TemplatePriv.ERulesDatasetByGroupName).%New()
 d result.SetArgs(argGroupName)
 Quit result
}

ClassMethod GetGroupNameByTemplateID(argTemplateID As %String) As %String
{
	//q ##class(EMRmeta.TemplatePriv.TemplateGroup).GetGroupNameByTemplateID(argTemplateID)
	k SQLCODE
	s name="",curTemplateGroupID=""
	&sql(select TemplateGroup into :curTemplateGroupID from EMRmeta_TemplatePriv.TemplatesInGroup where Template=:parTemplateId)
	q:(curTemplateGroupID="") ""
	
	&sql(select GroupName into :name 
			from EMRmeta_TemplatePriv.TemplateGroup where id=:curTemplateGroupID)
	q name
}

ClassMethod GetConditionByGrpNameAndAction(argGroupName As %String, argAction As %String) As %String
{
	q ##class(EMRmeta.TemplatePriv.TemplateGroup).GetConditionByGrpNameAndAction(argGroupName,argAction)
}

}
