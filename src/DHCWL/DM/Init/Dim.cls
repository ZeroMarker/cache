Import DHCWL.DM.T

Class DHCWL.DM.Init.Dim Extends %RegisteredObject
{

// d ##class(DHCWL.DM.Init.Dim).InitAll()

ClassMethod InitAll()
{
	//TODO 用JDBC:DHC-APP-LOCAL数据源连接配置创建维度原型，根据需要修改成实际的数据源连接
	d ##class(DHCWL.DM.Init.Dim).Meta("JDBC:DHC-APP-LOCAL")
}

ClassMethod Meta(dataSouceConfigPath)
{
	s ds=##class(DHCWL.DM.T.DataSourceConfig).GetByPath(dataSouceConfigPath)
	s ns=##class(DHCWL.DM.T.Namespace).MetaNamespace("/")
	s type=##class(DHCWL.DM.T.TypeConfig).GetByPath("META:LOOKUP")
	s obj=##class(DHCWL.DM.T.MetaTableBase).GetByPath("/CTLOC.ml")
	if obj=""{
		s obj=##class(DHCWL.DM.T.MetaTableBase).%New()
	}
	s obj.Type=type,obj.Namespace=ns,obj.Code="CTLOC"
	s obj.Name="科室维表",obj.Description="科室维表"
	s obj.DSConfig=ds,obj.Creator="lhh",obj.CreatedDate=+$h
	s status=obj.%Save()
	w:status'=$$$OK status,!
	s master="MetaTableBase-MDS-"_obj.%Id()
	s status=##class(DHCWL.DM.T.KeyValueConfig).Put(master,"table","ct_loc")
	w:status'=$$$OK status,!
	s status=##class(DHCWL.DM.T.KeyValueConfig).Put(master,"schema","SQLUSER")
	w:status'=$$$OK status,!
	s status=##class(DHCWL.DM.I.Manage).MetaInfoBuild("/CTLOC.ml")
	
	s ml=##class(MetaTableBase).GetByPath("/CTLOC.ml")
	s ns=##class(Namespace).GetByPath("DI:/")
	s dim=##class(DimBase).GetByPath("/CTLOC.d")
	if dim=""{
		s dim=##class(DimBase).%New()
	}
	s dim.Namespace=ns,dim.Code="CTLOC",dim.Name="科室",dim.LinkedMetaDim=ml,dim.Description="科室维度，对应HIS的ct_loc表",dim.Creator="lhh",dim.CreatedDate=+$p($h,",",1)
	s dim.RowKeyFields="LocId"
	s status= dim.%Save()
	w:status'=$$$OK status,!
	
	s base=dim
	s dpmp=##class(TypeConfig).GetByPath("DIM:DPMP")
	s bsed=##class(TypeConfig).GetByPath("DIM:BSED")
	
	s obj=dim.GetProperty("LocId")
	s:obj="" obj=##class(DimProperty).%New()
	s obj.DimBase=base,obj.Code="LocId",obj.Name="科室ID",obj.Description="科室RowID"
	s obj.CreatedType=dpmp,obj.Expression="CTLOC_RowID", obj.IsLinked="N"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	s obj=dim.GetProperty("LocCode")
	s:obj="" obj=##class(DimProperty).%New()
	s obj.DimBase=base,obj.Code="LocCode",obj.Name="科室代码（名称）",obj.Description="科室名称汉语拼音首字母编码" ;,obj.DataType=##class(DataType).GetByPath("string")
	s obj.CreatedType=dpmp,obj.Expression="CTLOC_Code", obj.IsLinked="N"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	s obj=dim.GetProperty("LocDesc")
	s:obj="" obj=##class(DimProperty).%New()
	s obj.DimBase=base,obj.Code="LocDesc",obj.Name="科室描述",obj.Description="科室描述" ;,obj.DataType=##class(DataType).GetByPath("string")
	s obj.CreatedType=dpmp,obj.Expression="CTLOC_Desc", obj.IsLinked="N"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	s obj=dim.GetProperty("LocContact")
	s:obj="" obj=##class(DimProperty).%New()
	s obj.DimBase=base,obj.Code="LocContact",obj.Name="科室拼音检索码",obj.Description="科室拼音的首字母码，用于检索使用" ;,obj.DataType=##class(DataType).GetByPath("string")
	s obj.CreatedType=dpmp,obj.Expression="CTLOC_ContactName", obj.IsLinked="N"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	s obj=dim.GetProperty("LocFloor")
	s:obj="" obj=##class(DimProperty).%New()
	s obj.DimBase=base,obj.Code="LocFloor",obj.Name="科室楼层",obj.Description="科室楼层" ;,obj.DataType=##class(DataType).GetByPath("string")
	s obj.CreatedType=dpmp,obj.Expression="CTLOC_Floor", obj.IsLinked="N"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s ds=##class(DataSourceConfig).GetByPath(dataSouceConfigPath)
	s ns=##class(Namespace).MetaNamespace("/")
	s type=##class(TypeConfig).GetByPath("META:LOOKUP")
	s obj=##class(MetaTableBase).GetByPath("/CTPCP.ml")
	if obj=""{
		s obj=##class(MetaTableBase).%New()
	}
	s obj.Type=type,obj.Namespace=ns,obj.Code="CTPCP"
	s obj.Name="医生维表",obj.Description="医生维表"
	s obj.DSConfig=ds,obj.Creator="lhh",obj.CreatedDate=+$h
	s status= obj.%Save()
	w:status'=$$$OK status,!
	s master="MetaTableBase-MDS-"_obj.%Id()
	s status=##class(DHCWL.DM.T.KeyValueConfig).Put(master,"table","CT_CareProv")
	w:status'=$$$OK status,!
	s status=##class(DHCWL.DM.T.KeyValueConfig).Put(master,"schema","SQLUSER")
	w:status'=$$$OK status,!
	s status=##class(DHCWL.DM.I.Manage).MetaInfoBuild("/CTPCP.ml")
	
	s ml=##class(MetaTableBase).GetByPath("/CTPCP.ml")
	s ns=##class(Namespace).GetByPath("DI:/")
	s dim=##class(DimBase).GetByPath("/CTPCP.d")
	if dim=""{
		s dim=##class(DimBase).%New()
	}
	s dim.Namespace=ns,dim.Code="CTPCP",dim.Name="医生",dim.LinkedMetaDim=ml,dim.Description="维度维度，对应HIS的CT_CareProv表",dim.Creator="lhh",dim.CreatedDate=+$p($h,",",1)
	s dim.RowKeyFields="DocId"
	s status= dim.%Save()
	w:status'=$$$OK status,!
	
	s base=dim
	s dpmp=##class(TypeConfig).GetByPath("DIM:DPMP")
	s bsed=##class(TypeConfig).GetByPath("DIM:BSED")
	
	s obj=dim.GetProperty("DocId")
	s:obj="" obj=##class(DimProperty).%New()
	s obj.DimBase=base,obj.Code="DocId",obj.Name="医生ID",obj.Description="医生RowID"
	s obj.CreatedType=dpmp,obj.Expression="CTPCP_RowId", obj.IsLinked="N"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	s obj=dim.GetProperty("DocCode")
	s:obj="" obj=##class(DimProperty).%New()
	s obj.DimBase=base,obj.Code="DocCode",obj.Name="医生工号",obj.Description="医生工号"
	s obj.CreatedType=dpmp,obj.Expression="CTPCP_Code", obj.IsLinked="N"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	s obj=dim.GetProperty("DocName")
	s:obj="" obj=##class(DimProperty).%New()
	s obj.DimBase=base,obj.Code="DocName",obj.Name="医生姓名",obj.Description="医生姓名"
	s obj.CreatedType=dpmp,obj.Expression="CTPCP_Desc", obj.IsLinked="N"
	s status= obj.%Save()
	w:status'=$$$OK status,!
}

}
