/// 用来生成ClassMethodService.RunServerMethod的加密字符串
Class web.DHCHM.ClassMethodServiceHelper Extends %CSP.Page
{

Parameter CHARSET = "utf-8";

ClassMethod OnPage() As %Status
{
	w ##class(%CSP.Page).Encrypt($LB("web.DHCHM.ClassMethodService.RunClassMethod"))
	Quit $$$OK
}

}
