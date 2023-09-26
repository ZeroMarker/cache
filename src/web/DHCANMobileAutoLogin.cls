Class web.DHCANMobileAutoLogin Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	;If ##Class(websys.SessionEvents).SessionExpired() Quit $$$ERROR($$$CSPSessionTimeout)
	s returnUrl=%request.Data("returnUrl",1)
	Set userId=%session.Get("LOGON.USERCODE")
	Set locId=%session.Get("LOGON.CTLOCID")
	
	s ^dhcAnMobileAutoLogin("LOGON.USERCODE")=userId
    Write "<html>",!
    Write "<body>",!
    Write "userName:",userId," locId:",locId,!
    Write "<script>",!
    s mobileServerIp="172.19.19.58"
    s url=mobileServerIp_"/ANMobile/Account/AutoLogIn?returnUrl="_returnUrl_"&userName="_userId_"&locId="_locId_""";"
    Write "window.location.href=""http://",mobileServerIp,"/ANMobile/Account/AutoLogIn?returnUrl=",returnUrl,"&userName=",userId,"&locId=",locId,""";",!
    Write "</script>",!
    Write "</body>",!
    Write "</html>",!
    Quit $$$OK
}

}
