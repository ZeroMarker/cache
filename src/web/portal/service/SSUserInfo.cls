/// 获取用户信息
Class web.portal.service.SSUserInfo Extends %SOAP.WebService
{

/// NAMESPACE - Should be an unique URI
/// Override this parameter in the subclass with the unique namespace URI
/// of your organization.
/// Override this parameter in the subclass.
Parameter NAMESPACE = "http://www.dhcc.com.cn/CPM/DHCCPM";

/// SERVICENAME - Should be the name of the service for which this is a proxy.
/// Override this parameter in the subclass.
Parameter SERVICENAME = "PortalUserInfo";

ClassMethod SelectUser() As web.portal.dataset.SSUser [ WebMethod ]
{
	;s obj= ##class(web.portal.service.SSUserInfo).ReadUserLoc("demo")
	Set result=##class(web.portal.dataset.SSUser).%New()
	Do result.SetArgs()
	Quit result
}

ClassMethod ReadUserLoc(UCode As %String) As web.portal.dataset.SSUserLogonLoc [ WebMethod ]
{
	;s obj= ##class(web.portal.service.SSUserInfo).ReadUserLoc("demo")
	Set result=##class(web.portal.dataset.SSUserLogonLoc).%New()
	Do result.SetArgs(UCode)
	Quit result
}

ClassMethod ReadUserByCode(UCode As %String) As web.portal.dataset.SSUserCodeDS [ WebMethod ]
{
	;s obj= ##class(web.portal.service.SSUserInfo).ReadUserByCode("demo")
	Set result=##class(web.portal.dataset.SSUserCodeDS).%New()
	Do result.SetArgs(UCode)
	Quit result
}

}
