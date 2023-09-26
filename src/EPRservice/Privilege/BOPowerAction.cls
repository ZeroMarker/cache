/// Not In Use
Class EPRservice.Privilege.BOPowerAction Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://192.168.0.15/trakcarejst/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "Privilege.PowerAction";

ClassMethod Add(argPowerAction As EPRservice.entity.Privilege.EPowerAction) As %String [ WebMethod ]
{
	q:($d(argPowerAction)=0)||(argPowerAction="") 0
	s aPowerAction=""
	s aPowerAction=##class(EPRmeta.Privilege.PowerAction).%New()
	q:(aPowerAction="") 0
	
	s aPowerAction.Alias=argPowerAction.Alias
	s aPowerAction.Code=argPowerAction.Code
	s aPowerAction.BeforeStatus=argPowerAction.BeforeStatus
	s aPowerAction.AfterStatus=argPowerAction.AfterStatus
	s aPowerAction.Description=argPowerAction.Description
	s aPowerAction.TraceTrigger=argPowerAction.TraceTrigger
	
	s result=""
	s result=aPowerAction.%Save()
	q result
}

ClassMethod Delete(argPowerActionID As %String) As %String [ WebMethod ]
{
	q:($d(argPowerActionID)=0)||(argPowerActionID="") 0
	s aPowerAction="",result=""
	s aPowerAction=##class(EPRmeta.Privilege.PowerAction).%OpenId(argPowerActionID)
	q:(aPowerAction="") 0
	s aPowerAction=""
	s result=##class(EPRmeta.Privilege.PowerAction).%DeleteId(argPowerActionID)
	q result
}

ClassMethod Update(argPowerActionID As %String, argPowerAction As EPRservice.entity.Privilege.EPowerAction) As %String [ WebMethod ]
{
	q:($d(argPowerActionID)=0)||($d(argPowerAction)=0)||(argPowerActionID="")||(argPowerAction="") 0
	s aPowerAction="",result=""
	s aPowerAction=##class(EPRmeta.Privilege.PowerAction).%OpenId(argPowerActionID)
	q:(aPowerAction="") 0
	
	s aPowerAction.Alias=argPowerAction.Alias
	s aPowerAction.Code=argPowerAction.Code
	s aPowerAction.BeforeStatus=argPowerAction.BeforeStatus
	s aPowerAction.AfterStatus=argPowerAction.AfterStatus
	s aPowerAction.Description=argPowerAction.Description
	s aPowerAction.TraceTrigger=argPowerAction.TraceTrigger
	
	s result=""
	s result=aPowerAction.%Save()
	q result
}

ClassMethod GetById(argPowerActionID As %String) As EPRservice.entity.Privilege.EPowerAction [ WebMethod ]
{
	s result="",id="",tmpResult=""
	k SQLCODE
	&sql(select ID into :id from EPRmeta_Privilege.PowerAction where %ID=:argPowerActionID)
	s result=##class(EPRservice.entity.Privilege.EPowerAction).%New()
	
	if (SQLCODE=0) {
		s tmpResult=##class(EPRmeta.Privilege.PowerAction).%OpenId(id)
		q:(tmpResult="") result
		
		s result.Alias=tmpResult.Alias
		s result.Code=tmpResult.Code
		s result.BeforeStatus=tmpResult.BeforeStatus
		s result.AfterStatus=tmpResult.AfterStatus
		s result.Description=tmpResult.Description
		s result.TraceTrigger=tmpResult.TraceTrigger
		
	}
	q result
}

ClassMethod GetAllPowerAction() As EPRservice.dataset.Privilege.EPowerActionDataset [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.Privilege.EPowerActionDataset).%New()
 Quit result
}

}
