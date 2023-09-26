/// 名称: DHCMA.CPW.IO.CommonRef
/// 描述: 引用外部公共接口类
/// 编写者：yankai
/// 编写日期: 2023-03-14
Class DHCMA.CPW.IO.CommonRef Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zqy
/// CreatDate：   2023-3-2
/// Description:  多语言翻译-取产品类字段翻译
/// Return:		  
/// w ##class(DHCMA.CPW.IO.CommonRef).GetTranByCPWClass("DHCMA.CPW.BT.PathVarCat","BTDesc","变异原因",1,2)
ClassMethod GetTranByCPWClass(aClass As %String, aBTDesc As %String, aDesc As %String, aLangID As %String, aHospID As %String = "") As %String
{
	New (aClass,aBTDesc,aDesc,aLangID,aHospID,%session)
	Set return=aDesc
	Quit:((aBTDesc="")||(aDesc="")||(aLangID="")||(aClass="")) return
	Set:((aHospID="")&&($d(%session))) aHospID=$g(%session.Data("LOGON.HOSPID"))
	Set ret=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWTranIsEnable",aHospID)	
	if (ret="Y"){
		Set exp="set return=##class("_aClass_").GetTranByDesc("_$c(34)_aBTDesc_$c(34)_","_$c(34)_aDesc_$c(34)_","_aLangID_")"
		x exp
	}
	Quit return
}

/// Creator：     zqy
/// CreatDate：   2023-3-2
/// Description:  多语言翻译-后台添加或获取csp文件中对应内容翻译
/// Return:		
/// w ##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("dhcma.cpw.bt.pathcompledit.csp","变异原因",2)
ClassMethod GetTranByCsp(aCsp As %String, aDesc As %String, aLangID As %String, aHospID As %String = "") As %String
{
	New (aCsp,aDesc,aLangID,aHospID,%session)
	Set return=aDesc
	Quit:((aCsp="")||(aDesc="")||(aLangID="")) return
	Set:((aHospID="")&&($d(%session))) aHospID=$g(%session.Data("LOGON.HOSPID"))
	Set ret=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWTranIsEnable",aHospID)	
	if (ret="Y"){
		Set exp="set return=##class(websys.Translation).Get("_$c(34)_aCsp_$c(34)_","_$c(34)_aDesc_$c(34)_","_aLangID_")"
		x exp
	}
	Quit return
}

/// Creator：     zqy
/// CreatDate：   2023-3-2
/// Description:  多语言翻译-取HIS基础数据对应翻译
/// Return:	
/// w ##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.CTCareProv","CTPCPDesc","石亚飞","EN",2)
ClassMethod GetTranByUserClass(aClass As %String, aBTDesc As %String, aDesc As %String, aLanguages As %String, aHospID As %String = "") As %String
{
	New (aClass,aBTDesc,aDesc,aLanguages,aHospID,%session)
	Set return=aDesc
	Quit:((aClass="")||(aBTDesc="")||(aDesc="")||(aLanguages="")) return
	Set:((aHospID="")&&($d(%session))) aHospID=$g(%session.Data("LOGON.HOSPID"))
	Set ret=##class(DHCMA.Util.BT.Config).GetValueByCode("CPWTranIsEnable",aHospID)	
	if (ret="Y"){
		Set exp="set return=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("_$c(34)_aClass_$c(34)_","_$c(34)_aBTDesc_$c(34)_","_$c(34)_aLanguages_$c(34)_","_$c(34)_aDesc_$c(34)_")"
		x exp
	}
	Quit return
}

}
