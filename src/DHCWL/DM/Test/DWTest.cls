Import DHCWL.DM.T

Class DHCWL.DM.Test.DWTest Extends %RegisteredObject
{

// d ##class(DHCWL.DM.Test.DWTest).Init()

ClassMethod Init()
{
	//定义数据源
	/*
    s type=##class(TypeConfig).GetByPath("DATASOURCE:JDBC")
	s obj=##class(DataSourceConfig).%New()
	s obj.Type=type
	s obj.Code="dw"
	s obj.Name="BI MySQL local dw数据源"
	s obj.Description="BI MySQL local dw数据源"
	s obj.IsActived="N"
	w obj.%Save()
	s id=obj.%Id()
	q:id=""
	w id,","
	w !,"KVRowId:"
	s master="DataSourceConfig-"_id
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'url','jdbc:mysql://localhost:3306/dw?&useUnicode=true&characterEncoding=UTF8&useSSL=false'))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'user','root'))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'password','root'))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'driver','com.mysql.jdbc.Driver'))
	w %ROWID,!
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'schema','dw'))
	w %ROWID,!
	*/
	
	
	//定义原型维表
	s type=##class(TypeConfig).GetByPath("META:LOOKUP")
	s ns=##class(Namespace).MetaNamespace("/")
	s ds=##class(DataSourceConfig).GetByPath("JDBC:dw")
	
	/*
	s obj=##class(MetaTableBase).%New()
	s obj.Type=type
	s obj.Namespace=ns
	s obj.Code="dept"
	s obj.Name="科室"
	s obj.Description="科室原型维表"
	s obj.DSConfig=ds
	s obj.Creator="lhh"
	s obj.CreatedDate=+$h
	;s obj.RowKeyFields="CTLOC_RowID"
	d obj.%Save()
	w obj.%Id(),","
	s id=obj.%Id()
	q:id=""
	s master="MetaTableBase-MDS-"_obj.%Id()
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'table','dic_dept'))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'schema','dw'))
	w %ROWID,","
	s obj=##class(MetaTableBase).%New()
	s obj.Type=type
	s obj.Namespace=ns
	s obj.Code="careprov"
	s obj.Name="医护人员"
	s obj.Description="医护人员原型维表"
	s obj.DSConfig=ds
	s obj.Creator="lhh"
	s obj.CreatedDate=+$h
	d obj.%Save()
	w obj.%Id(),","
	s id=obj.%Id()
	q:id=""
	s master="MetaTableBase-MDS-"_obj.%Id()
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'table','dic_careprov'))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'schema','dw'))
	w %ROWID,","
	s obj=##class(MetaTableBase).%New()
	s obj.Type=type
	s obj.Namespace=ns
	s obj.Code="person"
	s obj.Name="病人基本信息"
	s obj.Description="病人基本信息原型维表"
	s obj.DSConfig=ds
	s obj.Creator="lhh"
	s obj.CreatedDate=+$h
	d obj.%Save()
	w obj.%Id(),","
	s id=obj.%Id()
	q:id=""
	s master="MetaTableBase-MDS-"_obj.%Id()
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'table','dic_person'))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'schema','dw'))
	w %ROWID,","
	
	*/
	s obj=##class(MetaTableBase).%New()
	s obj.Type=type
	s obj.Namespace=ns
	s obj.Code="taritem"
	s obj.Name="收费项"
	s obj.Description="收费项原型维表"
	s obj.DSConfig=ds
	s obj.Creator="lhh"
	s obj.CreatedDate=+$h
	d obj.%Save()
	w obj.%Id(),","
	s id=obj.%Id()
	q:id=""
	s master="MetaTableBase-MDS-"_obj.%Id()
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'table','dic_taritem'))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'schema','dw'))
	w %ROWID,","
	
	
	/*
	s type=##class(TypeConfig).GetByPath("META:FACT")
	s obj=##class(MetaTableBase).%New()
	s obj.Type=type
	s obj.Namespace=ns
	s obj.Code="workloadall"
	s obj.Name="workloadall"
	s obj.Description="workloadall"
	s obj.DSConfig=ds
	s obj.Creator="lhh"
	s obj.CreatedDate=+$h
	d obj.%Save()
	w obj.%Id(),","
	s id=obj.%Id()
	q:id=""
	s master="MetaTableBase-MDS-"_obj.%Id()
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'table','dw_workloadall'))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'schema','dw'))
	w %ROWID,","
	d ##class(DHCWL.DM.T.MetaTablePro).TestData()
	
	s type=##class(TypeConfig).GetByPath("META:FACT")
	s obj=##class(MetaTableBase).%New()
	s obj.Type=type
	s obj.Namespace=ns
	s obj.Code="dw_paadm"
	s obj.Name="dw_paadm"
	s obj.Description="dw_paadm"
	s obj.DSConfig=ds
	s obj.Creator="lhh"
	s obj.CreatedDate=+$h
	d obj.%Save()
	w obj.%Id(),","
	s id=obj.%Id()
	q:id=""
	s master="MetaTableBase-MDS-"_obj.%Id()
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'table','dw_paadm'))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'schema','dw'))
	w %ROWID,","
	d ##class(DHCWL.DM.T.MetaTablePro).TestData()
	*/
	
    ;运行Java端建立MetaTablePro的值
}

// d ##class(DHCWL.DM.Test.DWTest).BuildDim()

ClassMethod BuildDim()
{
  s dim=##class(DimBase).BuildDimFromMeta("/dept.ml","Dept_Code")
  s dim=##class(DimBase).BuildDimFromMeta("/careprov.ml","CPV_Code")
  s dim=##class(DimBase).BuildDimFromMeta("/person.ml","PERSON_ID")
  s dim=##class(DimBase).BuildDimFromMeta("/taritem.ml","TARI_Code")
}

// d ##class(DHCWL.DM.Test.DWTest).BuildTheme()

ClassMethod BuildTheme()
{
  s theme=##class(DHCWL.DM.T.ThemeBase).GetByPath("/workloadall.t")
  s theme= ##class(DHCWL.DM.T.ThemeBase).BuildThemeFromMeta("/workloadall.mf","ORDDate",$lb("ORDDate","PersonID","ARCIMDR","TarItemDR","OrderDocDR","OrdLocDR","PatDocDR","PatLocDR","RecLocDR","TarACDR","TarECDR","TarSCDR","ARCICDR","ADMReaSon","PAADMType","FlagDate","PatWardDR","ExecDocDR","WLDate","InsDate","ABDate","ORDTime","FlagTime","WLTime","InsTime","PHCINDR","PRTUser","PRTZYUser","ORDUser","InsTypeDR","PatBedDR","PRTRowid","PRTZYRowid","PAADMID","WorkloadAllId"),$lb("UnitPrice","Quantity","TotalPrice","PayorPrice","DiscPrice","PaSharePrice"))
  w theme,!
  d theme.ChangeDimType($lb("PRTRowid","PRTZYRowid","PAADMID","WorkloadAllId"),"R")
  w theme.SetLinkPath("OrdLocDR","/dept.d")
  w theme.SetLinkPath("PatLocDR","/dept.d")
  w theme.SetLinkPath("RecLocDR","/dept.d")
  w theme.SetLinkPath("OrderDocDR","/careprov.d")
  w theme.SetLinkPath("PatDocDR","/careprov.d")
  w theme.SetLinkPath("ExecDocDR","/careprov.d")
  w theme.SetLinkPath("PersonID","/person.d")
  ;w ##class(DHCWL.DM.T.CubeBase).NewCube2("/workloadall.t",$lb("ORDDate","PersonID","ARCIMDR","TarItemDR","OrderDocDR","OrdLocDR","PatDocDR","PatLocDR","RecLocDR","TarACDR","TarECDR","TarSCDR","ARCICDR","ADMReaSon","PAADMType","FlagDate","PatWardDR","ExecDocDR","WLDate","InsDate","ABDate","ORDTime","FlagTime","WLTime","InsTime","PHCINDR","PRTUser","PRTZYUser","ORDUser","InsTypeDR","PatBedDR","PRTRowid","PRTZYRowid","PAADMID","WorkloadAllId"),$lb("UnitPrice","Quantity","TotalPrice","PayorPrice","DiscPrice","PaSharePrice"))
  ;d ##class(DHCWL.DM.T.CubeDBDPPart).AddThemePart("/workloadall.t")
  ;d ##class(DHCWL.DM.T.CubeDBDPPart).AddThemePart("/workloadall.t")
}

}
