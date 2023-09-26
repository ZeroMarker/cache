Class ext.websys.SessionEvents Extends websys.SessionEvents
{

ClassMethod OnEndSession()
{
	;s ^TMPSession("EndSession",$h,"Property")=..GetSessionProperty()
	i ($d(^TMPSession("Session",+$h,%session.SessionId))){
		k ^TMPSession("Session",+$h,%session.SessionId)
	}
	s ^TMPSession("Session",+$h, "COUNT")=+$g(^TMPSession("Session",+$h, "COUNT"))-1
}

/// called from websys.csp to clear/set any locked data when changing menus (not completing workflows)
ClassMethod websysMenuChange(newMenuId As %Library.String = "")
{
	d ##class(websys.SessionEvents).websysMenuChange(newMenuId)
}

/// Called when a new session is created and its values are initialised.
ClassMethod OnStartSession()
{
	if (+$g(^TMPSession("Session",+$h, "COUNT"))<=(+..#LicenseCount-1)){
		s ^TMPSession("Session",+$h,%session.SessionId)=""
	}
	s ^TMPSession("Session",+$h, "COUNT")=+$g(^TMPSession("Session",+$h, "COUNT"))+1
}

/// Called when a session that was in CSP application <var>oldapp</var> is now going to run a page in
/// CSP application <var>newapp</var>. If this returns an error value then instead of running the
/// page in the new application it will redirect to the error page (error page looked up from old application).
ClassMethod OnApplicationChange(oldapp As %String, newapp As %String) As %Status
{
	Quit $$$OK
}

/// Called when the CSP Daemon times out out this session before calling <method>EndSession</method>.
/// Use the %session object to examine this session. If you wish to
/// abort this deletion then:
/// <example>
/// Set %session.EndSession=0
/// </example>
ClassMethod OnTimeout()
{
	;s ^TMPSession("Session",+$h, "COUNT")=+$g(^TMPSession("Session",+$h, "COUNT"))-1
}

/// Wrapper to determine if there is a valid session
/// 用来验证是否 是否超期或者 超用户数
ClassMethod SessionExpired() As %Library.Boolean
{
	Q ##class(websys.SessionEvents).SessionExpired()
	s myflag=0
	
	;zhoacz
	;增加lisence控制
	;if ($g(^TMPSession("Session",+$h, "COUNT"))>..#LicenseCount){
		;q 0
	;}
	
	;s %session.EndSession=1
	s mysessionobj=##class(%CSP.Session).%OpenId(%session.SessionId)
	s myrlflag=(('$d(%session.Data("LOGON.USERID")))!($g(%session.Data("LOGON.USERID"))=""))
	;s myrlflag = (myrlflag)&&(%session.EndSession'=1)
	i (myrlflag){
		
		;add by wuqk 2010-11-19
		;如果是退出菜单，不校验session超时，直接关闭页面
		s mnu="",linkUrl=""
		s TMENU=$g(%request.Data("TMENU",1))
		s:TMENU mnu=##Class(websys.Menu).%OpenId(TMENU,0)
		s:mnu linkUrl=mnu.LinkUrl
		i ($ZCVT($g(linkUrl),"l")="websys.closesession.csp") {
			&javascript<#("<SCRIPT Language='JavaScript'>window.parent.close();</SCRIPT>")#>
			}
		else{
			;如果超时  弹出 ext.logon.csp,  重新登录成功后， 
			;调用 logonrefresh.csp 加载 epr.frames.csp
			;弹出新的登录窗体
			s %response.ServerSideRedirect="logonexpired.csp"
		}
		s myflag=1
	}
	
	q myflag
}

/// 获取当前Session的属性
ClassMethod GetSessionProperty() As %String [ Final ]
{
	s mystr=" EndSession = "_%session.EndSession_"; SessionId = "_%session.SessionId _" TimeOut= "_%session.AppTimeout_" EventClass=" _ %session.EventClass
	s mystr=mystr _";  Preserve= "_%session.Preserve_"; CookiePath = "_%session.CookiePath_"; Language = "_%session.Language
	s mystr=mystr_"; HttpAuthorization= "_%session.HttpAuthorization_";  KeepAlive= "_%session.KeepAlive_"; Application = "_%session.Application_" ;SecurityContext = "_%session.SecurityContext
	q mystr
}

Parameter LicenseCount = 20;

}
