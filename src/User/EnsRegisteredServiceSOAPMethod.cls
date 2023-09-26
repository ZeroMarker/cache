/// 已注册方法
Class User.EnsRegisteredServiceSOAPMethod Extends %Persistent [ SqlTableName = Ens_RegisteredServiceSOAPMethod ]
{

/// DDL Primary Key Specification
Index PKMethodCode On (ServiceCode, MethodCode) [ PrimaryKey, SqlName = PK_MethodCode, Type = index, Unique ];

Index MethodName On (ServiceCode, MethodDesc);

/// Foreign Key FKServRefMeth created via DDL
ForeignKey FKServRefMeth(ServiceCode) References User.EnsRegisteredService(PKServiceCode) [ OnDelete = cascade, OnUpdate = cascade, SqlName = FK_Serv_Ref_Meth ];

/// 服务代码
Property ServiceCode As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 2 ];

/// 方法代码
Property MethodCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ Required, SqlColumnNumber = 3 ];

/// 方法名称
Property MethodDesc As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 4 ];

/// 方法描述
Property MethodNote As %Library.String(MAXLEN = 200) [ SqlColumnNumber = 5 ];

/// 方法状态
Property MethodStatus As %Library.String(MAXLEN = 20) [ SqlColumnNumber = 6 ];

/// 返回值类型
Property ReturnVal As %Library.String(MAXLEN = 200) [ SqlColumnNumber = 7 ];

/// 服务地址(WSDL)
Property ServiceAddress As %Library.String(MAXLEN = 200) [ SqlColumnNumber = 8 ];

/// 服务地址IP
Property ServiceHost As %Library.String(MAXLEN = 100) [ SqlColumnNumber = 9 ];

/// 服务地址端口
Property ServicePort As %Library.String(MAXLEN = 100) [ SqlColumnNumber = 10 ];

/// 更新日期
Property UpdateDate As %Library.Date [ InitialExpression = {$P($H,",")}, SqlColumnNumber = 11 ];

/// 更新时间
Property UpdateTime As %Library.Time [ InitialExpression = {$P($H,",",2)}, SqlColumnNumber = 12 ];

/// 服务所在类
Property ServiceClass As %Library.String(MAXLEN = 100) [ SqlColumnNumber = 13 ];

/// BO所在类(BO)
Property BoClassPath As %Library.String(MAXLEN = 200) [ SqlColumnNumber = 14 ];

/// 服务地址(实际调用地址)
Property ServiceLocation As %Library.String(MAXLEN = 200) [ SqlColumnNumber = 15 ];

/// 用户名
Property ServiceUserName As %Library.String(MAXLEN = 100) [ SqlColumnNumber = 16 ];

/// 密码
Property ServicePassWord As %Library.String(MAXLEN = 100) [ SqlColumnNumber = 17 ];

/// SSL配置
Property SslCongfig As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 18 ];

/// 总线代码
Property BusCode As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 19 ];

Storage Default
{
<CounterLocation>^Busi.ENS.RegisteredServiceSMetC</CounterLocation>
<Data name="RegisteredServiceSOAPMethodDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ServiceCode</Value>
</Value>
<Value name="3">
<Value>MethodCode</Value>
</Value>
<Value name="4">
<Value>MethodDesc</Value>
</Value>
<Value name="5">
<Value>MethodNote</Value>
</Value>
<Value name="6">
<Value>MethodStatus</Value>
</Value>
<Value name="7">
<Value>ReturnVal</Value>
</Value>
<Value name="8">
<Value>ServiceAddress</Value>
</Value>
<Value name="9">
<Value>UpdateDate</Value>
</Value>
<Value name="10">
<Value>UpdateTime</Value>
</Value>
<Value name="11">
<Value>ServiceHost</Value>
</Value>
<Value name="12">
<Value>ServicePort</Value>
</Value>
<Value name="13">
<Value>ServiceClass</Value>
</Value>
<Value name="14">
<Value>BoClassPath</Value>
</Value>
<Value name="15">
<Value>ServiceLocation</Value>
</Value>
<Value name="16">
<Value>ServiceUserName</Value>
</Value>
<Value name="17">
<Value>ServicePassWord</Value>
</Value>
<Value name="18">
<Value>SslCongfig</Value>
</Value>
<Value name="19">
<Value>BusCode</Value>
</Value>
</Data>
<DataLocation>^Busi.ENS.RegisteredServiceSMetD</DataLocation>
<DefaultData>RegisteredServiceSOAPMethodDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^Busi.ENS.RegisteredServiceSMetD</IdLocation>
<IndexLocation>^Busi.ENS.RegisteredServiceSMetI</IndexLocation>
<StreamLocation>^Busi.ENS.RegisteredServiceSMetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
