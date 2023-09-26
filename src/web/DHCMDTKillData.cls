Import SQLUser

/// Creator: 	 bianshuai
/// CreateDate:  2019-04-15
/// Descript:    MDT会诊清数据类
/// 
/// MDT会诊清除业务数据
/// D ##Class(web.DHCMDTKillData).killMDTBusiData()
/// 
/// MDT会诊清除基础数据
/// D ##Class(web.DHCMDTKillData).killMDTBaseData()
/// 
Class web.DHCMDTKillData Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript: MDT会诊清除业务数据
/// D ##Class(web.DHCEMConsKillData).killMDTBusiData()
ClassMethod killMDTBusiData()
{
	
	/// MDT申请 DHC_MDTConsult、DHC_MDTConsultItm
	k ^DHCMDTCON
	;k ^mdata("DHCMDTCONSULT")
	
	/// MDT申请日志记录表 DHC_MDTLog
    k ^DHCMDTL
    ;k ^mdata("DHCMDTLOG")
    
    /// MDT医嘱费用表 DHC_MDTOrdBill
    k ^DHCMDTORD
    ;k ^mdata("DHCMDTORDBILL")
    
    /// MDT随访记录表 DHC_MDTFolUpSur
    ;k ^DHCMDTSS
    k ^DHCMDTFUV
    
    /// MDT数字签名表 DHC_MDTSignVerify
    k ^DHCMDTSV
    ;k ^mdata("DHCMDTSIGNVERIFY")
    
    ///文件上传
    k ^DHCMDTPCD
    k ^DHCMDTPATCHKDOCU
    
    ///资料审查会议模板
    k ^User.DHCMDTMeetTempD
    
    ///外院专家
    k ^DHCMDTCOE
}

/// Descript: MDT会诊清除基础数据
/// D ##Class(web.DHCEMConsKillData).killMDTBaseData()
ClassMethod killMDTBaseData()
{
	
	/// 疑难病种分组 DHC_MDTGroup、DHC_MDTGroupItm
	k ^DHCMDTG
	;k ^mdata("DHCMDTGROUP")
	
	/// 疑难病种分组与号别关联表 DHC_MDTCareProv
	k ^DHCMDTCP
	;k ^mdata("DHCMDTCAREPROV")
	
#;	/// MDT类型字典维护 DHC_MDTDicType
#;	k ^DHCMDTDT
#;	k ^mdata("DHCMDTDICTYPE")
	
#;	/// MDT项目字典维护 DHC_MDTDicItem
#;	k ^DHCMDTDI
#;	k ^mdata("DHCMDTDICITEM")
	
#;	/// MDT状态字典 DHC_MDTStatus
#;	k ^DHCMDTS
#;	k ^mdata("DHCMDTCONSSTATUS")

	/// MDT权限维护表 DHC_MDTDocAut
	k ^DHCMDTDA
	k ^mdata("DHCMDTDOCAUT")
	
	/// MDT医嘱配置 DHC_MDTOrdConfig
	k ^DHCMDTOC
	;k ^mdata("DHCMDTORDCONFIG")

	/// 病种随访次数维护 DHC_MDTFolUpVis
	k ^DHCMDTFUT
	;k ^mdata("DHCMDTFOLUPVIS")
	
	/// 会诊目的模板  DHC_MDTOpiTemp
	k ^DHCMDTOT
	;k ^mdata("DHCMDTOPITEMP")
	
	/// MDT权限人员表 DHC_MDTDocAppAut、DHC_MDTDocAppAutItm
	k ^DHCMDTDAA
	;k ^mdata("User.DHCMDTDOCAPPAUT")
	
	///病种外院专家
	k ^DHCMDTGOE
}

Storage Default
{
<Data name="DHCMDTKillDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCMDTKillDataD</DataLocation>
<DefaultData>DHCMDTKillDataDefaultData</DefaultData>
<IdLocation>^web.DHCMDTKillDataD</IdLocation>
<IndexLocation>^web.DHCMDTKillDataI</IndexLocation>
<StreamLocation>^web.DHCMDTKillDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
