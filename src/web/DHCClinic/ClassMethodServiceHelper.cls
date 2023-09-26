/// 用来生成ClassMethodService.RunServerMethod的加密字符串
Class web.DHCClinic.ClassMethodServiceHelper Extends %CSP.Page [ ClassType = "", Not ProcedureBlock ]
{

Parameter CHARSET = "utf-8";

ClassMethod OnPage() As %Status
{
	w ##class(websys.Page).Encrypt($LB("web.DHCClinic.ClassMethodService.RunClassMethod"))
	//cspRunSe....方法经websys.Broker.cls中转后 Arg...参数不正确，websys.Broker未修正情况下 先用 先修改成 web.DHCClinic.ClassMethodService.RunClassMethod2  //2023-02-16 cryze
	//w ##class(websys.Page).Encrypt($LB("web.DHCClinic.ClassMethodService.RunClassMethod2"))
	Quit $$$OK
}

/// 需要先调用平台方法重写session
ClassMethod OnPreHTTP() As %Library.Boolean
{
	i ##Class(websys.SessionEvents).SessionExpired() q 1
	quit 1
}

}
