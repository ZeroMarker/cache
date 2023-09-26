/// 用来生成ClassMethodService.RunServerMethod的加密字符串
Class web.DHCANOP.ClassMethodServiceHelper Extends %CSP.Page [ ClassType = "", Not ProcedureBlock ]
{

Parameter CHARSET = "utf-8";

ClassMethod OnPage() As %Status
{
	w ##class(websys.Page).Encrypt($LB("web.DHCANOP.ClassMethodService.RunClassMethod"))
	Quit $$$OK
}

}
