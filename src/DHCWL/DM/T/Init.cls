Class DHCWL.DM.T.Init Extends %RegisteredObject
{

// d ##class(DHCWL.DM.T.Init).AllInit()

ClassMethod AllInit()
{
  
  /*
  d ##class(DHCWL.DM.T.TypeConfig).TestData()
  d ##class(DHCWL.DM.T.KeyValueConfig).TestData()
  d ##class(DHCWL.DM.T.DataSourceConfig).TestData()
  d ##class(DHCWL.DM.T.Namespace).TestData()
  d ##class(DHCWL.DM.T.DataType).TestData()
  d ##class(DHCWL.DM.T.MetaTableBase).TestData()
  d ##class(DHCWL.DM.T.MetaTablePro).TestData()
  q 
  */
  ;运行Java端建立MetaTablePro的值
  
  d ##class(DHCWL.DM.T.DimBase).TestData()
  d ##class(DHCWL.DM.T.DimProperty).TestData()
  //d ##class(DHCWL.DM.Test.DWTest).BuildDim()
  k ^DHCWL.DM.T.DimDStructD,^DHCWL.DM.T.DimDStructI
  k ^DHCWL.DM.T.DimDataIndexD,^DHCWL.DM.T.DimDataIndexI
  k ^DHCWL.DM.T.GlobalSN
  
  d ##class(DHCWL.DM.T.FunctionConfig).TestData()
  d ##class(DHCWL.DM.T.FunParaConfig).TestData()
  d ##class(DHCWL.DM.T.ThemeBase).TestData()
  d ##class(DHCWL.DM.T.ThemeDims).TestData()
  d ##class(DHCWL.DM.T.ThemeMetrics).TestData()
  d ##class(DHCWL.DM.T.ThemeFetchConfig).TestData()
  d ##class(DHCWL.DM.T.ThemeFetchFilter).TestData()
  //d ##class(DHCWL.DM.Test.DWTest).BuildTheme()
  d ##class(DHCWL.DM.T.CubeBase).TestData()
  d ##class(DHCWL.DM.T.CubeDBDPPart).TestData()
  k ^DHCWL.DM.T.CubeDStructD,^DHCWL.DM.T.CubeDStructI
  //运行Java端建立Dim的数据
}

}
