/// 名称:     体检产品公共方法       
/// 编写者:   薛迎
/// 编写日期: 2022-09-20
Class web.DHCPE.CT.Public.PubFun Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:     yupeng
/// Description: 多语言后台数据翻译
/// Input：      cname:csp名或类名,pname:属性名,desc:需要翻译的汉字,type:翻译类型：csp或者cls
/// Output：     有平台类方法，返回翻译数据，无返回原值
/// CreatDate:   2022-11-24
/// Debug:  w ##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpedocpatient.station.hisui.csp","项目")
/// Debug:  w ##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEOrderDetail","身高","ODDesc","cls")
ClassMethod GetTranslationDesc(cname As %String, desc As %String, pname As %String = "", type As %String = "") As %String
{
    n (cname,pname,desc,type,%session)
    s $zt="GetTranslationDescErr"
    if $d(%session) {
        set langid=%session.Get("LOGON.LANGID")
    }
    else
    { s langid=""}
    
    q:langid="" desc
   
    if (type="cls")
    {
        q:pname="" desc
        s isexist=..IsValidMethodName(cname,"GetTranByDesc")
        if (isexist=1) q $zobjclassmethod(cname,"GetTranByDesc",pname,desc,langid)
        q desc
    }
    else
    {
        s isexist=..IsValidMethodName("websys.Translation","Get")
        if (isexist=1) q ##class(websys.Translation).Get(cname,desc,langid)
        q desc
    }
    q desc
GetTranslationDescErr
	q desc
}

/// Creator:     薛迎
/// Description: 判断类是否存在
/// Input：      classname:类名称,如"web.DHCPE.CT.Public.PubFun"
/// Output：     1:存在，0:不存在
/// CreatDate:   2022-09-20
/// Debug:  w ##class(web.DHCPE.CT.Public.PubFun).IsValidClassName("web.DHCPE.CT.Public.PubFun")
ClassMethod IsValidClassName(classname As %Library.String) As %Library.Boolean
{
    n (classname)
    q:(classname="") 0
    s myobj=##class(%Dictionary.CompiledClass).%OpenId(classname)
    s myrtn=0
    i ($IsObject(myobj)){
        s myobj=""
        s myrtn = 1
    }
    q myrtn
}

/// Creator:     薛迎
/// Description: 判断某个类方法是否存在
/// Input：      classname:类名称,如"web.DHCPE.CT.Public.PubFun"，methodname:类方法名称,如："IsValidMethodName"
/// Output：     1:存在，0:不存在
/// CreatDate:   2022-09-20
/// Debug: w ##class(web.DHCPE.CT.Public.PubFun).IsValidMethodName("web.DHCPE.CT.Public.PubFun","IsValidMethodName")
ClassMethod IsValidMethodName(classname As %Library.String, methodname As %Library.String) As %Library.Boolean
{
    n (classname, methodname)
    q:((classname="")||(methodname="")) 0
    s myobj=##class(%Dictionary.CompiledMethod).%OpenId(classname_"||"_methodname)
    s myrtn=0
    i ($IsObject(myobj))
    {
        s myobj=""
        s myrtn = 1
    }
    q myrtn
}

/// Creator:     薛迎
/// Description: 判断Query是否存在
/// Input：      classname:类名称,如"web.DHCPE.InvPrt",queryname：Query名称，如"FindInvPrtList"
/// Output：     1:存在，0:不存在
/// CreatDate:   2022-09-20
/// Debug:  w ##class(web.DHCPE.CT.Public.PubFun).IsValidQueryName("web.DHCPE.InvPrt","FindInvPrtList")
ClassMethod IsValidQueryName(classname As %Library.String, queryname As %Library.String) As %Library.Boolean
{
    n (classname, queryname)
    q:((classname="")||(queryname="")) 0
    s myobj=##class(%Dictionary.CompiledQuery).%OpenId(classname_"||"_queryname)
    s myrtn=0
    i ($IsObject(myobj))
    {
        s myobj=""
        s myrtn = 1
    }
    q myrtn
}

}
