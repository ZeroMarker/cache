Class DHCWL.DM.MDR.MetaTableInit Extends %RegisteredObject
{

// d ##class(DHCWL.DM.MDR.MetaTableInit).DeleteAllTables()

ClassMethod DeleteAllTables()
{
	//*
	&sql(delete DHCWL_DM_T.TypeConfig)
	k ^DHCWL.DM.T.TypeConfigD,^DHCWL.DM.T.TypeConfigI
	
	&sql(delete DHCWL_DM_T.Namespace)
	k ^DHCWL.DM.T.NamespaceD,^DHCWL.DM.T.NamespaceI
	
	&sql(delete DHCWL_DM_T.DataType)
	k ^DHCWL.DM.T.DataTypeD,^DHCWL.DM.T.DataTypeI
	
	&sql(delete DHCWL_DM_T.DataSourceConfig)
	k ^DHCWL.DM.T.DataSourceConfigD,^DHCWL.DM.T.DataSourceConfigI
	
	&sql(delete DHCWL_DM_T.KeyValueConfig)
	k ^DHCWL.DM.T.KeyValueConfigD,^DHCWL.DM.T.KeyValueConfigI
	
	&sql(delete DHCWL_DM_T.FunctionConfig)
	k ^DHCWL.DM.T.FunctionConfigD,^DHCWL.DM.T.FunctionConfigI
	
	&sql(delete DHCWL_DM_T.FunParaConfig)
	k ^DHCWL.DM.T.FunParaConfigD,^DHCWL.DM.T.FunParaConfigI
	
	&sql(delete DHCWL_DM_T.MetaTableBase)
	k ^DHCWL.DM.T.MetaTableBaseI,^DHCWL.DM.T.MetaTableBaseD
	
	&sql(delete DHCWL_DM_T.MetaTablePro)
	k ^DHCWL.DM.T.MetaTableProI,^DHCWL.DM.T.MetaTableProD
	
	&sql(delete DHCWL_DM_T.DimBase)
	k ^DHCWL.DM.T.DimBaseD,^DHCWL.DM.T.DimBaseI
	
	&sql(delete DHCWL_DM_T.DimDataIndex)
	k ^DHCWL.DM.T.DimDataIndexD,^DHCWL.DM.T.DimDataIndexI
	
	k ^DHCWL.DM.T.DimDStructD,^DHCWL.DM.T.DimDStructI
	
	&sql(delete DHCWL_DM_T.DimDStructMap)
	k ^DHCWL.DM.T.DimDStructMapD,^DHCWL.DM.T.DimDStructMapI
	
	&sql(delete DHCWL_DM_T.DimProperty)
	k ^DHCWL.DM.T.DimPropertyD,^DHCWL.DM.T.DimPropertyI
	
	&sql(delete DHCWL_DM_T.ThemeBase)
	k ^DHCWL.DM.T.ThemeBaseD,^DHCWL.DM.T.ThemeBaseI
	
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
	//*/
	&sql(delete DHCWL_DM_T.CubeDStructMap)
	&sql(delete DHCWL_DM_T.CubeBase)
	&sql(delete DHCWL_DM_T.CubeDims)
	&sql(delete DHCWL_DM_T.CubeMetrics)
	k ^DHCWL.DM.T.CubeBaseD,^DHCWL.DM.T.CubeBaseI,^DHCWL.DM.T.CubeDimsD,^DHCWL.DM.T.CubeDimsI,^DHCWL.DM.T.CubeMetricsD,^DHCWL.DM.T.CubeMetricsI,^DHCWL.DM.T.CubeDStructMapI,^DHCWL.DM.T.CubeDStructMapD
	
	&sql(delete DHCWL_DM_T.CubeDBDPPart)
	k ^DHCWL.DM.T.CubeDCDIDLogI,^DHCWL.DM.T.CubeDBDPPartD,^DHCWL.DM.T.CubeDBDPPartI
	
	k ^DHCWL.DM.T.CubeDStructD,^DHCWL.DM.T.CubeDStructV,^DHCWL.DM.T.CubeDStructI,^DHCWL.DM.T.CubeDStructIR
	
	&sql(delete DHCWL_DM_T.CubeFetchConfig)
	k ^DHCWL.DM.T.CubeFetchConfigI,^DHCWL.DM.T.CubeFetchConfigD
	
	&sql(delete DHCWL_DM_T.DataLog)
	k ^DHCWL.DM.T.DataLogI,^DHCWL.DM.T.DataLogD
}

// d ##class(DHCWL.DM.MDR.MetaTableInit).InitDataSource()

ClassMethod InitDataSource()
{
	;d ##class(DHCWL.DM.T.TypeConfig).TestData()
	;d ##class(DHCWL.DM.T.Namespace).TestData()
	;d ##class(DHCWL.DM.T.DataType).TestData()
	;d ##class(DHCWL.DM.T.DataSourceConfig).TestData()
  //定义系统中使用的键值对类型的数据
  /*
  d ##class(DHCWL.DM.T.KeyValueConfig).TestData()
  d ##class(DHCWL.DM.T.FunctionConfig).TestData()
  d ##class(DHCWL.DM.T.FunParaConfig).TestData()
  s type=##class(DHCWL.DM.T.TypeConfig).GetByPath("DATASOURCE:JDBC")
  
  s obj=##class(DHCWL.DM.T.DataSourceConfig).GetByPath("JDBC:MDR-LOCAL")
  if obj=""{
	  s obj=##class(DHCWL.DM.T.DataSourceConfig).%New()
		s obj.Type=type
		s obj.Code="MDR-LOCAL"
		s obj.Name="Caché MDR-LOCAL连接配置"
		s obj.Description="连接10.1.5.89 Caché数据库的MDR命名空间DWBC包下的数据"
		s obj.IsActived="N"
		d obj.%Save()
		s id=obj.%Id()
		q:id=""
		w id,","
		w !,"KVRowId:"
		s master="DataSourceConfig-"_id
		&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'url','jdbc:Cache://mdr_pc:1972/mdr'))
		w %ROWID,","
		&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'user','_SYSTEM'))
		w %ROWID,","
		&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'password','SYS'))
		w %ROWID,","
		&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'driver','com.intersys.jdbc.CacheDriver'))
		w %ROWID,!
		&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'schema','DWBC'))
		w %ROWID,!
  }
  s obj=""
  s obj=##class(DHCWL.DM.T.DataSourceConfig).GetByPath("JDBC:MDR-DW-89")
  if obj=""{
	  s obj=##class(DHCWL.DM.T.DataSourceConfig).%New()
		s obj.Type=type
		s obj.Code="MDR-DW-89"
		s obj.Name="Caché MDR-LOCAL连接配置"
		s obj.Description="连接10.1.5.89 Caché数据库的MDR命名空间DW包下的数据"
		s obj.IsActived="N"
		d obj.%Save()
		s id=obj.%Id()
		q:id=""
		w id,","
		w !,"KVRowId:"
		s master="DataSourceConfig-"_id
		&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'url','jdbc:Cache://mdr_pc:1972/mdr'))
		w %ROWID,","
		&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'user','_SYSTEM'))
		w %ROWID,","
		&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'password','SYS'))
		w %ROWID,","
		&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'driver','com.intersys.jdbc.CacheDriver'))
		w %ROWID,!
		&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'schema','DW'))
		w %ROWID,!
  }
  */
  d ##class(DHCWL.DM.T.FunctionConfig).TestData()
  d ##class(DHCWL.DM.T.FunParaConfig).TestData()
  
  s obj=##class(DHCWL.DM.T.DataSourceConfig).GetByPath("JDBC:MDR-DWBC-LOCAL")
	if obj=""{
		s obj=##class(DHCWL.DM.T.DataSourceConfig).%New()
	}
	s type=##class(DHCWL.DM.T.TypeConfig).GetByPath("DATASOURCE:JDBC")
	s obj.Type=type,obj.Code="MDR-DWBC-LOCAL",obj.Name="Caché MDR-DWBC-LOCAL DWBC库 连接配置"
	s obj.Description="连接localhostCaché数据库的MDR命名空间 DWBC库",obj.IsActived="N"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	s status=##class(DHCWL.DM.T.KeyValueConfig).Put("DataSourceConfig-"_obj.%Id(),"url","jdbc:Cache://localhost:1972/mdr")
	w:status'=$$$OK status,!
	s status= ##class(DHCWL.DM.T.KeyValueConfig).Put("DataSourceConfig-"_obj.%Id(),"user","_SYSTEM")
	w:status'=$$$OK status,!
	s status= ##class(DHCWL.DM.T.KeyValueConfig).Put("DataSourceConfig-"_obj.%Id(),"password","SYS")
	w:status'=$$$OK status,!
	s status= ##class(DHCWL.DM.T.KeyValueConfig).Put("DataSourceConfig-"_obj.%Id(),"driver","com.intersys.jdbc.CacheDriver")
	w:status'=$$$OK status,!
	s status= ##class(DHCWL.DM.T.KeyValueConfig).Put("DataSourceConfig-"_obj.%Id(),"schema","DWBC")
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.DataSourceConfig).GetByPath("JDBC:MDR-DW-LOCAL")
	if obj=""{
		s obj=##class(DHCWL.DM.T.DataSourceConfig).%New()
	}
	s type=##class(DHCWL.DM.T.TypeConfig).GetByPath("DATASOURCE:JDBC")
	s obj.Type=type,obj.Code="MDR-DW-LOCAL",obj.Name="Caché MDR-DW-LOCAL DW库连接配置"
	s obj.Description="连接localhostCaché数据库的MDR命名空间 DW库",obj.IsActived="N"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	s status=##class(DHCWL.DM.T.KeyValueConfig).Put("DataSourceConfig-"_obj.%Id(),"url","jdbc:Cache://localhost:1972/mdr")
	w:status'=$$$OK status,!
	s status= ##class(DHCWL.DM.T.KeyValueConfig).Put("DataSourceConfig-"_obj.%Id(),"user","_SYSTEM")
	w:status'=$$$OK status,!
	s status= ##class(DHCWL.DM.T.KeyValueConfig).Put("DataSourceConfig-"_obj.%Id(),"password","SYS")
	w:status'=$$$OK status,!
	s status= ##class(DHCWL.DM.T.KeyValueConfig).Put("DataSourceConfig-"_obj.%Id(),"driver","com.intersys.jdbc.CacheDriver")
	w:status'=$$$OK status,!
	s status= ##class(DHCWL.DM.T.KeyValueConfig).Put("DataSourceConfig-"_obj.%Id(),"schema","DW")
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.DataSourceConfig).GetByPath("JDBC:MDR-DWBC-89")
	if obj=""{
		s obj=##class(DHCWL.DM.T.DataSourceConfig).%New()
	}
	s type=##class(DHCWL.DM.T.TypeConfig).GetByPath("DATASOURCE:JDBC")
	s obj.Type=type,obj.Code="MDR-DWBC-89",obj.Name="Caché MDR_89 DWBC库连接配置"
	s obj.Description="连接10.1.5.89 Caché数据库的MDR命名空间 DWBC库",obj.IsActived="N"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	s status=##class(DHCWL.DM.T.KeyValueConfig).Put("DataSourceConfig-"_obj.%Id(),"url","jdbc:Cache://10.1.5.89:1972/mdr")
	w:status'=$$$OK status,!
	s status= ##class(DHCWL.DM.T.KeyValueConfig).Put("DataSourceConfig-"_obj.%Id(),"user","_SYSTEM")
	w:status'=$$$OK status,!
	s status= ##class(DHCWL.DM.T.KeyValueConfig).Put("DataSourceConfig-"_obj.%Id(),"password","SYS")
	w:status'=$$$OK status,!
	s status= ##class(DHCWL.DM.T.KeyValueConfig).Put("DataSourceConfig-"_obj.%Id(),"driver","com.intersys.jdbc.CacheDriver")
	w:status'=$$$OK status,!
	s status= ##class(DHCWL.DM.T.KeyValueConfig).Put("DataSourceConfig-"_obj.%Id(),"schema","DWBC")
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.DataSourceConfig).GetByPath("JDBC:MDR-DW-89")
	if obj=""{
		s obj=##class(DHCWL.DM.T.DataSourceConfig).%New()
	}
	s type=##class(DHCWL.DM.T.TypeConfig).GetByPath("DATASOURCE:JDBC")
	s obj.Type=type,obj.Code="MDR-DW-89",obj.Name="Caché MDR_89 DW库 连接配置"
	s obj.Description="连接10.1.5.89 Caché数据库的MDR命名空间 DW库",obj.IsActived="N"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	s status=##class(DHCWL.DM.T.KeyValueConfig).Put("DataSourceConfig-"_obj.%Id(),"url","jdbc:Cache://10.1.5.89:1972/mdr")
	w:status'=$$$OK status,!
	s status= ##class(DHCWL.DM.T.KeyValueConfig).Put("DataSourceConfig-"_obj.%Id(),"user","_SYSTEM")
	w:status'=$$$OK status,!
	s status= ##class(DHCWL.DM.T.KeyValueConfig).Put("DataSourceConfig-"_obj.%Id(),"password","SYS")
	w:status'=$$$OK status,!
	s status= ##class(DHCWL.DM.T.KeyValueConfig).Put("DataSourceConfig-"_obj.%Id(),"driver","com.intersys.jdbc.CacheDriver")
	w:status'=$$$OK status,!
	s status= ##class(DHCWL.DM.T.KeyValueConfig).Put("DataSourceConfig-"_obj.%Id(),"schema","DW")
	w:status'=$$$OK status,!
}

// d ##class(DHCWL.DM.MDR.MetaTableInit).InitThemeMetaTableBase()

ClassMethod InitThemeMetaTableBase()
{
	Set result=##class(%ResultSet).%New("%DynamicQuery:SQL")
	Set sc=result.Prepare("SELECT * FROM DWMDR.CTSubjectDict")
	If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
	Set sc=result.Execute() If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
	s ds=##class(DHCWL.DM.T.DataSourceConfig).GetByPath("JDBC:MDR-DW-89") //JDBC:MDR-DW-89
	s ns=##class(DHCWL.DM.T.Namespace).MetaNamespace("/")
	if ns=""{
		s ns=##class(DHCWL.DM.T.Namespace).CreateNamespace("MT:/")
	}
	s type=##class(DHCWL.DM.T.TypeConfig).GetByPath("META:FACT")
	s obj=##class(DHCWL.DM.T.MetaTableBase).GetByPath("/DHCWorkLoad.mf")
	if obj=""{
		s obj=##class(DHCWL.DM.T.MetaTableBase).%New()
		s obj.Code="DHCWorkLoad",obj.Creator="lhh",obj.Description="收入主题",obj.DSConfig=ds,obj.Name="收入主题"
		s obj.Type=type,obj.Namespace=ns,obj.CreatedDate=+$h,obj.UpdateDate=+$h
		w obj.%Save(),!
		d ##class(DHCWL.DM.T.KeyValueConfig).Put("MetaTableBase-MDS-"_obj.%Id(),"table","DHCWorkLoad")
		d ##class(DHCWL.DM.T.KeyValueConfig).Put("MetaTableBase-MDS-"_obj.%Id(),"schema","DW")
		d ..InitThemeMetaPro(obj,2)
	}else{
		s obj.UpdateDate=+$h
		;s obj.DSConfig=ds
		d obj.%Save()
		d ##class(DHCWL.DM.T.KeyValueConfig).Put("MetaTableBase-MDS-"_obj.%Id(),"table","DHCWorkLoad")
		d ##class(DHCWL.DM.T.KeyValueConfig).Put("MetaTableBase-MDS-"_obj.%Id(),"schema","DW")
		d ..InitThemeMetaPro(obj,2)
	}
	If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
}

ClassMethod InitThemeMetaPro(metaBase As DHCWL.DM.T.MetaTableBase, id)
{
	Set result=##class(%ResultSet).%New("%DynamicQuery:SQL")
	Set sc=result.Prepare("SELECT CTSDDimDR->CTDDCode CTDDCode,CTSDDimDR->CTDDDesc CTDDDesc,CTSDSubjectCode FROM DWMDR.CTSubjectDim WHERE CTSDSubjectDimDR=?")
	If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
	Set sc=result.Execute(id) If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
	s id=metaBase.%Id()
	While result.Next(.sc) {
		If $$$ISERR(sc) Quit
		s code=result.Data("CTSDSubjectCode"),desc=result.Data("CTDDDesc")
		s obj=##class(DHCWL.DM.T.MetaTablePro).GetProperty(id,code)
		if obj=""{
			s obj=##class(DHCWL.DM.T.MetaTablePro).%New()
			s obj.Code=code,obj.Description=desc,obj.Name=desc,obj.DataType=##class(DHCWL.DM.T.DataType).GetByPath("string"),obj.MetaTable=metaBase
			d obj.%Save()
		}else{
			s obj.Code=code,obj.Description=desc,obj.Name=desc,obj.DataType=##class(DHCWL.DM.T.DataType).GetByPath("string"),obj.MetaTable=metaBase
			d obj.%Save()
		}
	}
}

// d ##class(DHCWL.DM.MDR.MetaTableInit).InitDimMetaTableBase()

ClassMethod InitDimMetaTableBase()
{
	Set result=##class(%ResultSet).%New("%DynamicQuery:SQL")
	Set sc=result.Prepare("SELECT ID,CTCTCode, CTCTDesc FROM DWMDR.CTCodeTable WHERE CTCTRemarks IS NULL")
	If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
	Set sc=result.Execute() If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
	s ds=##class(DHCWL.DM.T.DataSourceConfig).GetByPath("JDBC:MDR-DWBC-89")
	s ns=##class(DHCWL.DM.T.Namespace).MetaNamespace("/")
	s type=##class(DHCWL.DM.T.TypeConfig).GetByPath("META:LOOKUP")
	While result.Next(.sc) {
		If $$$ISERR(sc) Quit
		s id=result.Data("ID"),code= result.Data("CTCTCode"),desc=result.Data("CTCTDesc")
		w code_"  "_desc,!
		s obj=##class(DHCWL.DM.T.MetaTableBase).GetByPath("/"_code_".ml")
		if obj=""{
			s obj=##class(DHCWL.DM.T.MetaTableBase).%New()
			s obj.Code=code,obj.Name=desc,obj.Description=desc,obj.DSConfig=ds,obj.Type=type,obj.Namespace=ns,obj.Creator="lhh"
			s obj.CreatedDate=+$h,obj.UpdateDate=+$h
			s status= obj.%Save()
			If $$$ISERR(status) Do DisplayError^%apiOBJ(status) Quit
			d ##class(DHCWL.DM.T.KeyValueConfig).Put("MetaTableBase-MDS-"_obj.%Id(),"table",code)
			d ##class(DHCWL.DM.T.KeyValueConfig).Put("MetaTableBase-MDS-"_obj.%Id(),"schema","DWBC")
			d ..InitMetaPro(obj,id)
			
		}else{
			s obj.UpdateDate=+$h
			;s obj.DSConfig=ds
			d ..InitMetaPro(obj,id)
			d ##class(DHCWL.DM.T.KeyValueConfig).Put("MetaTableBase-MDS-"_obj.%Id(),"table",code)
			d ##class(DHCWL.DM.T.KeyValueConfig).Put("MetaTableBase-MDS-"_obj.%Id(),"schema","DWBC")
		}
		
	}
	If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
}

ClassMethod InitMetaPro(metaBase As DHCWL.DM.T.MetaTableBase, id)
{
	Set result=##class(%ResultSet).%New("%DynamicQuery:SQL")
	Set sc=result.Prepare("SELECT * FROM DWMDR.CTDimProperty WHERE CTCDCodeTableDR=?")
	If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
	Set sc=result.Execute(id) If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
	s id=metaBase.%Id()
	While result.Next(.sc) {
		If $$$ISERR(sc) Quit
		s code=result.Data("CTCDCode"),desc=result.Data("CTCDDesc")
		s obj=##class(DHCWL.DM.T.MetaTablePro).GetProperty(id,code)
		if obj=""{
			s obj=##class(DHCWL.DM.T.MetaTablePro).%New()
			s obj.Code=code,obj.Description=desc,obj.Name=desc,obj.DataType=##class(DHCWL.DM.T.DataType).GetByPath("string"),obj.MetaTable=metaBase
			s sc= obj.%Save()
			If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
		}else{
			s obj.Code=code,obj.Description=desc,obj.Name=desc,obj.DataType=##class(DHCWL.DM.T.DataType).GetByPath("string"),obj.MetaTable=metaBase
			s sc= obj.%Save()
			If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
		}
	}
}

// d ##class(DHCWL.DM.MDR.MetaTableInit).BuildDim()

ClassMethod BuildDim()
{
	s dim=##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/CT_ACChargeCategory.ml","CTACCC_Code")
	s dim=##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/CT_ACChargeChildCategory.ml","CTACCCC_Code")
	s dim=##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/CT_ARCItmMast.ml","CTARCIM_Code")
	s dim=##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/CT_Bed.ml","CTB_Code")
	s dim=##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/CT_BillCat.ml","CTBC_Code")
	s dim=##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/CT_BillChildCat.ml","CTBCC_Code")
	s dim=##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/CT_BusinessField.ml","CTBF_Code")
	s dim=##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/CT_CareProv.ml","CTCP_Code")
	s dim=##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/CT_CareProvPosition.ml","CTCPP_Code")
	s dim=##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/CT_CareProvType.ml","CTCPT_Code")
	s dim=##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/CT_Category.ml","CTC_Code")
	s dim=##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/CT_ChargeCategory.ml","CTCC_Code")
	s dim=##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/CT_ChargeChildCategory.ml","CTCCC_Code")
	s dim=##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/CT_ChargeItem.ml","CTCI_CCCode")
	s dim=##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/CT_ChildCategory.ml","CTCC_Code")
	s dim=##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/CT_Dept.ml","CTD_Code")
	s dim=##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/CT_EMChargeCategory.ml","CTEMCC_Code")
	s dim=##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/CT_EMChargeChildCategory.ml","CTEMCCC_Code")
	s dim=##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/CT_Hospital.ml","CTH_Code")
	s dim=##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/CT_Instr.ml","CTI_Code")
	s dim=##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/CT_IPChargeCategory.ml","CTIPCC_Code")
	s dim=##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/CTIPChargeChildCategory.ml","CTIPCCC_Code")
	s dim=##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/CT_MEDGroup.ml","CTMDG_Code")
	s dim=##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/CT_MRChargeCategory.ml","CTMRCC_Code")
	s dim=##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/CT_MRChargeChildCategory.ml","CTMRCCC_ParentCode")
	s dim=##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/CT_OPChargeCategory.ml","CTOPCC_Code")
	s dim=##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/CT_OPChargeChildCategory.ml","CTOPCCC_Code")
	s dim=##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/CT_PatientPosition.ml","CTPP_Code")
	s dim=##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/CT_PHCPoison.ml","CTPHCP_Code")
	s dim=##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/CT_StaffType.ml","CTST_Code")
	s dim=##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/CT_SubMajor.ml","CTSM_Code")
	s dim=##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/CT_TitleOfTech.ml","CTTT_Code")
	s dim=##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/CT_DIMDAY.ml","M_DAY_CODE")
	s pro= dim.GetProperty("M_DAY_CODE")
	s pro.DataType=##class(DHCWL.DM.T.DataType).GetByPath("date")
	s status=pro.%Save()
	w:status'=$$$OK status,!
	s pro= dim.GetProperty("M_DAY")
	s pro.DataType=##class(DHCWL.DM.T.DataType).GetByPath("date")
	s status=pro.%Save()
	w:status'=$$$OK status,!
	s dim=##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/CT_MDRDictionary.ml","UniCode")
	s dim=##class(DHCWL.DM.T.DimBase).BuildDimFromMeta("/CT_MDRDictionaryType.ml","CTDTCode")
}

// d ##class(DHCWL.DM.MDR.MetaTableInit).LoadDimData()

ClassMethod LoadDimData()
{
	s status=##class(DHCWL.DM.I.Manage).DimDataManualBuild("/CT_ACChargeCategory.d")
	s status=##class(DHCWL.DM.I.Manage).DimDataManualBuild("/CT_ACChargeChildCategory.d")
	s status=##class(DHCWL.DM.I.Manage).DimDataManualBuild("/CT_ARCItmMast.d")
	s status=##class(DHCWL.DM.I.Manage).DimDataManualBuild("/CT_Bed.d")
	s status=##class(DHCWL.DM.I.Manage).DimDataManualBuild("/CT_BillCat.d")
	s status=##class(DHCWL.DM.I.Manage).DimDataManualBuild("/CT_BillChildCat.d")
	s status=##class(DHCWL.DM.I.Manage).DimDataManualBuild("/CT_BusinessField.d")
	s status=##class(DHCWL.DM.I.Manage).DimDataManualBuild("/CT_CT_CareProv.d")
	s status=##class(DHCWL.DM.I.Manage).DimDataManualBuild("/CT_CareProvPosition.d")
	s status=##class(DHCWL.DM.I.Manage).DimDataManualBuild("/CT_CareProvType.d")
	s status=##class(DHCWL.DM.I.Manage).DimDataManualBuild("/CT_Category.d")
	s status=##class(DHCWL.DM.I.Manage).DimDataManualBuild("/CT_ChargeCategory.d")
	s status=##class(DHCWL.DM.I.Manage).DimDataManualBuild("/CT_ChargeChildCategory.d")
	s status=##class(DHCWL.DM.I.Manage).DimDataManualBuild("/CT_ChargeItem.d")
	s status=##class(DHCWL.DM.I.Manage).DimDataManualBuild("/CT_ChildCategory.d")
	s status=##class(DHCWL.DM.I.Manage).DimDataManualBuild("/CT_Dept.d")
	s status=##class(DHCWL.DM.I.Manage).DimDataManualBuild("/CT_EMChargeCategory.d")
	s status=##class(DHCWL.DM.I.Manage).DimDataManualBuild("/CT_EMChargeChildCategory.d")
	s status=##class(DHCWL.DM.I.Manage).DimDataManualBuild("/CT_Hospital.d")
	s status=##class(DHCWL.DM.I.Manage).DimDataManualBuild("/CT_Instr.d")
	s status=##class(DHCWL.DM.I.Manage).DimDataManualBuild("/CT_IPChargeCategory.d")
	s status=##class(DHCWL.DM.I.Manage).DimDataManualBuild("/CTIPChargeChildCategory.d")
	s status=##class(DHCWL.DM.I.Manage).DimDataManualBuild("/CT_MEDGroup.d")
	s status=##class(DHCWL.DM.I.Manage).DimDataManualBuild("/CT_MRChargeCategory.d")
	s status=##class(DHCWL.DM.I.Manage).DimDataManualBuild("/CT_MRChargeChildCategory.d")
	s status=##class(DHCWL.DM.I.Manage).DimDataManualBuild("/CT_OPChargeCategory.d")
	s status=##class(DHCWL.DM.I.Manage).DimDataManualBuild("/CT_OPChargeChildCategory.d")
	s status=##class(DHCWL.DM.I.Manage).DimDataManualBuild("/CT_PatientPosition.d")
	s status=##class(DHCWL.DM.I.Manage).DimDataManualBuild("/CT_PHCPoison.d")
	s status=##class(DHCWL.DM.I.Manage).DimDataManualBuild("/CT_StaffType.d")
	s status=##class(DHCWL.DM.I.Manage).DimDataManualBuild("/CT_SubMajor.d")
	s status=##class(DHCWL.DM.I.Manage).DimDataManualBuild("/CT_TitleOfTech.d")
	s status=##class(DHCWL.DM.I.Manage).DimDataManualBuild("/CT_DIMDAY.d")
	s status=##class(DHCWL.DM.I.Manage).DimDataManualBuild("/CT_MDRDictionary.d")
	s status=##class(DHCWL.DM.I.Manage).DimDataManualBuild("/CT_MDRDictionaryType.d")
}

// d ##class(DHCWL.DM.MDR.MetaTableInit).DimGroupTest()

ClassMethod DimGroupTest()
{
	s obj=##class(DHCWL.DM.T.FunctionConfig).GetByPath("DYCDIMPRO:GroupTest")
	if obj=""{
		s obj=##class(DHCWL.DM.T.FunctionConfig).%New()
	}
	s obj.Name="GroupFun",obj.Type=##class(DHCWL.DM.T.TypeConfig).GetByPath("FUNCTION:DYCDIMPRO")
	s obj.CallExpression="##class(DWMDR.CTSubGrpItem).GetSubGroup"
	s obj.SubType="MR"
	s status=obj.%Save()
	w:status'=$$$OK status,!
	s fun=obj
	s obj=##class(DHCWL.DM.T.FunParaConfig).GetParameter(fun.%Id(),"group")
	s:obj="" obj=##class(DHCWL.DM.T.FunParaConfig).%New()
	s obj.FunctionConfig=fun,obj.ParaIndex=1,obj.Name="group"
	s obj.ValueType=##class(DHCWL.DM.T.DataType).GetByPath("VARCHAR"),obj.IsProperty=0
	s obj.ParamType=##class(DHCWL.DM.T.TypeConfig).GetByPath("PARAM:CONSTANTEVALPASS")
	s status=obj.%Save()
	w:status'=$$$OK status,!
	s obj=##class(DHCWL.DM.T.FunParaConfig).GetParameter(fun.%Id(),"field")
	s:obj="" obj=##class(DHCWL.DM.T.FunParaConfig).%New()
	s obj.FunctionConfig=fun,obj.ParaIndex=2,obj.Name="field"
	s obj.ValueType=##class(DHCWL.DM.T.DataType).GetByPath("VARCHAR"),obj.IsProperty=0
	s obj.ParamType=##class(DHCWL.DM.T.TypeConfig).GetByPath("PARAM:CONSTANTEVALPASS")
	s status=obj.%Save()
	w:status'=$$$OK status,!
	s obj=##class(DHCWL.DM.T.FunParaConfig).GetParameter(fun.%Id(),"Code")
	s:obj="" obj=##class(DHCWL.DM.T.FunParaConfig).%New()
	s obj.FunctionConfig=fun,obj.ParaIndex=3,obj.Name="Code"
	s obj.ValueType=##class(DHCWL.DM.T.DataType).GetByPath("VARCHAR")
	s obj.ParamType=##class(DHCWL.DM.T.TypeConfig).GetByPath("PARAM:EVALPASSBYVAR")
	s status=obj.%Save()
	w:status'=$$$OK status,!
	
	
	
	s dim=##class(DHCWL.DM.T.DimBase).GetByPath("/CT_ACChargeCategory.d")
	s obj=dim.GetProperty("Group")
	if obj=""{
		s obj=##class(DHCWL.DM.T.DimProperty).%New()
	}
	s obj.DimBase=dim,obj.Code="Group",obj.Name="统计组",obj.Description="统计组" ;,obj.DataType=##class(DataType).GetByPath("string")
	s obj.CreatedType=##class(DHCWL.DM.T.TypeConfig).GetByPath("DIM:DYCDIMPRO"),obj.Expression="GroupFun", obj.IsLinked="N"
	s status=obj.%Save()
	w:status'=$$$OK status,!
	
	s dim=##class(DHCWL.DM.T.DimBase).GetByPath("/CT_ACChargeChildCategory.d")
	s obj=dim.GetProperty("Group")
	if obj=""{
		s obj=##class(DHCWL.DM.T.DimProperty).%New()
	}
	s obj.DimBase=dim,obj.Code="Group",obj.Name="统计组",obj.Description="统计组" ;,obj.DataType=##class(DataType).GetByPath("string")
	s obj.CreatedType=##class(DHCWL.DM.T.TypeConfig).GetByPath("DIM:DYCDIMPRO"),obj.Expression="GroupFun", obj.IsLinked="N"
	s status=obj.%Save()
	w:status'=$$$OK status,!
	
	s dim=##class(DHCWL.DM.T.DimBase).GetByPath("/CT_Category.d")
	s obj=dim.GetProperty("Group")
	if obj=""{
		s obj=##class(DHCWL.DM.T.DimProperty).%New()
	}
	s obj.DimBase=dim,obj.Code="Group",obj.Name="统计组",obj.Description="统计组" ;,obj.DataType=##class(DataType).GetByPath("string")
	s obj.CreatedType=##class(DHCWL.DM.T.TypeConfig).GetByPath("DIM:DYCDIMPRO"),obj.Expression="GroupFun", obj.IsLinked="N"
	s status=obj.%Save()
	w:status'=$$$OK status,!
	
	s dim=##class(DHCWL.DM.T.DimBase).GetByPath("/CT_ChildCategory.d")
	s obj=dim.GetProperty("Group")
	if obj=""{
		s obj=##class(DHCWL.DM.T.DimProperty).%New()
	}
	s obj.DimBase=dim,obj.Code="Group",obj.Name="统计组",obj.Description="统计组" ;,obj.DataType=##class(DataType).GetByPath("string")
	s obj.CreatedType=##class(DHCWL.DM.T.TypeConfig).GetByPath("DIM:DYCDIMPRO"),obj.Expression="GroupFun", obj.IsLinked="N"
	s status=obj.%Save()
	w:status'=$$$OK status,!
	
	s dim=##class(DHCWL.DM.T.DimBase).GetByPath("/CT_ARCItmMast.d")
	s obj=dim.GetProperty("Group")
	if obj=""{
		s obj=##class(DHCWL.DM.T.DimProperty).%New()
	}
	s obj.DimBase=dim,obj.Code="Group",obj.Name="统计组",obj.Description="统计组" ;,obj.DataType=##class(DataType).GetByPath("string")
	s obj.CreatedType=##class(DHCWL.DM.T.TypeConfig).GetByPath("DIM:DYCDIMPRO"),obj.Expression="GroupFun", obj.IsLinked="N"
	s status=obj.%Save()
	w:status'=$$$OK status,!
	
	s dim=##class(DHCWL.DM.T.DimBase).GetByPath("/CT_BillCat.d")
	s obj=dim.GetProperty("Group")
	if obj=""{
		s obj=##class(DHCWL.DM.T.DimProperty).%New()
	}
	s obj.DimBase=dim,obj.Code="Group",obj.Name="统计组",obj.Description="统计组" ;,obj.DataType=##class(DataType).GetByPath("string")
	s obj.CreatedType=##class(DHCWL.DM.T.TypeConfig).GetByPath("DIM:DYCDIMPRO"),obj.Expression="GroupFun", obj.IsLinked="N"
	s status=obj.%Save()
	w:status'=$$$OK status,!
	
	s dim=##class(DHCWL.DM.T.DimBase).GetByPath("/CT_BillChildCat.d")
	s obj=dim.GetProperty("Group")
	if obj=""{
		s obj=##class(DHCWL.DM.T.DimProperty).%New()
	}
	s obj.DimBase=dim,obj.Code="Group",obj.Name="统计组",obj.Description="统计组" ;,obj.DataType=##class(DataType).GetByPath("string")
	s obj.CreatedType=##class(DHCWL.DM.T.TypeConfig).GetByPath("DIM:DYCDIMPRO"),obj.Expression="GroupFun", obj.IsLinked="N"
	s status=obj.%Save()
	w:status'=$$$OK status,!
	
	s dim=##class(DHCWL.DM.T.DimBase).GetByPath("/CT_Dept.d")
	s obj=dim.GetProperty("Group")
	if obj=""{
		s obj=##class(DHCWL.DM.T.DimProperty).%New()
	}
	s obj.DimBase=dim,obj.Code="Group",obj.Name="统计组",obj.Description="统计组" ;,obj.DataType=##class(DataType).GetByPath("string")
	s obj.CreatedType=##class(DHCWL.DM.T.TypeConfig).GetByPath("DIM:DYCDIMPRO"),obj.Expression="GroupFun", obj.IsLinked="N"
	s status=obj.%Save()
	w:status'=$$$OK status,!
	
	s dim=##class(DHCWL.DM.T.DimBase).GetByPath("/CT_Hospital.d")
	s obj=dim.GetProperty("Group")
	if obj=""{
		s obj=##class(DHCWL.DM.T.DimProperty).%New()
	}
	s obj.DimBase=dim,obj.Code="Group",obj.Name="统计组",obj.Description="统计组" ;,obj.DataType=##class(DataType).GetByPath("string")
	s obj.CreatedType=##class(DHCWL.DM.T.TypeConfig).GetByPath("DIM:DYCDIMPRO"),obj.Expression="GroupFun", obj.IsLinked="N"
	s status=obj.%Save()
	w:status'=$$$OK status,!
	
	s dim=##class(DHCWL.DM.T.DimBase).GetByPath("/CT_CareProv.d")
	s obj=dim.GetProperty("Group")
	if obj=""{
		s obj=##class(DHCWL.DM.T.DimProperty).%New()
	}
	s obj.DimBase=dim,obj.Code="Group",obj.Name="统计组",obj.Description="统计组" ;,obj.DataType=##class(DataType).GetByPath("string")
	s obj.CreatedType=##class(DHCWL.DM.T.TypeConfig).GetByPath("DIM:DYCDIMPRO"),obj.Expression="GroupFun", obj.IsLinked="N"
	s status=obj.%Save()
	w:status'=$$$OK status,!
	
	s dim=##class(DHCWL.DM.T.DimBase).GetByPath("/CT_EMChargeCategory.d")
	s obj=dim.GetProperty("Group")
	if obj=""{
		s obj=##class(DHCWL.DM.T.DimProperty).%New()
	}
	s obj.DimBase=dim,obj.Code="Group",obj.Name="统计组",obj.Description="统计组" ;,obj.DataType=##class(DataType).GetByPath("string")
	s obj.CreatedType=##class(DHCWL.DM.T.TypeConfig).GetByPath("DIM:DYCDIMPRO"),obj.Expression="GroupFun", obj.IsLinked="N"
	s status=obj.%Save()
	w:status'=$$$OK status,!
	
	s dim=##class(DHCWL.DM.T.DimBase).GetByPath("/CT_EMChargeChildCategory.d")
	s obj=dim.GetProperty("Group")
	if obj=""{
		s obj=##class(DHCWL.DM.T.DimProperty).%New()
	}
	s obj.DimBase=dim,obj.Code="Group",obj.Name="统计组",obj.Description="统计组" ;,obj.DataType=##class(DataType).GetByPath("string")
	s obj.CreatedType=##class(DHCWL.DM.T.TypeConfig).GetByPath("DIM:DYCDIMPRO"),obj.Expression="GroupFun", obj.IsLinked="N"
	s status=obj.%Save()
	w:status'=$$$OK status,!
}

}
