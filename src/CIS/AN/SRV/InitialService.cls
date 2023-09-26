Class CIS.AN.SRV.InitialService Extends %RegisteredObject
{

/// 保留配置数据表
Parameter RetainConfigClass = "CF.AN.MenuPermission,CF.AN.SSGroup,CF.AN.ActionPermission";

/// 请谨慎使用!!!
/// 使用之前，请先使用SMP查看Global情况，确保CIS.AN.开头的Global都是手麻系统的!!!
/// 使用之前，请先备份所有CIS.AN.开头的Global，防止误删除后无法恢复!!!
/// d ##class(CIS.AN.SRV.InitialService).InitialBSData()
ClassMethod InitialBSData() As %String
{
	&sql(declare CISCursor cursor for select distinct by (GlobalName) %EXACT(GlobalName) into :GlobalName from %ExtentMgr.GlobalRegistry where GlobalName like '^CIS.AN.%')	
	&sql(open CISCursor)
	for
	{
		&sql(fetch CISCursor)
		quit:(SQLCODE'=0)
		set killText="kill "_GlobalName
		x killText
		w GlobalName_" is killed.",!	
	}
	&sql(close CISCursor)

	// 清除旧表业务数据
	d ##class(web.DHCClinicCom).ClearOPData()
	w "old BS data is clear"
	quit "S^"
}

/// 请谨慎使用!!!
/// 使用之前，请先使用SMP查看Global情况，确保CF.AN.开头的Global都是手麻系统的!!!
/// 使用之前，请先备份所有CF.AN.开头的Global，防止误删除后无法恢复!!!
/// d ##class(CIS.AN.SRV.InitialService).InitialConfigData()
ClassMethod InitialConfigData() As %String
{
	&sql(declare ConfigCursor cursor for select distinct by (GlobalName) %EXACT(GlobalName) into :GlobalName from %ExtentMgr.GlobalRegistry where GlobalName like '^CF.AN.%')	
	&sql(open ConfigCursor)
	for
	{
		&sql(fetch ConfigCursor)
		quit:(SQLCODE'=0)
		continue:..IsRetainConfigData(GlobalName)
		x "kill "_GlobalName
		w GlobalName_" is killed.",!	
	}
	&sql(close ConfigCursor)

	// 删除从HIS导入的数据
	do ..InitHISData()
	w "his data is killed",!
	

	// 清除旧表配置数据
	d ##class(web.DHCClinicCom).ClearOpSetInfo()
	w "old config data is clear"
	
	
	// 独立库性别数据字典初始化
	d ##class(CIS.AN.BL.Sex).Initiate()
	w "sex dictionary is initiated"
	
	quit "S^"
}

/// 是否保留配置数据
/// w ##class(CIS.AN.SRV.InitialService).IsRetainConfigData("^CF.AN.MenuPermissionS")
ClassMethod IsRetainConfigData(GlobalName) As %Boolean
{
	set list = $LISTFROMSTRING(..#RetainConfigClass,",")
	set result=0
	for i=1:1:$ll(list)
	{
		if GlobalName[$lg(list,i)
		{
			set result=1
			quit
		}
	}
	quit result
}

/// 请谨慎使用!!!
/// 使用之前，请先使用SMP查看Global情况，确保CT.AN.开头的Global都是手麻系统的!!!
/// 使用之前，请先备份所有CT.AN.开头的Global，防止误删除后无法恢复!!!
/// d ##class(CIS.AN.SRV.InitialService).InitialCodeData()
ClassMethod InitialCodeData() As %String
{
	&sql(declare ANCodeCursor cursor for select distinct by (GlobalName) %EXACT(GlobalName) into :GlobalName from %ExtentMgr.GlobalRegistry where GlobalName like '^CT.AN.%')	
	&sql(open ANCodeCursor)
	for
	{
		&sql(fetch ANCodeCursor)
		quit:(SQLCODE'=0)
		x "merge "_GlobalName_"Bak="_GlobalName
		x "kill "_GlobalName
		w GlobalName_" is killed.",!	
	}
	&sql(close ANCodeCursor)
	quit "S^"
}

/// 请谨慎使用!!!
/// 单独清楚HIS导入的数据
/// 使用之前，请先使用SMP查看Global情况，确保CT.AN.和CF.AN.开头的Global都是手麻系统的!!!
/// 使用之前，请先备份所有CT.AN.和CF.AN.开头的Global，防止误删除后无法恢复!!!
/// d ##class(CIS.AN.SRV.InitialService).InitHISData()
ClassMethod InitHISData() As %String
{
	// 删除从HIS导入的诊断数据
	kill ^CT.AN.DiagnosisD
	kill ^CT.AN.DiagnosisI

	// 删除从HIS导入的性别数据
	kill ^CT.AN.SexD
	kill ^CT.AN.SexI

	// 删除从HIS导入的手术字典
	kill ^CT.AN.OperationD
	kill ^CT.AN.OperationI

	// 删除从HIS导入的用药途径
	kill ^CT.AN.InstructionD
	kill ^CT.AN.InstructionI

	// 删除从HIS导入的手术等级
	kill ^CT.AN.OperClassD
	kill ^CT.AN.OperClassI

	// 删除从HIS导入的切口类型
	kill ^CT.AN.BladeTypeD
	kill ^CT.AN.BladeTypeI

	// 删除从HIS导入的身体部位
	kill ^CT.AN.BodySiteD
	kill ^CT.AN.BodySiteI

	// 删除从HIS导入的手术体位
	kill ^CT.AN.OperPositionD
	kill ^CT.AN.OperPositionI

	// 删除从HIS导入的麻醉类型
	kill ^CT.AN.AnaTypeD
	kill ^CT.AN.AnaTypeI

	// 删除从HIS导入的麻醉方法
	kill ^CT.AN.AnaMethodD
	kill ^CT.AN.AnaMethodI

	// 删除从HIS导入的ASA分级
	kill ^CT.AN.ASAClassD
	kill ^CT.AN.ASAClassI

	// 删除从HIS导入的医院数据
	kill ^CF.AN.HospitalD
	kill ^CF.AN.HospitalI

	// 删除从HIS导入的科室数据
	kill ^CF.AN.DepartmentD
	kill ^CF.AN.DepartmentI

	// 删除从HIS导入的病区数据
	kill ^CF.AN.WardD
	kill ^CF.AN.WardI

	// 删除从HIS导入的床位数据
	kill ^CF.AN.BedD
	kill ^CF.AN.BedI

	// 删除从HIS导入的医护人员类型数据
	kill ^CF.AN.CareProvTypeD
	kill ^CF.AN.CareProvTypeI

	// 删除从HIS导入的医护人员数据
	kill ^CF.AN.CareProviderD
	kill ^CF.AN.CareProviderI

	// 删除从HIS导入的安全组数据
	//kill ^CF.AN.SSGroupD
	//kill ^CF.AN.SSGroupI

	// 删除从HIS导入的用户数据
	kill ^CF.AN.SSUserD
	kill ^CF.AN.SSUserI

	// 删除从HIS导入的用户登录科室
	kill ^CF.AN.UserLogonDeptD
	kill ^CF.AN.UserLogonDeptI

	// 删除从HIS导入的科室列表数据
	kill ^CF.AN.DeptListD
	kill ^CF.AN.DeptListI

	// 删除从HIS导入的科室列表关联科室数据
	kill ^CF.AN.DeptListDeptD
	kill ^CF.AN.DeptListDeptI

	// 删除从HIS导入的科室关联科室数据
	kill ^CF.AN.DeptLinkDeptD
	kill ^CF.AN.DeptLinkDeptI

	// 删除从HIS导入的科室医护人员数据
	kill ^CF.AN.ResourceD
	kill ^CF.AN.ResourceI
	
	quit "S^"
}

/// 请谨慎使用!!!
/// 清除与HIS相关联的数据
/// 使用之前，请先使用SMP查看Global情况，确保CT.AN.和CF.AN.开头的Global都是手麻系统的!!!
/// 使用之前，请先备份所有CT.AN.和CF.AN.开头的Global，防止误删除后无法恢复!!!
/// d ##class(CIS.AN.SRV.InitialService).InitHISLinkedData()
ClassMethod InitHISLinkedData() As %String
{
	// 删除功能授权数据
	kill ^CF.AN.ActionPermissionD
	kill ^CF.AN.ActionPermissionI
	
	// 删除科室设备数据
	kill ^CF.AN.DeptEquipD
	kill ^CF.AN.DeptEquipI
	
	// 删除科室关联手术部位
	kill ^CF.AN.DeptLinkBodySiteD
	kill ^CF.AN.DeptLinkBodySiteI
	
	// 删除科室关联手术
	kill ^CF.AN.DeptOperationD
	kill ^CF.AN.DeptOperationI
	
	// 删除手术间和PACU床位
	kill ^CF.AN.LocationD
	kill ^CF.AN.LocationI
	
	// 删除菜单授权数据
	kill ^CF.AN.MenuPermissionD
	kill ^CF.AN.MenuPermissionI
	
	// 删除模块授权数据
	kill ^CF.AN.ModulePermissionD
	kill ^CF.AN.ModulePermissionI
	
	// 删除手术楼层数据
	kill ^CF.AN.OperFloorD
	kill ^CF.AN.OperFloorI
	
	// 删除表单授权数据
	kill ^CF.AN.SheetPermissionD
	kill ^CF.AN.SheetPermissionI
	
	// 删除表单元素授权数据
	kill ^CF.AN.SheetElementD
	kill ^CF.AN.SheetElementI
	
	// 删除手术医生组
	kill ^CF.AN.SurgeonGroupD
	kill ^CF.AN.SurgeonGroupI
	
	// 删除医生关联手术
	kill ^CF.AN.SurgeonOperationD
	kill ^CF.AN.SurgeonOperationI
	
	// 删除数据表格设置
	kill ^CF.AN.DataGridD
	kill ^CF.AN.DataGridI
	
	// 删除数据列设置
	kill ^CF.AN.DataColumnD
	kill ^CF.AN.DataColumnI
}

/// 请谨慎使用!!!
/// 备份基础数据
/// tag: 备份Global的别名
/// d ##class(CIS.AN.SRV.InitialService).CTANBackup()
ClassMethod CTANBackup(tag = "") As %String
{
	//Kill ^DHCCLANBak
	&sql(declare cctan cursor for 
	select distinct by (GlobalName) %EXACT(GlobalName) into :GlobalName 
	from %ExtentMgr.GlobalRegistry where GlobalName like '^CT.AN.%')	
	&sql(open cctan)
	for
	{
		&sql(fetch cctan)
		quit:(SQLCODE'=0)
		if GlobalName["MenuD" 
		if GlobalName["OperStatus" 
		set GlobalNameNew=$Replace(GlobalName,"^","")
		x "merge "_"^DHCCLANBak"_tag_"("""_GlobalNameNew_""")="_GlobalName
	}
	&sql(close cctan)
	quit "S^"
}

/// 请谨慎使用!!!
/// 导入基础数据
/// d ##class(CIS.AN.SRV.InitialService).LoadCTAN()
ClassMethod LoadCTAN() As %String
{
	// 备份
	do ..CTANBackup($Replace($zd(+$h,3),"-",1))
	if ($o(^DHCCLANBak(""))="")
	{
		write "^DHCCLANBak不存在，请先导入",!
	}
	// 导入 
	set globalName=""
	for{
		set globalName=$O(^DHCCLANBak(globalName))
		quit:globalName=""
		write "load:"_"^"_globalName,!
		x "kill "_"^"_globalName
		x "merge "_"^"_globalName_"="_"^DHCCLANBak("""_globalName_""")"
	}
	quit "S^"
}

ClassMethod InitMenu(systemGroupId = 265)
{
	// d ##class(CIS.AN.SRV.InitialService).InitMenu()
	kill ^CF.AN.MenuPermissionD
	kill ^CF.AN.MenuPermissionI
	
	do AddMenu(systemGroupId,26,"Y")
	do AddMenu(systemGroupId,30,"Y")
	do AddMenu(systemGroupId,31,"N")
	do AddMenu(systemGroupId,32,"N")
	do AddMenu(systemGroupId,33,"Y")
	do AddMenu(systemGroupId,34,"Y")
	do AddMenu(systemGroupId,35,"Y")
	do AddMenu(systemGroupId,36,"Y")
	do AddMenu(systemGroupId,77,"Y")
	do AddMenu(systemGroupId,27,"Y")
	do AddMenu(systemGroupId,37,"Y")
	do AddMenu(systemGroupId,38,"N")
	do AddMenu(systemGroupId,39,"Y")
	do AddMenu(systemGroupId,40,"Y")
	do AddMenu(systemGroupId,84,"N")
	do AddMenu(systemGroupId,28,"Y")
	do AddMenu(systemGroupId,41,"Y")
	do AddMenu(systemGroupId,42,"Y")
	do AddMenu(systemGroupId,43,"Y")
	do AddMenu(systemGroupId,79,"Y")
	do AddMenu(systemGroupId,78,"N")
	do AddMenu(systemGroupId,29,"Y")
	do AddMenu(systemGroupId,44,"Y")
	do AddMenu(systemGroupId,45,"Y")
	do AddMenu(systemGroupId,46,"Y")
	do AddMenu(systemGroupId,87,"Y")
	do AddMenu(systemGroupId,88,"Y")
	do AddMenu(systemGroupId,89,"Y")
	do AddMenu(systemGroupId,90,"Y")
	do AddMenu(systemGroupId,91,"Y")
	do AddMenu(systemGroupId,92,"Y")
	do AddMenu(systemGroupId,94,"Y")
	do AddMenu(systemGroupId,101,"Y")
	do AddMenu(systemGroupId,102,"Y")
	do AddMenu(systemGroupId,103,"Y")
	do AddMenu(systemGroupId,104,"Y")
	do AddMenu(systemGroupId,105,"Y")
	do AddMenu(systemGroupId,106,"Y")
	do AddMenu(systemGroupId,107,"Y")
	do AddMenu(systemGroupId,108,"Y")
	do AddMenu(systemGroupId,109,"Y")
	do AddMenu(systemGroupId,110,"Y")
	do AddMenu(systemGroupId,111,"Y")
	do AddMenu(systemGroupId,112,"Y")
	do AddMenu(systemGroupId,113,"Y")
	do AddMenu(systemGroupId,114,"Y")
	do AddMenu(systemGroupId,115,"Y")
	do AddMenu(systemGroupId,116,"Y")
	do AddMenu(systemGroupId,117,"Y")
	do AddMenu(systemGroupId,118,"Y")
	do AddMenu(systemGroupId,119,"Y")
	do AddMenu(systemGroupId,120,"Y")
	do AddMenu(systemGroupId,121,"Y")
	do AddMenu(systemGroupId,122,"Y")
	do AddMenu(systemGroupId,123,"Y")
	do AddMenu(systemGroupId,124,"Y")
	do AddMenu(systemGroupId,125,"Y")
	do AddMenu(systemGroupId,126,"Y")
	do AddMenu(systemGroupId,127,"Y")
	do AddMenu(systemGroupId,130,"Y")
	do AddMenu(systemGroupId,131,"Y")
	do AddMenu(systemGroupId,132,"Y")
	do AddMenu(systemGroupId,133,"Y")
	do AddMenu(systemGroupId,134,"Y")
	do AddMenu(systemGroupId,135,"Y")
	do AddMenu(systemGroupId,136,"Y")
	do AddMenu(systemGroupId,137,"Y")
	do AddMenu(systemGroupId,138,"Y")
	do AddMenu(systemGroupId,140,"Y")
	do AddMenu(systemGroupId,141,"Y")
	do AddMenu(systemGroupId,143,"Y")
	do AddMenu(systemGroupId,144,"Y")
	do AddMenu(systemGroupId,145,"Y")
	do AddMenu(systemGroupId,142,"Y")
	do AddMenu(systemGroupId,146,"Y")
	do AddMenu(systemGroupId,147,"Y")
	do AddMenu(systemGroupId,148,"Y")
	do AddMenu(systemGroupId,149,"Y")
	do AddMenu(systemGroupId,150,"Y")
	do AddMenu(systemGroupId,139,"Y")
	do AddMenu(systemGroupId,151,"Y")
	do AddMenu(systemGroupId,152,"Y")
	do AddMenu(systemGroupId,153,"Y")
	do AddMenu(systemGroupId,155,"Y")
	do AddMenu(systemGroupId,157,"Y")
	do AddMenu(systemGroupId,158,"Y")
	quit "Over"

AddMenu(systemGroupId,menuItemId,isActive)
	&sql(select RowId into :rowId from CF_AN.MenuPermission
	where RoleGroup=:systemGroupId and MenuItem=:menuItemId)
	quit:'(##class(CT.AN.MenuItem).%ExistsId(menuItemId)) 0
	
	if (rowId="")
	{
	&sql(INSERT INTO CF_AN.MenuPermission (RoleGroup, MenuItem, Active)
	VALUES (:systemGroupId, :menuItemId, :isActive))
	}
	else
	{
		set menu=##class(CF.AN.MenuPermission).%OpenId(rowId)
		set menu.Active=isActive
		set menu.GroupID=systemGroupId
		set menu.MenuItem=##class(CT.AN.MenuItem).%OpenId(menuItemId)
		do menu.%Save()
	}

    quit 0
}

/// 初始化HIS菜单
ClassMethod InitHISMenu()
{
	// d ##class(CIS.AN.SRV.InitialService).InitHISMenu()
	// 添加父菜单
	do Save("OPERAHEAD","CIS.AN.OPM.Nurse", "手术管理", "", "", "", "0", "005OPM000", "HeaderMenu", "", "", "", "")
    do Save("INPDOCHEAD","CIS.AN.OPM", "手术管理", "", "", "", "0", "005OPM000", "HeaderMenu", "", "", "", "")
    do Save("OUTDOCHEAD","CIS.AN.OutOper", "门诊手术管理", "", "", "", "0", "", "HeaderMenu", "", "", "", "")
	// 添加子菜单
	//do Save("OPERAHEAD", "dhcan.workstation.opnurse", "手术护士工作站", "dhcan.workstation.opnurse.csp", "", "", "0", "", "HeaderMenu", "", "", "", "")
	//do Save("OPERAHEAD", "CIS.AN.OPM.Nurse", "手术管理", "", "", "", "0", "005OPM000", "HeaderMenu", "", "", "", "")
	do Save("OPERAHEAD", "CIS.AN.OutOperReg", "门诊手术登记", "CIS.AN.OutOperReg.csp", "", "", "0", "OPM007", "HeaderMenu", "", "", "", "&moduleCode=AN_OPA_003")
	do Save("OPERAHEAD", "CIS.AN.OutNurse.OperationListOut", "手术列表", "CIS.AN.OperationListOut.csp", "bottom:10px;right:10px;", "", "0", "001", "HeaderMenu", "2018/9/28 0:00:00", "13:40:31", 1, "")
	//do Save("OUTDOCHEAD", "CIS.AN.OutOper", "门诊手术管理", "", "", "", "0", "", "HeaderMenu", "", "", "", "")
	//do Save("INPDOCHEAD", "CIS.AN.OPM", "手术管理", "", "", "", "0", "005OPM000", "HeaderMenu", "", "", "", "")
	do Save("CIS.AN.OPM.Nurse", "CIS.AN.OperArrange", "手术排班", "CIS.AN.OperArrange.csp", "", "", "0", "OPM003", "HeaderMenu", "", "", "", "&moduleCode=AN_OPA_003")
	do Save("CIS.AN.OPM.Nurse", "CIS.AN.OperArrange.Drag", "手术排班(视图)", "CIS.AN.OperArrange.Drag.csp", "", "", "0", "", "HeaderMenu", "", "", "", "")
	do Save("CIS.AN.OPM.Nurse", "CIS.AN.OperationList.New.Nurse", "手术列表(新)", "CIS.AN.OperationList.New.csp", "", "", "0", "", "HeaderMenu", "", "", "", """&moduleCode=AN_OPA_002""")
	do Save("CIS.AN.OPM.Nurse", "CIS.AN.OPOperationList", "手术麻醉列表", "CIS.AN.OperationList.csp", "", "", "0", "OPS000", "HeaderMenu", "", "", "", "")
	
	do Save("CIS.AN.OPM.Nurse", "CIS.AN.ArchiveList", "手术麻醉列表", "CIS.AN.ArchiveList.csp", "", "", "0", "", "HeaderMenu", "", "", "", "")
	
	do Save("CIS.AN.OPM.Nurse", "dhcan.crewarrange.month", "科室月排班", "dhcan.crewarrange.month.csp", "", "", "0", "", "HeaderMenu", "", "", "", "")
	do Save("CIS.AN.OPM.Nurse", "CF.AN.MonthArrange", "科室月排班(新)", "CF.AN.MonthArrange.csp", "", "", "0", "", "HeaderMenu", "", "", "", "")
	
	do Save("CIS.AN.OPM.Nurse", "CIS.AN.SystemSettings", "系统配置", "CIS.AN.SystemSettings.csp", "", "", "0", "OPM100", "HeaderMenu", "", "", "", "&moduleCode=AN_OPA_100")
	do Save("CIS.AN.OPM.Nurse", "CIS.AN.Workstation", "手术工作站", "CIS.AN.Workstation.csp", "", "", "0", "OPS001", "HeaderMenu", "", "", "", "&moduleCode=AN_OPS_001&menuCode=OPWSMenu")
	do Save("CIS.AN.OPM.Nurse", "CIS.AN.OperPatTrans", "手术交接", "CIS.AN.OperPatTrans.csp", "", "", "0", "OPS001", "HeaderMenu", "", "", "", "&moduleCode=AN_OPS_001&menuCode=OPWSMenu")
	do Save("CIS.AN.OPM.Nurse", "CIS.AN.OperPatTrans.New", "手术交接(新)", "CIS.AN.OperPatTrans.New.csp", "", "", "0", "OPS001", "HeaderMenu", "", "", "", "&moduleCode=AN_OPS_001&menuCode=OPWSMenu")
	do Save("CIS.AN.OPM.Nurse", "CIS.AN.SpecimenTrans", "术中标本交接", "CIS.AN.SpecimenTrans.csp", "", "", "0", "OPS001", "HeaderMenu", "", "", "", "&moduleCode=AN_OPS_001&menuCode=OPWSMenu")
	do Save("CIS.AN.OPM.Nurse", "CIS.AN.BloodTrans", "输血交接", "CIS.AN.BloodTrans.csp", "", "", "0", "OPS001", "HeaderMenu", "", "", "", "&moduleCode=AN_OPS_001&menuCode=OPWSMenu")
	do Save("CIS.AN.OPM.Nurse", "CIS.AN.AnaArrange", "麻醉排班", "CIS.AN.AnaArrange.csp", "", "", "0", "OPM004", "HeaderMenu", "", "", "", "&moduleCode=AN_OPA_004")
	do Save("CIS.AN.OPM.Nurse", "CIS.AN.AnaArrange.Drag", "麻醉排班(视图)", "CIS.AN.AnaArrange.Drag.csp", "", "", "0", "", "HeaderMenu", "", "", "", "")
	do Save("CIS.AN.OPM.Nurse", "CIS.AN.ANWorkstation", "麻醉工作站", "CIS.AN.Workstation.csp", "", "", "0", "OPS002", "HeaderMenu", "", "", "", "&moduleCode=AN_OPS_002&menuCode=ANWSMenu")
	do Save("CIS.AN.OPM.Nurse", "CIS.AN.StatQuery", "手术麻醉明细报表", "CIS.AN.StatQuery.csp", "", "", "0", "OPM002", "HeaderMenu", "", "", "", "")
	do Save("CIS.AN.OPM.Nurse", "CIS.AN.Statistic.Index", "手术麻醉统计", "CIS.AN.Statistic.Index.csp", "", "", "0", "", "HeaderMenu", "", "", "", "")
	do Save("CIS.AN.OPM.Nurse", "CIS.AN.PACUStation", "恢复室工作站", "CIS.AN.PACUStation.csp", "", "", "0", "", "HeaderMenu", "", "", "", "")
	do Save("CIS.AN.OPM.Nurse", "CIS.AN.BatchArchive", "批量归档", "CIS.AN.BatchArchive.csp", "", "", "0", "", "HeaderMenu", "", "", "", "")
	do Save("CIS.AN.OPM.Nurse", "dhcan.monitor.index", "手术实时监控", "dhcan.monitor.index.csp", "", "", "0", "", "HeaderMenu", "", "", "", "")
	
	
	do Save("CIS.AN.OPM", "CIS.AN.OperApplication", "手术申请", "CIS.AN.OperApplication.csp", "", "CheckLinkDetails", "0", "OPM001", "HeaderMenu", "", "", "", "&moduleCode=AN_OPA_001")
	do Save("CIS.AN.OPM", "CIS.AN.OperationList", "手术列表", "CIS.AN.OperationList.csp", "", "", "0", "OPM002", "HeaderMenu", "", "", "", "&moduleCode=AN_OPA_002")
	do Save("CIS.AN.OPM", "CIS.AN.OperApplication.New", "手术申请(新)", "CIS.AN.OperApplication.New.csp", "", "CheckLinkDetails", "0", "", "HeaderMenu", "", "", "", "&moduleCode=AN_OPA_001")
	do Save("CIS.AN.OPM", "CIS.AN.OperationList.New", "手术列表(新)", "CIS.AN.OperationList.New.csp", "", "", "0", "", "HeaderMenu", "", "", "", "&moduleCode=AN_OPA_002")
	do Save("CIS.AN.OPM", "CF.AN.SurgeonGroup", "手术医师组", "CF.AN.SurgeonGroup.csp", "", "", "0", "", "HeaderMenu", "", "", "", "&moduleCode=AN_OPA_002")
	do Save("CIS.AN.OPM", "CIS.AN.DaySurgeryApp", "日间手术申请", "CIS.AN.DaySurgeryApp.csp", "", "CheckLinkDetails", "0", "", "HeaderMenu", "", "", "", "&moduleCode=AN_OPA_001&IsConfirm=N")
	
	
	do Save("CIS.AN.OutOper", "CIS.AN.OutOperationList", "门诊手术列表", "CIS.AN.OperationListOut.csp", "", "", "0", "", "HeaderMenu", "", "", "", "")
	do Save("CIS.AN.OutOper", "CIS.AN.OperOutApply", "门诊手术申请", "CIS.AN.OutOperApp.csp", "", "CheckLinkDetails", "0", "OPM001", "HeaderMenu", "", "", "", "&moduleCode=AN_OPA_001")
	
	
	quit "Over"
Save(subMenuOf,name,caption,linkurl,helpStyle,javaScriptFunction,isXhrRefresh,sequence,type,updateDate,updatetime,updateUser,valueExpression)
    set parentId=""
    &sql(select id into:parentId from websys.Menu where Name=:subMenuOf)
    write "parentId:",parentId,!
    quit:parentId="" "parentId is null"
	&sql(select id into:id from websys.Menu where Name=:name)
	set menuObj=##class(websys.Menu).%New()
	if (id'="")
	{
		set menuObj=##class(websys.Menu).%OpenId(id)
	}
	
	set menuObj.SubMenuOf=##class(websys.Menu).%OpenId(parentId)
	set menuObj.Name=name
	set menuObj.Caption=caption
	set menuObj.LinkUrl=linkurl
	set menuObj.HelpStyle=helpStyle
	set menuObj.JavascriptFunction=javaScriptFunction
	set menuObj.IsXhrRefresh=isXhrRefresh
	set menuObj.Sequence=sequence
	set menuObj.Type=type
	//set menuObj.UpdateDate
	//set menuObj.Updatetime
	//set menuObj.UpdateUser
	set menuObj.ValueExpression=valueExpression
	do menuObj.%Save()
	write "id:"_id,!
	quit menuObj.%Id()
}

}
