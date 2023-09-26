/// 名称: DHCHAI.Abstract
/// 描述: 所有类的抽象父类
Class DHCHAI.Abstract Extends %RegisteredObject [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// 默认分隔符
Parameter SEPARATE = "^";

Method ListFromString(STR As %String, SEPA As %String) As %List
{
	New (STR,SEPA)
	Set return=""
	For Ind=1:1:$l(STR,SEPA) {
		Set StrSub=$p(STR,SEPA,Ind)
		Set return=return_$lb(StrSub)
	}
	Quit return
}

Method ListToString(STR As %List, SEPA As %String) As %String
{
	New (STR,SEPA)
	Set return=""
	For Ind=1:1:$listlength(STR) {
		Set StrSub=$listget(STR,Ind)
		Set return=return_SEPA_StrSub
	}
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
}

/// Creator：     陈剑波
/// CreatDate：   2022-09-30
/// Description:  公共方法实体类调用方法取字段翻译结果,如没有session的语言参数，默认取中文翻译结果
/// Input：       aProp:数据字段名称
/// Input：       aDesc:对照的原数据
/// Input：       aClassName:对照的原数据，不传类名使用当前调用类名称
/// Input：       aLangId:翻译语言类型,默认取中文翻译
/// Return：      对照后的翻译结果     
/// w ##Class(DHCHAI.Abstract).HAIGetTranByDesc("MRCIDDesc","伤寒","User.MRCICDDx",1)
ClassMethod HAIGetTranByDesc(aProp As %String, aDesc As %String, aClassName As %String = "", aLangId As %String = "") As %String
{
	New (aProp,aDesc,aClassName,aLangId,%session)
	if ##class(websys.Conversions).IsValidMethodName("web.DHCBL.BDP.BDPConfig","GetConfigValue"){
		 Set Flag =##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPTranslation")
		 Quit:Flag="N" aDesc
	}
	Q:'##class(websys.Conversions).IsValidMethodName("web.DHCBL.Authorize.BDPTranslation","GetTransDesc") aDesc
	Set:aClassName="" aClassName = $classname()
	If $d(%session),$d(%session.Data("LOGON.LANGID")) {
		Set aLangId = %session.Data("LOGON.LANGID")
	}
	If aLangId="" Set aLangId=20
	Set Languages=$p($g(^SS("LAN",aLangId)),"^",1)
	Q ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc(aClassName,aProp,Languages,aDesc)
 	Q aDesc
}

/// Creator：     陈剑波
/// CreatDate：   2023-03-08
/// Description:  公共方法实体类调用方法取原始描述值,如没有session的语言参数，默认为中文
/// Input：       aProp:数据字段名称
/// Input：       aDesc:翻译后的数据
/// Input：       aClassName:表结构类名，不传类名使用当前调用类名称
/// Input：       aLangId:翻译语言类型,默认取中文
/// Return：      翻译内容的原始值     
/// w ##Class(DHCHAI.Abstract).HAIGetKeyByTranDesc("BTDesc","upper respiratory tract infection","DHCHAI.BT.InfPos",1)
ClassMethod HAIGetKeyByTranDesc(aProp As %String, aDesc As %String, aClassName As %String = "", aLangId As %String = "") As %String
{
	New (aProp,aDesc,aClassName,aLangId,%session)
	if ##class(websys.Conversions).IsValidMethodName("web.DHCBL.BDP.BDPConfig","GetConfigValue"){
		 Set Flag =##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPTranslation")
		 Quit:Flag="N" aDesc
	}
	Q:'##class(websys.Conversions).IsValidMethodName("web.DHCBL.Authorize.BDPTranslation","GetBeforeTransDesc") aDesc
	Set:aClassName="" aClassName = $classname()
	If $d(%session),$d(%session.Data("LOGON.LANGID")) {
		Set aLangId = %session.Data("LOGON.LANGID")
	}
	If aLangId="" Set aLangId=20
	Set Languages=$p($g(^SS("LAN",aLangId)),"^",1)
	//Quit ##class(web.DHCBL.Authorize.BDPTranslation).GetBeforeTransDesc(classname,prpname,langid,trans)
	Q ##class(web.DHCBL.Authorize.BDPTranslation).GetBeforeTransDesc(aClassName,aProp,Languages,aDesc)
 	Q aDesc
}

/// Creator：     陈剑波
/// CreatDate：   2022-09-30
/// Description:  公共方法实体类调用方法取字段翻译结果,如没有session的语言参数，默认取中文翻译结果
/// Input：       aProp:数据字段名称
/// Input：       aDesc:对照的原数据
/// Input：       aClassName:对照的原数据，不传类名使用当前调用类名称
/// Input：       aLangId:翻译语言类型,默认取中文翻译
/// Return：      对照后的翻译结果     
/// w ##Class(DHCHAI.Abstract).TranslationGet("dhcma.hai.ir.patscreening.csp","待处理")
ClassMethod TranslationGet(aCspName As %String, aDesc As %String) As %String
{
	New (aCspName,aDesc,%session)
	Quit:aDesc="" aDesc
	if ##class(websys.Conversions).IsValidMethodName("web.DHCBL.BDP.BDPConfig","GetConfigValue"){
		 Set Flag =##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPTranslation")
		 Quit:Flag="N" aDesc
	}
	Q:'##class(websys.Conversions).IsValidMethodName("websys.Translation","Get") aDesc
	Q ##class(websys.Translation).Get(aCspName,aDesc)
 	Q aDesc
}

}
