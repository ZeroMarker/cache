/// 名称: DHCHAI.ClassMethodServiceHelper
/// 描述: 用来生成ClassMethodService.RunServerMethod的加密字符串
Class DHCHAI.ClassMethodServiceHelper Extends %CSP.Page [ ClassType = "", Not ProcedureBlock ]
{

Parameter CHARSET = "utf-8";

ClassMethod OnPage() As %Status
{
	w ##class(websys.Page).Encrypt($LB("DHCHAI.ClassMethodService.RunClassMethod"))
	Quit $$$OK
}

}
