Import SQLUser

/// Creator: 	 sufan
/// CreateDate:  2018-11-23
/// Descript:    陪送申请清数据类
/// 
/// 陪送申请清除业务数据
/// D ##Class(web.DHCDISClearData).killDisBusiData()
/// 
/// 陪送申请清除基础数据
/// D ##Class(web.DHCDISClearData).killDisBaseData()
/// 
/// 陪送状态 User.DHCDisStatusAdd(不能随意清空)
/// k ^DHCDISSA
/// k ^mdata("^DHCDISSA")
/// 陪送任务类型 User.DHCDisTypeAdd(不能清空)
/// k ^DHCDISTA
/// k ^mdata("^DHCDISTYPEADD")
/// 如果只清业务数据，运行此方法，清空护工工作量
/// W ##Class(web.DHCDISClearData).UpdWorkLoad()
/// 计数器赋值
/// w ##Class(web.DHCDISClearData).SetMdata()
Class web.DHCDISClearData Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript: 陪送申请清除业务数据
/// D ##Class(web.DHCDISClearData).killDisBusiData()
ClassMethod killDisBusiData()
{
	/// 陪送申请 User.DHCDisRequest,User.DHCDisRequestItm
	k ^DHCDISRE
	k ^mdata("^DHCDISRE")
	
	/// 陪送申请明细表 User.DHCDisRequestSta
	k ^DHCDISRS
	k ^mdata("^DHCDISRS")
	
	/// 陪送申请验证码 User.DHCDisRequestCode
	k ^DHCDISRC
	k ^mdata("^DHCDISRC")
	
	/// 陪送申请评价 User.DHCDisRequestAsse 
	k ^DHCDISRA
	k ^mdata("^DHCDISRA")
	
	/// 陪送申请评价明细 User.DHCDisRequestAsseI
	k ^DHCDISRAi
	k ^mdata("^DHCDISRAi")
	
	/// 陪送人员安排 User.DHCDisPeople
	k ^DHCDISPE 
	k ^mdata("^DHCDISPEOPLE")
}

/// Descript: 陪送申请清除基础数据
/// D ##Class(web.DHCDISClearData).killAppBaseData()
ClassMethod killDisBaseData()
{
	
	/// 陪送类型 User.DHCDisType
	k ^DHCDISTY
	k ^mdata("^DHCDISTY")
	
	/// 陪送方工/工具  User.DHCDisTool
	k ^DHCDISTO
	k ^mdata("^DHCDISTO")
	
	/// 陪人员关联业务发起科室 User.DHCDisLocUser
	k ^DHCDISLU
	k ^mdata("^DHCDISLU")
	
	/// 陪送未完成原因 User.DHCDisFailReason
	k ^DHCDISFR
	k ^mdata("^DHCDISFR")
	
	/// 陪送申请评价项目字典 User.DHCDisAsseItem
	k ^DHCDISAI
	k ^mdata("^DHCDISAI")
	
	/// 陪送其它项目 User.DHCDisLocItem
	k ^DHCDISLI
	k ^mdata("^DHCDISLI")
}

/// Descript: 更新护工工作量为空
/// W ##Class(web.DHCDISClearData).UpdWorkLoad()
ClassMethod UpdWorkLoad()
{
	s Statu="0"
	s Workload=""
	&sql(update DHC_DisLocUser set LU_Status=:Statu,LU_Workload=:Workload where LU_RowId>0)
	Q SQLCODE
}

ClassMethod SetMdata()
{
	/// 陪送类型 User.DHCDisType
	s id=^mdata("^DHCDISTY")
	s ^mdata("^DHCDISTY")=id
	
	/// 陪送方工/工具  User.DHCDisTool
	s id=^mdata("^DHCDISTO")
	s ^mdata("^DHCDISTO")=id
	
	/// 陪人员关联业务发起科室 User.DHCDisLocUser
	s id=^mdata("^DHCDISLU")
	s ^mdata("^DHCDISLU")=id
	
	/// 陪送未完成原因 User.DHCDisFailReason
	//s id=^mdata("^DHCDISFR")
	//s ^mdata("^DHCDISFR")=id
	
	/// 陪送申请评价项目字典 User.DHCDisAsseItem
	s id=^mdata("^DHCDISAI")
	s ^mdata("^DHCDISAI")=id
	
	/// 陪送其它项目 User.DHCDisLocItem
	s id=^mdata("^DHCDISLI")
	s ^mdata("^DHCDISLI")=id
	
	/// 陪送状态
	s id=^mdata("^DHCDISSA")
	s ^mdata("^DHCDISSA")=id
	
	///陪送任务类型 User.DHCDisTypeAdd(不能清空)	
	s id=^mdata("^DHCDISTYPEADD")
	s ^mdata("^DHCDISTYPEADD")=id
	Q 0
}

}
