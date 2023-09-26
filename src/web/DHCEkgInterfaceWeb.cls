/// web.DHCEkgOutInterfaceWeb
/// For DHC EKG Studio System . 2008-12-30, Created by Yang Yali .
/// 公布的Webservice方法，提供给第三方使用
Class web.DHCEkgInterfaceWeb Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "DHCEkgOutInterfaceWeb";

//Parameter LOCATION = "http://localhost/csp/websource";

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/EKG";

/// Creator：      yangyali
/// CreatDate：    2017-3-10
/// Modify: 	   yangyali
/// ModifyDate：   2017-3-10
/// Description:   提供给百惠的接口，查询医嘱
/// Input：        执行科室ID，病人登记号
/// Output：       string
/// Return：       string
/// Others：
/// w ##class(web.DHCEkgOutInterfaceWeb).DHCEKGGetOrdInfotoBaihui("45","0000148963")
ClassMethod DHCEKGGetOrdInfotoBaihui(LocId As %String, PatCode As %String) As %String [ WebMethod ]
{
	set rtn=""
	set rtn=##class(web.DHCEkgService).DHCEKGGetOrdInfotoBaihui(LocId,PatCode)
	q rtn
}

}
