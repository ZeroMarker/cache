Include DHCDoc

/// Filename         :DHCDoc.Util.RegisteredObject.cls
/// Description      :业务类的基类，提供命令式的公共方法、全局变量、产品通用方法等
/// Time             :2021/04/16
/// Author           :tanjishan
Class DHCDoc.Util.RegisteredObject Extends %RegisteredObject
{

/// Description      :获取医生站命令行帮助工具
/// Author           :lixiangzong
/// Time             :2022/07/12
/// debugger         :w ##Class(DHCDoc.Util.RegisteredObject).%DocHelp("")
ClassMethod %DocHelp(Args...) As %String
{
    //s ArgsLength=$G(Args)
    quit ##Class(DHCDoc.Util.cmd).DocHelp(Args...)
}

/// Description      :获取医生站常规配置
/// Author           :tanjishan
/// Time             :2021/04/16
/// debugger         :w ##Class(DHCDoc.Util.RegisteredObject).%GetConfig("OrderEntryLock",2,3)
ClassMethod %GetConfig(Args...) As %String
{
    //s ArgsLength=$G(Args)
    quit ##Class(web.DHCDocConfig).GetConfigNode(Args...)
}

ClassMethod %GetConfig1(Args...) As %String
{
    quit ##Class(web.DHCDocConfig).GetConfigNode1(Args...)
}

/// 获取系统格式日期
ClassMethod %SysDate() As %String
{
    quit +$H
}

/// 获取系统格式时间
ClassMethod %SysTime() As %String
{
    quit $P($H,",",2)
}

/// 转换为前台展示的日期
ClassMethod %ZD(%Date As %String) As %String
{
    if ..%IsValidMethod("websys.Conversions","DateLogicalToHtml"){
        quit ##class(websys.Conversions).DateLogicalToHtml(%Date)
    }else{
        quit $ZD(%Date,..%DateFormat())
    }
}

/// 转换为系统日期
ClassMethod %ZDH(%Date As %String) As %String
{
    if ..%IsValidMethod("websys.Conversions","DateHtmlToLogical"){
        quit ##class(websys.Conversions).DateHtmlToLogical(%Date)
    }else{
        quit $ZDH(%Date,..%DateFormat())
    }
}

/// 转换为前台展示的时间
ClassMethod %ZT(%Time As %String, TimeFormat As %String = "") As %String
{
    if (..%IsValidMethod("websys.Conversions","TimeLogicalToHtml")){
        quit ##class(websys.Conversions).TimeLogicalToHtml(%Time,TimeFormat)
    }else{
        quit $ZT(%Time,TimeFormat)
    }
}

/// 转换为系统时间
ClassMethod %ZTH(%Time As %String, TimeFormat As %String = "") As %String
{
    if (..%IsValidMethod("websys.Conversions","TimeHtmlToLogical")){
        quit ##class(websys.Conversions).TimeHtmlToLogical(%Time,TimeFormat)
    }else{
        quit $ZTH(%Time,TimeFormat)
    }
}

ClassMethod %DateFormat() As %String
{
    if ..%IsValidMethod("websys.Conversions","DateFormat"){
        quit ##class(websys.Conversions).DateFormat()
    }else{
        quit 4
    }
}

ClassMethod %IsValidClass(%ClassName) As %String
{
    quit ##class(websys.Conversions).IsValidClassName(%ClassName)
}

ClassMethod %IsValidMethod(%ClassName, %MethodName) As %String
{
    quit ##class(websys.Conversions).IsValidMethodName(%ClassName,%MethodName)
}

ClassMethod %IsValidQuery(%ClassName, %QueryName) As %String
{
    quit ##class(websys.Conversions).IsValidQueryName(%ClassName,%QueryName)
}

/// Description      :获取当前配置的翻译语言
/// Author           :tanjishan
/// Time             :2021/04/16
ClassMethod %LanguageID() As %String
{
    Set langid=20
    if ($d(%session))&&($d(%session.Data)){
        set langid=+$g(%session.Data("LOGON.LANGID"))
    }
    q langid
}

/// websys.js->GetSessionStr\websys_getSessionStr
/// DHCDoc.Util.RegisteredObject->%SessionStr
/// 获取SessionStr,请保持三处方法统一
ClassMethod %SessionStr() As %String
{
    s $ZT="SessionStrErr"
    s Str=""
    if ('$d(%session) || ('$d(%session.Data))){
        q Str
    }
    
    if ..%IsValidMethod("BSP.SYS.SRV.Session","GetSessionStr"){
        s Str = ##class(BSP.SYS.SRV.Session).GetSessionStr()
    }else{
        if ($d(%session)&&($d(%session.Data))){
            s Str =%session.Data("LOGON.USERID")
            s Str =Str _ "^" _ %session.Data("LOGON.GROUPID")
            s Str =Str _ "^" _ %session.Data("LOGON.CTLOCID")
            s Str =Str _ "^" _ %session.Data("LOGON.HOSPID")
            s Str =Str _ "^" _ %session.Data("LOGON.WARDID")
            s Str =Str _ "^" _ %session.Data("LOGON.LANGID")
            s Str =Str _ "^" _ %session.Data("LOGON.SSUSERLOGINID")
            s Str =Str _ "^" _ ""			;docunitid
            s Str =Str _ "^" _ %session.SessionId
    }
    }
    q Str
SessionStrErr
    s $ZT=""
    q ""
}

/// 根据错误代码获取错误描述
ClassMethod %GetErrCodeMsg(errCode As %String, className As %String = "")
{
    s:className="" className=$CLASSNAME()
    Q ##Class(web.DHCDocErrCodeRegister).GetErrCodeMsg(className,errCode)
}

/// 翻译
ClassMethod %Translate(Args...)
{
    Q ##class(websys.Translation).Get(Args...)
}

}
