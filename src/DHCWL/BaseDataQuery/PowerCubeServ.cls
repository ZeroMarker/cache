Class DHCWL.BaseDataQuery.PowerCubeServ Extends %RegisteredObject
{

// d ##class(DHCWL.BaseDataQuery.PowerCubeServ).BuildPowerCube("2018-03-23","2018-04-11")

ClassMethod BuildPowerCube(startDate As %String, endDate As %String)
{
	s powerCubePrj("DHCWorkload")=""
	//s powerCubePrj("DHCMrinfo")=""
	//初始化基础数据
	d ##class(DHCWL.DM.T.MetaTableBase).TestData()
	d ##class(DHCWL.DM.T.MetaTablePro).TestData()
	d ##class(DHCWL.DM.T.KeyValueConfig).TestData()
	d ##class(DHCWL.DM.T.DataSourceConfig).TestData()
	d ##class(DHCWL.DM.Test.MRInfoInit).NewProject()
	
	//
	if $d(powerCubePrj("DHCMrinfo")) {
		d ##class(DHCWL.DM.Test.MRInfoInit).InitMeta()
		d ##class(DHCWL.DM.Test.MRInfoInit).InitMetaProNameDes() //初始化维度、度量的名称和描述
		d ##class(DHCWL.DM.Test.MRInfoInit).InitTheme()	//构建病案主题
			/*增加函数维度。如果没有函数维度，下面语句可以不用执行*/
			d ##class(DHCWL.DM.Test.MRInfoInit).AddFunDim()		//增加函数维度
		d ##class(DHCWL.DM.T.FunctionConfig).TestData()	//设置（汇总）函数配置
		d ##class(DHCWL.DM.T.FunParaConfig).TestData()	//设置（汇总）函数参数
		d ##class(DHCWL.DM.Test.MRInfoInit).InitCube()	//构建基本的Cube
		d ##class(DHCWL.DM.Test.MRInfoInit).InitBaseDim()	//构建基础维度
		d ##class(DHCWL.DM.Test.MRInfoInit).InitThemeDimLinkPath()	//配置病案主题中维度的连接路径

		s status=##class(DHCWL.DM.I.Manage).ThemeDataManualBuild("/DHCMRInfo.t",startDate,endDate)	//完成Cube数据的构造
		//d ##class(DHCWL.DM.Test.MRInfoInit).QueryMRInfo("2018-02-01","2018-03-31") //运行病案主题数据的CQL查询测试
	
	}
	
	if $d(powerCubePrj("DHCWorkload")) {
		d ##class(DHCWL.DM.Test.WorkloadInit).InitWorkloadMeta()
		//2、初始化维度、度量的名称和描述
		d ..InitWLMetaProNameDes()
		
		d ##class(DHCWL.DM.Test.WorkloadInit).InitTheme()
		
		d ##class(DHCWL.DM.Test.WorkloadInit).InitCube()
		d ##class(DHCWL.DM.Test.MRInfoInit).InitBaseDim()	//构建基础维度
		d ##class(DHCWL.DM.Test.WorkloadInit).InitThemeDimLinkPath()
		s status=##class(DHCWL.DM.I.Manage).ThemeDataManualBuild("/WorkLoad.t",startDate,endDate)	//完成Cube数据的构造

	}
	
	d ##class(DHCWL.DM.I.Manage).DimDataTask()
}

ClassMethod InitWLMetaProNameDes()
{
	s wlinfoObj=##class(DHCWL.DM.T.MetaTableBase).GetByPath("/WorkLoad.mf")
	
	s obj=##class(DHCWL.DM.T.MetaTableBase).GetByPath("/WorkLoad.mf")
	s proCodes="WorkLoad_RecDep_DR,WorkLoad_ItemOrd_DR,WorkLoad_ResDep_DR,WorkLoad_Type,WorkLoad_OrdDate,WorkLoad_OrdTime,WorkLoad_StatDate,WorkLoad_StatTime,WorkLoad_ItemCat_DR,WorkLoad_BillGrp_DR,WorkLoad_BillSub_DR,WorkLoad_PAADM_DR,WorkLoad_PAPMI_DR,WorkLoad_UnitPrice,WorkLoad_Quantity,WorkLoad_TotalPrice,WorkLoad_OrdStatus,WorkLoad_RecDoc_DR,WorkLoad_ResDoc_DR,WorkLoad_ARPBL_DR,WorkLoad_OEORI_DR,WorkLoad_TarItem_DR,WorkLoad_PatDep_DR,WorkLoad_PatWard_DR,WorkLoad_PatDoc_DR,WorkLoad_Flag,WorkLoad_FlagDate,WorkLoad_ReceiptI_DR,WorkLoad_ReceiptO_DR,WorkLoad_CasherI_DR,WorkLoad_CasherO_DR,WorkLoad_UserDep_DR,WorkLoad_User_DR,WorkLoad_HoldFlag,WorkLoad_HoldFlagDate,WorkLoad_HoldDep_DR,WorkLoad_HoldDoc_DR,WorkLoad_DisDate,WorkLoad_DisFlag,WorkLoad_TarAC_dr,WorkLoad_TarEC_Dr,WorkLoad_TarIC_Dr,WorkLoad_TarMC_Dr,WorkLoad_TarOut_Dr,WorkLoad_TarSC_Dr,WorkLoad_FlagTime,WorkLoad_DataType,WorkLoad_PBDDR,WorkLoad_ResMedUnitCareProv_dr,WorkLoad_RecMedUnitCareProv_dr,WorkLoad_PatMedUnitCareProv_dr,WorkLoad_AdmReason_DR,WorkLoad_TarMCNew_Dr,WorkLoad_OEORE_Dr,WorkLoad_SocialStatus_DR,WorkLoad_PHCC_DR,WorkLoad_PHCD_DR,WorkLoad_PHCDF_DR,WorkLoad_PHCIN_DR,WorkLoad_PayorPrice,WorkLoad_DiscPrice,WorkLoad_PaSharePrice,WorkLoad_PatRoom_DR,WorkLoad_PatBed_DR"
	s proDes="执行科室,医嘱项,病人科室,病人类型,医嘱日期,医嘱时间,插入数据日期,插入数据时间,医嘱子类,帐单大类,帐单子类,就诊信息,患者基本信息,单价,医嘱数量,费用,,执行医生,下医嘱医生,帐单号,医嘱,收费项目,下医嘱科室,病人病区,病人医生,结束标志,结算日期,,,,,,,,,,,,,会计分类,核算分类,住院分类,病案分类,门诊分类,,,,,,,,,新病案分类,,,,,,,,,,"
	w $l(proCodes,",")=$l(proDes,",")
	f i=1:1:$l(proCodes,","){
	  s code=$p(proCodes,",",i)
	  s des=$p(proDes,",",i)
	  s proObj=wlinfoObj.GetProperty(code)
	  continue:proObj=""
	  s proObj.Name=des
	  s proObj.Description=des
	  w proObj.%Save()
	  s proObj=""
	}
}

}
