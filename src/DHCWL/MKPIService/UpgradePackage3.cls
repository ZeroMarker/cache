Class DHCWL.MKPIService.UpgradePackage3 Extends %RegisteredObject
{

/// 指标升级3.0所需工作
/// d ##class(DHCWL.MKPIService.UpgradePackage3).Upgrade()
ClassMethod Upgrade(isInstall As %Integer = 0)
{
	s ver=##class(DHCWL.MKPIService.VersionPath).GetVersion()
	if (ver'="4.4.1"){
		s ^DHCWL.MKPI.Version($h)="4.4.1"
	}
	if (isInstall=1){
		d ..UpgradeDimType()
		d ..UpgradeKpi()
		k ^DHCWL.MKPI.MKPIDimTypeI
		d ##class(DHCWL.MKPI.MKPIDimType).%BuildIndices()
		k ^DHCWL.MKPI.MKPIDimensionsI
		d ##class(DHCWL.MKPI.MKPIDimensions).%BuildIndices()
		k ^DHCWL.MKPI.DimPropertyI
		d ##class(DHCWL.MKPI.DimProperty).%BuildIndices()
	}
	;4.1及以前的版本需重建DHCWL_MKPI.DHCWLMKPIDim索引

	d AddKpiTask^DHCWLKPITaskSecCheck()  //add by wk~2017-05-10~新增三个任务执行代码
	k ^DHCWL.MKPI.MKPIDimensionsI
	d ##class(DHCWL.MKPI.MKPIDimensions).%BuildIndices()
    
    k ^DHCWL.MKPI.MMgrRptCfgI
    d ##class(DHCWL.MKPI.MMgrRptCfg).%BuildIndices()
	
	d ##class(DHCWL.MKPIService.FilterConfig).Config()

	d ##class(DHCWL.Interface.MKPI.DimData).ChangeSecDimProAct()
	d ##class(DHCWL.MKPILogin.LoginService).IsLoginAppLibraryInited()
	d ##class(DHCWL.SysService.SysFilterFunc).ConfigFilterFunc()
	d ##class(DHCWL.MKPIIO.XMLIOConfige).ConfigeCodeAndId()
	d ##class(DHCWL.MKPI.MonthContract).CreateNeed()
	s id=$o(^DHCWL.MKPI.ExecuteCodeD(""))
	if (+id>0){
		s obj=##class(DHCWL.MKPI.ExecuteCode).%OpenId(id)
		s status=##class(DHCWL.util.CodeUtil).HasProperty(obj,"ExcCodeSubType")
		;b ;000
		if ((+$g(status))=0){
			;b ;001
			d ##class(DHCWL.MKPI.ExecuteCode).%BuildIndices()
			&sql(delete from DHCWL_MKPI.MKPI_ExecuteCode)
			k ^DHCWL.MKPI.ExecuteCodeI
		}
	}
	d ##class(DHCWL.MKPIService.ExcCodeService).InstalledDefaultExcode()
	d ##class(DHCWL.MKPIService.UpgradePackage3).UpdatePackCreatDataTask()
	d ##class(DHCWL.MKPILogin.LoginService).IsLoginAppLibraryInited()
	
	//add by wz.2014-6-18.系统默认配置的处理
	d ..CfgDefaultSetting()
	//下面一行不用改。在导入使用。如果要导入的版本小于3.3，就使用就的导入方法进行导入
	s ^DHCWL.MKPI.SetConfig("NewIOConfigVersion")=3.3
	/*s ysecId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode("Y","DHCWL.MKPI.Section")
	s year="" f  s year=$o(^DHCWL.MKPI.MonthsI("SectionFlagName",ysecId,year)) q:year=""  d
	.s yearNum=+year
	.d ##class(DHCWL.MKPIService.DateUtil).SetMonthContractYear(yearNum,1)
	*/
}

/// d ##class(DHCWL.MKPIService.UpgradePackage3).UpgradeDimType()
ClassMethod UpgradeDimType() As %Status
{
	s ver=##class(DHCWL.MKPIService.VersionPath).GetVersion()
	s status=""
	s sql="select ID,KDT_Code,KDT_Name,KDT_Desc,KDT_EXCode,'Y' from DHCWL_MKPI.DHCWLMKPIDimType"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s getId=""
		s dimId=rs.Data("ID"),dimCode=rs.Data("KDT_Code")
		&sql(select ID into :getId from DHCWL_MKPI.DHCWLDimProperty where DimPro_DimDr=:dimId and DimPro_Code=:dimCode)
		if getId'="" {
			//&sql(update DHCWL_MKPI.DHCWLDimProperty set DimPro_Code=:dimCode where ID=:getId)
		}else{
			&sql(insert into DHCWL_MKPI.DHCWLDimProperty(DimPro_DimDr,DimPro_Code,DimPro_Name,DimPro_Desc,DimPro_ExcCode,DimPro_DefaultFlag) select id,KDT_Code,KDT_Name,KDT_Desc,KDT_EXCode,'Y' from DHCWL_MKPI.DHCWLMKPIDimType where ID=:dimId)
		}
		s status=SQLCODE
		//q:status'=0
	}
	w status
}

/// d ##class(DHCWL.MKPIService.UpgradePackage3).UpgradeKpi()
ClassMethod UpgradeKpi() As %Status
{
	s ver=##class(DHCWL.MKPIService.VersionPath).GetVersion()
	s status=""
	s sql="select t2.KDT_Code,t1.ID kpiId,t1.MKPI_TypeDr,1,t2.KDT_Desc,',' from DHCWL_MKPI.DHCWLMKPI t1,DHCWL_MKPI.DHCWLMKPIDimType t2 where t1.MKPI_TypeDr=t2.ID"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s kpiId=rs.Data("kpiId"),dimCode=rs.Data("KDT_Code")
		s getId=""
		&sql(select ID into :getId from DHCWL_MKPI.DHCWLMKPIDim where MKPI_Dr=:kpiId and MKPIDim_Code=:dimCode)
		i getId="" {
			&sql(select ID into :tempId from DHCWL_MKPI.DHCWLMKPIDim where MKPI_Dr=:kpiId)
			if ($g(tempId)=""){
				&sql(insert into DHCWL_MKPI.DHCWLMKPIDim (MKPIDim_Code,MKPI_Dr,MKPIDim_DimDr,MKPIDim_Order,MKPIDim_Des,MKPIDim_Deli)
				select t2.KDT_Code,t1.ID kpiId,t1.MKPI_TypeDr,1,t2.KDT_Desc,',' from DHCWL_MKPI.DHCWLMKPI t1,DHCWL_MKPI.DHCWLMKPIDimType t2 where t1.MKPI_TypeDr=t2.ID and t1.ID=:kpiId
				)
			}
		}else{
			;&sql(update DHCWL_MKPI.DHCWLMKPIDim set MKPIDim_Code=:dimCode where ID=:getId)
		}
		s status=SQLCODE
		q:status'=0
	}
	w status
}

/// d ##class(DHCWL.MKPIService.UpgradePackage3).test()
ClassMethod test()
{
	f id=2:1:145 {
		continue:'$d(^DHCWL.MKPI.MKPIDimensionsD(id))
		s col1="",col2=$lg(^DHCWL.MKPI.MKPIDimensionsD(id),2),col3=$lg(^DHCWL.MKPI.MKPIDimensionsD(id),3)
		s col4=$lg(^DHCWL.MKPI.MKPIDimensionsD(id),4),col5=$lg(^DHCWL.MKPI.MKPIDimensionsD(id),5,1),col6=$lg(^DHCWL.MKPI.MKPIDimensionsD(id),6,",")
		&sql(insert into DHCWL_MKPI.DHCWLMKPIDim(MKPIDim_Code,MKPI_Dr,MKPIDim_Des,MKPIDim_DimDr,MKPIDim_Order,MKPIDim_Deli)
		values(:col1,:col2,:col3,:col4,:col5,:col6))
	}
}

/// d ##class(DHCWL.MKPIService.UpgradePackage3).test2()
ClassMethod test2()
{
	s sql="select t2.KDT_Code,t1.ID from DHCWL_MKPI.DHCWLMKPIDim t1,DHCWL_MKPI.DHCWLMKPIDimType t2 where t1.MKPIDim_DimDr=t2.ID"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s code=rs.Data("KDT_Code"),id=rs.Data("ID")
		continue:(code="")||(code=$c(0))||(id<146)
		&sql(update DHCWL_MKPI.DHCWLMKPIDim set MKPIDim_Code=:code where ID=:id)
	}
}

/// create by JEFF for upgrade V4.1
/// w ##class(DHCWL.MKPIService.UpgradePackage3).UpdatePackCreatDataTask()
ClassMethod UpdatePackCreatDataTask() As %Status
{
	s taskRowId=""
	do{
		s taskRowId=$o(^DHCWL.MKPI.CreatDataTaskD(taskRowId))
		q:(""=taskRowId)
		continue:'$d(^DHCWL.MKPI.CreatDataTaskD(taskRowId))
		s taskExcuteCodeDr=$lg(^DHCWL.MKPI.CreatDataTaskD(taskRowId),7,"")
		continue:(""'=taskExcuteCodeDr)
		s taskExcuteCode=$lg(^DHCWL.MKPI.CreatDataTaskD(taskRowId),3,"")
		continue:taskExcuteCode=""
		s mapExcuteCodeRowId=""
		s excuteCodeRowId=$o(^DHCWL.MKPI.ExecuteCodeI("ExcCodeTypeI","TAS"," "_$zcvt(taskExcuteCode,"U"),""))
		if (+excuteCodeRowId>0){
			&sql(update DHCWL_MKPI.DHCWLCreatDataTask set DTask_ExcuteCode_DR=:excuteCodeRowId where ID=:taskRowId)	
		}
		/*
		if (""'=mapExcuteCodeRowId){
			&sql(update DHCWL_MKPI.DHCWLCreatDataTask set DTask_ExcuteCode_DR=:mapExcuteCodeRowId where ID=:taskRowId)	
		}else{
			s obj=##class(DHCWL.SysService.SysExecuteCode).BuildSysExecuteCodeObj("","TAS",taskExcuteCode)
			s result=##class(DHCWL.SysService.SysExecuteCode).Insert(obj)
			s mapExcuteCodeRowId=obj.%Id()
			&sql(update DHCWL_MKPI.DHCWLCreatDataTask set DTask_ExcuteCode_DR=:mapExcuteCodeRowId where ID=:taskRowId)
		}
		i (0'=SQLCODE) {
			w "任务Id："_taskRowId_"更新时出错，SQLCODE："_$g(SQLCODE)
			b
		}*/
	}while(""'=taskRowId)
	q 1
}

/// Creator:		WZ
/// CreatDate:		
/// Description:	配置系统默认的一些设置值，
/// Table:			
/// Input:			
/// Output:			
/// HowToUse:		d class(DHCWL.MKPIService.UpgradePackage3).CfgDefaultSetting()
/// Other:			
ClassMethod CfgDefaultSetting() As %Status
{
	//1、设置日志全局配置里的“任务错误日志”为true
	s code ="GlobalKpiLogTaskErrCfg"
	s desc = "指标任务错误日志全局配置"
	s value ="true"
	s user="Installer"

	s obj=##class(DHCWL.SysService.SysVarService).BuildSysVarObj(code,desc,value,user)
	s result=##class(DHCWL.SysService.SysVarService).Insert(obj)
	//2、设置日志全局配置里的“数据查询日志”为true
	s code ="GlobalKpiLogDataQueryCfg"
	s desc = "指标数据查询日志全局配置"
	s value ="true"
	s user="Installer"

	s obj=##class(DHCWL.SysService.SysVarService).BuildSysVarObj(code,desc,value,user)
	s result=##class(DHCWL.SysService.SysVarService).Insert(obj)
	
	//3、指标任务全局设置中“当某个指标任务出错时，任务挂起，同时将指标数据整个任务挂起？”设置为YES
	s code ="GlobalTaskSuspendCfg"
	s desc = "指标任务出错时的挂起配置"
	s value ="Y"
	s user="Installer"

	s obj=##class(DHCWL.SysService.SysVarService).BuildSysVarObj(code,desc,value,user)
	s result=##class(DHCWL.SysService.SysVarService).Insert(obj)
	q result
}

}
