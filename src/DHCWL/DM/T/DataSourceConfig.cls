Class DHCWL.DM.T.DataSourceConfig Extends %Persistent
{

// Attached="DS"

Property Type As TypeConfig [ Required ];

// 只能由字母,数字或者下划线组成

Property Code As %String [ Required ];

Property Name As %String;

Property Description As %String;

Property IsActived As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",Y,N");

Property ConnectedStatus As %String;

// Property URL As %String;

// Property UserName As %String;

// Property Password As %String;

Property UsageStatus As %String(DISPLAYLIST = ",Active,Deprecated,", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",A,D");

Index MainI On (Type, Code) [ PrimaryKey ];

Trigger KVDeleteTri [ Event = DELETE, Time = AFTER ]
{
	n id
	s id={%%ID}
	n master
	i id'="" d
	.s master="DataSourceConfig-"_id
	.&sql(delete DHCWL_DM_T.KeyValueConfig where Master=:master)
}

ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ Private, ServerOnly = 1 ]
{
    s obj=##class(MetaTableBase).%Open(oid)
    s id=obj.%Id()
    i id'="" d
    .s master="DataSourceConfig-"_id
	.&sql(delete DHCWL_DM_T.KeyValueConfig where Master=:master)
    q $$$OK
}

// d ##class(DHCWL.DM.T.DataSourceConfig).TestData()

ClassMethod TestData()
{
	&sql(delete DHCWL_DM_T.DataSourceConfig)
	k ^DHCWL.DM.T.DataSourceConfigD,^DHCWL.DM.T.DataSourceConfigI
	q
	s type=##class(TypeConfig).GetByPath("DATASOURCE:JDBC")
	s obj=##class(DataSourceConfig).%New()
	s obj.Type=type
	s obj.Code="DHCAPP_LOCAL"
	s obj.Name="Caché本地DHC-APP连接配置"
	s obj.Description="连接本地Caché数据库的DHC-APP命名空间"
	s obj.IsActived="N"
	;s obj.URL="jdbc:Cache://127.0.0.1:1972/dhc-app"
	;s obj.UserName="_SYSTEM"
	;s obj.Password="SYS"
	d obj.%Save()
	s id=obj.%Id()
	q:id=""
	w id,","
	w !,"KVRowId:"
	s master="DataSourceConfig-"_id
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'url','jdbc:Cache://127.0.0.1:1972/dhc-app'))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'user','_SYSTEM'))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'password','SYS'))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'driver','com.intersys.jdbc.CacheDriver'))
	w %ROWID,!
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'schema','sqluser'))
	w %ROWID,!
	
	s type=##class(TypeConfig).GetByPath("DATASOURCE:CSV")
	s obj=##class(DataSourceConfig).%New()
	s obj.Type=type
	s obj.Code="TEST"
	s obj.Name="CSV数据源测试"
	s obj.Description="CSV数据源测试-sales目录"
	s obj.IsActived="N"
	;s obj.URL="jdbc:Cache://127.0.0.1:1972/dhc-app"
	;s obj.UserName="_SYSTEM"
	;s obj.Password="SYS"
	d obj.%Save()
	s id=obj.%Id()
	q:id=""
	w id,","
	w !,"KVRowId:"
	s master="DataSourceConfig-"_id
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'directory','file:///D:/study/intelj/workspace/dm/adapter/src/test/resources/sales/'))
	w %ROWID,","
	
	
	s type=##class(TypeConfig).GetByPath("DATASOURCE:JDBC")
	s obj=##class(DataSourceConfig).%New()
	s obj.Type=type
	s obj.Code="SQLSEVER66"
	s obj.Name="BI SQLServer66数据源"
	s obj.Description="SQLServer66数据源"
	s obj.IsActived="N"
	s obj.ConnectedStatus="DELETE"
	d obj.%Save()
	s id=obj.%Id()
	q:id=""
	w id,","
	w !,"KVRowId:"
	s master="DataSourceConfig-"_id
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'url','jdbc:sqlserver://172.19.19.66:1433;database=DWHouse20170727'))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'user','sa'))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'password','sa1A'))
	w %ROWID,","
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'driver','com.microsoft.sqlserver.jdbc.SQLServerDriver'))
	w %ROWID,!
	
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
	&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'queryTimeout','2400'))
	w %ROWID,!
}

// s list=##class(DHCWL.DM.T.DataSourceConfig).GetByType("JDBC")

ClassMethod GetByType(type = "", status = "", usageStatus As %String = "A") As %ListOfObjects
{
	s list=##class(%ListOfObjects).%New()
	i type'="" d
	.s typeId=##class(TypeConfig).GetIdByPath("DATASOURCE:"_type)
	.q:typeId=""
	.s code="" f  s code=$o(^DHCWL.DM.T.DataSourceConfigI("MainI",typeId,code)) q:code=""  d
	..s id=$o(^DHCWL.DM.T.DataSourceConfigI("MainI",typeId,code,""))
	..s obj= ##class(DataSourceConfig).%OpenId(id)
	..q:obj=""
	..q:((obj.UsageStatus'="")&&(obj.UsageStatus'=usageStatus))
	..q:(status'="")&&(obj.ConnectedStatus=status)
	..d list.Insert(obj)
	e  d
	.s typeId="" f  s typeId=$o(^DHCWL.DM.T.DataSourceConfigI("MainI",typeId)) q:typeId=""  d
	..s code="" f  s code=$o(^DHCWL.DM.T.DataSourceConfigI("MainI",typeId,code)) q:code=""  d
	...s id=$o(^DHCWL.DM.T.DataSourceConfigI("MainI",typeId,code,""))
	...s obj= ##class(DataSourceConfig).%OpenId(id)
	...q:obj=""
	..q:(status'="")&&(obj.ConnectedStatus'=status)
	...d list.Insert(obj)
	q list
}

ClassMethod GetIdByPath(path)
{
	s tc=$zcvt($p(path,":",1),"U")
	s typeId=##class(TypeConfig).GetIdByPath("DATASOURCE:"_tc)
	s code=" "_$zcvt($p(path,":",2),"U")
	q:(('$d(^DHCWL.DM.T.DataSourceConfigI("MainI",typeId)))||('$d(^DHCWL.DM.T.DataSourceConfigI("MainI",typeId,code)))) ""
	q $o(^DHCWL.DM.T.DataSourceConfigI("MainI",typeId,code,""))
}

// s obj=##class(DHCWL.DM.T.DataSourceConfig).GetByPath("JDBC:DHC-APP-LOCAL")

ClassMethod GetByPath(path) As DataSourceConfig
{
	q ##class(DataSourceConfig).%OpenId(..GetIdByPath(path))
}

Method GetKVConfig() As %ListOfObjects
{
	q ##class(KeyValueConfig).GetList("DataSourceConfig-"_..%Id())
}

Method GetPath() As %String
{
	s tp=..Type.GetPath()
	s tp=$p(tp,":",2)
	q tp_":"_..Code
}

Storage Default
{
<Data name="DataSourceConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Type</Value>
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
<Value>IsActived</Value>
</Value>
<Value name="7">
<Value>ConnectedStatus</Value>
</Value>
<Value name="8">
<Value>UsageStatus</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DM.T.DataSourceConfigD</DataLocation>
<DefaultData>DataSourceConfigDefaultData</DefaultData>
<IdLocation>^DHCWL.DM.T.DataSourceConfigD</IdLocation>
<IndexLocation>^DHCWL.DM.T.DataSourceConfigI</IndexLocation>
<StreamLocation>^DHCWL.DM.T.DataSourceConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
