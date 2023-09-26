Import SQLUser

/// Creator: 	 bianshuai
/// CreateDate:  2018-09-28
/// Descript:    会诊清数据类
/// 
/// 会诊清除业务数据
/// D ##Class(web.DHCEMConsKillData).killAppBusiData()
/// 
/// 会诊清除基础数据
/// D ##Class(web.DHCEMConsKillData).killAppBaseData()
/// 
Class web.DHCEMConsKillData Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript: 会诊清除业务数据
/// D ##Class(web.DHCEMConsKillData).killAppBusiData()
ClassMethod killAppBusiData()
{
	
	/// 会诊申请 DHC_EmConsult
	k ^DHCEMCON
	k ^mdata("DHCEMCONSULT")
	
	/// 会诊申请指症表 DHC_EmConsultInd
	k ^DHCEMCONI
	k ^mdata("DHCEMCONSULTIND")
	
	/// 会诊申请日志表 DHC_EmConsultLog
	k ^DHCEMCONL
	k ^mdata("DHCEMCONSULTLOG")
	
	/// 会诊申请小组成员 DHC_EmConsultUser
	k ^DHCEMCONU
	k ^mdata("DHCEMCONSULTUSER")
	
	/// 会诊意见模板表 DHC_EmConsOpinionTemp
	k ^DHCEMCOT
	k ^mdata("DHCEMCONSOPINIONTEMP")
	
	/// 会诊授权表 DHC_EmConsEmrAut
	k ^DHCEMCEA
	k ^mdata("DHCEMCONSEMRAUT")
}

/// Descript: 会诊清除基础数据
/// D ##Class(web.DHCEMConsKillData).killAppBaseData()
ClassMethod killAppBaseData()
{
	
#;	/// 会诊申请状态字典表 DHC_EmConsStatus
#;	k ^DHCEMCONS
#;	k ^mdata("DHCEMCONSSTATUS")
	
	/// MDT小组字典 DHC_EmConsultGroup
	k ^DHCEMCG
	k ^mdata("DHCEMCONSULTGROUP")
	
	/// MDT诊断配置 DHC_EmConsultDiag
	k ^DHCEMCD
	k ^mdata("DHCEMCONSULTDIAG")
	
	/// 会诊申请医嘱配置表 DHC_EmConsOrdConfig
	k ^DHCEMCONSOC
	k ^mdata("DHCEMCONSORDCONFIG")
	
#;	/// 会诊申请字典类型表 DHC_EmConsDicType
#;	k ^DHCEMCDT
#;	k ^mdata("DHCEMCONSDICTYPE")
#;	
#;	/// 会诊申请字典项目表 DHC_EmConsDicItem
#;	k ^DHCEMCDI
#;	k ^mdata("DHCEMCONSDICITEM")
	
	/// 医护人员会诊权限维护表 DHC_EmConsDocAut
	k ^DHCEMCDA
	k ^mdata("DHCEMCONSDOCAUT")
	
	/// 科室亚专业/指症关联表 DHC_EmConsLocItm
	k ^DHCEMCLI
	k ^mdata("DHCEMCONSLOCITM")
	
	/// 会诊外院科室关联表 DHC_EmConsHosLoc
	k ^DHCEMCHL
	k ^mdata("DHCEMCONSHOSLOC")
	
#;	/// 会诊函数表达式维护
#;	k ^DHCEMCONF
#;	k ^mdata("DHCEMCONSFUNCTION")
	
#;	/// 会诊工作流配置
#;	k ^DHCEMCONWF
#;	k ^mdata("DHCEMCONSWORKFLOW")

	/// 工作流前置条件
	k ^DHCEMCONPC
	k ^mdata("DHCEmConsPreCon")
	
	/// 工作流授权
	k ^DHCEMCONG
	k ^mdata("DHCEmConsGrant")
}

}
