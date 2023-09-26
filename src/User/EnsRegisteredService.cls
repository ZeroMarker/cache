/// 已注册服务
Class User.EnsRegisteredService Extends %Persistent [ SqlTableName = Ens_RegisteredService ]
{

/// DDL Primary Key Specification
Index PKServiceCode On ServiceCode [ PrimaryKey, SqlName = PK_ServiceCode, Type = index, Unique ];

/// 服务代码
Property ServiceCode As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ InitialExpression = {..GenerateServiceCode()}, Required, SqlColumnNumber = 2 ];

/// 服务名称
Property ServiceDesc As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 3 ];

/// 服务描述
Property ServiceNote As %Library.String(MAXLEN = 200) [ SqlColumnNumber = 4 ];

/// 服务状态
Property ServiceStatus As %Library.String(MAXLEN = 20) [ SqlColumnNumber = 5 ];

/// 服务类型（SQL/SOAP/REST）
Property ServiceType As %Library.String(MAXLEN = 20) [ SqlColumnNumber = 6 ];

/// 服务提供方
Property ServiceProvider As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 7 ];

/// 方法存放路径
Property PackageSrc As %String(MAXLEN = 200) [ SqlColumnNumber = 8 ];

/// 更新日期
Property UpdateDate As %Library.Date [ InitialExpression = {$P($H,",")}, SqlColumnNumber = 9 ];

/// 更新时间
Property UpdateTime As %Library.Time [ InitialExpression = {$P($H,",",2)}, SqlColumnNumber = 10 ];

/// 服务分类
Property ServiceCategory As %String(MAXLEN = 10) [ SqlColumnNumber = 11 ];

/// 注册码
Property RegisterCode As %Library.String(COLLATION = "EXACT", MAXLEN = 200) [ SqlColumnNumber = 12, SqlFieldName = Register_Code ];

/// 鉴权标志
Property Signed As %Library.String(COLLATION = "EXACT", MAXLEN = 2) [ SqlColumnNumber = 13, SqlFieldName = Signed ];

/// ak
Property AccessKey As %Library.String(COLLATION = "EXACT", MAXLEN = 32) [ SqlColumnNumber = 14, SqlFieldName = Access_Key ];

/// sk
Property AccessSecret As %Library.String(COLLATION = "EXACT", MAXLEN = 64) [ SqlColumnNumber = 15, SqlFieldName = Access_Secret ];

/// apiName
Property ApiName As %Library.String(COLLATION = "EXACT", MAXLEN = 200) [ SqlColumnNumber = 16, SqlFieldName = Api_Name ];

/// Version
Property Version As %Library.String(COLLATION = "EXACT", MAXLEN = 200) [ SqlColumnNumber = 17, SqlFieldName = Version ];

/// 总线代码
Property BusCode As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 18, SqlFieldName = BusCode ];

ClassMethod GenerateServiceCode() As %String
{
	s servicecode=""
	s rowId=$i(^Busi.ENS.RegisteredServiceC)
	s len=$l(rowId)
	s servicecode=rowId
	f i=len:1:3 {
		set servicecode="0"_servicecode
	}
	q "REG"_servicecode
}

Storage Default
{
<Data name="RegisteredServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ServiceCode</Value>
</Value>
<Value name="3">
<Value>ServiceDesc</Value>
</Value>
<Value name="4">
<Value>ServiceNote</Value>
</Value>
<Value name="5">
<Value>ServiceStatus</Value>
</Value>
<Value name="6">
<Value>ServiceType</Value>
</Value>
<Value name="7">
<Value>ServiceProvider</Value>
</Value>
<Value name="8">
<Value>UpdateDate</Value>
</Value>
<Value name="9">
<Value>UpdateTime</Value>
</Value>
<Value name="10">
<Value>PackageSrc</Value>
</Value>
<Value name="11">
<Value>ServiceCategory</Value>
</Value>
<Value name="12">
<Value>RegisterCode</Value>
</Value>
<Value name="13">
<Value>Signed</Value>
</Value>
<Value name="14">
<Value>AccessKey</Value>
</Value>
<Value name="15">
<Value>AccessSecret</Value>
</Value>
<Value name="16">
<Value>ApiName</Value>
</Value>
<Value name="17">
<Value>Version</Value>
</Value>
<Value name="18">
<Value>BusCode</Value>
</Value>
</Data>
<DataLocation>^Busi.ENS.RegisteredServiceD</DataLocation>
<DefaultData>RegisteredServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^Busi.ENS.RegisteredServiceD</IdLocation>
<IndexLocation>^Busi.ENS.RegisteredServiceI</IndexLocation>
<StreamLocation>^Busi.ENS.RegisteredServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
