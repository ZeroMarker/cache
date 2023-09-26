Class DHCWL.DM.T.MetaTablePro Extends %Persistent
{

Property MetaTable As MetaTableBase [ Required ];

//只能由字母,数字或者下划线组成，且必须是字母开头

Property Code As %String [ Required ];

Property Name As %String;

Property Description As %String;

Property DataType As DataType;

Index MainI On (MetaTable, Code) [ PrimaryKey ];

// d ##class(DHCWL.DM.T.MetaTablePro).TestData()

ClassMethod TestData()
{
	&sql(delete DHCWL_DM_T.MetaTablePro)
	k ^DHCWL.DM.T.MetaTableProI,^DHCWL.DM.T.MetaTableProD
	q
	s base=##class(MetaTableBase).GetByPath("/CTLOC.ml")
	s str=##class(DataType).GetByPath("string")
	s baseId=base.%Id()
	s strId=str.%Id()
	&sql(insert into DHCWL_DM_T.MetaTablePro(MetaTable,Code,Name,Description,DataType) values(:baseId,'CTLOC_RowID','RowID','CT_LOC表格的主键',:strId))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.MetaTablePro(MetaTable,Code,Name,Description,DataType) values(:baseId,'CTLOC_Code','科室编码','科室名称',:strId))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.MetaTablePro(MetaTable,Code,Name,Description,DataType) values(:baseId,'CTLOC_Desc','科室描述','科室描述：简拼-名称',:strId))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.MetaTablePro(MetaTable,Code,Name,Description,DataType) values(:baseId,'CTLOC_ContactName','科室简拼','科室中文名字拼音头字母',:strId))
	w %ROWID,","
	
	s base=##class(MetaTableBase).GetByPath("/WorkLoad.mf")
	s str=##class(DataType).GetByPath("string")
	s baseId=base.%Id()
	s strId=str.%Id()
	s int=##class(DataType).GetByPath("int")
	s intId=int.%Id()
	s double=##class(DataType).GetByPath("double")
	s doubleId=double.%Id()
	&sql(insert into DHCWL_DM_T.MetaTablePro(MetaTable,Code,Name,Description,DataType) values(:baseId,'WorkLoad_Rowid','RowID','DHC_WorkLoad表格的主键',:strId))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.MetaTablePro(MetaTable,Code,Name,Description,DataType) values(:baseId,'WorkLoad_RecDep_DR','接收/执行科室','接收/执行科室维度',:strId))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.MetaTablePro(MetaTable,Code,Name,Description,DataType) values(:baseId,'WorkLoad_PatDep_DR','开单科室','开单科室维度',:strId))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.MetaTablePro(MetaTable,Code,Name,Description,DataType) values(:baseId,'WorkLoad_PatWard_DR','病区','病区维度',:strId))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.MetaTablePro(MetaTable,Code,Name,Description,DataType) values(:baseId,'WorkLoad_ResDep_DR','病人科室','病人科室维度',:strId))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.MetaTablePro(MetaTable,Code,Name,Description,DataType) values(:baseId,'WorkLoad_Type','就诊类型','O代表门诊，I代表住院',:strId))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.MetaTablePro(MetaTable,Code,Name,Description,DataType) values(:baseId,'WorkLoad_OrdDate','医嘱日期','医生下医嘱日期',:intId))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.MetaTablePro(MetaTable,Code,Name,Description,DataType) values(:baseId,'WorkLoad_UnitPrice','单价','单价',:doubleId))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.MetaTablePro(MetaTable,Code,Name,Description,DataType) values(:baseId,'WorkLoad_Quantity','数量','数量',:intId))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.MetaTablePro(MetaTable,Code,Name,Description,DataType) values(:baseId,'WorkLoad_TotalPrice','金额','金额=单价*数量',:doubleId))
	w %ROWID,","
}

ClassMethod GetMetaTablePros(parentId) As %ListOfObjects
{
	s list=##class(%ListOfObjects).%New()
	q:'$d(^DHCWL.DM.T.MetaTableProI("MainI",parentId)) list
	s code="" f  s code=$o(^DHCWL.DM.T.MetaTableProI("MainI",parentId,code)) q:code=""  d
	.s pid=$o(^DHCWL.DM.T.MetaTableProI("MainI",parentId,code,""))
	.s obj=##class(MetaTablePro).%OpenId(pid)
	.d list.Insert(obj)
	q list
}

ClassMethod GetProperty(parentId, code) As MetaTablePro
{
	s code=" "_$zcvt(code,"U")
	q:( ( '$d(^DHCWL.DM.T.MetaTableProI("MainI",parentId)) ) || ( '$d(^DHCWL.DM.T.MetaTableProI("MainI",parentId,code)) ) ) ""
	s id=$o(^DHCWL.DM.T.MetaTableProI("MainI",parentId,code,""))
	q ##class(MetaTablePro).%OpenId(id)
}

//d ##class(DHCWL.DM.T.MetaTablePro).Upsert("2","WORKLOAD_RECDEP_DR","4","INTEGER")

ClassMethod Upsert(metaTableId, code, dataType, typeName)
{
	;w $lts(row)
	;s code=$lg(row,1)
	;s dataType=$lg(row,2)
	;s typeName=$lg(row,3)
	s code2=" "_$zcvt(code,"U")
	s status=##class(DataType).Upasert(typeName,dataType)
	q:status'=$$$OK status
	s tid=##class(DataType).GetIdByPath(typeName)
	if tid=""{
	  s status=##class(DataType).Upasert("VARCHAR",12)
	  s tid=##class(DataType).GetIdByPath("VARCHAR")
	}
	
	if ( ($d(^DHCWL.DM.T.MetaTableProI("MainI",metaTableId))) && ($d(^DHCWL.DM.T.MetaTableProI("MainI",metaTableId,code2))) ) d
	.s id=$o(^DHCWL.DM.T.MetaTableProI("MainI",metaTableId,code2,""))
	.&sql(UPDATE DHCWL_DM_T.MetaTablePro SET DataType=:tid WHERE ID=:id)
	.s:SQLCODE'=0 status=$$$ERROR("SQLCODE:"_SQLCODE)
	e  d
	.&sql(INSERT INTO DHCWL_DM_T.MetaTablePro(MetaTable,Code,DataType)VALUES(:metaTableId,:code,:tid))
	.s:SQLCODE'=0 status=$$$ERROR("SQLCODE:"_SQLCODE)
	q
}

Storage Default
{
<Data name="MetaTableProDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MetaTable</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>Description</Value>
</Value>
<Value name="6">
<Value>DataType</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DM.T.MetaTableProD</DataLocation>
<DefaultData>MetaTableProDefaultData</DefaultData>
<IdLocation>^DHCWL.DM.T.MetaTableProD</IdLocation>
<IndexLocation>^DHCWL.DM.T.MetaTableProI</IndexLocation>
<StreamLocation>^DHCWL.DM.T.MetaTableProS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
