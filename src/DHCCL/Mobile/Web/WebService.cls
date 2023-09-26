Class DHCCL.Mobile.Web.WebService Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "CLMobileInterface";

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
Parameter LOCATION = "http://localhost/Dthealth/web";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://dhcc.com.cn";

Parameter SOAPSESSION = 1;

ClassMethod Test() As %String [ WebMethod ]
{
	q:$g(%session.Data("logOn"))'="" $g(%session.Data("logOn"))
	i $g(%session.Data("logOn"))="" s %session.Data("logOn")="1"
	q "Test String"
}

ClassMethod RequestSubmit(RequestCode, RequestXML) As %String [ WebMethod ]
{
	// w ##class(DHCCL.Mobile.Web.WebService).RequestSubmit(RequestCode, RequestXML)
	s session=""
	i ##class(%Library.Device).GetType()'=1 d
	.// 如果不是Terminal
	.Set %session.AppTimeout=3600
	.s session=$g(%session.Data("userName"))
	
	s time=$p($h,",",2)
	s date=$Replace($zd(+$h,3),"-","")
	s ihour=time\3600
	s imin=(time#3600)\60
	s isec=time#3600#60
	s ^tmpcldebug(date,ihour,imin,isec,time)=RequestCode_" "_RequestXML
	s ^tmpcldebug(date,ihour,imin,isec,time,"DateTime")=$zd(+$h)_" "_$zt($p($h,",",2))
	i RequestXML=$c(0) s RequestXML=""
	q:RequestCode="" "Code is NULL"

	w "<!-- ",!
	s session="1"
	i session'="" d
	.; 已登陆
	.s res=..RunMethod(RequestCode,RequestXML)
	e  d
	.; 未登陆
	.i RequestCode<30000 d
	..s res=..RunMethod(RequestCode,RequestXML)
	.e  d
	..s res="<Response><ResultCode>-1</ResultCode><ResultDesc>Session失效 请重新登陆</ResultDesc><TotalCount></TotalCount></Response>"
	w "-->",!
	q res
}

ClassMethod CheckLogIn(RequestCode, RequestXML)
{
	
	q:##class(%Library.Device).GetType()=1 1 // Terninal执行
	q:$g(%session.Data("userName"))'="" 1
	s res=0
	s ID=$O(^User.ServiceActionI("ActionCode",RequestCode,""))
	s ActionObj=##class(User.ServiceAction).%OpenId(ID)
	// i ((ActionObj.ActionName="登陆")||(ActionObj.ActionName="获取医院列表")) d
	i (ActionObj.ActionCode<30000) d
	.s res=..RunMethod(RequestCode,RequestXML)
	.
	q res
}

ClassMethod RunMethod(ActionCode As %String = "", Param As %String = "") As %String
{
	q ##class(DHCCL.Mobile.Web.RunMethod).RunMethod(ActionCode,Param)
}

}
