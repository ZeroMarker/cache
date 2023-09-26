Import SQLUser

/// Creator: 	 bianshuai
/// CreateDate:  2017-04-26
/// Descript:    急诊清数据类
/// 
/// 急诊清除业务数据
/// D ##Class(web.DHCEMKillData).killAppBusiData()
/// 
/// 急诊清除基础数据
/// D ##Class(web.DHCEMKillData).killAppBaseData()
/// 
Class web.DHCEMKillData Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript: 急诊清除业务数据
/// D ##Class(web.DHCEMKillData).killAppBusiData()
ClassMethod killAppBusiData()
{
	
	/// 预检分级 DHC_EmPatCheckLev
	k ^DHCEMPCL
	k ^mdata("DHCEMPATCHECKLEV")
	
	/// 预检分级就诊表 DHC_EmPatChkAdm
	k ^DHCEMPCA
	k ^mdata("DHCEMPATCHKADM")
	
	/// 预检生命体征表 DHC_EmPatChkSign
	k ^DHCEMPCS
	k ^mdata("DHCEMPATCHKSIGN")
	
	/// 预检既往史 DHC_EmPatChkHis
	k ^DHCEMPCH
	k ^mdata("DHCEMPATCHKHIS")
	
	/// 预检号别表 DHC_EmPatChkCare
	k ^DHCEMPCC
	k ^mdata("DHCEMPATCHKCARE")
	
	/// 预检病人无名氏增递计算器表 DHC_EmPatChkNo
	k ^DHCEMPCN
	k ^mdata("DHCEMPATCHKNO")
	
	/// 预检病人格拉斯哥 DHC_EmPatChkGCS
	k ^DHCEMPCG
	k ^mdata("^DHCEMPCG")
	
	/// 创伤评分 DHC_EmPatChkAIS
	k ^DHCEMPCAI
	k ^mdata("^DHCEMPCA")
	
	/// 分诊出租物件信息表 DHC_EmPatChkRList
	k ^DHCEMPCR
	k ^DHCEMPCRi
	k ^mdata("^DHCEMPCR")
	
	/// 预检分诊症状表 DHC_EmPatChkSym
	//k ^DHCEMPCS
	//k ^mdata("DHCEMPATCHKSYM")
	
	/// 预检分级绿色通道记录表 DHC_EmPatGreenRec
	k ^DHCEMPGR
	k ^mdata("DHCEMPATGREENREC")
	
	/// 医生更新病人分级记录表 DHC_EmDocUpdPatLev
	k ^DHCEMDUPL
	k ^mdata("^DHCEMDUPL")
	
	/// 急诊分级六大病种表  DHC_EmPatChkSpec
	k ^DHCEMPCSP
	k ^mdata("^DHCEMPCSP")
	
	/// 急诊万能表        DHC_EmPatChkHisMore 增加 hxy 2019-11-28
	;k ^DHCEMPCHIM
	;k ^mdata("DHCEMPCHIM")
	
	///待入院管理 DHC_EmWaitToHos DHC_EmWaitToHosItm
	k ^DHCEMWH
	k ^mdata("DHCEMWAITTOHOS")
	
	///死亡登记 DHC_EmDeathReg
	k ^DHCEMEFSA
	k ^mdata("DHCEMDEATHREG")
	
	///急诊交接班 DHC_EmBedSideShift DHC_EmBedSideShiftItm
	k ^DHCEMBSS
	k ^mdata("DHCEMBEDSIDESHIFT")
	
	///急诊交接班  DHC_EmShiftLinkItem
	k ^DHCEMSLI
	k ^mdata("DHCEMSHIFTLINKITEM")
	
	//////急诊基础字典类型表 DHC_EmDicType
	///k ^DHCEMDT
	///k ^mdata("DHCEMDICTYPE")
	
	//////急诊基础字典项目表 DHC_EmDicItem
	///k ^DHCEMDI
	///k ^mdata("DHCEMDICITEM")
	
	///急诊院前出诊记录表 DHC_EmPreHosVis
	k ^DHCEMPHV
	k ^mdata("DHCEMPREHOSVIS")
	
	///急诊科救护车派车管理登记表 DHC_EmDisAmbMan
	k ^DHCEMDAM
	k ^mdata("DHCEMDISAMBMAN")
	
	///派车随车人员表 DHC_EmAccPerson
	k ^DHCEMACCP
	k ^mdata("DHCEMACCPERSON")
	
	///急诊院前登记表 DHC_EmPreHosReg DHC_EmPreHosRegItem
	k ^DHCEMPHR
	k ^mdata("DHCEMPREHOSREG")
	
	///评分记录表 DHC_EMCScore
	k ^DHCEMCS
	k ^mdata("DHCEMCSCORE")
	
	///评分记录元素值 DHC_EMCScoreItem
	k ^DHCEMCSI
	k ^mdata("DHCEMCSCOREITEM")
	
	///急诊每日工作量记录表 DHC_EmDailyWorkLoad DHC_EmDailyWorkLoadItem
	k ^DHCEMDWL
	k ^mdata("DHCEmDAILYWORKLOAD")
	
	/// 预交金
	k ^DHCEMADVPA
	k ^mdata("DHCEMADVPAYASS")
	
	///输液座位 DHC_NurSyPatRec
	k ^User.DHCNurSyPatRecI
	k ^User.DHCNurSyPatRecD
	
	///急诊患者登记表
	k ^DOCEMREG
	k ^DOCEMREG(0)
	k ^DOCEMREGi
	
	/// 病人状态变更
	k ^DHCADMVisitStatus
	
	///CA签名数据
	k ^DHCEMSV
	k ^DHCEmSignVerify
	
	///MDT上传文件
	k ^DHCEMPCDO
	k ^DHCEMPATCHKDOCU
	
	///绿色通道审核记录
	k ^User.DHCEmPatGreenRecAuditI
	k ^User.DHCEmPatGreenRecAuditD
}

/// Descript: 急诊清除基础数据
/// D ##Class(web.DHCEMKillData).killAppBaseData()
ClassMethod killAppBaseData()
{
	/// 既往史字典 DHC_EmPatHistory
	k ^DHCEMPHI
	k ^mdata("^DHCEMPHI")
	
	/// 病人来源字典 DHC_EmPatSource
	k ^DHCEMPSO
	k ^mdata("^DHCEMPSO")
	
	/// 病人来诊方式字典 DHC_EmPatAdmWay
	k ^DHCEMPADW
	k ^mdata("^DHCEMPADW")
	
	/// 病人意识状态字典 DHC_EmPatAware
	k ^DHCEMPAW
	k ^mdata("DDHCEMPATAWARE")
	
	/// 更改分级原因字典 DHC_EmUpdLevReson
	k ^DHCEMULR
	k ^mdata("DHCEMUPDLEVRESON")
	
	/// 分级指标函数分类表 DHC_EmLevFunCat
	//k ^DHCEMLFC
	//k ^mdata("^DHCEMLFC")
	
	/// 分级指标函数表  DHC_EmLevFunLib
	//k ^DHCEMLFL
	//k ^mdata("^DHCEMLFL")
	
	/// 分级指标表达式库表 DHC_EmLevExpress
	//k ^DHCEMLEX
	//k ^mdata("^DHCEMLEX")
	
	/// 分级指标表达式库表 DHC_EmLevTheme
	//k ^DHCEMLTH
	//k ^mdata("^DHCEMLTH")
	
	/// 分级指标关键字库表 DHC_EmLevKey
	//k ^DHCEMLK
	//k ^mdata("^DHCEMLK")
	
	/// 产品表 DHC_EmSys、DHC_EmSysItm、DHC_EmSysItmAut
	//k ^DHCEMS
	//k ^mdata("^DHCEMS")
	
	/// 格拉斯哥昏迷评分 DHC_EmGCS、DHC_EmGCSItem
	k ^DHCEMGCS
	k ^mdata("^DHCEMGCS")
	
	///	创伤评分 DHC_EmAIS、DHC_EmAISItem
	k ^DHCEMAIS
	k ^mdata("DHCEmAIS")
	
	/// 病人人群字典表 DHC_EmPatType
	k ^DHCEMPT
	k ^mdata("^DHCEMPT")
	
	/// 陪送人员字典 DHC_EmPartners
	k ^DHCEMPA
	k ^mdata("^DHCEMPA")
	
	/// 出租物件字典 DHC_EmRentList
	k ^DHCEMRL
	k ^DHCEMRLI
	k ^mdata("^DHCEMRL")
	
	/// 医生更新病人分级原因表 DHC_EmDocUpdReason
	k ^DHCEMDUR
	k ^mdata("^DHCEMDUR")
	
	/// 医生评估护士分级分类表 DHC_EmDocAssessType
	k ^DHCEMDAT
	k ^mdata("^DHCEMDAT")
	
	/// 急诊特病字典表 DHC_EmSpecDise
	k ^DHCEMSPD
	k ^mdata("^DHCEMSPD")
	
	///重大事件及患者关联-汇报对象 DHC_EmPatHistoryMore
	k ^DHCEMPHIM
	k ^mdata("^DHCEMPHIM")
	
	///门急诊护士执行单设置 DHC_EmExecFormSet DHC_EmExecFormSetItm
	k ^DHCEMEFSI
	k ^mdata("^DHCEMEXECFORMSET")
	
	///评分表单元素表 DHC_EMCScoreForm
	//k ^DHCEMCSF
	//k ^mdata("DHCEMCSCOREFORM")
	
	///评分表单 DHC_EMCScoreScale
	//k ^DHCEMCSS
	//k ^mdata("DHCEMCSCORESCALE")
	d ..DeleteMapping()
}

/// Descript: 急诊清除基础数据(仅和科室相关的) liangqiang
/// D ##Class(web.DHCEMKillData).killEMDataOnlyLinkLoc()
ClassMethod killEMDataOnlyLinkLoc()
{
	/// 科室座位图字典表 DHC_EmPatSeat、DHC_EmPatSeatItm
	k ^DHCEMPSE
	k ^mdata("^DHCEMPSE")
	
	/// 页面表格列设置表 DHC_EmSysGridSet
	k ^DHCEMSGS
	k ^mdata("^DHCEMSGS")
	
	/// 座位类别字典表 DHC_EmPatSeatCat
	k ^DHCEMPSC
	k ^mdata("^DHCEMPSC")
	
	/// 授权病人状态表 DHC_EmPatStatusAcc 只清除人员
	;k ^DHCEMPSA
	&sql(DELETE DHC_EmPatStatusAcc WHERE PSA_Type IN ('U') AND 1=1 )
	
	///门急诊护士安全组授权  DHC_EmExecFormSetAut 只清除科室数据
	&sql(DELETE FROM DHC_EmExecFormSetAut WHERE FSA_Loc_Dr != "")
	;k ^DHCEMEFSAA
	;k ^DHCEMEXECFORMSETAUT
	
	///门急诊护士执行单设置-医嘱属性设置
	;&sql(DELETE DHC_EmExecFormSetItm WHERE FSI_TypeCode IN ('ExecDis','ExecPro','ExecCat','ExecStat','ExecPhi','ExecSpec','ExecRecLoc'))
	&sql(DELETE DHC_EmExecFormSetItm WHERE FSI_TypeCode IN ('ExecCat','ExecPhi','ExecSpec','ExecRecLoc'))
	
	///产品功能配置授权
	&sql(DELETE DHC_EmSysItmAut WHERE SA_Type IN ('U','L') AND 1=1 )
}

/// Creator:    hxy
/// CreateDate: 2020-06-23
/// Description: 删除急诊-基础数据中间表数据
/// D ##Class(web.DHCEMKillData).DeleteMapping()
ClassMethod DeleteMapping()
{
	///既往史字典
	d ..DeleteTableHospitals("DHC_EmPatHistory")
	///病人来源字典
	d ..DeleteTableHospitals("DHC_EmPatSource")
	///病人来诊方式字典维护
	d ..DeleteTableHospitals("DHC_EmPatAdmWay")
	///病人意识状态字典维护
	d ..DeleteTableHospitals("DHC_EmPatAware")
	///医护更改分级原因
	d ..DeleteTableHospitals("DHC_EmDocUpdReason")
	///分级评估字典维护
	d ..DeleteTableHospitals("DHC_EmDocAssessType")
	///特殊人群
	d ..DeleteTableHospitals("DHC_EmPatType")
	///分级六大病种字典维护
	d ..DeleteTableHospitals("DHC_EmSpecDise")
	///授权病人状态表
	d ..DeleteTableHospitals("DHC_EmPatStatusAcc")
	///门急诊护士安全组授权
	d ..DeleteTableHospitals("DHC_EmExecFormSetAut")
}

/// Creator:    hxy
/// CreateDate: 2020-06-23
/// Description: 删除表名或则代码对应的所有关联医院关系,用于初始清数据
/// Input:       表名称(BDPMPHTableName，如ARC_ItemCat) 
/// Return: 0:普通收费模式, 1:押金收费模式
/// D ##Class(web.DHCEMKillData).DeleteTableHospitals()
ClassMethod DeleteTableHospitals(BDPMPHTableName)
{
	n (BDPMPHTableName)
	s ret=##class(web.DHCBL.BDP.BDPMappingHOSP).DeleteTableHospitals(BDPMPHTableName)
	q ret
}

}
