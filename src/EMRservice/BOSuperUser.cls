/// 名称:EMRservice.BOSuperUser
/// 描述:用户信息BO
/// 编写者：yejian
/// 编写日期: 2014-2-12
Class EMRservice.BOSuperUser Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "SuperUserService";

ClassMethod SelectALLSUser() As EMRservice.dataset.ESuperUserDataset [ WebMethod ]
{
 Set result=##class(EMRservice.dataset.ESuperUserDataset).%New()
 Quit result
}

ClassMethod CreateSuperUser(argESuperUser As EMRservice.entity.ESuperUser) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLSuperUser).CreateSuperUser(argESuperUser)
}

ClassMethod UpdateSuperUser(argESuperUser As EMRservice.entity.ESuperUser) As %String [ WebMethod ]
{
 q ##Class(EMRservice.BL.BLSuperUser).UpdateSuperUser(argESuperUser)
}

ClassMethod DeleteSuperUser(AID As %String) As %Boolean [ WebMethod ]
{
	q:(($d(AID) = 0)||(AID = "")) 0	
	set objSuperUser = ##class(EMRmeta.SuperUser).%OpenId(AID)
	Quit objSuperUser.%DeleteId(AID)
}

}
