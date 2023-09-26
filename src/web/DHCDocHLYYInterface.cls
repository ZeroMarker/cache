Class web.DHCDocHLYYInterface Extends DHCDoc.Util.RegisteredObject
{

/// w ##class(web.DHCDocHLYYInterface).Init()
ClassMethod Init(AdmDepRowid As %String, Layout = "OEOrd") As %String
{
	k RetjsonAry
	/*
	s HLYYAdmDep=..%GetConfig("DTAdmDep")    //合理用药科室权限
 	Set DTDepNotDoUpLoad="0"
 	Set HLYYYDTS="0"       //药典提示
 	Set HLYYXHZY="0"       //相互作用
 	Set HLYYUpLoad="0"     //下医嘱审核
 	Set HLYYInterface="0"  //合理用药标志
 	Set CurrCompanyCode=""
 	//获取美康审查方式
 	s McSynCheckMode=..%GetConfig("McSynCheckMode")
 	//合理用药涉及的后台数据获取或保存方法
 	s GetPrescXML=""
 	s GetDTYDTS=""
 	s BaseInfo=""
 	//初始化需返回的数组值
 	s RetjsonAry("HLYYInterface")=$g(HLYYInterface)
	s RetjsonAry("CurrCompanyCode")=$g(CurrCompanyCode)
	s RetjsonAry("DTDepNotDoUpLoad")=$g(DTDepNotDoUpLoad)
	s RetjsonAry("McSynCheckMode")=$g(McSynCheckMode)
	s RetjsonAry("GetPrescXML")=$g(GetPrescXML)
	s RetjsonAry("GetDTYDTS")=$g(GetDTYDTS)
	s RetjsonAry("BaseInfo")=$g(BaseInfo)
 	
 	s CurrCompany=..%GetConfig("CurrCompany")
 	s DTCheckCNMed=..%GetConfig("DTCheckCNMed")
	s CurrCompanyCode=$p(CurrCompany,"^",2)   //合理用药厂商选择
	s CurrCompanyCode=$$ALPHAUP^SSUTIL4(CurrCompanyCode)
	if CurrCompanyCode="" {
		Quit ##Class(DHCDoc.Util.FromJSON).GetArrJson(.RetjsonAry)
	}
	if (Layout="CMOEOrd")&&(DTCheckCNMed'="1"){
		Quit ##Class(DHCDoc.Util.FromJSON).GetArrJson(.RetjsonAry)
	}
 	i (HLYYAdmDep'="")&("^"_HLYYAdmDep_"^"[("^"_AdmDepRowid_"^")){
	 	s HLYYInterface="1"
	 	;按产家代码新增载入函数,在此自动根据产家代码执行
		s ExecLoadCompanyFileMothod="set ret=..Load"_CurrCompanyCode_"()"
		x ExecLoadCompanyFileMothod

	 	;按版本处理后台数据获取或保存方法
	 	s GetPrescXML="web.DHCDocHLYY"_CurrCompanyCode_".GetPrescXML"
	 	s GetDTYDTS="web.DHCDocHLYY"_CurrCompanyCode_".GetDTYDTS"
	 	s BaseInfo="web.DHCDocHLYY"_CurrCompanyCode_".GetBaseInfo"
	 	s RetjsonAry("GetPrescXML")=##Class(websys.Page).Encrypt($lb(GetPrescXML))
		s RetjsonAry("GetDTYDTS")=##Class(websys.Page).Encrypt($lb(GetDTYDTS))
		s RetjsonAry("BaseInfo")=##Class(websys.Page).Encrypt($lb(BaseInfo))
		
	 	s DTDepNotDoStr=..%GetConfig1("DTAdmDep",AdmDepRowid)
	 	s DTDepNotDoYDTS=$p(DTDepNotDoStr,"^",1)
	 	s DTDepNotDoXHZY=$p(DTDepNotDoStr,"^",2)
		s DTDepNotDoUpLoad=$p(DTDepNotDoStr,"^",3)
		
		;引用不同厂家或同厂家不同版本的js
		w "<script type='text/javascript' src='../scripts/dhcdoc/DHCDocHLYY"_CurrCompanyCode_".js'></script>",!
	}
	s RetjsonAry("HLYYInterface")=$g(HLYYInterface)
	s RetjsonAry("CurrCompanyCode")=$g(CurrCompanyCode)
	s RetjsonAry("DTDepNotDoUpLoad")=$g(DTDepNotDoUpLoad)
	*/
	;使用对外接口接入管理配置,初始化合理用药
	s RetjsonAry("HLYYInterface")="0"
	s HospitalId=$p($g(^CTLOC(AdmDepRowid)),"^",22)
	s LinkInfo=##class(DHCDoc.Interface.AccessManage).GetAccessLinkInfo("Company","HLYY",HospitalId,Layout,AdmDepRowid)
	if (LinkInfo["CompanyCode") {
		s RetjsonAry("HLYYInterface")="1"
	}
	Q ##Class(DHCDoc.Util.FromJSON).GetArrJson(.RetjsonAry)
}

/// 加载美康程序
ClassMethod LoadMK()
{
	//w "<link rel='stylesheet' type='text/css' href='../CUSTOM/PassJs/McCssAll.css' />" ,!  
	//w "<script type='text/javascript' src='../CUSTOM/PassJs/McConfig.js'></script>",!
	//w "<script type='text/javascript' src='../CUSTOM/PassJs/McJsAll.js'></script>",!
	w "<script type='text/javascript' src='../CUSTOM/PassJs/McLoader.js'></script>",!
	Quit 1
}

/// 加载大通程序
ClassMethod LoadDT()
{
	w "<object id='CaesarComponent' classid='clsid:8C028072-4FD2-46AE-B6D2-63E9F9B4155F' codebase = '../addins/client/dtywzxUIForMS.cab#version1.0.0.1'>"
    w "</object>"
    Q 1
}

/// 加载大通BS版本程序
ClassMethod LoadDTBS()
{
	w "<object id='DtObject' style='display:none' classid='clsid:862DC7EE-F440-4093-B591-E5FCAE890162' codebase = '../addins/client/CRMS_UIForMS.CAB#version=1.0.0.1#RegisterServer=yes#DestDir=""'>"
    w "</object>"
    Q 1
}

/// 加载杭州逸曜程序
ClassMethod LoadHZYY()
{
	Q 1
}

ClassMethod GetArcimInfo(ARCIMRowid As %String) As %String
{
	s OrderName=$P(^ARCIM(+ARCIMRowid,$P(ARCIMRowid,"||",2),1),"^",2)
	s ARCIMCode=$P(^ARCIM(+ARCIMRowid,$P(ARCIMRowid,"||",2),1),"^",1)
	q ARCIMCode_"^"_OrderName
}

/// 加载新产品组的合理用药
ClassMethod LoadDHC()
{
	w "<link rel='stylesheet' href='../scripts/dhcnewpro/dhcckb/css/pdss.css'/>" ,!  
	w "<script type='text/javascript' src='../scripts/dhcnewpro/dhcckb/pdss.js'></script>",!
	w "<script type='text/javascript' src='../scripts/dhcnewpro/dhcpresc/auditpopup.js' charset='gb2312'></script>",!
	Quit 1
}

}
