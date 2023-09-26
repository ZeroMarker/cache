/// 原型表所连接的数据源表格或者Query等的数据信息保存到KeyValueConfig表中。其Master组成：MetaTableBase-Tag-RowId.
/// 原型数据源连接的Tag为MDS。
/// 1、连接的数据库表格KeyName包括：Table,Class
/// 2、连接的Query KeyName包括：QueryClass,QueryName。Query的参数也保存到KeyValueConfig中，其Tag为QPA
Class DHCWL.DM.T.MetaTableBase Extends %Persistent
{

Property Type As TypeConfig [ Required ];

Property Namespace As Namespace [ Required ];

// 只能由字母,数字或者下划线组成，且必须是字母开头

Property Code As %String [ Required ];

Property Name As %String;

Property Description As %String;

Property DSConfig As DataSourceConfig [ Required ];

Property Creator As %String;

Property CreatedDate As %Date;

Property UpdateDate As %Date;

Property UsageStatus As %String(DISPLAYLIST = ",Active,Deprecated,", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",A,D");

Index MainI On (Type, Namespace, Code) [ PrimaryKey ];

Index DSCinfigI On DSConfig;

Trigger KVDeleteTri [ Event = DELETE, Time = AFTER ]
{
	n id
	s id={%%ID}
	n master
	i id'="" d
	.s master="MetaTableBase-MDS-"_id
	.&sql(delete DHCWL_DM_T.KeyValueConfig where Master=:master)
	.s master="MetaTableBase-QPA-"_id
    .&sql(delete DHCWL_DM_T.KeyValueConfig where Master=:master)
}

ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ Private, ServerOnly = 1 ]
{
    s obj=##class(MetaTableBase).%Open(oid)
    s id=obj.%Id()
    s master="MetaTableBase-MDS-"_id
    i id'="" d
    .&sql(delete DHCWL_DM_T.KeyValueConfig where Master=:master)
    .s master="MetaTableBase-QPA-"_id
    .&sql(delete DHCWL_DM_T.KeyValueConfig where Master=:master)
    q $$$OK
}

// d ##class(DHCWL.DM.T.MetaTableBase).TestData()

ClassMethod TestData()
{
	&sql(delete DHCWL_DM_T.MetaTableBase)
	k ^DHCWL.DM.T.MetaTableBaseI,^DHCWL.DM.T.MetaTableBaseD
	q
	s type=##class(TypeConfig).GetByPath("META:LOOKUP")
	s ns=##class(Namespace).MetaNamespace("/")
	s ds=##class(DataSourceConfig).GetByPath("JDBC:DHCAPP_LOCAL")
	s obj=##class(MetaTableBase).%New()
	s obj.Type=type
	s obj.Namespace=ns //##class(Namespace).MetaNamespace("/common")
	s obj.Code="CTLOC"
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
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'table','ct_loc'))
	w %ROWID,","
	;&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'catalog',''))
	;w %ROWID,","
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'schema','SQLUSER'))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'EnumeratorClass','com.dhcwl.dm.adapter.jdbc.JDBCEnumeratorTable'))
	w %ROWID,","
	
	s type=##class(TypeConfig).GetByPath("META:FACT")
	s ns=##class(Namespace).MetaNamespace("/")
	s ds=##class(DataSourceConfig).GetByPath("JDBC:DHCAPP_LOCAL")
	s obj=##class(MetaTableBase).%New()
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
	
	w "csv"
	s type=##class(TypeConfig).GetByPath("META:LOOKUP")
	s ns=##class(Namespace).MetaNamespace("/")
	s ds=##class(DataSourceConfig).GetByPath("CSV:TEST")
	s obj=##class(MetaTableBase).%New()
	s obj.Type=type
	s obj.Namespace=ns
	s obj.Code="DEPTS"
	s obj.Name="CSV科室"
	s obj.Description="CSV科室测试数据"
	s obj.DSConfig=ds
	s obj.Creator="lhh"
	s obj.CreatedDate=+$h
	;s obj.RowKeyFields="ID"
	d obj.%Save()
	w obj.%Id(),","
	s id=obj.%Id()
	q:id=""
	s master="MetaTableBase-MDS-"_obj.%Id()
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'fileName','DEPTS.csv'))
	w %ROWID,","
	
	s ds=##class(DataSourceConfig).GetByPath("JDBC:DHCAPP_LOCAL")
	s type=##class(TypeConfig).GetByPath("META:LOOKUP")
	s obj=##class(MetaTableBase).%New()
	s obj.Type=type
	s obj.Namespace=ns
	s obj.Code="CTHospital"
	s obj.Name="医院"
	s obj.Description="医院维表"
	s obj.DSConfig=ds
	s obj.Creator="lhh"
	s obj.CreatedDate=+$h
	d obj.%Save()
	w obj.%Id(),","
	s id=obj.%Id()
	q:id=""
	s master="MetaTableBase-MDS-"_obj.%Id()
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'table','CT_Hospital'))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'schema','SQLUSER'))
	w %ROWID,","
	
	s ds=##class(DataSourceConfig).GetByPath("JDBC:DHCAPP_LOCAL")
	s ns=##class(Namespace).MetaNamespace("/")
	s type=##class(TypeConfig).GetByPath("META:LOOKUP")
	s obj=##class(MetaTableBase).%New()
	s obj.Type=type
	s obj.Namespace=ns
	s obj.Code="Doctor"
	s obj.Name="医生"
	s obj.Description="医生维表"
	s obj.DSConfig=ds
	s obj.Creator="lhh"
	s obj.CreatedDate=+$h
	d obj.%Save()
	w obj.%Id(),","
	s id=obj.%Id()
	q:id=""
	s master="MetaTableBase-MDS-"_obj.%Id()
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'table','CT_CareProv'))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'schema','SQLUSER'))
	w %ROWID,","
	
	s ds=##class(DataSourceConfig).GetByPath("JDBC:DHCAPP_LOCAL")
	s ns=##class(Namespace).MetaNamespace("/")
	s type=##class(TypeConfig).GetByPath("META:LOOKUP")
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
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'table','DHC_TarItem'))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'schema','SQLUSER'))
	w %ROWID,","
	
	s ds=##class(DataSourceConfig).GetByPath("JDBC:DHCAPP_LOCAL")
	s ns=##class(Namespace).MetaNamespace("/")
	s type=##class(TypeConfig).GetByPath("META:LOOKUP")
	s obj=##class(MetaTableBase).%New()
	s obj.Type=type
	s obj.Namespace=ns
	s obj.Code="arcItmMast"
	s obj.Name="医嘱项"
	s obj.Description="医嘱项原型维表"
	s obj.DSConfig=ds
	s obj.Creator="lhh"
	s obj.CreatedDate=+$h
	d obj.%Save()
	w obj.%Id(),","
	s id=obj.%Id()
	q:id=""
	s master="MetaTableBase-MDS-"_obj.%Id()
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'table','ARC_ItmMast'))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'schema','SQLUSER'))
	w %ROWID,","
	
	s ds=##class(DataSourceConfig).GetByPath("JDBC:DHCAPP_LOCAL")
	s ns=##class(Namespace).MetaNamespace("/")
	s type=##class(TypeConfig).GetByPath("META:LOOKUP")
	s obj=##class(MetaTableBase).%New()
	s obj.Type=type
	s obj.Namespace=ns
	s obj.Code="paPatMas"
	s obj.Name="病人基本信息"
	s obj.Description="病人基本信息主表原型维表"
	s obj.DSConfig=ds
	s obj.Creator="lhh"
	s obj.CreatedDate=+$h
	d obj.%Save()
	w obj.%Id(),","
	s id=obj.%Id()
	q:id=""
	s master="MetaTableBase-MDS-"_obj.%Id()
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'table','PA_PatMas'))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'schema','SQLUSER'))
	w %ROWID,","
	/*
	s type=##class(TypeConfig).GetByPath("META:LOOKUP")
	s ns=##class(Namespace).MetaNamespace("/")
	s ds=##class(DataSourceConfig).GetByPath("JDBC:dw")
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
	/*
	s type=##class(TypeConfig).GetByPath("META:FACT")
	s ns=##class(Namespace).MetaNamespace("/")
	s ds=##class(DataSourceConfig).GetByPath("JDBC:SQLSEVER66")
	s obj=##class(MetaTableBase).%New()
	s obj.Type=type
	s obj.Namespace=ns
	s obj.Code="WorkLoadAlll"
	s obj.Name="收入"
	s obj.Description="WorkLoadAlll收入数据仓库"
	s obj.DSConfig=ds
	s obj.Creator="lhh"
	s obj.CreatedDate=+$h
	;s obj.RowKeyFields="WorkLoad_Rowid"
	d obj.%Save()
	w obj.%Id(),","
	s id=obj.%Id()
	q:id=""
	s master="MetaTableBase-MDS-"_obj.%Id()
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'table','T_DW_WorkLoadAll'))
	w %ROWID,","
	;&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'catalog',''))
	;w %ROWID,","
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'schema','HBI'))
	w %ROWID,","
	;&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'EnumeratorClass','com.dhcwl.dm.adapter.jdbc.JDBCEnumeratorTable'))
	;w %ROWID,","
	*/
}

// s list=##class(DHCWL.DM.T.MetaTableBase).GetAll()

ClassMethod GetAll(usageStatus As %String = "A") As %ListOfObjects
{
	s list=##class(%ListOfObjects).%New()
	s typeId="" f  s typeId=$o(^DHCWL.DM.T.MetaTableBaseI("MainI",typeId)) q:typeId=""  d
	.s nsId="" f  s nsId=$o(^DHCWL.DM.T.MetaTableBaseI("MainI",typeId,nsId)) q:nsId=""  d
	..s code="" f  s code=$o(^DHCWL.DM.T.MetaTableBaseI("MainI",typeId,nsId,code)) q:code=""  d
	...s id=$o(^DHCWL.DM.T.MetaTableBaseI("MainI",typeId,nsId,code,""))
	...q:'$d(^DHCWL.DM.T.MetaTableBaseD(id))
	...s obj=##class(MetaTableBase).%OpenId(id)
	...q:((obj.UsageStatus'="")&&(obj.UsageStatus'=usageStatus))
	...d list.Insert(obj)
	q list
}

ClassMethod GetMetaHelaper(typepath, nspath, name) [ Private ]
{
	s typeId=##class(TypeConfig).GetIdByPath(typepath)
	q:typeId="" ""
	s nsId=##class(Namespace).GetIdByPath(nspath)
	q:nsId="" ""
	s code=" "_$zcvt(name,"U")
	q:( ('$d(^DHCWL.DM.T.MetaTableBaseI("MainI",typeId))) || ('$d(^DHCWL.DM.T.MetaTableBaseI("MainI",typeId,nsId))) || ('$d(^DHCWL.DM.T.MetaTableBaseI("MainI",typeId,nsId,code))) ) ""
	q $o(^DHCWL.DM.T.MetaTableBaseI("MainI",typeId,nsId,code,""))
}

// w ##class(DHCWL.DM.T.MetaTableBase).GetIdByPath("/WorkLoad.mf")

ClassMethod GetIdByPath(path)
{
	d ##class(Util).ResolvePath(path,.nspath,.name,.type)
	i $zcvt(type,"U")="MF" q ..GetMetaHelaper("META:FACT","MT:"_nspath,name)
	i $zcvt(type,"U")="ML" q ..GetMetaHelaper("META:LOOKUP","MT:"_nspath,name)
	q ""
}

// s obj=##class(DHCWL.DM.T.MetaTableBase).GetByPath("/WorkLoad.mf")

ClassMethod GetByPath(path) As MetaTableBase
{
	q ##class(MetaTableBase).%OpenId(..GetIdByPath(path))
}

Method GetKVConfig() As %ListOfObjects
{
	s list=..DSConfig.GetKVConfig()
	k map
	f i=1:1:list.Count(){
		s map(list.GetAt(i).KeyName)=list.GetAt(i)
	}
	s list2= ##class(KeyValueConfig).GetList("MetaTableBase-MDS-"_..%Id())
	f i=1:1:list2.Count(){
		s map(list2.GetAt(i).KeyName)=list2.GetAt(i)
	}
	s retLis=##class(%ListOfObjects).%New()
	s key="" f{
		s key=$o(map(key))
		q:key=""
		d retLis.Insert(map(key))
	}
	q retLis
}

Method GetQueryParameters() As %ListOfObjects
{
	q ##class(KeyValueConfig).GetList("MetaTableBase-QPA-"_..%Id())
}

Method IsFact() As %Boolean
{
	q ..Type.GetPath()="META:FACT"
}

Method GetProperties() As %ListOfObjects
{
	q ##class(MetaTablePro).GetMetaTablePros(..%Id())
}

Method GetProperty(code) As MetaTablePro
{
	q ##class(MetaTablePro).GetProperty(..%Id(),code)
}

Method GetPath() As %String
{
	if $zcvt(..Type.Code,"U")="LOOKUP" {
		q ..Namespace.GetPath()_ ..Code_".ml"
	}else {
		q ..Namespace.GetPath()_ ..Code_".mf"
	}
}

Method GetSQLRef() As %String
{
	i ..Namespace.IsRoot() {
		q ..Code
	}else{
		s path=..Namespace.GetPath()
		s path=$e(path,2,$l(path)-1)
		s l=$l(path)
		s sn=""
		f i=1:1:l {
			i $e(path,i)="/" {
				s sn=sn_"_"
			}else{
				s sn=sn_$e(path,i)
			}
		}
		q sn_"_"_..Code
	}
}

Method GetDataSourceTable() As %String
{
	q ##class(KeyValueConfig).GetValue(" METATABLEBASE-MDS-"_..%Id()," TABLE")
}

Storage Default
{
<Data name="MetaTableBaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Type</Value>
</Value>
<Value name="3">
<Value>Namespace</Value>
</Value>
<Value name="4">
<Value>Code</Value>
</Value>
<Value name="5">
<Value>Name</Value>
</Value>
<Value name="6">
<Value>Description</Value>
</Value>
<Value name="7">
<Value>DSConfig</Value>
</Value>
<Value name="8">
<Value>RowIdFields</Value>
</Value>
<Value name="9">
<Value>Creator</Value>
</Value>
<Value name="10">
<Value>CreatedDate</Value>
</Value>
<Value name="11">
<Value>RowKeyFields</Value>
</Value>
<Value name="12">
<Value>UpdateDate</Value>
</Value>
<Value name="13">
<Value>UsageStatus</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DM.T.MetaTableBaseD</DataLocation>
<DefaultData>MetaTableBaseDefaultData</DefaultData>
<IdLocation>^DHCWL.DM.T.MetaTableBaseD</IdLocation>
<IndexLocation>^DHCWL.DM.T.MetaTableBaseI</IndexLocation>
<StreamLocation>^DHCWL.DM.T.MetaTableBaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
