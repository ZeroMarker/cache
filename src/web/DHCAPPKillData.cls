Import SQLUser

/// Creator: 	 bianshuai
/// CreateDate:  2017-01-23
/// Descript:    检查申请清数据类
/// 
/// 检查申请清除业务数据
/// D ##Class(web.DHCAPPKillData).killAppBusiData()
/// 
/// 检查申请清除基础数据
/// D ##Class(web.DHCAPPKillData).killAppBaseData()
/// 
/// 病理申请清除业务数据
/// D ##Class(web.DHCAPPKillData).killPisBusiData()
/// 
/// 病理申请清除基础数据
/// D ##Class(web.DHCAPPKillData).killPisBaseData()
/// 
Class web.DHCAPPKillData Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript: 检查申请清除业务数据
/// D ##Class(web.DHCAPPKillData).killAppBusiData()
ClassMethod killAppBusiData()
{
	/// 检查申请 DHC_AppReport
	k ^DHCAPREP
	k ^mdata("DHCAPPREPORT")
	
	k ^DHCAPREPO
	k ^mdata("DHCAPPREPPOS")
	
	/// 检查申请 病人体征
	k ^DHCAPPATSI
	k ^mdata("DHCAPPPATSIGNS")
	
	/// 检查申请 病人现病史
	k ^DHCAPPREH
	k ^mdata("DHCAPPPREHIS")
	
	/// 检查申请 病人主诉
	k ^DHCAPPATSY
	k ^mdata("DHCAPPPATSYMPTOM")
	
	/// 检查申请 Html内容表
	k ^DHCAPRHV
	k ^mdata("DHCAPPPATSYMPTOM")
	
	/// 检查申请 收费记录表
	k ^DHCAPREPTA
	k ^mdata("DHCAPREPTA")
	
	/// 检查申请 病人主诉模板表   sufan  增加清模板数据
	k ^DHCAPPATSYT
	k ^mdata("DHCAPPPATSYMTEMP")
	
	/// 检查申请 病人现病史模板表
	k ^DHCAPPREHT
	k ^mdata("DHCAPPPATPREHISTEMP")
	
	/// 检查申请 病人体征模板表
	k ^DHCAPATST
	k ^mdata("DHCAPPPATSIGNSTEMP")
		
	Q ""
}

/// Descript: 检查申请清除基础数据
/// D ##Class(web.DHCAPPKillData).killAppBaseData()
ClassMethod killAppBaseData()
{
	/// 部位表 DHC_AppPart、DHC_AppPartItm
	k ^DHCAPPART
	k ^mdata("DHCAppPart")
	
	/// 检查分类表 DHC_AppArcCat  检查分类主表不再清除 2019-01-16 bianshuai
	//k ^DHCAPARCCA
	//k ^mdata("DHCAppArcCat")
	
	/// 检查分类和其他项目关联表 DHC_AppCatLinkOpt
	k ^DHCAPCATO
	
	/// 后处理方法 DHC_AppDispMedthod
	k ^DHCAPDIM
	k ^mdata("DHCAPPDISPMEDTHOD")
	
	/// 体位 DHC_AppPosition
	k ^DHCAPPOS
	k ^mdata("DHCAPPPOSITION")
	
	/// 注意事项 DHC_AppItemTemp、DHC_AppItemTempD
	k ^DHCAPITMTE
	k ^mdata("DHCAPPITEMTEMP")
	
	/// 其它项目字典表 DHC_AppOtherOpt、DHC_AppOtherOptItm
	k ^DHCAPOTHO
	k ^mdata("DHCAPPOTHEROPT")
	
	/// 医嘱项与注意事项关联 DHC_AppArcNote
	k ^DHCAPARCNO
	k ^mdata("DHCAPPARCNOTE")
	
	/// 医嘱项与后处理关联 DHC_AppArcLinkDisp
	k ^DHCAPARCDI
	k ^mdata("^DHCAPPARCLINKDISP")
	
	/// 医嘱项与体位关联 DHC_AppArcLinkPos
	k ^DHCAPARCPO
	k ^mdata("^DHCAPARCPO")
	
	/// 医嘱项与其它项目关联 DHC_AppArcLinkOpt
	k ^DHCAPARCO
	k ^mdata("DHCAPARCO")
	
	/// 检查分类树维护表 DHC_AppTreeAdd、DHC_AppTreeLink
	k ^DHCAPPTRA
	k ^mdata("DHCAPPTREEADD")
	
	/// 检查医嘱项与部位对照表 DHC_AppArcLink
	k ^DHCAPARCL
	k ^mdata("DHCAPPARCLINK")
	
	/// 检查医嘱项与收费项对照表 DHC_AppArcLinkTar
	k ^DHCAPARCLTA
	k ^mdata("DHCAPARCLTA")
	
	/// 检查项目与打折系数维护 DHC_AppArcDisc
	k ^DHCAPARCDIS
	k ^mdata("DHCAPARCDIS")
	
	/// 检查体位关联收费项目 DHC_AppPosLinkTar
	k ^DHCAPPOSTAR
	k ^mdata("DHCAPPOSTAR")
	
	/// 检查后处理方法关联收费项目 DHC_AppMedLinkTar
	k ^DHCAPMEDTAR
	k ^mdata("^DHCAPPMEDTAR")
	
	/// 检查申请单Html格式内容表 DHC_AppRepHtmlView
	k ^DHCAPRHV
	k ^mdata("DHCAPPREPHTMLVIEW")
	
	/// 检查医嘱项维护 DHC_AppArcAdd
	k ^DHCAPPARA
	k ^mdata("DHCAPPARCADD")
	
	/// 检查分类子表 DHC_AppCatLinkOrd
	//k ^DHCAPARCCA
	//k ^mdata("DHCAPPCATLINKORD")
	&SQL(DELETE FROM DHC_AppCatLinkOrd)
	
	/// 检查分类与医嘱项关联表 DHC_AppCatLinkArcItm
	&SQL(DELETE FROM DHC_AppCatLinkArcItm)
	
#;	/// 检查分类与打印模板关联表  DHC_AppPrtTemp
#;	k ^DHCAPPPRT
#;	k ^mdata("DHCAPPPRTTEMP")
		
	Q ""
}

/// Descript: 病理申请清除业务数据
/// D ##Class(web.DHCAPPKillData).killPisBusiData()
ClassMethod killPisBusiData()
{
	/// 病理申请主表  DHC_AppPisMaster
	k ^DHCAPPPM	
	k ^mdata("DHCAPPPISMASTER")
	
	/// HPV治疗方式 DHC_AppPisTreMet
	k ^DHCAPPPTM
	k ^mdata("DHCAPPPISTREMET")

	/// 检测方法 DHC_AppPisTesMet
	k ^DHCAPPPTIM
	k ^mdata("DHCAPPPISTESMET")

	///传染病史  DHC_AppPisInfDis
	k ^DHCAPPPID
	k ^mdata("DHCAPPPISINFDIS")

	/// 病人病历 DHC_AppPisPatRec
	k ^DHCAPPPPR
	k ^mdata("DHCAPPPISPATREC")

	/// 临床诊断 DHC_AppPisTesDiag
	k ^DHCAPPPTD
	k ^mdata("DHCAPPPISTESDIAG")

	/// 检测方法 DHC_AppPisTesItm
	k ^DHCAPPPTI
	k ^mdata("DHCAPPPISTESITM")
	
	/// 检查申请结果 DHC_AppRepResult
	k ^DHCAPPRR
	k ^mdata("DHCAPPREPRESULT")

	/// 检查申请状态记录 DHC_AppRepLog
	k ^DHCAPPRL
	k ^mdata("DHCAPPREPLOG")
	
	/// 记录打印次数
	k ^DHCDocAPPPisPrintNum
	Q ""
}

/// Descript: 病理申请清除基础数据
/// D ##Class(web.DHCAPPKillData).killPisBaseData()
ClassMethod killPisBaseData()
{
	/// 治疗方式 DHC_AppTreMet
	k ^DHCAPPTM
	k ^mdata("DHCAPPTREMER")

	/// 病理申请状态字典表 DHC_APPTestStatus
	//k ^DHCAPPTST
	//k ^mdata("DHCAPPTESTSTATUS")

	/// 临床诊断 DHC_AppTesDiag
	k ^DHCAPPTD
	k ^mdata("DHCAPPTESDIAG")

    /// 检测方法 DHC_AppTesItmMet
	k ^DHCAPPTIM
	k ^mdata("DHCAppTESITMMET")

	/// 分子病理检测项目 DHC_AppTestItem
	k ^DHCAPPTI
	k ^mdata("^DHCAPPTI")

	/// 检测项目分类表 DHC_AppTestCat
	k ^DHCAPPTC
	k ^mdata("DHCAPPTESTCAT")

	/// 病理标本字典 DHC_AppTestSpec
	//k ^DHCAPPTS
	//k ^mdata("^DHCAPPTS")

	/// 检测项目套餐字典表 DHC_APPTestPack、DHC_APPTestPackItm
	k ^DHCAPPTP
	k ^mdata("DHCAPPTESTPACK")

	/// 病人病历字典表 DHC_AppPatRec
	k ^DHCAPPPR
	k ^mdata("DHCAPPPATREC")

	/// 取材字典表 DHC_AppCutBas
	k ^DHCAPPCB
	k ^mdata("DHCAPPCUTBAS")
	
	/// 检查状态和PIS系统状态对照表 DHC_AppStatContrast
	//k ^DHCAPPSC
	//k ^mdata("DHCAPPSC")

	/// 病人病历分类字典表 DHC_APPCaseClass
	k ^DHCAPPCC
	k ^mdata("DHCAPPCC")
	
	/// 病理标本玻片类型字典表（外院） DHC_APPSpecSlideType
	k ^DHCAPPSST
	k ^mdata("DHCAPPSST")
	
	/// 传染病字典表 DHC_AppInfDis
	k ^DHCAPPID
	k ^mdata("DHCAPPINFDIS")
	
	///病理基本设置
	///k ^DHCDocAppConfig
	
	///分子明细项目
	//k ^DHCAPPCellItemLink
	//k ^DHCAPPCellItemLinki
	
	/// 细胞学标本字典表关联医嘱项
	k ^DHCAppTestSpecRelArc
	Q ""
}

}
