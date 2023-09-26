Class DHCWL.DM.Test.MDRTest Extends %RegisteredObject
{

// d ##class(DHCWL.DM.Test.MDRTest).InitDataSource()

ClassMethod InitDataSource()
{
  s type=##class(DHCWL.DM.T.TypeConfig).GetByPath("DATASOURCE:JDBC")
  s obj=##class(DHCWL.DM.T.DataSourceConfig).GetByPath("JDBC:MDR-89")
  if obj=""{
	  s obj=##class(DHCWL.DM.T.DataSourceConfig).%New()
		s obj.Type=type
		s obj.Code="MDR-89"
		s obj.Name="Caché MDR-89连接配置"
		s obj.Description="连接10.1.5.89 Caché数据库的MDR命名空间"
		s obj.IsActived="N"
		d obj.%Save()
		s id=obj.%Id()
		q:id=""
		w id,","
		w !,"KVRowId:"
		s master="DataSourceConfig-"_id
		&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'url','jdbc:Cache://10.1.5.89:1972/mdr'))
		w %ROWID,","
		&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'user','_SYSTEM'))
		w %ROWID,","
		&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'password','SYS'))
		w %ROWID,","
		&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'driver','com.intersys.jdbc.CacheDriver'))
		w %ROWID,!
  }
}

// d ##class(DHCWL.DM.Test.MDRTest).InitMeta()

ClassMethod InitMeta()
{
	
	s type=##class(DHCWL.DM.T.TypeConfig).GetByPath("META:LOOKUP")
	s ns=##class(DHCWL.DM.T.Namespace).MetaNamespace("/")
	s ds=##class(DHCWL.DM.T.DataSourceConfig).GetByPath("JDBC:MDR-89") //DHCAPP_LOCAL
	s obj=##class(DHCWL.DM.T.MetaTableBase).GetByPath("/CT_ACChargeCategory.ml")
	if obj=""{
		s obj=##class(DHCWL.DM.T.MetaTableBase).%New()
		s obj.Type=type
		s obj.Namespace=ns
		s obj.Code="CT_ACChargeCategory"
		s obj.Name="会计大类字典表"
		s obj.Description="会计大类字典表"
		s obj.DSConfig=ds
		s obj.Creator="lhh"
		s obj.CreatedDate=+$h
		d obj.%Save()
		w obj.%Id(),","
		s id=obj.%Id()
		q:id=""
		s master="MetaTableBase-MDS-"_obj.%Id()
		&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'table','CT_ACChargeCategory'))
		w %ROWID,","
		;&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'catalog',''))
		;w %ROWID,","
		&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'schema','DWBC'))
		w %ROWID,","
		s status=##class(DHCWL.DM.I.Manage).MetaInfoBuild("/CT_ACChargeCategory.ml")
	}
}

}
