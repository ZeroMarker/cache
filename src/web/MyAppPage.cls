Class web.MyAppPage Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
    Write "<html>",!
    Write "<body>",!
    Write "My page1",!
    Write "</body>",!
    Write "</html>",!
    Write "sessionId:===="_%session.SessionId_"</br>"
    w "session.NewSession===="_%session.NewSession_"</br>"
    w "LicenseId======="_%session.LicenseId_"</br>"
    w "KeepAlive======="_%session.KeepAlive_"</br>"
    w "Application======="_%session.Application_"</br>"
    w "BrowserName======="_%session.BrowserName_"</br>"
    w "BrowserPlatform======="_%session.BrowserPlatform_"</br>"
    w "BrowserVersion======="_%session.BrowserVersion_"</br>"
    w "CSPSessionCookie======="_%session.CSPSessionCookie_"</br>"    
    w "Debug======="_%session.Debug_"</br>"
    w "EndSession======="_%session.EndSession_"</br>"
    w "ErrorPage======="_%session.ErrorPage_"</br>"
    w "EventClass======="_%session.EventClass_"</br>"
    w "HttpAuthorization======="_%session.HttpAuthorization_"</br>"
    w "Key======="_%session.Key_"</br>"
    w "Language======="_%session.Language_"</br>"
    
    w "Namespace======="_%session.Namespace_"</br>"
    w "NewSession======="_%session.NewSession_"</br>"
    w "session.Username:======"_%session.Username_"</br>"
    w "session.UserAgent:====="_%session.UserAgent_"</br>"
    w "session.SecureSessionCookie======"_%session.SecureSessionCookie_"</br>"
    w "session.CreateTime"_%session.CreateTime_"</br>"
    w "LastModified======="_%session.LastModified_"</br>"
    w "ssssss============="_$ZD($zdh($p(%session.LastModified," ",1),3),11)_","_$zd($zdh($p(%session.LastModified," ",1),3),2)_" "_$zt(($zth($p(%session.LastModified," ",2),1)+%session.AppTimeout),1)_" GMT"_"</br>"
    w "ssssss1============="_$ZD($zdh($p(%session.LastModified," ",1),3),11)_","_$zd($zdh($p(%session.LastModified," ",1),3),2)_" "_$zt(($zth($p(%session.LastModified," ",2),1)+%session.AppTimeout),1)_" GMT"_"</br>"
    w "session.Key==========="_%session.Key_"</br>"
    w "session.ProcessId================="_%session.ProcessId_"<br>"
    w "Preserve======="_%session.Preserve_"</br>"
    w "Referrer======="_%session.Referrer_"</br>"
    w "RunNamespace======="_%session.RunNamespace_"</br>"
    w "SecureSessionCookie======="_%session.SecureSessionCookie_"</br>"
    w "UseSessionCookie======="_%session.UseSessionCookie_"</br>"
    w "UserAgent======="_%session.UserAgent_"</br>"
    ;w "session[username]="_%request.Data("username",1)_"</br>"
    ;s %session.AppTimeout=10
    w "AppTimeout="_$fn(%session.AppTimeout,"")_"</br>"
    w "UsernameGet()="_%session.UsernameGet()_"</br>"
    w "session[LOGON.TIMEOUT]="_360
    Do %response.SetCookie("NAME","VALUE",1,2)
    

    Quit $$$OK
}

}
