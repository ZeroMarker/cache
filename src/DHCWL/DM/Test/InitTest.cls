Class DHCWL.DM.Test.InitTest Extends %RegisteredObject
{

// d ##class(DHCWL.DM.Test.InitTest).InitFirst()

ClassMethod InitFirst()
{
  //定义系统中使用的字典编码
  d ##class(DHCWL.DM.T.TypeConfig).TestData()
  //定义系统中使用的键值对类型的数据
  d ##class(DHCWL.DM.T.KeyValueConfig).TestData()
  //配置系统中可以连接到的数据源
  d ##class(DHCWL.DM.T.DataSourceConfig).TestData()
  //定义维度、主题等要使用的命名空间
  d ##class(DHCWL.DM.T.Namespace).TestData()
  //初始化数据类型
  d ##class(DHCWL.DM.T.DataType).TestData()
  //定义连接到的原型表，包括原型维表和原型事实表
  d ##class(DHCWL.DM.T.MetaTableBase).TestData()
  //初始化原型表属性存储表格
  d ##class(DHCWL.DM.T.MetaTablePro).TestData()
}

// d ##class(DHCWL.DM.Test.InitTest).InitWorkloadMeta()

ClassMethod InitWorkloadMeta()
{
	s type=##class(DHCWL.DM.T.TypeConfig).GetByPath("META:FACT")
	s ns=##class(DHCWL.DM.T.Namespace).MetaNamespace("/")
	s ds=##class(DHCWL.DM.T.DataSourceConfig).GetByPath("JDBC:DHCAPP_LOCAL")
	s obj=##class(DHCWL.DM.T.MetaTableBase).%New()
	s obj.Type=type
	s obj.Namespace=ns
	s obj.Code="WorkLoad"
	s obj.Name="收入"
	s obj.Description="综合查询收入数据仓库"
	s obj.DSConfig=ds
	s obj.Creator="lhh"
	s obj.CreatedDate=+$h
	;s obj.RowKeyFields="WorkLoad_Rowid"
	d obj.%Save()
	w obj.%Id(),","
	s id=obj.%Id()
	q:id=""
	s master="MetaTableBase-MDS-"_obj.%Id()
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'table','DHC_WorkLoad'))
	w %ROWID,","
	;&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'catalog',''))
	;w %ROWID,","
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'schema','SQLUSER'))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'EnumeratorClass','com.dhcwl.dm.adapter.jdbc.JDBCEnumeratorTable'))
	w %ROWID,","
}

// d ##class(DHCWL.DM.Test.InitTest).InitSecond()

ClassMethod InitSecond()
{
  //定义维度
  /*
  d ##class(DHCWL.DM.T.DimBase).TestData()
  //定义维度包含的属性
  d ##class(DHCWL.DM.T.DimProperty).TestData()
  //直接根据原型维表定义维度 维度名称是taritem，维度属性包括原型维表taritem中所有的字段
  w ##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/taritem.ml","TARI_RowId")
  //直接根据原型维表定义维度 维度名称是arcItmMast，维度属性包括原型维表arcItmMast中所有的字段
  w ##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/arcItmMast.ml","ARCIM_RowId")
  //直接根据原型维表定义维度 维度名称是paPatMas，维度属性包括原型维表paPatMas中所有的字段
  w ##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/paPatMas.ml","PAPMI_RowId")
  //清除数据
  k ^DHCWL.DM.T.DimDStructD,^DHCWL.DM.T.DimDStructI
  k ^DHCWL.DM.T.DimDataIndexD,^DHCWL.DM.T.DimDataIndexI
  k ^DHCWL.DM.T.GlobalSN
  //定义系统中的函数，包括过滤函数，聚合函数，维度方法等
  d ##class(DHCWL.DM.T.FunctionConfig).TestData()
  //定义函数入参
  d ##class(DHCWL.DM.T.FunParaConfig).TestData()
  */
  &sql(delete DHCWL_DM_T.ThemeDims)
  k ^DHCWL.DM.T.ThemeDimsD,^DHCWL.DM.T.ThemeDimsI
  &sql(delete DHCWL_DM_T.ThemeDStructMap)
  k ^DHCWL.DM.T.ThemeDStructMapD,^DHCWL.DM.T.ThemeDStructMapI
  &sql(delete DHCWL_DM_T.ThemeFetchConfig)
  k ^DHCWL.DM.T.ThemeFetchConfigD,^DHCWL.DM.T.ThemeFetchConfigI
  &sql(delete DHCWL_DM_T.ThemeFetchFilter)
  k ^DHCWL.DM.T.ThemeFetchFilterD,^DHCWL.DM.T.ThemeFetchFilterI
  &sql(delete DHCWL_DM_T.ThemeMetrics)
  k ^DHCWL.DM.T.ThemeMetricsD,^DHCWL.DM.T.ThemeMetricsI
  &sql(delete DHCWL_DM_T.ThemeBase)
  k ^DHCWL.DM.T.ThemeBaseD,^DHCWL.DM.T.ThemeBaseI
  //直接根据原型维表定义主题，主题包括的维度和度量分别在第二、三个参数指定。
  s theme= ##class(DHCWL.DM.T.ThemeBase).BuildThemeFromMeta("/WorkLoad.mf","WorkLoad_OrdDate",$lb("WorkLoad_OrdDate","WorkLoad_PAPMI_DR","WorkLoad_TarItem_DR","WorkLoad_BillSub_DR","WorkLoad_BillGrp_DR","WorkLoad_RecDep_DR","WorkLoad_ItemCat_DR","WorkLoad_PatDoc_DR","WorkLoad_RecDoc_DR","WorkLoad_ResDoc_DR","WorkLoad_PatDep_DR","WorkLoad_PatWard_DR","WorkLoad_ResDep_DR","WorkLoad_Type","WorkLoad_TarSC_Dr","WorkLoad_TarOut_Dr","WorkLoad_OrdStatus","WorkLoad_StatDate","WorkLoad_DisDate","WorkLoad_FlagDate","WorkLoad_Flag","WorkLoad_UserDep_DR","WorkLoad_User_DR","WorkLoad_DisFlag","WorkLoad_TarAC_dr","WorkLoad_TarEC_Dr","WorkLoad_TarMC_Dr","WorkLoad_TarIC_Dr","WorkLoad_TarMCNew_Dr","WorkLoad_ResMedUnitCareProv_dr","WorkLoad_RecMedUnitCareProv_dr","WorkLoad_PatMedUnitCareProv_dr","WorkLoad_AdmReason_DR","WorkLoad_SocialStatus_DR","WorkLoad_CasherO_DR","WorkLoad_OrdTime","WorkLoad_StatTime","WorkLoad_HoldDep_DR","WorkLoad_HoldDoc_DR","WorkLoad_HoldFlagDate","WorkLoad_CasherI_DR","WorkLoad_HoldFlag","WorkLoad_DataType","WorkLoad_FlagTime","WorkLoad_ItemOrd_DR","WorkLoad_PAADM_DR","WorkLoad_ARPBL_DR","WorkLoad_OEORI_DR","WorkLoad_ReceiptI_DR","WorkLoad_ReceiptO_DR","WorkLoad_PBDDR","WorkLoad_OEORE_Dr","WorkLoad_PHCC_DR","WorkLoad_PHCD_DR","WorkLoad_PHCDF_DR","WorkLoad_PHCIN_DR","WorkLoad_Rowid"),$lb("WorkLoad_UnitPrice","WorkLoad_Quantity","WorkLoad_TotalPrice","WorkLoad_PayorPrice","WorkLoad_DiscPrice","WorkLoad_PaSharePrice"))
  w theme,!
  //更改维度的类型，将WorkLoad_OEORE_Dr等类型的字段（不适合做Group操作的维度）定义成关系
  d theme.ChangeDimType($lb("WorkLoad_ItemOrd_DR","WorkLoad_PAADM_DR","WorkLoad_ARPBL_DR","WorkLoad_OEORI_DR","WorkLoad_ReceiptI_DR","WorkLoad_ReceiptO_DR","WorkLoad_PBDDR","WorkLoad_OEORE_Dr","WorkLoad_PHCC_DR","WorkLoad_PHCD_DR","WorkLoad_PHCDF_DR","WorkLoad_PHCIN_DR","WorkLoad_Rowid"),"R")
  w "setLinkPath:",!
  //设置主题维度字段关联的维度路径
  w theme.SetLinkPath("WorkLoad_ResDep_DR","/Department.d")
  w theme.SetLinkPath("WorkLoad_RecDep_DR","/Department.d")
  w theme.SetLinkPath("WorkLoad_PAPMI_DR","/paPatMas.d")
  w theme.SetLinkPath("WorkLoad_RecDoc_DR","/Doctor.d")
  w theme.SetLinkPath("WorkLoad_ResDoc_DR","/Doctor.d")
  w theme.SetLinkPath("WorkLoad_TarItem_DR","/taritem.d")
  w theme.SetLinkPath("WorkLoad_PatDep_DR","/Department.d")
  w theme.SetLinkPath("WorkLoad_PatWard_DR","/Department.d")
  w theme.SetLinkPath("WorkLoad_PatDoc_DR","/Doctor.d")
  w theme.SetLinkPath("WorkLoad_UserDep_DR","/Department.d")
  &sql(delete DHCWL_DM_T.CubeDStructMap)
  &sql(delete DHCWL_DM_T.CubeBase)
  &sql(delete DHCWL_DM_T.CubeDims)
  &sql(delete DHCWL_DM_T.CubeMetrics)
  k ^DHCWL.DM.T.CubeBaseD,^DHCWL.DM.T.CubeBaseI,^DHCWL.DM.T.CubeDimsD,^DHCWL.DM.T.CubeDimsI,^DHCWL.DM.T.CubeMetricsD,^DHCWL.DM.T.CubeMetricsI,^DHCWL.DM.T.CubeDStructMapI,^DHCWL.DM.T.CubeDStructMapD
  //定义主题的Cube
  w ##class(DHCWL.DM.T.CubeBase).NewCube2("/WorkLoad.t",$lb("WorkLoad_OrdDate","WorkLoad_PAPMI_DR","WorkLoad_TarItem_DR","WorkLoad_BillSub_DR","WorkLoad_BillGrp_DR","WorkLoad_RecDep_DR","WorkLoad_ItemCat_DR","WorkLoad_PatDoc_DR","WorkLoad_RecDoc_DR","WorkLoad_ResDoc_DR","WorkLoad_PatDep_DR","WorkLoad_PatWard_DR","WorkLoad_ResDep_DR","WorkLoad_Type","WorkLoad_TarSC_Dr","WorkLoad_TarOut_Dr","WorkLoad_OrdStatus","WorkLoad_FlagDate","WorkLoad_Flag","WorkLoad_TarAC_dr","WorkLoad_TarEC_Dr","WorkLoad_TarMC_Dr","WorkLoad_TarIC_Dr","WorkLoad_AdmReason_DR","WorkLoad_SocialStatus_DR"),$lb("WorkLoad_UnitPrice","WorkLoad_Quantity","WorkLoad_TotalPrice","WorkLoad_PayorPrice","WorkLoad_DiscPrice","WorkLoad_PaSharePrice"))
  w ##class(DHCWL.DM.T.CubeBase).NewCube2("/WorkLoad.t",$lb("WorkLoad_OrdDate","WorkLoad_PAPMI_DR","WorkLoad_TarItem_DR","WorkLoad_BillSub_DR","WorkLoad_BillGrp_DR","WorkLoad_RecDep_DR","WorkLoad_ItemCat_DR","WorkLoad_PatDoc_DR","WorkLoad_RecDoc_DR","WorkLoad_ResDoc_DR","WorkLoad_PatDep_DR","WorkLoad_PatWard_DR","WorkLoad_ResDep_DR","WorkLoad_Type","WorkLoad_TarSC_Dr","WorkLoad_TarOut_Dr","WorkLoad_OrdStatus","WorkLoad_StatDate","WorkLoad_DisDate","WorkLoad_FlagDate","WorkLoad_Flag","WorkLoad_UserDep_DR","WorkLoad_User_DR","WorkLoad_DisFlag","WorkLoad_TarAC_dr","WorkLoad_TarEC_Dr","WorkLoad_TarMC_Dr","WorkLoad_TarIC_Dr","WorkLoad_TarMCNew_Dr","WorkLoad_ResMedUnitCareProv_dr","WorkLoad_RecMedUnitCareProv_dr","WorkLoad_PatMedUnitCareProv_dr","WorkLoad_AdmReason_DR","WorkLoad_SocialStatus_DR","WorkLoad_CasherO_DR","WorkLoad_OrdTime","WorkLoad_StatTime","WorkLoad_HoldDep_DR","WorkLoad_HoldDoc_DR","WorkLoad_HoldFlagDate","WorkLoad_CasherI_DR","WorkLoad_HoldFlag","WorkLoad_DataType","WorkLoad_FlagTime","WorkLoad_ItemOrd_DR","WorkLoad_PAADM_DR","WorkLoad_ARPBL_DR","WorkLoad_OEORI_DR","WorkLoad_ReceiptI_DR","WorkLoad_ReceiptO_DR","WorkLoad_PBDDR","WorkLoad_OEORE_Dr","WorkLoad_PHCC_DR","WorkLoad_PHCD_DR","WorkLoad_PHCDF_DR","WorkLoad_PHCIN_DR","WorkLoad_Rowid"),$lb("WorkLoad_UnitPrice","WorkLoad_Quantity","WorkLoad_TotalPrice","WorkLoad_PayorPrice","WorkLoad_DiscPrice","WorkLoad_PaSharePrice"))
  
  k ^DHCWL.DM.T.CubeDCDIDLogI
  k ^DHCWL.DM.T.CubeDStructD,^DHCWL.DM.T.CubeDStructI
  k ^DHCWL.DM.T.CubeDStructM,^DHCWL.DM.T.CubeDStructR,^DHCWL.DM.T.CubeDStructIR
  &sql(delete DHCWL_DM_T.CubeDBDPPart )
  k ^DHCWL.DM.T.CubeDBDPPartI,^DHCWL.DM.T.CubeDBDPPartD
  // 配置Cube数据存储分区调用一次AddThemePart方法增加一个新的分区
  d ##class(DHCWL.DM.T.CubeDBDPPart).AddThemePart("/WorkLoad.t")
  d ##class(DHCWL.DM.T.CubeDBDPPart).AddThemePart("/WorkLoad.t")
  d ##class(DHCWL.DM.T.CubeDBDPPart).AddThemePart("/WorkLoad.t")
  d ##class(DHCWL.DM.T.CubeDBDPPart).AddThemePart("/WorkLoad.t")
}

}
